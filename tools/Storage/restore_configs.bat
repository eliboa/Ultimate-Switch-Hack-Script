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
call "%associed_language_script%" "restaure_file_select"
set /p filepath=<templogs\tempvar.txt
IF NOT "%filepath%"=="" (
	TOOLS\7zip\7za.exe x -y -sccUTF-8 "%filepath%" -o"." -r
	call "%associed_language_script%" "restaure_success"
) else (
	call "%associed_language_script%" "restaure_cancel"
)
rmdir /s /q templogs
pause 
endlocal