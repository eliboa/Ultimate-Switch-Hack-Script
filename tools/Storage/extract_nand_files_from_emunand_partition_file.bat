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
echo Ce script permet d'extraire le fichier BOOT0, BOOT1 et rawnand.bin à partir d'un fichier utilisé par l'emunand via partition.
pause
:folders_choice
echo.
echo Vous allez devoir sélectionner le fichier de l'emunand.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers bin (*.bin)|*.bin|" "Sélection du fichier de dump de l'emunand" "templogs\tempvar.txt"
set /p dump_input=<templogs\tempvar.txt
IF "%dump_input%"=="" (
	echo Aucun dossier sélectionné, le script va s'arrêter.
	goto:end_script
)
:output_select
echo.
echo Vous allez maintenant devoir sélectionner le répertoire vers lequel sera copié le fichier "BOOT0", "BOOT1" et "rawnand.bin". Attention, le dossier devra se trouver sur une partition supportant les fichiers de plus de 4 GO (EXFAT, NTFS).
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt"
set /p dump_output=<"templogs\tempvar.txt"
IF "%dump_output%"=="" (
	echo Aucun dossier sélectionné, le script va s'arrêter.
	goto:end_script
)
set dump_output=%dump_output:\\=\%
:verif_existing_file
IF EXIST "%dump_output%\BOOT0" (
	set /p erase_existing_dump_boot0=Un fichier "BOOT0" a été trouvé à l'emplacement de copie du nouveau dump, souhaitez-vous écraser le dump précédent ^(la suppression du dump sera faite tout de suite après ce choix donc soyez prudent^)? ^(O/n^): 
)
IF NOT "%erase_existing_dump_boot0%"=="" set erase_existing_dump_boot0=%erase_existing_dump_boot0:~0,1%
IF EXIST "%dump_output%\BOOT1" (
	set /p erase_existing_dump_boot1=Un fichier "BOOT1" a été trouvé à l'emplacement de copie du nouveau dump, souhaitez-vous écraser le dump précédent ^(la suppression du dump sera faite tout de suite après ce choix donc soyez prudent^)? ^(O/n^): 
)
IF NOT "%erase_existing_dump_boot1%"=="" set erase_existing_dump_boot1=%erase_existing_dump_boot1:~0,1%
IF EXIST "%dump_output%\rawnand.bin" (
	set /p erase_existing_dump_rawnand=Un fichier "rawnand.bin" a été trouvé à l'emplacement de copie du nouveau dump, souhaitez-vous écraser le dump précédent ^(la suppression du dump sera faite tout de suite après ce choix donc soyez prudent^)? ^(O/n^): 
)
IF NOT "%erase_existing_dump_rawnand%"=="" set erase_existing_dump_rawnand=%erase_existing_dump_rawnand:~0,1%
IF EXIST "%dump_output%\BOOT0" (
	IF /i "%erase_existing_dump_boot0%"=="o" (
		del /q "%dump_output%\BOOT0"
	) else (
		echo Opération annulée.
		goto:end_script
	)
)
IF EXIST "%dump_output%\BOOT1" (
	IF /i "%erase_existing_dump_boot1%"=="o" (
		del /q "%dump_output%\BOOT1"
		goto:verif_disk_free_space
	) else (
		echo Opération annulée.
		goto:end_script
	)
)
IF EXIST "%dump_output%\rawnand.bin" (
	IF /i "%erase_existing_dump_rawnand%"=="o" (
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
:error_disk_free_space
echo.
echo Il n'y a pas assez d'espace libre à l'emplacement sur lequel vous souhaitez copier votre dump, le script va s'arrêter.
goto:end_script


:copy_nand
echo.
echo Copie en cours...
"tools\gnuwin32\bin\dd.exe" bs=1c count=4194304 if="%dump_input%" of="%dump_output%\BOOT0"
IF %errorlevel% NEQ 0 (
	echo Il semble qu'une erreur se soit produite pendant la copie, les fichiers créés vont être supprimés s'ils existent.
	echo Vérifiez que la partition sur laquelle vous copiez les fichiers est une partition supportant les fichiers de plus de 4 GO et vérifiez également que vous avez au moins 30 GO de libre sur la partition sur lequel les fichiers sont copié puis réessayez.
	echo Vérifiez également que vous avez les droits en écriture pour le répertoire dans lequel vous essayez de copier les fichiers.
	IF EXIST "%dump_output%\BOOT0" del /q "%dump_output%\BOOT0"
	IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
	IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
	goto:end_script
)
"tools\gnuwin32\bin\dd.exe bs=1c skip=4194304 count=4194304 if="%dump_input%" of="%dump_output%\BOOT1"
IF %errorlevel% NEQ 0 (
	echo Il semble qu'une erreur se soit produite pendant la copie, les fichiers créés vont être supprimés s'ils existent.
	echo Vérifiez que la partition sur laquelle vous copiez les fichiers est une partition supportant les fichiers de plus de 4 GO et vérifiez également que vous avez au moins 30 GO de libre sur la partition sur lequel les fichiers sont copié puis réessayez.
	echo Vérifiez également que vous avez les droits en écriture pour le répertoire dans lequel vous essayez de copier les fichiers.
	IF EXIST "%dump_output%\BOOT0" del /q "%dump_output%\BOOT0"
	IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
	IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
	goto:end_script
)
"tools\gnuwin32\bin\dd.exe" bs=1c skip=8388609 if="%dump_input%" of="%dump_output%\rawnand.bin"
IF %errorlevel% NEQ 0 (
	echo Il semble qu'une erreur se soit produite pendant la copie, les fichiers créés vont être supprimés s'ils existent.
	echo Vérifiez que la partition sur laquelle vous copiez les fichiers est une partition supportant les fichiers de plus de 4 GO et vérifiez également que vous avez au moins 30 GO de libre sur la partition sur lequel les fichiers sont copié puis réessayez.
	echo Vérifiez également que vous avez les droits en écriture pour le répertoire dans lequel vous essayez de copier les fichiers.
	IF EXIST "%dump_output%\BOOT0" del /q "%dump_output%\BOOT0"
	IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
	IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
	goto:end_script
)
call :test_rawnand_size "%dump_output%\BOOT0"
call :test_rawnand_size "%dump_output%\BOOT1"
call :test_rawnand_size "%dump_output%\rawnand.bin"
echo Copie terminée.
echo.
IF "%copy_error_boot0%"=="Y" echo Erreur de copie du fichier "BOOT0".
IF "%copy_error_boot1%"=="Y" echo Erreur de copie du fichier "BOOT1".
IF "%copy_error_rawnand%"=="Y" echo Erreur de copie du fichier "rawnand.bin".
echo.
IF NOT "%copy_error_rawnand%"=="Y" set /p launch_hacdiskmount=Souhaitez-vous lancer HacDiskMount pour vérifier que le dump a bien été copié ^(rawnand.bin^) et qu'il fonctionne correctement ^(recommandé^)? ^(O/n^): 
IF NOT "%launch_hacdiskmount%"=="" set launch_hacdiskmount=%launch_hacdiskmount:~0,1%
IF /i "%launch_hacdiskmount%"=="o" (
	start tools\HacDiskMount\HacDiskMount.exe
)
goto:end_script

:test_rawnand_size
IF "%~nx1"=="rawnand.bin" (
	IF NOT "%~z1"=="31268536320" (
		echo Il semble que la taille du fichier créé ne corresponde pas à la taille que devrait faire le dump de la rawnand, le fichier créé va donc être supprimé.
		echo Il est donc conseillé de refaire le dump de l'emunand puis de réessayer d'exécuter ce script.
		echo Si le dump est correct, vérifiez l'espace disque sur la partition sur laquelle vous essayez de copier le dump et vérifiez aussi que cette même partition ai un système de fichier supportant les fichiers de plus de 4 GO.
		IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
		set copy_error_rawnand=Y
	)
) else IF "%~nx1"=="BOOT0" (
IF NOT "%~z1"=="4194304" (
		echo Il semble que la taille du fichier créé ne corresponde pas à la taille que devrait faire le dump de la partition BOOT0, le fichier créé va donc être supprimé.
		echo Il est donc conseillé de refaire le dump de l'emunand puis de réessayer d'exécuter ce script.
		echo Si le dump est correct, vérifiez l'espace disque sur la partition sur laquelle vous essayez de copier le dump.
		IF EXIST "%dump_output%\BOOT0" del /q "%dump_output%\BOOT0"
		set copy_error_boot0=Y
	)
) else IF "%~nx1"=="BOOT0" (
IF NOT "%~z1"=="4194304" (
		echo Il semble que la taille du fichier créé ne corresponde pas à la taille que devrait faire le dump de la partition BOOT1, le fichier créé va donc être supprimé.
		echo Il est donc conseillé de refaire le dump de l'emunand puis de réessayer d'exécuter ce script.
		echo Si le dump est correct, vérifiez l'espace disque sur la partition sur laquelle vous essayez de copier le dump.
		IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
		set copy_error_boot1=Y
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