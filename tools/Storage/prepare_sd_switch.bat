::Script by Shadow256
Setlocal enabledelayedexpansion
@echo off
chcp 65001 >nul
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
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
echo Ce script va vous permettre de préparer une carte SD pour le hack Switch en y installant les outils importants.
echo Pendant le script, les droits administrateur seront peut-être demandé.
echo.
echo ATTENTION: Si vous décidez de formater votre carte SD, toutes les données de celle-ci seront perdues. Sauvegardez les données importante avant de formater.
echo ATTENTION: Choisissez bien la lettre du volume qui correspond à votre carte SD car aucune vérification ne pourra être faites à ce niveau là.
echo.
echo Je ne pourrais être tenu pour responsable de quelque domage que se soit lié à l'utilisation de ce script ou des outils qu'il contient.
echo.
echo.
pause
:define_volume_letter
%windir%\system32\wscript //Nologo //B TOOLS\Storage\functions\list_volumes.vbs
TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\volumes_list.txt >templogs\count.txt
set /p tempcount=<templogs\count.txt
del /q templogs\count.txt
IF "%tempcount%"=="0" (
	echo Aucun disque compatible trouvé. Veuillez insérer votre carte SD puis relancez le script.
	echo Le script va maintenant s'arrêté.
	goto:endscript
)
echo.
echo Liste des disques:
:list_volumes
IF "%tempcount%"=="0" goto:set_volume_letter
TOOLS\gnuwin32\bin\tail.exe -%tempcount% <templogs\volumes_list.txt | TOOLS\gnuwin32\bin\head.exe -1
set /a tempcount-=1
goto:list_volumes
:set_volume_letter
echo.
echo.
set volume_letter=
set /p volume_letter=Entrez la lettre du volume de la SD que vous souhaitez utiliser ou entrez "0" pour quitter le script:
call TOOLS\Storage\functions\strlen.bat nb "%volume_letter%"
IF %nb% EQU 0 (
	echo La lettre de lecteur ne peut être vide. Réessayez.
	goto:define_volume_letter
)
set volume_letter=%volume_letter:~0,1%
IF "%volume_letter%"=="0" goto:endscript2
set nb=1
CALL TOOLS\Storage\functions\CONV_VAR_to_MAJ.bat volume_letter
set i=0
:check_chars_volume_letter
IF %i% LSS %nb% (
	set check_chars_volume_letter=0
	FOR %%z in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
		IF "!volume_letter:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_volume_letter=1
			goto:check_chars_volume_letter
		)
	)
	IF "!check_chars_volume_letter!"=="0" (
		echo Un caractère non autorisé a été saisie dans la lettre du lecteur. Recommencez.
		set volume_letter=
		goto:define_volume_letter
	)
)
IF NOT EXIST "%volume_letter%:\" (
	echo Ce volume n'existe pas. Recommencez.
	set volume_letter=
	goto:define_volume_letter
)
TOOLS\gnuwin32\bin\grep.exe "Lettre volume=%volume_letter%" <templogs\volumes_list.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 1 | TOOLS\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
set /p temp_volume_letter=<templogs\tempvar.txt
IF NOT "%volume_letter%"=="%temp_volume_letter%" (
	echo Cette lettre de volume n'est pas dans la liste. Recommencez.
	goto:define_volume_letter
)
set /p format_choice=Souhaitez-vous formaté la SD (volume "%volume_letter%")? (O/n):
IF NOT "%format_choice%"=="" set format_choice=%format_choice:~0,1%
IF /i "%format_choice%"=="o" (
	echo.
	echo Quel type de formatage souhaitez-vous effectuer:
	echo 1: EXFAT (la Switch doit avoir le support pour ce format d'installé^)?
	echo 2: FAT32 (limité au fichier de moins de 4 GO^)?
	echo Tout autre choix: Annule le formatage.
	echo.
	set /p format_type=Choisissez le type de formatage à effectuer:
) else (
	goto:copy_to_sd
)
IF "%format_type%"=="1" goto:format_exfat
IF "%format_type%"=="2" goto:format_fat32
set format_choice=
goto:copy_to_sd
:format_exfat
echo Formatage en cours...
echo.
chcp 850 >nul
format %volume_letter%: /X /Q /FS:EXFAT
IF %errorlevel% NEQ 0 (
	chcp 65001 >nul
	echo Un problème s'est produit pendant la tentative de formatage, le script va maintenant s'arrêter.
	goto:endscript
) else (
chcp 65001 >nul
	echo Formatage effectué avec succès.
	echo.
	goto:copy_to_sd
)
:format_fat32
echo Formatage en cours...
echo.
TOOLS\fat32format\fat32format.exe -q -c128 %volume_letter%
echo.
IF "%ERRORLEVEL%"=="5" (
	echo La demande d'élévation n'a pas été acceptée, le formatage est annulé.
	::echo.
	goto:copy_to_sd
)
IF "%ERRORLEVEL%"=="32" (
	echo Le formatage n'a pas été effectué.
	echo Essayez d'éjecter proprement votre clé USB, réinsérez-là et relancez immédiatement ce script.
	echo Vous pouvez également essayer de fermer toutes les fenêtres de l'explorateur Windows avant le formatage, parfois cela règle le bug.
	echo.
	echo Le script va maintenant s'arrêter.
	goto:endscript
)
IF "%ERRORLEVEL%"=="2" (
	echo Le volume à formater n'existe pas. Vous avez peut-être débranché ou éjecté la carte SD durant ce script.
	echo.
	echo Le script va maintenant s'arrêter.
	goto:endscript
)
IF NOT "%ERRORLEVEL%"=="1" (
	IF NOT "%ERRORLEVEL%"=="0" (
		echo Une erreur inconue s'est produite pendant le formatage.
		echo.
		echo Le script va maintenant s'arrêter.
		goto:endscript
	)
)
IF "%ERRORLEVEL%"=="1" (
	echo Le formatage a été annulé par l'utilisateur.
)
IF "%ERRORLEVEL%"=="0" (
	echo Formatage effectué avec succès.
)
:copy_to_sd
:define_general_select_profile
echo.
echo Sélection du profile général:
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
IF NOT EXIST "tools\sd_switch\profiles\*.bat" (
	goto:general_no_profile_created
)
cd tools\sd_switch\profiles
for %%p in (*.bat) do (
	set temp_profilename=%%p
	set temp_profilename=!temp_profilename:~0,-4!
	echo !temp_count!: !temp_profilename!
	echo %%p>> ..\..\..\templogs\profiles_list.txt
	set /a temp_count+=1
)
cd ..\..\..
:general_no_profile_created
IF EXIST "tools\default_configs\general_profile_all.bat" (
	echo %temp_count%: Profile recommandé, ne contient pas le patch NOGC et met juste à jour les fichiers existant de la SD donc ce profile n'est pas toujours adapté.
) else (
	set /a temp_count-=1
	set general_no_default_config=Y
)
echo 0: Accéder à la gestion des profiles généraux.
echo E: Terminer le script sans préparer la SD.
echo Tout autre choix: Préparer la SD manuellement.
echo.
set general_profile_path=
set general_profile=
set /p general_profile=Choisissez un profile: 
IF /i "%general_profile%"=="e" goto:endscript2
IF "%general_profile%"=="" (
	set pass_copy_general_pack=Y
	goto:skip_verif_general_profile
)
call TOOLS\Storage\functions\strlen.bat nb "%general_profile%"
set i=0
:check_chars_general_profile
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!general_profile:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_general_profile
		)
	)
	IF "!check_chars!"=="0" (
		set pass_copy_general_pack=Y
		goto:skip_verif_general_profile
	)
)
IF %general_profile% GTR %temp_count% (
	set pass_copy_general_pack=Y
		goto:skip_verif_general_profile
)
IF "%general_profile%"=="0" (
	call tools\Storage\prepare_sd_switch_profiles_management.bat
	goto:define_general_select_profile
)
IF %general_profile% EQU %temp_count% (
	IF NOT "%general_no_default_config%"=="Y" (
		set pass_prepare_general_pack=Y
		set general_profile_path=tools\default_configs\general_profile_all.bat
		goto:skip_verif_general_profile
	)
)
TOOLS\gnuwin32\bin\sed.exe -n %general_profile%p <templogs\profiles_list.txt > templogs\tempvar.txt
set /p general_profile_path=<templogs\tempvar.txt
set general_profile_path=tools\sd_switch\profiles\%general_profile_path%
set pass_prepare_general_pack=Y
:skip_verif_general_profile
del /q templogs\profiles_list.txt >nul 2>&1
IF NOT "%pass_prepare_general_pack%"=="Y" (
	call tools\Storage\prepare_sd_switch_files_questions.bat
	goto:test_copy_launch
) else (
	IF EXIST "%general_profile_path%" (
		call "%general_profile_path%"
	)
)
IF /i "%copy_atmosphere_pack%"=="o" (
	IF NOT "%atmosphere_pass_copy_modules_pack%"=="Y" (
		IF NOT EXIST "%atmosphere_modules_profile_path%" (
			set errorlevel=404
		)
	)
)
IF /i "%copy_reinx_pack%"=="o" (
	IF NOT "%reinx_pass_copy_modules_pack%"=="Y" (
		IF NOT EXIST "%reinx_modules_profile_path%" (
			set errorlevel=404
		)
	)
)
IF /i "%copy_emu%"=="o" (
	IF NOT "%pass_copy_emu_pack%"=="Y" (
		IF NOT EXIST "%emu_profile_path%" (
			set errorlevel=404
		)
	)
)
IF "%copy_cheats%"=="Y" (
	IF NOT EXIST "%cheats_profile_path%" (
		set errorlevel=404
	)
)
IF NOT "%pass_copy_mixed_pack%"=="Y" (
	IF NOT EXIST "%mixed_profile_path%" (
			set errorlevel=404
	)
)
:confirm_settings
call tools\Storage\prepare_sd_switch_infos.bat
set confirm_copy=
	set /p confirm_copy=Souhaitez-vous confirmer ceci? (O/n^): 
IF NOT "%confirm_copy%"=="" set confirm_copy=%confirm_copy:~0,1%
IF /i "%confirm_copy%"=="o" (
	set errorlevel=200
	goto:test_copy_launch
) else IF /i "%confirm_copy%"=="n" (
	echo Opération annulée.
	goto:endscript
) else (
	echo Choix inexistant.
	goto:confirm_settings
)
:test_copy_launch
IF %errorlevel% EQU 200 (
	goto:begin_copy
) else IF %errorlevel% EQU 400 (
	goto:endscript
) else (
	echo Préparation de la SD annulée car une erreur inconnue est survenue, vérifiez que vous n'avez pas supprimer de profiles utilisés dans ce profile général.
	echo Si le problème persiste, veuillez refaire ce profile.
	goto:endscript
)

:begin_copy
echo Copie en cours...

IF /i "%del_files_dest_copy%"=="1" (
	call :delete_cfw_files
	set del_files_dest_copy=0
) else IF /i "%del_files_dest_copy%"=="2" (
	rmdir /s /q "%volume_letter%:\" >nul 2>&1
	set del_files_dest_copy=0
)

call :copy_mixed_pack
call :copy_emu_pack

IF /i "%copy_atmosphere_pack%"=="o" (
	IF EXIST "%volume_letter%:\atmosphere\kip_patches\fs_patches" rmdir /s /q "%volume_letter%:\atmosphere\kip_patches\fs_patches" >nul
	IF EXIST "%volume_letter%:\atmosphere\exefs_patches" rmdir /s /q "%volume_letter%:\atmosphere\exefs_patches" >nul
	%windir%\System32\Robocopy.exe TOOLS\sd_switch\atmosphere %volume_letter%:\ /e >nul
	IF /i "%copy_payloads%"=="o" (
		copy /V /B TOOLS\sd_switch\payloads\Atmosphere_fusee-primary.bin %volume_letter%:\Atmosphere_fusee-primary.bin >nul
		copy /V /B TOOLS\sd_switch\payloads\Hekate.bin %volume_letter%:\Hekate.bin >nul
	)
	copy /V /B TOOLS\sd_switch\payloads\Hekate.bin %volume_letter%:\bootloader\payloads\Hekate.bin >nul
	copy /V /B TOOLS\sd_switch\payloads\Hekate.bin %volume_letter%:\bootloader\update.bin >nul
	IF EXIST "%volume_letter%:\switch\GagOrder.nro" del /q "%volume_letter%:\switch\GagOrder.nro" >nul
	IF EXIST "%volume_letter%:\atmosphere\exefs_patches\Signature_Patches_by_br4z0rf_and_Jakibaki" rmdir /s /q "%volume_letter%:\atmosphere\exefs_patches\Signature_Patches_by_br4z0rf_and_Jakibaki" >nul
	IF EXIST "%volume_letter%:\switch\appstore\res" rmdir /s /q "%volume_letter%:\switch\appstore\res" >nul
	IF EXIST "%volume_letter%:\BCT.ini" del /q "%volume_letter%:\BCT.ini" >nul
	IF EXIST "%volume_letter%:\fusee-secondary.bin" del /q "%volume_letter%:\fusee-secondary.bin" >nul
	IF EXIST "%volume_letter%:\bootlogo.bmp" del /q "%volume_letter%:\bootlogo.bmp" >nul
	IF EXIST "%volume_letter%:\hekate_ipl.ini" del /q "%volume_letter%:\hekate_ipl.ini" >nul
	IF EXIST "%volume_letter%:\switch\CFWSettings" rmdir /s /q "%volume_letter%:\switch\CFWSettings" >nul
	IF EXIST "%volume_letter%:\switch\CFW-Settings" rmdir /s /q "%volume_letter%:\switch\CFW-Settings" >nul
	IF EXIST "%volume_letter%:\modules\atmosphere\fs_mitm.kip" del /q "%volume_letter%:\modules\atmosphere\fs_mitm.kip" >nul
	IF EXIST "%volume_letter%:\atmosphere\titles\010000000000100D" rmdir /s /q "%volume_letter%:\atmosphere\titles\010000000000100D" >nul
	IF /i "%atmosphere_enable_nogc_patch%"=="O" (
		%windir%\System32\Robocopy.exe TOOLS\sd_switch\atmosphere_patches_nogc %volume_letter%:\ /e >nul
	)
	IF /i "%atmosphere_enable_cheats%"=="o" (
		IF "%copy_all_cheats_pack%"=="Y" (
			%windir%\System32\Robocopy.exe TOOLS\sd_switch\cheats\titles %volume_letter%:\atmosphere\titles /e >nul
		) else (
			call :copy_cheats_profile "atmosphere"
		)
		%windir%\System32\Robocopy.exe TOOLS\sd_switch\mixed\modular\EdiZon %volume_letter%:\ /e >nul
	)
	copy /V /B TOOLS\sd_switch\payloads\Hekate.bin %volume_letter%:\atmosphere\reboot_payload.bin >nul
	copy /V /B TOOLS\sd_switch\payloads\Hekate.bin %volume_letter%:\RR\payloads\Hekate.bin >nul
	copy /V /B TOOLS\sd_switch\payloads\Atmosphere_fusee-primary.bin %volume_letter%:\RR\payloads\Atmosphere.bin >nul
	copy /V /B TOOLS\sd_switch\payloads\Lockpick_RCM.bin %volume_letter%:\bootloader\payloads\Lockpick_RCM.bin >nul
	copy /V /B TOOLS\sd_switch\payloads\Retro_reloaded.bin %volume_letter%:\bootloader\payloads\Retro_reloaded.bin >nul
	del /Q /S "%volume_letter%:\atmosphere\.emptydir" >nul
	del /Q /S "%volume_letter%:\bootloader\.emptydir" >nul
	copy nul %volume_letter%:\atmosphere\prodinfo.ini >nul
	echo [config]>>%volume_letter%:\atmosphere\prodinfo.ini
	IF /i NOT "%atmosphere_enable_prodinfo_write%"=="o" (
		echo allow_write=^0>>%volume_letter%:\atmosphere\prodinfo.ini
	) else (
		echo allow_write=^1>>%volume_letter%:\atmosphere\prodinfo.ini
	)
	IF /i "%atmosphere_manual_config%"=="o" (
		call :copy_atmosphere_configuration
	)
	call :copy_modules_pack "atmosphere"
)

IF /i "%copy_reinx_pack%"=="o" (
	%windir%\System32\Robocopy.exe TOOLS\sd_switch\reinx %volume_letter%:\ /e >nul
	IF /i NOT "%reinx_enable_nogc_patch%"=="o" del /q %volume_letter%:\ReiNX\nogc >nul
	copy /V /B TOOLS\sd_switch\payloads\ReiNX.bin %volume_letter%:\ReiNX.bin >nul
	IF /i "%copy_atmosphere_pack%"=="o" copy /V /B TOOLS\sd_switch\payloads\ReiNX.bin %volume_letter%:\bootloader\payloads\ReiNX.bin >nul
	IF EXIST "%volume_letter%:\switch\GagOrder.nro" del /q "%volume_letter%:\switch\GagOrder.nro" >nul
	IF EXIST "%volume_letter%:\switch\appstore\res" rmdir /s /q "%volume_letter%:\switch\appstore\res" >nul
	::IF EXIST "%volume_letter%:\ReiNX\titles\010000000000100D" rmdir /s /q "%volume_letter%:\ReiNX\titles\010000000000100D" >nul
	IF EXIST "%volume_letter%:\ReiNX\hbl.nsp" del /q "%volume_letter%:\ReiNX\hbl.nsp" >nul
	IF EXIST "%volume_letter%:\ReiNX\titles\010000000000100D\exefs.nsp" del /q "%volume_letter%:\ReiNX\titles\010000000000100D\exefs.nsp" >nul
	copy /V /B TOOLS\sd_switch\payloads\ReiNX.bin %volume_letter%:\ReiNX\reboot_payload.bin >nul
	copy /V /B TOOLS\sd_switch\payloads\ReiNX.bin %volume_letter%:\RR\payloads\ReiNX.bin >nul
	call :copy_modules_pack "reinx"
)

IF /i "%copy_sxos_pack%"=="o" (
	%windir%\System32\Robocopy.exe TOOLS\sd_switch\sxos %volume_letter%:\ /e >nul
	IF /i "%copy_payloads%"=="o" (
		copy /V /B TOOLS\sd_switch\payloads\SXOS.bin %volume_letter%:\SXOS.bin >nul
		copy /V /B TOOLS\sd_switch\payloads\Retro_reloaded.bin %volume_letter%:\Retro_reloaded.bin >nul
		copy /V /B TOOLS\sd_switch\payloads\Lockpick_RCM.bin %volume_letter%:\Lockpick_RCM.bin >nul
	)
	IF /i "%copy_atmosphere_pack%"=="o" copy /V /B TOOLS\sd_switch\payloads\SXOS.bin %volume_letter%:\bootloader\payloads\SXOS.bin >nul
	IF EXIST "%volume_letter%:\switch\GagOrder.nro" del /q "%volume_letter%:\switch\GagOrder.nro" >nul
	IF EXIST "%volume_letter%:\switch\appstore\res" rmdir /s /q "%volume_letter%:\switch\appstore\res" >nul
	IF /i "%sxos_enable_cheats%"=="o" (
		IF "%copy_all_cheats_pack%"=="Y" (
			%windir%\System32\Robocopy.exe TOOLS\sd_switch\cheats\titles %volume_letter%:\sxos\titles /e >nul
		) else (
			call :copy_cheats_profile "sxos"
		)
	)
	copy /V /B TOOLS\sd_switch\payloads\SXOS.bin %volume_letter%:\RR\payloads\SXOS.bin >nul
	del /Q /S "%volume_letter%:\sxos\.emptydir" >nul
)

IF /i "%copy_memloader%"=="o" (
	%windir%\System32\Robocopy.exe TOOLS\memloader\mount_discs %volume_letter%:\ /e >nul
	IF /i "%copy_sxos_pack%"=="o" copy /V /B TOOLS\sd_switch\payloads\memloader.bin %volume_letter%:\Memloader.bin >nul
	IF /i "%copy_atmosphere_pack%"=="o" copy /V /B TOOLS\sd_switch\payloads\memloader.bin %volume_letter%:\bootloader\payloads\Memloader.bin >nul
	copy /V /B TOOLS\sd_switch\payloads\memloader.bin %volume_letter%:\RR\payloads\memloader.bin >nul
)

del /Q /S "%volume_letter%:\switch\.emptydir" >nul
del /Q /S "%volume_letter%:\Backup\.emptydir" >nul
del /Q /S "%volume_letter%:\pk1decryptor\.emptydir" >nul
del /Q /S "%volume_letter%:\rr\payloads\.emptydir" >nul 2>&1
IF EXIST "%volume_letter%:\tinfoil\" del /Q /S "%volume_letter%:\tinfoil\.emptydir" >nul 2>&1
echo Copie terminée.
goto:endscript

:copy_modules_pack
IF "%~1"=="atmosphere" (
	IF "%atmosphere_pass_copy_modules_pack%"=="Y" goto:skip_copy_modules_pack
	set temp_modules_copy_path=%volume_letter%:\atmosphere
	set temp_modules_profile_path=%atmosphere_modules_profile_path%
)
IF "%~1"=="reinx" (
	IF "%reinx_pass_copy_modules_pack%"=="Y" goto:skip_copy_modules_pack
	set temp_modules_copy_path=%volume_letter%:\ReiNX
	set temp_modules_profile_path=%reinx_modules_profile_path%
)
IF "%~1"=="sxos" (
	IF "%sxos_pass_copy_modules_pack%"=="Y" goto:skip_copy_modules_pack
	set temp_modules_copy_path=%volume_letter%:\sxos
	set temp_modules_profile_path=%sxos_modules_profile_path%
)
tools\gnuwin32\bin\grep.exe -c "" <"%temp_modules_profile_path%" > templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
for /l %%i in (1,1,%temp_count%) do (
	TOOLS\gnuwin32\bin\sed.exe -n %%ip <"%temp_modules_profile_path%" >templogs\tempvar.txt
	set /p temp_module=<templogs\tempvar.txt
	%windir%\System32\Robocopy.exe tools\sd_switch\modules\pack\!temp_module!\titles %temp_modules_copy_path%\titles /e >nul
	%windir%\System32\Robocopy.exe tools\sd_switch\modules\pack\!temp_module!\others %volume_letter%:\ /e >nul
)
:skip_copy_modules_pack
exit /b

:copy_mixed_pack
rmdir /s /q %volume_letter%:\RR >nul 2>&1
%windir%\System32\Robocopy.exe tools\sd_switch\mixed\base %volume_letter%:\ /e >nul
IF "%pass_copy_mixed_pack%"=="Y" goto:skip_copy_mixed_pack
tools\gnuwin32\bin\grep.exe -c "" <"%mixed_profile_path%" > templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
for /l %%i in (1,1,%temp_count%) do (
	TOOLS\gnuwin32\bin\sed.exe -n %%ip <"%mixed_profile_path%" >templogs\tempvar.txt
	set /p temp_homebrew=<templogs\tempvar.txt
	%windir%\System32\Robocopy.exe tools\sd_switch\mixed\modular\!temp_homebrew! %volume_letter%:\ /e >nul
	IF "!temp_homebrew!"=="Payload_Launcher" (
		copy /V /B TOOLS\sd_switch\payloads\Lockpick_RCM.bin %volume_letter%:\payloads\Lockpick_RCM.bin >nul
		copy /V /B TOOLS\sd_switch\payloads\Retro_reloaded.bin %volume_letter%:\payloads\Retro_reloaded.bin >nul
		IF /i "%copy_atmosphere_pack%"=="o" (
			copy /V /B TOOLS\sd_switch\payloads\Atmosphere_fusee-primary.bin %volume_letter%:\payloads\Atmosphere_fusee-primary.bin >nul
			copy /V /B TOOLS\sd_switch\payloads\Hekate.bin %volume_letter%:\payloads\Hekate.bin >nul
		)
		IF /i "%copy_reinx_pack%"=="o" copy /V /B TOOLS\sd_switch\payloads\ReiNX.bin %volume_letter%:\payloads\ReiNX.bin >nul
		IF /i "%copy_sxos_pack%"=="o" copy /V /B TOOLS\sd_switch\payloads\SXOS.bin %volume_letter%:\payloads\SXOS.bin >nul
		IF /i "%copy_memloader%"=="o" copy /V /B TOOLS\sd_switch\payloads\memloader.bin %volume_letter%:\payloads\memloader.bin >nul
	)
)
:skip_copy_mixed_pack
exit /b

:copy_emu_pack
IF /i NOT "%copy_emu%"=="o" (
	goto:skip_copy_emu_pack
) else (
	IF "%pass_copy_emu_pack%"=="Y" goto:skip_copy_emu_pack
	IF EXIST "%volume_letter%:\switch\pfba\skin\config.cfg" move "%volume_letter%:\switch\pfba\skin\config.cfg" "%volume_letter%:\switch\pfba\skin\config.cfg.bak" >nul
	IF EXIST "%volume_letter%:\switch\pnes\skin\config.cfg" move "%volume_letter%:\switch\pnes\skin\config.cfg" "%volume_letter%:\switch\pnes\skin\config.cfg.bak" >nul
	IF EXIST "%volume_letter%:\switch\psnes\skin\config.cfg" move "%volume_letter%:\switch\psnes\skin\config.cfg" "%volume_letter%:\switch\psnes\skin\config.cfg.bak" >nul
			tools\gnuwin32\bin\grep.exe -c "" <"%general_profile_path%" > templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
	for /l %%i in (1,1,%temp_count%) do (
		TOOLS\gnuwin32\bin\sed.exe -n %%ip <"%general_profile_path%" >templogs\tempvar.txt
		set /p temp_emulator=<templogs\tempvar.txt
		%windir%\System32\Robocopy.exe tools\sd_switch\emulators\pack\!temp_emulator! %volume_letter%:\ /e >nul
	)
	IF /i "%keep_emu_configs%"=="o" (
		del /q "%volume_letter%:\switch\pfba\skin\config.cfg" >nul
		move "%volume_letter%:\switch\pfba\skin\config.cfg.bak" "%volume_letter%:\switch\pfba\skin\config.cfg" >nul
		del /q "%volume_letter%:\switch\pnes\skin\config.cfg" >nul
		move "%volume_letter%:\switch\pnes\skin\config.cfg.bak" "%volume_letter%:\switch\pnes\skin\config.cfg" >nul
		del /q "%volume_letter%:\switch\psnes\skin\config.cfg" >nul
		move "%volume_letter%:\switch\psnes\skin\config.cfg.bak" "%volume_letter%:\switch\psnes\skin\config.cfg" >nul
	) else (
		IF EXIST "%volume_letter%:\switch\pfba\skin\config.cfg.bak" del /q "%volume_letter%:\switch\pfba\skin\config.cfg.bak"
		IF EXIST "%volume_letter%:\switch\pnes\skin\config.cfg.bak" del /q "%volume_letter%:\switch\pnes\skin\config.cfg.bak"
		IF EXIST "%volume_letter%:\switch\psnes\skin\config.cfg.bak" del /q "%volume_letter%:\switch\psnes\skin\config.cfg.bak"
	)
)
:skip_copy_emu_pack
exit /b

:copy_cheats_profile
IF "%~1"=="atmosphere" set temp_cheats_copy_path=%volume_letter%:\atmosphere\titles
IF "%~1"=="sxos" set temp_cheats_copy_path=%volume_letter%:\sxos\titles
tools\gnuwin32\bin\grep.exe -c "" <"%cheats_profile_path%" > templogs\tempvar.txt
set /p temp_count=<templogs\tempvar.txt
for /l %%i in (1,1,%temp_count%) do (
	TOOLS\gnuwin32\bin\sed.exe -n %%ip <"%cheats_profile_path%" >templogs\tempvar.txt
	set /p temp_cheat=<templogs\tempvar.txt
	IF NOT EXIST "%temp_cheats_copy_path%\!temp_cheat!" mkdir "%temp_cheats_copy_path%\!temp_cheat!"
	%windir%\System32\Robocopy.exe tools\sd_switch\cheats\titles\!temp_cheat! %temp_cheats_copy_path%\!temp_cheat! /e >nul
)
exit /b

:delete_cfw_files
IF EXIST "%volume_letter%:\atmosphere" rmdir /s /q "%volume_letter%:\atmosphere"
IF EXIST "%volume_letter%:\bootloader" rmdir /s /q "%volume_letter%:\bootloader"
IF EXIST "%volume_letter%:\config" rmdir /s /q "%volume_letter%:\config"
IF EXIST "%volume_letter%:\ftpd" rmdir /s /q "%volume_letter%:\ftpd"
IF EXIST "%volume_letter%:\modules" rmdir /s /q "%volume_letter%:\modules"
IF EXIST "%volume_letter%:\ReiNX" rmdir /s /q "%volume_letter%:\ReiNX"
IF EXIST "%volume_letter%:\sept" rmdir /s /q "%volume_letter%:\sept"
IF EXIST "%volume_letter%:\SlideNX" rmdir /s /q "%volume_letter%:\SlideNX"
IF EXIST "%volume_letter%:\sxos\titles" rmdir /s /q "%volume_letter%:\sxos\titles"
IF EXIST "%volume_letter%:\boot.dat" del /q "%volume_letter%:\boot.dat"
IF EXIST "%volume_letter%:\hbmenu.nro" del /q "%volume_letter%:\hbmenu.nro"
IF EXIST "%volume_letter%:\xor.play.json" del /q "%volume_letter%:\xor.play.json"
IF EXIST "%volume_letter%:\switch\Kip_Select" rmdir /s /q "%volume_letter%:\switch\Kip_Select"
IF EXIST "%volume_letter%:\switch\Kosmos-Toolbox" rmdir /s /q "%volume_letter%:\switch\Kosmos-Toolbox"
IF EXIST "%volume_letter%:\switch\KosmosUpdater" rmdir /s /q "%volume_letter%:\switch\KosmosUpdater"
IF EXIST "%volume_letter%:\switch\ldnmitm_config" rmdir /s /q "%volume_letter%:\switch\ldnmitm_config"
IF EXIST "%volume_letter%:\switch\ReiNXToolkit" rmdir /s /q "%volume_letter%:\switch\ReiNXToolkit"
IF EXIST "%volume_letter%:\switch\ROMMENU" rmdir /s /q "%volume_letter%:\switch\ROMMENU"
IF EXIST "%volume_letter%:\switch\reboot_to_payload" rmdir /s /q "%volume_letter%:\switch\reboot_to_payload"
IF EXIST "%volume_letter%:\switch\sx_installer" rmdir /s /q "%volume_letter%:\switch\sx_installer"
IF EXIST "%volume_letter%:\switch\SXDUMPER" rmdir /s /q "%volume_letter%:\switch\SXDUMPER"
exit /b

:copy_atmosphere_configuration
Setlocal disabledelayedexpansion
IF /i "%atmo_upload_enabled%"=="o" (
	set atmo_upload_enabled=0x1
) else (
	set atmo_upload_enabled=0x0
)
IF /i "%atmo_usb30_force_enabled%"=="o" (
	set atmo_usb30_force_enabled=0x1
) else (
	set atmo_usb30_force_enabled=0x0
)
IF /i "%atmo_ease_nro_restriction%"=="o" (
	set atmo_ease_nro_restriction=0x1
) else (
	set atmo_ease_nro_restriction=0x0
)
IF /i "%atmo_dmnt_cheats_enabled_by_default%"=="o" (
	set atmo_dmnt_cheats_enabled_by_default=0x1
) else (
	set atmo_dmnt_cheats_enabled_by_default=0x0
)
IF /i "%atmo_dmnt_always_save_cheat_toggles%"=="o" (
	set atmo_dmnt_always_save_cheat_toggles=0x1
) else (
	set atmo_dmnt_always_save_cheat_toggles=0x0
)
IF /i "%atmo_fsmitm_redirect_saves_to_sd%"=="o" (
	set atmo_fsmitm_redirect_saves_to_sd=0x1
) else (
	set atmo_fsmitm_redirect_saves_to_sd=0x0
)
set atmo_fatal_auto_reboot_interval=0x%atmo_fatal_auto_reboot_interval%
IF "%atmo_power_menu_reboot_function%"=="1" (
set atmo_power_menu_reboot_function=payload
) else IF "%atmo_power_menu_reboot_function%"=="2" (
set atmo_power_menu_reboot_function=rcm
) else IF "%atmo_power_menu_reboot_function%"=="3" (
set atmo_power_menu_reboot_function=normal
)
IF "%inverted_atmo_hbl_override_key%"=="Y" set atmo_hbl_override_key=!%atmo_hbl_override_key%
IF "%inverted_atmo_cheats_override_key%"=="Y" set atmo_cheats_override_key=!%atmo_cheats_override_key%
IF "%inverted_atmo_layeredfs_override_key%"=="Y" set atmo_layeredfs_override_key=!%atmo_layeredfs_override_key%
echo ; Disable uploading error reports to Nintendo>%volume_letter%:\atmosphere\system_settings.ini
echo [eupld]>>%volume_letter%:\atmosphere\system_settings.ini
echo upload_enabled = u8!%atmo_upload_enabled%>>%volume_letter%:\atmosphere\system_settings.ini
echo ; Enable USB 3.0 superspeed for homebrew>>%volume_letter%:\atmosphere\system_settings.ini
echo [usb]>>%volume_letter%:\atmosphere\system_settings.ini
echo usb30_force_enabled = u8!%atmo_usb30_force_enabled%>>%volume_letter%:\atmosphere\system_settings.ini
echo ; Control whether RO should ease its validation of NROs.>>%volume_letter%:\atmosphere\system_settings.ini
echo ; (note: this is normally not necessary, and ips patches can be used.)>>%volume_letter%:\atmosphere\system_settings.ini
echo [ro]>>%volume_letter%:\atmosphere\system_settings.ini
echo ease_nro_restriction = u8!%atmo_ease_nro_restriction%>>%volume_letter%:\atmosphere\system_settings.ini
echo ; Atmosphere custom settings>>%volume_letter%:\atmosphere\system_settings.ini
echo [atmosphere]>>%volume_letter%:\atmosphere\system_settings.ini
echo ; Reboot from fatal automatically after some number of milliseconds.>>%volume_letter%:\atmosphere\system_settings.ini
echo ; If field is not present or 0, fatal will wait indefinitely for user input.>>%volume_letter%:\atmosphere\system_settings.ini
echo fatal_auto_reboot_interval = u64!%atmo_fatal_auto_reboot_interval%>>%volume_letter%:\atmosphere\system_settings.ini
echo ; Make the power menu's "reboot" button reboot to payload.>>%volume_letter%:\atmosphere\system_settings.ini
echo ; Set to "payload" to reboot to "/atmosphere\reboot_to_payload.bin" payload, "normal" for normal reboot, "rcm" for rcm reboot.>>%volume_letter%:\atmosphere\system_settings.ini
echo power_menu_reboot_function = str!%atmo_power_menu_reboot_function%>>%volume_letter%:\atmosphere\system_settings.ini
echo ; Controls whether dmnt cheats should be toggled on or off by >>%volume_letter%:\atmosphere\system_settings.ini
echo ; default. 1 = toggled on by default, 0 = toggled off by default.>>%volume_letter%:\atmosphere\system_settings.ini
echo dmnt_cheats_enabled_by_default = u8!%atmo_dmnt_cheats_enabled_by_default%>>%volume_letter%:\atmosphere\system_settings.ini
echo ; Controls whether dmnt should always save cheat toggle state>>%volume_letter%:\atmosphere\system_settings.ini
echo ; for restoration on new game launch. 1 = always save toggles,>>%volume_letter%:\atmosphere\system_settings.ini
echo ; 0 = only save toggles if toggle file exists.>>%volume_letter%:\atmosphere\system_settings.ini
echo dmnt_always_save_cheat_toggles = u8!%atmo_dmnt_always_save_cheat_toggles%>>%volume_letter%:\atmosphere\system_settings.ini
echo ; Controls whether fs.mitm should redirect save files>>%volume_letter%:\atmosphere\system_settings.ini
echo ; to directories on the sd card.>>%volume_letter%:\atmosphere\system_settings.ini
echo ; 0 = Do not redirect, 1 = Redirect.>>%volume_letter%:\atmosphere\system_settings.ini
echo ; NOTE: EXPERIMENTAL>>%volume_letter%:\atmosphere\system_settings.ini
echo ; If you do not know what you are doing, do not touch this yet.>>%volume_letter%:\atmosphere\system_settings.ini
echo fsmitm_redirect_saves_to_sd = u8!%atmo_fsmitm_redirect_saves_to_sd%>>%volume_letter%:\atmosphere\system_settings.ini

echo [hbl_config]>%volume_letter%:\atmosphere\loader.ini
echo title_id=010000000000100D>>%volume_letter%:\atmosphere\loader.ini
echo override_any_app=true>>%volume_letter%:\atmosphere\loader.ini
echo path=atmosphere/hbl.nsp>>%volume_letter%:\atmosphere\loader.ini
echo override_key=%atmo_hbl_override_key%>>%volume_letter%:\atmosphere\loader.ini
echo.>>%volume_letter%:\atmosphere\loader.ini
echo [default_config]>>%volume_letter%:\atmosphere\loader.ini
echo override_key=%atmo_layeredfs_override_key%>>%volume_letter%:\atmosphere\loader.ini
echo cheat_enable_key=%atmo_cheats_override_key%>>%volume_letter%:\atmosphere\loader.ini
endlocal
exit /b

:endscript
pause
:endscript2
rmdir /s /q templogs
endlocal