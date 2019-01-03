::Script by Shadow256
chcp 65001 > nul
setlocal
:define_action_choice
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
echo 9: Joindre les différentes parties d'un dump de la nand effectué par Hekate si cette fonctionnalité s'est activée dans celui-ci (le dump de la nand de SX OS est également supportée)?
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
IF "%action_choice%"=="9" goto:nand_joiner
goto:end_script
:update_on_sd
set action_choice=
echo.
call TOOLS\Storage\prepare_update_on_sd.bat
@echo off
goto:define_action_choice
:convert_game
set action_choice=
echo.
call TOOLS\Storage\convert_game_to_nsp.bat
@echo off
goto:define_action_choice
:install_nsp_network
set action_choice=
echo.
call TOOLS\Storage\install_nsp_network.bat
@echo off
goto:define_action_choice
:install_nsp_usb
set action_choice=
echo.
call TOOLS\Storage\install_nsp_usb.bat
@echo off
goto:define_action_choice
:convert_BOTW
set action_choice=
echo.
call TOOLS\Storage\convert_BOTW.bat
@echo off
goto:define_action_choice
:extract_cert
set action_choice=
echo.
call TOOLS\Storage\extract_cert.bat
@echo off
goto:define_action_choice
:verify_nsp
set action_choice=
echo.
call TOOLS\Storage\verify_nsp.bat
@echo off
goto:define_action_choice
:split_games
set action_choice=
echo.
call TOOLS\Storage\split_games.bat
@echo off
goto:define_action_choice
:nand_joiner
set action_choice=
echo.
call TOOLS\Storage\nand_joiner.bat
@echo off
goto:define_action_choice
:end_script
endlocal