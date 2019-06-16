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
echo Ce script permet de découper un dump de la rawnand en plusieurs parties, ceci peut être utile pour utiliser ensuite ce dump pour l'Emunand de Atmosphere.
pause
:rawnand_choice
echo.
echo Vous allez devoir sélectionner le fichier de la rawnand à découper.
pause
%windir%\system32\wscript.exe //Nologo "tools\Storage\functions\open_file.vbs" "" "Fichier bin(*.bin)|*.bin|" "Sélection du fichier de dump de la nand" "templogs\tempvar.txt"
set /p dump_input=<"templogs\tempvar.txt"
IF "%dump_input%"=="" (
	echo Aucun fichier sélectionné, le script va s'arrêter.
	goto:end_script
)
call :get_type_nand "%dump_input%"
IF /i NOT "%nand_type%"=="RAWNAND" (
	echo Le fichier sélectionné n'est pas un dump de rawnand valide ou est un fichier de dump d'une rawnand déjà découpé, le script ne peut continuer.
	goto:end_script
)
set /a chars_filename_count=0
:prepare_extract_filename
set /a chars_filename_count+=1
IF NOT "!dump_input:~-%chars_filename_count%,1!"=="\" (
	goto:prepare_extract_filename
) else (
	goto:skip_prepare_extract_filename
)
:skip_prepare_extract_filename
set /a chars_filename_count-=1
set filename=!dump_input:~-%chars_filename_count%!
:output_select
echo.
echo Vous allez maintenant devoir sélectionner le répertoire vers lequel seront copié les fichiers du dump découpé. Notez que l'archive byte sera appliquer au dossier pour rendre celui-ci compatible avec l'Emunand d'Atmosphere.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt"
set /p dump_output=<"templogs\tempvar.txt"
IF "%dump_output%"=="" (
	echo Aucun dossier sélectionné, le script va s'arrêter.
	goto:end_script
)
set dump_output=%dump_output:\\=\%
:define_parts_number
echo.
echo Choisissez en combien de parties le dump sera découppé:
echo 1: 8 parties (recommandé)?
echo 2: 15 parties?
echo 3: 30 parties?
echo.
set parts_number_choice=
set /p parts_number_choice=Faites votre choix: 
IF "%parts_number_choice%"=="1" (
	set parts_number=8
	goto:skip_define_parts_number
)
IF "%parts_number_choice%"=="2" (
	set parts_number=15
	goto:skip_define_parts_number
)
IF "%parts_number_choice%"=="3" (
	set parts_number=30
	goto:skip_define_parts_number
)
echo Choix Inexistant.
goto:define_parts_number
:skip_define_parts_number
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
cd /d "%dump_output%"
"%this_script_dir%\..\gnuwin32\bin\split.exe" -d -n %parts_number% "%dump_input%" %filename%.
IF %errorlevel% NEQ 0 (
	echo Il semble qu'une erreur se soit produite pendant la copie.
	echo Vérifiez que vous avez au moins 30 GO de libre sur la partition sur lequel le fichier est copié puis réessayez.
	echo Vérifiez également que vous avez les droits en écriture pour le répertoire dans lequel vous essayez de copier le fichier.
	set copy_error=Y
)
cd /D "%this_script_dir%\..\.."
IF "%copy_error%"=="Y" goto:end_script
attrib +a "%dump_output%"
echo Copie terminée.
goto:end_script

:get_type_nand
set nand_type=
set temp_input_file=%~1
tools\NxNandManager\NxNandManager.exe --info -i "%temp_input_file%" >templogs\infos_nand.txt
set temp_input_file=
tools\gnuwin32\bin\grep.exe "NAND type :" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p nand_type=<templogs\tempvar.txt
set nand_type=%nand_type:~1%
exit /B

:end_script
pause
:end_script_2
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
endlocal