::Script by Shadow256
chcp 65001 > nul
IF EXIST log.txt del /q log.txt
set ushs_launch=Y
:define_action_choice
set action_choice=
cls
::Header
title Shadow256 Ultimate Switch Hack Script %ushs_version%
echo :::::::::::::::::::::::::::::::::::::
echo ::Shadow256 Ultimate Switch Hack Script %ushs_version%::
echo :::::::::::::::::::::::::::::::::::::
echo.
echo Menu principal
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Lancer un payload via le mode RCM?
echo.
echo 2: Lancer un payload via PegaScape/PegaSwitch et/ou préparer le nécessaire sur la SD pour que cela fonctionne?
echo.
echo 3: Monter la nand, la partition boot0, la partition boot1 ou la carte SD comme un disque dur sur votre système d'exploitation?
echo.
echo 4: Préparer une carte SD pour le hack Switch?
echo.
echo 5: Nand toolbox?
echo.
echo 6: Lancer NSC_Builder qui permet d'avoir des infos, de convertir et de nettoyer des NSPs et XCIs, voir la documentation pour plus d'infos?
echo.
echo 7: Lancer ou configurer la boîte à outils?
echo.
echo 8: Autres fonctions?
echo.
echo 9: Fonctions à utiliser occasionnellement?
echo.
echo 10: Sauvegarde/restauration et paramètres du script?
echo.
echo 11: Lancer ou configurer le client pour pouvoir jouer en réseau (serveur Switch-Lan-Play)?
echo.
echo 12: Lancer un serveur pour le jeu en réseau (serveur Switch-Lan-Play)?
echo.
echo 13: A propos du script?
echo.
echo 14: Ouvrir la page permettant de me faire une donation?
echo.
echo 0: Lancer la documentation (recommandé)?
echo.
echo N'importe quelle autre choix: Quitter sans rien faire?
echo.
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
IF "%action_choice%"=="0" goto:launch_doc
IF "%action_choice%"=="1" goto:launch_payload
IF "%action_choice%"=="2" goto:pegaswitch
IF "%action_choice%"=="3" goto:mount_discs
IF "%action_choice%"=="4" goto:prepare_sd
IF "%action_choice%"=="5" goto:nand_toolbox
IF "%action_choice%"=="6" goto:launch_NSC_Builder
IF "%action_choice%"=="7" goto:launch_toolbox
IF "%action_choice%"=="8" goto:others_functions
IF "%action_choice%"=="9" goto:ocasional_functions
IF "%action_choice%"=="10" goto:settings
IF "%action_choice%"=="11" goto:client_netplay
IF "%action_choice%"=="12" goto:server_netplay
IF "%action_choice%"=="13" goto:about
IF "%action_choice%"=="14" (
	set action_choice=
	cls
	start https://www.paypal.me/shadow256
	goto:define_action_choice
)
goto:end_script
:launch_payload
set action_choice=
echo.
cls
IF EXIST "tools\Storage\launch_payload.bat" (
	call tools\Storage\update_manager.bat "update_launch_payload.bat"
) else (
	call tools\Storage\update_manager.bat "update_launch_payload.bat" "force"
)
call tools\Storage\launch_payload.bat
@echo off
goto:define_action_choice
:pegaswitch
set action_choice=
echo.
cls
IF EXIST "tools\Storage\pegaswitch.bat" (
	call tools\Storage\update_manager.bat "update_pegaswitch.bat"
) else (
	call tools\Storage\update_manager.bat "update_pegaswitch.bat" "force"
)
call tools\Storage\pegaswitch.bat
@echo off
goto:define_action_choice
:mount_discs
set action_choice=
echo.
cls
IF EXIST "tools\Storage\mount_discs.bat" (
	call tools\Storage\update_manager.bat "update_mount_discs.bat"
) else (
	call tools\Storage\update_manager.bat "update_mount_discs.bat" "force"
)
call tools\Storage\mount_discs.bat
@echo off
goto:define_action_choice
:prepare_sd
set action_choice=
echo.
cls
IF EXIST "tools\Storage\prepare_sd_switch.bat" (
	call tools\Storage\update_manager.bat "update_prepare_sd_switch.bat"
) else (
	call tools\Storage\update_manager.bat "update_prepare_sd_switch.bat" "force"
)
call tools\Storage\prepare_sd_switch.bat
@echo off
goto:define_action_choice
:nand_toolbox
set action_choice=
echo.
cls
IF EXIST "tools\Storage\nand_toolbox.bat" (
	call tools\Storage\update_manager.bat "update_nand_toolbox.bat"
) else (
	call tools\Storage\update_manager.bat "update_nand_toolbox.bat" "force"
)
call tools\Storage\nand_toolbox.bat
@echo off
goto:define_action_choice
:launch_NSC_Builder
set action_choice=
echo.
cls
IF EXIST "tools\Storage\preload_NSC_Builder.bat" (
	call tools\Storage\update_manager.bat "update_preload_NSC_Builder.bat"
) else (
	call tools\Storage\update_manager.bat "update_preload_NSC_Builder.bat" "force"
)
call tools\Storage\preload_NSC_Builder.bat
@echo off
goto:define_action_choice
:launch_toolbox
set action_choice=
echo.
cls
IF EXIST "tools\Storage\toolbox.bat" (
	call tools\Storage\update_manager.bat "update_toolbox.bat"
) else (
	call tools\Storage\update_manager.bat "update_toolbox.bat" "force"
)
call tools\Storage\toolbox.bat
@echo off
goto:define_action_choice
:others_functions
set action_choice=
echo.
cls
call tools\Storage\others_functions_menu.bat
@echo off
goto:define_action_choice
:ocasional_functions
set action_choice=
echo.
cls
call tools\Storage\ocasional_functions_menu.bat
@echo off
goto:define_action_choice
:settings
set action_choice=
echo.
cls
call tools\Storage\settings_menu.bat
@echo off
goto:define_action_choice
:client_netplay
set action_choice=
echo.
cls
IF EXIST "tools\Storage\netplay.bat" (
	call tools\Storage\update_manager.bat "update_netplay.bat"
) else (
	call tools\Storage\update_manager.bat "update_netplay.bat" "force"
)
call tools\Storage\netplay.bat
@echo off
goto:define_action_choice
:server_netplay
set action_choice=
echo.
cls
IF EXIST "tools\Storage\launch_switch_lan_play_server.bat" (
	call tools\Storage\update_manager.bat "update_launch_switch_lan_play_server.bat"
) else (
	call tools\Storage\update_manager.bat "update_launch_switch_lan_play_server.bat" "force"
)
call tools\Storage\launch_switch_lan_play_server.bat
@echo off
goto:define_action_choice
:launch_doc
set action_choice=
echo.
cls
start DOC\index.html
goto:define_action_choice
:about
set action_choice=
echo.
cls
call tools\Storage\about.bat
@echo off
goto:define_action_choice
:end_script
exit