function ShowLoginForm_Submit()
{
	var xmlhttp, rememberme;
	if(document.getElementById("rememberme").checked)
		rememberme = "1";
	else
		rememberme = "0";
	document.getElementById("submit").disabled = true;
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
				if(xmlhttp.responseText.indexOf("LOGINSUCCESS") >= 0)
					MainPage_ChangeSection('sec1');
				else if(xmlhttp.responseText.indexOf("LOGINFAILED") >= 0)
					alert("密码错误。");
				else if(xmlhttp.responseText.indexOf("NOSUCHUSER") >= 0)
					alert("没有这个用户。");
				else if(xmlhttp.responseText.indexOf("BADUSERNAME") >= 0)
					alert("非法用户名。");
				else
					alert("内部错误，请刷新页面后重试。");
			}
			else
				alert("内部错误，请刷新页面后重试。");
			if(document.getElementById("submit"))
				document.getElementById("submit").disabled = false;
		}
	}
	xmlhttp.open("POST", "cgi/LoginAuth.php", true);
	xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	xmlhttp.send("username=" + document.getElementById("username").value + "&password=" + document.getElementById("password").value + "&rememberme=" + rememberme);
}
function ShowLoginForm_CheckSubmit(e)
{
	e = e || window.event;
	if(e && e.keyCode == 13)
		ShowLoginForm_Submit();
}
function ShowLoginForm_PageReady()
{
	document.getElementById("button1").style.backgroundColor = "#92e4ff";
	document.getElementById("username").focus();
	CommonLib_RefreshTableStyle();
}
