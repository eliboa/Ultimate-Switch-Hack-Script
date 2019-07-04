::Script by Shadow256
Setlocal enabledelayedexpansion
@echo off
chcp 65001 >nul
echo é >nul
title Shadow256 Ultimate Switch Hack Script %ushs_version%
echo :::::::::::::::::::::::::::::::::::::
echo ::Shadow256 Ultimate Switch Hack Script %ushs_version% updater::
echo.
set base_script_path="%~dp0\..\.."
set folders_url_project_base=https://github.com/shadow2560/Ultimate-Switch-Hack-Script/trunk
set files_url_project_base=https://github.com/shadow2560/Ultimate-Switch-Hack-Script/raw/master
IF EXIST "templogs" (
	del /q "templogs" 2>nul
	rmdir /s /q "templogs" 2>nul
)
mkdir "templogs"
IF NOT EXIST "failed_updates\*.failed" (
	rmdir /s /q "failed_updates" 2>nul
)
mkdir "failed_updates" >nul
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	echo Aucune connexion à internet disponible, le script ne peux vérifier les mises à jour.
	pause
	goto_end_script
)
:new_script_install
IF "%~1"=="update_all" goto:skip_new_script_install
IF "%~1"=="general_content_update" goto:skip_new_script_install
IF "%~2"=="force" (
	call :verif_file_version "tools\Storage\update_manager.bat"
	IF !errorlevel! EQU 1 (
		call :verif_file_version "tools\Storage\update_manager_updater.bat"
		IF !errorlevel! EQU 1 (
			call :update_file
		)
		echo Le gestionnaire de mises à jour doit se mettre à jour lui-même avant de pouvoir continuer.
		echo Pour se faire, le script va lancer un autre script puis se fermer pour que la mise à jour puisse s'effectuer correctement.
		echo Une fois la mise à jour effectuée, le script va redémarré.
		pause
		call :update_manager_update_special_script
	)
	echo Attention, il semble que vous souhaitiez utiliser une fonctionnalité non installée.
	echo De fait, l'installation de celle-ci va être forcée si vous choisissez d'accepter cette installation, une connexion internet est nécessaire.
	echo Si vous ne pouvez pas utiliser internet, la fonctionnalité ne se lancera pas après cette tentative d'installation et des bugs pourraienent se produire donc dans ce cas il est fortement conseillé de refuser le choix qui va suivre et le script se fermera pour plus de sécurité.
	set new_install_choice=
	set /p new_install_choice=Souhaitez-vous lancer l'installation? ^(O/n^): 
	IF NOT "!new_install_choice!"=="" set new_install_choice=!new_install_choice:~0,1!
	IF /i NOT "!new_install_choice!"=="o" (
		IF EXIST templogs (
			rmdir /s /q templogs
		)
		IF NOT EXIST "failed_updates\*.failed" (
			rmdir /s /q failed_updates
	)
		exit
	)
)
:skip_new_script_install
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	echo Aucune connexion internet vérifiable, tentative de mise à jour arrêtée.
	IF /i "%new_install_choice%"=="o" (
		echo De plus, ceci était une tentative d'installation d'une nouvelle fonctionnalité, le script va donc se fermer pour plus de sécurité.
		pause
		IF EXIST templogs (
			rmdir /s /q templogs
		)
		IF NOT EXIST "failed_updates\*.failed" (
			rmdir /s /q failed_updates
		)
		exit
	)
	goto:end_script
)
:failed_updates_verification
IF NOT EXIST "failed_updates\*.failed" goto:skip_failed_updates_verification
IF EXIST "failed_updates\update_manager.bat.file.failed" (
		call :verif_file_version "tools\Storage\update_manager_updater.bat"
IF !errorlevel! EQU 1 (
	call :update_file
)
	echo Le gestionnaire de mises à jour doit se mettre à jour lui-même avant de pouvoir continuer car sa mise à jour précédente semble avoir échouée.
	echo Pour se faire, le script va lancer un autre script puis se fermer pour que la mise à jour puisse s'effectuer correctement.
	echo Une fois la mise à jour effectuée, le script va redémarré.
	pause
	call :update_manager_update_special_script
)
for %%f in (failed_updates\*.failed) do (
	call :update_failed_content "%%f"
)
:skip_failed_updates_verification
IF "%~2"=="force" goto:start_verif_update
IF /i "%new_install_choice%"=="o" goto:start_verif_update
:verif_auto_update_ini
IF EXIST tools\Storage\verif_update.ini\*.* (
	rmdir /s /q tools\Storage\verif_update.ini
)
IF not EXIST tools\Storage\verif_update.ini copy nul tools\Storage\verif_update.ini >nul
tools\gnuwin32\bin\grep.exe -m 1 "auto_update" <tools\Storage\verif_update.ini | tools\gnuwin32\bin\cut.exe -d = -f 2 >templogs\tempvar.txt
set /p ini_auto_update=<templogs\tempvar.txt
:initialize_auto_update
IF "%ini_auto_update%"=="" (
	echo Réglage de la mise à jour automatique:
	echo.
	echo La mise à jour automatique intervient lors du démarrage des différentes fonctionnalités ou grands groupes de fonctionnalités du script. Si vous tentez de mettre à jour une fonctionnalité qui n'est pas encore installée, son installation sera forcée même en cas de désactivation de la mise à jour automatique.
	echo Dans les choix qui vont suivre, si vous ne faites pas un choix définitif, cette question sera donc souvent posée.
	echo Si vous choisissez de toujours vérifier les mises à jour, certaines fonctionnalités mettront un peu de temps à se lancer, notemment le démarrage du menu principal ou encore la préparation d'une SD ou la Nand Toolbox car ces fonctionnalités ont beaucoup de dépendances mais vous aurez toujours les dernières versions des fonctionnalités que vous utilisez et le reste ne bougera pas tant que vous ne l'aurez pas utilisé au moins une fois.
	echo Au contraire, si vous choisissez de ne jamais mettre à jour, vous ne pourrez que faire la mise à jour de tous les éléments du script d'un coup via le menu "A propos" mais le lancement des fonctionnalités sera bien plus rapide.
	echo Notez que vous pouvez toujours réinitialiser cette valeur en passant par le menu des paramètres du script.
	echo Notez également que même en cas de désactivation de la mise à jour automatique et si vous faites une mise à jour manuelle qui a échouée, celle-ci sera reprise automatiquement pour éviter des bugs dans le script.
	echo.
	echo Que souhaitez-vous faire?
	echo O: Vérifier les mises à jour cette fois-ci.
	echo N: Ne pas vérifier les mises à jour cette fois-ci.
	echo T: Toujours vérifier les mises à jour.
	echo J: Ne jamais vérifier les mises à jour.
	echo.
	set /p auto_update=Souhaitez-vous activer la mise à jour automatique? (O/N/T/J^): >con
) else IF /i "%ini_auto_update%"=="O" (
	set auto_update=O
) else IF /i "%ini_auto_update%"=="N" (
	set auto_update=N
) else (
	echo Mauvaise valeur configurée, le paramètre va être réinitialisé.
	del /q tools\Storage\verif_update.ini
	goto:verif_auto_update_ini
)
IF NOT "%auto_update%"=="" (
	set auto_update=%auto_update:~0,1%
) else (
	echo Cette valeur ne peut être vide.
	goto:initialize_auto_update
)
IF /i "%auto_update%"=="J" (
	echo auto_update=N>>tools\Storage\verif_update.ini
	set auto_update=N
)
IF /i "%auto_update%"=="T" (
	echo auto_update=O>>tools\Storage\verif_update.ini
	set auto_update=O
)
IF /i "%auto_update%"=="N" (
	goto:end_script
) else IF /i "%auto_update%"=="O" (
	goto:start_verif_update
) else (
	echo Choix inexistant.
	goto:initialize_auto_update
)
:start_verif_update
:update_manager_update
call :verif_file_version "tools\Storage\update_manager.bat"
IF %errorlevel% EQU 1 (
	call :verif_file_version "tools\Storage\update_manager_updater.bat"
IF !errorlevel! EQU 1 (
	call :update_file
)
	echo Le gestionnaire de mises à jour doit se mettre à jour lui-même avant de pouvoir continuer.
	echo Pour se faire, le script va lancer un autre script puis se fermer pour que la mise à jour puisse s'effectuer correctement.
	echo Une fois la mise à jour effectuée, le script va redémarré.
	pause
	call :update_manager_update_special_script
)
IF "%~1"=="" (
		goto:end_script
	) else (
	echo Vérifications et mises à jour en cours...
	call :%~1
)
call :del_old_or_unused_files
echo Vérifications et mises à jour terminées.
pause
goto:end_script

rem Specific scripts instructions must be added here

:update_all
echo Mise à jour intégrale du script en cours...
call :general_content_update
call :update_about.bat
call :update_android_installer.bat
call :update_biskey_dump.bat
call :update_convert_BOTW.bat
call :update_convert_game_to_nsp.bat
call :update_extract_cert.bat
call :update_install_drivers.bat
call :update_install_nsp_network.bat
call :update_install_nsp_USB.bat
call :update_launch_linux.bat
call :update_launch_payload.bat
call :update_launch_switch_lan_play_server.bat
call :update_nand_toolbox.bat
call :update_netplay.bat
call :update_nsZip.bat
call :update_pegaswitch.bat
call :update_preload_NSC_Builder.bat
call :update_prepare_sd_switch.bat
call :update_prepare_update_on_sd.bat
call :update_serial_checker.bat
call :update_split_games.bat
call :update_test_keys.bat
call :update_toolbox.bat
call :update_update_shofel2.bat
call :update_verify_nsp.bat
call :update_NES_Injector
call :update_SNES_Injector
echo Mise à jour intégrale du script terminée.
exit /b

:update_starting_script
call :verif_file_version "Ultimate-Switch-Hack-Script.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
exit /b

:update_about.bat
call :verif_file_version "tools\Storage\about.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
exit /b

:update_android_installer.bat
call :verif_file_version "tools\Storage\android_installer.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\android_apps"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_biskey_dump.bat
call :verif_file_version "tools\Storage\biskey_dump.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\biskeydump"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\TegraRcmSmash"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_cheats_profiles_management.bat
call :verif_file_version "tools\Storage\cheats_profiles_management.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\sd_switch\cheats"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_convert_BOTW.bat
call :verif_file_version "tools\Storage\convert_BOTW.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\BOTW_saveconv"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_convert_game_to_nsp.bat
call :verif_file_version "tools\Storage\convert_game_to_nsp.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\Hactool_based_programs"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_create_update.bat
call :verif_file_version "tools\Storage\create_update.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\Hactool_based_programs"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\python3_scripts\Keys_management"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_emulators_pack_profiles_management.bat
call :verif_file_version "tools\Storage\emulators_pack_profiles_management.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
tools\gnuwin32\bin\grep.exe -c "" <"tools\default_configs\Lists\emulators.list" > templogs\tempvar.txt
set /p count_emulators=<templogs\tempvar.txt
set /a temp_count=1
:listing_emulators
IF %temp_count% GTR %count_emulators% goto:skip_listing_emulators
"tools\gnuwin32\bin\sed.exe" -n %temp_count%p "tools\default_configs\Lists\emulators.list" >templogs\tempvar.txt
set /p temp_emulator=<templogs\tempvar.txt
call :verif_folder_version "tools\sd_switch\emulators\pack\%temp_emulator%"
IF !errorlevel! EQU 1 (
	call :update_folder
)
set /a temp_count+=1
goto:listing_emulators
:skip_listing_emulators
exit /b

:update_emunand_partition_file_create.bat
call :verif_file_version "tools\Storage\emunand_partition_file_create.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
exit /b

:update_extract_cert.bat
call :verif_file_version "tools\Storage\extract_cert.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\openssl"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\python2_scripts\CertNXtractionPack"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\python3_scripts\Cert_extraction"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_extract_nand_files_from_emunand_partition_file.bat
call :verif_file_version "tools\Storage\extract_nand_files_from_emunand_partition_file.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
exit /b

:update_install_drivers.bat
call :verif_file_version "tools\Storage\install_drivers.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\drivers"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\TegraRcmSmash"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_install_nsp_network.bat
call :verif_file_version "tools\Storage\install_nsp_network.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\python3_scripts\remote_NSP"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_install_nsp_USB.bat
call :verif_file_version "tools\Storage\install_nsp_USB.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\Goldtree"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_launch_hid-mitm_compagnon.bat
call :verif_file_version "tools\Storage\launch_hid-mitm_compagnon.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\Hid-mitm_compagnon"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_launch_linux.bat
call :verif_file_version "tools\Storage\launch_linux.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\linux_kernels"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\shofel2"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\TegraRcmSmash"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_launch_payload.bat
call :verif_file_version "tools\Storage\launch_payload.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "Payloads"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\TegraRcmSmash"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_launch_switch_lan_play_server.bat
call :verif_file_version "tools\Storage\launch_switch_lan_play_server.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\Node.js_programs"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_menu.bat
call :verif_file_version "tools\Storage\menu.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
exit /b

:update_mixed_pack_profiles_management.bat
call :verif_file_version "tools\Storage\mixed_pack_profiles_management.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\sd_switch\mixed\base"
IF !errorlevel! EQU 1 (
	call :update_folder
)
tools\gnuwin32\bin\grep.exe -c "" <"tools\default_configs\Lists\homebrews.list" > templogs\tempvar.txt
set /p count_homebrews=<templogs\tempvar.txt
set /a temp_count=1
:listing_homebrews
IF %temp_count% GTR %count_homebrews% goto:skip_listing_homebrews
"tools\gnuwin32\bin\sed.exe" -n %temp_count%p "tools\default_configs\Lists\homebrews.list" >templogs\tempvar.txt
set /p temp_homebrew=<templogs\tempvar.txt
call :verif_folder_version "tools\sd_switch\mixed\modular\%temp_homebrew%"
IF !errorlevel! EQU 1 (
	call :update_folder
)
set /a temp_count+=1
goto:listing_homebrews
:skip_listing_homebrews
exit /b

:update_modules_profiles_management.bat
call :verif_file_version "tools\Storage\modules_profiles_management.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
tools\gnuwin32\bin\grep.exe -c "" <"tools\default_configs\Lists\modules.list" > templogs\tempvar.txt
set /p count_modules=<templogs\tempvar.txt
set /a temp_count=1
:listing_modules
IF %temp_count% GTR %count_modules% goto:skip_listing_modules
"tools\gnuwin32\bin\sed.exe" -n %temp_count%p "tools\default_configs\Lists\modules.list" >templogs\tempvar.txt
set /p temp_module=<templogs\tempvar.txt
call :verif_folder_version "tools\sd_switch\modules\pack\%temp_module%"
IF !errorlevel! EQU 1 (
	call :update_folder
)
set /a temp_count+=1
goto:listing_modules
:skip_listing_modules
exit /b

:update_mount_discs.bat
call :verif_file_version "tools\Storage\mount_discs.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\HacDiskMount"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\memloader"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\TegraRcmSmash"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_nand_firmware_detect.bat
call :verif_file_version "tools\Storage\nand_firmware_detect.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\python3_scripts\FVI"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_nand_joiner.bat
call :verif_file_version "tools\Storage\nand_joiner.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
exit /b

:update_nand_spliter.bat
call :verif_file_version "tools\Storage\nand_spliter.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
exit /b

:update_nand_toolbox.bat
call :verif_file_version "tools\Storage\nand_toolbox.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\NxNandManager"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :update_emunand_partition_file_create.bat
call :update_extract_nand_files_from_emunand_partition_file.bat
call :update_mount_discs.bat
call :update_nand_firmware_detect.bat
call :update_nand_joiner.bat
call :update_nand_spliter.bat
exit /b

:update_netplay.bat
call :verif_file_version "tools\Storage\netplay.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\netplay"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_nsZip.bat
call :verif_file_version "tools\Storage\nsZip.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\nsZip"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_ocasional_functions_menu.bat
call :verif_file_version "tools\Storage\ocasional_functions_menu.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
exit /b

:update_others_functions_menu.bat
call :verif_file_version "tools\Storage\others_functions_menu.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
exit /b

:update_pegaswitch.bat
call :verif_file_version "tools\Storage\pegaswitch.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\sd_switch\pegaswitch"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\Node.js_programs"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "Payloads"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_preload_NSC_Builder.bat
call :verif_file_version "tools\Storage\preload_NSC_Builder.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\NSC_Builder"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_prepare_sd_switch.bat
call :verif_file_version "tools\Storage\prepare_sd_switch.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\fat32format"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\sd_switch\atmosphere"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\sd_switch\atmosphere_patches_nogc"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\sd_switch\payloads"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\sd_switch\reinx"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\sd_switch\sxos"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "Payloads"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :update_cheats_profiles_management.bat
call :update_emulators_pack_profiles_management.bat
call :update_mixed_pack_profiles_management.bat
call :update_modules_profiles_management.bat
call :update_prepare_sd_switch_profiles_management.bat
call :verif_file_version "tools\sd_switch\version.txt"
	call :update_file
)
exit /b

:update_prepare_sd_switch_files_questions.bat
call :verif_file_version "tools\Storage\prepare_sd_switch_files_questions.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
exit /b

:update_prepare_sd_switch_infos.bat
call :verif_file_version "tools\Storage\prepare_sd_switch_infos.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
exit /b

:update_prepare_sd_switch_profiles_management.bat
call :verif_file_version "tools\Storage\prepare_sd_switch_profiles_management.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :update_prepare_sd_switch_files_questions.bat
call :update_prepare_sd_switch_infos.bat
exit /b

:update_prepare_update_on_sd.bat
call :verif_file_version "tools\Storage\prepare_update_on_sd.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\sd_switch\mixed\modular\ChoiDuJourNX"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :update_create_update.bat
exit /b

:update_restore_configs.bat
call :verif_file_version "tools\Storage\restore_configs.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
exit /b

:update_restore_default.bat
call :verif_file_version "tools\Storage\restore_default.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
exit /b

:update_settings_menu.bat
call :verif_file_version "tools\Storage\settings_menu.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
exit /b

:update_save_configs.bat
call :verif_file_version "tools\Storage\save_configs.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
exit /b

:update_serial_checker.bat
call :verif_file_version "tools\Storage\serial_checker.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\python3_scripts\ssnc"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_split_games.bat
call :verif_file_version "tools\Storage\split_games.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\python3_scripts\splitNSP"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\XCI-Cutter"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_test_keys.bat
call :verif_file_version "tools\Storage\test_keys.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\python3_scripts\Keys_management"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_toolbox.bat
call :verif_file_version "tools\Storage\toolbox.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\toolbox"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\Goldtree"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\GuiFormat"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\HacDiskMount"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\Hactool_based_programs"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\H2testw"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\XCI-Cutter"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_update_shofel2.bat
call :verif_file_version "tools\Storage\update_shofel2.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\shofel2"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_verify_nsp.bat
call :verif_file_version "tools\Storage\verify_nsp.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
call :verif_folder_version "tools\Hactool_based_programs"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_NES_Injector
call :verif_folder_version "tools\NES_Injector"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_SNES_Injector
call :verif_folder_version "tools\SNES_Injector"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:general_content_update
echo Vérification et mise à jour des éléments généraux du script
call :update_starting_script
call :update_about.bat
call :update_menu.bat
call :update_ocasional_functions_menu.bat
call :update_others_functions_menu.bat
call :update_settings_menu.bat
call :update_restore_configs.bat
call :update_restore_default.bat
call :update_save_configs.bat
call :verif_folder_version "tools\7zip"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\default_configs"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\gitget"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\gnuwin32"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\megatools"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "tools\Storage\functions"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :verif_folder_version "DOC"
IF %errorlevel% EQU 1 (
	call :update_folder
)
echo Mise à jour des éléments généraux terminée.
exit /b

rem End of specific scripts instructions

:verif_file_version
set temp_file_path=%~1
set temp_file_slash_path=%temp_file_path:\=/%
rem ping /n 2 www.google.com >nul 2>&1
rem IF %errorlevel% NEQ 0 (
rem 	echo Aucune connexion internet vérifiable, la vérification de version du fichier "%temp_file_path%" n'aura pas lieu.
rem 	exit /b 0
rem )
call :test_write_access file "%~dp1"
set script_version=0.00.00
IF "%temp_file_path%"=="tools\sd_switch\version.txt" (
	IF EXIST "%temp_file_path%" set /p script_version=<"%temp_file_path%"
	"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "templogs\version.txt" %files_url_project_base%/%temp_file_slash_path% 2>nul
) else (
	IF EXIST "%~1.version" set /p script_version=<"%~1.version"
	"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "templogs\version.txt" %files_url_project_base%/%temp_file_slash_path%.version 2>nul
)
title Shadow256 Ultimate Switch Hack Script %ushs_version%
set /p script_version_verif=<"templogs\version.txt"
rem echo %temp_file_path% : va=%script_version%, vm=%script_version_verif%
rem echo %temp_file_slash_path%
rem pause
call :compare_version
exit /b %errorlevel%

:verif_folder_version
set temp_folder_path=%~1
set temp_folder_slash_path=%temp_folder_path:\=/%
rem ping /n 2 www.google.com >nul 2>&1
rem IF %errorlevel% NEQ 0 (
rem 	echo Aucune connexion internet vérifiable, la vérification de version du dossier "%temp_folder_path%" n'aura pas lieu.
rem 	exit /b 0
rem )
call :test_write_access folder "%~1"
set script_version=0.00.00
IF EXIST "%~1\folder_version.txt" set /p script_version=<"%~1\folder_version.txt"
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "templogs\version.txt" %files_url_project_base%/%temp_folder_slash_path%/folder_version.txt 2>nul
title Shadow256 Ultimate Switch Hack Script %ushs_version%
set /p script_version_verif=<"templogs\version.txt"
rem echo %temp_folder_path% : va=%script_version%, vm=%script_version_verif%
rem echo %temp_folder_slash_path%
rem pause
call :compare_version
exit /b %errorlevel%

:update_file
rem ping /n 2 www.google.com >nul 2>&1
rem IF %errorlevel% NEQ 0 (
rem 	echo Aucune connexion internet vérifiable, la mise à jour du fichier "%temp_file_path%" n'aura pas lieu.
rem 	exit /b 404
rem )
echo %temp_file_path%>"failed_updates\%temp_file_path:\=;%.file.failed"
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "%temp_file_path%" %files_url_project_base%/%temp_file_slash_path% 2>nul
IF %errorlevel% NEQ 0 (
	echo Erreur lors de la mise à jour du fichier "%temp_file_path%", le script va se fermer pour pouvoir relancer le processus de mise à jour lors du prochain redémarrage de celui-ci.
	IF EXIST templogs (
		rmdir /s /q templogs
	)
	pause
	exit
)
:file.version_download
IF "%temp_file_path%"=="tools\sd_switch\version.txt" goto:skip_file.version_download
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "%temp_file_path%.version" %files_url_project_base%/%temp_file_slash_path%.version 2>nul
IF %errorlevel% NEQ 0 (
	echo Erreur lors de la mise à jour du fichier "%temp_file_path%.version", le script va se fermer pour pouvoir relancer le processus de mise à jour lors du prochain redémarrage de celui-ci.
	IF EXIST templogs (
		rmdir /s /q templogs
	)
	pause
	exit
)
:skip_file.version_download
title Shadow256 Ultimate Switch Hack Script %ushs_version%
del /q "failed_updates\%temp_file_path:\=;%.file.failed"
echo Mise à jour de "%temp_file_path%" effectuée.
exit /b

:update_folder
rem ping /n 2 www.google.com >nul 2>&1
rem IF %errorlevel% NEQ 0 (
rem 	echo Aucune connexion internet vérifiable, la mise à jour du dossier "%temp_folder_path%" n'aura pas lieu.
rem 	exit /b 404
rem )
echo %temp_folder_path%>"failed_updates\%temp_folder_path:\=;%.fold.failed"
IF "%temp_folder_path%"=="tools\gitget" (
	"tools\gitget\SVN\svn.exe" export %folders_url_project_base%/%temp_folder_slash_path% templogs\gitget --force >nul
	IF !errorlevel! NEQ 0 (
		echo Erreur lors de la mise à jour du dossier "%temp_folder_path%", le script va se fermer pour pouvoir relancer le processus de mise à jour lors du prochain redémarrage de celui-ci.
		IF EXIST templogs (
			rmdir /s /q templogs
		)
		pause
		exit
	) else (
		rmdir /s /q "%temp_folder_path%"
		move "templogs\gitget" "%temp_folder_path%"
		del /q "failed_updates\%temp_folder_path:\=;%.folder.failed"
		exit /b
	)
)
IF "%temp_folder_path%"=="tools\Hactool_based_programs" (
	mkdir templogs\tempsave
	copy /V "tools\Hactool_based_programs\keys.txt" "templogs\tempsave\keys.txt" >nul 2>&1
copy /V "tools\Hactool_based_programs\keys.dat" "templogs\tempsave\keys.dat" >nul 2>&1
)
IF "%temp_folder_path%"=="tools\megatools" (
	mkdir templogs\tempsave
	copy /V "tools\megatools\mega.ini" "templogs\tempsave\mega.ini" >nul 2>&1
)
IF "%temp_folder_path%"=="tools\netplay" (
	mkdir templogs\tempsave
	copy /v "tools\netplay\servers_list.txt" "templogs\tempsave\servers_list.txt" >nul 2>&1
)
IF "%temp_folder_path%"=="tools\NSC_Builder" (
	mkdir templogs\tempsave
	copy /V "tools\NSC_Builder\keys.txt" "templogs\tempsave\keys.txt" >nul 2>&1
)
IF "%temp_folder_path%"=="tools\toolbox" (
	mkdir templogs\tempsave
	%windir%\System32\Robocopy.exe tools\toolbox templogs\tempsave /e >nul 2>&1
	del /q templogs\tempsave\default_tools.txt
	del /q templogs\tempsave\folder_version.txt
)
rmdir /s /q "%temp_folder_path%"
"tools\gitget\SVN\svn.exe" export %folders_url_project_base%/%temp_folder_slash_path% %temp_folder_path% --force >nul
set temp_folder_download_error=%errorlevel%
IF "%temp_folder_path%"=="tools\Hactool_based_programs" (
		move "templogs\tempsave" "%temp_folder_path%"
)
IF "%temp_folder_path%"=="tools\megatools" (
		move "templogs\tempsave" "%temp_folder_path%"
)
IF "%temp_folder_path%"=="tools\netplay" (
		move "templogs\tempsave" "%temp_folder_path%"
)
IF "%temp_folder_path%"=="tools\NSC_Builder" (
		move "templogs\tempsave" "%temp_folder_path%"
)
IF "%temp_folder_path%"=="tools\toolbox" (
		move "templogs\tempsave" "%temp_folder_path%"
)
IF %temp_folder_download_error% NEQ 0 (
	echo Erreur lors de la mise à jour du dossier "%temp_folder_path%", le script va se fermer pour pouvoir relancer le processus de mise à jour lors du prochain redémarrage de celui-ci.
	IF EXIST templogs (
		rmdir /s /q templogs
	)
	pause
	exit
)
del /q "failed_updates\%temp_folder_path:\=;%.fold.failed"
echo Mise à jour de "%temp_folder_path%" effectuée.
exit /b

:compare_version
set update_finded=
IF "%script_version_verif%"=="" exit /b 0
IF "%script_version%"=="" (
	IF NOT "%script_version_verif%"=="" (
		set update_finded=O
		exit /b 1
	) else (
		exit /b 0
	)
)
IF %script_version_verif:~0,1% GTR %script_version:~0,1% (
	set update_finded=O
	exit /b 1
)
IF %script_version_verif:~2,1% GTR %script_version:~2,1% (
	set update_finded=O
	exit /b 1
)
IF %script_version_verif:~3,1% GTR %script_version:~3,1% (
	set update_finded=O
	exit /b 1
)
IF %script_version_verif:~5,1% GTR %script_version:~5,1% (
	set update_finded=O
	exit /b 1
)
IF %script_version_verif:~6,1% GTR %script_version:~6,1% (
	set update_finded=O
	exit /b 1
)
	exit /b 0

:test_write_access
IF "%~1"=="folder" (
	mkdir "%~2\test"
) else (
	mkdir "%~dp2\test"
)
IF %errorlevel% NEQ 0 (
	echo Le script se trouve dans un répertoire nécessitant les privilèges administrateur pour être écrit. Veuillez relancer le script avec les privilèges administrateur en faisant un clique droit dessus et en sélectionnant "Exécuter en tant qu'administrateur".
	goto:end_script
)
IF "%~1"=="folder" (
	rmdir /s /q "%~2\test"
) else (
	rmdir /s /q "%~dp2\test"
)
exit /b

:update_failed_content
set /p temp_failed_update_path=<"%~1"
set temp_failed_file=%~1
IF "%temp_failed_file:~-11,4%"=="file" (
	set temp_file_path=%temp_failed_update_path%
	set temp_file_slash_path=%temp_failed_update_path:\=/%
	call :update_file
)
IF "%temp_failed_file:~-11,4%"=="fold" (
	set temp_folder_path=%temp_failed_update_path%
	set temp_folder_slash_path=%temp_failed_update_path:\=/%
	call :update_folder
)
exit /b

:update_manager_update_special_script
IF EXIST templogs (
	rmdir /s /q templogs
)
IF NOT EXIST "failed_updates\*.failed" (
	rmdir /s /q failed_updates
)
endlocal
start "" "%windir%\system32\cmd.exe" "/c start ^"^" ^"tools\Storage\update_manager_updater.bat^""
exit

:del_old_or_unused_files
echo Vérifications et suppressions d'éventuels anciens fichiers n'étant plus utilisés.

echo Vérifications et suppressions terminées.
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
)
IF NOT EXIST "failed_updates\*.failed" (
	rmdir /s /q failed_updates
)
cls
endlocal