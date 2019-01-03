::Script by Shadow256
chcp 65001 > nul
setlocal
:define_action_choice
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Sauvegarder les fichiers importants du script?
echo.
echo 2: Restaurer les fichiers importants du script?
echo.
echo 3: Réinitialiser complètement le script?
echo.
echo N'importe quelle autre choix: Revenir au menu précédent?
echo.
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
IF "%action_choice%"=="1" goto:save_config
IF "%action_choice%"=="2" goto:restaure_config
IF "%action_choice%"=="3" goto:restaure_default
goto:end_script
:save_config
set action_choice=
echo.
call TOOLS\Storage\save_configs.bat
@echo off
goto:define_action_choice
:restaure_config
set action_choice=
echo.
call TOOLS\Storage\restore_configs.bat
@echo off
goto:define_action_choice
:restaure_default
set action_choice=
echo.
call TOOLS\Storage\restore_default.bat
@echo off
goto:define_action_choice
:end_script
endlocal