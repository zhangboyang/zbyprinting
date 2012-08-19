<?php include "../CommonLib.php"; ?>
<?php
	$uid = GetUserID();
	if($uid != $ADMIN_UID)
		die("You aren't the administrator!");
	$count = $_GET['count'];
	$value = $_GET['value'];
	echo "Generating cards: count = " . $count . ", value = " . $value . "<br>\n";
	
	echo "Generating random passwords...<br>\n";
	$time0 = clock();
	$query = "INSERT INTO rechargecards VALUE ";
	for($i = 1; $i <= $count; $i++)
	{
		$pass[$i] = GenerateRandomNumbers();
		if($i > 1)
			$query .= ",";
		$query .= "('" . $pass[$i] . "'," . $value . ")";
	}

	$time1 = clock();
	mysql_query($query);
	UpdateCounter("total-rechargecard-count", $count);
	UpdateCounter("total-rechargecard-money", $count * $value);
	$time2 = clock();
	
	echo "Command completed successfully<br>\n";
	printf("generating time: %.2fs<br>\n", $time1 - $time0);
	printf("sql querying time: %.2fs<br>\n", $time2 - $time1);

	echo "<br>\n";
	for($i = 1; $i <= $count; $i++)
	{
		echo $pass[$i];
		echo "<br>";
	}
?>
