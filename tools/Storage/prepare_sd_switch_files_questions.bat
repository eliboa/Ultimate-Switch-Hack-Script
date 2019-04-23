IF EXIST "tools\packs_version.txt" (
	echo Il semble qu'une mise à jour des packs via le script ait échouée précédemment et n'ai pas été réussie depuis, par sécurité ce script va donc s'arrêter.
	echo Si vous êtes certains d'avoir mis à jour correctement le dossier des packs (par exemple en retéléchargeant le script et en extrayant le dossier "tools\sd_switch" de l'archive dans le dossier "tools" du script, vous pouvez supprimer manuellement le fichier "tools\packs_version.txt" et relancer ce script et cette erreur n'apparaîtra plus. Notez que si ceci n'a pas été fait correctement, ce script pourrait avoir des comportements anormaux.
	goto:endscript
)
IF EXIST "tools\cheats_version.txt" (
	echo Il semble qu'une mise à jour des cheats via le script ait échouée précédemment et n'ai pas été réussie depuis, par sécurité ce script va donc s'arrêter.
	echo Si vous êtes certains d'avoir mis à jour correctement le dossier des cheats (par exemple en retéléchargeant le script et en extrayant le dossier "tools\sd_switch\cheats" de l'archive dans le dossier "tools\sd_switch" du script, vous pouvez supprimer manuellement le fichier "tools\cheats_version.txt" et relancer ce script et cette erreur n'apparaîtra plus. Notez que si ceci n'a pas été fait correctement, ce script ne proposera pas la possibilité de copier les cheats sur la SD.
	set cheats_update_error=Y
)
echo.
echo Préparation des fichiers à copier sur la SD
echo.
set /p launch_manual=Souhaitez-vous lancer la page d'information sur se qui peut être copié (vivement conseillé)? (O/n):
IF NOT "%launch_manual%"=="" set launch_manual=%launch_manual:~0,1%
IF /i "%launch_manual%"=="o" (
	start DOC\files\sd_prepare.html
)

echo.
set /p copy_atmosphere_pack=Souhaitez-vous copier le pack pour lancer Atmosphere via le payload Fusee-primary d'Atmosphere (CFW Atmosphere complet) ou via Hekate (pack Kosmos)? (O/n):
IF NOT "%copy_atmosphere_pack%"=="" set copy_atmosphere_pack=%copy_atmosphere_pack:~0,1%
IF /i NOT "%copy_atmosphere_pack%"=="o" goto:skip_ask_cheats_atmosphere
	:ask_nogc_atmosphere
	echo.
	echo Souhaitez-vous activer le patch NOGC pour Atmosphere  (firmware 4.0.0 et supérieur^)?
	echo Ce patch est utile pour ceux ayant mis à jour avec la méthode ChoiDuJour à partir du firmware 3.0.2 et inférieur et ne voulant pas que le firmware du port cartouche soit mis à jour, permettant ainsi le downgrade en-dessous de la version 4.0.0 sans perdre l'usage du port cartouche.
	echo Attention,, si un firmware supérieur au 4.0.0 est chargé une seule fois par le bootloader de Nintendo (démarrage classique^) ou sans ce patche, le firmware du port cartouche sera mis à jour et donc l'activation de ce patch sera inutile.
	set /p atmosphere_enable_nogc_patch=Souhaitez-vous activer le patch nogc? (O/n^):
	IF NOT "%atmosphere_enable_nogc_patch%"=="" set atmosphere_enable_nogc_patch=%atmosphere_enable_nogc_patch:~0,1%
:skip_ask_nogc_atmosphere
:ask_prodinfo_config_atmosphere
echo.
echo Configuration des options pour la partition PRODINFO pour Atmosphere
echo.
echo Activer l'écriture sur la partition PRODINFO (utile si vous compter utiliser le homebrew Incognito pour supprimer les infos spécifique à la console de cette partition mais sinon il vaut mieux désactiver cette option)?
echo Notez qu'en cas d'activation pour le homebrew Incognito, il est préférable de désactiver cette option une fois que le homebrew aura fait se qu'il avait à faire.
echo.
echo O: Activer l'écriture sur la partition PRODINFO?
echo Tout autre choix: Désactiver l'écriture sur la partition PRODINFO?
echo.
set /p atmosphere_enable_prodinfo_write=Faites votre choix: 
:skip_ask_prodinfo_config_atmosphere
call :modules_profile_choice "atmosphere"
IF "%cheats_update_error%"=="Y" goto:skip_ask_cheats_atmosphere
:ask_cheats_atmosphere
echo.
set /p atmosphere_enable_cheats=Souhaitez-vous copier les cheats pour Atmosphere (utilisable avec le homebrew EdiZon)? (O/n): 
IF NOT "%atmosphere_enable_cheats%"=="" set atmosphere_enable_cheats=%atmosphere_enable_cheats:~0,1%
:skip_ask_cheats_atmosphere

echo.
IF /i "%copy_atmosphere_pack%"=="o" (
	echo copie du pack  ReiNX?
	echo Attention: Vous avez choisi la copie du pack Atmosphere, si vous êtes en firmware 7.0.0 ou supérieur et si vous choisissez de copier aussi le pack ReiNX, Atmosphere ne sera plus lançable via son payload dédié "Fusee Primary", il faudra donc le lancer via Kosmos et les configurations de Hekate pour l'utiliser ou passer par le payload de Retro_Reloaded.
	set /p copy_reinx_pack=Souhaitez-vous copier le pack pour lancer ReiNX? ^(O/n^):
) else (
	set /p copy_reinx_pack=Souhaitez-vous copier le pack pour lancer ReiNX? ^(O/n^):
)
IF NOT "%copy_reinx_pack%"=="" set copy_reinx_pack=%copy_reinx_pack:~0,1%
IF /i "%copy_reinx_pack%"=="o" (
	echo.
	echo Souhaitez-vous activer le patch NOGC pour ReiNX (firmware 4.0.0 et supérieur^)?
	echo Ce patch est utile pour ceux ayant mis à jour avec la méthode ChoiDuJour à partir du firmware 3.0.2 et inférieur et ne voulant pas que le firmware du port cartouche soit mis à jour, permettant ainsi le downgrade en-dessous de la version 4.0.0 sans perdre l'usage du port cartouche.
	echo Attention,, si un firmware supérieur au 4.0.0 est chargé une seule fois par le bootloader de Nintendo (démarrage classique^) ou sans ce patche, le firmware du port cartouche sera mis à jour et donc l'activation de ce patch sera inutile.
	set /p reinx_enable_nogc_patch=Souhaitez-vous activer le patch nogc? (O/n^):
	IF NOT "!reinx_enable_nogc_patch!"=="" set reinx_enable_nogc_patch=!reinx_enable_nogc_patch:~0,1!
)
IF /i "%copy_reinx_pack%"=="o" call :modules_profile_choice "reinx"

echo.
set /p copy_memloader=Souhaitez-vous copier les fichiers nécessaire à Memloader pour monter la SD, la partition EMMC, la partition Boot0 ou la partition Boot1 sur un PC en lançant simplement le payload de Memloader? (Si la copie de SXOS a été souhaité, le payload sera aussi copié à la racine de la SD pour pouvoir le lancer grâce au payload de SXOS) (O/n):
IF NOT "%copy_memloader%"=="" set copy_memloader=%copy_memloader:~0,1%

echo.
set /p copy_sxos_pack=Souhaitez-vous copier le pack pour lancer SXOS? (O/n):
IF NOT "%copy_sxos_pack%"=="" set copy_sxos_pack=%copy_sxos_pack:~0,1%
IF /i NOT "%copy_sxos_pack%"=="o" goto:skip_ask_cheats_sxos
set /p copy_payloads=Souhaitez-vous copier les fichiers de payloads des fonctions choisient précédemment à la racine de la SD pour être compatible avec le lancement de payloads du payload SX_Loader? (O/n):
IF NOT "!copy_payloads!"=="" set copy_payloads=!copy_payloads:~0,1!
IF "%cheats_update_error%"=="Y" goto:skip_ask_cheats_sxos
:ask_cheats_sxos
echo.
	set /p sxos_enable_cheats=Souhaitez-vous copier les cheats pour SX OS (utilisable avec le ROMMENU de SX OS)? (O/n): 
	IF NOT "%sxos_enable_cheats%"=="" set sxos_enable_cheats=%sxos_enable_cheats:~0,1%
:skip_ask_cheats_sxos

echo.
set /p copy_emu=Souhaitez-vous copier le pack d'émulateurs? (O/n):
IF NOT "%copy_emu%"=="" set copy_emu=%copy_emu:~0,1%
IF /i "%copy_emu%"=="o" (
	IF /i NOT "%del_files_dest_copy%"=="o" (
		set /p keep_emu_configs=Souhaitez-vous concerver vos anciens fichiers de configurations d'émulateurs? (O/n^):
		IF NOT "!keep_emu_configs!"=="" set keep_emu_configs=!keep_emu_configs:~0,1!
	)
) else (
	goto:skip_verif_emu_profile
)
:define_emu_select_profile
echo.
echo Sélection du profile pour la copie des émulateurs:
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
IF NOT EXIST "tools\sd_switch\emulators\profiles\*.ini" (
	goto:emu_no_profile_created
)
cd tools\sd_switch\emulators\profiles
for %%p in (*.ini) do (
	set temp_profilename=%%p
	set temp_profilename=!temp_profilename:~0,-4!
	echo !temp_count!: !temp_profilename!
	echo %%p>> ..\..\..\..\templogs\profiles_list.txt
	set /a temp_count+=1
)
cd ..\..\..\..
:emu_no_profile_created
IF EXIST "tools\default_configs\emu_profile_all.ini" (
	echo %temp_count%: Tous les émulateurs.
) else (
	set /a temp_count-=1
	set emu_no_default_config=Y
)
echo 0: Accéder à la gestion des profiles d'émulateurs.
echo Tout autre choix: Ne copier aucun des émulateurs.
echo.
set emu_profile_path=
set emu_profile=
set /p emu_profile=Choisissez un profile d'émulateurs: 
IF "%emu_profile%"=="" (
	set pass_copy_emu_pack=Y
	goto:skip_verif_emu_profile
)
call TOOLS\Storage\functions\strlen.bat nb "%emu_profile%"
set i=0
:check_chars_emu_profile
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!emu_profile:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_emu_profile
		)
	)
	IF "!check_chars!"=="0" (
		set pass_copy_emu_pack=Y
		goto:skip_verif_emu_profile
	)
)
IF %emu_profile% GTR %temp_count% (
	set pass_copy_emu_pack=Y
		goto:skip_verif_emu_profile
)
IF "%emu_profile%"=="0" (
	call tools\Storage\emulators_pack_profiles_management.bat
	goto:define_emu_select_profile
)
IF %emu_profile% EQU %temp_count% (
	IF NOT "%emu_no_default_config%"=="Y" (
		set emu_profile_path=tools\default_configs\emu_profile_all.ini
		goto:skip_verif_emu_profile
	)
)
TOOLS\gnuwin32\bin\sed.exe -n %emu_profile%p <templogs\profiles_list.txt > templogs\tempvar.txt
set /p emu_profile_path=<templogs\tempvar.txt
set emu_profile_path=tools\sd_switch\emulators\profiles\%emu_profile_path%
:skip_verif_emu_profile
del /q templogs\profiles_list.txt >nul 2>&1

:define_select_profile
echo.
echo Sélection du profile pour la copie des homebrews optionnels:
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
IF NOT EXIST "tools\sd_switch\mixed\profiles\*.ini" (
	goto:no_profile_created
)
cd tools\sd_switch\mixed\profiles
for %%p in (*.ini) do (
	set temp_profilename=%%p
	set temp_profilename=!temp_profilename:~0,-4!
	echo !temp_count!: !temp_profilename!
	echo %%p>> ..\..\..\..\templogs\profiles_list.txt
	set /a temp_count+=1
)
cd ..\..\..\..
:no_profile_created
IF EXIST "tools\default_configs\mixed_profile_all.ini" (
	echo %temp_count%: Tous les homebrews optionnels.
) else (
	set /a temp_count-=1
	set no_default_config=Y
)
echo 0: Accéder à la gestion des profiles de homebrews.
echo Tout autre choix: Ne copier aucun des homebrews optionnels.
echo.
set mixed_profile_path=
set mixed_profile=
set /p mixed_profile=Choisissez un profile de homebrews: 
IF "%mixed_profile%"=="" (
	set pass_copy_mixed_pack=Y
	goto:skip_verif_mixed_profile
)
call TOOLS\Storage\functions\strlen.bat nb "%mixed_profile%"
set i=0
:check_chars_mixed_profile
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!mixed_profile:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_mixed_profile
		)
	)
	IF "!check_chars!"=="0" (
		set pass_copy_mixed_pack=Y
		goto:skip_verif_mixed_profile
	)
)
IF %mixed_profile% GTR %temp_count% (
	set pass_copy_mixed_pack=Y
		goto:skip_verif_mixed_profile
)
IF "%mixed_profile%"=="0" (
	call tools\Storage\mixed_pack_profiles_management.bat
	goto:define_select_profile
)
IF %mixed_profile% EQU %temp_count% (
	IF NOT "%no_default_config%"=="Y" (
		set mixed_profile_path=tools\default_configs\mixed_profile_all.ini
		goto:skip_verif_mixed_profile
	)
)
TOOLS\gnuwin32\bin\sed.exe -n %mixed_profile%p <templogs\profiles_list.txt > templogs\tempvar.txt
set /p mixed_profile_path=<templogs\tempvar.txt
set mixed_profile_path=tools\sd_switch\mixed\profiles\%profile_path%
:skip_verif_mixed_profile
del /q templogs\profiles_list.txt >nul
:define_select_cheats_profile
set cheats_profile_path=
set cheats_profile_name=
set cheats_profile=
set copy_cheats=
copy nul templogs\profiles_list.txt >nul
IF /i "%atmosphere_enable_cheats%"=="o" set copy_cheats=Y
IF /i "%sxos_enable_cheats%"=="o" set copy_cheats=Y
IF NOT "%copy_cheats%"=="Y" goto:skip_verif_cheats_profile
echo.
echo Sélection du profile pour la copie des cheats:
set /a temp_count=1
IF NOT EXIST "tools\sd_switch\cheats\profiles\*.ini" (
	goto:no_cheats_profile_created
)
cd tools\sd_switch\cheats\profiles
for %%p in (*.ini) do (
	set temp_profilename=%%p
	set temp_profilename=!temp_profilename:~0,-4!
	echo !temp_count!: !temp_profilename!
	echo %%p>> ..\..\..\..\templogs\profiles_list.txt
	set /a temp_count+=1
)
cd ..\..\..\..
:no_cheats_profile_created
echo 0: Accéder à la gestion des profiles de cheats.
echo Tout autre choix: Copier tous les cheats de la base de données.
echo.
set /p cheats_profile=Choisissez un profile de cheats: 
IF "%cheats_profile%"=="" (
	set copy_all_cheats_pack=Y
	goto:skip_verif_cheats_profile
)
call TOOLS\Storage\functions\strlen.bat nb "%cheats_profile%"
set i=0
:check_chars_cheats_profile
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!cheats_profile:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_cheats_profile
		)
	)
	IF "!check_chars!"=="0" (
		set copy_all_cheats_pack=Y
		goto:skip_verif_cheats_profile
	)
)
IF %cheats_profile% GTR %temp_count% (
	set copy_all_cheats_pack=Y
		goto:skip_verif_cheats_profile
)
IF "%cheats_profile%"=="0" (
	call tools\Storage\cheats_profiles_management.bat
	goto:define_select_cheats_profile
)
TOOLS\gnuwin32\bin\sed.exe -n %cheats_profile%p <templogs\profiles_list.txt > templogs\tempvar.txt
set /p cheats_profile_path=<templogs\tempvar.txt
set cheats_profile_name=%cheats_profile_path:~0,-4%
set cheats_profile_path=tools\sd_switch\cheats\profiles\%cheats_profile_path%
:skip_verif_cheats_profile
del /q templogs\profiles_list.txt >nul

:define_del_files_dest_copy
set del_files_dest_copy=
IF /i NOT "%format_choice%"=="o" (
	echo.
	echo Suppression de données de la SD:
	echo 1: Remettre les données de tous les CFWs à zéro sur la SD ^(supprimera les thèmes, configurations personnels, mods de jeux car les dossiers "titles" seront remis à zéro... donc bien sauvegarder vos données personnelles si vous souhaitez les concerver^)?
	echo 2: Supprimer toutes les données de la SD?
	echo 0: Copier normalement les fichiers sans supprimer de données de la SD?
	echo.
	set /p del_files_dest_copy=Faites votre choix: 
) else (
	set del_files_dest_copy=0
)
IF "%del_files_dest_copy%"=="1" goto:confirm_settings
IF "%del_files_dest_copy%"=="2" goto:confirm_settings
IF "%del_files_dest_copy%"=="0" goto:confirm_settings
echo Choix inexistant.
goto:define_del_files_dest_copy

:confirm_settings
call tools\Storage\prepare_sd_switch_infos.bat
set confirm_copy=
	set /p confirm_copy=Souhaitez-vous confirmer ceci? (O/n^): 
IF NOT "%confirm_copy%"=="" set confirm_copy=%confirm_copy:~0,1%
IF /i "%confirm_copy%"=="o" (
	goto:endscript
) else IF /i "%confirm_copy%"=="n" (
	echo Opération annulée.
	exit /b 200
) else (
	echo Choix inexistant.
	goto:confirm_settings
)

:modules_profile_choice
:define_modules_select_profile
echo.
echo Sélection du profile pour la copie des modules optionnels du CFW %~1:
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
IF NOT EXIST "tools\sd_switch\modules\profiles\*.ini" (
	goto:modules_no_profile_created
)
cd tools\sd_switch\modules\profiles
for %%p in (*.ini) do (
	set temp_profilename=%%p
	set temp_profilename=!temp_profilename:~0,-4!
	echo !temp_count!: !temp_profilename!
	echo %%p>> ..\..\..\..\templogs\profiles_list.txt
	set /a temp_count+=1
)
cd ..\..\..\..
:modules_no_profile_created
IF EXIST "tools\default_configs\modules_profile_all.ini" (
	echo %temp_count%: Tous les modules.
	set modules_no_default_config=N
) else (
	set /a temp_count-=1
	set modules_no_default_config=Y
)
echo 0: Accéder à la gestion des profiles de modules.
echo Tout autre choix: Ne copier aucun des modules.
echo.
set modules_profile_path=
set modules_profile=
set pass_copy_modules_pack=
set /p modules_profile=Choisissez un profile de modules: 
IF "%modules_profile%"=="" (
	set pass_copy_modules_pack=Y
	goto:skip_verif_modules_profile
)
call TOOLS\Storage\functions\strlen.bat nb "%modules_profile%"
set i=0
:check_chars_modules_profile
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!modules_profile:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_modules_profile
		)
	)
	IF "!check_chars!"=="0" (
		set pass_copy_modules_pack=Y
		goto:skip_verif_modules_profile
	)
)
IF %modules_profile% GTR %temp_count% (
	set pass_copy_modules_pack=Y
		goto:skip_verif_modules_profile
)
IF "%modules_profile%"=="0" (
	call tools\Storage\modules_profiles_management.bat
	goto:define_modules_select_profile
)
IF %modules_profile% EQU %temp_count% (
	IF NOT "%modules_no_default_config%"=="Y" (
		set modules_profile_path=tools\default_configs\modules_profile_all.ini
		goto:skip_verif_modules_profile
	)
)
TOOLS\gnuwin32\bin\sed.exe -n %modules_profile%p <templogs\profiles_list.txt > templogs\tempvar.txt
set /p modules_profile_path=<templogs\tempvar.txt
set modules_profile_path=tools\sd_switch\modules\profiles\%modules_profile_path%
:skip_verif_modules_profile
del /q templogs\profiles_list.txt >nul 2>&1
IF "%~1"=="atmosphere" (
	set atmosphere_modules_profile_path=%modules_profile_path%
	set atmosphere_pass_copy_modules_pack=%pass_copy_modules_pack%
)
IF "%~1"=="reinx" (
	set reinx_modules_profile_path=%modules_profile_path%
	set reinx_pass_copy_modules_pack=%pass_copy_modules_pack%
)
IF "%~1"=="sxos" (
	set sxos_modules_profile_path=%modules_profile_path%
	set sxos_pass_copy_modules_pack=%pass_copy_modules_pack%
)
exit /b

:endscript