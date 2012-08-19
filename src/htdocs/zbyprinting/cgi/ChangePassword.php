<?php include "CommonLib.php"; ?>
<?php
	$uid = GetUserID();
	if($uid == 0)
		die("NOTLOGGEDIN");
	if($_POST['newpassword'] != $_POST['newpassword1'])
		die("BADPASSWORD");
	$result = mysql_query("SELECT password FROM users WHERE id = " . $uid);
	$row = mysql_fetch_array($result);
	if($row['password'] != md5($_POST['oldpassword']))
		die("AUTHFAILED");
	mysql_query("UPDATE users SET password = '" . md5($_POST['newpassword']) . "' WHERE id = " . $uid);
	echo "CHANGESUCCESS";
?>
