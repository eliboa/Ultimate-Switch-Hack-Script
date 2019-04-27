::Script by Shadow256
chcp 65001 > nul
IF EXIST log.txt del /q log.txt
set ushs_launch=Y
cls
::Header
title Shadow256 Ultimate Switch Hack Script %ushs_version%
echo :::::::::::::::::::::::::::::::::::::
echo ::Shadow256 Ultimate Switch Hack Script %ushs_version%::
echo :::::::::::::::::::::::::::::::::::::
:define_action_choice
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Lancer un payload?
echo.
echo 2: Lancer ou configurer la boîte à outils?
echo.
echo 3: Monter la nand, la partition boot0, la partition boot1 ou la carte SD comme un disque dur sur votre système d'exploitation?
echo.
echo 4: Préparer une carte SD pour le hack Switch?
echo.
echo 5: Lancer NSC_Builder qui permet d'avoir des infos, de convertir et de nettoyer des NSPs et XCIs, voir la documentation pour plus d'infos?
echo.
echo 6: Autres fonctions?
echo.
echo 7: Fonctions à utiliser occasionnellement?
echo.
echo 8: Sauvegarde/restauration et paramètres du script?
echo.
echo 9: Lancer ou configurer le client pour pouvoir jouer en réseau (serveur Switch-Lan-Play)?
echo.
echo 10: Lancer un serveur pour le jeu en réseau (serveur Switch-Lan-Play)?
echo.
echo 11: Lancer Linux?
echo.
echo 12: Vérifier s'il existe une mise à jour du script?
echo.
echo 13: A propos du script?
echo.
echo 0: Lancer la documentation (recommandé)?
echo.
echo N'importe quelle autre choix: Quitter sans rien faire?
echo.
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
IF "%action_choice%"=="0" goto:launch_doc
IF "%action_choice%"=="1" goto:launch_payload
IF "%action_choice%"=="2" goto:launch_toolbox
IF "%action_choice%"=="3" goto:mount_discs
IF "%action_choice%"=="4" goto:prepare_sd
IF "%action_choice%"=="5" goto:launch_NSC_Builder
IF "%action_choice%"=="6" goto:others_functions
IF "%action_choice%"=="7" goto:ocasional_functions
IF "%action_choice%"=="8" goto:save_and_restaure
IF "%action_choice%"=="9" goto:client_netplay
IF "%action_choice%"=="10" goto:server_netplay
IF "%action_choice%"=="11" goto:launch_linux
IF "%action_choice%"=="12" goto:check_update
IF "%action_choice%"=="13" goto:about
goto:end_script
:launch_payload
set action_choice=
echo.
call TOOLS\Storage\launch_payload.bat > log.txt 2>&1
@echo off
goto:define_action_choice
:launch_toolbox
set action_choice=
echo.
call TOOLS\Storage\toolbox.bat
@echo off
goto:define_action_choice
:mount_discs
set action_choice=
echo.
call TOOLS\Storage\mount_discs.bat
@echo off
goto:define_action_choice
:prepare_sd
set action_choice=
echo.
call TOOLS\Storage\prepare_sd_switch.bat
@echo off
goto:define_action_choice
:launch_NSC_Builder
set action_choice=
echo.
call TOOLS\Storage\preload_NSC_Builder.bat
endlocal
@echo off
goto:define_action_choice
:others_functions
set action_choice=
echo.
call TOOLS\Storage\others_functions_menu.bat
@echo off
goto:define_action_choice
:ocasional_functions
set action_choice=
echo.
call TOOLS\Storage\ocasional_functions_menu.bat
@echo off
goto:define_action_choice
:save_and_restaure
set action_choice=
echo.
call TOOLS\Storage\save_and_restaure_menu.bat
@echo off
goto:define_action_choice
:client_netplay
set action_choice=
echo.
call TOOLS\Storage\netplay.bat
@echo off
goto:define_action_choice
:server_netplay
set action_choice=
echo.
call TOOLS\Storage\launch_switch_lan_play_server.bat
@echo off
goto:define_action_choice
:launch_linux
set action_choice=
echo.
call TOOLS\Storage\launch_linux.bat
@echo off
goto:define_action_choice
:check_update
set action_choice=
echo.
set force_update=1
call TOOLS\Storage\verif_update.bat
set force_update=
@echo off
goto:define_action_choice
:launch_doc
set action_choice=
echo.
start DOC\index.html
goto:define_action_choice
:about
set action_choice=
echo.
call TOOLS\Storage\about.bat
@echo off
goto:define_action_choice
:end_script
exit