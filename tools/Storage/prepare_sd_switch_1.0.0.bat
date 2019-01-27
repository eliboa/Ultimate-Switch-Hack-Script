::Script by Shadow256
Setlocal enabledelayedexpansion
@echo off
chcp 65001 >nul
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
echo Ce script va vous permettre de préparer une carte SD pour le hack Switch en y installant les outils importants pour le firmware 1.0.0.
echo Il est conseillé de ne pas rester sous ce firmware et de rapidement mettre à jour vers un firmware plus récent via ChoiDuJour-NX, de concerver ensuite l'auto-RCM pour éviter de griller les efuses pour permettre le downgrade dans le futur et d'utiliser le patch "nogc" pour ne pas mettre à jour le firmware du port cartouche si le firmware devient supérieur ou égal au 4.0.0 (tous les CFWs disposent du patch "nogc" sauf SX OS (dans le pack Kosmos il faudra utiliser les options contenant "prevent GC access" si vous réutilisez mon script pour une nouvelle préparation de la SD)).
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
set /p volume_letter=Entrez la lettre du volume de la SD que vous souhaitez utiliser: 
call TOOLS\Storage\functions\strlen.bat nb "%volume_letter%"
IF %nb% EQU 0 (
	echo La lettre de lecteur ne peut être vide. Réessayez.
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
set /p format_choice=Souhaitez-vous formaté la SD (volume "%volume_letter%") en FAT32? (O/n): 
IF NOT "%format_choice%"=="" set format_choice=%format_choice:~0,1%
IF /i "%format_choice%"=="o" (
	goto:format_fat32
) else (
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
set /p cancel_copy=Souhaitez-vous annuler la copie des différents fichiers vers votre SD (volume "%volume_letter%")? (O/n): 
IF NOT "%cancel_copy%"=="" set cancel_copy=%cancel_copy:~0,1%
IF /i "%cancel_copy%"=="o" goto:endscript
set /p launch_manual=Souhaitez-vous lancer la page d'information sur se qui peut être copié (vivement conseillé)? (O/n): 
IF NOT "%launch_manual%"=="" set launch_manual=%launch_manual:~0,1%
IF /i "%launch_manual%"=="o" (
	start DOC\files\sd_prepare.html
)
IF /i NOT "%format_choice%"=="o" (
	set /p del_files_dest_copy=Souhaitez-vous supprimer tous les répertoires et fichiers de la SD pendant la copie? (O/n^): 
)
IF NOT "%del_files_dest_copy%"=="" set del_files_dest_copy=%del_files_dest_copy:~0,1%
IF /i "%del_files_dest_copy%"=="o" (
set del_files_dest_copy=
	set /p del_files_dest_copy=Souhaitez-vous réellement supprimer tous les fichiers de la SD? (O/n^): 
)
IF NOT "%del_files_dest_copy%"=="" set del_files_dest_copy=%del_files_dest_copy:~0,1%

set copy_sdfilesswitch_pack=O

set /p copy_memloader=Souhaitez-vous copier les fichiers nécessaire à Memloader pour monter la SD, la partition EMMC, la partition Boot0 ou la partition Boot1 sur un PC en lançant simplement le payload de Memloader? (O/n): 
IF NOT "%copy_memloader%"=="" set copy_memloader=%copy_memloader:~0,1%

set /p copy_emu=Souhaitez-vous copier le pack d'émulateurs? (O/n): 
IF NOT "%copy_emu%"=="" set copy_emu=%copy_emu:~0,1%
IF /i "%copy_emu%"=="o" (
	IF /i NOT "%del_files_dest_copy%"=="o" (
		set /p keep_emu_configs=Souhaitez-vous concerver vos anciens fichiers de configurations d'émulateurs? (O/n^): 
		IF NOT "!keep_emu_configs!"=="" set keep_emu_configs=!keep_emu_configs:~0,1!
	)
		)
echo Copie en cours...
set copy_mixed_pack=O

IF /i "%copy_sdfilesswitch_pack%"=="o" (
	IF /i "%del_files_dest_copy%"=="o" (
		%windir%\System32\Robocopy.exe TOOLS\sd_switch\sdfilesswitch_1.0.0 %volume_letter%:\ /mir /e >nul
		set del_files_dest_copy=n
	) else (
		IF EXIST "%volume_letter%:\atmosphere\kip_patches\fs_patches" rmdir /s /q "%volume_letter%:\atmosphere\kip_patches\fs_patches"
		IF EXIST "%volume_letter%:\atmosphere\exefs_patches" rmdir /s /q "%volume_letter%:\atmosphere\exefs_patches"
		%windir%\System32\Robocopy.exe TOOLS\sd_switch\sdfilesswitch_1.0.0 %volume_letter%:\ /e >nul
	)
	IF /i "%copy_mixed_pack%"=="O" %windir%\System32\Robocopy.exe TOOLS\sd_switch\mixed %volume_letter%:\ /e >nul
	set copy_mixed_pack=N
	IF /i "%copy_memloader%"=="o" copy /V /B TOOLS\sd_switch\payloads\memloader.bin %volume_letter%:\bootloader\payloads\memloader.bin
	IF EXIST "%volume_letter%:\bootlogo.bmp" del /q "%volume_letter%:\bootlogo.bmp"
	IF EXIST "%volume_letter%:\hekate_ipl.ini" del /q "%volume_letter%:\hekate_ipl.ini"
	IF EXIST "%volume_letter%:\switch\GagOrder.nro" del /q "%volume_letter%:\switch\GagOrder.nro"
	IF EXIST "%volume_letter%:\atmosphere\exefs_patches\Signature_Patches_by_br4z0rf_and_Jakibaki" rmdir /s /q "%volume_letter%:\atmosphere\exefs_patches\Signature_Patches_by_br4z0rf_and_Jakibaki"
	IF EXIST "%volume_letter%:\switch\appstore\res" rmdir /s /q "%volume_letter%:\switch\appstore\res"
	IF EXIST "%volume_letter%:\switch\CFWSettings" rmdir /s /q "%volume_letter%:\switch\CFWSettings"
	IF EXIST "%volume_letter%:\switch\CFW-Settings" rmdir /s /q "%volume_letter%:\switch\CFW-Settings"
)

IF /i "%copy_memloader%"=="o" (
	%windir%\System32\Robocopy.exe TOOLS\memloader\mount_discs %volume_letter%:\ /e >nul
	IF /i "%copy_sdfilesswitch_pack%"=="o" copy /V /B TOOLS\memloader\memloader.bin %volume_letter%:\bootloader\payloads\Memloader.bin
)
IF /i "%copy_emu%"=="o" (
	IF /i "%del_files_dest_copy%"=="o" (
		%windir%\System32\Robocopy.exe TOOLS\sd_switch\emulators %volume_letter%:\ /mir /e
		set del_files_dest_copy=n
	) else (
		IF EXIST "%volume_letter%:\switch.settings" move "%volume_letter%:\switch.settings" "%volume_letter%:\switch.settings.bak"
				%windir%\System32\Robocopy.exe TOOLS\sd_switch\emulators %volume_letter%:\ /e >nul
		IF /i "%keep_emu_configs%"=="o" (
			del /q "%volume_letter%:\switch.settings"
			move "%volume_letter%:\switch.settings.bak" "%volume_letter%:\switch.settings"
		) else (
			IF EXIST "%volume_letter%:\switch.settings.bak" del /q "%volume_letter%:\switch.settings.bak"
		)
	)
)
del /Q /S "%volume_letter%:\switch\.emptydir
del /Q /S "%volume_letter%:\bootloader\.emptydir
del /Q /S "%volume_letter%:\Backup\.emptydir
del /Q /S "%volume_letter%:\tinfoil\.emptydir
del /Q /S "%volume_letter%:\pk1decryptor\.emptydir
echo Copie terminée.
echo.
echo Vous pouvez maintenant utiliser Hekate pour lancer le CFW en 1.0.0.
echo Une fois la console mise à jour, il est conseillé de refaire une SD avec la fonction classique de ce script en supprimant les données de la SD.
echo.
set /p prepare_update=Souhaitez-vous préparer une mise à jour sur la SD à installer ensuite en utilisant ChoiDuJourNX? (O/n): 
IF NOT "%prepare_update%"==""  set prepare_update=%prepare_update:~0,1%
IF /i "%prepare_update%"=="o" (
	set prepare_update=
	set volume_letter=
	endlocal
	call tools\Storage\prepare_update_on_sd.bat
	goto:finish_script
)
:endscript
endlocal
pause 
:finish_script
rmdir /s /q templogs 2>nul