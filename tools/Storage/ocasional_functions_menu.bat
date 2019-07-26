::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
:define_action_choice
call "%associed_language_script%" "display_title"
set action_choice=
cls
call "%associed_language_script%" "display_menu"
IF "%action_choice%"=="1" goto:biskey_dump
IF "%action_choice%"=="2" goto:install_drivers
IF "%action_choice%"=="3" goto:create_update
IF "%action_choice%"=="4" goto:verif_serials
IF "%action_choice%"=="5" goto:test_keys
IF "%action_choice%"=="6" goto:hid-mitm_compagnon
IF "%action_choice%"=="7" goto:launch_linux
IF "%action_choice%"=="8" goto:update_shofel2
goto:end_script
:biskey_dump
set action_choice=
echo.
cls
IF EXIST "tools\Storage\biskey_dump.bat" (
	call tools\Storage\update_manager.bat "update_biskey_dump.bat"
) else (
	call tools\Storage\update_manager.bat "update_biskey_dump.bat" "force"
)
call TOOLS\Storage\biskey_dump.bat
@echo off
goto:define_action_choice
:install_drivers
set action_choice=
echo.
cls
IF EXIST "tools\Storage\install_drivers.bat" (
	call tools\Storage\update_manager.bat "update_install_drivers.bat"
) else (
	call tools\Storage\update_manager.bat "update_install_drivers.bat" "force"
)
call TOOLS\Storage\install_drivers.bat
@echo off
goto:define_action_choice
:create_update
set action_choice=
echo.
cls
IF EXIST "tools\Storage\create_update.bat" (
	call tools\Storage\update_manager.bat "update_create_update.bat"
) else (
	call tools\Storage\update_manager.bat "update_create_update.bat" "force"
)
call TOOLS\Storage\create_update.bat
@echo off
goto:define_action_choice
:verif_serials
set action_choice=
echo.
cls
IF EXIST "tools\Storage\serial_checker.bat" (
	call tools\Storage\update_manager.bat "update_serial_checker.bat"
) else (
	call tools\Storage\update_manager.bat "update_serial_checker.bat" "force"
)
call TOOLS\Storage\serial_checker.bat
@echo off
goto:define_action_choice
:test_keys
set action_choice=
echo.
cls
IF EXIST "tools\Storage\test_keys.bat" (
	call tools\Storage\update_manager.bat "update_test_keys.bat"
) else (
	call tools\Storage\update_manager.bat "update_test_keys.bat" "force"
)
call TOOLS\Storage\test_keys.bat
@echo off
goto:define_action_choice
:hid-mitm_compagnon
set action_choice=
echo.
cls
IF EXIST "tools\Storage\launch_hid-mitm_compagnon.bat" (
	call tools\Storage\update_manager.bat "update_launch_hid-mitm_compagnon.bat"
) else (
	call tools\Storage\update_manager.bat "update_launch_hid-mitm_compagnon.bat" "force"
)
call tools\Storage\launch_hid-mitm_compagnon.bat
@echo off
goto:define_action_choice
:launch_linux
set action_choice=
echo.
cls
IF EXIST "tools\Storage\launch_linux.bat" (
	call tools\Storage\update_manager.bat "update_launch_linux.bat"
) else (
	call tools\Storage\update_manager.bat "update_launch_linux.bat" "force"
)
call TOOLS\Storage\launch_linux.bat
@echo off
goto:define_action_choice
:update_shofel2
set action_choice=
echo.
cls
IF EXIST "tools\Storage\update_shofel2.bat" (
	call tools\Storage\update_manager.bat "update_update_shofel2.bat"
) else (
	call tools\Storage\update_manager.bat "update_update_shofel2.bat" "force"
)
call TOOLS\Storage\update_shofel2.bat
@echo off
goto:define_action_choice
:end_script
endlocal