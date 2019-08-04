goto:%~1

:display_title
title Installation drivers %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script va permettre d'installer les drivers nécessaires au bon fonctionnement de la Switch avec le PC.
echo Pour plus d'informations sur les différentes méthodes, choisissez d'ouvrir la documentation lorsque cela sera proposé.
goto:eof

:install_choice
echo Installation de drivers
echo.
echo Choisissez comment installer les drivers:
echo.
echo 1: Installation automatique pour le mode RCM ^(installation recommandée pour ce mode^)?
echo 2: Installation via Zadig?
echo 3: Installation via le gestionaire de périphériques?
echo 0: Lancer la documentation?
echo N'importe quel autre choix: Revenir au menu précédent.
echo.
set /p install_choice=Quelle méthode souhaitez-vous utiliser? 
goto:eof

:rcm_and_drivers_install_instructions
echo *********************************************
echo ***    CONNECTEZ LA SWITCH EN MODE RCM    ***
echo *********************************************
echo 1^) Connecter la Switch en USB et l'éteindre
echo 2^) Appliquer le JoyCon Haxx : PIN1 + PIN10 ou PIN9 + PIN10
echo 3^) Faire un appui long sur VOLUME UP + appui court sur POWER ^(l'écran restera noir^)
echo 4^) Une fois les mannipulations effectuées, appuyez sur une touche, accepter la demande d'élévation des privilèges et suivez les instructions à l'écran.
goto:eof

:test_payload_choice
set /p test_payload=Souhaitez-vous lancer un payload? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:zadig_launch_instructions
echo Zadig va être lancé, veuillez accepter la demande d'élévation des privilèges qui va suivre pour faire fonctionner ce programme.
goto:eof

:manual_install_instructions
echo Le gestionnaire de périphérique va être lancé.
echo Le dossier à sélectionner pour installer les drivers est le dossier "tools\drivers\manual_installation_usb_driver" de ce script.
goto:eof