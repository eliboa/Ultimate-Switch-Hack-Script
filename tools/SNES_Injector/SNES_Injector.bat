::Script by markus95, modified by shadow256
@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
IF "%ushs_launch%"=="Y" (
	echo Ce script va vous permettre de préparer l'émulateur Snes Classic Edition avec vos jeux et vos images.
	echo Une fois le travail terminé, l'émulateur ainsi configuré pourra être copié via la fonction de préparation d'une SD si le homebrew est inclu pendant la préparation.
	echo Attention, les jeux et les images de l'émulateur seront toujours remis à zéro, la configuration précédente ne sera pas gardée à partir du moment où un dossier de jeux est indiqué.
	pause
	set script_base=tools\SNES_Injector
	set target_path=tools\sd_switch\emulators\pack\Snes_Classic_Edition\switch\snes_classic\game
	call :set_paths
) else (
	CD /d "%~dp0"
	set script_base=.
	set target_path=snes_classic\game
	set source_images=source_files\images
	set source_roms=source_files\roms
	IF NOT EXIST "source_files\*.*" (
		MD "source_files"
		MD "%source_images%"
		MD "%source_roms%"
		echo Attention, le dossier "sources_files" n'existait pas au lancement du script, vous devez y placer vos fichiers comme indiqué dans le readme du projet.
		goto:end_script
	)
	IF NOT EXIST "%source_images%\*.*" (
		MD "%source_images%"
		echo Attention, le dossier "%source_images%" contenant les sources des images n'existait pas, le script va donc le créer et continuer avec l'image par défaut pour tous les jeux.
	)
	IF NOT EXIST "%source_roms%\*.*" (
		MD "%source_roms%"
		echo Attention, le dossier de roms "%source_roms%" n'existait pas au lancement du script, celui-ci ne peut continuer en l'état mais le dossier vient d'être créé pour que vous puissiez y placer vos roms au format "smc" ou "sfc".
		goto:end_script
	)
	rmdir /s /q "%target_path%" >nul 2>&1
	MD "%target_path%"
	MD "%target_path%\boxart"
	MD "%target_path%\rom"
	MD "%target_path%\thumbnail"
	MD "%target_path%\images"
)
set /a nb_games=0
for %%a in ("%source_roms%\*.sfc" "%source_roms%\*.smc") do (
	copy "%%a" "%target_path%\rom"
	set /a nb_games+=1
)
IF %nb_games% EQU 0 (
	echo Aucun jeu dans le dossier "%source_roms%", le script ne peut donc rien faire.
	IF NOT "%ushs_launch%"=="Y" rmdir /s /q game >nul 2>&1
	goto:end_script
)
for %%a in ("%target_path%\rom\*.sfc") do (
	ren %%a %%ña.smc
)
for %%a in ("%target_path%\rom\*.smc") do (
	copy "%source_images%\%%~na.jpg" "%target_path%\images" >nul 2>&1
)
for /f "delims=" %%a In ('dir /b/a-d/s  "%target_path%\images" ') Do (
	set "$File=%%~nxa"
	set "$File=!$File: =_!"
	ren "%%a" "!$File!"
)
for /f "delims=" %%a In ('dir /b/a-d/s "%target_path%\rom" ') Do (
	set "$File=%%~nxa"
	set "$File=!$File: =_!"
	ren "%%a" "!$File!"
)
set /a tmp_nb_games=0
echo [>>"%target_path%\database.json"
for %%I in ("%target_path%\rom\*.*") do (
	set /a tmp_nb_games+=1
	set game_file_name=%%~nI
	set space=!game_file_name:_= !
	set "num="
	call :prepare_game
)
echo ]>>"%target_path%\database.json"
echo Opérations effectuées.
goto:end_script

:prepare_game
IF NOT EXIST "%target_path%\images\%game_file_name%.jpg" (
	echo Aucune image trouvée pour le jeu "%space%, une image par défaut sera donc copiée.
	copy "%script_base%\default_image.jpg" "%target_path%\images\%game_file_name%.jpg"
)
set jpg=%game_file_name%.jpg
findstr /I /C:"%game_file_name%" 2player.txt
if "%errorlevel%"=="0" set num=2
if not "%num%"=="2" set num=1
set "nospace=%space:&=%"
set nospace=%nospace:'=%
set nospace=%nospace:,=%
set nospace=%nospace:-=%
set nospace=%nospace: =%

echo     {>>"%target_path%\database.json"
echo         "title": "%space%",>>"%target_path%\database.json"
echo         "filename": "%nospace%",>>"%target_path%\database.json"
echo         "number_of_player": ^%num%,>>"%target_path%\database.json"
echo         "has_sram" : false>>"%target_path%\database.json"
IF %nb_games% NEQ !tmp_nb_games! (
	echo     },>>"%target_path%\database.json"
) else (
	echo     }>>"%target_path%\database.json"
)

"%script_base%\nconvert.exe" -out png -rmeta -resize 40 28 "%target_path%\images\%jpg%" >nul
set thumb=%jpg:~0,-4%
set "thumb1=%thumb:&=%"
set thumb1=%thumb1:'=%
set thumb1=%thumb1:,=%
set thumb1=%thumb1:-=%
set thumb1=%thumb1: =%
ren "%target_path%\images\%thumb%.png" %thumb1%.png
move "%target_path%\images\%thumb1%.png" "%target_path%\thumbnail"

"%script_base%\nconvert.exe" -out png -rmeta -resize 228 160 "%target_path%\images\%jpg%" >nul
set box=%jpg:~0,-4%
set "box1=%box:&=%"
set box1=%box1:'=%
set box1=%box1:,=%
set box1=%box1:-=%
set box1=%box1: =%
ren "%target_path%\images\%box%.png" "%box1%.png"
move "%target_path%\images\%box1%.png" "%target_path%\boxart"
exit /b

:set_paths
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
echo Vous allez devoir sélectionner le répertoire contenant les images correspondant à vos jeux. Attention, le nom des images doit correspondre au nom du jeu auquel il est associé.
echo Si la source est laissée vide, l'image par défaut sera utilisée pour tous les jeux.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt"
set /p source_images=<templogs\tempvar.txt
IF "%source_images%"=="" (
	echo Aucune source d'images, le script utilisera donc l'image par défaut pour tous les jeux.
	pause
) else (
	set source_images=!source_images!\
	set source_images=!source_images:\\=\!
	set source_images=!source_images:~0,-1!
)
echo Vous allez devoir sélectionner le répertoire contenant vos jeux.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt"
set /p source_roms=<templogs\tempvar.txt
IF "%source_roms%"=="" (
	echo La source des jeux ne peut être vide.
	goto:end_script
) else (
	set source_roms=!source_roms!\
	set source_roms=!source_roms:\\=\!
	set source_roms=!source_roms:~0,-1!
)
rmdir /s /q templogs 2>nul
rmdir /s /q "%target_path%\boxart" >nul 2>&1
rmdir /s /q "%target_path%\rom" >nul 2>&1
rmdir /s /q "%target_path%\thumbnail" >nul 2>&1
rmdir /s /q "%target_path%\images" >nul 2>&1
MD "%target_path%\boxart"
MD "%target_path%\rom"
MD "%target_path%\thumbnail"
MD "%target_path%\images"
exit /b

:end_script
pause
rmdir /s /q "%target_path%\images" >nul 2>&1
endlocal