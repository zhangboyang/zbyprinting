function ShowLoginForm_Submit()
{
	var isRememberme;
	if ($("#rememberme").attr("checked"))
		isRememberme = "1";
	else
		isRememberme = "0";
	$("#submit").attr("disabled", true);
	$.post("cgi/LoginAuth.php",
		{
			username: $("#username").val(),
			password: $("#password").val(),
			rememberme: isRememberme
		},
		function (data, textStatus, jqXHR)
		{
			$("#submit").attr("disabled", false);
			if(data.indexOf("LOGINSUCCESS") >= 0)
				MainPage_ChangeSection('sec1');
			else if(data.indexOf("LOGINFAILED") >= 0)
				alert("密码错误。");
			else if(data.indexOf("NOSUCHUSER") >= 0)
				alert("没有这个用户。");
			else if(data.indexOf("BADUSERNAME") >= 0)
				alert("非法用户名。");
			else
				alert("内部错误，请刷新页面后重试。");
		}
	);
}
function ShowLoginForm_CheckSubmit(e)
{
	e = e || window.event;
	if(e && e.keyCode == 13)
		ShowLoginForm_Submit();
}
function ShowLoginForm_PageReady()
{
	$("#button1").css("background-color", "#92e4ff");
	$("#username").focus();
	CommonLib_RefreshTableStyle();
}
