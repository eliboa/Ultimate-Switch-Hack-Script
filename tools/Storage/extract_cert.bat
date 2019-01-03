::CertNXtractionPack by SocraticBliss and SimonMKWii, modified by Shadow256
@ECHO OFF
Setlocal enabledelayedexpansion
chcp 65001 >nul

IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
IF EXIST "Certificat" (
	rmdir /s /q "Certificat" 2>nul
	del /q Certificat 2>nul
)
mkdir "Certificat"

echo Ce script permet d'extraire le certificat d'une console via la partition PRODINFO déchiffrée de celle-ci.
echo Pour obtenir ce fichier, il va vous falloir les Bis Keys (Bis Key 0) qui peuvent être obtenuent grâce au payload BiskeyDump.
echo Ensuite il y a deux possibilités, soit extraire le fichier d'une Switch directement en montant la partition EMMC de celle-ci ou soit extraire le fichier d'un dump de la nand.
echo Dans les deux cas, il faudra utiliser HacDiskMount pour extraire le fichier en lui indiquant les Bis Keys requises avant l'extraction.
echo Pendant le script, il vous sera proposer d'éventuellement lancer le payload BiskeyDump, de monter la partition EMMC d'une Switch puis de lancer HacDiskMount pour tenter d'obtenir le fichier PRODINFO.bin nécessaire mais il faut savoir comment s'y prendre pour l'extraction dans HacDiskMount car ceci ne peut être automatisé.
pause
set /p biskey=Souhaitez-vous lancer le payload BiskeyDump? (O/n): 
IF NOT "%biskey%"=="" set biskey=%biskey:~0,1%
IF /i "%biskey%"=="o" call TOOLS\Storage\biskey_dump.bat
set /p mount_emmc=Souhaitez-vous monter la partition EMMC de la Switch? (O/n): 
IF NOT "%mount_emmc%"=="" set mount_emmc=%mount_emmc:~0,1%
IF /i "%mount_emmc%"=="o" (
echo *********************************************
echo ***    CONNECTEZ LA SWITCH EN MODE RCM    ***
echo *********************************************
echo 1^) Connecter la Switch en USB et l'éteindre
echo 2^) Appliquer le JoyCon Haxx : PIN1 + PIN10 ou PIN9 + PIN10
echo 3^) Faire un appui long sur VOLUME UP + appui court sur POWER (l'écran restera noir^)
echo En attente d'une Switch en mode RCM...
	tools\TegraRcmSmash\TegraRcmSmash.exe -w tools\memloader\memloader.bin --dataini="tools\memloader\mount_discs\ums_emmc.ini"
	echo.
	echo Le disque devrait être monté sur votre système. Pour le démonter, éjecter le périphérique à l'aide du bouton "retirer le périphérique en toute sécurité" situé sur la barre des tâches en bas à droite puis forcer l'extinction de la Switch en maintenant le bouton POWER pendant 10 secondes (Attention à ne pas écrire/lire de données pendant cette opération sous peine d'endommager gravement les données de votre nand^).
	echo Pour explorer la mémoire interne de la Switch vous devez utiliser l'outil HacDiskMount lancé en tant qu'administrateur (nécessite d'avoir les biskey pour décrypter les données mais non nécessaire pour faire un dump de la nand^). Si vous souhaitez faire un dump de la nand via cette méthode, le dump peut prendre du temps (environ trois heures^).
	echo Parfois, le disque n'est pas reconu automatiquement. Vous devez ouvrir le gestionnaire de périphérique, trouver le périphérique avec un point d'exclamation nommé "Périphérique d’entrée USB" (testé sous Windows 7^), faire un clique droit dessus, cliquer sur "Mettre à jour le pilote...", cliquer sur "Rechercher automatiquement un pilote mis à jour" puis cliquer sur "Fermer". Le périphérique devrait maintenant être utilisable.
	set /p launch_devices_manager=Souhaitez-vous lancer le gestionnaire de périphérique? (o/n^): 
	echo.
	IF NOT "!launch_devices_manager!"=="" set launch_devices_manager=!launch_devices_manager:~0,1!
	IF /i "!launch_devices_manager!"=="o" start devmgmt.msc
)
set /p launch_hacdiskmount=Souhaitez-vous lancer HacDiskMount? (o/n^): 
IF NOT "%launch_hacdiskmount%"=="" set launch_hacdiskmount=%launch_hacdiskmount:~0,1%
IF /i "%launch_hacdiskmount%"=="o" start tools\HacDiskMount/HacDiskMount.exe
echo.
echo Vous allez devoir sélectionner le fichier "PRODINFO.bin" décrypter de la Switch dont le certificat doit être extrait.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers bin (*.bin)|*.bin|" "Sélection du fichier PRODINFO.bin" "templogs\tempvar.txt"
set /p filepath=<templogs\tempvar.txt
IF "!filepath!"=="" (
	echo Oppération annulée.
	rmdir /s /q "Certificat"
	goto:endscript
)
cd "Certificat"
copy /v "%filepath%" "PRODINFO.bin"
REM Check the file dependencies
FOR %%G IN (PRODINFO.bin) DO (
IF NOT EXIST %%G (ECHO Erreur: Placer %%G dans le répertoire "Certificat" et recommencez! && SET ERRORLEVEL=1)
)
IF %ERRORLEVEL% NEQ 0 (ECHO: && cd .. && rmdir /s /q "Certificat" && goto:end_script)

REM Exécution du Script #1
chcp 1250 >nul
..\TOOLS\python2_scripts\CertNXtractionPack.exe
chcp 65001 >nul
IF %ERRORLEVEL% NEQ 0 (ECHO: && cd .. && rmdir /s /q "Certificat" && goto:end_script)

REM Exécution du Script #2
..\TOOLS\python3_scripts\Convert_to_der.exe
IF %ERRORLEVEL% NEQ 0 (ECHO: && cd .. && rmdir /s /q "Certificat" && goto:end_script)

REM Création du fichier de certificat au format "PFX"
..\TOOLS\openssl\openssl.exe x509 -inform DER -in clcert.der -outform PEM -out clcert.pem >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 (ECHO: && cd .. && rmdir /s /q "Certificat" && goto:end_script)

..\TOOLS\openssl\openssl.exe rsa -inform DER -in privkey.der -outform PEM -out privkey.pem >NUL 2>&1
TYPE clcert.pem privkey.pem > nx_tls_client_cert.pem 2>&1
..\TOOLS\openssl\openssl.exe pkcs12 -export -in nx_tls_client_cert.pem -out nx_tls_client_cert.pfx -passout pass:switch >NUL 2>&1
DEL privk.bin >NUL 2>&1
DEL clcert.der >NUL 2>&1
DEL privkey.der >NUL 2>&1
DEL clcert.pem >NUL 2>&1
DEL privkey.pem >NUL 2>&1
DEL nx_tls_client_cert.pem >NUL 2>&1

ECHO:
ECHO Le fichier nx_tls_client_cert.pfx a été sauvegardé dans le répertoire "Certificat" à la racine du script.
ECHO Mot de passe = switch
ECHO:

REM Convertion du fichier "PFX" au format "PEM"
..\TOOLS\python3_scripts\pfx_to_pem.exe nx_tls_client_cert.pfx
IF %ERRORLEVEL% NEQ 0 (ECHO: && cd .. && goto:end_script)

ECHO:
ECHO Le fichier nx_tls_client_cert.pem a été sauvegardé dans le répertoire "Certificat" à la racine du script.
ECHO Toutes les oppérations ont été complétées!
ECHO:
cd ..
:end_script
rmdir /s /q templogs
IF EXIST "Certificat\PRODINFO.bin" del /q "Certificat\PRODINFO.bin"
pause 
endlocal