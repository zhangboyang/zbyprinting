@echo off
rem ###################################################
rem ## Printer Setup Tool for Zby's Printing Service ##
rem ## ver 0.1.3 for Windows XP, Vista, 7, 8         ##
rem ##                  Copyright 2012 Zhang Boyang. ##
rem ##                          All rights reserved. ##
rem ###################################################
rem ## ChangLog:                                     ##
rem ##  ver 0.1.3 20121122 change printer driver &   ##
rem ##                     bug fix &                 ##
rem ##                     non-root warning (winxp)  ##
rem ##  ver 0.1.2 20120910 bug fix & final release   ##
rem ##  ver 0.1.1 20120811 add windows 8 support     ##
rem ##  ver 0.1   20120726 initial release           ##
rem ###################################################

rem #### Options ####
set INSTALLERVER=0.1.3
set LASTCHANGE=2012-11-22
set PRINTERADDR=zby.pkuschool.edu.cn
set URLNAME=石头、剪子、布 打印店.url
set ICONPATH=%SYSTEMROOT%\system32\shell32.dll
set ICONID=60

title 石头、剪子、布打印店
:testinstalled
rem #### Test if installed ####
set UNINSTALL=
if "%1" == "--uninstall" goto uninstall
if exist "%ProgramFiles%\ZbyPrinting\uninst.bat" set UNINSTALL=%ProgramFiles%\ZbyPrinting\uninst.bat
if exist "%APPDATA%\ZbyPrinting\uninst.bat" set UNINSTALL=%APPDATA%\ZbyPrinting\uninst.bat
if "%UNINSTALL%" == "" goto begin
color 0B
echo.
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##                                  警 告                                   ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   安装程序检测到您的电脑中已经安装了本程序。                             ##
echo  ##                                                                          ##
echo  ##   安装程序将调用卸载程序先进行卸载。                                     ##
echo  ##                                                                          ##
echo  ##   ==== 按回车继续 ====                                                   ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##############################################################################
call:waitforenter
start "卸载 石头、剪子、布打印店 客户端程序" /wait cmd /c "%UNINSTALL%" --uninstall
goto testinstalled

rem #### Main Menu ###
:begin
color 0A
echo.
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##  *****  *                     ****        *             *                ##
echo  ##     *   *            ,        *   *                 *                    ##
echo  ##    *    * * *  *   *    ***   ****   * *  *  * **  ***  *  * **  ****    ##
echo  ##   *     *   *   * *    *      *      **   *  ** *   *   *  ** *  *  *    ##
echo  ##  *****  * * *    *       *    *      *    *  *  *   **  *  *  *  ****    ##
echo  ##                 *     ***                                           *    ##
echo  ##                *                                                  ***    ##
echo  ##                                                                          ##
echo  ##   ****                    *                                              ##
echo  ##  *      ****                      ****     石头、剪子、布打印店          ##
echo  ##   ***   ****  * *  *   *  *  ***  ****     Zby's Printing Service        ##
echo  ##      *  *     **    * *   *  *    *        ver %INSTALLERVER%                     ##
echo  ##  ****   ****  *      *    *  ***  ****     %LASTCHANGE%                    ##
echo  ##                                                                          ##
echo  ##  客户端安装程序                            for Windows XP, Vista, 7, 8   ##
echo  ##  整个安装过程将耗时约 2 分钟                                             ##
echo  ##                                                                          ##
echo  ##  http://zby.pkuschool.edu.cn       14-5-3 张博洋                         ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ==== 按回车继续 ====
call:waitforenter

set THISISROOT=1
del %systemroot%\system32\zbytemp.txt
echo This is test text. > zbytemp.txt
copy zbytemp.txt %systemroot%\system32
if not exist %systemroot%\system32\zbytemp.txt set THISISROOT=0
del zbytemp.txt
del %systemroot%\system32\zbytemp.txt

color 0E
cls
echo.
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##                           安 装 前 请 确 认                              ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   1. 计算机操作系统为 Windows XP, Vista, 7, 8 中的一个。                 ##
echo  ##                                                                          ##
echo  ##   2. 计算机已经接入北大附中校园内部网络。( 通过 Wifi 等方式 )            ##
echo  ##                                                                          ##
echo  ##   3. 安装过程中某些防火墙软件可能提示一些信息，请让防火墙允许本程序修    ##
echo  ##      改你的系统。                                                        ##
echo  ##                                                                          ##
echo  ##   4. 请同意以下用户协议，如果继续安装，则视为已经同意。                  ##
echo  ##                                                                          ##
echo  ##     a. 本软件为开源软件，所有源代码在 GPL  授权下发布，你可以根据你的    ##
echo  ##        意愿修改软件源代码，但必须遵守 GPL  授权。源代码可以在打印店的    ##
echo  ##        网站上下载。                                                      ##
echo  ##     b. 本软件没有任何形式的担保，在使用本软件过程中，由于本软件的问题    ##
echo  ##        而造成的任何损失，本软件不负任何责任。                            ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ==== 按回车继续 ====
call:waitforenter

if %THISISROOT%==1 goto setupprinter
color 0C
echo.
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##                                  警 告                                   ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   安装程序检测到安装程序没有以管理员身份运行。这可能会导致安装失败。     ##
echo  ##                                                                          ##
echo  ##   在安装打印机过程如果弹出错误窗口，这代表安装失败，即便本安装程序提示   ##
echo  ##   安装已成功。                                                           ##
echo  ##                                                                          ##
echo  ##   ******                                                                 ##
echo  ##                                                                          ##
echo  ##   若您正在使用 Windows XP 系统，强烈建议您立即退出，并用管理员账户运行   ##
echo  ##   本安装程序。                                                           ##
echo  ##                                                                          ##
echo  ##   若您正在使用 Windows Vista, 7, 8, 您可以选择继续安装，但是强烈建议您   ##
echo  ##   以管理员权限运行本安装程序（方法是在安装程序文件上点击右键，选择菜单   ##
echo  ##   中的“以管理员身份运行”）。                                           ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##   ==== 按回车继续，点击窗口右上角“ X ” 退出 ====                       ##
echo  ##                                                                          ##
echo  ##############################################################################
call:waitforenter

rem #### Setup Printer ####
:setupprinter
color 0F
cls
echo.
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##                             安 装 客 户 端                               ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   ==== 按回车开始安装客户端 ====                                         ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##############################################################################
echo.
call:waitforenter

cls
echo.
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##                             安 装 客 户 端                               ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   正在安装打印机，请稍候，这大约需要 20 秒钟 ... ...                     ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##############################################################################
echo.
rundll32 printui.dll,PrintUIEntry /b "Zby's Printing Service" /n "Zby's Printing Service" /x /if /f %windir%\inf\ntprint.inf /r "http://%PRINTERADDR%:631/printers/zbyprinting" /m "HP Color LaserJet PS"

cls
echo.
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##                             安 装 客 户 端                               ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   正在安装打印机，请稍候，这大约需要 20 秒钟 ... ...  安装完成！         ##
echo  ##                                                                          ##
echo  ##   正在安装快捷方式，请稍候 ... ...                                       ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##############################################################################
echo.

echo [InternetShortcut] > temp.url
echo URL=http://%PRINTERADDR%/zbyprinting/?ver=win%INSTALLERVER% >> temp.url
echo IconIndex=%ICONID% >> temp.url
echo IconFile=%ICONPATH% >> temp.url
if %THISISROOT%==0 goto installurl_notroot
if exist "%ALLUSERSPROFILE%\桌面" copy temp.url "%ALLUSERSPROFILE%\桌面\%URLNAME%"
if exist "%ALLUSERSPROFILE%\Desktop" copy temp.url "%ALLUSERSPROFILE%\Desktop\%URLNAME%"
goto finishinstallurl
:installurl_notroot
if exist "%USERPROFILE%\桌面" copy temp.url "%USERPROFILE%\桌面\%URLNAME%"
if exist "%USERPROFILE%\Desktop" copy temp.url "%USERPROFILE%\Desktop\%URLNAME%"
:finishinstallurl
del temp.url

cls
echo.
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##                             安 装 客 户 端                               ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   正在安装打印机，请稍候，这大约需要 20 秒钟 ... ...  安装完成！         ##
echo  ##                                                                          ##
echo  ##   正在安装快捷方式，请稍候 ... ...  安装完成！                           ##
echo  ##                                                                          ##
echo  ##   正在安装用于卸载的程序，请稍候 ... ...                                 ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##############################################################################
echo.

if %THISISROOT%==0 goto installuninst_notroot
SET INSTALLPATH=%ProgramFiles%\ZbyPrinting
SET REGROOT=HKLM
goto finishinstalluninst
:installuninst_notroot
SET INSTALLPATH=%APPDATA%\ZbyPrinting
SET REGROOT=HKCU
:finishinstalluninst
mkdir "%INSTALLPATH%" > NUL
copy %0 "%INSTALLPATH%\uninst.bat" > NUL
reg add %REGROOT%\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZbyPrinting > NUL
reg add %REGROOT%\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZbyPrinting /v DisplayName /t REG_SZ /d 石头、剪子、布打印店 /f > NUL
reg add %REGROOT%\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZbyPrinting /v UninstallString /t REG_SZ /d "%INSTALLPATH%\uninst.bat --uninstall" /f > NUL
reg add %REGROOT%\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZbyPrinting /v InstallLocation /t REG_SZ /d "%INSTALLPATH%" /f > NUL
reg add %REGROOT%\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZbyPrinting /v DisplayIcon /t REG_SZ /d "%ICONPATH%,%ICONID%" /f > NUL
reg add %REGROOT%\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZbyPrinting /v NoModify /t REG_DWORD /d 1 /f > NUL
reg add %REGROOT%\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZbyPrinting /v NoRepair /t REG_DWORD /d 1 /f > NUL

cls
echo.
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##                             安 装 客 户 端                               ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   正在安装打印机，请稍候，这大约需要 20 秒钟 ... ...  安装完成！         ##
echo  ##                                                                          ##
echo  ##   正在安装快捷方式，请稍候 ... ...  安装完成！                           ##
echo  ##                                                                          ##
echo  ##   正在安装用于卸载的程序，请稍候 ... ...  安装完成！                     ##
echo  ##                                                                          ##
echo  ##   ==== 按回车键继续 ====                                                 ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##############################################################################
echo.
call:waitforenter

color 0E
cls
echo.
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##                          恭 喜 ， 安 装 完 成 ！                         ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   所有安装操作均已结束。                                                 ##
echo  ##                                                                          ##
echo  ##   欢迎使用 石头、剪子、布打印店 的打印服务！                             ##
echo  ##                                                                          ##
echo  ##   ==== 按回车键退出 ====                                                 ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##   最低浏览器版本要求： Firefox 3.6.28, IE 6.0, Chrome 20                 ##
echo  ##                                                                          ##
echo  ##   推荐浏览器版本： Firefox 17, IE 8.0, Chrome 20 （或更高）              ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##   为了最佳的浏览体验，推荐使用 Firefox 浏览器。                          ##
echo  ##                                                                          ##
echo  ##############################################################################
echo.
call:waitforenter
start http://%PRINTERADDR%/intro/firstrun/?ver=win%INSTALLERVER%
goto end

rem #### Set zbyprinting as default printer ####

rem rundll32 printui.dll,PrintUIEntry /n "Zby's Printing Service" /y
rem pause

rem #### Uninstall ####
:uninstall
set TEMPUNINST="%TEMP%\uninst_zby.bat"
echo @echo off> %TEMPUNINST%
echo color 0F>> %TEMPUNINST%
echo cls>> %TEMPUNINST%
echo echo.>> %TEMPUNINST%
echo echo  ##############################################################################>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                  卸 载                                   ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##############################################################################>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##   您即将卸载“石头、剪子、布打印店 客户端程序”。                        ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##   ==== 按回车键开始卸载 ====                                             ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##############################################################################>> %TEMPUNINST%
echo call:waitforenter>> %TEMPUNINST%

echo cls>> %TEMPUNINST%
echo echo.>> %TEMPUNINST%
echo echo  ##############################################################################>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                  卸 载                                   ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##############################################################################>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##   正在卸载，请稍候，这大约需要 10 秒钟 ... ...                           ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##############################################################################>> %TEMPUNINST%

echo rundll32 printui.dll,PrintUIEntry /dl /n "Zby's Printing Service">> %TEMPUNINST%
echo del "%ALLUSERSPROFILE%\桌面\%URLNAME%">> %TEMPUNINST%
echo del "%ALLUSERSPROFILE%\Desktop\%URLNAME%">> %TEMPUNINST%
echo del "%USERPROFILE%\桌面\%URLNAME%">> %TEMPUNINST%
echo del "%USERPROFILE%\Desktop\%URLNAME%">> %TEMPUNINST%
echo reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZbyPrinting /f>> %TEMPUNINST%
echo reg delete HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZbyPrinting /f>> %TEMPUNINST%
echo del "%ProgramFiles%\ZbyPrinting\uninst.bat">> %TEMPUNINST%
echo rmdir "%ProgramFiles%\ZbyPrinting">> %TEMPUNINST%
echo del "%APPDATA%\ZbyPrinting\uninst.bat">> %TEMPUNINST%
echo rmdir "%APPDATA%\\ZbyPrinting">> %TEMPUNINST%

echo cls>> %TEMPUNINST%
echo echo.>> %TEMPUNINST%
echo echo  ##############################################################################>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                  卸 载                                   ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##############################################################################>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##   正在卸载，请稍候，这大约需要 10 秒钟 ... ...  卸载完成！               ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##   感谢您使用石头、剪子、布打印店。                                       ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##   ==== 按回车退出 ====                                                   ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##############################################################################>> %TEMPUNINST%
echo call:waitforenter>> %TEMPUNINST%
echo exit>> %TEMPUNINST%
echo :waitforenter>> %TEMPUNINST%
echo set /p WAITFORENTER=>> %TEMPUNINST%
%TEMPUNINST%
exit

rem #### Press enter to continue ###
:waitforenter
set /p WAITFORENTER=
goto end

rem #### End ####
:end
