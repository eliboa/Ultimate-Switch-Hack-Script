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
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "intro"
pause
cd TOOLS\Hactool_based_programs
IF NOT EXIST keys.dat (
	IF EXIST keys.txt (
		copy keys.txt keys.dat
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
	set /p keys_file_path=<"..\..\templogs\tempvar.txt"
	IF "%keys_file_path%"=="" (
	call "%associed_language_script%" "no_keys_file_selected_error"
	goto:end_script
	)
	
	copy "%keys_file_path%" keys.dat
	
:skip_keys_file_creation
echo.
call "%associed_language_script%" "xci_file_selection"
set /p game_path=<..\..\templogs\tempvar.txt
IF "%game_path%"=="" (
	call "%associed_language_script%" "no_game_selected_error"
	goto:end_script
)
call "%associed_language_script%" "output_folder_select"
set /p output_path=<..\..\templogs\tempvar.txt
IF "%output_path%"=="" (
	call "%associed_language_script%" "no_output_folder_error"
	goto:end_script
) else (
	set output_path=!output_path!\
	set output_path=!output_path:\\=\!
)
set rename_target=
call "%associed_language_script%" "rename_param_choice"
IF NOT "%rename_target%"=="" set rename_target=%rename_target:~0,1%
IF /i NOT "%rename_target%"=="o" set params=-r 
set keepncaid=
call "%associed_language_script%" "kipncaid_param_choice"
IF NOT "%keepncaid%"=="" set keepncaid=%keepncaid:~0,1%
IF /i NOT "%keepncaid%"=="o" set params=--keepncaid
"4nxci.exe" %params% -o "%output_path%" -t "..\..\templogs" "%game_path%"
IF %errorlevel% NEQ 0 (
	echo.
	call "%associed_language_script%" "converting_error"
) else (
	echo.
	call "%associed_language_script%" "converting_success"
)
:end_script
pause
cd ..\..
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal