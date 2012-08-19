function ShowRegisterForm_Submit()
{
	var xmlhttp;
	document.getElementById("regsubmit").disabled = true;
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
				if(xmlhttp.responseText.indexOf("REGSUCCESS") >= 0)
				{
					MainPage_ChangeSection('usersec3');
					alert("注册成功！");
				}
				else if(xmlhttp.responseText.indexOf("BADPASSWORD") >= 0)
					alert("密码不一致。");
				else if(xmlhttp.responseText.indexOf("LCPASSWORD") >= 0)
					alert("龙创密码不正确。");
				else if(xmlhttp.responseText.indexOf("USEDUSERNAME") >= 0)
					alert("该用户已注册。");
				else if(xmlhttp.responseText.indexOf("BADUSERNAME") >= 0)
					alert("非法用户名。");
				else
					alert("内部错误，请刷新页面后重试。");
			}
			else
				alert("内部错误，请刷新页面后重试。");
			if(document.getElementById("regsubmit"))
				document.getElementById("regsubmit").disabled = false;
		}
	}
	xmlhttp.open("POST", "cgi/Register.php", true);
	xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	xmlhttp.send("username=" + document.getElementById("username").value + "&password=" + document.getElementById("password").value + "&password1=" + document.getElementById("password1").value + "&LCpassword=" + document.getElementById("LCpassword").value + "&name=" + document.getElementById("name").value);
}
function ShowRegisterForm_PageReady()
{
	document.getElementById("button1").style.backgroundColor = "#92e4ff";
	document.getElementById("username").focus();
	CommonLib_RefreshTableStyle();
}
