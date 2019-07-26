::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
call "%associed_language_script%" "display_title"
Setlocal disabledelayedexpansion
echo.
call "%associed_language_script%" "display_infos"
endlocal
endlocal