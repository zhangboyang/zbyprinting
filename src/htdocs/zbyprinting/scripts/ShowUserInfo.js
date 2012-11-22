var ShowUserInfo_Page;
var ShowUserInfo_orgHTML1, ShowUserInfo_orgHTML2, ShowUserInfo_orgHTML3;
function ShowUserInfo_getOriginalInnerHTML()
{
	ShowUserInfo_orgHTML1 = $("#table1").html();
	ShowUserInfo_orgHTML2 = $("#table2").html();
	ShowUserInfo_orgHTML3 = $("#table3").html();
}
function ShowUserInfo_CheckSubmit(e)
{
	e = e || window.event;
	if(e && e.keyCode == 13)
		ShowUserInfo_Recharge();
}
function ShowUserInfo_Recharge()
{
	$("#rechargesubmit").attr("disabled", true);
	$.post("cgi/Recharge.php",
		{
			recharge: $("#rechargepassword").val()
		},
		function (data, textStatus, jqXHR)
		{
			$("#rechargesubmit").attr("disabled", false);
			if (data.indexOf("RECHARGESUCCESS") >= 0)
			{
				alert("充值成功！");
				MainPage_ChangeSection("sec2");
			}
			else if (data.indexOf("AUTHFAILED") >= 0)
				alert("充值密码输入错误。");
			else if (data.indexOf("BADPASSWORD") >= 0)
				alert("充值密码格式不正确。");
			else if (data.indexOf("NOTLOGGEDIN") >= 0)
				alert("您还没有登录。");
			else
				alert("内部错误，请刷新页面后重试。");
		}
	);
}
function ShowUserInfo_ChangePassword()
{
	$("#changepasswordsubmit").attr("disabled", true);
	$.post("cgi/ChangePassword.php",
		{
			oldpassword: $("#oldpassword").val(),
			newpassword: $("#newpassword").val(),
			newpassword1: $("#newpassword1").val()
		},
		function (data, textStatus, jqXHR)
		{
			$("#changepasswordsubmit").attr("disabled", false);
			if(data.indexOf("CHANGESUCCESS") >= 0)
			{
				alert("修改成功！");
				$("#oldpassword").val("");
				$("#newpassword").val("");
				$("#newpassword1").val("");
			}
			else if(data.indexOf("AUTHFAILED") >= 0)
				alert("密码错误。");
			else if(data.indexOf("BADPASSWORD") >= 0)
				alert("密码不一致。");
			else if(data.indexOf("NOTLOGGEDIN") >= 0)
				alert("您还没有登录。");
			else
				alert("内部错误，请刷新页面后重试。");
		}
	);
}
function ShowUserInfo_GetBillInfo(id, url, page)
{
	var tablefoot = "<div class=\"plaintextright\">第 "+page+" 页 <a href=\"javascript:ShowUserInfo_TurnPage(2)\">第一页</a> <a href=\"javascript:ShowUserInfo_TurnPage(-1)\">上一页</a> <a href=\"javascript:ShowUserInfo_TurnPage(1)\">下一页</a> <a href=\"javascript:ShowUserInfo_TurnPage(0)\">刷新</a></div>";
	$.get(url,
		function (response, status, xhr)
		{
			if (MainPage_ThisID == "sec2")
				$("#" + id).html(tablefoot + response + tablefoot);
			CommonLib_RefreshTableStyle();
		}
	);
}
function ShowUserInfo_TurnPage(f)
{
	$("#table2").html(ShowUserInfo_orgHTML2);
	if (f == 2)
		ShowUserInfo_Page = 1;
	else
		ShowUserInfo_Page += f;
	ShowUserInfo_GetBillInfo("table2", "cgi/GetJobsStatus.php?type=bill&page=" + ShowUserInfo_Page + "&rand=" + Math.random(), ShowUserInfo_Page);
}
function ShowUserInfo_ShowPayment()
{
	$("#button2").css("background-color", "");
	$("#button1").css("background-color", "#92e4ff");
	$("#payment").show();
	$("#info").hide();
	$("#table1").html(ShowUserInfo_orgHTML1);
	$("#table1").load("cgi/GetPaymentInfo.php?rand=" + Math.random(), CommonLib_RefreshTableStyle);
	ShowUserInfo_TurnPage(0);
}
function ShowUserInfo_ShowInfo()
{
	$("#button1").css("background-color", "");
	$("#button2").css("background-color", "#92e4ff");
	$("#payment").hide();
	$("#info").show();
	$("#table3").html(ShowUserInfo_orgHTML3);
	$("#table3").load("cgi/GetUserInfo.php?rand=" + Math.random(), CommonLib_RefreshTableStyle);
}
function ShowUserInfo_PageReady()
{
	ShowUserInfo_Page = 1;
	ShowUserInfo_getOriginalInnerHTML();
	ShowUserInfo_ShowPayment();
}
