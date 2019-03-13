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
echo 4: Réinitialiser le paramètre de mise à jour automatique du script?
echo.
echo 5: Réinitialiser la liste de programmes personnels de la Toolbox (supprimera également les programmes incluent dans le dossier "tools\toolbox")?
echo.
echo 6: Réinitialiser la liste de serveurs de Switch-Lan-Play?
echo.
echo 7: Supprimer le fichiers de clés utilisé par NSC_Builder?
echo.
echo 8: Supprimer les fichiers de clés utilisés par Hactool, XCI-Explorer, ChoiDuJour...?
echo.
echo 9: Configurer les profiles de copie de homebrews lors de la préparation d'une SD?
echo.
echo 10: Configurer les profiles de copie de cheats lors de la préparation d'une SD?
echo.
echo N'importe quelle autre choix: Revenir au menu précédent?
echo.
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
IF "%action_choice%"=="1" goto:save_config
IF "%action_choice%"=="2" goto:restaure_config
IF "%action_choice%"=="3" goto:restaure_default
IF "%action_choice%"=="4" goto:default_auto_update
IF "%action_choice%"=="5" goto:default_toolbox
IF "%action_choice%"=="6" goto:default_switch-lan-play
IF "%action_choice%"=="7" goto:default_keys_nsc_builder
IF "%action_choice%"=="8" goto:default_keys_hactool
IF "%action_choice%"=="9" goto:mixed_packs_profiles_management
IF "%action_choice%"=="10" goto:cheats_profiles_management
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
:default_auto_update
set action_choice=
echo.
del /q tools\Storage\verif_update.ini 2>nul
echo Paramètre de mise à jour automatique réinitialisé.
goto:define_action_choice
:default_toolbox
set action_choice=
echo.
rmdir /s /q tools\toolbox
mkdir tools\toolbox
copy tools\default_configs\default_tools.txt tools\toolbox\default_tools.txt
copy nul tools\toolbox\user_tools.txt
echo Programmes personnels de la Toolbox réinitialisés.
goto:define_action_choice
:default_switch-lan-play
set action_choice=
echo.
copy /v "tools\default_configs\servers_list.txt" "tools\netplay\servers_list.txt"
echo Liste de serveurs Switch-Lan-Play réinitialisée.
goto:define_action_choice
:default_keys_nsc_builder
:default_switch-lan-play
set action_choice=
echo.
del /q "tools\NSC_Builder\keys.txt" 2>nul
echo Fichier de clés pour NSC_Builder supprimé.
goto:define_action_choice
:default_keys_hactool
set action_choice=
echo.
del /q "tools\Hactool_based_programs\keys.txt" 2>nul
del /q "tools\Hactool_based_programs\keys.dat" 2>nul
echo Fichiers de clés pour les outils basés sur Hactool supprimés.
goto:define_action_choice
:mixed_packs_profiles_management
set action_choice=
echo.
call TOOLS\Storage\mixed_pack_profiles_management.bat
rmdir /s /q templogs
@echo off
goto:define_action_choice
:cheats_profiles_management
set action_choice=
echo.
call TOOLS\Storage\cheats_profiles_management.bat
rmdir /s /q templogs
@echo off
goto:define_action_choice
:end_script
endlocal