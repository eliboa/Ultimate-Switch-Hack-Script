::Script by Eliboa, modified by Shadow256
@echo off
chcp 65001 >nul
setlocal
del /q tools\shofel2\kernel\Image.gz 2>nul
cd tools\shofel2
if not exist conf\imx_usb.conf set MISSING=1
if not exist conf\switch.conf set MISSING=1
if not exist coreboot\cbfs.bin set MISSING=1
if not exist coreboot\coreboot.rom set MISSING=1
if not exist dtb\tegra210-nintendo-switch.dtb set MISSING=1
if not exist image\switch.scr.img set MISSING=1
if not exist kernel\*.* set MISSING=1
cd ..\..
IF "%MISSING%"=="1" (
	echo Des fichiers sont manquants et Linux ne pourra pas être lancé.
	echo Veuillez utiliser l'option de mise à jour de Shofel2 dans le menu principal pour corriger ce problème.
	pause
	set MISSING=
	goto:end_script
)
:choose_kernel
echo Choisissez un kernel.
echo.
echo 1: Kernel officiel (recommandé)
echo 2: Kernel patché (si vous avez des erreurs de carte SD au chargement du kernel)
echo 0: Choisir un fichier de kernel personnel
echo Tout autre choix: Quitter le script.
echo.
set /p choose_kernel=Entrez le numéro du kernel à utiliser: 
IF "%choose_kernel%"=="0" (
	mkdir templogs
	%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichier de kernel Linux (*.gz)|*.gz|" "Sélection du kernel" "templogs\tempvar.txt"
	set /p kernel_path=<templogs\tempvar.txt
	rmdir /s /q templogs
)
IF "%choose_kernel%"=="0" (
	IF "%kernel_path%"=="" (
		Aucun kernel sélectionné, le lancement de Linux est annulé.
		pause
		goto:end_script
	) else (
		copy "%kernel_path%" tools\shofel2\kernel\Image.gz
		set kernel_path=
		goto:launch_linux
	)
)
IF "%choose_kernel%"=="1" (
	IF NOT EXIST "tools\linux_kernels\Image_1.gz" (
	echo Des fichiers sont manquants et Linux ne pourra pas être lancé.
	echo Veuillez utiliser l'option de mise à jour de Shofel2 dans le menu principal pour corriger ce problème.
	pause
	goto:end_script
	)
	copy tools\linux_kernels\Image_1.gz tools\shofel2\kernel\Image.gz
) else IF "%choose_kernel%"=="2" (
	copy tools\linux_kernels\Image_2.gz tools\shofel2\kernel\Image.gz
) else (
	goto:end_script
)
:launch_linux
echo *********************************************
echo ***    CONNECTEZ LA SWITCH EN MODE RCM    ***
echo *********************************************
echo 1) Connecter la Switch en USB et l'éteindre
echo 2) Appliquer le JoyCon Haxx : PIN1 + PIN10 ou PIN9 + PIN10
echo 3) Faire un appui long sur VOLUME UP + appui court sur POWER
tools\TegraRcmSmash\TegraRcmSmash.exe -w --relocator= "tools\shofel2\coreboot\cbfs.bin" "CBFS:tools\shofel2\coreboot\coreboot.rom"
echo Switch détectée. Attendons 5 secondes...
SLEEP 5
cd tools\shofel2\
imx_usb.exe -c conf\
cd ..\..
echo *********************************************
echo ***   ATTENDEZ QUE LA SWITCH REDEMARRE    ***
echo *********************************************
tools\TegraRcmSmash\TegraRcmSmash.exe -w --relocator= "tools\shofel2\coreboot\cbfs.bin" "CBFS:tools\shofel2\coreboot\coreboot.rom"
echo Switch détectée. Attendons 5 secondes...
SLEEP 5
cd tools\shofel2\
imx_usb.exe -c conf\
cd ..\..
echo *********************************************
echo *** LINUX DEVRAIT SE LANCER SUR LA SWITCH ***
echo *********************************************
pause
:end_script
set choose_kernel=
del /q tools\shofel2\kernel\Image.gz 2>nul
endlocal