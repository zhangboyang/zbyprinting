<?php include "CommonLib.php"; ?>
<table class="usertable">
	<tr>
<?php
	$uid = GetUserID();
	if($uid == 0)
		echo "<td id=\"usersec1\" onclick=\"MainPage_ChangeSection('usersec3')\">您还没有登录</td><td id=\"usersec2\" onclick=\"MainPage_ChangeSection('usersec2')\">注册</td><td id=\"usersec3\" onclick=\"MainPage_ChangeSection('usersec3')\">登录</td>";
	else
		echo "<td id=\"usersec1\" onclick=\"MainPage_ChangeSection('sec2')\">" . GetUserNameByID($uid) . "</td><td id=\"usersec2\" onclick=\"LoginButtons_Logout()\">注销</td>";
?>
	</tr>
</table>
