var JobConfirm_TotalPages;
var JobConfirm_ID;
var JobConfirm_MoneyLeft;
var JobConfirm_Pages = new Array();
var JobConfirm_Name = new Array(), JobConfirm_SingleSided = new Array(), JobConfirm_DoubleSided = new Array(), JobConfirm_isDuplex = new Array(), JobConfirm_Paper = new Array();
var JobConfirm_Price;
function JobConfirm_RefreshSummary(type)
{
	var printer = $("input[name='printer']:checked").val();
	if (typeof(printer) != 'undefined')
	{
		$("#summary_printer").html(JobConfirm_Name[printer]);
		if (JobConfirm_isDuplex[printer] == 1)
		{
			$("#double").attr("disabled", false);
			if (type == 1)
				$("#double").attr("checked", true);
		}
		else
		{
			$("#double").attr("disabled", true);
			$("#single").attr("checked", true);
		}
	}
	
	var duplex = $("input[name='duplex']:checked").val();
	if (typeof(duplex) != 'undefined')
	{
		$("#summary_duplex").html(duplex == 1 ? "自动双面打印" : "单面打印");
		if (typeof(printer) != 'undefined')
		{
			var i, tmp1, tmp2, sum, paper;
			sum = 0;
			if(duplex == 1)
			{
				for(i = 1; i <= JobConfirm_TotalPages; i++)
				{
					tmp1 = JobConfirm_Pages[i] * JobConfirm_DoubleSided[printer];
					tmp2 = tmp1 / 50000;
					$("#page" + i).html(tmp2.toFixed(2));
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
					$("#page" + i).html(tmp2.toFixed(2));
					sum += tmp1;
				}
				paper = JobConfirm_TotalPages * JobConfirm_Paper[printer];
			}
			tmp1 = Math.round(sum / 500) / 100;
			tmp2 = paper / 100;
			JobConfirm_Price = Math.round(sum / 500) + paper;
			sum = JobConfirm_Price / 100;
			$("#summary_price1").html(tmp1.toFixed(2));
			$("#summary_price2").html(tmp2.toFixed(2));
			$("#summary_price").html(sum.toFixed(2));
			if(JobConfirm_Price > JobConfirm_MoneyLeft)
			{
				$("#submit").attr("value", "余额不足");
				$("#submit").attr("disabled", true);
			}
			else
			{
				$("#submit").attr("value", "确认无误，提交");
				$("#submit").attr("disabled", false);
			}
		}
	}
}
function JobConfirm_SendXMLHttpResuest(printer, duplex)
{
	$.get("cgi/PrintDocument.php?id=" + JobConfirm_ID + "&printer=" + printer + "&duplex=" + duplex + "&price=" + JobConfirm_Price,
		function (response, status, xhr)
		{
			if (response.indexOf("SUCCESS") >= 0)
				MainPage_ChangeSection('sec1');
			else if (response.indexOf("BADPRICE") >= 0)
				alert("浮点数错误。");
			else if (response.indexOf("NOTLOGGEDIN") >= 0)
			{
				alert("未登录。");
				MainPage_ChangeSection("usersec3");
			}
			else if (response.indexOf("TIMEOUT") >= 0)
			{
				alert("操作超时。");
				MainPage_ChangeSection("sec1_back");
			}
			else if (response.indexOf("BADPRINTER") >= 0)
			{
				alert("打印机错误，请重试。");
				MainPage_ChangeSection("sec1_back");
			}
			else if (response.indexOf("BADARGS") >= 0)
				alert("参数错误。");
			else if (response.indexOf("NOTENOUGHMONEY") >= 0)
				alert("余额不足。");
			else
				alert("内部错误，请刷新页面后重试。");
		}
	);
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
	
	$("#submit").attr("value", "处理中...");
	$("#submit").attr("disabled", true);
	JobConfirm_SendXMLHttpResuest(printer, duplex);
}
function JobConfirm_PageReady()
{
	if (document.getElementById("info"))
		eval($("#info").attr("value"));
	CommonLib_RefreshTableStyle();
}
