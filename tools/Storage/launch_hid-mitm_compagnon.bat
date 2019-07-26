call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
:start
cls
set IP_Adress=
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "intro"
ECHO.
call "%associed_language_script%" "ip_choice"
IF "%IP_Adress%"=="" goto:end_script
tools\Hid-mitm_compagnon\input_pc_win.exe %IP_Adress%
ECHO.
goto start
:end_script
endlocal