::Script by Shadow256
IF EXIST "tools\storage\functions\ini_scripts.bat" (
	call tools\storage\functions\ini_scripts.bat
) else (
	@echo off
	chcp 65001 >nul
)
Setlocal enabledelayedexpansion
set base_script_path="%~dp0\..\.."
set folders_url_project_base=https://github.com/shadow2560/Ultimate-Switch-Hack-Script/trunk
set files_url_project_base=https://github.com/shadow2560/Ultimate-Switch-Hack-Script/raw/master
IF EXIST "templogs" (
	del /q "templogs" 2>nul
	rmdir /s /q "templogs" 2>nul
)
mkdir "templogs"
IF NOT EXIST "tools\gnuwin32\bin\wc.exe" (
	ping /n 2 www.github.com >nul 2>&1
	IF !errorlevel! NEQ 0 (
		echo Dependancy error, you have to connect to internet, script will close.
		exit
	) else (
		"tools\gitget\SVN\svn.exe" export %folders_url_project_base%/tools/gnuwin32 tools\gnuwin32 --force >nul
	)
)
IF "%language_path%"=="" (
	IF "%temp_language_path%"=="" (
		set temp_language_path=languages\FR_fr
		rmdir /s /q "templogs" 2>nul
		call :initialize_language
		exit
	)
)
IF "%~2"=="language_init" (
	rmdir /s /q "templogs" 2>nul
	call :initialize_language
	exit
)
echo é >nul
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
call "%associed_language_script%" "display_title"
IF  "%~2"=="force" (
	set auto_update=O
	goto:begin_update
)
IF EXIST "failed_updates\*.failed" (
	set auto_update=O
	goto:begin_update
)
:verif_auto_update_ini
IF EXIST "%language_path%\script_general_config.bat\*.*" (
	rmdir /s /q "%language_path%\script_general_config.bat"
)
IF not EXIST "%language_path%\script_general_config.bat" copy nul "%language_path%\script_general_config.bat" >nul
tools\gnuwin32\bin\grep.exe -n "set auto_update=" <"%language_path%\script_general_config.bat" >templogs\tempvar.txt
set /p temp_auto_update_line=<templogs\tempvar.txt
IF NOT "%temp_auto_update_line%"=="" (
	echo %temp_auto_update_line%|"tools\gnuwin32\bin\cut.exe" -d : -f 1 >templogs\tempvar.txt
	set /p auto_update_file_param_line=<templogs\tempvar.txt
	echo %temp_auto_update_line%|"tools\gnuwin32\bin\cut.exe" -d = -f 2 >templogs\tempvar.txt
	set /p ini_auto_update=<templogs\tempvar.txt
)
set temp_auto_update_line=
:initialize_auto_update
IF "%ini_auto_update%"=="" (
	call "%associed_language_script%" "autoupdate_choice"
) else IF /i "%ini_auto_update%"=="O" (
	set auto_update=O
) else IF /i "%ini_auto_update%"=="N" (
	set auto_update=N
) else (
	call "%associed_language_script%" "autoupdate_bad_value_error"
	"tools\gnuwin32\bin\sed.exe" %auto_update_file_param_line%d "%language_path%\script_general_config.bat">"%language_path%\script_general_config2.bat"
	del /q "%language_path%\script_general_config.bat"
	ren "%language_path%\script_general_config2.bat" "script_general_config.bat"
	set ini_auto_update=
	goto:initialize_auto_update
)
IF NOT "%auto_update%"=="" (
	set auto_update=%auto_update:~0,1%
) else (
	call "%associed_language_script%" "autoupdate_empty_value_error"
	goto:initialize_auto_update
)
IF /i "%auto_update%"=="J" (
	IF NOT "%auto_update_file_param_line%"=="" (
		"tools\gnuwin32\bin\sed.exe" '%auto_update_file_param_line% d' "%language_path%\script_general_config.bat">"%language_path%\script_general_config2.bat"
		del /q "%language_path%\script_general_config.bat"
		ren "%language_path%\script_general_config2.bat" "script_general_config.bat"
	)
	echo set auto_update=N>>"%language_path%\script_general_config.bat"
	set auto_update=N
)
IF /i "%auto_update%"=="T" (
	IF NOT "%auto_update_file_param_line%"=="" (
		"tools\gnuwin32\bin\sed.exe" '%auto_update_file_param_line% d' "%language_path%\script_general_config.bat">"%language_path%\script_general_config2.bat"
		del /q "%language_path%\script_general_config.bat"
		ren "%language_path%\script_general_config2.bat" "script_general_config.bat"
	)
	echo set auto_update=O>>"%language_path%\script_general_config.bat"
	set auto_update=O
)
IF /i "%auto_update%"=="N" (
	goto:end_script
) else IF /i "%auto_update%"=="O" (
	goto:begin_update
) else (
	call "%associed_language_script%" "autoupdate_choice_not_permited_error"
	goto:initialize_auto_update
)
:begin_update
echo :::::::::::::::::::::::::::::::::::::
echo ::Shadow256 Ultimate Switch Hack Script %ushs_version% updater::
echo.
IF NOT EXIST "failed_updates\*.failed" (
	rmdir /s /q "failed_updates" 2>nul
)
mkdir "failed_updates" >nul
:new_script_install
IF "%~1"=="update_all" goto:skip_new_script_install
IF "%~1"=="general_content_update" goto:skip_new_script_install
IF "%~2"=="force" (
	ping /n 2 www.github.com >nul 2>&1
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "no_internet_connection_error"
		pause
		goto_end_script
	)
	call :verif_file_version "tools\Storage\update_manager.bat"
	IF !errorlevel! EQU 1 (
		call :verif_file_version "tools\Storage\update_manager_updater.bat"
		IF !errorlevel! EQU 1 (
			call :update_file
		)
		IF "%language_custom%"=="0" (
			call :verif_file_version "%language_path%\tools\Storage\update_manager_updater.bat"
			IF !errorlevel! EQU 1 (
				call :update_file
			)
		)
		call "%associed_language_script%" "update_manager_updater_update"
		pause
		call :update_manager_update_special_script
	)
	set new_install_choice=
	call "%associed_language_script%" "new_installation_choice"
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
ping /n 2 www.github.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "no_internet_connection_error"
	IF /i "%new_install_choice%"=="o" (
		call "%associed_language_script%" "no_internet_connection_for_new_installation_error"
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
	IF "%language_custom%"=="0" (
		call :verif_file_version "%language_path%\tools\Storage\update_manager_updater.bat"
		IF !errorlevel! EQU 1 (
			call :update_file
		)
	)
	call "%associed_language_script%" "update_manager_updater_update"
	pause
	call :update_manager_update_special_script
)
for %%f in (failed_updates\*.failed) do (
	call :update_failed_content "%%f"
)
:skip_failed_updates_verification
:start_verif_update
:update_manager_update
call :verif_file_version "tools\Storage\update_manager.bat"
IF %errorlevel% EQU 1 (
	call :verif_file_version "tools\Storage\update_manager_updater.bat"
IF !errorlevel! EQU 1 (
	call :update_file
)
	IF "%language_custom%"=="0" (
		call :verif_file_version "%language_path%\tools\Storage\update_manager_updater.bat"
		IF !errorlevel! EQU 1 (
			call :update_file
		)
	)
	call "%associed_language_script%" "update_manager_updater_update"
	pause
	call :update_manager_update_special_script
)
IF "%~1"=="" (
		goto:end_script
	) else (
	call "%associed_language_script%" "begin_update"
	call :verif_file_version "tools\general_update_version.txt"
	IF !errorlevel! EQU 1 (
		call :general_content_update
	)
	call :verif_file_version "tools\version.txt"
	IF !errorlevel! EQU 1 (
		call :update_file
	)
	IF "%language_custom%"=="0" (
		call :verif_folder_version "%language_path%\doc"
		IF !errorlevel! EQU 1 (
			call :update_folder
		)
		call :verif_file_version "%language_path%\language_general_config.bat"
		IF !errorlevel! EQU 1 (
			"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "templogs\language_general_config.bat" %files_url_project_base%/%language_path:\=/%/language_general_config.bat 2>nul
			IF !errorlevel! EQU 0 (
				move "templogs\language_general_config.bat" "%language_path%\language_general_config.bat" >nul
			)
			call "%associed_language_script%" "display_title"
		)
	)
	IF "%~1"=="general_content_update" goto:clean_files
	call :%~1
)
:clean_files
call :del_old_or_unused_files
call "%associed_language_script%" "end_update"
pause
goto:end_script

rem Specific scripts instructions must be added here

:update_all
call "%associed_language_script%" "update_all_begin"
call "%associed_language_script%" "languages_update_begin"
"tools\gitget\SVN\svn.exe" export %folders_url_project_base%/languages languages --force >nul
call "%associed_language_script%" "languages_update_end"
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
call :update_merge_games.bat
call :update_nand_toolbox.bat
call :update_netplay.bat
call :update_nsZip.bat
call :update_pegaswitch.bat
call :update_preload_NSC_Builder.bat
call :update_prepare_sd_switch.bat
call :update_prepare_update_on_sd.bat
call :update_renxpack.bat
call :update_serial_checker.bat
call :update_split_games.bat
call :update_test_keys.bat
call :update_toolbox.bat
call :update_update_shofel2.bat
call :update_verify_nsp.bat
call :update_NES_Injector
call :update_SNES_Injector
call "%associed_language_script%" "update_all_end"
exit /b

:update_starting_script
call :verif_file_version "Ultimate-Switch-Hack-Script.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\Ultimate-Switch-Hack-Script.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_about.bat
call :verif_file_version "tools\Storage\about.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\about.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_android_installer.bat
call :verif_file_version "tools\Storage\android_installer.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\android_installer.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\biskey_dump.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\cheats_profiles_management.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\convert_BOTW.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\convert_game_to_nsp.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\create_update.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\emulators_pack_profiles_management.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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

:update_emummc_profiles_management.bat
call :verif_file_version "tools\Storage\emummc_profiles_management.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\emummc_profiles_management.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_emunand_partition_file_create.bat
call :verif_file_version "tools\Storage\emunand_partition_file_create.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\emunand_partition_file_create.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_extract_cert.bat
call :verif_file_version "tools\Storage\extract_cert.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\extract_cert.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\extract_nand_files_from_emunand_partition_file.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_install_drivers.bat
call :verif_file_version "tools\Storage\install_drivers.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\install_drivers.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\install_nsp_network.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\install_nsp_USB.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\launch_hid-mitm_compagnon.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\launch_linux.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\launch_payload.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\launch_switch_lan_play_server.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\menu.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_merge_game.bat
call :verif_file_version "tools\Storage\merge_games.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\merge_games.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_mixed_pack_profiles_management.bat
call :verif_file_version "tools\Storage\mixed_pack_profiles_management.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\mixed_pack_profiles_management.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\modules_profiles_management.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\mount_discs.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\nand_firmware_detect.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\nand_joiner.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_nand_spliter.bat
call :verif_file_version "tools\Storage\nand_spliter.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\nand_spliter.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_nand_toolbox.bat
call :verif_file_version "tools\Storage\nand_toolbox.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\nand_toolbox.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\netplay.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\nsZip.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\ocasional_functions_menu.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_others_functions_menu.bat
call :verif_file_version "tools\Storage\others_functions_menu.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\others_functions_menu.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_pegaswitch.bat
call :verif_file_version "tools\Storage\pegaswitch.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\pegaswitch.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\preload_NSC_Builder.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\prepare_sd_switch.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
call :update_emummc_profiles_management.bat
call :update_mixed_pack_profiles_management.bat
call :update_modules_profiles_management.bat
call :update_prepare_sd_switch_profiles_management.bat
call :verif_file_version "tools\sd_switch\version.txt"
IF %errorlevel% EQU 1 (
	call :update_file
)
exit /b

:update_prepare_sd_switch_files_questions.bat
call :verif_file_version "tools\Storage\prepare_sd_switch_files_questions.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\prepare_sd_switch_files_questions.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_prepare_sd_switch_infos.bat
call :verif_file_version "tools\Storage\prepare_sd_switch_infos.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\prepare_sd_switch_infos.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_prepare_sd_switch_profiles_management.bat
call :verif_file_version "tools\Storage\prepare_sd_switch_profiles_management.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\prepare_sd_switch_profiles_management.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
call :update_prepare_sd_switch_files_questions.bat
call :update_prepare_sd_switch_infos.bat
exit /b

:update_prepare_update_on_sd.bat
call :verif_file_version "tools\Storage\prepare_update_on_sd.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\prepare_update_on_sd.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
call :verif_folder_version "tools\sd_switch\mixed\modular\ChoiDuJourNX"
IF %errorlevel% EQU 1 (
	call :update_folder
)
call :update_create_update.bat
exit /b

:update_renxpack.bat
call :verif_file_version "tools\Storage\renxpack.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\renxpack.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
call :verif_folder_version "tools\Hactool_based_programs"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_restore_configs.bat
call :verif_file_version "tools\Storage\restore_configs.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\restore_configs.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_restore_default.bat
call :verif_file_version "tools\Storage\restore_default.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\restore_default.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_save_configs.bat
call :verif_file_version "tools\Storage\save_configs.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\save_configs.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_serial_checker.bat
call :verif_file_version "tools\Storage\serial_checker.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\serial_checker.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
call :verif_folder_version "tools\python3_scripts\ssnc"
IF %errorlevel% EQU 1 (
	call :update_folder
)
exit /b

:update_settings_menu.bat
call :verif_file_version "tools\Storage\settings_menu.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\settings_menu.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_split_games.bat
call :verif_file_version "tools\Storage\split_games.bat"
IF %errorlevel% EQU 1 (
	call :update_file
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\split_games.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\test_keys.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\toolbox.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\update_shofel2.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\Storage\verify_nsp.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
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
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\NES_Injector\NES_Injector.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:update_SNES_Injector
call :verif_folder_version "tools\SNES_Injector"
IF %errorlevel% EQU 1 (
	call :update_folder
)
IF "%language_custom%"=="0" (
	call :verif_file_version "%language_path%\tools\SNES_Injector\SNES_Injector.bat"
	IF %errorlevel% EQU 1 (
		call :update_file
	)
)
exit /b

:general_content_update
call "%associed_language_script%" "update_basic_elements_begin"
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
call :verif_file_version "tools\general_update_version.txt"
IF %errorlevel% EQU 1 (
	call :update_file
)
call "%associed_language_script%" "update_basic_elements_end"
exit /b

rem End of specific scripts instructions

:verif_file_version
set temp_file_path=%~1
set temp_file_slash_path=%temp_file_path:\=/%
call :test_write_access file "%~dp1"
set script_version=0
IF "%temp_file_path%"=="tools\sd_switch\version.txt" (
	IF EXIST "%temp_file_path%" (
		set /p script_version=<"%temp_file_path%"
	) else (
		set script_version=0
	)
	"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "templogs\version.txt" %files_url_project_base%/%temp_file_slash_path% 2>nul
) else IF "%temp_file_path%"=="tools\general_update_version.txt" (
	IF EXIST "%temp_file_path%" (
		set /p script_version=<"%temp_file_path%"
	) else (
		set script_version=0
	)
	"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "templogs\version.txt" %files_url_project_base%/%temp_file_slash_path% 2>nul
) else IF "%temp_file_path%"=="tools\version.txt" (
	IF EXIST "%temp_file_path%" (
		set /p script_version=<"%temp_file_path%"
	) else (
		set script_version=0
	)
	"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "templogs\version.txt" %files_url_project_base%/%temp_file_slash_path% 2>nul
) else (
	IF EXIST "%~1.version" set /p script_version=<"%~1.version"
	"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "templogs\version.txt" %files_url_project_base%/%temp_file_slash_path%.version 2>nul
)
call "%associed_language_script%" "display_title"
set /p script_version_verif=<"templogs\version.txt"
rem echo %temp_file_path% : va=%script_version%, vm=%script_version_verif%
rem echo %temp_file_slash_path%
rem pause
call :compare_version
exit /b %errorlevel%

:verif_folder_version
set temp_folder_path=%~1
set temp_folder_slash_path=%temp_folder_path:\=/%
call :test_write_access folder "%~1"
set script_version=0
IF EXIST "%~1\folder_version.txt" set /p script_version=<"%~1\folder_version.txt"
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "templogs\version.txt" %files_url_project_base%/%temp_folder_slash_path%/folder_version.txt 2>nul
call "%associed_language_script%" "display_title"
set /p script_version_verif=<"templogs\version.txt"
rem echo %temp_folder_path% : va=%script_version%, vm=%script_version_verif%
rem echo %temp_folder_slash_path%
rem pause
call :compare_version
exit /b %errorlevel%

:update_file
echo %temp_file_path%>"failed_updates\%temp_file_path:\=;%.file.failed"
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "%temp_file_path%" %files_url_project_base%/%temp_file_slash_path% 2>nul
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "update_file_error"
	IF EXIST templogs (
		rmdir /s /q templogs
	)
	pause
	exit
)
:file.version_download
IF "%temp_file_path%"=="tools\sd_switch\version.txt" goto:skip_file.version_download
IF "%temp_file_path%"=="tools\general_update_version.txt" goto:skip_file.version_download
IF "%temp_file_path%"=="tools\version.txt" goto:skip_file.version_download
"tools\gnuwin32\bin\wget.exe" --no-check-certificate --content-disposition -S -O "%temp_file_path%.version" %files_url_project_base%/%temp_file_slash_path%.version 2>nul
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "update_file.version_error"
	IF EXIST templogs (
		rmdir /s /q templogs
	)
	pause
	exit
)
:skip_file.version_download
call "%associed_language_script%" "display_title"
del /q "failed_updates\%temp_file_path:\=;%.file.failed"
call "%associed_language_script%" "update_file_success"
exit /b

:update_folder
echo %temp_folder_path%>"failed_updates\%temp_folder_path:\=;%.fold.failed"
IF "%temp_folder_path%"=="tools\gitget" (
	"tools\gitget\SVN\svn.exe" export %folders_url_project_base%/%temp_folder_slash_path% templogs\gitget --force >nul
	IF !errorlevel! NEQ 0 (
		call "%associed_language_script%" "update_folder_error"
		IF EXIST templogs (
			rmdir /s /q templogs
		)
		pause
		exit
	) else (
		rmdir /s /q "%temp_folder_path%"
		move "templogs\gitget" "%temp_folder_path%"
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
	call "%associed_language_script%" "update_folder_error"
	IF EXIST templogs (
		rmdir /s /q templogs
	)
	pause
	exit
)
del /q "failed_updates\%temp_folder_path:\=;%.fold.failed"
call "%associed_language_script%" "update_folder_success"
exit /b

:compare_version
set update_finded=
IF "%script_version_verif%"=="" goto:end_compare_version
IF "%script_version%"=="" (
	IF NOT "%script_version_verif%"=="" (
		set update_finded=Y
		goto:end_compare_version
	) else (
		goto:end_compare_version
	)
)
echo %script_version_verif%|"tools\gnuwin32\bin\grep.exe" -o "\."|"tools\gnuwin32\bin\wc.exe" -l >templogs\tempvar.txt
set /p count_script_version_verif_cols=<templogs\tempvar.txt
set /a count_script_version_verif_cols+=1
echo %script_version%|"tools\gnuwin32\bin\grep.exe" -o "\."|"tools\gnuwin32\bin\wc.exe" -l >templogs\tempvar.txt
set /p count_script_version_cols=<templogs\tempvar.txt
set /a count_script_version_cols+=1
IF %count_script_version_verif_cols% EQU 1 (
	IF %count_script_version_cols% EQU 1 (
		IF %script_version_verif% GTR %script_version% (
			set update_finded=Y
			goto:end_compare_version
		) else (
			goto:end_compare_version
		)
	)
)
for /l %%i in (1,1,%count_script_version_verif_cols%) do (
	echo %script_version_verif%|"tools\gnuwin32\bin\grep.exe" ""|"tools\gnuwin32\bin\cut.exe" -d . -f %%i >templogs\tempvar.txt
	set /p temp_script_version_verif=<templogs\tempvar.txt
	echo %script_version%|"tools\gnuwin32\bin\grep.exe" ""|"tools\gnuwin32\bin\cut.exe" -d . -f %%i >templogs\tempvar.txt
	set /p temp_script_version=<templogs\tempvar.txt
	IF !temp_script_version_verif! GTR !temp_script_version! (
		set update_finded=Y
		goto:end_compare_version
	)
)
:end_compare_version
IF "%update_finded%"=="Y" (
	exit /b 1
) else (
	exit /b 0
)

:test_write_access
IF "%~1"=="folder" (
	mkdir "%~2\test"
) else (
	mkdir "%~dp2\test"
)
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "write_access_test_error"
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
start /i "" "%windir%\system32\cmd.exe" /c call "tools\Storage\update_manager_updater.bat"
exit
exit /b

:initialize_language
ping /n 2 www.github.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	echo No internet connection and the language is not initialized, script will close.
	pause
	exit /b 500
)
IF NOT EXIST "tools\default_configs\Lists\languages.list" (
	"tools\gitget\SVN\svn.exe" export %folders_url_project_base%/tools/default_configs/Lists tools\default_configs\Lists --force >nul
)
"tools\gitget\SVN\svn.exe" export %folders_url_project_base%/%temp_language_path:\=/% %temp_language_path% --force >nul
echo Language initialized, script will close so restart it manualy to use the language installed.
pause
exit /b 200

:del_old_or_unused_files
call "%associed_language_script%" "del_hold_files_begin"
IF EXIST "tools\Storage\verif_update.ini" del /q "tools\Storage\verif_update.ini"
IF EXIST "DOC\*.*" rmdir /s /q "DOC"
call "%associed_language_script%" "del_hold_files_end"
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