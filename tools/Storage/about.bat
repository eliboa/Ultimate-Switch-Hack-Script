::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
:define_action_choice
cls
call "%associed_language_script%" "display_title"
echo.
set action_choice=
call "%associed_language_script%" "action_choice"
IF "%action_choice%"=="1" goto:display_changelog_general
IF "%action_choice%"=="2" goto:display_changelog_packs
IF "%action_choice%"=="3" goto:check_update
IF "%action_choice%"=="4" goto:full_update
IF "%action_choice%"=="5" (
	set action_choice=
	cls
	start https://www.paypal.me/shadow256
	goto:define_action_choice
)
goto:end_script
:display_changelog_general
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "no_internet_connection"
	goto:define_action_choice
)
tools\gnuwin32\bin\wget.exe --no-check-certificate --content-disposition -S -O "templogs\changelog.html" https://github.com/shadow2560/Ultimate-Switch-Hack-Script/raw/master/%language_path:\=/%/doc/files/changelog.html
call "%associed_language_script%" "display_title"
start explorer.exe templogs\changelog.html
goto:define_action_choice
:display_changelog_packs
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "no_internet_connection"
	goto:define_action_choice
)
tools\gnuwin32\bin\wget.exe --no-check-certificate --content-disposition -S -O "templogs\changelog.html" https://github.com/shadow2560/Ultimate-Switch-Hack-Script/raw/master/%language_path:\=/%/doc/files/packs_changelog.html
call "%associed_language_script%" "display_title"
start explorer.exe templogs\changelog.html
goto:define_action_choice
:check_update
set action_choice=
echo.
cls
call TOOLS\Storage\update_manager.bat "update_all" "force"
@echo off
exit
:full_update
set action_choice=
echo.
del /s /q folder_version.txt >nul
del /q Ultimate-Switch-Hack-Script.bat.version >nul
move "tools\Storage\update_manager.bat.version" "templogs\update_manager.bat.version" >nul
del /q tools\Storage\*.version >nul
move "templogs\update_manager.bat.version" "tools\Storage\update_manager.bat.version" >nul
cls
call TOOLS\Storage\update_manager.bat "update_all" "force"
@echo off
exit
:end_script
rmdir /s /q templogs 2>nul
endlocal