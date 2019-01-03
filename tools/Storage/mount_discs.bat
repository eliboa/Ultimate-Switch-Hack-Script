::Script by Shadow256
chcp 65001 > nul
setlocal
echo Attention: Cette fonctionnalité peut monter la mémoire interne de votre Switch. Effectuer des modifications sur cette partie de la console peut entraîner un brick de celle-ci, vous êtes seul responsable de se que vous ferez avec ce script.
echo Notez que la lecture/écriture est assez lente dans ce mode mais cela peut être util pour copier/modifier/supprimer des données mais cela peut prendre du temps pour de gros fichiers.
echo S'il vous plaît, lisez bien attentivement toutes les informations données pendant le script.
pause
echo.
echo Quelle partie de la mémoire souhaitez-vous monter?
echo.
echo 1: Nand de la console.
echo 2: Carte SD.
echo 3: Boot0.
echo 4: Boot1
echo Tout autre choix: Retour au menu principal.
echo.
set /p disc_mounted=Sélectionner la mémoire à monter: 
IF "%disc_mounted%"=="1" (
set ini_path=tools\memloader\mount_discs\ums_emmc.ini
) else IF "%disc_mounted%"=="2" (
set ini_path=tools\memloader\mount_discs\ums_sd.ini
) else IF "%disc_mounted%"=="3" (
set ini_path=tools\memloader\mount_discs\ums_boot0.ini
) else IF "%disc_mounted%"=="4" (
set ini_path=tools\memloader\mount_discs\ums_boot1.ini
) else (
	goto:end_script
)
:mounting
echo *********************************************
echo ***    CONNECTEZ LA SWITCH EN MODE RCM    ***
echo *********************************************
echo 1) Connecter la Switch en USB et l'éteindre
echo 2) Appliquer le JoyCon Haxx : PIN1 + PIN10 ou PIN9 + PIN10
echo 3) Faire un appui long sur VOLUME UP + appui court sur POWER (l'écran restera noir)
echo En attente d'une Switch en mode RCM...
tools\TegraRcmSmash\TegraRcmSmash.exe -w tools\memloader\memloader.bin --dataini="%ini_path%"
echo.
echo Le disque devrait être monté sur votre système. Pour le démonter, éjecter le périphérique à l'aide du bouton "retirer le périphérique en toute sécurité" situé sur la barre des tâches en bas à droite puis forcer l'extinction de la Switch en maintenant le bouton POWER pendant 10 secondes (Attention à ne pas écrire/lire de données pendant cette opération sous peine d'endommager gravement les données de votre nand/sd).
IF "%disc_mounted%"=="1" echo Pour explorer la mémoire interne de la Switch vous devez utiliser l'outil HacDiskMount lancé en tant qu'administrateur (nécessite d'avoir les biskey pour décrypter les données mais non nécessaire pour faire un dump de la nand). Si vous souhaitez faire un dump de la nand via cette méthode, le dump peut prendre du temps (environ trois heures).
IF "%disc_mounted%"=="3" echo Pour explorer la partition boot0 de la Switch vous devez utiliser l'outil HacDiskMount lancé en tant qu'administrateur (nécessite d'avoir les biskey pour décrypter les données mais non nécessaire pour faire un dump de la partition). Si vous souhaitez faire un dump de la partition via cette méthode, le dump peut prendre du temps.
IF "%disc_mounted%"=="4" echo Pour explorer la partition boot1 de la Switch vous devez utiliser l'outil HacDiskMount lancé en tant qu'administrateur (nécessite d'avoir les biskey pour décrypter les données mais non nécessaire pour faire un dump de la partition). Si vous souhaitez faire un dump de la partition via cette méthode, le dump peut prendre du temps.
echo Parfois, le disque n'est pas reconu automatiquement. Vous devez ouvrir le gestionnaire de périphérique, trouver le périphérique avec un point d'exclamation nommé "Périphérique d’entrée USB" (testé sous Windows 7), faire un clique droit dessus, cliquer sur "Mettre à jour le pilote...", cliquer sur "Rechercher automatiquement un pilote mis à jour" puis cliquer sur "Fermer". Le périphérique devrait maintenant être utilisable.
set /p launch_devices_manager=Souhaitez-vous lancer le gestionnaire de périphérique? (o/n): 
echo.
IF NOT "%launch_devices_manager%"=="" set launch_devices_manager=%launch_devices_manager:~0,1%
IF /i "%launch_devices_manager%"=="o" start devmgmt.msc
IF %disc_mounted% NEQ 2 (
	set /p launch_hacdiskmount=Souhaitez-vous lancer HacDiskMount? (o/n^): 
)
	IF %disc_mounted% NEQ 2 (
	IF NOT "%launch_hacdiskmount%"=="" set launch_hacdiskmount=%launch_hacdiskmount:~0,1%
)
IF %disc_mounted% NEQ 2 (
	IF /i "%launch_hacdiskmount%"=="o" start tools\HacDiskMount/HacDiskMount.exe
)
:end_script
pause
endlocal