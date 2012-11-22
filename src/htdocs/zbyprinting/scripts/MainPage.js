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
	id = "#" + id;
	$(id).load(url,
		function(response, status, xhr)
		{
			if (status == "success")
				callback();
		});
}
function MainPage_ResetSectionButtons()
{
	$("#sec1, #sec2, #sec3, #sec4, #usersec2, #usersec3").css("background-color", "");
}
function MainPage_ChangeSection(id)
{
	if(id == "sec1_back")
		MainPage_ThisID = "sec1";
	else
		MainPage_ThisID = id;
	$("#pagecontents").html(MainPage_orgHTML);
	MainPage_ResetSectionButtons();
	MainPage_LoadUserInfo();
	switch(id)
	{
		case "sec1":
		case "sec2":
		case "sec3":
		case "sec4":
			$("#" + id).css("background-color", "#b5ff66");
			break;
		case "usersec2":
		case "usersec3":
			$("#" + id).css("background-color", "#92e4ff");
	}
	switch(id)
	{
		case "sec1":
			MainPage_sendXMLHttpResuest("pagecontents", "ShowStatus.html?rand=" + Math.random(), ShowStatus_PageReady);
			break;
		case "sec1_back":
			MainPage_sendXMLHttpResuest("pagecontents", "ShowStatus.html?rand=" + Math.random(), ShowStatus_PageBackReady);
			break;
		case "sec2":
			MainPage_sendXMLHttpResuest("pagecontents", "ShowUserInfo.html?rand=" + Math.random(), ShowUserInfo_PageReady);
			break;
		case "sec3":
			MainPage_sendXMLHttpResuest("pagecontents", "ShowAnnouncements.html?rand=" + Math.random(), ShowAnnouncements_PageReady);
			break;
		case "sec4":
			MainPage_sendXMLHttpResuest("pagecontents", "ShowHelp.html?rand=" + Math.random(), ShowHelp_PageReady);
			break;
		case "usersec2":
			MainPage_sendXMLHttpResuest("pagecontents", "ShowRegisterForm.html?rand=" + Math.random(), ShowRegisterForm_PageReady);
			break;
		case "usersec3":
			MainPage_sendXMLHttpResuest("pagecontents", "ShowLoginForm.html?rand=" + Math.random(), ShowLoginForm_PageReady);
	}
}
function MainPage_LoadUserInfo()
{
	MainPage_sendXMLHttpResuest("usersection", "cgi/LoginButtons.php?rand=" + Math.random(), LoginButtons_PageReady);
}
function MainPage_LoadConfirmPage(id)
{
	MainPage_LoadUserInfo();
	JobConfirm_ID = id;
	MainPage_sendXMLHttpResuest("pagecontents", "cgi/JobConfirm.php?id=" + id, JobConfirm_PageReady);
}
function MainPage_PageReady()
{
	$(document).ajaxError(
		function (event, xhr, options, exc)
		{
			alert("获取数据时发生错误，请刷新页面后重试。");
		}
	);
	MainPage_orgHTML = $("#pagecontents").html();
	MainPage_LoadUserInfo();
	MainPage_ChangeSection("sec1");
}
