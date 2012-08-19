<?php include "../CommonLib.php"; ?>
<?php
/*	Args:
		pid		printer id
		jid		job id
		stat	status code
*/

	$pid = $_GET['pid'];
	$jid = $_GET['jid'];
	$status = $_GET['status'];
	
	if(!preg_match("/^\d+$/", $pid) || !preg_match("/^\d+$/", $jid) || !preg_match("/^\d+$/", $status))
		die("BADARGS");
	
	$result = mysql_query("SELECT ip FROM printers WHERE id = " . $pid);
	if(mysql_num_rows($result) == 0)
		die("BADARGS");
	
	$row = mysql_fetch_array($result);
	if(GetIPInteger($_SERVER['REMOTE_ADDR']) != $row['ip'])
		die("BADARGS");

	UpdateJobStatus($jid, $status);
	
	echo "SUCCESS";
?>
