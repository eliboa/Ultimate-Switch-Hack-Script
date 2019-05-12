@echo off
chcp 65001 >nul
setlocal
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
:define_action_choice
cls
echo.
echo A propos:
echo.
echo Version actuelle du script: %ushs_version%
echo Version actuelle des packs: %ushs_packs_version%
echo Version actuelle du pack de cheats: %ushs_cheats_version%
echo.
echo Licence GPL V3 pour mon travail (shadow256 sur les forums et shadow2560 sur Github), le reste est sous la licence des auteurs de celui-ci.
echo.
echo Que souhaitez-vous faire?
echo 1: Afficher le changelog du script le plus récent?
echo 2: Afficher le changelog des packs le plus récent?
echo N'importe quel autre choix: Revenir au menu principal.
echo.
set action_choice=
set /p action_choice=Faites votre choix: 
IF "%action_choice%"=="1" goto:display_changelog_general
IF "%action_choice%"=="2" goto:display_changelog_packs
goto:end_script
:display_changelog_general
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	echo Aucune connexion à internet disponible, impossible d'afficher cette information.
	goto:define_action_choice
)
tools\gnuwin32\bin\wget.exe --no-check-certificate --content-disposition -S -O "templogs\changelog.html" https://raw.githubusercontent.com/shadow2560/Ultimate-Switch-Hack-Script/master/DOC/files/changelog.html
title Shadow256 Ultimate Switch Hack Script %ushs_version%
start explorer.exe templogs\changelog.html
goto:define_action_choice
:display_changelog_packs
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	echo Aucune connexion à internet disponible, impossible d'afficher cette information.
	goto:define_action_choice
)
tools\gnuwin32\bin\wget.exe --no-check-certificate --content-disposition -S -O "templogs\changelog.html" https://raw.githubusercontent.com/shadow2560/Ultimate-Switch-Hack-Script/master/DOC/files/packs_changelog.html
title Shadow256 Ultimate Switch Hack Script %ushs_version%
start explorer.exe templogs\changelog.html
goto:define_action_choice
:end_script
rmdir /s /q templogs 2>nul
cls
endlocal