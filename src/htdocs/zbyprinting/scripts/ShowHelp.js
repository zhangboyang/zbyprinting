var ShowHelp_isShowUsage, ShowHelp_isShowAbout;
function ShowHelp_ResetButtonStyle()
{
	document.getElementById("button1").style.backgroundColor = "";
	document.getElementById("button2").style.backgroundColor = "";
}
function ShowHelp_ShowUsage()
{
	ShowHelp_isShowUsage = 1;
	ShowHelp_isShowAbout = 0;
	ShowHelp_ResetButtonStyle();
	document.getElementById("button1").style.backgroundColor = "#92e4ff";
	document.getElementById("usage").style.display = 'block';
	document.getElementById("about").style.display = 'none';
}
function ShowHelp_ShowAbout()
{
	ShowHelp_isShowUsage = 0;
	ShowHelp_isShowAbout = 1;
	ShowHelp_ResetButtonStyle();
	document.getElementById("button2").style.backgroundColor = "#92e4ff";
	document.getElementById("usage").style.display = 'none';
	document.getElementById("about").style.display = 'block';
	CommonLib_RefreshTableStyle();
}
function ShowHelp_PageReady()
{
	ShowHelp_ShowUsage();
}
