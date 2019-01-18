::Script by Shadow256
Setlocal enabledelayedexpansion
echo on
chcp 65001 >nul
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
echo Ce script va vous permettre de préparer une carte SD pour le hack Switch en y installant les outils importants. >con
echo Pendant le script, les droits administrateur seront peut-être demandé.
echo.>con
echo ATTENTION: Si vous décidez de formater votre carte SD, toutes les données de celle-ci seront perdues. Sauvegardez les données importante avant de formater.>con
echo ATTENTION: Choisissez bien la lettre du volume qui correspond à votre carte SD car aucune vérification ne pourra être faites à ce niveau là. >con
echo.>con
echo Je ne pourrais être tenu pour responsable de quelque domage que se soit lié à l'utilisation de ce script ou des outils qu'il contient. >con
echo.>con
echo.>con
pause >con
:define_volume_letter
%windir%\system32\wscript //Nologo //B TOOLS\Storage\functions\list_volumes.vbs
TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\volumes_list.txt >templogs\count.txt
set /p tempcount=<templogs\count.txt
del /q templogs\count.txt
IF "%tempcount%"=="0" (
	echo Aucun disque compatible trouvé. Veuillez insérer votre carte SD puis relancez le script. >con
	echo Le script va maintenant s'arrêté. >con
	goto:endscript
)
echo. >con
echo Liste des disques: >con
:list_volumes
IF "%tempcount%"=="0" goto:set_volume_letter
TOOLS\gnuwin32\bin\tail.exe -%tempcount% <templogs\volumes_list.txt | TOOLS\gnuwin32\bin\head.exe -1 >con
set /a tempcount-=1
goto:list_volumes
:set_volume_letter
echo.>con
echo.>con
set volume_letter=
set /p volume_letter=Entrez la lettre du volume de la SD que vous souhaitez utiliser: >con
call TOOLS\Storage\functions\strlen.bat nb "%volume_letter%"
IF %nb% EQU 0 (
	echo La lettre de lecteur ne peut être vide. Réessayez. >con
	goto:define_volume_letter
)
set volume_letter=%volume_letter:~0,1%
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
		echo Un caractère non autorisé a été saisie dans la lettre du lecteur. Recommencez. >con
		set volume_letter=
		goto:define_volume_letter
	)
)
IF NOT EXIST "%volume_letter%:\" (
	echo Ce volume n'existe pas. Recommencez. >con
	set volume_letter=
	goto:define_volume_letter
)
TOOLS\gnuwin32\bin\grep.exe "Lettre volume=%volume_letter%" <templogs\volumes_list.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 1 | TOOLS\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
set /p temp_volume_letter=<templogs\tempvar.txt
IF NOT "%volume_letter%"=="%temp_volume_letter%" (
	echo Cette lettre de volume n'est pas dans la liste. Recommencez. >con
	goto:define_volume_letter
)
set /p format_choice=Souhaitez-vous formaté la SD (volume "%volume_letter%")? (O/n): >con
IF NOT "%format_choice%"=="" set format_choice=%format_choice:~0,1%
IF /i "%format_choice%"=="o" (
	echo.>con
	echo Quel type de formatage souhaitez-vous effectuer: >con
	echo 1: EXFAT (la Switch doit avoir le support pour ce format d'installé^)? >con
	echo 2: FAT32 (limité au fichier de moins de 4 GO^)? >con
	echo Tout autre choix: Annule le formatage.>con
	echo.>con
	set /p format_type=Choisissez le type de formatage à effectuer: >con
) else (
	goto:copy_to_sd
)
IF "%format_type%"=="1" goto:format_exfat
IF "%format_type%"=="2" goto:format_fat32
set format_choice=
goto:copy_to_sd
:format_exfat
echo Formatage en cours... >con
echo.>con
chcp 850 >nul
format %volume_letter%: /X /Q /FS:EXFAT >con
IF %errorlevel% NEQ 0 (
	chcp 65001 >nul
	echo Un problème s'est produit pendant la tentative de formatage, le script va maintenant s'arrêter. >con
	goto:endscript
) else (
chcp 65001 >nul
	echo Formatage effectué avec succès. >con
	echo.>con
	goto:copy_to_sd
)
:format_fat32
echo Formatage en cours... >con
echo.>con
TOOLS\fat32format\fat32format.exe -q -c128 %volume_letter%
echo.>con
IF "%ERRORLEVEL%"=="5" (
	echo La demande d'élévation n'a pas été acceptée, le formatage est annulé. >con
	::echo.>con
	goto:copy_to_sd
)
IF "%ERRORLEVEL%"=="32" (
	echo Le formatage n'a pas été effectué. >con
	echo Essayez d'éjecter proprement votre clé USB, réinsérez-là et relancez immédiatement ce script. >con
	echo Vous pouvez également essayer de fermer toutes les fenêtres de l'explorateur Windows avant le formatage, parfois cela règle le bug. >con
	echo.>con
	echo Le script va maintenant s'arrêter. >con
	goto:endscript
)
IF "%ERRORLEVEL%"=="2" (
	echo Le volume à formater n'existe pas. Vous avez peut-être débranché ou éjecté la carte SD durant ce script.>con
	echo.>con
	echo Le script va maintenant s'arrêter. >con
	goto:endscript
)
IF NOT "%ERRORLEVEL%"=="1" (
	IF NOT "%ERRORLEVEL%"=="0" (
		echo Une erreur inconue s'est produite pendant le formatage. >con
		echo.>con
		echo Le script va maintenant s'arrêter. >con
		goto:endscript
	)
)
IF "%ERRORLEVEL%"=="1" (
	echo Le formatage a été annulé par l'utilisateur. >con
)
IF "%ERRORLEVEL%"=="0" (
	echo Formatage effectué avec succès. >con
)
:copy_to_sd
set /p cancel_copy=Souhaitez-vous annuler la copie des différents fichiers vers votre SD (volume "%volume_letter%")? (O/n): >con
IF NOT "%cancel_copy%"=="" set cancel_copy=%cancel_copy:~0,1%
IF /i "%cancel_copy%"=="o" goto:endscript
set /p launch_manual=Souhaitez-vous lancer la page d'information sur se qui peut être copié (vivement conseillé)? (O/n): >con
IF NOT "%launch_manual%"=="" set launch_manual=%launch_manual:~0,1%
IF /i "%launch_manual%"=="o" (
	start DOC\files\sd_prepare.html
)
IF /i NOT "%format_choice%"=="o" (
	set /p del_files_dest_copy=Souhaitez-vous supprimer tous les répertoires et fichiers de la SD pendant la copie? (O/n^): >con
)
IF NOT "%del_files_dest_copy%"=="" set del_files_dest_copy=%del_files_dest_copy:~0,1%
IF /i "%del_files_dest_copy%"=="o" (
set del_files_dest_copy=
	set /p del_files_dest_copy=Souhaitez-vous réellement supprimer tous les fichiers de la SD? (O/n^): >con
)
IF NOT "%del_files_dest_copy%"=="" set del_files_dest_copy=%del_files_dest_copy:~0,1%

set /p copy_sdfilesswitch_pack=Souhaitez-vous copier le pack pour, entre autres, lancer Atmosphere via Hekate (pack Kosmos, anciennement nommé SDFilesSwitch)? (O/n): >con
IF NOT "%copy_sdfilesswitch_pack%"=="" set copy_sdfilesswitch_pack=%copy_sdfilesswitch_pack:~0,1%

set /p copy_atmosphere_pack=Souhaitez-vous copier le pack pour lancer Atmosphere via le payload Fusee-primary d'Atmosphere (CFW Atmosphere complet)? (O/n): >con
IF NOT "%copy_atmosphere_pack%"=="" set copy_atmosphere_pack=%copy_atmosphere_pack:~0,1%
IF /i "%copy_atmosphere_pack%"=="o" goto:ask_nogc_atmosphere
goto:skip_ask_nogc_atmosphere
	:ask_nogc_atmosphere
	echo.>con
	echo Souhaitez-vous activer le patch NOGC pour Atmosphere  (firmware 4.0.0 et supérieur^)? >con
	echo Ce patch est utile pour ceux ayant mis à jour avec la méthode ChoiDuJour à partir du firmware 3.0.2 et inférieur et ne voulant pas que le firmware du port cartouche soit mis à jour, permettant ainsi le downgrade en-dessous de la version 4.0.0 sans perdre l'usage du port cartouche. >con
	echo Attention,, si un firmware supérieur au 4.0.0 est chargé une seule fois par le bootloader de Nintendo (démarrage classique^) ou sans ce patche, le firmware du port cartouche sera mis à jour et donc l'activation de ce patch sera inutile. >con
	set /p atmosphere_enable_nogc_patch=Souhaitez-vous activer le patch nogc? (O/n^): >con
	IF NOT "%atmosphere_enable_nogc_patch%"=="" set atmosphere_enable_nogc_patch=%atmosphere_enable_nogc_patch:~0,1%
:skip_ask_nogc_atmosphere

set /p copy_reinx_pack=Souhaitez-vous copier le pack pour lancer ReiNX? (O/n): >con
IF NOT "%copy_reinx_pack%"=="" set copy_reinx_pack=%copy_reinx_pack:~0,1%
IF /i "%copy_reinx_pack%"=="o" (
	echo.>con
	echo Souhaitez-vous activer le patch NOGC pour ReiNX (firmware 4.0.0 et supérieur^)? >con
	echo Ce patch est utile pour ceux ayant mis à jour avec la méthode ChoiDuJour à partir du firmware 3.0.2 et inférieur et ne voulant pas que le firmware du port cartouche soit mis à jour, permettant ainsi le downgrade en-dessous de la version 4.0.0 sans perdre l'usage du port cartouche. >con
	echo Attention,, si un firmware supérieur au 4.0.0 est chargé une seule fois par le bootloader de Nintendo (démarrage classique^) ou sans ce patche, le firmware du port cartouche sera mis à jour et donc l'activation de ce patch sera inutile. >con
	set /p reinx_enable_nogc_patch=Souhaitez-vous activer le patch nogc? (O/n^): >con
	IF NOT "!reinx_enable_nogc_patch!"=="" set reinx_enable_nogc_patch=!reinx_enable_nogc_patch:~0,1!
)

set /p copy_sxos_pack=Souhaitez-vous copier le pack pour lancer SXOS? (O/n): >con
IF NOT "%copy_sxos_pack%"=="" set copy_sxos_pack=%copy_sxos_pack:~0,1%

set /p copy_memloader=Souhaitez-vous copier les fichiers nécessaire à Memloader pour monter la SD, la partition EMMC, la partition Boot0 ou la partition Boot1 sur un PC en lançant simplement le payload de Memloader? (Si la copie de SXOS a été souhaité, le payload sera aussi copié à la racine de la SD pour pouvoir le lancer grâce au payload de SXOS) (O/n): >con
IF NOT "%copy_memloader%"=="" set copy_memloader=%copy_memloader:~0,1%

IF /i "%copy_sxos_pack%"=="o" (
	set /p copy_payloads=Souhaitez-vous copier les fichiers de payloads des fonctions choisient précédemment à la racine de la SD pour être compatible avec le lancement de payloads du payload SX_Loader? (O/n^): >con
	IF NOT "!copy_payloads!"=="" set copy_payloads=!copy_payloads:~0,1!
)
set /p copy_emu=Souhaitez-vous copier le pack d'émulateurs? (O/n): >con
IF NOT "%copy_emu%"=="" set copy_emu=%copy_emu:~0,1%
IF /i "%copy_emu%"=="o" (
	IF /i NOT "%del_files_dest_copy%"=="o" (
		set /p keep_emu_configs=Souhaitez-vous concerver vos anciens fichiers de configurations d'émulateurs? (O/n^): >con
		IF NOT "!keep_emu_configs!"=="" set keep_emu_configs=!keep_emu_configs:~0,1!
	)
		)
echo Copie en cours... >con
set copy_mixed_pack=O

IF /i "%copy_sdfilesswitch_pack%"=="o" (
	IF /i "%del_files_dest_copy%"=="o" (
		%windir%\System32\Robocopy.exe TOOLS\sd_switch\sdfilesswitch %volume_letter%:\ /mir /e
		set del_files_dest_copy=n
	) else (
		IF EXIST "%volume_letter%:\atmosphere\kip_patches\fs_patches" rmdir /s /q "%volume_letter%:\atmosphere\kip_patches\fs_patches"
		IF EXIST "%volume_letter%:\atmosphere\exefs_patches" rmdir /s /q "%volume_letter%:\atmosphere\exefs_patches"
		%windir%\System32\Robocopy.exe TOOLS\sd_switch\sdfilesswitch %volume_letter%:\ /e
	)
	IF /i "%copy_mixed_pack%"=="O" %windir%\System32\Robocopy.exe TOOLS\sd_switch\mixed %volume_letter%:\ /e
	set copy_mixed_pack=N
	IF /i "%copy_payloads%"=="o" copy /V /B TOOLS\sd_switch\payloads\Hekate.bin %volume_letter%:\Hekate.bin
	IF /i "%copy_memloader%"=="o" copy /V /B TOOLS\sd_switch\payloads\memloader.bin %volume_letter%:\bootloader\payloads\memloader.bin
	IF EXIST "%volume_letter%:\bootlogo.bmp" del /q "%volume_letter%:\bootlogo.bmp"
	IF EXIST "%volume_letter%:\hekate_ipl.ini" del /q "%volume_letter%:\hekate_ipl.ini"
	IF EXIST "%volume_letter%:\switch\GagOrder.nro" del /q "%volume_letter%:\switch\GagOrder.nro"
	IF EXIST "%volume_letter%:\atmosphere\exefs_patches\Signature_Patches_by_br4z0rf_and_Jakibaki" rmdir /s /q "%volume_letter%:\atmosphere\exefs_patches\Signature_Patches_by_br4z0rf_and_Jakibaki"
	IF EXIST "%volume_letter%:\switch\appstore\res" rmdir /s /q "%volume_letter%:\switch\appstore\res"
	IF EXIST "%volume_letter%:\switch\CFWSettings" rmdir /s /q "%volume_letter%:\switch\CFWSettings"
	del /Q /S "%volume_letter%:\bootloader\.emptydir
)

IF /i "%copy_atmosphere_pack%"=="o" (
	IF /i "%del_files_dest_copy%"=="o" (
		%windir%\System32\Robocopy.exe TOOLS\sd_switch\atmosphere %volume_letter%:\ /mir /e
		set del_files_dest_copy=n
	) else (
		IF EXIST "%volume_letter%:\atmosphere\kip_patches\fs_patches" rmdir /s /q "%volume_letter%:\atmosphere\kip_patches\fs_patches"
		IF EXIST "%volume_letter%:\atmosphere\exefs_patches" rmdir /s /q "%volume_letter%:\atmosphere\exefs_patches"
		%windir%\System32\Robocopy.exe TOOLS\sd_switch\atmosphere %volume_letter%:\ /e
	)
	IF /i "%copy_mixed_pack%"=="O" %windir%\System32\Robocopy.exe TOOLS\sd_switch\mixed %volume_letter%:\ /e
	set copy_mixed_pack=N
	IF /i "%copy_payloads%"=="o" copy /V /B TOOLS\sd_switch\payloads\Atmosphere_fusee-primary.bin %volume_letter%:\Atmosphere_fusee-primary.bin
	IF /i "%copy_sdfilesswitch_pack%"=="o" copy /V /B TOOLS\sd_switch\payloads\Atmosphere_fusee-primary.bin %volume_letter%:\bootloader\payloads\Atmosphere_fusee-primary.bin
	IF EXIST "%volume_letter%:\switch\GagOrder.nro" del /q "%volume_letter%:\switch\GagOrder.nro"
	IF EXIST "%volume_letter%:\atmosphere\exefs_patches\Signature_Patches_by_br4z0rf_and_Jakibaki" rmdir /s /q "%volume_letter%:\atmosphere\exefs_patches\Signature_Patches_by_br4z0rf_and_Jakibaki"
	IF EXIST "%volume_letter%:\switch\appstore\res" rmdir /s /q "%volume_letter%:\switch\appstore\res"
	IF EXIST "%volume_letter%:\BCT.ini" del /q "%volume_letter%:\BCT.ini"
	IF EXIST "%volume_letter%:\fusee-secondary.bin" del /q "%volume_letter%:\fusee-secondary.bin"
	IF /i "%atmosphere_enable_nogc_patch%"=="O" (
		%windir%\System32\Robocopy.exe TOOLS\sd_switch\atmosphere_patches_nogc %volume_letter%:\ /e
	)
	del /Q /S "%volume_letter%:\atmosphere\.emptydir
)

IF /i "%copy_reinx_pack%"=="o" (
	IF /i "%del_files_dest_copy%"=="o" (
		%windir%\System32\Robocopy.exe TOOLS\sd_switch\reinx %volume_letter%:\ /mir /e
		set del_files_dest_copy=n
	) else (
		%windir%\System32\Robocopy.exe TOOLS\sd_switch\reinx %volume_letter%:\ /e
	)
	IF /i "%copy_mixed_pack%"=="O" %windir%\System32\Robocopy.exe TOOLS\sd_switch\mixed %volume_letter%:\ /e
	set copy_mixed_pack=N
	IF /i "%reinx_enable_nogc_patch%"=="n" del /q %volume_letter%:\ReiNX\nogc
	IF /i "%copy_payloads%"=="o" copy /V /B TOOLS\sd_switch\payloads\ReiNX.bin %volume_letter%:\ReiNX.bin
	IF /i "%copy_sdfilesswitch_pack%"=="o" copy /V /B TOOLS\sd_switch\payloads\ReiNX.bin %volume_letter%:\bootloader\payloads\ReiNX.bin
	IF EXIST "%volume_letter%:\switch\GagOrder.nro" del /q "%volume_letter%:\switch\GagOrder.nro"
	IF EXIST "%volume_letter%:\switch\appstore\res" rmdir /s /q "%volume_letter%:\switch\appstore\res"
)

IF /i "%copy_sxos_pack%"=="o" (
	IF /i "%del_files_dest_copy%"=="o" (
		%windir%\System32\Robocopy.exe TOOLS\sd_switch\sxos %volume_letter%:\ /mir /e
		set del_files_dest_copy=n
	) else (
		%windir%\System32\Robocopy.exe TOOLS\sd_switch\sxos %volume_letter%:\ /e
	)
	IF /i "%copy_mixed_pack%"=="O" %windir%\System32\Robocopy.exe TOOLS\sd_switch\mixed %volume_letter%:\ /e
	set copy_mixed_pack=N
	IF /i "%copy_payloads%"=="o" copy /V /B TOOLS\sd_switch\payloads\SXOS.bin %volume_letter%:\SXOS.bin
	IF /i "%copy_sdfilesswitch_pack%"=="o" copy /V /B TOOLS\sd_switch\payloads\SXOS.bin %volume_letter%:\bootloader\payloads\SXOS.bin
	IF EXIST "%volume_letter%:\switch\GagOrder.nro" del /q "%volume_letter%:\switch\GagOrder.nro"
	IF EXIST "%volume_letter%:\switch\appstore\res" rmdir /s /q "%volume_letter%:\switch\appstore\res"
	del /Q /S "%volume_letter%:\sxos\.emptydir
)

IF /i "%copy_memloader%"=="o" (
	%windir%\System32\Robocopy.exe TOOLS\memloader\mount_discs %volume_letter%:\ /e
	IF /i "%copy_sxos_pack%"=="o" copy /V /B TOOLS\memloader\memloader.bin %volume_letter%:\Memloader.bin
	IF /i "%copy_sdfilesswitch_pack%"=="o" copy /V /B TOOLS\memloader\memloader.bin %volume_letter%:\bootloader\payloads\Memloader.bin
)
IF /i "%copy_emu%"=="o" (
	IF /i "%del_files_dest_copy%"=="o" (
		%windir%\System32\Robocopy.exe TOOLS\sd_switch\emulators %volume_letter%:\ /mir /e
		set del_files_dest_copy=n
	) else (
		IF EXIST "%volume_letter%:\switch.settings" move "%volume_letter%:\switch.settings" "%volume_letter%:\switch.settings.bak"
				%windir%\System32\Robocopy.exe TOOLS\sd_switch\emulators %volume_letter%:\ /e
		IF /i "%keep_emu_configs%"=="o" (
			del /q "%volume_letter%:\switch.settings"
			move "%volume_letter%:\switch.settings.bak" "%volume_letter%:\switch.settings"
		) else (
			IF EXIST "%volume_letter%:\switch.settings.bak" del /q "%volume_letter%:\switch.settings.bak"
		)
	)
)
del /Q /S "%volume_letter%:\switch\.emptydir
del /Q /S "%volume_letter%:\Backup\.emptydir
del /Q /S "%volume_letter%:\tinfoil\.emptydir
del /Q /S "%volume_letter%:\pk1decryptor\.emptydir
echo Copie terminée. >con
:endscript
pause >con
rmdir /s /q templogs
endlocal