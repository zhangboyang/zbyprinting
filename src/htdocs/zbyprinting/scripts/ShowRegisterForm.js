function ShowRegisterForm_Submit()
{
	$("#regsubmit").attr("disabled", true);
	$.post("cgi/Register.php",
		{
			username: $("#username").val(),
			password: $("#password").val(),
			password1: $("#password1").val(),
			LCpassword: $("#LCpassword").val(),
			realname: $("#realname").val()
		},
		function (data, textStatus, jqXHR)
		{
			$("#regsubmit").attr("disabled", false);
			if(data.indexOf("REGSUCCESS") >= 0)
			{
				MainPage_ChangeSection('usersec3');
				alert("注册成功！");
			}
			else if(data.indexOf("BADPASSWORD") >= 0)
				alert("密码不一致。");
			else if(data.indexOf("LCPASSWORD") >= 0)
				alert("龙创密码不正确。");
			else if(data.indexOf("USEDUSERNAME") >= 0)
				alert("该用户已注册。");
			else if(data.indexOf("BADUSERNAME") >= 0)
				alert("非法用户名。");
			else
				alert("内部错误，请刷新页面后重试。");
		}
	);
}
function ShowRegisterForm_PageReady()
{
	$("#button1").css("background-color", "#92e4ff");
	$("#username").focus();
	CommonLib_RefreshTableStyle();
}
