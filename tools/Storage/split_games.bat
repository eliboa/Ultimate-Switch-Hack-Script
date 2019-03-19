::Script by Shadow256
Setlocal enabledelayedexpansion
@echo off
chcp 65001 >nul
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
echo Ce script permet de découper un NSP en plusieurs fichiers de 4 GO.
echo Il permet également de pouvoir découper un XCI avec XCI-Cutter.
echo.
pause
echo.
echo Que souhaitez-vous faire:
echo 1: Découper un NSP?
echo 2: Découper un XCI?
echo N'importe quel autre choix: Revenir au menu précédent.
echo.
set /p cut_type=Faites votre choix: 
IF NOT "%cut_type%"=="" set cut_type=%cut_type:~0,1%
IF "%cut_type%"=="1" goto:NSP_cut
IF "%cut_type%"=="2" goto:XCI_cut
goto:finish_script
:NSP_cut
echo.
echo Comment Souhaitez-vous découper votre NSP:
echo 1: Découper le fichier et concerver le fichier original?
echo 2: Découper le fichier mais ne pas concerver le fichier original (plus rapide)?
echo N'importe quel autre choix: Revenir au menu précédent.
echo.
set /p split_type=Choisissez comment le découpage du fichier sera fait: 
IF NOT "%split_type%"=="" set split_type=%split_type:~0,1%
IF "%split_type%"=="1" (
	set params=
) else IF "%split_type%"=="2" (
	set params=-q
) else (
	goto:finish_script
)
echo.
echo Veuillez renseigner le fichier NSP dans la fenêtre suivante.
pause
%windir%\system32\wscript.exe //Nologo "tools\Storage\functions\open_file.vbs" "" "Fichier NSP(*.nsp)|*.nsp|" "Sélection du fichier NSP" "templogs\tempvar.txt"
set /p nsp_path=<"templogs\tempvar.txt"
IF "%nsp_path%"=="" (
	echo Aucun fichier NSP renseigné, le script va s'arrêter.
	goto:end_script
	)
IF "%split_type%"=="1" (
	echo.
	echo Vous allez devoir sélectionner le dossier dans lequel le NSP découpé sera extrait.
	pause
	%windir%\system32\wscript.exe //Nologo tools\Storage\functions\select_dir.vbs "templogs\tempvar.txt"
	set /p filepath=<templogs\tempvar.txt
)
IF "%split_type%"=="1" (
	IF "%filepath%"=="" (
		echo Aucun dossier sélectionné, le script va s'arrêter.
		goto:end_script
	)
)
IF "%split_type%"=="1" set filepath=%filepath%\
IF "%split_type%"=="1" set filepath=%filepath:\\=\%
IF "%split_type%"=="2" (
	"tools\python3_scripts\splitNSP\splitNSP.exe" %params% "%nsp_path%"
) else (
	"tools\python3_scripts\splitNSP\splitNSP.exe" %params% -o %filepath% "%nsp_path%"
)
IF %errorlevel% NEQ 0 (
	echo.
	echo Une erreur inconnue s'est produite.
	goto:end_script
)
echo.
echo Découpage du NSP terminée.
goto:end_script
:XCI_cut
echo XCI Cutter va être lancé pour permettre de découper votre XCI.
pause
start "tools\XCI-Cutter\XCI-Cutter.exe"
:end_script
pause
:finish_script
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal