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
echo Version actuelle des packs du script: %ushs_packs_version%
echo.
echo Licence GPL V3 pour mon travail (shadow256 sur les forums et shadow2560 sur Github), le reste est sous la licence des auteurs de celui-ci.
echo.
echo Note: Vous devrez  faire deux fois l'action de mise à jour souhaitée si une mise à jour du gestionnaire de mises à jour est trouvée durant la procédure.
echo Que souhaitez-vous faire?
echo 1: Afficher le changelog du script le plus récent?
echo 2: Afficher le changelog des packs le plus récent?
echo 3: Mettre à jour tous les éléments du script pouvant être mis à jour (méthode recommandé) (le script se fermera après la mise à jour et devra être redémarré)?
echo 4: Mettre à jour l'ensemble du script (dernier recours)  (le script se fermera après la mise à jour et devra être redémarré)?
echo 5: Me faire une donation?
echo N'importe quel autre choix: Revenir au menu principal.
echo.
set action_choice=
set /p action_choice=Faites votre choix: 
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
	echo Aucune connexion à internet disponible, impossible d'afficher cette information.
	goto:define_action_choice
)
tools\gnuwin32\bin\wget.exe --no-check-certificate --content-disposition -S -O "templogs\changelog.html" https://github.com/shadow2560/Ultimate-Switch-Hack-Script/raw/master/DOC/files/changelog.html
title Shadow256 Ultimate Switch Hack Script %ushs_version%
start explorer.exe templogs\changelog.html
goto:define_action_choice
:display_changelog_packs
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	echo Aucune connexion à internet disponible, impossible d'afficher cette information.
	goto:define_action_choice
)
tools\gnuwin32\bin\wget.exe --no-check-certificate --content-disposition -S -O "templogs\changelog.html" https://github.com/shadow2560/Ultimate-Switch-Hack-Script/raw/master/DOC/files/packs_changelog.html
title Shadow256 Ultimate Switch Hack Script %ushs_version%
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