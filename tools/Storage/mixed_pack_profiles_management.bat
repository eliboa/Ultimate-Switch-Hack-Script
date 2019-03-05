::Script by Shadow256
chcp 65001 >nul
Setlocal enabledelayedexpansion
@echo off
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
IF NOT EXIST "tools\sd_switch\mixed\profiles\*.*" mkdir "tools\sd_switch\mixed\profiles"

echo Gestions de profiles pour la sélection de homebrews optionnels à copier durant la préparation d'une SD.
:define_action_choice
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Créer un profile?
echo 2: Modifier un profile?
echo 3: Supprimer un profile?
echo 0: Obtenir la liste des homebrews d'un profile?
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
	echo Aucun profile à modifier, veuillez en créer un.
	goto:define_action_choice
)
echo.
echo Nom du profile: %profile_selected:~0,-4%
echo Homebrews présent dans le profile:
call :list_homebrews_in_profile "%profile_selected%"
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
copy nul "tools\sd_switch\mixed\profiles\%new_profile_name%.ini" >nul
echo Profile "%new_profile_name%" créé avec succès.
set profile_selected=%new_profile_name%.ini
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
	call :add_del_homebrew_in_profile "%profile_selected%"
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
	del /q "tools\sd_switch\mixed\profiles\%profile_selected%" >nul
	echo Profile "%profile_selected:~0,-4%" supprimé avec succès.
) else (
	echo Opération annulée.
)
pause
goto:define_action_choice

:select_profile
set profile_selected=
echo Sélectionner un profile:
IF NOT EXIST "tools\sd_switch\mixed\profiles\*.ini" exit /b 404
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
cd tools\sd_switch\mixed\profiles
for %%p in (*.ini) do (
	set temp_profilename=%%p
	set temp_profilename=!temp_profilename:~0,-4!
	echo !temp_count!: !temp_profilename!
	echo %%p>> ..\..\..\..\templogs\profiles_list.txt
	set /a temp_count+=1
)
cd ..\..\..\..
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
exit /b

:list_homebrews_in_profile
tools\gnuwin32\bin\sort.exe -n <"tools\sd_switch\mixed\profiles\%~1"
exit /b

:add_del_homebrew_in_profile
set temp_profile=%~1
set temp_path_profile=tools\sd_switch\mixed\profiles\%~1
echo Sélection d'un homebrew à ajouter ou à supprimer pour le profile "%temp_profile:~0,-4%"
:recall_add_remove_homebrew
echo.
echo Les homebrews dont le nom est préfixé d'un "*" sont les homebrews présent dans le profile.
echo.
call :homebrews_list
for /l %%i in (1,1,%count_homebrews%) do (
	tools\gnuwin32\bin\grep.exe -c "!homebrews_list_%%i!" <"%temp_path_profile%" > templogs\tempvar.txt
	set /p temp_count_homebrews=<templogs\tempvar.txt
	IF !temp_count_homebrews! EQU 0 (
		echo %%i: !homebrews_list_%%i!
	) else (
		echo %%i: *!homebrews_list_%%i!
	)
)
echo N'importe quel autre choix: Arrêter la modification de la liste des homebrews du profile.
echo.
set homebrew_choice=
set /p homebrew_choice=Choisir un homebrew pour l'ajouter ou le supprimer: 
IF "%homebrew_choice%"=="" set /a homebrew_choice=0
call TOOLS\Storage\functions\strlen.bat nb "%homebrew_choice%"
set i=0
:check_chars_homebrew_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!homebrew_choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_homebrew_choice
		)
	)
	IF "!check_chars!"=="0" (
exit /b 400
	)
)
IF %homebrew_choice% GTR %count_homebrews% exit /b 400
IF %homebrew_choice% EQU 0 exit /b 400
TOOLS\gnuwin32\bin\sed.exe -n %homebrew_choice%p <templogs\homebrews_list.txt > templogs\tempvar.txt
set /p homebrew_selected=<templogs\tempvar.txt
tools\gnuwin32\bin\grep.exe -c "%homebrew_selected%" <"%temp_path_profile%" > templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
IF %temp_count% EQU 0 (
	echo %homebrew_selected%>>"%temp_path_profile%"
) else (
	tools\gnuwin32\bin\grep.exe -v "%homebrew_selected%" <"%temp_path_profile%" > templogs\tempvar.txt
	del /q "%temp_path_profile%" >nul
	move templogs\tempvar.txt "%temp_path_profile%" >nul
)
goto:recall_add_remove_homebrew
exit /b

:homebrews_list
copy nul templogs\homebrews_list.txt >nul
echo Appstore>>templogs\homebrews_list.txt
echo BiggestDump>>templogs\homebrews_list.txt
echo Checkpoint>>templogs\homebrews_list.txt
echo ChoiDuJourNX>>templogs\homebrews_list.txt
echo DZ>>templogs\homebrews_list.txt
echo EdiZon>>templogs\homebrews_list.txt
echo Ftpd>>templogs\homebrews_list.txt
echo GagOrder>>templogs\homebrews_list.txt
echo Gcdumptool>>templogs\homebrews_list.txt
echo Goldleaf>>templogs\homebrews_list.txt
echo Incognito>>templogs\homebrews_list.txt
echo JKSV>>templogs\homebrews_list.txt
echo Lithium>>templogs\homebrews_list.txt
echo Lockpick>>templogs\homebrews_list.txt
echo Mod_Plague>>templogs\homebrews_list.txt
echo N1dusd>>templogs\homebrews_list.txt
echo NX-Shell>>templogs\homebrews_list.txt
echo Pplay>>templogs\homebrews_list.txt
echo Sdsetup-switch>>templogs\homebrews_list.txt
echo SwitchIdent>>templogs\homebrews_list.txt
echo Tinfoil>>templogs\homebrews_list.txt
echo Zerotwoxci>>templogs\homebrews_list.txt
tools\gnuwin32\bin\grep.exe -c "" <templogs\homebrews_list.txt > templogs\tempvar.txt
set /p count_homebrews=<templogs\tempvar.txt
for /l %%i in (1,1,%count_homebrews%) do (
	TOOLS\gnuwin32\bin\sed.exe -n %%ip <templogs\homebrews_list.txt > templogs\tempvar.txt
	set /p homebrews_list_%%i=<templogs\tempvar.txt
)
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
	mkdir templogs
)
endlocal