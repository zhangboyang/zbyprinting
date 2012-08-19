<?php include "CommonLib.php"; ?>
<?php
	$thisip = GetIPInteger($_SERVER['REMOTE_ADDR']);
	$uid = GetUserID();
	if($uid == 0)
		die("NOTLOGGEDIN");
	
	$id = $_GET['id'];
	$printer = $_GET['printer'];
	$duplex = $_GET['duplex'];
	$price = $_GET['price'];
	if(CheckMediumINT($id) || CheckMediumINT($printer) || CheckBoolean($duplex) || CheckMediumINT($price))
		die("BADARGS");

	$result = mysql_query("SELECT value FROM wallets WHERE id = " . $uid);
	$row = mysql_fetch_array($result);
	$money = $row['value'];
	
	$result = mysql_query("SELECT realid, pages FROM jobs WHERE id = " . $id . " AND status = 1 AND ip = " . $thisip);
	if(mysql_num_rows($result) == 0)
		die("TIMEOUT");
	$row = mysql_fetch_array($result);
	$realid = $row['realid'];
	$pages = $row['pages'];
	
	$result = mysql_query("SELECT command, status, singlesided, doublesided, duplex, paper FROM printers WHERE id = " . $printer);
	if(mysql_num_rows($result) == 0)
		die("BADARGS");
	$row = mysql_fetch_array($result);
	if($row['duplex'] == 0 && $duplex == 1)
		die("BADARGS");
	if($row['status'] != 1 && $row['status'] != 2)
		die("BADPRINTERSTAT");
	$orgcmd = $row['command'];
	
	if($duplex == 1)
	{
		$page_price = $row['doublesided'];
		$paper = $row['paper'] * ceil($pages / 2);
	}
	else
	{
		$page_price = $row['singlesided'];
		$paper = $row['paper'] * $pages;
	}
	
	$result = mysql_query("SELECT result FROM jobs_analysis WHERE jobid = " . $id);
	if(mysql_num_rows($result) == 0)
		die("BADARGS");
	$sum = 0;
	while($row = mysql_fetch_array($result))
		$sum += $row['result'];
	
	$sum = round(($sum * $page_price) / 500) + $paper;
	
	if($sum != $price)
		die("BADPRICE");
	
	if($sum > $money)
		die("NOTENOUGHMONEY");
	
	// %d(duplex) %d(jobid) %s(pdfname)
	$command = sprintf($orgcmd, $duplex, $id, "/var/spool/cups-pdf/job_" . $realid . ".pdf");
	
	passthru($command, $ret);
	if($ret != 0)
		die("BADPRINTER");

	mysql_query("UPDATE jobs SET userid = " . $uid . ", output = " . $printer . ", status = 2, duplex = " . $duplex . ", fee = " . $sum . " WHERE id = " . $id);
	mysql_query("UPDATE wallets SET value = value - " . $sum . " WHERE id = " . $uid);
	mysql_query("UPDATE printers SET totaljobs = totaljobs + 1 WHERE id = " . $printer);
	UpdateCounter("total-money-used", $sum);
	echo "SUCCESS";
?>
