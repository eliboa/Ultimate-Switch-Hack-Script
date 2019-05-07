::Script by Shadow256
Setlocal enabledelayedexpansion
@echo off
chcp 65001 >nul
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
echo Ce script va permettre de compresser/décompresser un fichier XCI/NSP.
echo Attention: Il est préférable de ne pas exécuter ce script sur une partition formatée en FAT32 à cause de la limite de création de fichiers de plus de  4 GO de ce système de fichiers.
echo.
pause
echo.
echo Vous allez devoir sélectionner le fichier XCI/NSP à compresser/décompresser.
pause
%windir%\system32\wscript.exe //Nologo tools\Storage\functions\open_file.vbs "" "Fichier de jeu Switch (*.xci;*.nsp;*.xciz;*.nspz)|*.xci;*.nsp;*.xciz;*.nspz;" "Sélection du jeu à compresser/décompresser" "templogs\tempvar.txt"
set /p game_path=<templogs\tempvar.txt
IF "%game_path%"=="" (
	echo Aucun jeu sélectionné, la conversion est annulée.
	goto:end_script
)
echo Maintenant, sélectionner le dossier de sortie.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt"
set /p output_path=<templogs\tempvar.txt
IF NOT "%output_path%"=="" (
	set output_path=%output_path:\\=\%
) else (
	echo Aucun dossier sélectionné, le script va s'arrêter.
	goto:end_script
)
IF /i "%game_path:~-4%"=="nspz" goto:skip_set_params
IF /i "%game_path:~-4%"=="xciz" goto:skip_set_params
:set_compression_level
set compression_level=
set /p compression_level=Choisir le niveau de compression (1 pour le minimum, 22 pour le maximum): 
IF "%compression_level%"=="" (
	echo Cette valeur ne peut être vide.
	goto:set_compression_level
)
call TOOLS\Storage\functions\strlen.bat nb "%compression_level%"
set i=0
:check_chars_compression_level
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!compression_level:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_compression_level
		)
	)
	IF "!check_chars!"=="0" (
		echo Valeur non autorisée.
		goto:set_compression_level
	)
)
IF %compression_level% LSS 1 (
	echo La valeur ne peut être inférieur à 1.
	goto:set_compression_level
)
IF %compression_level% GTR 22 (
	echo La valeur ne peut être supérieur à 22.
	goto:set_compression_level
)
set params=-l %compression_level%
:skip_set_params
"tools\nsZip\nsZip.exe" -i "%game_path%" -o "%output_path%" -t "templogs\" %params%
IF %errorlevel% NEQ 0 (
	echo.
	echo Erreur pendant la tentative de compression/décompression.
) else (
	echo.
	echo Compression/décompression terminée avec succès.
)
:end_script
pause
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal