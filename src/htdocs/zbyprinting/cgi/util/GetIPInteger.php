<?php include "../CommonLib.php"; ?>
<?php
	if(preg_match("/((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)/", $_GET['ip']))
		echo GetIPInteger($_GET['ip']);
	else
		echo "usage : GetIPInteger.php?ip=IPADDRESS";
?>
