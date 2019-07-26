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
echo.
call "%associed_language_script%" "input_nand_file_choice"
set /p dump_path=<"templogs\tempvar.txt"
IF "%dump_path%"=="" (
	call "%associed_language_script%" "no_input_nand_file_selected_error"
	goto:end_script
)
echo.
call "%associed_language_script%" "input_biskeys_file_choice"
set /p biskeys_path=<"templogs\tempvar.txt"
IF "%biskeys_path%"=="" (
	call "%associed_language_script%" "no_input_biskeys_file_selected_error"
	goto:end_script
)
"tools\python3_scripts\FVI\FVI.exe" -b="%biskeys_path%" "%dump_path%" >templogs\log.txt
IF %errorlevel% NEQ 0 (
	echo.
	call "%associed_language_script%" "dump_infos_error"
	goto:end_script
)
"tools\gnuwin32\bin\tail.exe" --lines=2 <"templogs\log.txt" >templogs\log2.txt
"tools\gnuwin32\bin\tail.exe" --lines=1 <"templogs\log2.txt" | "tools\gnuwin32\bin\cut.exe" -d : -f 2- >templogs\log.txt
set /p last_launch_info=<templogs\log.txt
set last_launch_info=%last_launch_info:~1%
"tools\gnuwin32\bin\head.exe" --lines=1 <"templogs\log2.txt" | "tools\gnuwin32\bin\cut.exe" -d : -f 2- >templogs\log.txt
set /p firmware_info=<templogs\log.txt
set firmware_info=%firmware_info:~1%
echo %firmware_info% | "tools\gnuwin32\bin\cut.exe" -d " " -f 1 >templogs\tempvar.txt
set /p firmware_version=<templogs\tempvar.txt
echo %firmware_info% | "tools\gnuwin32\bin\cut.exe" -d " " -f 2- >templogs\tempvar.txt
set /p firmware_exfat=<templogs\tempvar.txt
set firmware_exfat=%firmware_exfat:(=%
set firmware_exfat=%firmware_exfat:)=%
set firmware_exfat=%firmware_exfat: =%
IF /i "%firmware_exfat%"=="noexfat" (
	call "%associed_language_script%" "noexfat_firmware_infos"
) else (
	call "%associed_language_script%" "exfat_firmware_infos"
)
echo %last_launch_info% | "tools\gnuwin32\bin\cut.exe" -d " " -f 1 >templogs\tempvar.txt
set /p date_last_launch_info=<templogs\tempvar.txt
set date_last_launch_info=%date_last_launch_info: =%
echo %date_last_launch_info% | "tools\gnuwin32\bin\cut.exe" -d - -f 1 >templogs\tempvar.txt
set /p year_last_launch_info=<templogs\tempvar.txt
echo %date_last_launch_info% | "tools\gnuwin32\bin\cut.exe" -d - -f 2 >templogs\tempvar.txt
set /p month_last_launch_info=<templogs\tempvar.txt
echo %date_last_launch_info% | "tools\gnuwin32\bin\cut.exe" -d - -f 3 >templogs\tempvar.txt
set /p day_last_launch_info=<templogs\tempvar.txt
set day_last_launch_info=%day_last_launch_info: =%
echo %last_launch_info% | "tools\gnuwin32\bin\cut.exe" -d " " -f 2 >templogs\tempvar.txt
set /p hour_last_launch_info=<templogs\tempvar.txt
set hour_last_launch_info=%hour_last_launch_info: =%
call "%associed_language_script%" "date_last_launch_infos"
:end_script
pause
:finish_script
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal