goto:%~1

:display_title
title Préparation d'une SD %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script va vous permettre de préparer une carte SD pour le hack Switch en y installant les outils importants.
echo Pendant le script, les droits administrateur seront peut-être demandé.
echo.
echo ATTENTION: Si vous décidez de formater votre carte SD, toutes les données de celle-ci seront perdues. Sauvegardez les données importante avant de formater.
echo ATTENTION: Choisissez bien la lettre du volume qui correspond à votre carte SD car aucune vérification ne pourra être faites à ce niveau là.
echo.
echo Je ne pourrais être tenu pour responsable de quelque domage que se soit lié à l'utilisation de ce script ou des outils qu'il contient.
goto:eof

:disk_not_finded_error
	echo Aucun disque compatible trouvé. Veuillez insérer votre carte SD puis relancez le script.
	echo Le script va maintenant s'arrêté.
goto:eof

:disk_list_begin
echo Liste des disques:
goto:eof

:disk_choice
set /p volume_letter=Entrez la lettre du volume de la SD que vous souhaitez utiliser ou entrez "0" pour quitter le script:
goto:eof

:disk_choice_empty_error
echo La lettre de lecteur ne peut être vide. Réessayez.
goto:eof

:disk_choice_char_error
echo Un caractère non autorisé a été saisie dans la lettre du lecteur. Recommencez.
goto:eof

:disk_choice_not_exist_error
echo Ce volume n'existe pas. Recommencez.
goto:eof

:disk_choice_not_in_list_error
echo Cette lettre de volume n'est pas dans la liste. Recommencez.
goto:eof

:disk_format_choice
set /p format_choice=Souhaitez-vous formaté la SD ^(volume "%volume_letter%"^)? ^(O/n^):
goto:eof

:disk_format_type_choice
echo Quel type de formatage souhaitez-vous effectuer:
echo 1: EXFAT ^(la Switch doit avoir le support pour ce format d'installé^)?
echo 2: FAT32 ^(limité au fichier de moins de 4 GO^)?
echo Tout autre choix: Annule le formatage.
echo.
set /p format_type=Choisissez le type de formatage à effectuer:
goto:eof

:disk_formating_begin
echo Formatage en cours...
goto:eof

:disk_formating_error
echo Un problème s'est produit pendant la tentative de formatage, le script va maintenant s'arrêter.
goto:eof

:disk_formating_success
echo Formatage effectué avec succès.
goto:eof

:disk_formating_fat32_not_admin_error
echo La demande d'élévation n'a pas été acceptée, le formatage est annulé.
goto:eof

:disk_formating_fat32_disk_used_error
echo Le formatage n'a pas été effectué.
echo Essayez d'éjecter proprement votre clé USB, réinsérez-là et relancez immédiatement ce script.
echo Vous pouvez également essayer de fermer toutes les fenêtres de l'explorateur Windows avant le formatage, parfois cela règle le bug.
echo.
echo Le script va maintenant s'arrêter.
goto:eof

:disk_formating_fat32_disk_not_exist_error
echo Le volume à formater n'existe pas. Vous avez peut-être débranché ou éjecté la carte SD durant ce script.
echo.
echo Le script va maintenant s'arrêter.
goto:eof

:disk_formating_fat32_unknown_error
echo Une erreur inconue s'est produite pendant le formatage.
echo.
echo Le script va maintenant s'arrêter.
goto:eof

:disk_formating_fat32_canceled_info
echo Le formatage a été annulé par l'utilisateur.
goto:eof

:general_profile_select_begin
echo Sélection du profile général:
goto:eof

:general_profile_select_atmosphere_and_sxos_recommanded_profile_display
echo !count_default_profile!: Profile Atmosphere + SXOS + Memloader recommandé, ne contient pas le patch NOGC et met juste à jour les fichiers existant de la SD donc ce profile n'est pas toujours adapté.
goto:eof

:general_profile_select_atmosphere_recommanded_profile_display
echo !count_default_profile!: Profile Atmosphere recommandé, ne contient pas le patch NOGC et met juste à jour les fichiers existant de la SD donc ce profile n'est pas toujours adapté.
goto:eof

:general_profile_select_sxos_recommanded_profile_display
echo !count_default_profile!: Profile  SXOS recommandé,  met juste à jour les fichiers existant de la SD donc ce profile n'est pas toujours adapté.
goto:eof

:general_profile_choice
echo 0: Accéder à la gestion des profiles généraux.
echo E: Terminer le script sans préparer la SD.
echo Tout autre choix: Préparer la SD manuellement.
echo.
set /p general_profile=Choisissez un profile: 
goto:eof

:confirm_copy_choice
set /p confirm_copy=Souhaitez-vous confirmer ceci? ^(O/n^): 
goto:eof

:canceled
echo Opération annulée.
goto:eof

:bad_choice
echo Choix inexistant.
goto:eof

:before_copy_error
	echo Préparation de la SD annulée car une erreur inconnue est survenue, vérifiez que vous n'avez pas supprimer de profiles utilisés dans ce profile général.
	echo Si le problème persiste, veuillez refaire ce profile.
goto:eof

:copying_begin
echo Copie en cours...
goto:eof

:copying_end
echo Copie terminée.
goto:eof