var ShowStatus_Showing;
var ShowStatus_My1Page, ShowStatus_My2Page, ShowStatus_AllPage;
function ShowStatus_GetOriginalInnerHTML()
{
	ShowStatus_orgHTML1 = $("#table1").html();
	ShowStatus_orgHTML2 = $("#table2").html();
	ShowStatus_orgHTML3 = $("#table3").html();
	ShowStatus_orgHTML4 = $("#table4").html();
}
function ShowStatus_SetLoading(id)
{
	switch(id)
	{
		case "table1":
			$("#table1").html(ShowStatus_orgHTML1);
			break;
		case "table2":
			$("#table2").html(ShowStatus_orgHTML2);
			break;
		case "table3":
			$("#table3").html(ShowStatus_orgHTML3);
			break;
		case "table4":
			$("#table4").html(ShowStatus_orgHTML4);
	}
	CommonLib_RefreshTableStyle();
}
function ShowStatus_SendXMLHttpResuest(id, url, page)
{
	var tablefoot = "<div class=\"plaintextright\">第 "+page+" 页 <a href=\"javascript:ShowStatus_TurnPage('" + id + "', 2)\">第一页</a> <a href=\"javascript:ShowStatus_TurnPage('" + id + "', -1)\">上一页</a> <a href=\"javascript:ShowStatus_TurnPage('" + id + "', 1)\">下一页</a> <a href=\"javascript:ShowStatus_TurnPage('" + id + "', 0)\">刷新</a></div>";
	$.get(url,
		function (response, status, xhr)
		{
			if (MainPage_ThisID == "sec1")
				$("#" + id).html(tablefoot + response + tablefoot);
			CommonLib_RefreshTableStyle();
		}
	);
}
function ShowStatus_TurnPage(id, f)
{
	ShowStatus_SetLoading(id);
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
function ShowStatus_ShowMyJobs()
{
	ShowStatus_Showing = 1;	

	$("#button1").css("background-color", "#92e4ff");
	$("#button2, #button3").css("background-color", "");
	$("#myjobs").show();
	$("#alljobs, #printers").hide();
	
	ShowStatus_TurnPage("table1", 0);
	ShowStatus_TurnPage("table2", 0);
	CommonLib_RefreshTableStyle();
}
function ShowStatus_ShowAllJobs()
{
	ShowStatus_Showing = 2;	

	$("#button2").css("background-color", "#92e4ff");
	$("#button1, #button3").css("background-color", "");
	$("#alljobs").show();
	$("#myjobs, #printers").hide();
	
	ShowStatus_TurnPage("table3", 0);
	CommonLib_RefreshTableStyle();
}
function ShowStatus_ShowPrintersStatus()
{
	ShowStatus_Showing = 3;
	
	$("#button3").css("background-color", "#92e4ff");
	$("#button1, #button2").css("background-color", "");
	$("#printers").show();
	$("#myjobs, #alljobs").hide();
	
	ShowStatus_SetLoading("table4");
	$("#table4").load("cgi/GetPrintersStatus.php?rand=" + Math.random(), CommonLib_RefreshTableStyle);
}
function ShowStatus_PageBackReady()
{
	if (ShowStatus_Showing == 1)
		ShowStatus_ShowMyJobs();
	if (ShowStatus_Showing == 2)
		ShowStatus_ShowAllJobs();
	if (ShowStatus_Showing == 3)
		ShowStatus_ShowPrintersStatus();
}
function ShowStatus_PageReady()
{
	ShowStatus_My1Page = 1;
	ShowStatus_My2Page = 1;
	ShowStatus_AllPage = 1;

	ShowStatus_GetOriginalInnerHTML();
	ShowStatus_ShowMyJobs();
}
