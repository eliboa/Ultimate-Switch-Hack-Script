::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
call "%associed_language_script%" "display_title"
:define_filename
set filename=
call "%associed_language_script%" "filename_choice"
IF "%filename%"=="" (
	call "%associed_language_script%" "filename_empty_error"
	goto:define_filename
) else (
	set filename=%filename:"=%
)
call tools\Storage\functions\strlen.bat nb "%filename%"
set i=0
:check_chars_filename
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^/ ^* ^? ^: ^^ ^| ^\) do (
		IF "!filename:~%i%,1!"=="%%z" (
			call "%associed_language_script%" "filename_char_error"
			goto:define_filename
		)
	)
	set /a i+=1
	goto:check_chars_filename
)
call "%associed_language_script%" "output_folder_choice"
set /p filepath=<templogs\tempvar.txt
IF NOT "%filepath%"=="" set filepath=%filepath%\
IF NOT "%filepath%"=="" set filepath=%filepath:\\=\%
call "%associed_language_script%" "save_begin"
IF NOT EXIST KEY_SAVES mkdir KEY_SAVES
IF EXIST "Ultimate-Switch-Hack-Script.bat.lng" copy /v "Ultimate-Switch-Hack-Script.bat.lng" "KEY_SAVES\Ultimate-Switch-Hack-Script.bat.lng"
IF NOT EXIST KEY_SAVES\languages mkdir KEY_SAVES\languages
cd languages
for /f %%p in ("*") do (
	IF EXIST "%%p\script_general_config.bat" (
		IF NOT EXIST "KEY_SAVES\languages\%%p" mkdir "KEY_SAVES\languages\%%p"
	)
	IF EXIST "%%p\script_general_config.bat" copy /v "%%p\script_general_config.bat" "KEY_SAVES\languages\%%p\script_general_config.bat"
)
cd ..
IF NOT EXIST KEY_SAVES\tools mkdir KEY_SAVES\tools
IF NOT EXIST "KEY_SAVES\tools\Hactool_based_programs" mkdir "KEY_SAVES\tools\Hactool_based_programs"
copy /V tools\Hactool_based_programs\keys.txt KEY_SAVES\tools\Hactool_based_programs\keys.txt
copy /V tools\Hactool_based_programs\keys.dat KEY_SAVES\tools\Hactool_based_programs\keys.dat
IF NOT EXIST "KEY_SAVES\tools\megatools" mkdir "KEY_SAVES\tools\megatools"
copy /V "tools\megatools\mega.ini" "KEY_SAVES\tools\megatools\mega.ini"
IF NOT EXIST "KEY_SAVES\tools\netplay" mkdir "KEY_SAVES\tools\netplay"
copy /v tools\netplay\servers_list.txt KEY_SAVES\tools\netplay\servers_list.txt
IF NOT EXIST "KEY_SAVES\tools\NSC_Builder" mkdir "KEY_SAVES\tools\NSC_Builder"
copy /V tools\NSC_Builder\keys.txt KEY_SAVES\tools\NSC_Builder\keys.txt
IF NOT EXIST "KEY_SAVES\tools\sd_switch" mkdir "KEY_SAVES\tools\sd_switch"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\mixed" mkdir "KEY_SAVES\tools\sd_switch\mixed"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\mixed\profiles" mkdir "KEY_SAVES\tools\sd_switch\mixed\profiles"
copy /V "tools\sd_switch\mixed\profiles\*.ini" "KEY_SAVES\tools\sd_switch\mixed\profiles\"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\atmosphere_emummc_profiles" mkdir "KEY_SAVES\tools\sd_switch\atmosphere_emummc_profiles"
copy /V "tools\sd_switch\atmosphere_emummc_profiles\*.ini" "KEY_SAVES\tools\sd_switch\atmosphere_emummc_profiles\"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\cheats" mkdir "KEY_SAVES\tools\sd_switch\cheats"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\cheats\profiles" mkdir "KEY_SAVES\tools\sd_switch\cheats\profiles"
copy /V "tools\sd_switch\cheats\profiles\*.ini" "KEY_SAVES\tools\sd_switch\cheats\profiles\"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\emulators" mkdir "KEY_SAVES\tools\sd_switch\emulators"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\emulators\profiles" mkdir "KEY_SAVES\tools\sd_switch\emulators\profiles"
copy /V "tools\sd_switch\emulators\profiles\*.ini" "KEY_SAVES\tools\sd_switch\emulators\profiles\"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\modules" mkdir "KEY_SAVES\tools\sd_switch\modules"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\modules\profiles" mkdir "KEY_SAVES\tools\sd_switch\modules\profiles"
copy /V "tools\sd_switch\modules\profiles\*.ini" "KEY_SAVES\tools\sd_switch\modules\profiles\"
IF NOT EXIST "KEY_SAVES\tools\sd_switch\profiles" mkdir "KEY_SAVES\tools\sd_switch\profiles"
copy /V "tools\sd_switch\profiles\*.bat" "KEY_SAVES\tools\sd_switch\profiles\"
IF NOT EXIST KEY_SAVES\tools\toolbox mkdir KEY_SAVES\tools\toolbox
%windir%\System32\Robocopy.exe tools\toolbox KEY_SAVES\tools\toolbox\ /e
cd KEY_SAVES
IF NOT "%filepath%"=="" (
	..\tools\7zip\7za.exe a -y -tzip -sdel -sccUTF-8 "%filepath%%filename%".ushs  -r
) else (
	..\tools\7zip\7za.exe a -y -tzip -sdel -sccUTF-8 "..\%filename%".ushs  -r
)
cd ..
call "%associed_language_script%" "save_end"
rmdir /s /q KEY_SAVES
rmdir /s /q templogs
pause 
endlocal