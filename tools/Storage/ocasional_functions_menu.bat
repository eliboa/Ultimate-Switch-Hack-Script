::Script by Shadow256
chcp 65001 > nul
setlocal
:define_action_choice
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Récupérer les Biskey dans un fichier texte?
echo.
echo 2: Mettre à jour Shofel2?
echo.
echo 3: Installer les drivers pour la Switch?
echo.
echo 4: Créer un package de mise à jour de la Switch via ChoiDuJour via un fichier ou un dossier déjà téléchargé??
echo.
echo 5: Vérifier si des numéros de série de consoles sont patchées ou non?
echo.
echo 6: Vérifier un fichier de clés?
echo.
echo 7: Nand toolbox?
echo.
echo 8: Utiliser le compagnon pour Hid-mitm?
echo.
echo N'importe quelle autre choix: Revenir au menu précédent?
echo.
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
IF "%action_choice%"=="1" goto:biskey_dump
IF "%action_choice%"=="2" goto:update_shofel2
IF "%action_choice%"=="3" goto:install_drivers
IF "%action_choice%"=="4" goto:create_update
IF "%action_choice%"=="5" goto:verif_serials
IF "%action_choice%"=="6" goto:test_keys
IF "%action_choice%"=="7" goto:nand_toolbox
IF "%action_choice%"=="8" goto:hid-mitm_compagnon
goto:end_script
:biskey_dump
set action_choice=
echo.
call TOOLS\Storage\biskey_dump.bat
@echo off
goto:define_action_choice
:update_shofel2
set action_choice=
echo.
call TOOLS\Storage\update_shofel2.bat
@echo off
goto:define_action_choice
:install_drivers
set action_choice=
echo.
call TOOLS\Storage\install_drivers.bat
@echo off
goto:define_action_choice
:create_update
set action_choice=
echo.
call TOOLS\Storage\create_update.bat
@echo off
goto:define_action_choice
:verif_serials
set action_choice=
echo.
call TOOLS\Storage\serial_checker.bat
@echo off
goto:define_action_choice
:test_keys
set action_choice=
echo.
call TOOLS\Storage\test_keys.bat
@echo off
goto:define_action_choice
:nand_toolbox
set action_choice=
echo.
call TOOLS\Storage\nand_toolbox.bat
@echo off
goto:define_action_choice
:hid-mitm_compagnon
set action_choice=
echo.
call tools\Hid-mitm_compagnon\start.bat
@echo off
goto:define_action_choice
:end_script
endlocal