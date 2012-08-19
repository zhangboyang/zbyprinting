function LoginButtons_Logout()
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
				MainPage_ChangeSection('sec1');
			else
				alert("内部错误，请刷新页面后重试。");
		}
	}
	xmlhttp.open("GET", "cgi/Logout.php?rand=" + Math.random(), true);
	xmlhttp.send();
}
function LoginButtons_PageReady()
{
	// Do Nothing
}
