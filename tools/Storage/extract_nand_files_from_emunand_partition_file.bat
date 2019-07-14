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
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers bin (*.bin)|*.bin|" "Sélection du fichier de dump de l\'emunand" "templogs\tempvar.txt"
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
call :test_sxos_special_first_bytes "%dump_input%"
IF %errorlevel% EQU 500 goto:end_script
:verif_disk_free_space
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\get_free_space_for_path.vbs" "%dump_output%"
set /p free_space=<templogs\volume_free_space.txt
call "tools\Storage\functions\check_disk_free_space.bat" "%free_space%" "31276924928"
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
IF NOT "%sxos_first_1024%"=="Y" (
	"tools\gnuwin32\bin\dd.exe" bs=4096 iflag=count_bytes count=4194304 if="%dump_input%" of="%dump_output%\BOOT0"
	IF !errorlevel! NEQ 0 (
		echo Il semble qu'une erreur se soit produite pendant la copie, les fichiers créés vont être supprimés s'ils existent.
		echo Vérifiez que la partition sur laquelle vous copiez les fichiers est une partition supportant les fichiers de plus de 4 GO et vérifiez également que vous avez au moins 30 GO de libre sur la partition sur lequel les fichiers sont copié puis réessayez.
		echo Vérifiez également que vous avez les droits en écriture pour le répertoire dans lequel vous essayez de copier les fichiers.
		IF EXIST "%dump_output%\BOOT0" del /q "%dump_output%\BOOT0"
		IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
		IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
		goto:end_script
	)
	"tools\gnuwin32\bin\dd.exe" bs=4096 iflag=count_bytes,skip_bytes skip=4194304 count=4194304 if="%dump_input%" of="%dump_output%\BOOT1"
	IF !errorlevel! NEQ 0 (
		echo Il semble qu'une erreur se soit produite pendant la copie, les fichiers créés vont être supprimés s'ils existent.
		echo Vérifiez que la partition sur laquelle vous copiez les fichiers est une partition supportant les fichiers de plus de 4 GO et vérifiez également que vous avez au moins 30 GO de libre sur la partition sur lequel les fichiers sont copié puis réessayez.
		echo Vérifiez également que vous avez les droits en écriture pour le répertoire dans lequel vous essayez de copier les fichiers.
		IF EXIST "%dump_output%\BOOT0" del /q "%dump_output%\BOOT0"
		IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
		IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
		goto:end_script
	)
	"tools\gnuwin32\bin\dd.exe" bs=4096 iflag=skip_bytes skip=8388608 if="%dump_input%" of="%dump_output%\rawnand.bin"
	IF !errorlevel! NEQ 0 (
		echo Il semble qu'une erreur se soit produite pendant la copie, les fichiers créés vont être supprimés s'ils existent.
		echo Vérifiez que la partition sur laquelle vous copiez les fichiers est une partition supportant les fichiers de plus de 4 GO et vérifiez également que vous avez au moins 30 GO de libre sur la partition sur lequel les fichiers sont copié puis réessayez.
		echo Vérifiez également que vous avez les droits en écriture pour le répertoire dans lequel vous essayez de copier les fichiers.
		IF EXIST "%dump_output%\BOOT0" del /q "%dump_output%\BOOT0"
		IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
		IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
		goto:end_script
	)
) else (
	"tools\gnuwin32\bin\dd.exe" bs=4096 iflag=count_bytes,skip_bytes skip=1024 count=4194304 if="%dump_input%" of="%dump_output%\BOOT0"
	IF !errorlevel! NEQ 0 (
		echo Il semble qu'une erreur se soit produite pendant la copie, les fichiers créés vont être supprimés s'ils existent.
		echo Vérifiez que la partition sur laquelle vous copiez les fichiers est une partition supportant les fichiers de plus de 4 GO et vérifiez également que vous avez au moins 30 GO de libre sur la partition sur lequel les fichiers sont copié puis réessayez.
		echo Vérifiez également que vous avez les droits en écriture pour le répertoire dans lequel vous essayez de copier les fichiers.
		IF EXIST "%dump_output%\BOOT0" del /q "%dump_output%\BOOT0"
		IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
		IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
		goto:end_script
	)
	"tools\gnuwin32\bin\dd.exe" bs=4096 iflag=count_bytes,skip_bytes skip=4195328 count=4194304 if="%dump_input%" of="%dump_output%\BOOT1"
	IF !errorlevel! NEQ 0 (
		echo Il semble qu'une erreur se soit produite pendant la copie, les fichiers créés vont être supprimés s'ils existent.
		echo Vérifiez que la partition sur laquelle vous copiez les fichiers est une partition supportant les fichiers de plus de 4 GO et vérifiez également que vous avez au moins 30 GO de libre sur la partition sur lequel les fichiers sont copié puis réessayez.
		echo Vérifiez également que vous avez les droits en écriture pour le répertoire dans lequel vous essayez de copier les fichiers.
		IF EXIST "%dump_output%\BOOT0" del /q "%dump_output%\BOOT0"
		IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
		IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
		goto:end_script
	)
	"tools\gnuwin32\bin\dd.exe" bs=4096 iflag=skip_bytes skip=8389632 if="%dump_input%" of="%dump_output%\rawnand.bin"
	IF !errorlevel! NEQ 0 (
		echo Il semble qu'une erreur se soit produite pendant la copie, les fichiers créés vont être supprimés s'ils existent.
		echo Vérifiez que la partition sur laquelle vous copiez les fichiers est une partition supportant les fichiers de plus de 4 GO et vérifiez également que vous avez au moins 30 GO de libre sur la partition sur lequel les fichiers sont copié puis réessayez.
		echo Vérifiez également que vous avez les droits en écriture pour le répertoire dans lequel vous essayez de copier les fichiers.
		IF EXIST "%dump_output%\BOOT0" del /q "%dump_output%\BOOT0"
		IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
		IF EXIST "%dump_output%\rawnand.bin" del /q "%dump_output%\rawnand.bin"
		goto:end_script
	)
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
) else IF "%~nx1"=="BOOT1" (
IF NOT "%~z1"=="4194304" (
		echo Il semble que la taille du fichier créé ne corresponde pas à la taille que devrait faire le dump de la partition BOOT1, le fichier créé va donc être supprimé.
		echo Il est donc conseillé de refaire le dump de l'emunand puis de réessayer d'exécuter ce script.
		echo Si le dump est correct, vérifiez l'espace disque sur la partition sur laquelle vous essayez de copier le dump.
		IF EXIST "%dump_output%\BOOT1" del /q "%dump_output%\BOOT1"
		set copy_error_boot1=Y
	)
)
exit /B

:test_sxos_special_first_bytes
IF "%~z1"=="31276924928" (
	set sxos_first_1024=N
) else IF "%~z1"=="31276925952" (
	set sxos_first_1024=Y
) else (
	echo Le dump sélectionné ne semble pas être correct, le script va donc se terminer sans rien faire.
	exit /b 500
)
exit /b

:end_script
pause
:end_script_2
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
endlocal