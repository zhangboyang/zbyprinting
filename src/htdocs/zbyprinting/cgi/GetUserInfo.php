<?php include "CommonLib.php"; ?>
<?php
	$uid = GetUserID();
	if($uid == 0)
		echo "<table width=\"200\" cellspacing=\"1\">
	<tr>
		<td width=\"40%\">姓名：</td>
		<td width=\"60%\">您还没有登录</td>
	</tr>
	<tr>
		<td>学号：</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>上次登录：</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>注册时间：</td>
		<td>&nbsp;</td>
	</tr>
</table>";
	else
	{
		$result = mysql_query("SELECT * FROM users WHERE id = " . $uid);
		$row = mysql_fetch_array($result);
		echo "<table width=\"200\" cellspacing=\"1\">
	<tr>
		<td width=\"40%\">姓名：</td>
		<td width=\"60%\">";
		echo $row['name'];
		echo "</td>
	</tr>
	<tr>
		<td>学号：</td>
		<td>";
		echo GetUserSchoolID($uid);
		echo "</td>
	</tr>
	<tr>
		<td>上次登录：</td>
		<td>";
		if(is_null($row['lastloginip']))
			echo "从未";
		else
			echo GetIPString($row['lastloginip']);
		echo "</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>";
		if(is_null($row['lastlogin']))
			echo "从未";
		else
			echo FormatDateTime($row['lastlogin']);
		echo "</td>
	</tr>
	<tr>
		<td>注册时间：</td>
		<td>";
		echo FormatDateTime($row['register']);
		echo "</td>
	</tr>
</table>";
	}
?>
