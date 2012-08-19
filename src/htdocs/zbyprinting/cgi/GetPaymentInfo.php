<?php include "CommonLib.php"; ?>
<?php
	$uid = GetUserID();
	if($uid == 0)
		echo "<table width=\"200\" cellspacing=\"1\">
	<tr>
		<td width=\"40%\">账户余额</td>
		<td width=\"60%\">您还没有登录</td>
	</tr>
	<tr>
		<td>上次结账：</td>
		<td>&nbsp;</td>
	</tr>
</table>";
	else
	{
		$result = mysql_query("SELECT value, lastpayment FROM wallets WHERE id = " . $uid);
		$row = mysql_fetch_array($result);
		echo "<table width=\"200\" cellspacing=\"1\">
	<tr>
		<td width=\"40%\">账户余额</td>
		<td width=\"60%\">";
		printf("%.2f", $row['value'] / 100);
		echo " 元</td>
	</tr>
	<tr>
		<td>上次结账：</td>
		<td>";
		if(is_null($row['lastpayment']))
			echo "从未";
		else
			echo FormatDateTime($row['lastpayment']);
		echo "</td>
	</tr>
</table>";
	}
?>
