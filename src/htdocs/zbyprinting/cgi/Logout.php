<?php include "CommonLib.php"; ?>
<?php
	if(!preg_match("/^[0-9a-zA-Z]{20}$/", $_COOKIE['userhash']))
		die(0);
	$result = mysql_query("DELETE FROM sessions WHERE hash = '" . $_COOKIE['userhash'] . "'");
	setcookie("userhash", $_COOKIE['userhash'], time() - 3600);
?>
