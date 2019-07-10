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
echo Ce script permet de créer un fichier qui pourra ensuite être injecté dans une partition de la SD pour booter en emunand.
echo Au préalable, vous devez avoir un dossier contenant les fichiers "BOOT0", "BOOT1" et, selon le moyen de dump utilisé, le ou les fichiers de la rawnand ("rawnand.bin" ou "rawnand.bin.XX" pour Hekate et "full.XX.bin" pour SX OS (XX est pour les dumps splittés et représente le numéro de la partie)).
echo Notez que pour l'instant, les dumps splittés de Hekate supportés ne sont que les dumps en 15 ou 30 parties, le support d'autres types de dump sera ajouté plus tard.
echo Une fois le dump terminé, il sera nommé "emunand_partition.bin" et se trouvera dans le répertoire indiqué lors du script.
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
IF NOT EXIST "%dump_input%\BOOT0" (
	echo Fichier "BOOT0" introuvable, le script va donc s'arrêter.
	goto:end_script
)
IF NOT EXIST "%dump_input%\BOOT1" (
	echo Fichier "BOOT1" introuvable, le script va donc s'arrêter.
	goto:end_script
)
IF "%cfw_used%"=="1" goto:verif_hekate_dump
IF "%cfw_used%"=="2" goto:verif_sx_dump
:verif_hekate_dump
IF EXIST "%dump_input%\rawnand.bin" (
	set hekate_files_copy_param=BOOT0 + BOOT1 + rawnand.bin
	goto:skip_verif_input
)
set /a dump_parts=0
for %%f in ("%dump_input%\rawnand.bin.*") do (
	set /a dump_parts+=1
)
set /a temp_dump_parts=%dump_parts%-1
set hekate_files_copy_param=BOOT0 + BOOT1 + 
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
echo Vous allez maintenant devoir sélectionner le répertoire vers lequel sera copié le fichier "emunand_partition.bin" du dump joint. Attention, le dossier devra se trouver sur une partition supportant les fichiers de plus de 4 GO (EXFAT, NTFS).
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt"
set /p dump_output=<"templogs\tempvar.txt"
IF "%dump_output%"=="" (
	echo Aucun dossier sélectionné, le script va s'arrêter.
	goto:end_script
)
set dump_output=%dump_output:\\=\%
echo.
set add_sxos_first_1024=
echo Il est possible d'ajouter le code spécifique à SX OS pour détecter la partition que vous créerez pour injecter le dump. Par contre, vous devrez mettre la partition contenant l'emunand au tout début du disque.
set /p add_sxos_first_1024=Souhaitez-vous ajouter les 1024 premiers octets spécifiques à SX OS à votre dump? (O/n): 
IF NOT "%add_sxos_first_1024%"=="" set add_sxos_first_1024=%add_sxos_first_1024:~0,1%
:verif_existing_file
IF EXIST "%dump_output%\emunand_partition.bin" (
	set /p erase_existing_dump=Un fichier "emunand_partition.bin" a été trouvé à l'emplacement de copie du nouveau dump, souhaitez-vous écraser le dump précédent ^(la suppression du dump sera faite tout de suite après ce choix donc soyez prudent^)? ^(O/n^): 
)
IF NOT "%erase_existing_dump%"=="" set erase_existing_dump=%erase_existing_dump:~0,1%
IF EXIST "%dump_output%\emunand_partition.bin" (
	IF /i "%erase_existing_dump%"=="o" (
		del /q "%dump_output%\emunand_partition.bin"
		goto:verif_disk_free_space
	) else (
		echo Opération annulée.
		goto:end_script
	)
)
:verif_disk_free_space
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\get_free_space_for_path.vbs" "%dump_output%"
set /p free_space=<templogs\volume_free_space.txt
call TOOLS\Storage\functions\strlen.bat nb "%free_space%"
set /a nb=%nb%
IF /i NOT "%add_sxos_first_1024%"=="o" (
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
		IF %free_space:~3,1% GTR 7 (
			goto:copy_nand
		) else IF %free_space:~3,1% LSS 7 (
			goto:error_disk_free_space
		)
		IF %free_space:~4,1% GTR 6 (
			goto:copy_nand
		) else IF %free_space:~4,1% LSS 6 (
			goto:error_disk_free_space
		)
		IF %free_space:~5,1% GTR 9 (
			goto:copy_nand
		) else IF %free_space:~5,1% LSS 9 (
			goto:error_disk_free_space
		)
		IF %free_space:~6,1% GTR 2 (
			goto:copy_nand
		) else IF %free_space:~6,1% LSS 2 (
			goto:error_disk_free_space
		)
		IF %free_space:~7,1% GTR 4 (
			goto:copy_nand
		) else IF %free_space:~7,1% LSS 4 (
			goto:error_disk_free_space
		)
		IF %free_space:~8,1% GTR 9 (
			goto:copy_nand
		) else IF %free_space:~8,1% LSS 9 (
			goto:error_disk_free_space
		)
		IF %free_space:~9,1% GTR 2 (
			goto:copy_nand
		) else IF %free_space:~9,1% LSS 2 (
			goto:error_disk_free_space
		)
		IF %free_space:~10,1% GEQ 8 (
			goto:copy_nand
		)
	)
) else (
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
		IF %free_space:~3,1% GTR 7 (
			goto:copy_nand
		) else IF %free_space:~3,1% LSS 7 (
			goto:error_disk_free_space
		)
		IF %free_space:~4,1% GTR 6 (
			goto:copy_nand
		) else IF %free_space:~4,1% LSS 6 (
			goto:error_disk_free_space
		)
		IF %free_space:~5,1% GTR 9 (
			goto:copy_nand
		) else IF %free_space:~5,1% LSS 9 (
			goto:error_disk_free_space
		)
		IF %free_space:~6,1% GTR 2 (
			goto:copy_nand
		) else IF %free_space:~6,1% LSS 2 (
			goto:error_disk_free_space
		)
		IF %free_space:~7,1% GTR 5 (
			goto:copy_nand
		) else IF %free_space:~7,1% LSS 5 (
			goto:error_disk_free_space
		)
		IF %free_space:~8,1% GTR 9 (
			goto:copy_nand
		) else IF %free_space:~8,1% LSS 9 (
			goto:error_disk_free_space
		)
		IF %free_space:~9,1% GTR 5 (
			goto:copy_nand
		) else IF %free_space:~9,1% LSS 5 (
			goto:error_disk_free_space
		)
		IF %free_space:~10,1% GEQ 2 (
			goto:copy_nand
		)
	)
)
:error_disk_free_space
echo.
echo Il n'y a pas assez d'espace libre à l'emplacement sur lequel vous souhaitez copier le fichier, le script va s'arrêter.
goto:end_script


:copy_nand
echo.
echo Copie en cours...
cd /d "%dump_input%"
IF /i NOT "%add_sxos_first_1024%"=="o" (
	IF "%cfw_used%"=="1" (
		copy /v /b %hekate_files_copy_param% "%dump_output%\emunand_partition.bin"
	)
	IF "%cfw_used%"=="2" (
		copy /v /b BOOT0 + BOOT1 + full.00.bin + full.01.bin + full.02.bin + full.03.bin + full.04.bin + full.05.bin + full.06.bin + full.07.bin "%dump_output%\emunand_partition.bin"
	)
) else (
	IF "%cfw_used%"=="1" (
		copy /v /b "%this_script_dir%\..\tools\default_configs\sxos_first1024.bin" + %hekate_files_copy_param% "%dump_output%\emunand_partition.bin"
	)
	IF "%cfw_used%"=="2" (
		copy /v /b "%this_script_dir%\..\tools\default_configs\sxos_first1024.bin" + BOOT0 + BOOT1 + full.00.bin + full.01.bin + full.02.bin + full.03.bin + full.04.bin + full.05.bin + full.06.bin + full.07.bin "%dump_output%\emunand_partition.bin"
	)
)
IF %errorlevel% NEQ 0 (
	echo Il semble qu'une erreur se soit produite pendant la copie, le fichier créé va être supprimé s'il existe.
	echo Vérifiez que la partition sur laquelle vous copiez le fichier est une partition supportant les fichiers de plus de 4 GO et vérifiez également que vous avez au moins 30 GO de libre sur la partition sur lequel le fichier est copié puis réessayez.
	echo Vérifiez également que vous avez les droits en écriture pour le répertoire dans lequel vous essayez de copier le fichier.
	IF EXIST "%dump_output%\emunand_partition.bin" del /q "%dump_output%\emunand_partition.bin"
	set copy_error=Y
)
call :test_rawnand_size "%dump_output%\emunand_partition.bin"
cd /D "%this_script_dir%\..\.."
IF "%copy_error%"=="Y" goto:end_script
echo Copie terminée.
goto:end_script

:test_rawnand_size
IF /i NOT "%add_sxos_first_1024%"=="o" (
	IF NOT "%~z1"=="31276924928" (
		echo Il semble que la taille du fichier créé ne corresponde pas à la taille que devrait faire le fichier de l'emunand via partition, le fichier créé va donc être supprimé.
		echo Il est donc conseillé de refaire le dump de la nand puis de réessayer d'exécuter ce script.
		echo Si le dump est correct, vérifiez l'espace disque sur la partition sur laquelle vous essayez de copier le dump et vérifiez aussi que cette même partition ai un système de fichier supportant les fichiers de plus de 4 GO.
		IF EXIST "%dump_output%\emunand_partition.bin" del /q "%dump_output%\emunand_partition.bin"
		set copy_error=Y
	)
) else (
	IF NOT "%~z1"=="31276925952" (
		echo Il semble que la taille du fichier créé ne corresponde pas à la taille que devrait faire le fichier de l'emunand via partition, le fichier créé va donc être supprimé.
		echo Il est donc conseillé de refaire le dump de la nand puis de réessayer d'exécuter ce script.
		echo Si le dump est correct, vérifiez l'espace disque sur la partition sur laquelle vous essayez de copier le dump et vérifiez aussi que cette même partition ai un système de fichier supportant les fichiers de plus de 4 GO.
		IF EXIST "%dump_output%\emunand_partition.bin" del /q "%dump_output%\emunand_partition.bin"
		set copy_error=Y
	)
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