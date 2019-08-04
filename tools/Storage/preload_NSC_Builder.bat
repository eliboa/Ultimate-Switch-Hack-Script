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
echo %associed_language_script%
call "%associed_language_script%" "display_title"
cd >temp.txt
set /p calling_script_dir=<temp.txt
del /q temp.txt
set this_script_dir=%~dp0
%this_script_dir:~0,1%:
cd "%this_script_dir%"
IF EXIST "%calling_script_dir%\templogs\*.*" (
	del /q "%calling_script_dir%\templogs" 2>nul
	rmdir /s /q "%calling_script_dir%\templogs" 2>nul
)
mkdir "%calling_script_dir%\templogs"
cd ..\Hactool_based_programs
IF NOT EXIST "..\NSC_Builder\keys.txt" (
	IF EXIST keys.dat (
		copy keys.dat ..\NSC_Builder\keys.txt
		goto:skip_keys_file_creation
	) else IF EXIST keys.txt (
		copy keys.txt ..\NSC_Builder\keys.txt
		goto:skip_keys_file_creation
	) else (
		call "%associed_language_script%" "keys_file_not_finded"
		goto:keys_file_creation
	)
) else (
	goto:skip_keys_file_creation
)
:keys_file_creation
echo.
call "%associed_language_script%" "keys_file_choice"
set /p keys_file_path=<"%calling_script_dir%\templogs\tempvar.txt"
IF "%keys_file_path%"=="" (
	call "%associed_language_script%" "no_keys_file_selected"
	goto:endscript
)
copy "%keys_file_path%" ..\NSC_Builder\keys.txt
:skip_keys_file_creation
%calling_script_dir:~0,1%:
cd "%calling_script_dir%"
IF NOT "language_custom"=="0" (
	set nscb_language_choice=
	call "%associed_language_script%" "choose_nscb_language"
	IF "!nscb_language_choice!"=="1" (
		set language_id=FR_fr
	) else (
		set language_id=
	)
)
IF "%language_id%"=="FR_fr" (
	start tools\NSC_Builder\NSCB_fr.bat
) else (
	start tools\NSC_Builder\NSCB.bat
)
echo.
call "%associed_language_script%" "open_output_dir_choice"
IF NOT "%open_output_dir%"=="" set open_output_dir=%open_output_dir:~0,1%
call "tools\Storage\functions\modify_yes_no_always_never_vars.bat" "open_output_dir" "o/n_choice"
IF /I "%open_output_dir%"=="o" (
	IF "%language_id%"=="FR_fr" (
		"TOOLS\NSC_Builder\ztools\listmanager\listmanager.exe" -rl "TOOLS\NSC_Builder\zconfig\NSCB_fr_options.cmd" -ln "10" -nl "Output dir: " | TOOLS\gnuwin32\bin\cut.exe -d = -f 2 >templogs\tempvar.txt
	) else (
		"TOOLS\NSC_Builder\ztools\listmanager\listmanager.exe" -rl "TOOLS\NSC_Builder\zconfig\NSCB_options.cmd" -ln "10" -nl "Output dir: " | TOOLS\gnuwin32\bin\cut.exe -d = -f 2 >templogs\tempvar.txt
	)
	set /p NSCB_output_dir=<templogs\tempvar.txt
)
set NSCB_output_dir=%NSCB_output_dir:"=%
IF /I "%open_output_dir%"=="o" (
	IF "%NSCB_output_dir:~1,1%"==":" (
		IF NOT EXIST "%NSCB_output_dir%" (
			call "%associed_language_script%" "output_dir_not_exist_error"
			goto:endscript
		) else IF NOT EXIST "%~dp0..\NSC_Builder\%NSCB_output_dir%" (
			call "%associed_language_script%" "output_dir_not_exist_error"
			goto:endscript
		)
	)
)
	IF /I "%open_output_dir%"=="o" (
	IF "%NSCB_output_dir:~1,1%"==":" (
		start explorer.exe "%NSCB_output_dir%"
	) else (
		start explorer.exe "%~dp0..\NSC_Builder\%NSCB_output_dir%"
	)
)
:endscript
set open_output_dir=
set NSCB_output_dir=
pause
%calling_script_dir:~0,1%:
cd "%calling_script_dir%"
IF EXIST templogs\*.* (
	rmdir /s /q templogs
)
endlocal