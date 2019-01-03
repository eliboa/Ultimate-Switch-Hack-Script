::Script by Shadow256, using a part of a script of Eliboa
chcp 65001 > nul
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	echo Aucune connexion internet disponible, mise à jour annulée.
	goto:end_script
)
cd tools\shofel2
IF EXIST "master.zip" del /q master.zip
if exist conf\ RMDIR /S /Q conf
if exist coreboot\ RMDIR /S /Q coreboot
if exist dtb\ RMDIR /S /Q dtb
if exist image\ RMDIR /S /Q image
if exist kernel\ RMDIR /S /Q kernel
..\gnuwin32\bin\wget.exe --no-check-certificate --content-disposition -S -O "master.zip" https://github.com/SoulCipher/shofel2_linux/archive/master.zip
title Shadow256 Ultimate Switch Hack Script
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
echo Mise à jour effectuée.
:end_script
pause