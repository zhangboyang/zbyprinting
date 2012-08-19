var JobConfirm_TotalPages;
var JobConfirm_ID;
var JobConfirm_MoneyLeft;
var JobConfirm_Pages = new Array();
var JobConfirm_Name = new Array(), JobConfirm_SingleSided = new Array(), JobConfirm_DoubleSided = new Array(), JobConfirm_isDuplex = new Array(), JobConfirm_Paper = new Array();
var JobConfirm_Price;
function JobConfirm_RefreshSummary(type)
{
	var printer = $("input[name='printer']:checked").val();
	if(typeof(printer) != 'undefined')
	{
		document.getElementById("summary_printer").innerHTML = JobConfirm_Name[printer];
		if(JobConfirm_isDuplex[printer] == 1)
		{
			document.getElementById("double").disabled = false;
			if(type == 1)
				document.getElementById("double").checked = true;
		}
		else
		{
			document.getElementById("double").disabled = true;
			document.getElementById("single").checked = true;
		}
	}
	var duplex = $("input[name='duplex']:checked").val();
	if(typeof(duplex) != 'undefined')
	{
		document.getElementById("summary_duplex").innerHTML = duplex == 1 ? "自动双面打印" : "单面打印";
		if(typeof(printer) != 'undefined')
		{
			var i, tmp1, tmp2, sum, paper;
			sum = 0;
			if(duplex == 1)
			{
				for(i = 1; i <= JobConfirm_TotalPages; i++)
				{
					tmp1 = JobConfirm_Pages[i] * JobConfirm_DoubleSided[printer];
					tmp2 = tmp1 / 50000;
					document.getElementById("page" + i).innerHTML = tmp2.toFixed(2);
					sum += tmp1;
				}
				paper = Math.ceil(JobConfirm_TotalPages / 2) * JobConfirm_Paper[printer];
			}
			else
			{
				for(i = 1; i <= JobConfirm_TotalPages; i++)
				{
					tmp1 = JobConfirm_Pages[i] * JobConfirm_SingleSided[printer];
					tmp2 = tmp1 / 50000;
					document.getElementById("page" + i).innerHTML = tmp2.toFixed(2);
					sum += tmp1;
				}
				paper = JobConfirm_TotalPages * JobConfirm_Paper[printer];
			}
			tmp1 = Math.round(sum / 500) / 100;
			tmp2 = paper / 100;
			JobConfirm_Price = Math.round(sum / 500) + paper;
			sum = JobConfirm_Price / 100;
			document.getElementById("summary_price1").innerHTML = tmp1.toFixed(2);
			document.getElementById("summary_price2").innerHTML = tmp2.toFixed(2);
			document.getElementById("summary_price").innerHTML = sum.toFixed(2);
			if(JobConfirm_Price > JobConfirm_MoneyLeft)
			{
				document.getElementById("submit").value = "余额不足";
				document.getElementById("submit").disabled = true;
			}
			else
			{
				document.getElementById("submit").value = "确认无误，提交";
				document.getElementById("submit").disabled = false;
			}
		}
	}
}
function JobConfirm_SendXMLHttpResuest(printer, duplex)
{
	var xmlhttp, tablefoot;
	if(!window.ActiveXObject)
		xmlhttp = new XMLHttpRequest();
	else
		xmlhttp = new ActiveXObject("MSXML2.XMLHTTP");
	xmlhttp.onreadystatechange = function()
	{
		if(xmlhttp.readyState == 4)
		{
			if(xmlhttp.status == 200)
			{
				if(xmlhttp.responseText.indexOf("SUCCESS") >= 0)
					MainPage_ChangeSection('sec1');
				else if(xmlhttp.responseText.indexOf("BADPRICE") >= 0)
					alert("浮点数错误。");
				else if(xmlhttp.responseText.indexOf("NOTLOGGEDIN") >= 0)
				{
					alert("未登录。");
					MainPage_ChangeSection("usersec3");
				}
				else if(xmlhttp.responseText.indexOf("TIMEOUT") >= 0)
				{
					alert("操作超时。");
					MainPage_ChangeSection("sec1_back");
				}
				else if(xmlhttp.responseText.indexOf("BADPRINTER") >= 0)
				{
					alert("打印机错误，请重试。");
					MainPage_ChangeSection("sec1_back");
				}
				else if(xmlhttp.responseText.indexOf("BADARGS") >= 0)
					alert("参数错误。");
				else if(xmlhttp.responseText.indexOf("NOTENOUGHMONEY") >= 0)
					alert("余额不足。");
				else
					alert("内部错误，请刷新页面后重试。");
			}
			else
				alert("内部错误，请刷新页面后重试。");
			if(document.getElementById("submit"))
			{
				document.getElementById("submit").disabled = false;
				JobConfirm_RefreshSummary(0);
			}
		}
	}
	xmlhttp.open("GET", "cgi/PrintDocument.php?id=" + JobConfirm_ID + "&printer=" + printer + "&duplex=" + duplex + "&price=" + JobConfirm_Price, true);
	xmlhttp.send();
}
function JobConfirm_Submit()
{
	var printer = $("input[name='printer']:checked").val();
	if(typeof(printer) == 'undefined')
	{
		alert("请先选择打印机");
		return;
	}
		
	var duplex = $("input[name='duplex']:checked").val();
	if(typeof(duplex) == 'undefined')
	{
		alert("请先选择打印方式");
		return;
	}
	
	document.getElementById("submit").value = "处理中...";
	document.getElementById("submit").disabled = true;
	JobConfirm_SendXMLHttpResuest(printer, duplex);
}
function JobConfirm_PageReady()
{
	if(document.getElementById("info"))
		eval(document.getElementById("info").value);
	CommonLib_RefreshTableStyle();
}
