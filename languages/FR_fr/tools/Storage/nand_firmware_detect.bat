goto:%~1

:display_title
title Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet d'obtenir le firmware sur lequel se trouve un dump d'une nand ainsi que de savoir si le driver EXFAT est inclu ou non.
echo Vous aurez besoin d'un fichier de dump de la nand en une seule partie ainsi que des Bis keys associées à ce dump pour que ce script fonctionne correctement.
goto:eof

:input_nand_file_choice
echo Veuillez renseigner le fichier de dump de la nand dans la fenêtre suivante.
pause
%windir%\system32\wscript.exe //Nologo "tools\Storage\functions\open_file.vbs" "" "Fichier bin^(*.bin^)|*.bin|" "Sélection du fichier de dump de la nand" "templogs\tempvar.txt"
goto:eof

:no_input_nand_file_selected_error
echo Aucun fichier de dump de nand renseigné, le script va s'arrêter.
goto:eof

:input_biskeys_file_choice
echo Veuillez renseigner le fichier contenant les Bis keys associé au dump de la nand dans la fenêtre suivante.
pause
%windir%\system32\wscript.exe //Nologo "tools\Storage\functions\open_file.vbs" "" "Tous les fichiers^(*.*^)|*.*|" "Sélection du fichier contenant les biskeys du dump de la nand" "templogs\tempvar.txt"
goto:eof

:no_input_biskeys_file_selected_error
echo Aucun fichier de dump des clés renseigné, le script va s'arrêter.
goto:eof

:dump_infos_error
echo Une erreur inconnue s'est produite.
echo Il est possible que le fichiers de clés fourni ne corresponde pas au dump de la nand indiqué ou que le dump de la nand soit corrompu.
goto:eof

:noexfat_firmware_infos
echo Firmware %firmware_version% ne possédant pas le driver EXFAT.
goto:eof

:exfat_firmware_infos
echo Firmware %firmware_version% possédant le driver EXFAT.
goto:eof

:date_last_launch_infos
echo Dernière date de lancement du firmware: %day_last_launch_info%-%month_last_launch_info%-%year_last_launch_info% à %hour_last_launch_info%
goto:eof