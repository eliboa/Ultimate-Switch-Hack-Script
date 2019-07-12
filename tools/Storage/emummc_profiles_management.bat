::Script by Shadow256
chcp 65001 >nul
Setlocal enabledelayedexpansion
@echo off
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
IF NOT EXIST "tools\sd_switch\atmosphere_emummc_profiles\*.*" mkdir "tools\sd_switch\atmosphere_emummc_profiles"

:define_action_choice
cls
echo Gestion des profiles d'emummc pour Atmosphere
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Créer un profile?
echo 2: Modifier un profile?
echo 3: Supprimer un profile?
echo 0: Obtenir la configuration de l'emummc d'un profile?
echo N'importe quel autre choix: Revenir au menu précédent?
echo.
set action_choice=
set /p action_choice=Faites votre choix: 
IF "%action_choice%"=="1" cls & goto:create_profile
IF "%action_choice%"=="2" cls & goto:modify_profile
IF "%action_choice%"=="3" cls & goto:remove_profile
IF "%action_choice%"=="0" cls & goto:info_profile
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
call :parse_emummc.ini_file "%profile_selected%" "display"
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
copy nul "tools\sd_switch\atmosphere_emummc_profiles\%new_profile_name%.ini" >nul
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
	call :emunand_config "%profile_selected%"
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
	Setlocal enabledelayedexpansion
	cd tools\sd_switch\profiles
	set /a temp_count=0
	for %%p in (*.bat) do (
		..\..\gnuwin32\bin\grep.exe -c "atmosphere_emummc_profile_path=tools\\sd_switch\\atmosphere_emummc_profiles\\%profile_selected%" <"%%p" > ..\..\..\templogs\tempvar.txt
		set /p temp_test_profile=<..\..\..\templogs\tempvar.txt
		IF "!temp_test_profile!"=="1" (
			set /a temp_count+=1
			set temp_used_profile_list_!temp_count!=%%p
		) else (
			..\..\gnuwin32\bin\grep.exe -c "reinx_emummc_profile_path=tools\\sd_switch\\atmosphere_emummc_profiles\\%profile_selected%" <"%%p" > ..\..\..\templogs\tempvar.txt
			set /p temp_test_profile=<..\..\..\templogs\tempvar.txt
			IF "!temp_test_profile!"=="1" (
				set /a temp_count+=1
				set temp_used_profile_list_!temp_count!=%%p
			)
		)
	)
	cd ..\..\..
	IF !temp_count! EQU 0 (
		goto:removing_profile
	) else (
		echo Ce profile est utilisé dans les profiles généraux suivant:
		for /l %%k in (1,1,!temp_count!) do (
			echo !temp_used_profile_list_%%k:~0,-4!
		)
	)
	echo.
	set define_del_profile=
	set /p define_del_profile=Supprimer ce profile supprimera les profiles généraux auxquels il est lié, souhaitez-vous continuer? ^(O/n^): 
	IF NOT "!define_del_profile!"=="" set define_del_profile=!define_del_profile:~0,1!
	IF /i "!define_del_profile!"=="o" (
		for /l %%k in (1,1,!temp_count!) do (
			del /q tools\sd_switch\profiles\!temp_used_profile_list_%%k!
		)
	) else (
		echo Opération annulée.
		endlocal
		goto:define_action_choice
	)
	:removing_profile
	del /q "tools\sd_switch\atmosphere_emummc_profiles\%profile_selected%" >nul
	echo Profile "%profile_selected:~0,-4%" supprimé avec succès.
	endlocal
)
pause
goto:define_action_choice

:select_profile
set profile_selected=
echo Sélectionner un profile:
IF NOT EXIST "tools\sd_switch\atmosphere_emummc_profiles\*.ini" exit /b 404
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
cd tools\sd_switch\atmosphere_emummc_profiles
for %%p in (*.ini) do (
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
set /p profile_choice=Choisir un profile: 
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

:parse_emummc.ini_file
set temp_profile_path=tools\sd_switch\atmosphere_emummc_profiles\%~1
set emunand_enable=
set emummc_id=
set emummc_sector=
set emummc_path=
set emummc_nintendo_path=
tools\gnuwin32\bin\grep.exe -E "^^enabled =" <"%temp_profile_path%" | tools\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
set /p emunand_enable=<templogs\tempvar.txt
del /q templogs\tempvar.txt
IF NOT "%emunand_enable%"=="" set emunand_enable=%emunand_enable:~1%
IF "%emunand_enable%"=="1" (
	set emunand_enable=o
) else (
	set emunand_enable=n
)
tools\gnuwin32\bin\grep.exe -E "^^id =" <"%temp_profile_path%" | tools\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
set /p emummc_id=<templogs\tempvar.txt
del /q templogs\tempvar.txt
IF NOT "%emummc_id%"=="" set emummc_id=%emummc_id:~1%
tools\gnuwin32\bin\grep.exe -E "^^sector =" <"%temp_profile_path%" | tools\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
set /p emummc_sector=<templogs\tempvar.txt
del /q templogs\tempvar.txt
IF NOT "%emummc_sector%"=="" set emummc_sector=%emummc_sector:~1%
tools\gnuwin32\bin\grep.exe -E "^^path =" <"%temp_profile_path%" | tools\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
set /p emummc_path=<templogs\tempvar.txt
del /q templogs\tempvar.txt
IF NOT "%emummc_path%"=="" set emummc_path=%emummc_path:~1%
tools\gnuwin32\bin\grep.exe -E "^^nintendo_path =" <"%temp_profile_path%" | tools\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
set /p emummc_nintendo_path=<templogs\tempvar.txt
del /q templogs\tempvar.txt
IF NOT "%emummc_nintendo_path%"=="" set emummc_nintendo_path=%emummc_nintendo_path:~1%
IF NOT "%~2"=="display" (
	exit /b
) else (
	IF /i "%emunand_enable%"=="o" (
		echo Emunand activée avec les paramètres suivants:
		IF "%emummc_id%"=="" (
			echo ID de l'emunand par défaut.
		) else (
			echo ID de l'emunand: %emummc_id%
		)
		IF "%emummc_sector%"=="" (
			echo Aucun secteur de démarrage configuré.
		) else (
			echo Secteur de démarrage de l'emunand: %emummc_sector%
		)
		IF "%emummc_path%"=="" (
			echo Aucun chemin vers les fichiers de dump de la nand défini.
		) else (
			echo Chemin vers les fichiers de dump de la nand: %emummc_path%
		)
		IF "%emummc_nintendo_path%"=="" (
			echo Chemin du dossier Nintendo de l'emunand par défaut.
		) else (
			echo Chemin du dossier Nintendo de l'emunand: %emummc_nintendo_path%
		)
	) else (
		echo Emunand désactivée.
	)
)
exit /b

:emunand_config
echo.
echo Configuration de l'emunand
echo.
set emunand_enable=
set /p "emunand_enable=Souhaitez-vous activer l'emunand? (O/n): "
IF NOT "%emunand_enable%"=="" set emunand_enable=%emunand_enable:~0,1%
IF /i NOT "%emunand_enable%"=="o" goto:skip_emunand_config
:define_emummc_id
set emummc_id=
set /p emummc_id=Définir l'ID de l'emunand (laisser vide pour utiliser l'ID par défaut) (ne pas noter le 0x de début) (4 caractères maximum): 
IF "%emummc_id%"=="" goto:skip_define_emummc_id
call TOOLS\Storage\functions\strlen.bat nb "%emummc_id%"
IF %nb% GTR 4 (
	echo L'ID de l'emunand doit comprendre 4 caractères hexadécimaux au maximum.
	goto:define_emummc_id
)
call TOOLS\Storage\functions\CONV_VAR_to_MAJ.bat emummc_id
set i=0
:check_chars_emummc_id
IF %i% LSS %nb% (
	FOR %%z in (0 1 2 3 4 5 6 7 8 9 A B C D E F) do (
		IF "!emummc_id:~%i%,1!"=="%%z" (
			set /a i+=1
			goto:check_chars_emummc_id
		)
	)
	echo Un caractère non autorisé a été saisie dans l'ID de l'emunand.
	goto:define_emummc_id
)
:skip_define_emummc_id
:define_emummc_sector
set emummc_sector=
set /p emummc_sector=Définir le secteur de la partition démarrant l'emunand (si emunand via fichiers, laisser cette valeur vide) (ne pas noter le 0x de début): 
IF "%emummc_sector%"=="" goto:skip_define_emummc_sector
call TOOLS\Storage\functions\strlen.bat nb "%emummc_sector%"
call TOOLS\Storage\functions\CONV_VAR_to_MAJ.bat emummc_sector
set i=0
:check_chars_emummc_sector
IF %i% LSS %nb% (
	FOR %%z in (0 1 2 3 4 5 6 7 8 9 A B C D E F) do (
		IF "!emummc_sector:~%i%,1!"=="%%z" (
			set /a i+=1
			goto:check_chars_emummc_sector
		)
	)
	echo Un caractère non autorisé a été saisie dans le secteur de démarrage de l'emunand.
	goto:define_emummc_sector
)
goto:define_emummc_nintendo_path
:skip_define_emummc_sector
set emummc_path=
set /p emummc_path=Définir le chemin vers le dossier contenant les fichiers permettant de booter l'emunand (si laisser vide, l'emunand sera désactivée): 
IF "%emummc_path%"=="" (
	echo Aucun secteur de démarrage ni chemin de dossier vers des fichiers d'un dump de nand défini, l'emunand va donc être désactivée.
	set emunand_enable=n
	goto:skip_emunand_config
)
:define_emummc_nintendo_path
set emummc_nintendo_path=
set /p emummc_nintendo_path=Définir le chemin du dossier nintendo de l'emunand (laisser vide pour garder le chemin par défaut): 
:skip_emunand_config
:copy_atmosphere_emummc_configuration
echo [emummc]>"tools\sd_switch\atmosphere_emummc_profiles\%~1"
IF /i "%emunand_enable%"=="o" (
	echo enabled = ^1>>"tools\sd_switch\atmosphere_emummc_profiles\%~1"
) else (
	echo enabled = ^0>>"tools\sd_switch\atmosphere_emummc_profiles\%~1"
)
IF NOT "%emummc_id%"=="" (
	echo id = 0x%emummc_id%>>"tools\sd_switch\atmosphere_emummc_profiles\%~1"
)
IF NOT "%emummc_sector%"=="" (
	echo sector = 0x%emummc_sector%>>"tools\sd_switch\atmosphere_emummc_profiles\%~1"
)
IF NOT "%emummc_path%"=="" (
	echo path = %emummc_path%>>"tools\sd_switch\atmosphere_emummc_profiles\%~1"
)
IF NOT "%emummc_nintendo_path%"=="" (
	echo nintendo_path = %emummc_nintendo_path%>>"tools\sd_switch\atmosphere_emummc_profiles\%~1"
)
echo.
echo Configuration du fichier d'emummc sauvegardée avec succès dans le profile "%profile_selected:~0,-4%".
pause
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
	mkdir templogs
)
endlocal