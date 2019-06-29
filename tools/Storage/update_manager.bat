::Script by Shadow256
Setlocal enabledelayedexpansion
@echo off
chcp 65001 >nul
echo é >nul
IF "%~1"=="" goto:end_script
rem IF "%~2"=="forced" set verif_update=Y
set base_script_path="%~dp0\..\.."
set folders_url_project_base=https://github.com/shadow2560/Ultimate-Switch-Hack-Script/trunk
set files_url_project_base=https://github.com/shadow2560/Ultimate-Switch-Hack-Script/raw/master
IF NOT "%~nx0"=="update_manager_tmp.bat" (
	IF EXIST "%~dp0\%~n0_tmp.bat" del /q "%~dp0\%~n0_tmp.bat"
) else (
	cd /d "%base_script_path%"
)
IF EXIST "templogs" (
	del /q "templogs" 2>nul
	rmdir /s /q "templogs" 2>nul
)
mkdir "templogs"
IF EXIST "failed_updates" (
	del /q "failed_updates" 2>nul
	rmdir /s /q "failed_updates" 2>nul
)
mkdir "failed_updates"
:failed_updates_verification
IF NOT EXIST "failed_updates\*.failed" goto:skip_failed_updates_verification
cd "failed_updates"
IF EXIST "update_manager.bat.file.failed" (
		call :verif_file_version "tools\Storage\update_manager_updater.bat"
IF !errorlevel! EQU 1 (
	call :update_file
)
	echo Le gestionnaire de mises à jour doit se mettre à jour lui-même avant de pouvoir continuer car sa mise à jour précédente semble avoir échouée.
	echo Pour se faire, le script va lancer un autre script puis se fermer pour que la mise à jour puisse s'effectuer correctement.
	echo Une fois la mise à jour effectuée, le script va redémarrer.
	pause
	call :update_manager_update_special_script
)
for %%f in (*.failed) do (
	call :update_failed_content "%%f"
)
cd ..
:skip_failed_updates_verification
:update_manager_update
call :verif_file_version "tools\Storage\update_manager.bat"
IF %errorlevel% EQU 1 (
	call :verif_file_version "tools\Storage\update_manager_updater.bat"
IF !errorlevel! EQU 1 (
	call :update_file
)
	echo Le gestionnaire de mises à jour doit se mettre à jour lui-même avant de pouvoir continuer.
	echo Pour se faire, le script va lancer un autre script puis se fermer pour que la mise à jour puisse s'effectuer correctement.
	echo Une fois la mise à jour effectuée, le script va redémarrer.
	pause
	call :update_manager_update_special_script
)
:general_content_update
IF "%~2"=="skip_general_update" goto:skip_general_content_update
echo Mise à jour des éléments généraux du script
call :verif_file_version "Ultimate-Switch-Hack-Script.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_file_version "tools\Storage\about.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_file_version "tools\Storage\launch_payload.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_file_version "tools\Storage\menu.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_file_version "tools\Storage\ocasional_functions_menu.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_file_version "tools\Storage\others_functions_menu.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_file_version "tools\Storage\pegaswitch.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_file_version "tools\Storage\restore_configs.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_file_version "tools\Storage\restore_default.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_file_version "tools\Storage\save_and_restaure_menu.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_file_version "tools\Storage\save_configs.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "DOC"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\7zip"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\default_configs"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\gitget"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\gnuwin32"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\megatools"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\Node.js_programs"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\sd_switch\pegaswitch"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\Storage\functions"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\TegraRcmSmash"
IF %errorlevel% EQU 1 (
	call :update_folder
)
echo Mise à jour des éléments généraux terminée.
:skip_general_content_update
	IF "%~1"=="" (
		goto:end_script
	) else (
	goto:%~1
)



rem Specific scripts instructions must be added here

:verif_file_version
set temp_file_path=%~1
set temp_file_slash_path=%temp_file_path:\=/%
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	echo Aucune connexion internet vérifiable, la vérification de version du fichier "%temp_file_path%" n'aura pas lieu.
	exit /b 0
)
call :test_write_access file "%~1"
set script_version=0.00.00
IF EXIST "%~1.version" set /p script_version=<"%~1.version"
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "templogs\version.txt" %files_url_project_base%/%temp_file_slash_path%.version 2>nul
title Shadow256 Ultimate Switch Hack Script %ushs_version%
set /p script_version_verif=<"templogs\version.txt"
rem echo %temp_file_path% : va=%script_version%, vm=%script_version_verif%
rem echo %temp_file_slash_path%
rem pause
call :compare_version
exit /b %errorlevel%

:verif_folder_version
set temp_folder_path=%~1
set temp_folder_slash_path=%temp_folder_path:\=/%
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	echo Aucune connexion internet vérifiable, la vérification de version du dossier "%temp_folder_path%" n'aura pas lieu.
	exit /b 0
)
call :test_write_access folder "%~1"
set script_version=0.00.00
IF EXIST "%~1\folder_version.txt" set /p script_version=<"%~1\folder_version.txt"
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "templogs\version.txt" %files_url_project_base%/%temp_folder_slash_path%/folder_version.txt 2>nul
title Shadow256 Ultimate Switch Hack Script %ushs_version%
set /p script_version_verif=<"templogs\version.txt"
rem echo %temp_folder_path% : va=%script_version%, vm=%script_version_verif%
rem echo %temp_folder_slash_path%
rem pause
call :compare_version
exit /b %errorlevel%

:update_file
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	echo Aucune connexion internet vérifiable, la mise à jour du fichier "%temp_file_path%" n'aura pas lieu.
	exit /b 404
)
echo %temp_file_path%>"failed_updates\%temp_file_path:\=;%.file.failed"
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "%temp_file_path%" %files_url_project_base%/%temp_file_slash_path% 2>nul
IF %errorlevel% NEQ 0 (
	echo Erreur lors de la mise à jour du fichier "%temp_file_path%", le script va se fermer pour pouvoir relancer le processus de mise à jour lors du prochain redémarrage de celui-ci.
	IF EXIST templogs (
		rmdir /s /q templogs
	)
	pause
	exit
)
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "%temp_file_path%.version" %files_url_project_base%/%temp_file_slash_path%.version 2>nul
IF %errorlevel% NEQ 0 (
	echo Erreur lors de la mise à jour du fichier "%temp_file_path%.version", le script va se fermer pour pouvoir relancer le processus de mise à jour lors du prochain redémarrage de celui-ci.
	IF EXIST templogs (
		rmdir /s /q templogs
	)
	pause
	exit
)
title Shadow256 Ultimate Switch Hack Script %ushs_version%
del /q "failed_updates\%temp_file_path:\=;%.file.failed"
exit /b

:update_folder
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	echo Aucune connexion internet vérifiable, la mise à jour du dossier "%temp_folder_path%" n'aura pas lieu.
	exit /b 404
)
echo %temp_folder_path%>"failed_updates\%temp_folder_path:\=;%.fold.failed"
IF "%temp_folder_path%"=="tools\gitget" (
	"tools\gitget\SVN\svn.exe" export %folders_url_project_base%/%temp_folder_slash_path% templogs\gitget --force >nul
	IF !errorlevel! NEQ 0 (
		echo Erreur lors de la mise à jour du dossier "%temp_folder_path%", le script va se fermer pour pouvoir relancer le processus de mise à jour lors du prochain redémarrage de celui-ci.
		IF EXIST templogs (
			rmdir /s /q templogs
		)
		pause
		exit
	) else (
		rmdir /s /q "%temp_folder_path%"
		move "templogs\gitget" "%temp_folder_path%"
		del /q "failed_updates\%temp_folder_path:\=;%.folder.failed"
		exit /b
	)
)
rmdir /s /q "%temp_folder_path%"
"tools\gitget\SVN\svn.exe" export %folders_url_project_base%/%temp_folder_slash_path% %temp_folder_path% --force
IF %errorlevel% NEQ 0 (
	echo Erreur lors de la mise à jour du dossier "%temp_folder_path%", le script va se fermer pour pouvoir relancer le processus de mise à jour lors du prochain redémarrage de celui-ci.
	IF EXIST templogs (
		rmdir /s /q templogs
	)
	pause
	exit
)
del /q "failed_updates\%temp_folder_path:\=;%.fold.failed"
exit /b

:compare_version
set update_finded=
IF "%script_version_verif%"=="" exit /b 0
IF "%script_version%"=="" (
	IF NOT "%script_version_verif%"=="" (
		set update_finded=O
		exit /b 1
	) else (
		exit /b 0
	)
)
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

:update_failed_content
set temp_failed_update_path=<"%~1"
set temp_failed_file=%~1
IF "%temp_failed_file:~-11,4%"=="file" (
	set temp_file__path=%temp_failed_update_path%
	set temp_file_slash_path=%temp_failed_update_path:\=/%
	call :update_file
)
IF "%temp_failed_file:~-11,4%"=="fold" (
	set temp_folder_path=%temp_failed_update_path%
	set temp_folder_slash_path=%temp_failed_update_path:\=/%
	call :update_folder
)
exit /b

:update_manager_update_special_script
IF EXIST templogs (
	rmdir /s /q templogs
)
IF NOT EXIST "failed_updates\*.failed" (
	rmdir /s /q failed_updates
)
start "" "%windir%\system32\cmd.exe" "/c start ^"^" ^"tools\Storage\update_manager_updater.bat^""
exit

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
)
IF NOT EXIST "failed_updates\*.failed" (
	rmdir /s /q failed_updates
)
cls
endlocal