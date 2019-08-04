goto:%~1

:display_title
title Bo�te � outils de logiciels %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Bienvenue dans la bo�te � outils.
echo.
echo Ici, vous pouvez g�rer le lancement de programmes ayant une interface graphique et qui ne sont donc pas interractif avec mon script.
echo Vous trouverez une liste d'outils par d�faut qui interviennent parfois dans mon script et cette liste ne sera pas modifiable.
echo Par contre, vous pouvez �galement g�rer votre liste de programmes personnel et donc en ajouter ou en supprimer un.
echo.
echo Attention, du fait du fonctionnement qui peut diff�rer pour chaque programme, vous vous devez de g�rer vous-m�me les d�pendances de ceux-ci, cette bo�te � outils ne sert qu'� lancer ou organiser vos outils.
goto:eof

:first_action_choice
echo Bo�te � outils
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Lancer un programme?
echo 2: Ouvrir le dossier principal d'un programme de la liste de programmes personnels?
echo 3: G�rer la liste de programmes personnels?
echo N'importe quel autre choix: Revenir au menu pr�c�dent.
echo.
set /p action_choice=Faites votre choix: 
goto:eof

:launch_software_begin
echo Lancement d'un logiciel
echo.
echo Liste des logiciels:
echo.
echo Logiciels par d�faut:
goto:eof

:software_personal_list_begin
echo Logiciels personnels:
goto:eof

:launch_software_choice
echo N'importe quel autre chiffres: Revenir au menu de s�lection du mode de la toolbox.
echo.
set /p launch_software_choice=Choisissez un logiciel � lancer ou une action � faire: 
goto:eof

:bad_char_error
echo Un caract�re non-autoris� a �t� saisie.
goto:eof

:no_personal_software_defined_error
echo Aucun logiciel personnel d�fini, cette fonctionnalit� ne peut donc pas �tre utilis�e.
goto:eof

:launch_working_dir_choice
echo N'importe quel autre chiffres: Revenir au menu de s�lection du mode de la toolbox.
echo.
set /p launch_software_choice=Choisissez un logiciel pour lequel son dossier de travail sera ouvert ou une action � faire: 
goto:eof

:manage_action_choice
echo Configuration de la liste des logiciels de la bo�te � outils
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Ajouter un logiciel?
echo 2: Modifier le nom d'un logiciel?
echo 3: Supprimer un logiciel?
echo N'importe quel autre choix: Revenir au menu de s�lection du mode de la toolbox.
echo.
set /p manage_choice=Faites votre choix: 
goto:eof

:software_name_choice
set /p software_name=Entrez le nom du logiciel: 
goto:eof

:software_name_empty_error
echo Le nom du logiciel ne peut �tre vide.
goto:eof

:software_name_char_error
echo Un caract�re non autoris� a �t� saisie dans le nom du logiciel.
goto:eof

:software_copy_type_choice
set /p software_copy=Souhaitez-vous copier le logiciel dans le r�pertoire de travail du script? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:software_already_exist_error
echo Ce logiciel semble d�j� avoir �t� copi� dans le r�pertoire "toolbox" du script, l'ajout est donc annul�.
goto:eof

:software_type_choice
	echo Quel est le type du logiciel?
	echo.
	echo 1: Un logiciel n'utilisant qu'un seul fichier pour �tre lanc�?
	echo 2: Un logiciel contenu dans un dossier dont les autres fichiers/dossiers de ce dossier sont n�cessaires � sont fonctionnement?
	echo 0: Annuler la configuration de cet ajout et revenir au menu pr�c�dent.
	echo.
	set /p software_type=Faites votre choix: 
goto:eof

:choice_not_allowed_error
echo Ce choix n'est pas disponible.
goto:eof

:add_software_file_choice
echo Dans la prochaine �tape, vous devrez indiquer o� se trouve le logiciel sur votre ordinateur.
echo Si vous avez choisi de copier le logiciel et selon le type de logiciel choisi, le fichier indiqu� et/ou le dossier qui le contient seront copi�s dans le dossier "tools\toolbox" du script et le chemin sera adapt� pour n'�tre qu'un chemin relatif vers l'ex�cutable choisi.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file2.vbs "" "Tout les fichiers ^(*.*^)|*.*|" "S�lection du fichier principal de votre logiciel" "templogs\tempvar.txt"
goto:eof

:no_software_file_selected_error
echo Le fichier n'a pas �t� indiqu�, la proc�dure d'ajout est annul�e.
goto:eof

:add_software_success
echo Logiciel ajout�.
goto:eof

:modify_software_choice
echo N'importe quel autre chiffres: Revenir au menu  pr�c�dent.
echo.
set /p launch_software_choice=Faites votre choix: 
goto:eof

:modify_software_name_choice
set /p new_software_name=Entrez le nouveau nom du logiciel ^(si vide ou si le nom est exactement le m�me, l'ancien nom sera gard�^): 
goto:eof

:modify_software_not_renamed_error
echo Le logiciel n'a pas �t� renomm�, retour au menu pr�c�dent.
goto:eof

:modify_software_success
echo Nom du logiciel modifi�.
goto:eof

:del_software_success
echo Logiciel supprim�.
goto:eof