::Script by Shadow256
Setlocal enabledelayedexpansion
chcp 65001 >nul
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
:define_filename
set /p filename=Entrez le nom de la sauvegarde: 
IF "%filename%"=="" (
	echo Le nom de la sauvegarde ne peut être vide.
	goto:define_filename
) else (
	set filename=%filename:"=%
)
call TOOLS\Storage\functions\strlen.bat nb "%filename%"
set i=0
:check_chars_filename
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^/ ^* ^? ^: ^^ ^| ^\) do (
		IF "!filename:~%i%,1!"=="%%z" (
			echo Un caractère non autorisé a été saisie dans le nom de la sauvegarde.
			set filename=
			goto:define_filename
		)
	)
	set /a i+=1
	goto:check_chars_filename
)
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt"
set /p filepath=<templogs\tempvar.txt
IF NOT "%filepath%"=="" set filepath=%filepath%\
IF NOT "%filepath%"=="" set filepath=%filepath:\\=\%
echo Sauvegarde en cours... 
IF NOT EXIST KEY_SAVES mkdir KEY_SAVES
IF NOT EXIST KEY_SAVES\tools mkdir KEY_SAVES\tools
IF NOT EXIST "KEY_SAVES\tools\Hactool_based_programs" mkdir "KEY_SAVES\tools\Hactool_based_programs"
copy /V TOOLS\Hactool_based_programs\keys.txt KEY_SAVES\TOOLS\Hactool_based_programs\keys.txt
copy /V TOOLS\Hactool_based_programs\keys.dat KEY_SAVES\TOOLS\Hactool_based_programs\keys.dat
IF NOT EXIST "KEY_SAVES\tools\megatools" mkdir "KEY_SAVES\tools\megatools"
copy /V "tools\megatools\mega.ini" "KEY_SAVES\tools\megatools\mega.ini"
IF NOT EXIST "KEY_SAVES\tools\netplay" mkdir "KEY_SAVES\tools\netplay"
copy /v TOOLS\netplay\servers_list.txt KEY_SAVES\TOOLS\netplay\servers_list.txt
IF NOT EXIST "KEY_SAVES\tools\NSC_Builder" mkdir "KEY_SAVES\tools\NSC_Builder"
copy /V TOOLS\NSC_Builder\keys.txt KEY_SAVES\TOOLS\NSC_Builder\keys.txt
IF NOT EXIST "KEY_SAVES\tools\sd_switch" mkdir "KEY_SAVES\tools\sd_switch"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\mixed" mkdir "KEY_SAVES\tools\sd_switch\mixed"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\mixed\profiles" mkdir "KEY_SAVES\tools\sd_switch\mixed\profiles"
copy /V "tools\sd_switch\mixed\profiles\*.ini" "KEY_SAVES\tools\sd_switch\mixed\profiles\
IF NOT EXIST "KEY_SAVES\tools\sd_switch\cheats" mkdir "KEY_SAVES\tools\sd_switch\cheats"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\cheats\profiles" mkdir "KEY_SAVES\tools\sd_switch\cheats\profiles"
copy /V "tools\sd_switch\cheats\profiles\*.ini" "KEY_SAVES\tools\sd_switch\cheats\profiles\
IF NOT EXIST "KEY_SAVES\tools\sd_switch\emulators" mkdir "KEY_SAVES\tools\sd_switch\emulators"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\emulators\profiles" mkdir "KEY_SAVES\tools\sd_switch\emulators\profiles"
copy /V "tools\sd_switch\emulators\profiles\*.ini" "KEY_SAVES\tools\sd_switch\emulators\profiles\
IF NOT EXIST "KEY_SAVES\tools\sd_switch\modules" mkdir "KEY_SAVES\tools\sd_switch\modules"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\modules\profiles" mkdir "KEY_SAVES\tools\sd_switch\modules\profiles"
copy /V "tools\sd_switch\modules\profiles\*.ini" "KEY_SAVES\tools\sd_switch\modules\profiles\
IF NOT EXIST KEY_SAVES\tools\Storage mkdir KEY_SAVES\tools\Storage
copy /v tools\Storage\verif_update.ini KEY_SAVES\tools\Storage\verif_update.ini
IF NOT EXIST KEY_SAVES\tools\toolbox mkdir KEY_SAVES\tools\toolbox
%windir%\System32\Robocopy.exe tools\toolbox KEY_SAVES\tools\toolbox\ /e
cd KEY_SAVES
IF NOT "%filepath%"=="" (
	..\TOOLS\7zip\7za.exe a -y -tzip -sdel -sccUTF-8 "%filepath%%filename%".ushs  -r
) else (
	..\TOOLS\7zip\7za.exe a -y -tzip -sdel -sccUTF-8 "..\%filename%".ushs  -r
)
cd ..
echo Sauvegarde des fichiers de configurations terminée. 
rmdir /s /q KEY_SAVES
rmdir /s /q templogs
pause 
endlocal