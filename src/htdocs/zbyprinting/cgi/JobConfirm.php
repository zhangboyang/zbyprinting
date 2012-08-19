<?php include "CommonLib.php"; ?>
<table class="buttons">
	<tr>
		<td id="button1" onclick="MainPage_ChangeSection('sec1_back')">返回</td>
	</tr>
</table>
<br>

<?php
	$thisip = GetIPInteger($_SERVER['REMOTE_ADDR']);
	$uid = GetUserID();
	if($uid == 0)
		die("<div class=\"plaintext\">您还没有登录。</div>");
	$id = $_GET['id'];
	if(CheckMediumINT($id))
		die("<div class=\"plaintext\">参数错误。</div>");
	$result = mysql_query("SELECT * FROM jobs WHERE id = " . $id . " AND status = 1 AND ip = " . $thisip);
	if(mysql_num_rows($result) == 0)
		die("<div class=\"plaintext\">操作超时，请重试。</div>");
	$row = mysql_fetch_array($result);
	$pages = $row['pages'];
	
	
?>

<div class="subtitle">作业信息</div>
<div class="zbytable3">
	<table width="700" cellspacing="1">
		<tr>
			<th width="10%">作业序号</th>
			<th width="15%">提交者</th>
			<th width="45%">文档名</th>
			<th width="15%">提交时间</th>
			<th width="15%">状态</th>
		</tr>
		<tr>
<?php
	echo "
	<td>" . $row['id'] . "</td>
	<td>" . GetIPString($row['ip']) . "</td>
	<td>" . htmlspecialchars($row['name'], ENT_QUOTES, "UTF-8") . "</td>
	<td>" . FormatDateTime($row['time']) . "</td>
	<td>" . GetJobStatusString($row['status']) . "</td>";
?>
		</tr>
	</table>
</div>
<br>

<?php
	$result = mysql_query("SELECT pageid, result FROM jobs_analysis WHERE jobid = " . $id);
	while($row = mysql_fetch_array($result))
		$r[$row['pageid']] = $row['result'];
	
	$result = mysql_query("SELECT id, name, status, singlesided, doublesided, duplex, paper, comments FROM printers");
	$printers = mysql_num_rows($result);
	while($row = mysql_fetch_array($result))
		$p[$row['id']] = $row;
	
	$result = mysql_query("SELECT value FROM wallets WHERE id = " . $uid);
	$row = mysql_fetch_array($result);
	$money = $row['value'];
?>

<textarea id="info" class="hiddenobject" cols="30" rows="5">
<?php
	echo "JobConfirm_MoneyLeft = " . $money . ";\n";
	echo "JobConfirm_TotalPages = " . $pages . ";\n";

	for($i = 1; $i <= $pages; $i++)
		echo "JobConfirm_Pages[" . $i . "] = " . $r[$i] . ";\n";
	
	for($i = 1; $i <= $printers; $i++)
		echo "JobConfirm_SingleSided[" . $i . "] = " . $p[$i]['singlesided'] . ";\nJobConfirm_DoubleSided[" . $i . "] = " . $p[$i]['doublesided'] . ";\nJobConfirm_isDuplex[" . $i . "] = " . $p[$i]['duplex'] . ";\nJobConfirm_Name[" . $i . "] = \"" . $p[$i]['name'] . "\";\nJobConfirm_Paper[" . $i . "] = \"" . $p[$i]['paper'] . "\";\n";
?>
</textarea>

<div class="subtitle">选择一台打印机</div>
<div class="zbytable2">
	<table width="700" cellspacing="1">
		<tr>
			<th width="5%">&nbsp;</th>
			<th width="7%">序号</th>
			<th width="20%">名称</th>
			<th width="10%">状态</th>
			<th width="10%">单面价格</th>
			<th width="10%">双面价格</th>
			<th width="10%">纸张价格</th>
			<th width="28%">备注</th>
		</tr>
<?php
	for($i = 1; $i <= $printers; $i++)
	{
		echo "<tr>
				<td><input type=\"radio\" name=\"printer\" value=\"" . $i . "\" ";
		if($p[$i]['status'] != 1 && $p[$i]['status'] != 2)
			echo "disabled=\"true\" ";
		echo    "onclick=\"JobConfirm_RefreshSummary(1)\" /></td>
				<td>" . $p[$i]['id'] . "</td>
				<td>" . $p[$i]['name'] . "</td>
				<td><div class=\"";
		if($p[$i]['status'] == 1 || $p[$i]['status'] == 2)
			echo "greentext";
		else
			echo "redtext";
		echo "\">" . GetPrinterStatusString($p[$i]['status']) . "</div></td>
				<td>"; printf("%.2f", $p[$i]['singlesided'] / 100); echo "</td>";
		echo "<td>";
		if($p[$i]['duplex'] == 1)
			printf("%.2f", $p[$i]['doublesided'] / 100);
		else
			echo "不支持";
		echo   "</td><td>";
		printf("%.2f", $p[$i]['paper'] / 100);
		echo   "</td><td>" . $p[$i]['comments'] . "</td>
			  </tr>";
	}
?>
	</table>
</div>
<br>

<div class="subtitle">选择打印方式</div>
<div class="zbytable1">
	<table width="200" cellspacing="1">
		<tr>
			<td width="20%"><input id="double" type="radio" name="duplex" value="1" onclick="JobConfirm_RefreshSummary(0)" /></td>
			<td width="80%">自动双面打印</td>
		</tr>
		<tr>
			<td width="20%"><input id="single" type="radio" name="duplex" value="0" onclick="JobConfirm_RefreshSummary(0)" /></td>
			<td width="80%">单面打印</td>
		</tr>
	</table>
</div>
<br>

<!--
<div class="subtitle">页面缩略图</div>
<ul class="pageimagelist">
<?php
	for($i = 1; $i <= $pages; $i++)
	{
		echo "<li><a href=\"cgi/ReadPNGImage.php?job=" . $id . "&page=" . $i . "\" target=\"_blank\"><img src=\"cgi/ReadPNGImage.php?job=" . $id . "&page=" . $i . "\" /></a><br>第 " . $i . " 页 黑色面积: ";
		printf("%.2f", $r[$i] / 100);
		echo "%</li>";
	}
?>
</ul>
<div class="clear"></div>
-->

<div class="subtitle">页面分析结果</div>
<div class="zbytable3">
	<table width="200" cellspacing="1">
		<tr>
			<th width="20%">页码</th>
			<th width="30%">覆盖率</th>
			<th width="50%">费用</th>
		</tr>
<?php
	for($i = 1; $i <= $pages; $i++)
	{
		echo "<tr><td>" . $i . "</td><td>";
		printf("%.2f", $r[$i] / 100);
		echo "%</td><td><div id=\"page" . $i . "\">&nbsp;</td></tr>";
	}
?>
	</table>
</div>
<br>

<div class="subtitle">确认</div>
<table class="zbytable1" width="250">
	<tr>
		<td width="30%">打印机</td>
		<td width="70%"><div id="summary_printer">尚未选择</div></td>
	</tr>
	<tr>
		<td>打印方式</td>
		<td><div id="summary_duplex">尚未选择</div></td>
	</tr>
	<tr>
		<td>墨粉费用</td>
		<td><div id="summary_price1">&nbsp;</div></td>
	</tr>
	<tr>
		<td>纸张费用</td>
		<td><div id="summary_price2">&nbsp;</div></td>
	</tr>
	<tr>
		<td><div class="redtext">总费用</div></td>
		<td><div class="redtext" id="summary_price">&nbsp;</div></td>
	</tr>
	<tr>
		<td>账户余额</td>
		<td><?php printf("%.2f", $money / 100); ?></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><input type="button" id="submit" onclick="JobConfirm_Submit()" disabled="true" value="尚未选择" /></td>
	</tr>
</table>

