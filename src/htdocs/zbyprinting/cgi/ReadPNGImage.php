<?php include "CommonLib.php"; ?>
<?php
	if(!preg_match("/^\d+$/", $_GET['job']) || !preg_match("/^\d+$/", $_GET['page']))
		die("Error");
	$result = mysql_query("SELECT realid, ip FROM jobs WHERE id = " . $_GET['job']);
	if(mysql_num_rows($result) == 0)
		die("Error");
	$row = mysql_fetch_array($result);
	if($row['ip'] != GetIPInteger($_SERVER['REMOTE_ADDR']))
		die("Error");

	$file_name = "/var/spool/cups-pdf/job_" . $row['realid'] . "_page" . $_GET['page'] . ".png";
	if(file_exists($file_name) && is_readable($file_name))
	{
		header("Content-Type: image/png");
		readfile($file_name);
	}
	else
		die("Error");
?>
