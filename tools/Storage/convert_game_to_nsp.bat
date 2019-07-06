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
echo Vous allez devoir sélectionner le dossier vers lequel le NSP converti sera extrait.
pause
%windir%\system32\wscript.exe //Nologo tools\Storage\functions\select_dir.vbs "..\..\templogs\tempvar.txt"
set /p output_path=<..\..\templogs\tempvar.txt
IF "%output_path%"=="" (
	echo Aucun dossier sélectionné, la conversion est annulée.
	goto:end_script
) else (
	set output_path=!output_path!\
	set output_path=!output_path:\\=\!
)
set /p rename_target=Souhaitez-vous que le NSP généré soit renommé grâce au nom du jeu plutôt que grâce à l'ID de celui-ci? (O/n): 
IF NOT "%rename_target%"=="" set rename_target=%rename_target:~0,1%
IF /i NOT "%rename_target%"=="o" set params=-r 
set /p keepncaid=Souhaitez-vous que l'ID des NCA du NSP soit gardés (ne pas activer cette option est recommandé)? (O/n): 
IF NOT "%keepncaid%"=="" set keepncaid=%keepncaid:~0,1%
IF /i NOT "%keepncaid%"=="o" set params=--keepncaid
"4nxci.exe" %params% -o "%output_path%" -t "..\..\templogs" "%game_path%"
IF %errorlevel% NEQ 0 (
	echo.
	echo Erreur pendant la tentative de conversion.
) else (
	echo.
	echo Conversion terminée avec succès.
)
:end_script
pause
cd ..\..
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal