var ShowStatus_orgHTML1, ShowStatus_orgHTML2, ShowStatus_orgHTML3;
var ShowStatus_isShowMyJobs, ShowStatus_isShowAllJobs, ShowStatus_isShowPrintersStatus;
var ShowStatus_My1Page, ShowStatus_My2Page, ShowStatus_AllPage;
function ShowStatus_getOriginalInnerHTML()
{
	ShowStatus_orgHTML1 = document.getElementById("table1").innerHTML;
	ShowStatus_orgHTML2 = document.getElementById("table2").innerHTML;
	ShowStatus_orgHTML3 = document.getElementById("table3").innerHTML;
	ShowStatus_orgHTML4 = document.getElementById("table4").innerHTML;
}
function ShowStatus_setLoading(id)
{
	switch(id)
	{
		case "table1":
			document.getElementById(id).innerHTML = ShowStatus_orgHTML1;
			break;
		case "table2":
			document.getElementById(id).innerHTML = ShowStatus_orgHTML2;
			break;
		case "table3":
			document.getElementById(id).innerHTML = ShowStatus_orgHTML3;
			break;
		case "table4":
			document.getElementById(id).innerHTML = ShowStatus_orgHTML4;
	}
	CommonLib_RefreshTableStyle();
}
function ShowStatus_SendXMLHttpResuest(id, url, page)
{
	var xmlhttp, tablefoot;
	tablefoot = "<div class=\"plaintextright\">第 "+page+" 页 <a href=\"javascript:ShowStatus_TurnPage('" + id + "', 2)\">第一页</a> <a href=\"javascript:ShowStatus_TurnPage('" + id + "', -1)\">上一页</a> <a href=\"javascript:ShowStatus_TurnPage('" + id + "', 1)\">下一页</a> <a href=\"javascript:ShowStatus_TurnPage('" + id + "', 0)\">刷新</a></div>";
	if(!window.ActiveXObject)
		xmlhttp = new XMLHttpRequest();
	else
		xmlhttp = new ActiveXObject("MSXML2.XMLHTTP");
	xmlhttp.onreadystatechange = function()
	{
		if(xmlhttp.readyState == 4)
		{
			if(xmlhttp.status == 200)
			{
				if(MainPage_ThisID == "sec1" && document.getElementById(id))
					document.getElementById(id).innerHTML = tablefoot + xmlhttp.responseText + tablefoot;
			}
			else
				document.getElementById(id).innerHTML = "<table width='940' cellspacing='1'><tr><td width='100%'>内部错误，请重新刷新页面。错误代码: XMLHTTP.readyState=" + xmlhttp.readyState + " XMLHTTP.status=" + xmlhttp.status + "</td></tr></table>";
		}
		CommonLib_RefreshTableStyle();
	}
	xmlhttp.open("GET", url, true);
	xmlhttp.send();
}
function ShowStatus_RefreshPrintersStatus(id)
{
	var xmlhttp;
	if(!window.ActiveXObject)
		xmlhttp = new XMLHttpRequest();
	else
		xmlhttp = new ActiveXObject("MSXML2.XMLHTTP");
	xmlhttp.onreadystatechange = function()
	{
		if(xmlhttp.readyState == 4)
		{
			if(xmlhttp.status == 200)
			{
				if(MainPage_ThisID == "sec1" && document.getElementById(id))
					document.getElementById(id).innerHTML = xmlhttp.responseText;
			}
			else
				document.getElementById(id).innerHTML = "<table width='940' cellspacing='1'><tr><td width='100%'>内部错误，请重新刷新页面。错误代码: XMLHTTP.readyState=" + xmlhttp.readyState + " XMLHTTP.status=" + xmlhttp.status + "</td></tr></table>";
		}
		CommonLib_RefreshTableStyle();
	}
	xmlhttp.open("GET", "cgi/GetPrintersStatus.php?rand=" + Math.random(), true);
	xmlhttp.send();
}
function ShowStatus_TurnPage(id, f)
{
	ShowStatus_setLoading(id);
	switch(id)
	{
		case "table1":
			ShowStatus_My1Page += f;
			if(ShowStatus_My1Page == 0 || f == 2)
				ShowStatus_My1Page = 1;
			ShowStatus_SendXMLHttpResuest("table1", "cgi/GetJobsStatus.php?type=m1&page=" + ShowStatus_My1Page + "&rand=" + Math.random(), ShowStatus_My1Page);
			break;
		case "table2":
			ShowStatus_My2Page += f;
			if(ShowStatus_My2Page == 0 || f == 2)
				ShowStatus_My2Page = 1;
			ShowStatus_SendXMLHttpResuest("table2", "cgi/GetJobsStatus.php?type=m2&page=" + ShowStatus_My2Page + "&rand=" + Math.random(), ShowStatus_My2Page);
			break;
		case "table3":
			ShowStatus_AllPage += f;
			if(ShowStatus_AllPage == 0 || f == 2)
				ShowStatus_AllPage = 1;
			ShowStatus_SendXMLHttpResuest("table3", "cgi/GetJobsStatus.php?type=all&page=" + ShowStatus_AllPage + "&rand=" + Math.random(), ShowStatus_AllPage);
	}
}
function ShowStatus_DoRefreshContents()
{
	if(ShowStatus_isShowMyJobs == 1)
	{
		ShowStatus_TurnPage("table1", 0);
		ShowStatus_TurnPage("table2", 0);
	}
	if(ShowStatus_isShowAllJobs == 1)
		ShowStatus_TurnPage("table3", 0);
	if(ShowStatus_isShowPrintersStatus == 1)
	{
		ShowStatus_setLoading("table4");
		ShowStatus_RefreshPrintersStatus("table4");
	}
	CommonLib_RefreshTableStyle();
}
function ShowStatus_ResetButtonStyle()
{
	document.getElementById("button1").style.backgroundColor = "";
	document.getElementById("button2").style.backgroundColor = "";
	document.getElementById("button3").style.backgroundColor = "";
}
function ShowStatus_ShowMyJobs()
{
	ShowStatus_isShowMyJobs = 1;
	ShowStatus_isShowAllJobs = 0;
	ShowStatus_isShowPrintersStatus = 0;
	ShowStatus_ResetButtonStyle();
	document.getElementById("button1").style.backgroundColor = "#92e4ff";
	document.getElementById("myjobs").style.display = 'block';
	document.getElementById("alljobs").style.display = 'none';
	document.getElementById("printers").style.display = 'none';
	ShowStatus_DoRefreshContents();
}
function ShowStatus_ShowAllJobs()
{
	ShowStatus_isShowMyJobs = 0;
	ShowStatus_isShowAllJobs = 1;
	ShowStatus_isShowPrintersStatus = 0;
	ShowStatus_ResetButtonStyle();
	document.getElementById("button2").style.backgroundColor = "#92e4ff";
	document.getElementById("myjobs").style.display = 'none';
	document.getElementById("alljobs").style.display = 'block';
	document.getElementById("printers").style.display = 'none';
	ShowStatus_DoRefreshContents();
}
function ShowStatus_ShowPrintersStatus()
{
	ShowStatus_isShowMyJobs = 0;
	ShowStatus_isShowAllJobs = 0;
	ShowStatus_isShowPrintersStatus = 1;
	ShowStatus_ResetButtonStyle();
	document.getElementById("button3").style.backgroundColor = "#92e4ff";
	document.getElementById("myjobs").style.display = 'none';
	document.getElementById("alljobs").style.display = 'none';
	document.getElementById("printers").style.display = 'block';
	ShowStatus_DoRefreshContents();
}
function ShowStatus_PageBack()
{
	if(ShowStatus_isShowMyJobs == 1)
		ShowStatus_ShowMyJobs();
	if(ShowStatus_isShowAllJobs == 1)
		ShowStatus_ShowAllJobs();
	if(ShowStatus_isShowPrintersStatus == 1)
		ShowStatus_ShowPrintersStatus();
}
function ShowStatus_PageReady()
{
	ShowStatus_isShowMyJobs = 0;
	ShowStatus_isShowAllJobs = 0;
	ShowStatus_isShowPrintersStatus = 0;
	ShowStatus_My1Page = 1;
	ShowStatus_My2Page = 1;
	ShowStatus_AllPage = 1;
	
	CommonLib_RefreshTableStyle();
	ShowStatus_getOriginalInnerHTML();
	ShowStatus_ShowMyJobs();
}
