::Script by Shadow256
Setlocal enabledelayedexpansion
@echo off
chcp 65001 >nul
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
IF NOT EXIST "tools\android_apps\*.*" (
	del /q "tools\android_apps" 2>nul
	mkdir "tools\android_apps"
)
echo Ce script va servir à installer des applications sur un appareil Android via le mode débogage USB.
echo Si vous ne savez pas comment activer ce mode pour vottre appareil, je vous invite à faire une recherche pour trouver cette information.
echo Notez également que les drivers de votre appareil doivent être installés pour que ceci fonctionne correctement.
echo Enfin, une connexion à Internet peut être requise si vous souhaitez mettre à jour les outils utilisés durant ce script ou bien si c'est la première fois que vous exécutez celui-ci.
pause
IF NOT EXIST "tools\android_tools" (
	echo Les outils nécessaires au bon fonctionnement de ce script ne sont pas installés, ceux-ci vont donc être téléchargés sur le site de Google.
	call :update_adb
	IF !errorlevel! EQU 404 (
		echo Les outils pour installer une application android ne sont pas installés ou n'ont pas pu être installés, le script ne peut continuer.
		goto:end_script
	)
)
:list_aps
copy nul templogs\apps_list.txt >nul
set /a max_apps=1
cd "tools\android_apps"
for %%z in (*.apk) do (
	echo !max_apps!: %%z >>..\..\templogs\apps_list.txt
	set /a max_apps+=1
)
cd ..\..
:select_app
echo Choisir une application à installer. 
echo.
TOOLS\gnuwin32\bin\tail.exe -q -n+0 templogs\apps_list.txt
echo f: Choisir un fichier d'application Android.
echo d: Choisir un dossier contenant des applications Android (les sous-dossiers de celui-ci ne seront pas scannés).
echo u: Mettre à jour les outils permettant d'installer les applications (ADB...).
echo N'importe quel autre choix: Revenir au menu principal. 
echo.
set app_choice=
set /p app_choice=Faites votre choix: 
IF "%app_choice%"=="" goto:finish_script
IF /i "%app_choice%"=="u" (
	call :update_adb
	goto:select_app
)
IF /i "%app_choice%"=="f" (
	%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichier d\'application android (*.apk)|*.apk|" "Sélection de l\'application à installer" "templogs\tempvar.txt"
	set /p app_path=<templogs\tempvar.txt
)
IF /i "%app_choice%"=="f" (
	IF "%app_path%"=="" (
		echo Aucune application sélectionnée, retour à la sélection d'applications.
		set app_choice=
		goto:select_app
	)
	goto:install_app
)
IF /i "%app_choice%"=="d" (
	%windir%\system32\wscript.exe //Nologo tools\Storage\functions\select_dir.vbs "templogs\tempvar.txt"
	set /p app_path=<templogs\tempvar.txt
	IF NOT "!app_path!"=="" (
		set app_path=!app_path!\
		set app_path=!app_path:\\=\!
		goto:install_app
	) else (
		echo Aucun dossier d'applications sélectionné, retour à la sélection d'applications.
		set app_choice=
		goto:select_app
	)
)
tools\gnuwin32\bin\grep.exe "%app_choice%: " <templogs\apps_list.txt | TOOLS\gnuwin32\bin\cut.exe -d : -f 2 > templogs\tempvar.txt
set /p app_path=<templogs\tempvar.txt
IF "%app_path%"=="" (
	goto:finish_script
)
set app_path=%app_path:~1,-1%
:install_app
IF /i "%app_choice%"=="f" (
	tools\android_tools\adb.exe -d install -r "%app_path%"
) else IF /i "%app_choice%"=="d" (
	call :install_folder_apps "%app_path%"
) else (
	tools\android_tools\adb.exe -d install -r "tools\android_apps\%app_path%"
)
IF %errorlevel% GTR 0 (
	echo Une erreur s'est produite pendant l'installation de l'application. Vérifiez que le mode développeur est bien actif sur l'appareil Android et que le débogage USB est activé.
) else (
	echo ********************************************* 
	echo ***            Application installée            *** 
	echo ********************************************* 
)
tools\android_tools\adb.exe kill-server
goto:end_script

:install_folder_apps
for %%f in ("%~1*.apk") do (
	tools\android_tools\adb.exe -d install -r "%%f"
)
exit /b

:update_adb
echo Mise à jour des outils en cours...
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	echo Aucune connexion à internet disponible, le script ne peux télécharger la mise à jour des outils.
	exit /b 404
)
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "templogs\adb.zip" https://dl.google.com/android/repository/platform-tools-latest-windows.zip 2>nul
IF %errorlevel% NEQ 0 (
	title Shadow256 Ultimate Switch Hack Script %ushs_version%
	echo Erreur pendant le téléchargement du fichier de mise à jour des outils.
	exit /b 404
)
title Shadow256 Ultimate Switch Hack Script %ushs_version%
tools\7zip\7za.exe x -y -sccUTF-8 "templogs\adb.zip" -o"templogs" -r
IF %errorlevel% NEQ 0 (
	echo Erreur durant l'extraction du fichier téléchargé.
	exit /b 404
)
del /q templogs\adb.zip"
IF EXIST "tools\android_tools" rmdir /s /q "tools\android_tools"
move "templogs\platform-tools" "tools\android_tools"
echo Mise à jour des outils effectuée.
exit /b

:end_script
pause 
:finish_script
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal