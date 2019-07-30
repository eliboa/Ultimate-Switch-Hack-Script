::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
IF EXIST "%~0.version" (
	set /p this_script_version=<"%~0.version"
) else (
	set this_script_version=1.00.00
)
call "%associed_language_script%" "display_title"
cd >temp.txt
set /p calling_script_dir=<temp.txt
del /q temp.txt
set this_script_dir=%~dp0
%this_script_dir:~0,1%:
IF NOT "%~1"=="" (
	IF EXIST "%~1\*.*" (
		set update_file_path=%~1
		set update_type=1
	) else (
		call "%associed_language_script%" "folder_script_param_error"
		goto:endscript
	)
)
cd "%this_script_dir%"
IF EXIST "%calling_script_dir%\templogs" (
	del /q "%calling_script_dir%\templogs" 2>nul
	rmdir /s /q "%calling_script_dir%\templogs" 2>nul
)
mkdir "%calling_script_dir%\templogs"
call "%associed_language_script%" "warning_firmware_max_create"
echo.
cd ..\Hactool_based_programs
IF NOT EXIST keys.txt (
	IF EXIST keys.dat (
		copy keys.dat keys.txt
		goto:skip_keys_file_creation
	)
	call "%associed_language_script%" "keys_file_not_finded"
	goto:keys_file_creation
) else (
	goto:skip_keys_file_creation
)
:keys_file_creation
echo.
call "%associed_language_script%" "keys_file_selection"
	set /p keys_file_path=<"%calling_script_dir%\templogs\tempvar.txt"
	IF "%keys_file_path%"=="" (
	call "%associed_language_script%" "no_keys_file_selected_error"
	goto:endscript
	)
	
	copy "%keys_file_path%" keys.txt
	
:skip_keys_file_creation
IF EXIST ChoiDuJour_keys.txt del /q ChoiDuJour_keys.txt
..\python3_scripts\Keys_management\keys_management.exe create_choidujour_keys_file keys.txt
IF NOT EXIST ChoiDuJour_keys.txt (
	call "%associed_language_script%" "choidujour_keys_file_create_error"
	goto:endscript
)
IF NOT "%update_file_path%"=="" goto:skip_hfs0_select
set launch_xci_explorer=
call "%associed_language_script%" "launch_xci_explorer_choice"
IF NOT "%launch_xci_explorer%"=="" set launch_xci_explorer=%launch_xci_explorer:~0,1%
IF /i "%launch_xci_explorer%"=="o" XCI-Explorer.exe
:update_package_select
echo.
set update_type=
call "%associed_language_script%" "package_type_choice"
IF "%update_type%"=="" (
	call "%associed_language_script%" "no_package_type_selected_error"
	goto:update_package_select
) else (
	set update_type=%update_type:~0,1%
)
IF "%update_type%"=="1" (
	call "%associed_language_script%" "package_folder_select"
	set /p update_file_path=<"%calling_script_dir%\templogs\tempvar.txt"
) else IF "%update_type%"=="2" (
	call "%associed_language_script%" "package_file_select"
	set /p update_file_path=<"%calling_script_dir%\templogs\tempvar.txt"
) else (
	call "%associed_language_script%" "bad_choice_error"
	echo.
	goto:update_package_select
)
IF "%update_file_path%"=="" (
	call "%associed_language_script%" "no_source_selected_error"
	goto:endscript
)
set update_file_path=%update_file_path:\\=\%
:skip_hfs0_select
cd "%this_script_dir%"
:define_fspatches
set fspatches=--fspatches=nocmac
set enable_sigpatches=
call "%associed_language_script%" "sigpatches_param_choice"
IF NOT "%enable_sigpatches%"=="" set enable_sigpatches=%enable_sigpatches:~0,1%
IF /i "%enable_sigpatches%"=="o" set fspatches=%fspatches%,nosigchk
set disable_gamecard=
call "%associed_language_script%" "nogc_param_choice"
IF NOT "%disable_gamecard%"=="" set disable_gamecard=%disable_gamecard:~0,1%
IF /i "%disable_gamecard%"=="o" set fspatches=%fspatches%,nogc
set no_exfat=
call "%associed_language_script%" "noexfat_param_choice"
IF NOT "%no_exfat%"=="" set no_exfat=%no_exfat:~0,1%
IF /i "%no_exfat%"=="o" set no_exfat_param=--noexfat
:start_update_creation
IF NOT EXIST "%calling_script_dir%\update_packages\*.*" (
	del /q "%calling_script_dir%\update_packages" 2>nul
	mkdir "%calling_script_dir%\update_packages"
)
%calling_script_dir:~0,1%:
cd "%calling_script_dir%\update_packages"
del /q list_of_dirs.ini 2>nul
dir /A:D >list_of_dirs.ini
"%this_script_dir%\..\Hactool_based_programs\tools\ChoiDujour.exe" --keyset="%this_script_dir%\..\Hactool_based_programs\ChoiDuJour_keys.txt" %no_exfat_param% %fspatches% "%update_file_path%"
IF %errorlevel% EQU 0 (
	call "%associed_language_script%" "package_creation_success"
	goto:skip_verif_fw_dir
) else (
	call "%associed_language_script%" "package_creation_error"
	goto:verif_fw_dir
)
:verif_fw_dir
del /q list_of_dirs_2.ini 2>nul
dir /A:D >list_of_dirs_2.ini
"%this_script_dir%\..\gnuwin32\bin\diff.exe" list_of_dirs.ini list_of_dirs_2.ini | "%this_script_dir%\..\gnuwin32\bin\head.exe" -2 | "%this_script_dir%\..\gnuwin32\bin\tail.exe" -1 >new_dir.ini
::pause
::rmdir /q /s "%fw_dir%"
:skip_verif_fw_dir
IF "%update_type%"=="2" rmdir /q /s "%this_script_dir%\..\Hactool_based_programs\tools\update_update"
del /q list_of_dirs.ini 2>nul
del /q list_of_dirs_2.ini 2>nul
del /q new_dir.ini 2>nul
:endscript
pause
%calling_script_dir:~0,1%:
cd "%calling_script_dir%"
IF EXIST templogs\*.* (
	rmdir /s /q templogs
)
endlocal