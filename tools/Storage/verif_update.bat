::Script by Shadow256
chcp 65001 > nul
Setlocal
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
IF "%force_update%"=="1" goto:start_verif_update
title Shadow256 Ultimate Switch Hack Script %ushs_version%
echo :::::::::::::::::::::::::::::::::::::
echo ::Shadow256 Ultimate Switch Hack Script %ushs_version%::
:verif_auto_update_ini
IF EXIST tools\Storage\verif_update.ini\*.* (
	rmdir /s /q tools\Storage\verif_update.ini
)
IF not EXIST tools\Storage\verif_update.ini copy nul tools\Storage\verif_update.ini
tools\gnuwin32\bin\grep.exe -m 1 "auto_update" <tools\Storage\verif_update.ini | tools\gnuwin32\bin\cut.exe -d = -f 2 >templogs\tempvar.txt
set /p ini_auto_update=<templogs\tempvar.txt
:initialize_auto_update
IF "%ini_auto_update%"=="" (
	echo Réglage de la mise à jour automatique:
	echo.
	echo O: Vérifier les mises à jour cette fois-ci.
	echo N: Ne pas vérifier les mises à jour cette fois-ci.
	echo T: Toujours vérifier les mises à jour.
	echo J: Ne jamais vérifier les mises à jour.
	echo.
	set /p auto_update=Souhaitez-vous activer la mise à jour automatique? (O/N/T/J^): >con
) else IF /i "%ini_auto_update%"=="O" (
	set auto_update=O
) else IF /i "%ini_auto_update%"=="N" (
	set auto_update=N
) else (
	echo Mauvaise valeur configurée, le paramètre va être réinitialisé.
	del /q tools\Storage\verif_update.ini
	goto:verif_auto_update_ini
)
IF NOT "%auto_update%"=="" (
	set auto_update=%auto_update:~0,1%
) else (
	echo Cette valeur ne peut être vide.
	goto:initialize_auto_update
)
IF /i "%auto_update%"=="J" (
	echo auto_update=N>>tools\Storage\verif_update.ini
	set auto_update=N
)
IF /i "%auto_update%"=="T" (
	echo auto_update=O>>tools\Storage\verif_update.ini
	set auto_update=O
)
IF /i "%auto_update%"=="N" (
	goto:end_script
) else IF /i "%auto_update%"=="O" (
	goto:start_verif_update
) else (
	echo Choix inexistant.
	goto:initialize_auto_update
)
:start_verif_update
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 goto:end_script
echo :::::::::::::::::::::::::::::::::::::
tools\gnuwin32\bin\wget.exe --no-check-certificate --content-disposition -S -O "templogs\version.txt" https://raw.githubusercontent.com/shadow2560/Ultimate-Switch-Hack-Script/master/tools/version.txt
title Shadow256 Ultimate Switch Hack Script %ushs_version%
set /p ushs_version_verif=<templogs\version.txt
IF "%ushs_version_verif%"=="" goto:end_script
IF EXIST tools\sd_switch\version.txt (
	set /p ushs_packs_version=<tools\sd_switch\version.txt
) else (
	set /p ushs_packs_version=<tools\packs_version.txt
)
tools\gnuwin32\bin\wget.exe --no-check-certificate --content-disposition -S -O "templogs\version.txt" https://raw.githubusercontent.com/shadow2560/Ultimate-Switch-Hack-Script/master/tools/sd_switch/version.txt
title Shadow256 Ultimate Switch Hack Script %ushs_version%
set /p ushs_packs_version_verif=<templogs\version.txt
IF "%ushs_packs_version_verif%"=="" goto:end_script
IF %ushs_packs_version_verif% GTR %ushs_packs_version% set update_packs_finded=O
IF EXIST tools\sd_switch\cheats\version.txt (
	set /p ushs_cheats_version=<tools\sd_switch\cheats\version.txt
) else (
	set /p ushs_cheats_version=<tools\cheats_version.txt
)
tools\gnuwin32\bin\wget.exe --no-check-certificate --content-disposition -S -O "templogs\version.txt" https://raw.githubusercontent.com/shadow2560/Ultimate-Switch-Hack-Script/master/tools/sd_switch/cheats/version.txt
title Shadow256 Ultimate Switch Hack Script %ushs_version%
set /p ushs_cheats_version_verif=<templogs\version.txt
IF "%ushs_cheats_version_verif%"=="" goto:end_script
IF %ushs_cheats_version_verif% GTR %ushs_cheats_version% set update_cheats_finded=O
IF %ushs_version_verif:~0,1% GTR %ushs_version:~0,1% (
	set update_finded=O
	goto:skip_verif_update
)
IF %ushs_version_verif:~2,1% GTR %ushs_version:~2,1% (
	set update_finded=O
	goto:skip_verif_update
)
IF %ushs_version_verif:~3,1% GTR %ushs_version:~3,1% (
	set update_finded=O
	goto:skip_verif_update
)
IF %ushs_version_verif:~5,1% GTR %ushs_version:~5,1% (
	set update_finded=O
	goto:skip_verif_update
)
IF %ushs_version_verif:~6,1% GTR %ushs_version:~6,1% (
	set update_finded=O
	goto:skip_verif_update
)
:skip_verif_update
IF "%update_finded%"=="" (
	echo Aucune mise à jour générale du script trouvée.
	goto:check_packs_update
)
:define_action_choice
echo Mise à jour du script en version %ushs_version_verif% trouvée.
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Ouvrir la page du projet sur Logic-sunrise?
echo 2: Ouvrir la page de la documentation contenant le Changelog?
echo N'importe quel autre choix: Continuer sans rien faire?
echo.
set /p action_choice=Faites votre choix: 
IF "%action_choice%"=="1" goto:open_project_page
IF "%action_choice%"=="2" goto:open_documentation_page
goto:check_packs_update

:open_project_page
set action_choice=
start explorer.exe "http://www.logic-sunrise.com/forums/topic/81314-shadow256-ultimate-switch-hack-script/"
goto:define_action_choice
:open_documentation_page
set action_choice=
tools\gnuwin32\bin\wget.exe --no-check-certificate --content-disposition -S -O "templogs\changelog.html" https://raw.githubusercontent.com/shadow2560/Ultimate-Switch-Hack-Script/master/DOC/files/changelog.html
title Shadow256 Ultimate Switch Hack Script %ushs_version%
start explorer.exe templogs\changelog.html
goto:define_action_choice

:check_packs_update
IF "%update_packs_finded%"=="" (
	echo Aucune mise à jour des packs trouvée.
	pause
	goto:check_cheats_update
)
:define_packs_action_choice
echo Mise à jour des packs en version %ushs_packs_version_verif% trouvée.
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Mettre à jour les packs?
echo 2: Ouvrir la page de la documentation contenant le Changelog des packs?
echo N'importe quel autre choix: Continuer sans rien faire?
echo.
set /p packs_action_choice=Faites votre choix: 
IF "%packs_action_choice%"=="1" goto:update_packs
IF "%packs_action_choice%"=="2" goto:open_packs_changelog_page
goto:check_cheats_update
:update_packs
set packs_action_choice=
copy tools\sd_switch\version.txt tools\packs_version.txt
rmdir /s /q tools\sd_switch
tools\gnuwin32\bin\wget.exe --no-check-certificate --content-disposition -S -O "templogs\changelog.html" https://raw.githubusercontent.com/shadow2560/Ultimate-Switch-Hack-Script/master/DOC/files/packs_changelog.html
title Shadow256 Ultimate Switch Hack Script %ushs_version%
tools\gitget\SVN\svn.exe export https://github.com/shadow2560/Ultimate-Switch-Hack-Script/trunk/tools/sd_switch tools\sd_switch --force
IF %errorlevel% NEQ 0 (
	echo Un problème est survenu durant la mise à jour des packs, veuillez vérifier votre connexion internet et réessayer. Si cela ne vient pas de la connexion internet, vérifiez également l'espace disque pour la partition sur laquelle se trouve le script et libérez au moins 500 MO sur celui-ci avant de réessayer.
	echo Notez que vous devez réussir la mise à jour pour que le script de préparation d'une SD ou d'une SD pour la version 1.0.0 du firmware fonctionne correctement. Si la mise à jour ne fonctionne vraiment pas, veuillez retélécharger le script au complet et le réinstaller.
	goto:define_packs_action_choice
) else (
	del /q tools\packs_version.txt
	copy templogs\changelog.html DOC\files\packs_changelog.html
	echo Mise à jour des packs effectuée avec succès.
	pause
	goto:end_script
)
:open_packs_changelog_page
set pack_action_choice=
tools\gnuwin32\bin\wget.exe --no-check-certificate --content-disposition -S -O "templogs\changelog.html" https://raw.githubusercontent.com/shadow2560/Ultimate-Switch-Hack-Script/master/DOC/files/packs_changelog.html
title Shadow256 Ultimate Switch Hack Script %ushs_version%
start explorer.exe templogs\changelog.html
goto:define_packs_action_choice

:check_cheats_update
IF "%update_cheats_finded%"=="" (
	echo Aucune mise à jour des cheats trouvée.
	pause
	goto:end_script
)
:define_cheats_action_choice
echo Mise à jour des cheats en version %ushs_cheats_version_verif% trouvée.
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Mettre à jour les cheats?
echo N'importe quel autre choix: Continuer sans rien faire?
echo.
set /p cheats_action_choice=Faites votre choix: 
IF "%cheats_action_choice%"=="1" goto:update_cheats
goto:end_script
:update_cheats
set cheats_action_choice=
copy tools\sd_switch\cheats\version.txt tools\cheats_version.txt
rmdir /s /q tools\sd_switch\cheats
tools\gitget\SVN\svn.exe export https://github.com/shadow2560/Ultimate-Switch-Hack-Script/trunk/tools/sd_switch/cheats tools\sd_switch\cheats --force
IF %errorlevel% NEQ 0 (
	echo Un problème est survenu durant la mise à jour des cheats, veuillez vérifier votre connexion internet et réessayer. Si cela ne vient pas de la connexion internet, vérifiez également l'espace disque pour la partition sur laquelle se trouve le script et libérez au moins 5 MO sur celui-ci avant de réessayer.
	echo Notez que vous devez réussir la mise à jour pour que le script de préparation d'une SD  fonctionne correctement. Si la mise à jour ne fonctionne vraiment pas, veuillez retélécharger le script au complet et le réinstaller.
	goto:define_cheats_action_choice
) else (
	del /q tools\cheats_version.txt
	echo Mise à jour des cheats effectuée avec succès.
	pause
	goto:end_script
)

:end_script
rmdir /s /q templogs 2>nul
endlocal
IF NOT "%force_update%"=="1" call TOOLS\Storage\menu.bat