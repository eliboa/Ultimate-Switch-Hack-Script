::Script by Shadow256
Setlocal enabledelayedexpansion
@echo off
chcp 65001 >nul
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
echo Ce script permet d'obtenir le firmware sur lequel se trouve un dump d'une nand ainsi que de savoir si le driver EXFAT est inclu ou non.
echo Vous aurez besoin d'un fichier de dump de la nand en une seule partie ainsi que des Bis keys associées à ce dump pour que ce script fonctionne correctement.
echo.
pause
echo.
echo Veuillez renseigner le fichier de dump de la nand dans la fenêtre suivante.
pause
%windir%\system32\wscript.exe //Nologo "tools\Storage\functions\open_file.vbs" "" "Fichier bin(*.bin)|*.bin|" "Sélection du fichier de dump de la nand" "templogs\tempvar.txt"
set /p dump_path=<"templogs\tempvar.txt"
IF "%dump_path%"=="" (
	echo Aucun fichier de dump de nand renseigné, le script va s'arrêter.
	goto:end_script
)
echo.
echo Veuillez renseigner le fichier contenant les Bis keys associé au dump de la nand dans la fenêtre suivante.
pause
%windir%\system32\wscript.exe //Nologo "tools\Storage\functions\open_file.vbs" "" "Tous les fichiers(*.*)|*.*|" "Sélection du fichier contenant les biskeys du dump de la nand" "templogs\tempvar.txt"
set /p biskeys_path=<"templogs\tempvar.txt"
IF "%biskeys_path%"=="" (
	echo Aucun fichier de dump des clés renseigné, le script va s'arrêter.
	goto:end_script
)
"tools\python3_scripts\FVI\FVI.exe" -b="%biskeys_path%" "%dump_path%"
IF %errorlevel% NEQ 0 (
	echo.
	echo Une erreur inconnue s'est produite.
	goto:end_script
)
:end_script
pause
:finish_script
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal