<?php
include "Configure.php";

/* common functions */
function ConnectMySQLServer()
{
	global $MYSQL_HOST, $MYSQL_USERNAME, $MYSQL_PASSWORD, $MYSQL_DBNAME;
	$con = mysql_pconnect($MYSQL_HOST, $MYSQL_USERNAME, $MYSQL_PASSWORD);
	if(!$con)
		die('Could not connect: ' . mysql_error());
	mysql_select_db($MYSQL_DBNAME, $con);
	mysql_set_charset("utf8");
	return $con;
}


function UpdateCounter($name, $value)
{
	mysql_query("UPDATE counters SET value = value + " . $value . " WHERE name = \"" . $name . "\"");
}

function UpdatePrinterStatus($id, $status)
{
	mysql_query("UPDATE printers SET status = " . $status . " WHERE id = " . $id);
}

function UpdateJobStatus($id, $status)
{
	mysql_query("UPDATE jobs SET status = " . $status . " WHERE id = " . $id);
}

function GetUserID()
{
	if(!preg_match("/^[0-9a-zA-Z]{20}$/", $_COOKIE['userhash']))
		return 0;
	$result = mysql_query("SELECT id FROM sessions WHERE hash = '" . $_COOKIE['userhash'] . "'");
	if(mysql_num_rows($result) == 0)
		return 0;
	$row = mysql_fetch_array($result);
	return $row['id'];
}

function CleanSessions()
{
	mysql_query("DELETE FROM sessions WHERE expire < now()");
}

function CleanNotConfirmedJobs()
{
	global $CONFIRM_LIMIT;
	mysql_query("UPDATE jobs SET status = 4 WHERE status = 1 AND time < DATE_SUB(NOW(),  INTERVAL " . $CONFIRM_LIMIT . " MINUTE)");
}

function GetIPString($ip)
{
	$ret = $ip & 255;
	$ip >>= 8;
	$ret = ($ip & 255) . "." . $ret;
	$ip >>= 8;
	$ret = ($ip & 255) . "." . $ret;
	$ip >>= 8;
	$ret = $ip . "." . $ret;
	return $ret;
}

function GetIPInteger($ip)
{
	$tmp = explode(".", $ip);
	return ($tmp[0] << 24) + ($tmp[1] << 16) + ($tmp[2] << 8) + ($tmp[3]);
}

function GetUserSchoolID($id)
{
	if($id / 10000 % 10 == 2)
		return "g" . $id;
	if($id / 10000 % 10 == 1)
		return "c" . $id;
}
function GetUserNameByID($id)
{
	$result = mysql_query("SELECT name FROM users WHERE id = " . $id);
	$row = mysql_fetch_array($result);
	$ret .= GetUserSchoolID($id) . "(" . $row['name'] . ")";
	return $ret;
}
function GetPrinterNameByID($id)
{
	if($id == 0)
		return "";
	$result = mysql_query("SELECT name FROM printers WHERE id = " . $id);
	$row = mysql_fetch_array($result);
	return $row['name'];
}

function FormatDateTime($time)
{
	return date('Y-m-d H:i',strtotime($time));
}

function GetPrinterStatusString($s)
{
	switch($s)
	{
		case 1:
			return "空闲";
		case 2:
			return "打印中";
		case 3:
			return "暂停服务";
		case 4:
			return "失去连接";
		case 5:
			return "缺纸";
		case 6:
			return "卡纸";
		default:
			return "未知错误";
	}
}

function GetJobStatusString($s)
{
	switch($s)
	{
		case 1:
			return "待确认";
		case 2:
			return "队列中";
		case 3:
			return "正在打印";
		case 4:
			return "已取消";
		case 5:
			return "分析中";
		case 6:
			return "纸张错误";
		case 7:
			return "已完成";
		case 8:
			return "打印失败";
		default:
			return "未知错误";
	}
}

function GenerateRandomString()
{
	$str = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	$n = 20;
	$len = strlen($str) - 1;
	for($i = 1; $i <= $n; $i++)
	{
		$ret .= $str[rand(0, $len)];
	}
	return $ret;
}

function GenerateRandomNumbers()
{
	$str = "0123456789";
	$n = 20;
	$len = strlen($str) - 1;
	for($i = 1; $i <= $n; $i++)
	{
		$ret .= $str[rand(0, $len)];
	}
	return $ret;
}

function CheckMediumINT($x)
{
	return !preg_match("/^\d{1,8}$/", $x) || $x > 16777215;
}

function CheckBoolean($x)
{
	return $x != "0" && $x != "1";
}

function clock()
{
	list($usec, $sec) = explode(" ", microtime());
	return (float)$usec + (float)$sec;
}

ConnectMySQLServer();
UpdateCounter("total-page-load", 1);
//sleep(1);
?>
