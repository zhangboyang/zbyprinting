<?php include "CommonLib.php"; ?>
<table class="zbytable1" width="940" cellspacing="1">
	<tr>
		<th width="5%">序号</th>
		<th width="10%">名称</th>
		<th width="10%">状态</th>
		<th width="7%">作业总数</th>
		<th width="7%">成功总数</th>
		<th width="7%">错误总数</th>
		<th width="7%">单面价格</th>
		<th width="7%">双面价格</th>
		<th width="7%">纸张价格</th>
		<th width="12%">安装时间</th>
		<th width="21%">备注</th>
	</tr>
<?php
	$result = mysql_query("SELECT id, name, status, totaljobs, totalfinished, totalerrors, singlesided, doublesided, duplex, paper, setup, comments FROM printers");
	while($row = mysql_fetch_array($result))
	{
		echo "<tr>
				<td>" . $row['id'] . "</td>
				<td>" . $row['name'] . "</td>
				<td><div class=\"";
		if($row['status'] == 1 || $row['status'] == 2)
			echo "greentext";
		else
			echo "redtext";
		echo "\">" . GetPrinterStatusString($row['status']) . "</div></td>
				<td>" . $row['totaljobs'] . "</td>
				<td>" . $row['totalfinished'] . "</td>
				<td>" . $row['totalerrors'] . "</td>
				<td>"; printf("%.2f", $row['singlesided'] / 100); echo "</td>";
		  echo "<td>";
		if($row['duplex'] == 1)
			printf("%.2f", $row['doublesided'] / 100);
		else
			echo "不支持";
		echo   "</td>";
		echo   "<td>"; printf("%.2f", $row['paper'] / 100); echo "</td>
			    <td>" . FormatDateTime($row['setup']) . "</td>
				<td>" . $row['comments'] . "</td>
			  </tr>";
	}
?>
</table>
