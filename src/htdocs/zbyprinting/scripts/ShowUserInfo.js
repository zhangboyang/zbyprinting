var ShowUserInfo_isShowPayment, ShowUserInfo_isShowInfo;
var ShowUserInfo_Page;
var ShowUserInfo_orgHTML1, ShowUserInfo_orgHTML2, ShowUserInfo_orgHTML3;
function ShowUserInfo_getOriginalInnerHTML()
{
	ShowUserInfo_orgHTML1 = document.getElementById("table1").innerHTML;
	ShowUserInfo_orgHTML2 = document.getElementById("table2").innerHTML;
	ShowUserInfo_orgHTML3 = document.getElementById("table3").innerHTML;
}
function ShowUserInfo_CheckSubmit(e)
{
	e = e || window.event;
	if(e && e.keyCode == 13)
		ShowUserInfo_Recharge();
}
function ShowUserInfo_Recharge()
{
	var xmlhttp;
	document.getElementById("rechargesubmit").disabled = true;
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
				if(xmlhttp.responseText.indexOf("RECHARGESUCCESS") >= 0)
				{
					alert("充值成功！");
					document.getElementById("rechargepassword").value = "";
					MainPage_ChangeSection("sec2");
				}
				else if(xmlhttp.responseText.indexOf("AUTHFAILED") >= 0)
					alert("充值密码输入错误。");
				else if(xmlhttp.responseText.indexOf("BADPASSWORD") >= 0)
					alert("充值密码格式不正确。");
				else if(xmlhttp.responseText.indexOf("NOTLOGGEDIN") >= 0)
					alert("您还没有登录。");
				else
					alert("内部错误，请刷新页面后重试。");
			}
			else
				alert("内部错误，请刷新页面后重试。");
			if(document.getElementById("rechargesubmit"))
				document.getElementById("rechargesubmit").disabled = false;
		}
	}
	xmlhttp.open("POST", "cgi/Recharge.php", true);
	xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	xmlhttp.send("recharge=" + document.getElementById("rechargepassword").value);
}
function ShowUserInfo_ChangePassword()
{
	var xmlhttp;
	document.getElementById("changepasswordsubmit").disabled = true;
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
				if(xmlhttp.responseText.indexOf("CHANGESUCCESS") >= 0)
				{
					alert("修改成功！");
					document.getElementById("oldpassword").value = "";
					document.getElementById("newpassword").value = "";
					document.getElementById("newpassword1").value = "";
				}
				else if(xmlhttp.responseText.indexOf("AUTHFAILED") >= 0)
					alert("密码错误。");
				else if(xmlhttp.responseText.indexOf("BADPASSWORD") >= 0)
					alert("密码不一致。");
				else if(xmlhttp.responseText.indexOf("NOTLOGGEDIN") >= 0)
					alert("您还没有登录。");
				else
					alert("内部错误，请刷新页面后重试。");
			}
			else
				alert("内部错误，请刷新页面后重试。");
			document.getElementById("changepasswordsubmit").disabled = false;
		}
	}
	xmlhttp.open("POST", "cgi/ChangePassword.php", true);
	xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	xmlhttp.send("oldpassword=" + document.getElementById("oldpassword").value + "&newpassword=" + document.getElementById("newpassword").value + "&newpassword1=" + document.getElementById("newpassword1").value);
}
function ShowUserInfo_SendXMLHttpResuest(id, url)
{
	var xmlhttp, tablefoot;
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
				if(MainPage_ThisID == "sec2" && document.getElementById(id))
					document.getElementById(id).innerHTML = xmlhttp.responseText;
			}
			else
				document.getElementById(id).innerHTML = "<table width='200' cellspacing='1'><tr><td width='100%'>内部错误，请重新刷新页面。</td></tr></table>";
		}
		CommonLib_RefreshTableStyle();
	}
	xmlhttp.open("GET", url, true);
	xmlhttp.send();
}
function ShowUserInfo_GetBillInfo(id, url, page)
{
	var xmlhttp, tablefoot;
	tablefoot = "<div class=\"plaintextright\">第 "+page+" 页 <a href=\"javascript:ShowUserInfo_TurnPage(2)\">第一页</a> <a href=\"javascript:ShowUserInfo_TurnPage(-1)\">上一页</a> <a href=\"javascript:ShowUserInfo_TurnPage(1)\">下一页</a> <a href=\"javascript:ShowUserInfo_TurnPage(0)\">刷新</a></div>";
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
				if(MainPage_ThisID == "sec2" && document.getElementById(id))
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
function ShowUserInfo_TurnPage(f)
{
	document.getElementById("table2").innerHTML = ShowUserInfo_orgHTML2;
	if(f == 2)
		ShowUserInfo_Page = 1;
	else
		ShowUserInfo_Page += f;
	ShowUserInfo_GetBillInfo("table2", "cgi/GetJobsStatus.php?type=bill&page=" + ShowUserInfo_Page + "&rand=" + Math.random(), ShowUserInfo_Page);
}
function ShowUserInfo_ResetButtonStyle()
{
	document.getElementById("button1").style.backgroundColor = "";
	document.getElementById("button2").style.backgroundColor = "";
}

function ShowUserInfo_DoRefreshContents()
{
	if(ShowUserInfo_isShowPayment == 1)
	{
		ShowUserInfo_SendXMLHttpResuest("table1", "cgi/GetPaymentInfo.php?rand=" + Math.random());
		ShowUserInfo_TurnPage(0);
	}
	if(ShowUserInfo_isShowInfo == 1)
		ShowUserInfo_SendXMLHttpResuest("table3", "cgi/GetUserInfo.php?rand=" + Math.random());
}
function ShowUserInfo_ShowPayment()
{
	ShowUserInfo_isShowPayment = 1;
	ShowUserInfo_isShowInfo = 0;
	ShowUserInfo_ResetButtonStyle();
	document.getElementById("button1").style.backgroundColor = "#92e4ff";
	document.getElementById("payment").style.display = 'block';
	document.getElementById("info").style.display = 'none';
	document.getElementById("table1").innerHTML = ShowUserInfo_orgHTML1;
	ShowUserInfo_DoRefreshContents();
}
function ShowUserInfo_ShowInfo()
{
	ShowUserInfo_isShowPayment = 0;
	ShowUserInfo_isShowInfo = 1;
	ShowUserInfo_ResetButtonStyle();
	document.getElementById("button2").style.backgroundColor = "#92e4ff";
	document.getElementById("payment").style.display = 'none';
	document.getElementById("info").style.display = 'block';
	document.getElementById("table3").innerHTML = ShowUserInfo_orgHTML3;
	ShowUserInfo_DoRefreshContents();
}
function ShowUserInfo_PageReady()
{
	ShowUserInfo_isShowPayment = 0;
	ShowUserInfo_isShowInfo = 0;
	ShowUserInfo_Page = 1;
	ShowUserInfo_getOriginalInnerHTML();
	ShowUserInfo_ShowPayment();
}
