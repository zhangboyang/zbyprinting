<?php include "../CommonLib.php"; ?>
<?php
/*	Args:
		id		printer id
		stat	status code
*/

	$id = $_GET['id'];
	$status = $_GET['status'];
	
	if(!preg_match("/^\d+$/", $id) || !preg_match("/^\d+$/", $status))
		die("BADARGS");
	
	$result = mysql_query("SELECT ip FROM printers WHERE id = " . $id);
	if(mysql_num_rows($result) == 0)
		die("BADARGS");
	
	$row = mysql_fetch_array($result);
	if(GetIPInteger($_SERVER['REMOTE_ADDR']) != $row['ip'])
		die("BADARGS");

	UpdatePrinterStatus($id, $status);
	
	echo "SUCCESS";
?>
