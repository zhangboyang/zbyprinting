var MainPage_orgHTML;
var MainPage_ThisID;
function CommonLib_RefreshTableStyle()
{
	$(".zbytable1 tr:nth-child(odd)").addClass("oddr1");
	$(".zbytable1 tr:nth-child(even)").addClass("evenr1");
	$(".zbytable2 tr:nth-child(odd)").addClass("oddr2");
	$(".zbytable2 tr:nth-child(even)").addClass("evenr2");
	$(".zbytable3 tr:nth-child(odd)").addClass("oddr3");
	$(".zbytable3 tr:nth-child(even)").addClass("evenr3");
	$(".zbytable4 tr:nth-child(odd)").addClass("oddr4");
	$(".zbytable4 tr:nth-child(even)").addClass("evenr4");
}
function MainPage_sendXMLHttpResuest(id, url, callback)
{
	var xmlhttp;
	if(!window.ActiveXObject)
		xmlhttp=new XMLHttpRequest();
	else
		xmlhttp=new ActiveXObject("MSXML2.XMLHTTP");
	xmlhttp.onreadystatechange = function()
    {
		if(xmlhttp.readyState == 4)
		{
			if(xmlhttp.status == 200)
			{
				if(document.getElementById(id))
				{
					document.getElementById(id).innerHTML = xmlhttp.responseText;
					callback();
				}
			}
			else
			{
				if(id == "pagecontents")
					document.getElementById(id).innerHTML = "<table class='infotable' width='940' cellspacing='1'><tr><td width='100%'>内部错误，请重新刷新页面。错误代码: XMLHTTP.readyState=" + xmlhttp.readyState + " XMLHTTP.status=" + xmlhttp.status + "</td></tr></table>";
				else
					document.getElementById(id).innerHTML = "<div id=\"loginsection\"><table class=\"usertable\"><tr><td>内部错误，请刷新页面。</td></table></div>";
			}
		}
	}
	xmlhttp.open("GET", url, true);
	xmlhttp.send();
}
function MainPage_ResetSectionButtons()
{
	document.getElementById("sec1").style.backgroundColor = "";
	document.getElementById("sec2").style.backgroundColor = "";
	document.getElementById("sec3").style.backgroundColor = "";
	document.getElementById("sec4").style.backgroundColor = "";
	if(document.getElementById("usersec2"))
		document.getElementById("usersec2").style.backgroundColor = "";
	if(document.getElementById("usersec3"))
		document.getElementById("usersec3").style.backgroundColor = "";
}
function MainPage_ChangeSection(id)
{
	if(id == "sec1_back")
		MainPage_ThisID = "sec1";
	else
		MainPage_ThisID = id;
	document.getElementById("pagecontents").innerHTML = MainPage_orgHTML;
	MainPage_ResetSectionButtons();
	MainPage_LoadUserInfo();
	switch(id)
	{
		case "sec1":
		case "sec2":
		case "sec3":
		case "sec4":
			document.getElementById(id).style.backgroundColor = "#b5ff66";
			break;
		case "usersec2":
		case "usersec3":
			document.getElementById(id).style.backgroundColor = "#92e4ff";
	}
	switch(id)
	{
		case "sec1":
			MainPage_sendXMLHttpResuest("pagecontents", "ShowStatus.html", ShowStatus_PageReady);
			break;
		case "sec1_back":
			MainPage_sendXMLHttpResuest("pagecontents", "ShowStatus.html", ShowStatus_PageBack);
			break;
		case "sec2":
			MainPage_sendXMLHttpResuest("pagecontents", "ShowUserInfo.html", ShowUserInfo_PageReady);
			break;
		case "sec3":
			MainPage_sendXMLHttpResuest("pagecontents", "ShowAnnouncements.html", ShowAnnouncements_PageReady);
			break;
		case "sec4":
			MainPage_sendXMLHttpResuest("pagecontents", "ShowHelp.html", ShowHelp_PageReady);
			break;
		case "usersec2":
			MainPage_sendXMLHttpResuest("pagecontents", "ShowRegisterForm.html", ShowRegisterForm_PageReady);
			break;
		case "usersec3":
			MainPage_sendXMLHttpResuest("pagecontents", "ShowLoginForm.html", ShowLoginForm_PageReady);
	}
}
function MainPage_LoadUserInfo()
{
	MainPage_sendXMLHttpResuest("usersection", "cgi/LoginButtons.php?rand=" + Math.random(), LoginButtons_PageReady);
}
function MainPage_LoadConfirmPage(id)
{
	document.getElementById("pagecontents").innerHTML = MainPage_orgHTML;
	MainPage_LoadUserInfo();
	JobConfirm_ID = id;
	MainPage_sendXMLHttpResuest("pagecontents", "cgi/JobConfirm.php?id=" + id, JobConfirm_PageReady);
}
function MainPage_GetOrgHTML()
{
	MainPage_orgHTML = document.getElementById("pagecontents").innerHTML;
}
function MainPage_PageReady()
{
	MainPage_GetOrgHTML();
	MainPage_LoadUserInfo();
	MainPage_ChangeSection("sec1");
}
