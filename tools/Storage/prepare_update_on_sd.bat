::Script by Shadow256
@echo off
Setlocal
chcp 65001 > nul

IF NOT EXIST templogs (
	mkdir templogs
) else (
	rmdir /s /q templogs
	mkdir templogs
)
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	echo Aucune connexion à internet disponible, le script va s'arrêter.
	goto:end_script
)
set md5_try=0
echo Ce script permet de préparer la carte SD avec un firmware spécifique à installer avec ChoiDuJourNX, le firmware sera téléchargé puis copié sur la SD et ChoiDuJour-NX sera également copié sur la SD. Notez que vous aurez besoin de lancer un CFW pour finaliser la mise à jour sur votre console donc si vous ne l'avez pas fait, veuillez préparer la SD pour le hack avant ou après l'exécution de ce script (si après, ne pas formater la carte ou supprimer les données s'y trouvant car sinon vous devrez exécuter de nouveau ce script).
echo.
echo ATTENTION: Choisissez bien la lettre du volume qui correspond à votre SD car aucune vérification ne pourra être faites à ce niveau là. 
echo.
echo Le script permet également de créer un package de mise à jour via ChoiDuJour en se basant sur le firmware sélectionné pour mettre à jour manuellement la console via Memloader, Etcher et HacDiskMount (pour les utilisateurs avancés).
echo.
echo Attention: Aucune vérification n'est faite sur l'espace disque sur lequel est exécuté ce script ni sur celui de la SD, vous aurez au moins besoin de 800 MO (1 GO si vous créez en plus un package via ChoiDuJour) d'espace libre sur le disque sur lequel s'exécute ce script et d'environ 400 MO sur la SD de la Switch pour y copier le firmware. Notez que ces estimations sont un peu plus large que la réalité mais c'est à vous de faire ces vérifications pour le moment.
echo Notez également qu'une vérification sera tout de même faite pour savoir si le firmware téléchargé n'est pas corrompu via son MD5, seulement l'extraction de celui-ci n'est pas vérifiée donc faites bien attention aux éventuels messages d'erreurs des différents programmes pendant ce script pour savoir si quelque chose s'est mal passé. En cas de problème, vérifiez en premier lieu que vous avez assez d'espace disque sur les périphériques utilisés.
echo.
echo Notez également que les fichiers sont téléchargés via Mega donc certaines limitations pourraient s'appliquer en cas de trop nombreux téléchargements venant d'une même connexion internet. Si vous avez un compte sur Mega.nz, vous pouvez le configurer dans le fichier "tools\megatools\mega.ini" en supprimant les signes "#" devant "Username" et "Password" et en remplaçant les valeurs après le signe "=" par votre nom d'utilisateur et votre mot de passe.
echo.
echo Je ne pourrais être tenu pour responsable en cas de dommage lié à l'utilisation de ce script ou des outils qu'il contient. 
pause 
:define_action_type
Echo Que souhaitez-vous faire?
echo.
echo 1: Préparer un firmware qui sera copié sur la SD pour une installation via ChoiDuJour-NX?
echo 2: Préparer un firmware pour la mise à jour manuel avec ChoiDuJour?
echo 3: Effectuer les deux actions.
echo 4: Préparer une SD avec les différents CFWs et homebrews utiles et revenir à ce menu ensuite?
echo N'importe quel autre choix: Revenir au menu précédent.
echo.
set /p action_type=Faites votre choix: 
IF NOT "%action_type%"=="" set action_type=%action_type:~0,1%
IF "%action_type%"=="4" (
	set action_type=
	call tools\storage\prepare_sd_switch.bat > log.txt 2>&1
	@echo off
	goto:define_action_type
)
IF "%action_type%"=="1" goto:define_firmware_choice
IF "%action_type%"=="2" goto:define_firmware_choice
IF "%action_type%"=="3" goto:define_firmware_choice
goto:end_script
:define_firmware_choice
echo Choisissez le firmware que vous souhaitez préparer?
echo.
echo Liste des firmwares:
echo 1.0.0?
echo 2.0.0?
echo 2.1.0?
echo 2.2.0?
echo 2.3.0?
echo 3.0.0?
echo 3.0.1?
echo 3.0.2?
echo 4.0.0?
echo 4.0.1?
echo 4.1.0?
echo 5.0.0?
echo 5.0.1?
echo 5.0.2?
echo 5.1.0?
echo 6.0.0?
echo 6.0.1?
echo 6.1.0?
echo 6.2.0?
echo 7.0.0?
echo 7.0.1?
echo 8.0.0?
echo 8.0.1?
echo.
echo F: Ouvrir le dossier contenant les firmwares déjà téléchargé?
echo N'importe quel autre choix terminera ce script et reviendra au menu précédent.
echo.
set firmware_choice =
set /p firmware_choice=Entrez le firmware souhaité ou une action à faire: 
IF NOT EXIST "downloads" mkdir "downloads"
IF NOT EXIST "downloads\firmwares" mkdir "downloads\firmwares"
IF EXIST "firmware_temp" (
	del /q "firmware_temp" 2>nul
	rmdir /S /Q "firmware_temp" 2>nul
) else (
	mkdir firmware_temp
)
IF /i "%firmware_choice%"=="F" (
	set firmware_choice=
	start explorer.exe "%~dp0..\..\downloads\firmwares"
	goto:define_firmware_choice
)
IF "%firmware_choice%"=="1.0.0" (
	set expected_md5=529bcdab4964809e44fa75634c7f1432
	set firmware_link=https://mega.nz/#!YExVSRKY!MEBPOhYCQ1hXA0tlhSh70nC1C0rGEv2P3A6go56Z87g
	set firmware_file_name=Firmware 1.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="2.0.0" (
	set expected_md5=78fe09c2da202d35e58c7b07bb7f39a8
	set firmware_link=https://mega.nz/#!sAIzSQTK!c1RNFqOrDt3-iW4Rn_M5IkUgx-ormrpImrtZXixNrOQ
	set firmware_file_name=Firmware 2.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="2.1.0" (
	set expected_md5=35752c26badc270f9fdd51883922432b
	set firmware_link=https://mega.nz/#!gcx3UR5Y!P4Ka3g4hum5c2tI0YwX8HBokm6SQ4EoCG2OeKtKC8dg
	set firmware_file_name=Firmware 2.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="2.2.0" (
	set expected_md5=137f5d416d1b41ad26c35575dd534bc4
	set firmware_link=https://mega.nz/#!QVJl0aDA!MU03vBUo1OXxK5Ha0yP04vli6W0LQjvZILuc_bh_Xq4
	set firmware_file_name=Firmware 2.2.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="2.3.0" (
	set expected_md5=91e06f945e00e6412cc4ac44a0faa72b
	set firmware_link=https://mega.nz/#!1IxFgJBD!kkliIMLOYNjmwIVR0tcr3svn72C6tMOQG5GHYie50q4
	set firmware_file_name=Firmware 2.3.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="3.0.0" (
	set expected_md5=f4b5f8bffded14cca836bc24ecf19c06
	set firmware_link=https://mega.nz/#!RUxF3Lwb!5fYRfHTFTx8KS9HnyYMmTuTTzKKQ4HyaQ4FqC-nyAc4
	set firmware_file_name=Firmware 3.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="3.0.1" (
	set expected_md5=a245bc7d3151cd51687ce602a1d4dfbb
	set firmware_link=https://mega.nz/#!pE51RLgI!pmvw4sfocWw-vZ26P3GjA2PSrLyeBcq-eunnvzmUx94
	set firmware_file_name=Firmware 3.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="3.0.2" (
	set expected_md5=521e4aabc0b3b18d49f99c861cd55196
	set firmware_link=https://mega.nz/#!hNo1TLrL!S1pfSuDaOoeW2eNcpe89bPP3BiW0b3pPqUrJvsVCAuQ
	set firmware_file_name=Firmware 3.0.2.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="4.0.0" (
	set expected_md5=69ac6dbac1bd0a12ea9e12c97bc82907
	set firmware_link=https://mega.nz/#!EBIDFCrZ!NaIuX7dvC3skUBAfb113qxhh0hJYzY3mm1mWou7Casc
	set firmware_file_name=Firmware 4.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="4.0.1" (
	set expected_md5=3680ddfb0f7a2f01c83495dca909c757
	set firmware_link=https://mega.nz/#!NQg1yZaA!4yuWJbXOGlCp6lryPcsF5ADEydk7jZq08RstUCDMKwY
	set firmware_file_name=Firmware 4.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="4.1.0" (
	set expected_md5=fe53dd1eaa323bd9003f75a96822cb31
	set firmware_link=https://mega.nz/#!wQ4HGLgI!ru3dBiMh9FdPJJvVTLJ6ex7EX0Rfma9Tw4J3gRWYU7k
	set firmware_file_name=Firmware 4.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="5.0.0" (
	set expected_md5=de25e742c8c0fa9c7f6d079f65ddbf92
	set firmware_link=https://mega.nz/#!IBQlXQqL!oePY4waKGpSnmVyxgXqEwx_vOeI6FvdBdpg0Wp4Y28c
	set firmware_file_name=Firmware 5.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="5.0.1" (
	set expected_md5=79c2ac770eece2f9b713f3c6b12cc19a
	set firmware_link=https://mega.nz/#!BUB3TShb!VFVqGrzK2j_6OIUTcbwzTvPCm8V5Aab2hXrdJrVmUqk
	set firmware_file_name=Firmware 5.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="5.0.2" (
	set expected_md5=f14d2064255517aa1383e7e468e2ef19
	set firmware_link=https://mega.nz/#!wBwDCTgI!7LsV9WSoYDBI6CamIBRzZYwA3wjCRchXyXw1VTTwXTc
	set firmware_file_name=Firmware 5.0.2.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="5.1.0" (
	set expected_md5=656823850a70fb3050079423ee177c1a
	set firmware_link=https://mega.nz/#!8BplGRQA!z_2pCeh-8XV2Pf3E_38UfGhDPRSdN3nixb5s5-Q785w
	set firmware_file_name=Firmware 5.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="6.0.0" (
	set expected_md5=8e107ad46a5aacc1f8f5db7fc83d6945
	set firmware_link=https://mega.nz/#!0ZxlgABK!HN8_ZfQHha-LaVr-95wUiotvGSObIUoEY8RxMwjDgVg
	set firmware_file_name=Firmware 6.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="6.0.1" (
	set expected_md5=684f2184d9dd4bdc25ff161e0ea7353d
	set firmware_link=https://mega.nz/#!ZAYEhYSQ!69L4mdQnPNKghHnMY41w3Di5MjvGXr8MhXGMVAxG5GA
	set firmware_file_name=Firmware 6.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="6.1.0" (
	set expected_md5=320bd423e073a92b74dff30d92bcffa8
	set firmware_link=https://mega.nz/#!QAQ3ha4Y!7fI6dJmhk3SUwyEl9cj9orRSE7Fjb1rghJxCnliXZRU
	set firmware_file_name=Firmware 6.1.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="6.2.0" (
	set expected_md5=602826f8ad0ed04452a1092fc6d73c8c
	set firmware_link=https://mega.nz/#!9F5XFabb!UdZmY8qpMbDuo-rrn0jI-JCpXrTWKoshKhClZ_H7tkA
	set firmware_file_name=Firmware 6.2.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="7.0.0" (
	set expected_md5=550b0091304d54b67e3e977900c83dcc
	set firmware_link=https://mega.nz/#!kdJWQKBT!G15TiWusLkrS7JT2KHNYXOfNAUOb2PWdhXsfe-kRtxg
	set firmware_file_name=Firmware 7.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="7.0.1" (
	set expected_md5=c5440e557b8b62eabedf754e508ded2f
	set firmware_link=https://mega.nz/#!EERwCayT!KPGACrRhEVQdhsaqbfqpNTwzAyRIoZRLvfqqmxhNT80
	set firmware_file_name=Firmware 7.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="8.0.0" (
	set expected_md5=c0dab852378c289dc1fb135ed2a36f01
	set firmware_link=https://mega.nz/#!gU4B3KDa!H5QKqthWmIAc5IM-pouiRFp-vOSkEfDTSMoSDFTUPps
	set firmware_file_name=Firmware 8.0.0.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
IF "%firmware_choice%"=="8.0.1" (
	set expected_md5=c3a2a6ac6ef5956cdda6ce172ccd2053
	set firmware_link=https://mega.nz/#!lM4wSKCL!_-38B-DFq9dqqUqu4EorS0hnBi099dY6JbkXYard51A
	set firmware_file_name=Firmware 8.0.1.zip
	set firmware_folder=firmware_temp\
	goto:download_firmware
)
goto:end_script
:download_firmware
set md5_try=0
IF EXIST "downloads\firmwares\%firmware_file_name%" goto:verif_md5sum
:downloading_firmware
IF NOT EXIST "downloads\firmwares\%firmware_file_name%" (
	echo Téléchargement du firmware %firmware_choice%...
TOOLS\megatools\megadl.exe "%firmware_link%" --path=templogs\temp.zip
	TOOLS\gnuwin32\bin\md5sum.exe templogs\temp.zip | TOOLS\gnuwin32\bin\cut.exe -d " " -f 1 | TOOLS\gnuwin32\bin\cut.exe -d ^\ -f 2 >templogs\tempvar.txt
		set /p md5_verif=<templogs\tempvar.txt
)
IF NOT EXIST "downloads\firmwares\%firmware_file_name%" (
	IF NOT "%md5_verif%"=="%expected_md5%" (
		IF %md5_try% EQU 3 (
			echo Le md5 du firmware ne semble pas être correct. Veuillez vérifier votre connexion internet ainsi que l'espace disponible sur votre disque dur puis relancer le script. 
			goto:end_script
		) else (
			echo Le md5 du firmware ne semble pas être correct, le téléchargement va être réessayé.
			set /a md5_try+=1
			goto:downloading_firmware
		)
	)
)
set md5_try=0
move "templogs\temp.zip" "downloads\firmwares\%firmware_file_name%"
goto:skip_verif_md5sum
:verif_md5sum
TOOLS\gnuwin32\bin\md5sum.exe "downloads\firmwares\%firmware_file_name%" | TOOLS\gnuwin32\bin\cut.exe -d " " -f 1 | TOOLS\gnuwin32\bin\cut.exe -d ^\ -f 2 >templogs\tempvar.txt
set /p md5_verif=<templogs\tempvar.txt
IF NOT "%md5_verif%"=="%expected_md5%" (
	set md5_verif=
	echo Le fichier du firmware semble exister mais son MD5 est incorrect, il va donc être retéléchargé.
	goto:downloading_firmware
)
:skip_verif_md5sum
echo Extraction du firmware pour la suite des traitements...
TOOLS\7zip\7za.exe x -y -sccUTF-8 "downloads\firmwares\%firmware_file_name%" -o"firmware_temp" -r
IF "%action_type%"=="1" goto:define_volume_letter
IF "%action_type%"=="2" (
	set action_type=
	call tools\storage\create_update.bat "%~dp0..\..\firmware_temp"
	mkdir templogs
	goto:define_action_type
)
IF "%action_type%"=="3" goto:define_volume_letter
:define_volume_letter
%windir%\system32\wscript //Nologo //B TOOLS\Storage\functions\list_volumes.vbs
TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\volumes_list.txt >templogs\count.txt
set /p tempcount=<templogs\count.txt
del /q templogs\count.txt
IF "%tempcount%"=="" (
	echo Aucun disque compatible trouvé. Veuillez insérer votre clé USB puis relancez le script. 
	echo Le script va maintenant s'arrêté. 
	goto:end_script
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
set volume_letter=
set /p volume_letter=Entrez la lettre du volume de la carte SD que vous souhaitez utiliser: 
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
	TOOLS\gnuwin32\bin\grep.exe "Lettre volume=%volume_letter%" <templogs\volumes_list.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 3 | TOOLS\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
	set /p temp_volume_format=<templogs\tempvar.txt
IF NOT "%temp_volume_format%"=="FAT32" (
	echo Attention: Le support que vous avez choisi n'est pas formaté en FAT32. Si vous n'avez pas installé le driver EXFAT sur votre Switch, il est nécessaire de formater la carte SD en FAT32. 
set /p cancel_script=Souhaitez-vous annuler les oppérations en cours pour formater la SD en FAT32 (le firmware ne sera pas à retélécharger^)? (O/n^): 
)
IF NOT "%cancel_script%"=="" set cancel_script=%cancel_script:~0,1%
IF /i "%cancel_script%"=="o" goto:end_script
IF "%action_type%"=="1" (
	echo Copie du firmware sur la SD dans le dossier "FW_%firmware_choice%" et copie du homebrew ChoiDuJour-NX...
	%windir%\System32\Robocopy.exe "firmware_temp" %volume_letter%:\FW_%firmware_choice% /e
	IF EXIST "%volume_letter%:\switch\ChoiDuJourNX.nro" del /q "%volume_letter%:\switch\ChoiDuJourNX.nro"
	IF NOT EXIST "%volume_letter%:\switch" mkdir "%volume_letter%:\switch"
	IF NOT EXIST "%volume_letter%:\switch\ChoiDuJourNX" mkdir "%volume_letter%:\switch\ChoiDuJourNX"
	IF EXIST "%volume_letter%:\switch\ChoiDuJourNX\ChoiDuJourNX.nro" (
		del /q "%volume_letter%:\switch\ChoiDuJourNX\ChoiDuJourNX.nro"
	)
	copy /V /B "tools\sd_switch\mixed\switch\ChoiDuJourNX\ChoiDuJourNX.nro" "%volume_letter%:\switch\ChoiDuJourNX\ChoiDuJourNX.nro"
	echo Les fichiers ont été copiés.
)
IF "%action_type%"=="3" (
	echo Copie du firmware sur la SD dans le dossier "FW_%firmware_choice%" et copie du homebrew ChoiDuJour-NX...
	%windir%\System32\Robocopy.exe "firmware_temp" %volume_letter%:\FW_%firmware_choice% /e
	IF EXIST "%volume_letter%:\switch\ChoiDuJourNX.nro" del /q "%volume_letter%:\switch\ChoiDuJourNX.nro"
	IF NOT EXIST "%volume_letter%:\switch" mkdir "%volume_letter%:\switch"
	IF NOT EXIST "%volume_letter%:\switch\ChoiDuJourNX" mkdir "%volume_letter%:\switch\ChoiDuJourNX"
	IF EXIST "%volume_letter%:\switch\ChoiDuJourNX\ChoiDuJourNX.nro" (
		del /q "%volume_letter%:\switch\ChoiDuJourNX\ChoiDuJourNX.nro"
	)
	copy /V /B "tools\sd_switch\mixed\modular\ChoiDuJourNX\switch\ChoiDuJourNX\ChoiDuJourNX.nro" "%volume_letter%:\switch\ChoiDuJourNX\ChoiDuJourNX.nro"
	echo Les fichiers ont été copiés.
	echo.
	echo Maintenant, la préparation du package de mise à jour avec ChoiDuJour va être lancée et vous allez devoir régler ces options.
	echo.
	pause
	call tools\storage\create_update.bat "%~dp0..\..\firmware_temp"
	mkdir templogs
)
echo.
set /p launch_choidujournx_doc=Souhaitez-vous consulter la documentation pour savoir comment utiliser ChoiDuJourNX (recommandé)? (O/n): 
IF NOT "%launch_choidujournx_doc%"=="" set launch_choidujournx_doc=%launch_choidujournx_doc:~0,1%
IF /I "%launch_choidujournx_doc%"=="o" start DOC\files\choidujournx.html
	:end_script
pause 
echo Nettoyage des fichiers temporaires...
rmdir /s /q templogs 2>nul
rmdir /s /q "firmware_temp" 2>nul
endlocal