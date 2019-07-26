::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "intro"
pause
:select_install
cls
set install_choice=
call "%associed_language_script%" "install_choice"
IF NOT "%install_choice%"=="" set install_choice=%install_choice:~0,1%
IF "%install_choice%"=="1" goto:RCM_auto
IF "%install_choice%"=="2" goto:Zadig
IF "%install_choice%"=="3" goto:manual_install
IF "%install_choice%"=="0" goto:launch_doc
goto:finish_script
:RCM_auto
call "%associed_language_script%" "rcm_and_drivers_install_instructions"
pause
cd tools\drivers\apx_drivers
InstallDriver.exe
cd ..\..\..
set test_payload=
call "%associed_language_script%" "test_payload_choice"
IF NOT "%test_payload%"=="" set test_payload=%test_payload:~0,1%
IF /i "%test_payload%"=="o" (
	set test_payload=
	call tools\Storage\launch_payload.bat > log.txt 2>&1
	@echo off
)
echo.
goto:select_install

:Zadig
call "%associed_language_script%" "zadig_launch_instructions"
pause
echo.
start tools\drivers\zadig\zadig.exe
goto:select_install
:manual_install
call "%associed_language_script%" "manual_install_instructions"
pause
echo.
start devmgmt.msc
goto:select_install
:launch_doc
echo.
start "%language_pack%\doc\files\install_drivers.html
goto:select_install
:end_script
pause
:finish_script
endlocal