::Script by Shadow256, using a part of a script of Eliboa
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
call "%associed_language_script%" "display_title"
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "no_internet_connection_error"
	goto:end_script
)
call "%associed_language_script%" "update_begin"
cd tools\shofel2
IF EXIST "master.zip" del /q master.zip
if exist conf\ RMDIR /S /Q conf
if exist coreboot\ RMDIR /S /Q coreboot
if exist dtb\ RMDIR /S /Q dtb
if exist image\ RMDIR /S /Q image
if exist kernel\ RMDIR /S /Q kernel
..\gnuwin32\bin\wget.exe --no-check-certificate --content-disposition -S -O "master.zip" https://github.com/SoulCipher/shofel2_linux/archive/master.zip
call "%associed_language_script%" "display_title"
..\7zip\7za.exe x -y -sccUTF-8 "master.zip" -r
del /q master.zip
move shofel2_linux-master\conf .\
move shofel2_linux-master\coreboot .\
move shofel2_linux-master\dtb .\
move shofel2_linux-master\image .\
move shofel2_linux-master\kernel\Image.gz ..\linux_kernels\Image_1.gz
move shofel2_linux-master\kernel .\
rmdir /s/q shofel2_linux-master
cd ..\..
echo.
call "%associed_language_script%" "update_end"
:end_script
pause
endlocal