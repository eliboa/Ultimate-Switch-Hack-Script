goto:%~1

:display_title
title Boîte à outil pour la Nand %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Bienvenue dans la boîte à outils pour la nand.
echo.
echo Ici, vous pouvez effectuer un grand nombre d'actions sur la nand de la Switch ou sur un fichier de nand déjà dumpé.
echo Si vous n'avez pas lancé l'Ultimate Switch Hack Script en tant qu'administrateur ^(Windows 8 et versions supérieurs^), toutes les fonctionnalités permettant d'intervenir sur un disque physique seront inutilisables.
::echo.
echo Note: Pour sélectionner un dump splittés, il suffit de sélectionner le premier fichier de celui-ci.
echo.
echo Attention: Les opérations effectuées par ces fonctions peuvent intervenir sur la nand de votre console, vous êtes seul responsable de se que vous faites.
goto:eof

:first_action_choice
echo Boîte à outils de la nand
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: obtenir des infos sur un fichier de dump ou sur une partie de la nand de la console?
echo 2: Dumper la nand ou une partition de la nand de la console, copier un fichier ou extraire une partition d'un fichier de dump?
echo 3: Restaurer la nand ou une partition de la nand de la console sur la console ou dans un fichier de dump?
echo 4: Activer/désactiver l'auto-RCM d'une partition BOOT0 ?
echo 5: Joindre un dump de la rawnand fait en plusieurs parties, par exemple un dump fait via Hekate sur une SD formatée en FAT32?
echo 6: Spliter un dump de la rawnand?
echo 7: Créer un fichier à partir d'un dump complet de la nand qui pourra ensuite être utilisé pour la création d'une Emunand via une partition dédiée de la SD?
echo 8: Extraire les fichiers d'un dump de nand à partir d'un fichier de la partition de l'emunand?
echo 9: Connaître le firmware ainsi que le status du driver EXFAT d'un dump de nand ^(dump splité non pris en charge^)?
echo 0: Charger une partie de la nand d'une console via USB avec Memloader?
echo N'importe quel autre choix: Revenir au menu précédent?
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:nand_infos_begin
echo Sur quelle nand souhaitez-vous avoir des infos?
goto:eof

:nand_choice
echo 0: Fichier de dump?
echo Aucune valeur: Revenir au choix du mode?
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:dump_not_exist_error
echo Le fichier de dump n'a pas été indiqué ou le numéro de disque n'existe pas.
goto:eof

:dump_input_begin
echo Choisissez le support depuis lequel faire le dump:
goto:eof

:dump_output_folder_choice
echo Vous allez devoir sélectionner le dossier vers lequel extraire le dump.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Sélection du dossier"
goto:eof

:dump_output_folder_empty_error
echo Le répertoire pour extraire le dump ne peut être vide, la fonction va être annulée.
goto:eof

:dump_erase_existing_file_choice
set /p erase_output_file=Ce dossier contient déjà un fichier de ce type de dump, souhaitez-vous vraiment continuer en écrasant le fichier existant ^(si oui, le fichier sera supprimé juste après ce choix^)? ^(O/n^): 
goto:eof

:canceled
echo Opération annulée par l'utilisateur.
goto:eof

:restaure_input_file_begin
echo Vous allez devoir sélectionner le fichier depuis lequel restaurer.
goto:eof

:restaure_input_empty_error
echo Le fichier de dump n'a pas été indiqué, retour au choix du mode.
goto:eof

:restaure_output_begin
echo Choisissez le support vers lequel restaurer le dump:
goto:eof

:restaure_input_dump_invalid_error
echo Le dump en entrée semble être corrompu ou n'est pas un dump valide, par mesure de sécurité le script va s'arrêter.
goto:eof

:restaure_output_dump_invalid_error
echo Le dump en sortie semble être corrompu ou n'est pas un dump valide, par mesure de sécurité le script va s'arrêter.
goto:eof

:restaure_try_partition_on_other_than_rawnand_error
echo Impossible de restaurer une partition spécifique si le type de nand en sortie n'est pas "RAWNAND", l'opération est annulée.
goto:eof

:restaure_partitions_not_match_error
echo Le type de partition ne semble pas correspondre avec le fichier choisi pour restaurer. Par mesure de sécurité, l'opération est annulée.
goto:eof

:restaure_input_and_output_type_not_match_error
echo Le type de la nand en entrée ne correspond pas avec le type de la nand en sortie, il n'est pas possible de continuer.
goto:eof

:autorcm_dump_choice_begin
echo Sur quelle partition BOOT0 souhaitez-vous travailler?
goto:eof

:autorcm_choice
echo Que souhaitez-vous faire:
echo 1: Activer l'auto-RCM?
echo 2: Désactiver l'auto-RCM?
echo Tout autre choix: Annuler le processus.
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:autorcm_nand_type_must_be_boot0_error
echo Le type de la nand doit être BOOT0, le processus ne peut continuer.
goto:eof

:autorcm_action_error
	echo Une erreur inconnue semble s'être produite pendant la tentative d'activation/désactivation de l'auto-RCM.
	echo Vérifiez que le script a bien été exécuté en tant qu'administrateur et que le fichier ou le périphérique est bien accessible. Dans le cas d'un fichier, vérifiez également qu'il n'est pas en lecture seul.
goto:eof

:autorcm_enabled_success
echo Auto-RCM activé.
goto:eof

:autorcm_disabled_success
echo Auto-RCM désactivé.
goto:eof

:nand_file_select_choice
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Tout les fichiers ^(*.*^)|*.*|" "Sélection du fichier de dump" "templogs\tempvar.txt"
goto:eof

:nand_choice_char_error
echo Un caractère non-autorisé a été saisie.
goto:eof

:partition_choice_begin
echo Sur quelle partition travailler?
echo 0: Toute la rawnand.
goto:eof

:partition_choice
echo Aucun choix: Annuler l'opération.
echo.
set /p choose_partition=Faites votre choix: 
goto:eof

:bad_value
echo Choix inexistant.
goto:eof

:force_param_choice
set /p force_option=Souhaitez-vous que le programme ne pose aucune question durant le traitement ^(mode FORCE^)? ^(O/n^): 
goto:eof

:skipmd5_param_choice
set /p skip_md5=Souhaitez-vous passer la vérification MD5? ^(O/n^): 
goto:eof

:debug_param_choice
set /p debug_option=Souhaitez-vous activer les informations de débogage? ^(O/n^): 
goto:eof