/*
 * "zbynotify.c"
 *
 *   zby notifier for the Common UNIX Printing System (CUPS).
 *
 *   Copyright 2012 by Zhang Boyang.
 *   Copyright 2007 by Apple Inc.
 *   Copyright 2003-2011 by Randal E. Bryant and David R. O'Hallaron.
 *   Copyright 1997-2005 by Easy Software Products.
 *
 *   These coded instructions, statements, and computer programs are the
 *   property of Apple Inc. and are protected by Federal copyright
 *   law.  Distribution and use rights are outlined in the file "LICENSE.txt"
 *   which should have been included with this file.  If this file is
 *   file is missing or damaged, see the license at "http://www.cups.org/".
 *
 * Contents:
 *
 *   main()               - Main entry for the notifier.
 *   process_event()      - Process a request.
 *   update_status()      - Update job or printer status.
 *   send_http_request()  - Send a HTTP request.
 *   open_clientfd()      - Open a TCP socket connection.
 */

/*
 * Include necessary headers...
 */

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* CUPS headers */
#include <cups/cups.h>
#include <cups/language.h>
//#include <cups/string.h>

/* Socket headers */
#include <sys/types.h>
#include <sys/socket.h>

/*
 * Define Constants
 */

/* Options */
/* Note: job id -> %s, status code -> %d */
#define ZBY_CHANGE_JOBSTAT_URL "http://example.com/zbyprinting/cgi/printer/UpdateJobStatus.php?pid=1&jid=%s&status=%d"
/* Note: status code -> %d */
#define ZBY_CHANGE_PRINTERSTAT_URL "http://example.com/zbyprinting/cgi/printer/UpdatePrinterStatus.php?id=1&status=%d"

/* Job Status Code */
#define ZBY_JOBSTAT_NEEDCONFIRM 1
#define ZBY_JOBSTAT_WAITING 2
#define ZBY_JOBSTAT_PRINTING 3
#define ZBY_JOBSTAT_CANCELED 4
#define ZBY_JOBSTAT_ANALYSING 5
#define ZBY_JOBSTAT_PAPERERR 6
#define ZBY_JOBSTAT_FINISHED 7
#define ZBY_JOBSTAT_FAILED 8

/* Printer Status Code */
#define ZBY_PRINTERSTAT_IDLE 1
#define ZBY_PRINTERSTAT_BUSY 2
#define ZBY_PRINTERSTAT_PAUSED 3
#define ZBY_PRINTERSTAT_NOTCONNECTED 4
#define ZBY_PRINTERSTAT_NOPAPER 5
#define ZBY_PRINTERSTAT_JAM 6

/* HTTP request head */
#define ZBY_HTTP_BUFFER_SIZE 4096
#define ZBY_HTTP_REQUEST_HEAD "GET %s HTTP/1.0\r\n\r\n"

/*
 * Local functions...
 */

void process_event(ipp_t *ipp);
int update_status(int type, char *name, int status, char *reason);
int send_http_request(char *url);
int open_clientfd(char *hostname, int port);

/*
 * 'main()' - Main entry for the notifier.
 */

int main(int argc, char *argv[])
{
	ipp_t *event;				/* Event from scheduler */
	ipp_state_t state;			/* IPP event state */
	
	setbuf(stderr, NULL);

	while (1)
	{
		event = ippNew();
		while ((state = ippReadFile(0, event)) != IPP_DATA)
			if (state <= IPP_IDLE)
				break;

		if (state == IPP_ERROR)
			fputs("ERROR: ippReadFile() returned IPP_ERROR! (main)\n", stderr);

		if (state <= IPP_IDLE)
		{
			ippDelete(event);
			return 0;
		}

		process_event(event);
		ippDelete(event);

		/*
		* If the recipient URI is "zby://nowait", then we exit after each
		* event...
		*/

		if (!strcmp(argv[1], "zby://nowait"))
			return 0;
	}
}


/*
 * 'process_event()' - Process a request.
 */

void process_event(ipp_t *ipp)
{
	ipp_tag_t group;			/* Current group */
	ipp_attribute_t *attr;		/* Current attribute */

	int type = 0;				/* Event type 0 = unknown, 1 = job, 2 = printer */	
	char *name = NULL;			/* Name of the printer or the job */
	int status;					/* Status code */
	char *reason = NULL;		/* Reason of changing state */
	
	int ret;					/* Return value */

	for (group = IPP_TAG_ZERO, attr = ipp->attrs; attr; attr = attr->next)
	{
		if ((attr->group_tag == IPP_TAG_ZERO) || !attr->name)
		{
			group = IPP_TAG_ZERO;
			continue;
		}

		if (group != attr->group_tag)
			group = attr->group_tag;

		switch (attr->value_tag)
		{
			case IPP_TAG_ENUM:
				if (!strcmp(attr->name, "job-state") || !strcmp(attr->name, "printer-state"))
					status = attr -> values -> integer;
				break;
			
			case IPP_TAG_NAME:
				if (!strcmp(attr->name, "job-name") || !strcmp(attr->name, "printer-name"))
					name = attr -> values -> string.text;
				break;

			case IPP_TAG_KEYWORD:
				if (!strcmp(attr->name, "notify-subscribed-event"))
				{
					if (!strcmp(attr->values->string.text, "job-state-changed") || !strcmp(attr->values->string.text, "job-completed"))
						type = 1;
					else if (!strcmp(attr->values->string.text, "printer-state-changed") || !strcmp(attr->values->string.text, "printer-stopped"))
						type = 2;
				}
				
				if (!strcmp(attr->name, "job-state-reasons") || !strcmp(attr->name, "printer-state-reasons"))
					reason = attr->values->string.text;
				break;
		}
	}

	if (type > 0)
	{
		if (!name)
		{
			fputs("ERROR: fetch name failed! (process_event)\n", stderr);
			return;
		}
		
		if (!reason)
		{
			fputs("ERROR: fetch reason failed! (process_event)\n", stderr);
			return;
		}
		
		ret = update_status(type, name, status, reason);
		if (ret)
			fprintf(stderr, "ERROR: update_status(%d, \"%s\", %d, \"%s\") failed, returned %d! (process_event)\n", type, name, status, reason, ret);
	}
}

/*
 * 'update_status()' - Update job or printer status.
 */

int update_status(int type, char *name, int status, char *reason)
{
	char *buffer;	/* Temp string */
	int ret;		/* Return value */
	
	switch (type)
	{
		case 1:
			/* Update job status */
			/* Alloc memory : status code length <= 11 */
			buffer = (char *) malloc(strlen(ZBY_CHANGE_JOBSTAT_URL) + strlen(name) + 8);
			if (!buffer)
			{
				fputs("ERROR: Not enough memory. (update_status)\n", stderr);
				return 1;
			}
			
			if (status == 5 && !strcmp(reason, "job-printing"))
				status = ZBY_JOBSTAT_PRINTING;
			else if (status == 9 && !strcmp(reason, "job-completed-successfully"))
				status = ZBY_JOBSTAT_FINISHED;
			else if (status == 7 && !strcmp(reason, "job-canceled-by-user"))
				status = ZBY_JOBSTAT_FAILED;
			else
				status += 100000;
			
			sprintf(buffer, ZBY_CHANGE_JOBSTAT_URL, name, status);
			break;
			
		case 2:
			/* Update printer status */
			/* Alloc memory : status code length <= 11 */
			buffer = (char *) malloc(strlen(ZBY_CHANGE_PRINTERSTAT_URL) + 10);
			if (!buffer)
			{
				fputs("ERROR: Not enough memory. (update_status)\n", stderr);
				return 1;
			}
			
			if (status == 3)
				status = ZBY_PRINTERSTAT_IDLE;
			else if (status == 4 && !strcmp(reason, "none"))
				status = ZBY_PRINTERSTAT_BUSY;
			else if (status == 4 && !strcmp(reason, "media-empty-error"))
				status = ZBY_PRINTERSTAT_NOPAPER;
			else if (status == 4 && !strcmp(reason, "media-jam-error"))
				status = ZBY_PRINTERSTAT_JAM;
			else if (status == 5)
				status = ZBY_PRINTERSTAT_PAUSED;
			else
				status += 100000;
			
			sprintf(buffer, ZBY_CHANGE_PRINTERSTAT_URL, status);
	}
	
	/* Send HTTP request */
	ret = send_http_request(buffer);
	
	/* Free memory */
	free(buffer);
	
	return ret;
}

/*
 * 'send_http_request()' - Send a HTTP request.
 */

int send_http_request(char *url)
{
	int clientfd;	/* File handle */
	char *path;		/* HTTP request path */
	char *p;		/* Temp var */
	char *host;		/* HTTP request hostname */
	int port;		/* HTTP request port */
	char *buf;		/* Buffer */
	int ret;		/* Return value */
	
	/*
	* Process URL for HTTP request
	*/
	
	if (strncmp(url, "http://", 7))
		return 2; /* Bad url */
	path = strchr(url + 7, '/');
	if (!path)
		return 2; /* Bad url */
	host = (char *) malloc(path - url - 6); /* Alloc memory */
	if (!host)
	{
		fputs("ERROR: Not enough memory. (send_http_request)\n", stderr);
		return 1;
	}
	strncpy(host, url + 7, path - url - 7);
	host[path - url - 7] = '\0';
	if(p = strchr(host, ':'))
	{
		port = atoi(p + 1);
		(*p) = '\0';
	}
	else
		port = 80;
	
	/*
	* Open Connection
	*/
	clientfd = open_clientfd(host, port);
	if (clientfd < 0)
	{
		fprintf(stderr, "ERROR: open_clientfd(\"%s\", %d) failed, returned %d!\n", host, port, clientfd);
		free(host); /* Free memory */
		return clientfd;
	}
	
	
	/*
	* Make HTTP request
	*/
	buf = (char *) malloc(strlen(ZBY_HTTP_REQUEST_HEAD) + strlen(path) + strlen(host) - 1);
	if(!buf)
	{
		fputs("ERROR: Not enough memory. (send_http_request)\n", stderr);
		free(host); /* Free memory */
		close(clientfd); /* Close connection */
		return 1;
	}
	sprintf(buf, ZBY_HTTP_REQUEST_HEAD, path);
	free(host); /* Free memory */

	
	/*
	* Send HTTP request
	*/
	ret = write(clientfd, buf, strlen(buf));
	if(ret < 0)
	{
		fprintf(stderr, "ERROR: write(...) failed, return %d!\n", ret);
		close(clientfd); /* Close connection */
		return ret;
	}
	free(buf); /* Free memory */
	
	/*
	* Read until EOF
	*/
	buf = (char *) malloc(ZBY_HTTP_BUFFER_SIZE);
	while(read(clientfd, buf, ZBY_HTTP_BUFFER_SIZE));
	fputs("\n", stderr);
	free(buf); /* Free memory */
	close(clientfd); /* Close connection */
	
	return 0;
}

/*
 * 'open_clientfd()' - open connection to server at <hostname, port> 
 *   and return a socket descriptor ready for reading and writing.
 *   Returns -1 and sets errno on Unix error. 
 *   Returns -2 and sets h_errno on DNS (gethostbyname) error.
 */

typedef struct sockaddr SA;

int open_clientfd(char *hostname, int port)
{
	int clientfd;
	struct hostent *hp;
	struct sockaddr_in serveraddr;

	if ((clientfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
		return -1; /* check errno for cause of error */

	/* Fill in the server's IP address and port */
	if ((hp = gethostbyname(hostname)) == NULL)
		return -2; /* check h_errno for cause of error */

	bzero((char *) &serveraddr, sizeof(serveraddr));
	serveraddr.sin_family = AF_INET;
	bcopy((char *) hp->h_addr_list[0], 
	      (char *) &serveraddr.sin_addr.s_addr, hp->h_length);
	serveraddr.sin_port = htons(port);

	/* Establish a connection with the server */
	if (connect(clientfd, (SA *) &serveraddr, sizeof(serveraddr)) < 0)
		return -1;

	return clientfd;
}

/*
 * End of "zbynotify.c".
 */
