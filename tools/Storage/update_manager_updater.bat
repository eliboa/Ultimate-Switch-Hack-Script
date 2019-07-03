@echo off
chcp 65001 >nul
cd /d "%~dp0\..\.."
IF EXIST "templogs" (
	del /q "templogs" 2>nul
	rmdir /s /q "templogs" 2>nul
)
mkdir "templogs"
IF NOT EXIST "failed_updates\*.failed" (
	rmdir /s /q "failed_updates" 2>nul
)
	mkdir "failed_updates"
set temp_file_path=tools\Storage\update_manager.bat
set temp_file_slash_path=%temp_file_path:\=/%
set folders_url_project_base=https://github.com/shadow2560/Ultimate-Switch-Hack-Script/trunk
set files_url_project_base=https://github.com/shadow2560/Ultimate-Switch-Hack-Script/raw/master
set /p ushs_version=<DOC\folder_version.txt
title Shadow256 Ultimate Switch Hack Script %ushs_version% Update Manager Updater
echo :::::::::::::::::::::::::::::::::::::
echo ::Shadow256 Ultimate Switch Hack Script %ushs_version% Update Manager Updater::
echo.
echo Mise à jour du gestionnaire de mises à jour du script en cours...
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	echo Aucune connexion internet vérifiable, la mise à jour du fichier "%temp_file_path%" n'aura pas lieu.
	pause
	exit
)
echo %temp_file_path%>"failed_updates\%temp_file_path:\=;%.file.failed"
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "%temp_file_path%" %files_url_project_base%/%temp_file_slash_path% 2>nul
IF %errorlevel% NEQ 0 (
	echo Erreur lors de la mise à jour du fichier "%temp_file_path%", le script va se fermer pour pouvoir relancer le processus de mise à jour lors du prochain redémarrage de celui-ci.
	IF EXIST "templogs" (
		rmdir /s /q "templogs"
	)
	pause
	exit
)
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "%temp_file_path%.version" %files_url_project_base%/%temp_file_slash_path%.version 2>nul
IF %errorlevel% NEQ 0 (
	echo Erreur lors de la mise à jour du fichier "%temp_file_path%.version", le script va se fermer pour pouvoir relancer le processus de mise à jour lors du prochain redémarrage de celui-ci.
	IF EXIST "templogs" (
		rmdir /s /q "templogs"
	)
	pause
	exit
)
del /q "failed_updates\%temp_file_path:\=;%.file.failed"
IF EXIST "templogs" (
	rmdir /s /q "templogs"
)
IF NOT EXIST "failed_updates\*.failed" (
	rmdir /s /q "failed_updates"
)
echo Mise à jour du gestionnaire de mises à jour du script terminée.
pause
start "" "%windir%\system32\cmd.exe" "/c start ^"^" ^"Ultimate-Switch-Hack-Script.bat^""
exit