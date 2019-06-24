::Script by Shadow256
Setlocal enabledelayedexpansion
@echo off
chcp 65001 >nul
echo é >nul
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
:general_content_update

:skip_general_content_update
IF "%~1"=="" (
	goto:end_script
) else (
	goto:%~1
)

rem Specific scripts instructions must be added here

:verif_file_version

exit /b

:verif_folder_version

exit /b


:update_file

exit /b

:update_folder

exit /b


:end_script
IF EXIST templogs (
	rmdir /s /q templogs
	mkdir templogs
)
cls
endlocal