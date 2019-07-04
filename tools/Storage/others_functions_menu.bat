::Script by Shadow256
chcp 65001 > nul
setlocal
:define_action_choice
set action_choice=
cls
echo Menu des autres fonctionnalités
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Préparer une mise à jour via ChoiDuJour-NX sur la SD et/ou un package de mise à jour via ChoiDuJour en téléchargeant le firmware via internet?
echo.
echo 2: Convertir un fichier XCI ou NCA en NSP?
echo.
echo 3: Installer des NSP via Goldleaf et le réseau.
echo.
echo 4: Installer des NSP via Goldleaf et l'USB.
echo.
echo 5: Convertir une sauvegarde de Zelda Breath Of The Wild du format Wii U vers Switch ou inversement?
echo.
echo 6: Extraire le certificat d'une console?
echo.
echo 7: Vérifier des fichiers NSP?
echo.
echo 8: Découper un fichier NSP ou XCI en fichiers de 4 GO?
echo.
echo 9: Compresser/décompresser un jeu grâce à nsZip?
echo.
echo 10: Configurer l'émulateur Nes Classic Edition?
echo.
echo 11: Configurer l'émulateur Snes Classic Edition?
echo.
echo 12: Installer des applications Android (mode débogage USB requis)?
echo.
echo N'importe quelle autre choix: Revenir au menu précédent?
echo.
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
IF "%action_choice%"=="1" goto:update_on_sd
IF "%action_choice%"=="2" goto:convert_game
IF "%action_choice%"=="3" goto:install_nsp_network
IF "%action_choice%"=="4" goto:install_nsp_usb
IF "%action_choice%"=="5" goto:convert_BOTW
IF "%action_choice%"=="6" goto:extract_cert
IF "%action_choice%"=="7" goto:verify_nsp
IF "%action_choice%"=="8" goto:split_games
IF "%action_choice%"=="9" goto:nsZip
IF "%action_choice%"=="10" goto:config_nes_classic
IF "%action_choice%"=="11" goto:config_snes_classic
IF "%action_choice%"=="12" goto:install_android_apps
goto:end_script
:update_on_sd
set action_choice=
echo.
cls
IF EXIST "tools\Storage\prepare_update_on_sd.bat" (
	call tools\Storage\update_manager.bat "update_prepare_update_on_sd.bat"
) else (
	call tools\Storage\update_manager.bat "update_prepare_update_on_sd.bat" "force"
)
call TOOLS\Storage\prepare_update_on_sd.bat
@echo off
goto:define_action_choice
:convert_game
set action_choice=
echo.
cls
IF EXIST "tools\Storage\convert_game_to_nsp.bat" (
	call tools\Storage\update_manager.bat "update_convert_game_to_nsp.bat"
) else (
	call tools\Storage\update_manager.bat "update_convert_game_to_nsp.bat" "force"
)
call TOOLS\Storage\convert_game_to_nsp.bat
@echo off
goto:define_action_choice
:install_nsp_network
set action_choice=
echo.
cls
IF EXIST "tools\Storage\install_nsp_network.bat" (
	call tools\Storage\update_manager.bat "update_install_nsp_network.bat"
) else (
	call tools\Storage\update_manager.bat "update_install_nsp_network.bat" "force"
)
call TOOLS\Storage\install_nsp_network.bat
@echo off
goto:define_action_choice
:install_nsp_usb
set action_choice=
echo.
cls
IF EXIST "tools\Storage\install_nsp_usb.bat" (
	call tools\Storage\update_manager.bat "update_install_nsp_usb.bat"
) else (
	call tools\Storage\update_manager.bat "update_install_nsp_usb.bat" "force"
)
call TOOLS\Storage\install_nsp_usb.bat
@echo off
goto:define_action_choice
:convert_BOTW
set action_choice=
echo.
cls
IF EXIST "tools\Storage\convert_BOTW.bat" (
	call tools\Storage\update_manager.bat "update_convert_BOTW.bat"
) else (
	call tools\Storage\update_manager.bat "update_convert_BOTW.bat" "force"
)
call TOOLS\Storage\convert_BOTW.bat
@echo off
goto:define_action_choice
:extract_cert
set action_choice=
echo.
cls
IF EXIST "tools\Storage\extract_cert.bat" (
	call tools\Storage\update_manager.bat "update_extract_cert.bat"
) else (
	call tools\Storage\update_manager.bat "update_extract_cert.bat" "force"
)
call TOOLS\Storage\extract_cert.bat
@echo off
goto:define_action_choice
:verify_nsp
set action_choice=
echo.
cls
IF EXIST "tools\Storage\verify_nsp.bat" (
	call tools\Storage\update_manager.bat "update_verify_nsp.bat"
) else (
	call tools\Storage\update_manager.bat "update_verify_nsp.bat" "force"
)
call TOOLS\Storage\verify_nsp.bat
@echo off
goto:define_action_choice
:split_games
set action_choice=
echo.
cls
IF EXIST "tools\Storage\split_games.bat" (
	call tools\Storage\update_manager.bat "update_split_games.bat"
) else (
	call tools\Storage\update_manager.bat "update_split_games.bat" "force"
)
call TOOLS\Storage\split_games.bat
@echo off
goto:define_action_choice
:nsZip
set action_choice=
echo.
cls
IF EXIST "tools\Storage\nsZip.bat" (
	call tools\Storage\update_manager.bat "update_nsZip.bat"
) else (
	call tools\Storage\update_manager.bat "update_nsZip.bat" "force"
)
call TOOLS\Storage\nsZip.bat
@echo off
goto:define_action_choice
:config_nes_classic
set action_choice=
echo.
cls
IF EXIST "tools\NES_Injector\*.*" (
	call tools\Storage\update_manager.bat "update_NES_Injector"
) else (
	call tools\Storage\update_manager.bat "update_NES_Injector" "force"
)
call TOOLS\NES_Injector\NES_Injector.bat
@echo off
goto:define_action_choice
:config_snes_classic
set action_choice=
echo.
cls
IF EXIST "tools\SNES_Injector\*.*" (
	call tools\Storage\update_manager.bat "update_SNES_Injector"
) else (
	call tools\Storage\update_manager.bat "update_SNES_Injector" "force"
)
call TOOLS\SNES_Injector\SNES_Injector.bat
@echo off
goto:define_action_choice
:install_android_apps
set action_choice=
echo.
cls
IF EXIST "tools\Storage\android_installer.bat" (
	call tools\Storage\update_manager.bat "update_android_installer.bat"
) else (
	call tools\Storage\update_manager.bat "update_android_installer.bat" "force"
)
call TOOLS\Storage\android_installer.bat
@echo off
goto:define_action_choice
:end_script
endlocal