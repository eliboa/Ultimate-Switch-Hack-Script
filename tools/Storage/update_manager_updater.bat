::Script by Shadow256
@echo off
Setlocal enabledelayedexpansion
chcp 65001 >nul
cd /d "%~dp0\..\.."
IF EXIST "templogs" (
	del /q "templogs" 2>nul
	rmdir /s /q "templogs" 2>nul
)
mkdir "templogs"
cd >templogs\tempvar.txt
set /p ushs_base_path=<templogs\tempvar.txt
set ushs_base_path=%ushs_base_path%\
:define_language_path
set language_custom=0
set language_path=
set /p language_path=<Ultimate-Switch-Hack-Script.bat.lng
IF NOT EXIST "%language_path%\*.*" (
	del /q "Ultimate-Switch-Hack-Script.bat.lng"
	goto:define_language_path
)
call "%language_path%\language_general_config.bat"
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
echo %this_script_full_path%
call "%associed_language_script%" "display_title"
IF NOT EXIST "failed_updates\*.failed" (
	rmdir /s /q "failed_updates" 2>nul
)
	mkdir "failed_updates"
set temp_file_path=tools\Storage\update_manager.bat
set temp_file_slash_path=%temp_file_path:\=/%
set folders_url_project_base=https://github.com/shadow2560/Ultimate-Switch-Hack-Script/trunk
set files_url_project_base=https://github.com/shadow2560/Ultimate-Switch-Hack-Script/raw/master
call "%associed_language_script%" "begin_update"
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "no_internet_connection_error"
	pause
	endlocal
	exit
)
echo %temp_file_path%>"failed_updates\%temp_file_path:\=;%.file.failed"
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "%temp_file_path%" %files_url_project_base%/%temp_file_slash_path% 2>nul
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "update_file_error"
	IF EXIST "templogs" (
		rmdir /s /q "templogs"
	)
	pause
	endlocal
	exit
)
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "%temp_file_path%.version" %files_url_project_base%/%temp_file_slash_path%.version 2>nul
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "update_file.version_error"
	IF EXIST "templogs" (
		rmdir /s /q "templogs"
	)
	pause
	endlocal
	exit
)
IF "%language_custom%"=="0" (
	"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "%language_path%\%temp_file_path%" %files_url_project_base%/%language_path:\=/%/%temp_file_slash_path% 2>nul
	IF %errorlevel% NEQ 0 (
		call "%associed_language_script%" "update_language_file_error"
		IF EXIST "templogs" (
			rmdir /s /q "templogs"
		)
		pause
		endlocal
		exit
	)
	"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "%language_path%\%temp_file_path%.version" %files_url_project_base%/%language_path:\=/%/%temp_file_slash_path%.version 2>nul
	IF %errorlevel% NEQ 0 (
		call "%associed_language_script%" "update_language_file.version_error"
		IF EXIST "templogs" (
			rmdir /s /q "templogs"
		)
		pause
		endlocal
		exit
	)
)
del /q "failed_updates\%temp_file_path:\=;%.file.failed"
IF EXIST "templogs" (
	rmdir /s /q "templogs"
)
IF NOT EXIST "failed_updates\*.failed" (
	rmdir /s /q "failed_updates"
)
call "%associed_language_script%" "update_success"
pause
endlocal
start /i "" "%windir%\system32\cmd.exe" /c call "Ultimate-Switch-Hack-Script.bat"
exit