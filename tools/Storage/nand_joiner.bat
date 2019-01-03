::Script by Shadow256
@echo off
chcp 65001 >nul
Setlocal enabledelayedexpansion
set this_script_dir=%~dp0
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
echo Ce script permet de joindre un dump de la nand Switch effectué par Hekate ou SX OS qui a été découpé (carte formatée en FAT32 pour le dump, carte SD trop petite pour faire un dump en une fois...).
echo Une fois le dump terminé, il sera nommé "rawnand.bin" et se trouvera dans le répertoire indiqué lors du script.
pause
echo Quel moyen avez-vous utilisé pour faire votre dump?
echo 1: Hekate.
echo 2: SX OS.
echo N'importe quel autre choix: Retourne au menu précédent.
echo.
set /p cfw_used=Faites votre choix: 
IF "%cfw_used%"=="1" goto:folders_choice
IF "%cfw_used%"=="2" goto:folders_choice
goto:end_script_2
:folders_choice
echo.
echo Vous allez devoir sélectionner le répertoire dans lequel se trouve vos fichiers de dump.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt"
set /p dump_input=<"templogs\tempvar.txt"
IF "%dump_input%"=="" (
	echo Aucun dossier sélectionné, le script va s'arrêter.
	goto:end_script
)
set dump_input=%dump_input:\\=\%
IF "%cfw_used%"=="1" goto:verif_hekate_dump
IF "%cfw_used%"=="2" goto:verif_sx_dump
:verif_hekate_dump
IF NOT EXIST "%dump_input%\rawnand.bin.14" (
	set error_input=Y
	goto:skip_verif_input
)
IF EXIST "%dump_input%\rawnand.bin.15" (
	set dump_parts=30
)
IF "%dump_parts%"=="30" (
	IF NOT EXIST "%dump_input%\rawnand.bin.29" (
		set error_input=Y
		goto:skip_verif_input
	) else (
		set dump_parts=15
	)
)
IF NOT EXIST "%dump_input%\rawnand.bin.00" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.01" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.02" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.03" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.04" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.05" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.06" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.07" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.08" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.09" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.10" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.11" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.12" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.13" (
	set error_input=Y
	goto:skip_verif_input
)
IF "%dump_parts%"=="15" goto:skip_verif_input
IF NOT EXIST "%dump_input%\rawnand.bin.15" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.16" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.17" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.18" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.19" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.20" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.21" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.22" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.23" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.24" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.25" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.26" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.27" (
	set error_input=Y
	goto:skip_verif_input
)
IF NOT EXIST "%dump_input%\rawnand.bin.28" (
	set error_input=Y
	goto:skip_verif_input
)
:skip_verif_input
IF "%error_input%"=="Y" (
	echo Il semble que des fichiers du dump soient manquants, la copie ne peut donc pas avoir lieu et ce script va s'arrêter.
	goto:end_script
)
goto:output_select
:verif_sx_dump
IF NOT EXIST "%dump_input%\full.00.bin" (
	set error_input=Y
	goto:skip_verif_input_sx
)
IF NOT EXIST "%dump_input%\full.01.bin" (
	set error_input=Y
	goto:skip_verif_input_sx
)
IF NOT EXIST "%dump_input%\full.02.bin" (
	set error_input=Y
	goto:skip_verif_input_sx
)
IF NOT EXIST "%dump_input%\full.03.bin" (
	set error_input=Y
	goto:skip_verif_input_sx
)
IF NOT EXIST "%dump_input%\full.04.bin" (
	set error_input=Y
	goto:skip_verif_input_sx
)
IF NOT EXIST "%dump_input%\full.05.bin" (
	set error_input=Y
	goto:skip_verif_input_sx
)
IF NOT EXIST "%dump_input%\full.06.bin" (
	set error_input=Y
	goto:skip_verif_input_sx
)
IF NOT EXIST "%dump_input%\full.07.bin" (
	set error_input=Y
	goto:skip_verif_input_sx
)
:skip_verif_input_sx
IF "%error_input%"=="Y" (
	echo Il semble que des fichiers du dump soient manquants, la copie ne peut donc pas avoir lieu et ce script va s'arrêter.
	goto:end_script
)
goto:output_select
:output_select
echo.
echo Vous allez maintenant devoir sélectionner le répertoire vers lequel sera copié le fichier "rawnand.bin" du dump joint. Attention, le dossier devra se trouver sur une partition supportant les fichiers de plus de 4 GO (EXFAT, NTFS). Notez qu'une fois le fichier créé et son bon fonctionnement confirmé par vos soins, les fichiers découpés pouront être supprimé.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt"
set /p dump_output=<"templogs\tempvar.txt"
IF "%dump_output%"=="" (
	echo Aucun dossier sélectionné, le script va s'arrêter.
	goto:end_script
)
set dump_output=%dump_output:\\=\%
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\get_free_space_for_path.vbs" "%dump_output%"
set /p free_space=<templogs\volume_free_space.txt
call TOOLS\Storage\functions\strlen.bat nb "%free_space%"
set /a nb=%nb%
IF %nb% GTR 11 (
	goto:copy_nand
) else IF %nb% LSS 11 (
	goto:error_disk_free_space
)
IF %nb% EQU 11 (
	IF %free_space:~0,1% GTR 3 (
		goto:copy_nand
	) else IF %free_space:~0,1% LSS 3 (
		goto:error_disk_free_space
	)
	IF %free_space:~1,1% GTR 1 (
		goto:copy_nand
	) else IF %free_space:~1,1% LSS 1 (
		goto:error_disk_free_space
	)
	IF %free_space:~2,1% GTR 2 (
		goto:copy_nand
	) else IF %free_space:~2,1% LSS 2 (
		goto:error_disk_free_space
	)
	IF %free_space:~3,1% GTR 6 (
		goto:copy_nand
	) else IF %free_space:~3,1% LSS 6 (
		goto:error_disk_free_space
	)
	IF %free_space:~4,1% GTR 8 (
		goto:copy_nand
	) else IF %free_space:~4,1% LSS 8 (
		goto:error_disk_free_space
	)
	IF %free_space:~5,1% GTR 5 (
		goto:copy_nand
	) else IF %free_space:~5,1% LSS 5 (
		goto:error_disk_free_space
	)
	IF %free_space:~6,1% GTR 3 (
		goto:copy_nand
	) else IF %free_space:~6,1% LSS 3 (
		goto:error_disk_free_space
	)
	IF %free_space:~7,1% GTR 6 (
		goto:copy_nand
	) else IF %free_space:~7,1% LSS 6 (
		goto:error_disk_free_space
	)
	IF %free_space:~8,1% GTR 3 (
		goto:copy_nand
	) else IF %free_space:~8,1% LSS 3 (
		goto:error_disk_free_space
	)
	IF %free_space:~9,1% GTR 2 (
		goto:copy_nand
	) else IF %free_space:~9,1% LSS 2 (
		goto:error_disk_free_space
	)
	IF %free_space:~10,1% GEQ 0 (
		goto:copy_nand
	)
)
:error_disk_free_space
echo.
echo Il n'y a pas assez d'espace libre à l'emplacement sur lequel vous souhaitez copier votre dump, le script va s'arrêter.
goto:end_script
:copy_nand
echo.
echo Copie en cours...
cd /d "%dump_input%"
IF "%cfw_used%"=="1" (
	IF "%dump_parts%"=="15" (
		%windir%\system32\copy /b rawnand.bin.00 + rawnand.bin.01 + rawnand.bin.02 + rawnand.bin.03 + rawnand.bin.04 + rawnand.bin.05 + rawnand.bin.06 + rawnand.bin.07 + rawnand.bin.08 + rawnand.bin.09 + rawnand.bin.10 + rawnand.bin.11 + rawnand.bin.12 + rawnand.bin.13 + rawnand.bin.14 "%dump_output%\rawnand.bin"
	) else (
		%windir%\system32\copy /b rawnand.bin.00 + rawnand.bin.01 + rawnand.bin.02 + rawnand.bin.03 + rawnand.bin.04 + rawnand.bin.05 + rawnand.bin.06 + rawnand.bin.07 + rawnand.bin.08 + rawnand.bin.09 + rawnand.bin.10 + rawnand.bin.11 + rawnand.bin.12 + rawnand.bin.13 + rawnand.bin.14 + rawnand.bin.15 + rawnand.bin.16 + rawnand.bin.17 + rawnand.bin.18 + rawnand.bin.19 + rawnand.bin.20 + rawnand.bin.21 + rawnand.bin.22 + rawnand.bin.23 + rawnand.bin.24 + rawnand.bin.25 + rawnand.bin.26 + rawnand.bin.27 + rawnand.bin.28 + rawnand.bin.29 "%dump_output%\rawnand.bin"
	)
)
IF "%cfw_used%"=="2" (
%windir%\system32\copy /b full.00.bin + full.01.bin + full.02.bin + full.03.bin + full.04.bin + full.05.bin + full.06.bin + full.07.bin "%dump_output%\rawnand.bin"
)
IF %errorlevel% NEQ 0 (
	echo Il semble qu'une erreur se soit produite pendant la copie, le fichier créé va être supprimé s'il existe.
	echo Vérifiez que la partition sur laquelle vous copiez le fichier est une partition supportant les fichiers de plus de 4 GO et vérifiez également que vous avez au moins 30 GO de libre sur la partition sur lequel le fichier est copié puis réessayez.
	echo Vérifiez également que vous avez les droits en écriture pour le répertoire dans lequel vous essayez de copier le fichier.
	IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
	set copy_error=Y
)
call :test_rawnand_size "%dump_output%\rawnand.bin"
cd /D "%this_script_dir%\..\.."
IF "%copy_error%"=="Y" goto:end_script
echo Copie terminée.
echo.
set /p launch_hacdiskmount=Souhaitez-vous lancer HacDiskMount pour vérifier que le dump a bien été copié et qu'il fonctionne correctement (recommandé)? (O/n): 
IF NOT "%launch_hacdiskmount%"=="" set launch_hacdiskmount=%launch_hacdiskmount:~0,1%
IF /i "%launch_hacdiskmount%"=="o" (
	start tools\HacDiskMount\HacDiskMount.exe
)

:test_rawnand_size
IF NOT "%~z1"=="31268536320" (
	echo Il semble que la taille du fichier créé ne corresponde pas à la taille que devrait faire le dump de la nand, le fichier créé va donc être supprimé.
	echo Il est donc conseillé de refaire le dump de la nand puis de réessayer d'exécuter ce script.
	echo Si le dump est correct, vérifiez l'espace disque sur la partition sur laquelle vous essayez de copier le dump et vérifiez aussi que cette même partition ai un système de fichier supportant les fichiers de plus de 4 GO.
	IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
	set copy_error=Y
)
exit /B

:end_script
pause
:end_script_2
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
endlocal