::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "intro"
pause
cd TOOLS\Hactool_based_programs
IF NOT EXIST keys.txt (
	IF EXIST keys.dat (
		copy keys.dat keys.txt
		goto:skip_keys_file_creation
	)
	call "%associed_language_script%" "keys_file_not_finded_error"
	goto:keys_file_creation
) else (
	goto:skip_keys_file_creation
)
:keys_file_creation
echo.
call "%associed_language_script%" "keys_file_choice"
	set /p keys_file_path=<"..\..\templogs\tempvar.txt"
	IF "%keys_file_path%"=="" (
	call "%associed_language_script%" "no_keys_file_selected_error"
	goto:end_script
	)
	
	copy "%keys_file_path%" keys.txt
	
:skip_keys_file_creation
echo.
call "%associed_language_script%" "input_folder_choice"
set /p filepath=<..\..\templogs\tempvar.txt
IF NOT "%filepath%"=="" set filepath=%filepath%\
IF NOT "%filepath%"=="" (
	set filepath=%filepath:\\=\%
) else (
	call "%associed_language_script%" "no_input_folder_selected_error"
	goto:end_script
)
"NSPVerify.exe" "%filepath%"
IF %errorlevel% NEQ 0 (
	echo.
	call "%associed_language_script%" "verifying_error"
	goto:end_script
)
IF EXIST "Corrupted NSPs.txt" (
..\gnuwin32\bin\grep.exe -c "None of the files are corrupted." <"Corrupted NSPs.txt" >..\..\templogs\tempvar.txt
	set /p corupted_nsps=<..\..\templogs\tempvar.txt
)
IF %corupted_nsps% EQU 1 (
	del /q "Corrupted NSPs.txt"
	call "%associed_language_script%" "no_error_in_nsp_files"
)
IF EXIST "Exception Log.txt" (
	..\gnuwin32\bin\grep.exe -c "No exceptions to log." <"Exception Log.txt" >..\..\templogs\tempvar.txt
	set /p exceptions_log=<..\..\templogs\tempvar.txt
)
IF %exceptions_log% EQU 1 (
	del /q "Exception Log.txt"
	call "%associed_language_script%" "no_error_during_exec"
)
echo.
call "%associed_language_script%" "verify_end"
:end_script
pause
IF EXIST "Corrupted NSPs.txt" move "Corrupted NSPs.txt" "..\..\"Corrupted_NSPs.txt"
IF EXIST "Exception Log.txt" move "Exception Log.txt" "..\..\NSPVerify_Exceptions_log.txt"
cd ..\..
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal