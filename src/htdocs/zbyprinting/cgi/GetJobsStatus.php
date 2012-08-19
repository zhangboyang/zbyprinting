<?php include "CommonLib.php"; ?>
<?php
function NoOutput()
{
	echo "<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>无记录</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>";
}
function NotLoggedIn()
{
	echo "<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>您还没有登录</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>";
}
function QueryAndOutput($q)
{
	global $uid, $thisip;
	//echo $q;
	$result = mysql_query($q);
	
	if(mysql_num_rows($result) == 0)
	{
		NoOutput();
		return;
	}
	
	while($row = mysql_fetch_array($result))
	{
		echo "<tr>
				<td>" . $row['id'] . "</td>
				<td>";
		if($row['userid'] == 0)
			echo GetIPString($row['ip']);
		else
			echo GetUserNameByID($row['userid']);
		echo "</td>
				<td>" . htmlspecialchars($row['name'], ENT_QUOTES, "UTF-8") . "</td>
				<td>" . GetPrinterNameByID($row['output']) . "</td>
				<td>" . FormatDateTime($row['time']) . "</td>
				<td>" . GetJobStatusString($row['status']) . "</td>
				<td>";
		if($_GET['type'] == "bill")
			printf("%.2f", $row['fee'] / 100);
		else if($row['status'] == 1 && $row['ip'] == $thisip)
		{
			if($uid == 0)
				echo "请先登录";
			else
				echo "<a href=\"javascript:MainPage_LoadConfirmPage(" . $row['id'] . ")\">确认</a>";
		}
		echo "</td></tr>";
	}
}
?>
<table width="940" cellspacing="1">
	<tr>
		<th width="7%">作业序号</th>
		<th width="15%">提交者</th>
		<th width="40%">文档名</th>
		<th width="10%">输出地点</th>
		<th width="12%">提交时间</th>
		<th width="8%">状态</th>
<?php
	if($_GET['type'] == "bill")
		echo "<th width=\"8%\">费用</th>";
	else
		echo "<th width=\"8%\">操作</th>";
?>
	</tr>

<?php
	$uid = GetUserID();
	$thisip = GetIPInteger($_SERVER['REMOTE_ADDR']);
	$limit = " ORDER BY id DESC LIMIT " . (($_GET['page'] - 1) * $PAGE_COUNT) . ", " . $PAGE_COUNT;
	
	switch($_GET['type'])
	{
		case "m1":
			CleanNotConfirmedJobs();
			QueryAndOutput("SELECT * FROM jobs WHERE ip = " . $thisip . " AND (status = 1 OR status = 5 OR (status = 6 AND time >= DATE_SUB(NOW(),  INTERVAL " . $PAPER_ERROR_LIMIT . " MINUTE)))" . $limit);
			break;
		case "m2":
			$where = " AND status != 1";
		case "bill":
			if($uid != 0)
				QueryAndOutput("SELECT * FROM jobs WHERE userid = " . $uid . $where . $limit);
			else
				NotLoggedIn();
			break;
		case "all":
			QueryAndOutput("SELECT * FROM jobs" . $limit);
				
	}
?>

</table>
