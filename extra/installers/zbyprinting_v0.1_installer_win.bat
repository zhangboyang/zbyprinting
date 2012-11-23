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
set URLNAME=ʯͷ�����ӡ��� ��ӡ��.url
set ICONPATH=%SYSTEMROOT%\system32\shell32.dll
set ICONID=60

title ʯͷ�����ӡ�����ӡ��
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
echo  ##                                  �� ��                                   ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   ��װ�����⵽���ĵ������Ѿ���װ�˱�����                             ##
echo  ##                                                                          ##
echo  ##   ��װ���򽫵���ж�س����Ƚ���ж�ء�                                     ##
echo  ##                                                                          ##
echo  ##   ==== ���س����� ====                                                   ##
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
start "ж�� ʯͷ�����ӡ�����ӡ�� �ͻ��˳���" /wait cmd /c "%UNINSTALL%" --uninstall
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
echo  ##  *      ****                      ****     ʯͷ�����ӡ�����ӡ��          ##
echo  ##   ***   ****  * *  *   *  *  ***  ****     Zby's Printing Service        ##
echo  ##      *  *     **    * *   *  *    *        ver %INSTALLERVER%                     ##
echo  ##  ****   ****  *      *    *  ***  ****     %LASTCHANGE%                    ##
echo  ##                                                                          ##
echo  ##  �ͻ��˰�װ����                            for Windows XP, Vista, 7, 8   ##
echo  ##  ������װ���̽���ʱԼ 2 ����                                             ##
echo  ##                                                                          ##
echo  ##  http://zby.pkuschool.edu.cn       14-5-3 �Ų���                         ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ==== ���س����� ====
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
echo  ##                           �� װ ǰ �� ȷ ��                              ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   1. ���������ϵͳΪ Windows XP, Vista, 7, 8 �е�һ����                 ##
echo  ##                                                                          ##
echo  ##   2. ������Ѿ����뱱����У԰�ڲ����硣( ͨ�� Wifi �ȷ�ʽ )            ##
echo  ##                                                                          ##
echo  ##   3. ��װ������ĳЩ����ǽ���������ʾһЩ��Ϣ�����÷���ǽ����������    ##
echo  ##      �����ϵͳ��                                                        ##
echo  ##                                                                          ##
echo  ##   4. ��ͬ�������û�Э�飬���������װ������Ϊ�Ѿ�ͬ�⡣                  ##
echo  ##                                                                          ##
echo  ##     a. �����Ϊ��Դ���������Դ������ GPL  ��Ȩ�·���������Ը������    ##
echo  ##        ��Ը�޸����Դ���룬���������� GPL  ��Ȩ��Դ��������ڴ�ӡ���    ##
echo  ##        ��վ�����ء�                                                      ##
echo  ##     b. �����û���κ���ʽ�ĵ�������ʹ�ñ���������У����ڱ����������    ##
echo  ##        ����ɵ��κ���ʧ������������κ����Ρ�                            ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ==== ���س����� ====
call:waitforenter

if %THISISROOT%==1 goto setupprinter
color 0C
echo.
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##                                  �� ��                                   ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   ��װ�����⵽��װ����û���Թ���Ա������С�����ܻᵼ�°�װʧ�ܡ�     ##
echo  ##                                                                          ##
echo  ##   �ڰ�װ��ӡ����������������󴰿ڣ������װʧ�ܣ����㱾��װ������ʾ   ##
echo  ##   ��װ�ѳɹ���                                                           ##
echo  ##                                                                          ##
echo  ##   ******                                                                 ##
echo  ##                                                                          ##
echo  ##   ��������ʹ�� Windows XP ϵͳ��ǿ�ҽ����������˳������ù���Ա�˻�����   ##
echo  ##   ����װ����                                                           ##
echo  ##                                                                          ##
echo  ##   ��������ʹ�� Windows Vista, 7, 8, ������ѡ�������װ������ǿ�ҽ�����   ##
echo  ##   �Թ���ԱȨ�����б���װ���򣨷������ڰ�װ�����ļ��ϵ���Ҽ���ѡ��˵�   ##
echo  ##   �еġ��Թ���Ա������С�����                                           ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##   ==== ���س�����������������Ͻǡ� X �� �˳� ====                       ##
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
echo  ##                             �� װ �� �� ��                               ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   ==== ���س���ʼ��װ�ͻ��� ====                                         ##
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
echo  ##                             �� װ �� �� ��                               ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   ���ڰ�װ��ӡ�������Ժ����Լ��Ҫ 20 ���� ... ...                     ##
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
echo  ##                             �� װ �� �� ��                               ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   ���ڰ�װ��ӡ�������Ժ����Լ��Ҫ 20 ���� ... ...  ��װ��ɣ�         ##
echo  ##                                                                          ##
echo  ##   ���ڰ�װ��ݷ�ʽ�����Ժ� ... ...                                       ##
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
if exist "%ALLUSERSPROFILE%\����" copy temp.url "%ALLUSERSPROFILE%\����\%URLNAME%"
if exist "%ALLUSERSPROFILE%\Desktop" copy temp.url "%ALLUSERSPROFILE%\Desktop\%URLNAME%"
goto finishinstallurl
:installurl_notroot
if exist "%USERPROFILE%\����" copy temp.url "%USERPROFILE%\����\%URLNAME%"
if exist "%USERPROFILE%\Desktop" copy temp.url "%USERPROFILE%\Desktop\%URLNAME%"
:finishinstallurl
del temp.url

cls
echo.
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##                             �� װ �� �� ��                               ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   ���ڰ�װ��ӡ�������Ժ����Լ��Ҫ 20 ���� ... ...  ��װ��ɣ�         ##
echo  ##                                                                          ##
echo  ##   ���ڰ�װ��ݷ�ʽ�����Ժ� ... ...  ��װ��ɣ�                           ##
echo  ##                                                                          ##
echo  ##   ���ڰ�װ����ж�صĳ������Ժ� ... ...                                 ##
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
reg add %REGROOT%\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZbyPrinting /v DisplayName /t REG_SZ /d ʯͷ�����ӡ�����ӡ�� /f > NUL
reg add %REGROOT%\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZbyPrinting /v UninstallString /t REG_SZ /d "%INSTALLPATH%\uninst.bat --uninstall" /f > NUL
reg add %REGROOT%\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZbyPrinting /v InstallLocation /t REG_SZ /d "%INSTALLPATH%" /f > NUL
reg add %REGROOT%\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZbyPrinting /v DisplayIcon /t REG_SZ /d "%ICONPATH%,%ICONID%" /f > NUL
reg add %REGROOT%\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZbyPrinting /v NoModify /t REG_DWORD /d 1 /f > NUL
reg add %REGROOT%\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZbyPrinting /v NoRepair /t REG_DWORD /d 1 /f > NUL

cls
echo.
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##                             �� װ �� �� ��                               ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   ���ڰ�װ��ӡ�������Ժ����Լ��Ҫ 20 ���� ... ...  ��װ��ɣ�         ##
echo  ##                                                                          ##
echo  ##   ���ڰ�װ��ݷ�ʽ�����Ժ� ... ...  ��װ��ɣ�                           ##
echo  ##                                                                          ##
echo  ##   ���ڰ�װ����ж�صĳ������Ժ� ... ...  ��װ��ɣ�                     ##
echo  ##                                                                          ##
echo  ##   ==== ���س������� ====                                                 ##
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
echo  ##                          �� ϲ �� �� װ �� �� ��                         ##
echo  ##                                                                          ##
echo  ##############################################################################
echo  ##                                                                          ##
echo  ##   ���а�װ�������ѽ�����                                                 ##
echo  ##                                                                          ##
echo  ##   ��ӭʹ�� ʯͷ�����ӡ�����ӡ�� �Ĵ�ӡ����                             ##
echo  ##                                                                          ##
echo  ##   ==== ���س����˳� ====                                                 ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##   ���������汾Ҫ�� Firefox 3.6.28, IE 6.0, Chrome 20                 ##
echo  ##                                                                          ##
echo  ##   �Ƽ�������汾�� Firefox 17, IE 8.0, Chrome 20 ������ߣ�              ##
echo  ##                                                                          ##
echo  ##                                                                          ##
echo  ##   Ϊ����ѵ�������飬�Ƽ�ʹ�� Firefox �������                          ##
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
echo echo  ##                                  ж ��                                   ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##############################################################################>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##   ������ж�ء�ʯͷ�����ӡ�����ӡ�� �ͻ��˳��򡱡�                        ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##   ==== ���س�����ʼж�� ====                                             ##>> %TEMPUNINST%
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
echo echo  ##                                  ж ��                                   ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##############################################################################>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##   ����ж�أ����Ժ����Լ��Ҫ 10 ���� ... ...                           ##>> %TEMPUNINST%
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
echo del "%ALLUSERSPROFILE%\����\%URLNAME%">> %TEMPUNINST%
echo del "%ALLUSERSPROFILE%\Desktop\%URLNAME%">> %TEMPUNINST%
echo del "%USERPROFILE%\����\%URLNAME%">> %TEMPUNINST%
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
echo echo  ##                                  ж ��                                   ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##############################################################################>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##   ����ж�أ����Ժ����Լ��Ҫ 10 ���� ... ...  ж����ɣ�               ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##   ��л��ʹ��ʯͷ�����ӡ�����ӡ�ꡣ                                       ##>> %TEMPUNINST%
echo echo  ##                                                                          ##>> %TEMPUNINST%
echo echo  ##   ==== ���س��˳� ====                                                   ##>> %TEMPUNINST%
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
