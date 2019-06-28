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
set base_script_path="%~dp0\..\..\.."
set folders_url_project_base=https://github.com/shadow2560/Ultimate-Switch-Hack-Script/trunk
set files_url_project_base=https://raw.githubusercontent.com/shadow2560/Ultimate-Switch-Hack-Script/master
IF NOT "%~nx0"=="update_manager_tmp.bat" (
	IF EXIST "%~dp0\%~n0_tmp.bat" del /q "%~dp0\%~n0_tmp.bat"
) else (
	cd /d "%base_script_path%"
)
:general_content_update

:skip_general_content_update
IF "%~1"=="" (
	goto:end_script
) else (
	goto:%~1
)

rem Specific scripts instructions must be added here

:verif_file_version
set temp_file_slash_path=%~1
set temp_file_slash_path=%temp_file_slash_path:\=/%
call :test_write_access file "%~1"
set /p script_version=<"%~1.version"
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "templogs\version.txt" %files_url_project_base%/%temp_file_slash_path%.version
set /p script_version_verif=<"templogs\version.txt"
call :compare_version
exit /b

:verif_folder_version
set temp_folder_slash_path=%~1
set temp_folder_slash_path=%temp_folder_slash_path:\=/%
call :test_write_access folder "%~1"
set /p script_version=<"%~1\folder_version.txt"
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "templogs\version.txt" %files_url_project_base%/%temp_folder_slash_path%/folder_version.txt
set /p script_version_verif=<"templogs\version.txt"
call :compare_version
exit /b

:update_file
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "%temp_file_slash_path:/=\%" %files_url_project_base%/%temp_file_slash_path%
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "%temp_file_slash_path:/=\%.version" %files_url_project_base%/%temp_file_slash_path%.version
exit /b

:update_folder
rmdir /s /q "%temp_folder_slash_path:/=\%"
"tools\gitget\SVN\svn.exe" export %folder_url_project_base%/%temp_folder_slash_path:/=\% "%temp_folder_slash_path:/=\%" --force
exit /b

:compare_version
set update_finded=
IF %script_version_verif:~0,1% GTR %script_version:~0,1% (
	set update_finded=O
	exit /b 1
)
IF %script_version_verif:~2,1% GTR %script_version:~2,1% (
	set update_finded=O
	exit /b 1
)
IF %script_version_verif:~3,1% GTR %script_version:~3,1% (
	set update_finded=O
	exit /b 1
)
IF %script_version_verif:~5,1% GTR %script_version:~5,1% (
	set update_finded=O
	exit /b 1
)
IF %script_version_verif:~6,1% GTR %script_version:~6,1% (
	set update_finded=O
	exit /b 1
)
	exit /b 0

:test_write_access
IF "%~1"=="folder" (
	mkdir "%~2\test"
) else (
	mkdir "%~dp2\test"
)
IF %errorlevel% NEQ 0 (
	echo Le script se trouve dans un répertoire nécessitant les privilèges administrateur pour être écrit. Veuillez relancer le script avec les privilèges administrateur en faisant un clique droit dessus et en sélectionnant "Exécuter en tant qu'administrateur".
	goto:end_script
)
IF "%~1"=="folder" (
	rmdir /s /q "%~2\test"
) else (
	rmdir /s /q "%~dp2\test"
)
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
	mkdir templogs
)
cls
endlocal