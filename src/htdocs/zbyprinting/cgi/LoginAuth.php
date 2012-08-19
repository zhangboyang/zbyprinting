<?php include "CommonLib.php"; ?>
<?php
	global $LOGIN_LIMIT;
	CleanSessions();
	if(!preg_match("/^[g]?\d{2}2\d{4}$|^[c]?\d{2}1\d{4}$/", $_POST['username']))
		die("BADUSERNAME");
	preg_match("/\d{7}/", $_POST['username'], $matches);
	$uid = $matches[0];
	$result = mysql_query("SELECT password FROM users WHERE id = " . $uid);
	if(mysql_num_rows($result) == 0)
		die("NOSUCHUSER");
	$row = mysql_fetch_array($result);
	if($row['password'] != md5($_POST['password']))
		die("LOGINFAILED");
	$hash = GenerateRandomString();
	if($_POST['rememberme'] == 1)
	{
		$t1 = "1 year";
		$t2 = 365 * 24 * 3600;
	}
	else
	{
		$t1 = $LOGIN_LIMIT . " second";
		$t2 = $LOGIN_LIMIT;
	}
	mysql_query("INSERT INTO sessions VALUE ('" . $hash . "', " . $uid . ", DATE_ADD(NOW(), INTERVAL " . $t1 . "))");
	mysql_query("UPDATE users SET lastlogin = thislogin, lastloginip = thisloginip WHERE id = " . $uid);
	mysql_query("UPDATE users SET thislogin = now(), thisloginip = " . GetIPInteger($_SERVER['REMOTE_ADDR']) . " WHERE id = " . $uid);
	setcookie("userhash", $hash, time() + $t2);
	echo "LOGINSUCCESS";
?>
