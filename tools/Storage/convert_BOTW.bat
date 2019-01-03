::Script by Shadow256
Setlocal enabledelayedexpansion
chcp 65001 >nul

IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
IF EXIST "BOTW_save" (
	rmdir /s /q "BOTW_save" 2>nul
	del /q BOTW_save 2>nul
)
	mkdir "BOTW_save"
echo Ce script va vous permettre de convertir une sauvegarde de Zelda Breath Of The Wild Wii U vers Switch ou inversement.
echo Vous devrez donc choisir le dossier contenant l'ensemble des dossiers de la sauvegarde (celui qui contient le fichier "option.sav"), appuyez sur "y" pour lancer la conversion, appuyez sur "Entrer" à la fin de celle-ci et une fois terminée, copier la nouvelle sauvegarde dans le dossier adéquat du homebrew EdiZon ou Checkpoint pour la restaurer sur la Switch. Pour la Wii U, il faudra la copier dans le dossier de Savemi Mod ou la restaurer via Saviine.
echo La sauvegarde convertie se trouvera dans le dossier "BOTW_save" à la racine du script.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt"
set /p filepath=<templogs\tempvar.txt
IF NOT "%filepath%"=="" (
	set filepath=%filepath:\\=\%
) else (
	echo Aucun dossier sélectionné, le script va s'arrêter.
	rmdir /s /q "BOTW_save" 2>nul
	goto:end_script
)
IF NOT EXIST "%filepath%\option.sav" (
	set files_error=1
	goto:files_error
)
IF EXIST "%filepath%\0\*.*" (
	IF EXIST "%filepath%\0\caption.jpg" (
		IF EXIST "%filepath%\0\caption.sav" (
			IF EXIST "%filepath%\0\game_data.sav" (
				goto:start_converting
			)
		)
	)
)
IF EXIST "%filepath%\1\*.*" (
	IF EXIST "%filepath%\1\caption.jpg" (
		IF EXIST "%filepath%\1\caption.sav" (
			IF EXIST "%filepath%\1\game_data.sav" (
				goto:start_converting
			)
		)
	)
)
IF EXIST "%filepath%\2\*.*" (
	IF EXIST "%filepath%\2\caption.jpg" (
		IF EXIST "%filepath%\2\caption.sav" (
			IF EXIST "%filepath%\2\game_data.sav" (
				goto:start_converting
			)
		)
	)
)
IF EXIST "%filepath%\3\*.*" (
	IF EXIST "%filepath%\3\caption.jpg" (
		IF EXIST "%filepath%\3\caption.sav" (
			IF EXIST "%filepath%\3\game_data.sav" (
				goto:start_converting
			)
		)
	)
)
IF EXIST "%filepath%\4\*.*" (
	IF EXIST "%filepath%\4\caption.jpg" (
		IF EXIST "%filepath%\4\caption.sav" (
			IF EXIST "%filepath%\4\game_data.sav" (
				goto:start_converting
			)
		)
	)
)
IF EXIST "%filepath%\5\*.*" (
	IF EXIST "%filepath%\5\caption.jpg" (
		IF EXIST "%filepath%\5\caption.sav" (
			IF EXIST "%filepath%\5\game_data.sav" (
				goto:start_converting
			)
		)
	)
)
IF EXIST "%filepath%\6\*.*" (
	IF EXIST "%filepath%\6\caption.jpg" (
		IF EXIST "%filepath%\6\caption.sav" (
			IF EXIST "%filepath%\6\game_data.sav" (
				goto:start_converting
			)
		)
	)
)
IF EXIST "%filepath%\7\*.*" (
	IF EXIST "%filepath%\7\caption.jpg" (
		IF EXIST "%filepath%\7\caption.sav" (
			IF EXIST "%filepath%\7\game_data.sav" (
				goto:start_converting
			)
		)
	)
)
:files_error
echo Il semblerai que le dossier sélectionné ne contienne pas une sauvegarde de Zelda Breath OF The Wild, le script va s'arrêter.
rmdir /s /q "BOTW_save" 2>nul
goto:end_script
:start_converting
echo Copie des fichiers en cours...
copy "TOOLS\BOTW_SaveConv\BOTW_SaveConv.exe" "BOTW_save\BOTW_SaveConv.exe"
%windir%\System32\Robocopy.exe "%filepath%" "BOTW_save" /e
echo Copie terminée.
cd "BOTW_save"
BOTW_SaveConv.exe
del /q "BOTW_SaveConv.exe"
cd ..
echo Conversion de la sauvegarde terminée.
:end_script
rmdir /s /q templogs
pause 
endlocal