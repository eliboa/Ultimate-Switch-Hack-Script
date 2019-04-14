::Script by Shadow256
chcp 65001 >nul
Setlocal enabledelayedexpansion
@echo off
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
IF NOT EXIST "tools\sd_switch\emulators\profiles\*.*" mkdir "tools\sd_switch\emulators\profiles"

echo Gestions de profiles pour la sélection d'émulateurs à copier pour le pack d'émulateurs durant la préparation d'une SD.
:define_action_choice
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Créer un profile?
echo 2: Modifier un profile?
echo 3: Supprimer un profile?
echo 0: Obtenir la liste des émulateurs d'un profile?
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
echo.
echo Nom du profile: %profile_selected:~0,-4%
echo Emulateurs présents dans le profile:
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
copy nul "tools\sd_switch\emulators\profiles\%new_profile_name%.ini" >nul
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
	del /q "tools\sd_switch\emulators\profiles\%profile_selected%" >nul
	echo Profile "%profile_selected:~0,-4%" supprimé avec succès.
) else (
	echo Opération annulée.
)
pause
goto:define_action_choice

:select_profile
set profile_selected=
echo Sélectionner un profile:
IF NOT EXIST "tools\sd_switch\emulators\profiles\*.ini" exit /b 404
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
cd tools\sd_switch\emulators\profiles
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
Setlocal disabledelayedexpansion
copy nul templogs\homebrews_list.txt >nul
tools\gnuwin32\bin\grep.exe -c "" <"tools\sd_switch\emulators\profiles\%~1" > templogs\tempvar.txt
set /p count_homebrews=<templogs\tempvar.txt
IF %count_homebrews% EQU 0 (
	echo Aucun émulateur configuré pour ce profile.
	endlocal
	exit /b
)
%windir%\System32\sort.exe /l C <"tools\sd_switch\emulators\profiles\%~1" /o "templogs\homebrews_list.txt"
type "templogs\homebrews_list.txt"
del /q templogs\homebrews_list.txt
endlocal
exit /b

:add_del_homebrew_in_profile
set temp_profile=%~1
set temp_path_profile=tools\sd_switch\emulators\profiles\%~1
set /a selected_page=1
call :homebrews_list
IF %errorlevel% EQU 404 (
	del /q templogs\modules_list.txt
	exit /b 400
)
set /a page_number=%count_homebrews%/20
IF %count_homebrews% LEQ 20 (
	set /a modulo=0
	set /a page_number=1
	goto:skip:modulo_calc
)
set mod_a=!count_homebrews!
set mod_b=20
set mod_counter=0
for /l %%k in (1,1,!mod_a!) do (
    set /a mod_counter+=1
    set /a mod_a-=1
    if !mod_counter!==!mod_b! set /a mod_counter=0
    if !mod_a!==0 set modulo=!mod_counter!
)
if not defined modulo set modulo=0
IF %modulo% NEQ 0 set /a page_number+=1
:skip:modulo_calc
:recall_add_remove_homebrew
IF %count_homebrews% LEQ 20 (
	echo Sélection d'un émulateur à ajouter ou à supprimer pour le profile "%temp_profile:~0,-4%"
) else (
	echo Sélection d'un émulateur à ajouter ou à supprimer pour le profile "%temp_profile:~0,-4%", page %selected_page%/%page_number%
)
echo.
echo Les émulateurs dont le nom est préfixé d'un "*" sont les émulateurs présent dans le profile.
echo.
IF %modulo% NEQ 0 (
	IF %selected_page% EQU %page_number% (
		set /a temp_max_display_homebrews=%count_homebrews%
		set /a temp_min_display_homebrews=%count_homebrews%-%modulo%+1
	) else (
		set /a temp_max_display_homebrews=%selected_page%*20
		set /a temp_min_display_homebrews=!temp_max_display_homebrews!-19
	)
) else (
	IF %count_homebrews% LEQ 20 (
		set /a temp_max_display_homebrews=%count_homebrews%
		set /a temp_min_display_homebrews=1
	) else (
		set /a temp_max_display_homebrews=%selected_page%*20
		set /a temp_min_display_homebrews=!temp_max_display_homebrews!-19
	)
)
for /l %%i in (%temp_min_display_homebrews%,1,%temp_max_display_homebrews%) do (
	tools\gnuwin32\bin\grep.exe -c "!homebrews_list_%%i_0!" <"%temp_path_profile%" > templogs\tempvar.txt
	set /p temp_count_homebrews=<templogs\tempvar.txt
	IF !temp_count_homebrews! EQU 0 (
		echo %%i: !homebrews_list_%%i_0!
	) else (
		echo %%i: *!homebrews_list_%%i_0!
	)
)
IF %count_homebrews% GTR 20 echo P: Changer de page, faire suivre le P d'un numéro de page valide.
echo N'importe quel autre choix: Arrêter la modification de la liste des homebrews du profile.
echo.
set homebrew_choice=
set /p homebrew_choice=Choisir un homebrew pour l'ajouter ou le supprimer: 
IF "%homebrew_choice%"=="" set /a homebrew_choice=0
call TOOLS\Storage\functions\strlen.bat nb "%homebrew_choice%"
IF /i "%homebrew_choice:~0,1%"=="p" (
	set change_page=Y
	IF %nb% equ 1 (
		set homebrew_choice=0
	) else (
		set homebrew_choice=%homebrew_choice:~1%
	)
	)
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
IF "%change_page%"=="Y" (
	IF %homebrew_choice% GTR %page_number% (
		echo Cette page n'existe pas.
		set change_page=
		goto:recall_add_remove_homebrew
	) else IF %homebrew_choice% LEQ 0 (
	echo Cette page n'existe pas.
	set change_page=
	goto:recall_add_remove_homebrew
	) else (
		set selected_page=%homebrew_choice%
		set change_page=
		goto:recall_add_remove_homebrew
	)
)
IF %homebrew_choice% GTR %count_homebrews% (
	del /q templogs\homebrews_list.txt
	exit /b 400
)
IF %homebrew_choice% EQU 0 (
	del /q templogs\homebrews_list.txt
	exit /b 400
)
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
cd tools\sd_switch\emulators\pack
for /D %%i in (*) do (
	echo %%i>>..\..\..\..\templogs\homebrews_list.txt
)
cd ..\..\..\..
tools\gnuwin32\bin\grep.exe -c "" <templogs\homebrews_list.txt > templogs\tempvar.txt
set /p count_homebrews=<templogs\tempvar.txt
set temp_count=1
:listing_homebrews
IF %count_homebrews% EQU 0 (
	echo Erreur, il ne semble y avoir aucun émulateur dans le dossier "tools\sd_switch\emulators\pack" du script, le processus ne peut continuer.
	exit /b 404
)
IF %temp_count% GTR %count_homebrews% goto:skip_listing_homebrews
TOOLS\gnuwin32\bin\sed.exe -n %temp_count%p <templogs\homebrews_list.txt > templogs\tempvar.txt
set /p homebrews_list_%temp_count%_0=<templogs\tempvar.txt
set /a temp_count+=1
goto:listing_homebrews
:skip_listing_homebrews
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
	mkdir templogs
)
endlocal