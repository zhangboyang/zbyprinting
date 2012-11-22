function LoginButtons_Logout()
{
	$.get("cgi/Logout.php?rand=" + Math.random(),
		function (response, status, xhr)
		{
			MainPage_ChangeSection("sec1");
		}
	);
}
function LoginButtons_PageReady()
{
	// Do Nothing
}
