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
IF NOT EXIST KEY_SAVES\TOOLS mkdir KEY_SAVES\TOOLS
IF NOT EXIST "KEY_SAVES\TOOLS\Hactool_based_programs" mkdir "KEY_SAVES\TOOLS\Hactool_based_programs"
copy /V TOOLS\Hactool_based_programs\keys.txt KEY_SAVES\TOOLS\Hactool_based_programs\keys.txt
copy /V TOOLS\Hactool_based_programs\keys.dat KEY_SAVES\TOOLS\Hactool_based_programs\keys.dat
IF NOT EXIST "KEY_SAVES\TOOLS\megatools" mkdir "KEY_SAVES\TOOLS\megatools"
copy /V "tools\megatools\mega.ini" "KEY_SAVES\tools\megatools\mega.ini"
IF NOT EXIST "KEY_SAVES\TOOLS\netplay" mkdir "KEY_SAVES\TOOLS\netplay"
copy /v TOOLS\netplay\servers_list.txt KEY_SAVES\TOOLS\netplay\servers_list.txt
IF NOT EXIST "KEY_SAVES\TOOLS\NSC_Builder" mkdir "KEY_SAVES\TOOLS\Hactool_based_programs"
copy /V TOOLS\NSC_Builder\keys.txt KEY_SAVES\TOOLS\NSC_Builder\keys.txt
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