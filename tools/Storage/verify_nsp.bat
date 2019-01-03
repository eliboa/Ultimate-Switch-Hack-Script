::Script by Shadow256
Setlocal enabledelayedexpansion
@echo off
chcp 65001 >nul
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
echo Ce script permet de vérifier les fichiers NSP contenus dans un dossier et ses sous-dossiers.
echo Une fois terminé, les fichiers listants les NSP ayant un problème se trouveront à la racine du script.
echo Si aucun fichier n'a été créé, cela signifie que les NSPs vérifiés n'ont aucun problèmes.
echo.
pause
cd TOOLS\Hactool_based_programs
IF NOT EXIST keys.txt (
	IF EXIST keys.dat (
		copy keys.dat keys.txt
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
	
	copy "%keys_file_path%" keys.txt
	
:skip_keys_file_creation
echo.
echo Vous allez devoir sélectionner le dossier contenant vos fichiers NSP. Notez que les sous-dossiers seront également scanés.
pause
%windir%\system32\wscript.exe //Nologo ..\Storage\functions\select_dir.vbs "..\..\templogs\tempvar.txt"
set /p filepath=<..\..\templogs\tempvar.txt
IF NOT "%filepath%"=="" set filepath=%filepath%\
IF NOT "%filepath%"=="" (
	set filepath=%filepath:\\=\%
) else (
	echo Aucun dossier sélectionné, la vérification est annulée.
	goto:end_script
)
"NSPVerify.exe" "%filepath%"
IF %errorlevel% NEQ 0 (
	echo.
	echo Une erreur inconnue s'est produite.
	goto:end_script
)
IF EXIST "Corrupted NSPs.txt" (
..\gnuwin32\bin\grep.exe -c "None of the files are corrupted." <"Corrupted NSPs.txt" >..\..\templogs\tempvar.txt
	set /p corupted_nsps=<..\..\templogs\tempvar.txt
)
IF %corupted_nsps% EQU 1 (
	del /q "Corrupted NSPs.txt"
	echo Tout les NSPs vérifiés semblent n'avoir aucune erreur selon NSPVerify.
)
IF EXIST "Exception Log.txt" (
	..\gnuwin32\bin\grep.exe -c "No exceptions to log." <"Exception Log.txt" >..\..\templogs\tempvar.txt
	set /p exceptions_log=<..\..\templogs\tempvar.txt
)
IF %exceptions_log% EQU 1 (
	del /q "Exception Log.txt"
	Echo Aucun problème ne semble avoir été rencontré pendant l'exécution de NSPVerify.
)
echo.
echo Vérification des fichiers terminée.
:end_script
pause
IF EXIST "Corrupted NSPs.txt" move "Corrupted NSPs.txt" "..\..\"Corrupted_NSPs.txt"
IF EXIST "Exception Log.txt" move "Exception Log.txt" "..\..\NSPVerify_Exceptions_log.txt"
cd ..\..
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal