::Script by Shadow256
chcp 65001 >nul
Setlocal enabledelayedexpansion
@echo off
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
IF NOT EXIST "tools\sd_switch\profiles\*.*" mkdir "tools\sd_switch\profiles"

echo Gestions de profiles généraux des éléments à copier durant la préparation d'une SD.
:define_action_choice
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Créer un profile?
echo 2: Modifier un profile?
echo 3: Supprimer un profile?
echo 0: Obtenir la liste des éléments qui seront copiés d'un profile?
echo N'importe quel autre choix: Revenir au menu précédent?
echo.
set action_choice=
set /p action_choice=Faites votre choix: 
IF "%action_choice%"=="1" goto:create_profile
IF "%action_choice%"=="2" goto:modify_profile
IF "%action_choice%"=="3" goto:remove_profile
IF "%action_choice%"=="0" goto:info_profile
goto:end_script

:info_profile
echo Information sur un profile
call :select_profile
IF %errorlevel% EQU 404 (
	echo Aucun profile existant, veuillez en créer un pour obtenir des infos.
	goto:define_action_choice
)
call %profile_path%
call tools\Storage\prepare_sd_switch_infos.bat
pause
goto:define_action_choice

:create_profile
echo Création d'un profile
echo.
:define_new_profile_name
set new_profile_name=
set /p new_profile_name=Entrez le nom du profile, laisser vide pour annuler l'opération: 
IF "%new_profile_name%"=="" goto:define_action_choice
call TOOLS\Storage\functions\strlen.bat nb "%new_profile_name%"
set i=0
:check_chars_new_profile_name
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^/ ^* ^? ^: ^^ ^| ^\ ^( ^) ^") do (
		IF "!new_profile_name:~%i%,1!"=="%%z" (
			echo Un caractère non autorisé a été saisie dans le nom du profile.
			set new_profile_name=
			goto:define_new_profile_name
		)
	)
	set /a i+=1
	goto:check_chars_new_profile_name
)
copy nul "tools\sd_switch\profiles\%new_profile_name%.bat" >nul
echo Profile "%new_profile_name%" créé avec succès.
set profile_selected=%new_profile_name%.bat
goto:skip_modify_select_profile

:modify_profile
echo Modification d'un profile
echo.
call :select_profile
IF %errorlevel% EQU 404 (
	echo Aucun profile à modifier, veuillez en créer un.
	goto:define_action_choice
)
:skip_modify_select_profile
IF %errorlevel% EQU 0 (
	call tools\Storage\prepare_sd_switch_files_questions.bat
	call :save_profile_choices
) else (
	echo Opération annulée.
)
goto:define_action_choice

:remove_profile
echo Suppression d'un profile
echo.
call :select_profile
IF %errorlevel% EQU 404 (
	echo Aucun profile à supprimer, veuillez en créer un.
	goto:define_action_choice
)
IF %errorlevel% EQU 0 (
	del /q "tools\sd_switch\profiles\%profile_selected%" >nul
	echo Profile "%profile_selected:~0,-4%" supprimé avec succès.
) else (
	echo Opération annulée.
)
pause
goto:define_action_choice

:select_profile
set profile_selected=
echo Sélectionner un profile:
IF NOT EXIST "tools\sd_switch\profiles\*.bat" exit /b 404
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
cd tools\sd_switch\profiles
for %%p in (*.bat) do (
	set temp_profilename=%%p
	set temp_profilename=!temp_profilename:~0,-4!
	echo !temp_count!: !temp_profilename!
	echo %%p>> ..\..\..\templogs\profiles_list.txt
	set /a temp_count+=1
)
cd ..\..\..
echo N'importe quel autre choix: Revenir à l'action précédente.
echo.
set profile_choice=
set /p profile_choice=Choisir un profile.
IF "%profile_choice%"=="" set /a profile_choice=0
call TOOLS\Storage\functions\strlen.bat nb "%profile_choice%"
set i=0
:check_chars_profile_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!profile_choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_profile_choice
		)
	)
	IF "!check_chars!"=="0" (
exit /b 400
	)
)
IF %profile_choice% GEQ %temp_count% exit /b 400
IF %profile_choice% EQU 0 exit /b 400
TOOLS\gnuwin32\bin\sed.exe -n %profile_choice%p <templogs\profiles_list.txt > templogs\tempvar.txt
del /q templogs\profiles_list.txt >nul
set /p profile_selected=<templogs\tempvar.txt
set profile_path=tools\sd_switch\profiles\%profile_selected%
exit /b

:save_profile_choices
IF %errorlevel% NEQ 200 exit /b
set profile_path=tools\sd_switch\profiles\%profile_selected%
echo set "copy_atmosphere_pack=%copy_atmosphere_pack%">%profile_path%
echo set "atmosphere_enable_nogc_patch=%atmosphere_enable_nogc_patch%">>%profile_path%
echo set "atmosphere_enable_prodinfo_write=%atmosphere_enable_prodinfo_write%">>%profile_path%
echo set "atmosphere_pass_copy_modules_pack=%atmosphere_pass_copy_modules_pack%">>%profile_path%
echo set "atmosphere_modules_profile_path=%atmosphere_modules_profile_path%">>%profile_path%
echo set "copy_reinx_pack=%copy_reinx_pack%">>%profile_path%
echo set "reinx_enable_nogc_patch=%reinx_enable_nogc_patch%">>%profile_path%
echo set "reinx_pass_copy_modules_pack=%reinx_pass_copy_modules_pack%">>%profile_path%
echo set "reinx_modules_profile_path=%reinx_modules_profile_path%">>%profile_path%
echo set "copy_sxos_pack=%copy_sxos_pack%">>%profile_path%
echo set "copy_payloads=%copy_payloads%">>%profile_path%
echo set "copy_memloader=%copy_memloader%">>%profile_path%
echo set "copy_emu=%copy_emu%">>%profile_path%
echo set "keep_emu_configs=%keep_emu_configs%">>%profile_path%
echo set "pass_copy_emu_pack=%pass_copy_emu_pack%">>%profile_path%
echo set "emu_profile_path=%emu_profile_path%">>%profile_path%
echo set "pass_copy_mixed_pack=%pass_copy_mixed_pack%">>%profile_path%
echo set "mixed_profile_path=%mixed_profile_path%">>%profile_path%
echo set "copy_cheats=%copy_cheats%">>%profile_path%
echo set "copy_all_cheats_pack=%copy_all_cheats_pack%">>%profile_path%
echo set "cheats_profile_name=%cheats_profile_name%">>%profile_path%
echo set "cheats_profile_path=%cheats_profile_path%">>%profile_path%
echo set "atmosphere_enable_cheats=%atmosphere_enable_cheats%">>%profile_path%
echo set "sxos_enable_cheats=%sxos_enable_cheats%">>%profile_path%
echo set "del_files_dest_copy=%del_files_dest_copy%">>%profile_path%
echo Valeurs enregistrées avec succès pour le profile %profile_selected:~0,-4%.
echo.
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
	mkdir templogs
)
endlocal