::Script by Shadow256
@echo off
chcp 65001 >nul
Setlocal
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
echo Ce script permet de vérifier le contenu d'un fichier de clés et d'indiquer les clés inconnues/uniques qu'il contient ainsi que les clés incorrecte.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\open_file.vbs" "" "Tous les fichiers (*.*)|*.*|" "Sélection du fichier de clés" "templogs\tempvar.txt"
set /p keys_file_path=<"templogs\tempvar.txt"
if "%keys_file_path%"=="" (
	echo Aucun fichier sélectionné, le script va s'arrêter.
	goto:end_script
)
tools\python3_scripts\Keys_management\keys_management.exe test_keys_file "%keys_file_path%"
echo.
:end_script
pause
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
endlocal