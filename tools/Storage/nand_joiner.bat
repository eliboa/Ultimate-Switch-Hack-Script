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
IF NOT EXIST "%dump_input%\rawnand.bin.00" (
	set error_input=Y
	goto:skip_verif_input
)
set /a dump_parts=0
for %%f in ("%dump_input%\rawnand.bin.*") do (
	set /a dump_parts+=1
)
set /a temp_dump_parts=%dump_parts%-1
set hekate_files_copy_param=
for /l %%i in (0,1,%temp_dump_parts%) do (
	IF %%i LSS 10 (
		IF NOT EXIST "%dump_input%\rawnand.bin.0%%i" (
			set error_input=Y
			goto:skip_verif_input
		) else (
			IF %%i LSS %temp_dump_parts% (
				set hekate_files_copy_param=!hekate_files_copy_param!rawnand.bin.0%%i + 
			) else (
				set hekate_files_copy_param=!hekate_files_copy_param!rawnand.bin.0%%i
			)
		)
	) else (
		IF NOT EXIST "%dump_input%\rawnand.bin.%%i" (
			set error_input=Y
			goto:skip_verif_input
		) else (
			IF %%i LSS %temp_dump_parts% (
				set hekate_files_copy_param=!hekate_files_copy_param!rawnand.bin.%%i + 
			) else (
				set hekate_files_copy_param=!hekate_files_copy_param!rawnand.bin.%%i
			)
		)
	)
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
:verif_existing_file
IF EXIST "%dump_output%\rawnand.bin" (
	set /p erase_existing_dump=Un fichier "rawnand.bin" a été trouvé à l'emplacement de copie du nouveau dump, souhaitez-vous écraser le dump précédent ^(la suppression du dump sera faite tout de suite après ce choix donc soyez prudent^)? ^(O/n^): 
)
IF NOT "%erase_existing_dump%"=="" set erase_existing_dump=%erase_existing_dump:~0,1%
IF EXIST "%dump_output%\rawnand.bin" (
	IF /i "%erase_existing_dump%"=="o" (
		del /q "%dump_output%\rawnand.bin"
		goto:verif_disk_free_space
	) else (
		echo Opération annulée.
		goto:end_script
	)
)
:verif_disk_free_space
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\get_free_space_for_path.vbs" "%dump_output%"
set /p free_space=<templogs\volume_free_space.txt
call "tools\Storage\functions\check_disk_free_space.bat" "%free_space%" "31268536320"
IF "%verif_free_space%"=="OK" (
	goto:copy_nand
) else (
	goto:error_disk_free_space
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
	copy /b %hekate_files_copy_param% "%dump_output%\rawnand.bin"
)
IF "%cfw_used%"=="2" (
copy /b full.00.bin + full.01.bin + full.02.bin + full.03.bin + full.04.bin + full.05.bin + full.06.bin + full.07.bin "%dump_output%\rawnand.bin"
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
goto:end_script

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