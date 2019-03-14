::Script by Shadow256
chcp 65001 >nul
Setlocal enabledelayedexpansion
@echo off
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
IF NOT EXIST "tools\sd_switch\cheats\profiles\*.*" mkdir "tools\sd_switch\cheats\profiles"

echo Gestions de profiles pour la sélection de cheats optionnels à copier durant la préparation d'une SD.
:define_action_choice
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Créer un profile?
echo 2: Modifier un profile?
echo 3: Supprimer un profile?
echo 0: Obtenir la liste des cheats d'un profile?
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
echo Cheats présents dans le profile:
call :list_cheats_in_profile "%profile_selected%"
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
copy nul "tools\sd_switch\cheats\profiles\%new_profile_name%.ini" >nul
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
	call :add_del_cheat_in_profile "%profile_selected%"
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
	del /q "tools\sd_switch\cheats\profiles\%profile_selected%" >nul
	echo Profile "%profile_selected:~0,-4%" supprimé avec succès.
) else (
	echo Opération annulée.
)
pause
goto:define_action_choice

:select_profile
set profile_selected=
echo Sélectionner un profile:
IF NOT EXIST "tools\sd_switch\cheats\profiles\*.ini" exit /b 404
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
cd tools\sd_switch\cheats\profiles
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

:list_cheats_in_profile
Setlocal disabledelayedexpansion
copy nul templogs\cheats_list.txt >nul
tools\gnuwin32\bin\grep.exe -c "" <"tools\sd_switch\cheats\profiles\%~1" > templogs\tempvar.txt
set /p count_cheats=<templogs\tempvar.txt
set temp_count=1
:listing_cheats_in_profile
IF %count_cheats% EQU 0 (
	echo Aucun cheats configuré pour ce profile.
	endlocal
	exit /b
)
IF %temp_count% GTR %count_cheats% goto:skip_listing_cheats_in_profile
TOOLS\gnuwin32\bin\sed.exe -n %temp_count%p <"tools\sd_switch\cheats\profiles\%~1" > templogs\tempvar.txt
set /p temp_cheat_id=<templogs\tempvar.txt
TOOLS\gnuwin32\bin\grep.exe "%temp_cheat_id%" <tools\sd_switch\cheats\README.md | TOOLS\gnuwin32\bin\cut.exe -d ^| -f 2 > templogs\tempvar.txt
set /p temp_cheat_name=<templogs\tempvar.txt
TOOLS\gnuwin32\bin\grep.exe "%temp_cheat_id%" <tools\sd_switch\cheats\README.md | TOOLS\gnuwin32\bin\cut.exe -d ^| -f 4 | TOOLS\gnuwin32\bin\cut.exe -d ^! -f 2 | TOOLS\gnuwin32\bin\cut.exe -d ^( -f 1 > templogs\tempvar.txt
set /p temp_cheat_region=<templogs\tempvar.txt
echo %temp_cheat_name% %temp_cheat_region%: %temp_cheat_id%>>templogs\cheats_list.txt
set /a temp_count+=1
goto:listing_cheats_in_profile
:skip_listing_cheats_in_profile
%windir%\System32\sort.exe /l C <"templogs\cheats_list.txt" /o ""templogs\cheats_list.txt"
type "templogs\cheats_list.txt"
del /q templogs\cheats_list.txt
endlocal
exit /b

:add_del_cheat_in_profile
set temp_profile=%~1
set temp_path_profile=tools\sd_switch\cheats\profiles\%~1
set /a selected_page=1
call :cheats_list
IF %errorlevel% EQU 404 (
	del /q templogs\cheats_list.txt
	exit /b 400
)
set /a page_number=%count_cheats%/20
set mod_a=!count_cheats!
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
:recall_add_remove_cheat
echo Sélection d'un cheat à ajouter ou à supprimer pour le profile "%temp_profile:~0,-4%", page %selected_page%/%page_number%
echo.
echo Les cheats dont le nom est préfixé d'un "*" sont les cheats présent dans le profile.
echo.
IF %modulo% NEQ 0 (
	IF %selected_page% EQU %page_number% (
		set /a temp_max_display_cheats=%count_cheats%
		set /a temp_min_display_cheats=%count_cheats%-%modulo%
	) else (
		set /a temp_max_display_cheats=%selected_page%*20
		set /a temp_min_display_cheats=!temp_max_display_cheats!-19
	)
) else (
	set /a temp_max_display_cheats=%selected_page%*20
	set /a temp_min_display_cheats=!temp_max_display_cheats!-19
)
for /l %%i in (%temp_min_display_cheats%,1,%temp_max_display_cheats%) do (
	tools\gnuwin32\bin\grep.exe -c "!cheats_list_%%i_0!" <"%temp_path_profile%" > templogs\tempvar.txt
	set /p temp_count_cheats=<templogs\tempvar.txt
	IF !temp_count_cheats! EQU 0 (
		echo %%i: !cheats_list_%%i_0!; !cheats_list_%%i_1! !cheats_list_%%i_2!
	) else (
		echo %%i: *!cheats_list_%%i_0!; !cheats_list_%%i_1! !cheats_list_%%i_2!
	)
)
echo P: Changer de page, faire suivre le P d'un numéro de page valide.
echo N'importe quel autre choix: Arrêter la modification de la liste des cheats du profile.
echo.
set cheat_choice=
set /p cheat_choice=Choisir un cheat pour l'ajouter/le supprimer ou sélectionner une autre page: 
IF "%cheat_choice%"=="" set /a cheat_choice=0
IF /i "%cheat_choice:~0,1%"=="p" (
	set change_page=Y
	set cheat_choice=%cheat_choice:~1%
	)
IF "%cheat_choice%"=="" set /a cheat_choice=0
	call TOOLS\Storage\functions\strlen.bat nb "%cheat_choice%"
set i=0
:check_chars_cheat_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!cheat_choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_cheat_choice
		)
	)
	IF "!check_chars!"=="0" (
exit /b 400
	)
)
IF "%change_page%"=="Y" (
	IF %cheat_choice% GTR %page_number% (
		echo Cette page n'existe pas.
		set change_page=
		goto:recall_add_remove_cheat
	) else IF %cheat_choice% LEQ 0 (
	echo Cette page n'existe pas.
	set change_page=
	goto:recall_add_remove_cheat
	) else (
		set selected_page=%cheat_choice%
		set change_page=
		goto:recall_add_remove_cheat
	)
)
IF %cheat_choice% GTR %count_cheats% (
	del /q templogs\cheats_list.txt
	exit /b 400
)
IF %cheat_choice% EQU 0 (
	del /q templogs\cheats_list.txt
	exit /b 400
)
TOOLS\gnuwin32\bin\sed.exe -n %cheat_choice%p <templogs\cheats_list.txt > templogs\tempvar.txt
set /p cheat_selected=<templogs\tempvar.txt
tools\gnuwin32\bin\grep.exe -c "%cheat_selected%" <"%temp_path_profile%" > templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
IF %temp_count% EQU 0 (
	echo %cheat_selected%>>"%temp_path_profile%"
) else (
	tools\gnuwin32\bin\grep.exe -v "%cheat_selected%" <"%temp_path_profile%" > templogs\tempvar.txt
	del /q "%temp_path_profile%" >nul
	move templogs\tempvar.txt "%temp_path_profile%" >nul
)
goto:recall_add_remove_cheat
exit /b

:cheats_list
copy nul templogs\cheats_list.txt >nul
::copy nul cheats_list.txt >nul
cd tools\sd_switch\cheats\titles
for /D %%i in (*) do (
	echo %%i>>..\..\..\..\templogs\cheats_list.txt
)
cd ..\..\..\..
tools\gnuwin32\bin\grep.exe -c "" <templogs\cheats_list.txt > templogs\tempvar.txt
set /p count_cheats=<templogs\tempvar.txt
set temp_count=1
:listing_cheats
IF %count_cheats% EQU 0 (
	echo Erreur, il ne semble y avoir aucun cheats dans le dossier "tools\sd_switch\cheats\titles" du script, le processus ne peut continuer.
	exit /b 404
)
IF %temp_count% GTR %count_cheats% goto:skip_listing_cheats
TOOLS\gnuwin32\bin\sed.exe -n %temp_count%p <templogs\cheats_list.txt > templogs\tempvar.txt
set /p cheats_list_%temp_count%_0=<templogs\tempvar.txt
set /p temp_cheat=<templogs\tempvar.txt
Setlocal disabledelayedexpansion
TOOLS\gnuwin32\bin\grep.exe "%temp_cheat%" <tools\sd_switch\cheats\README.md | TOOLS\gnuwin32\bin\cut.exe -d ^| -f 2 > templogs\tempvar.txt
endlocal
set /p cheats_list_%temp_count%_1=<templogs\tempvar.txt
Setlocal disabledelayedexpansion
TOOLS\gnuwin32\bin\grep.exe "%temp_cheat%" <tools\sd_switch\cheats\README.md | TOOLS\gnuwin32\bin\cut.exe -d ^| -f 4 | TOOLS\gnuwin32\bin\cut.exe -d ^! -f 2 | TOOLS\gnuwin32\bin\cut.exe -d ^( -f 1 > templogs\tempvar.txt
endlocal
set /p cheats_list_%temp_count%_2=<templogs\tempvar.txt
::echo !cheats_list_%temp_count%_0!: !cheats_list_%temp_count%_1! !cheats_list_%temp_count%_2! >>cheats_list.txt
set /a temp_count+=1
goto:listing_cheats
:skip_listing_cheats
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
	mkdir templogs
)
endlocal