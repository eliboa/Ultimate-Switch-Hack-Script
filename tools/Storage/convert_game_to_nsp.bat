::Script by Shadow256
Setlocal enabledelayedexpansion
@echo off
chcp 65001 >nul
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
echo Ce script va permettre de convertir un fichier XCI au format NSP, fichier installable via Tinfoil, SXOS ou encore le DevMenu.
echo Attention: Il est préférable de ne pas exécuter ce script sur une partition formatée en FAT32 à cause de la limite de création de fichiers de plus de  4 GO de ce système de fichiers.
echo.
pause
cd TOOLS\Hactool_based_programs
IF NOT EXIST keys.dat (
	IF EXIST keys.txt (
		copy keys.txt keys.dat
		goto:skip_keys_file_creation
	)
	echo Fichiers clés non trouvé, veuillez suivre les instructions.
	goto:keys_file_creation
) else (
	goto:skip_keys_file_creation
)
:keys_file_creation
echo.
echo Veuillez renseigner le fichier de clés dans la fenêtre suivante.
pause
%windir%\system32\wscript.exe //Nologo "..\Storage\functions\open_file.vbs" "" "Fichier de liste de clés Switch(*.*)|*.*|" "Sélection du fichier de clés pour Hactool" "..\..\templogs\tempvar.txt"
	set /p keys_file_path=<"..\..\templogs\tempvar.txt"
	IF "%keys_file_path%"=="" (
	echo Aucun fichier clés renseigné, le script va s'arrêter.
	goto:end_script
	)
	
	copy "%keys_file_path%" keys.dat
	
:skip_keys_file_creation
echo.
echo Vous allez devoir sélectionner le fichier XCI à convertir.
pause
%windir%\system32\wscript.exe //Nologo ..\Storage\functions\open_file.vbs "" "Fichier de jeu Switch (*.xci)|*.xci|" "Sélection du jeu à convertir" "..\..\templogs\tempvar.txt"
set /p game_path=<..\..\templogs\tempvar.txt
IF "%game_path%"=="" (
	echo Aucun jeu sélectionné, la conversion est annulée.
	goto:end_script
)
set /p skip_ticket_creation=Souhaitez-vous qu'un  ticket et un certificat vides soient créé et intégré au NSP? (Ne pas les créés est recommandé) (O/n): 
IF NOT "%skip_ticket_creation%"=="" set skip_ticket_creation=%skip_ticket_creation:~0,1%
IF /i NOT "%skip_ticket_creation%"=="o" set params=--dummytik
"4nxci.exe" %params% "%game_path%"
IF %errorlevel% NEQ 0 (
	echo.
	echo Erreur pendant la tentative de conversion.
) else (
	IF NOT EXIST "..\..\packed_NSPs\*.*" mkdir "..\..\packed_NSPs"
	move *.nsp ..\..\packed_NSPs
	echo.
	echo Conversion terminée avec succès.
	echo Le fichier converti se trouve dans le répertoire "packed_NSPs" du script.
)
:end_script
IF EXIST "4nxci_extracted_xci\*.*" rmdir /q /s "4nxci_extracted_xci"
pause
cd ..\..
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal