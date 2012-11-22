<?php
function CheckLCPassword($username, $password, $type)
{
	$post = "ImgbtnLogin.x=62&ImgbtnLogin.y=15&TxtPassword=" . $password . "&TxtUserName=" . $username . "&__EVENTARGUMENT=&__EVENTTARGET=&__VIEWSTATE=/wEPDwUJLTkwODk2MDQ5ZBgBBR5fX0NvbnRyb2xzUmVxdWlyZVBvc3RCYWNrS2V5X18WAQULSW1nYnRuTG9naW4=";

	$request .= "POST /" . $type . "/Login.aspx HTTP/1.1\r\n";
	$request .= "Accept: */*\r\n";
	$request .= "Host: cms.pkuschool.edu.cn\r\n";
	$request .= "Content-Type: application/x-www-form-urlencoded\r\n";
	$request .= "Content-Length: " . strlen($post) . "\r\n";
	$request .= "Connection: close\r\n";
	$request .= "\r\n";
	$request .= $post;

	$fp = fsockopen("cms.pkuschool.edu.cn", 80);
	fputs($fp, $request);
	while(!feof($fp))
	{
		$result .= fgets($fp, 128);
	}
	fclose($fp);
	
	return strstr($result, "window.location.replace('/" . $type . "/Default1.aspx')") != false;
}
?>
