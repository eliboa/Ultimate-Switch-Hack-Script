::Script by Shadow256
chcp 65001 > nul
Setlocal
cls
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
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
IF %ushs_version_verif:~0,1% GTR %ushs_version:~0,1% (
	set update_finded=O
	goto:skip_verif_update
) else IF %ushs_version_verif:~0,1% LSS %ushs_version:~0,1% (
	goto:end_script
)
IF %ushs_version_verif:~2,1% GTR %ushs_version:~2,1% (
	set update_finded=O
	goto:skip_verif_update
) else IF %ushs_version_verif:~2,1% LSS %ushs_version:~2,1% (
	goto:end_script
)
IF %ushs_version_verif:~3,1% GTR %ushs_version:~3,1% (
	set update_finded=O
	goto:skip_verif_update
) else IF %ushs_version_verif:~3,1% LSS %ushs_version:~3,1% (
	goto:end_script
)
IF %ushs_version_verif:~5,1% GTR %ushs_version:~5,1% (
	set update_finded=O
	goto:skip_verif_update
) else IF %ushs_version_verif:~5,1% LSS %ushs_version:~5,1% (
	goto:end_script
)
IF %ushs_version_verif:~6,1% GTR %ushs_version:~6,1% (
	set update_finded=O
	goto:skip_verif_update
) else IF %ushs_version_verif:~6,1% LSS %ushs_version:~6,1% (
	goto:end_script
)
IF "%update_finded%"=="" (
	goto:end_script
)
:skip_verif_update
echo Mise à jour du script en version %ushs_version_verif% trouvée.
:define_action_choice
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
goto:end_script

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
:end_script
rmdir /s /q templogs 2>nul
endlocal
call TOOLS\Storage\menu.bat