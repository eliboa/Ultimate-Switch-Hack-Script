::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "rcm_instructions"
tools\TegraRcmSmash\TegraRcmSmash.exe -w tools\biskeydump\biskeydump.bin BOOT:0x0 >biskey.txt
::TOOLS\gnuwin32\bin\tail.exe -q -n+7 biskey.txt > biskey2.txt
echo.
call "%associed_language_script%" "script_success"
pause
endlocal