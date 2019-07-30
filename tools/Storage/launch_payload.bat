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
IF NOT EXIST Payloads\*.* (
	del /q Payloads 2>nul
	mkdir Payloads
)
call "%associed_language_script%" "display_title"
:list_payloads
copy nul templogs\payload_list.txt >nul
set max_payload=1
cd Payloads
for %%z in (*.bin) do (
	echo !max_payload!: %%z >>..\templogs\payloads_list.txt
	set /a max_payload+=1
)
cd ..
:select_payload
set payload_number=
call "%associed_language_script%" "begin_payload_choice"
echo.
TOOLS\gnuwin32\bin\tail.exe -q -n+0 templogs\payloads_list.txt 
call "%associed_language_script%" "end_payload_choice"
IF "%payload_number%"=="" goto:finish_script
call TOOLS\Storage\functions\strlen.bat nb "%payload_number%"
set i=0
:check_chars_payload_number
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!payload_number:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_payload_number
		)
	)
	IF "!check_chars!"=="0" (
		goto:finish_script
	)
)
IF "%payload_number%"=="0" (
	call "%associed_language_script%" "payload_file_choice"
	set /p payload_path=<templogs\tempvar.txt
)
IF "%payload_number%"=="0" (
	IF "%payload_path%"=="" (
		call "%associed_language_script%" "no_payload_file_selected_error"
		goto:select_payload
	)
	goto:launch_payload
)
TOOLS\gnuwin32\bin\grep.exe "%payload_number%: " <templogs\payloads_list.txt | TOOLS\gnuwin32\bin\cut.exe -d : -f 2 > templogs\tempvar.txt
set /p payload_path=<templogs\tempvar.txt
IF "%payload_path%"=="" (
	goto:finish_script
)
set payload_path=%payload_path:~1,-1%
:launch_payload
call "%associed_language_script%" "rcm_instructions"
IF "%payload_number%"=="0" (
	tools\TegraRcmSmash\TegraRcmSmash.exe -w "%payload_path%"
) else (
	tools\TegraRcmSmash\TegraRcmSmash.exe -w "payloads\%payload_path%"
)
IF %errorlevel% GTR 0 (
	call "%associed_language_script%" "launch_payload_error"
) else (
	call "%associed_language_script%" "launch_payload_success"
)
:end_script
pause 
:finish_script
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal