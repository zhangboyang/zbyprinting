<?php include "CommonLib.php"; ?>
<?php include "CheckLCPassword.php"; ?>
<?php
	CleanSessions();
	
	if($_POST['password'] != $_POST['password1'])
		die("BADPASSWORD");
	if(!preg_match("/^[g]?\d{2}2\d{4}$|^[c]?\d{2}1\d{4}$/", $_POST['username']))
		die("BADUSERNAME");
	preg_match("/\d{7}/", $_POST['username'], $matches);
	$uid = $matches[0];
	
	if($uid / 10000 % 10 == 2)
		$type = "gz";
	if($uid / 10000 % 10 == 1)
		$type = "cz";
			
	if(!CheckLCPassword($uid, $_POST['LCpassword'], $type))
		die("BADLCPASSWORD");

	$result = mysql_query("SELECT * FROM users WHERE id = " . $uid);
	if(mysql_num_rows($result) != 0)
		die("USEDUSERNAME");
	$password = md5($_POST['password']);
	
	mysql_query("INSERT INTO users VALUE (" . $uid . ", '" . $password . "', '" . mysql_real_escape_string($_POST['realname']) . "', NULL, NULL, NULL, NULL, now())");
	mysql_query("INSERT INTO wallets VALUE (" . $uid . ", 0, NULL)");
	UpdateCounter("total-user-count", 1);
	echo "REGSUCCESS";
?>
