<?php include "CommonLib.php"; ?>
<?php
	$uid = GetUserID();
	if($uid == 0)
		die("NOTLOGGEDIN");
	if(!preg_match("/^\d{20}$/", $_POST['recharge']))
		die("BADPASSWORD");

	$result = mysql_query("SELECT value FROM rechargecards WHERE password = '" . $_POST['recharge'] . "'");
	if(mysql_num_rows($result) == 0)
		die("AUTHFAILED");
		
	$row = mysql_fetch_array($result);
	$newmoney = $row['value'] * 100;
	
	mysql_query("UPDATE wallets SET value = value + " . $newmoney . " WHERE id = " . $uid);
	mysql_query("DELETE FROM rechargecards WHERE password = '" . $_POST['recharge'] . "'");
	UpdateCounter("total-money-in", $newmoney);
	UpdateCounter("total-rechargecard-used", 1);
	
	echo "RECHARGESUCCESS";
?>
