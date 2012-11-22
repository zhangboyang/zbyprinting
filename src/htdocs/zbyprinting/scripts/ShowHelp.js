function ShowHelp_Toggle(id)
{
	$("#button1, #button2").css("background-color", "");
	$("#" + id).css("background-color", "#92e4ff");
	$("#usage, #about").hide();
	if (id == "button1")
		$("#usage").show();
	else if (id == "button2")
		$("#about").show();
	CommonLib_RefreshTableStyle();
}
function ShowHelp_PageReady()
{
	$("#button2").css("background-color", "");
	$("#button1").css("background-color", "#92e4ff");
	$("#about").hide();
	CommonLib_RefreshTableStyle();
}
