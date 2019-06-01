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
"tools\python3_scripts\FVI\FVI.exe" -b="%biskeys_path%" "%dump_path%" >templogs\log.txt
IF %errorlevel% NEQ 0 (
	echo.
	echo Une erreur inconnue s'est produite.
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
	echo Firmware %firmware_version% ne possédant pas le driver EXFAT.
) else (
	echo Firmware %firmware_version% possédant le driver EXFAT.
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
echo Dernière date de lancement du firmware: %day_last_launch_info%-%month_last_launch_info%-%year_last_launch_info% à %hour_last_launch_info%
:end_script
pause
:finish_script
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal