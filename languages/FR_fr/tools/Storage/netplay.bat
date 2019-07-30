goto:%~1

:display_title
title Utiliser le client Switch-Lan-Play %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script va permettre d'installer et de lancer le n�cessaire pour utiliser le jeu en r�seau alternatif de la Switch.
echo Pour plus d'informations sur le sujet, choisissez d'ouvrir la documentation lorsque cela sera propos�.
goto:eof

:first_action_choice
echo Client de jeu en r�seau alternatif
echo.
echo Que souhaitez-vous faire:
echo.
echo 1: Lancer le client?
echo 2: Installation de Winpcap ^(� ne faire qu'une seule fois^)?
echo 0: Lancer la documentation?
echo N'importe quel autre choix: Revenir au menu pr�c�dent.
echo.
set /p install_choice=Votre choix: 
goto:eof

:launch_client_choice
echo Que souhaitez-vous faire:
echo.
echo 1: Lancer le client en mode interactif ^(recommand�^)?
echo 2: Se connecter � un serveur stock� dans une liste?
echo 3: G�rer la liste des serveurs?
echo N'importe quel autre choix: Terminer ce script et revenir au menu pr�c�dent?
echo.
set /p launch_client_choice=Votre choix: 
goto:eof

:no_server_list_error
echo La liste de serveurs n'existe pas, le client sera donc lanc� en mode interactif.
goto:eof

:choose_server_first_part
echo Choisir un serveur:
goto:eof

:launch_client_in_interactive_mode_message
echo N'importe quel autre choix: Lancer le client en mode interactif.
goto:eof

:go_back_message
echo N'importe quel autre choix: Revenir � l'action � faire dans la gestion des serveurs.
goto:eof

:select_server_choice
set /p selected_server=Choisir votre serveur: 
goto:eof

:server_choice_not_exist_in_list_error
echo Le serveur s�lectionn� n'existe pas dans la liste, le client sera donc lanc� en mode interactif.
goto:eof

:server_choice_not_exist_in_list_error2
echo Le serveur s�lectionn� n'existe pas dans la liste, retour aux actions de la gestion des serveurs.
goto:eof

:manage_servers_choice
echo Gestion des serveurs du r�seau alternatif
echo.
echo Que souhaitez-vous faire:
echo.
echo 1: Ajouter un serveur?
echo 2: Modifier un serveur?
echo 3: Supprimer un serveur?
echo N'importe quel autre choix: Quitter la gestion des serveurs.
echo.
set /p manage_choice=Votre choix: 
goto:eof

:server_name_choice
set /p new_server_name=Entrez le nom du serveur: 
goto:eof

:server_name_empty_error
echo Le nom du serveur ne peut �tre vide, l'ajout est annul�.
goto:eof

:server_name_char_error
echo Un caract�re non autoris� a �t� saisie dans le nom du serveur, l'ajout est annul�.
goto:eof

:server_addr_choice
set /p new_server_addr=Entrez l'adresse du serveur: 
goto:eof

:server_addr_empty_error
echo L'adresse du serveur ne peut �tre vide, l'ajout est annul�.
goto:eof

:server_addr_char_error
echo Un caract�re non autoris� a �t� saisie dans l'adresse du serveur, l'ajout est annul�.
goto:eof

:add_server_success
echo Serveur ajout�.
goto:eof

:modify_server_name_choice
set /p new_server_name=Entrez le nouveau nom du serveur ^(si vide, l'ancien nom sera gard�^): 
goto:eof

:modify_server_addr_choice
set /p new_server_addr=Entrez la nouvelle adresse du serveur ^(si vide, l'ancienne adresse sera gard�e^): 
goto:eof

:modify_server_success
echo Serveur modifi�.
goto:eof

:delete_server_success
echo Serveur supprim�.
goto:eof

:winpcap_install_instructions
echo Winpcap va �tre lanc�, veuillez accepter la demande d'�l�vation des privil�ges qui va suivre pour faire fonctionner ce programme.
goto:eof