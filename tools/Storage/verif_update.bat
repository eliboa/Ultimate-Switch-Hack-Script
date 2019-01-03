::Script by Shadow256
chcp 65001 > nul
Setlocal
cls
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 goto:finish_script
title Shadow256 Ultimate Switch Hack Script %ushs_version%
echo :::::::::::::::::::::::::::::::::::::
echo ::Shadow256 Ultimate Switch Hack Script %ushs_version%::
echo :::::::::::::::::::::::::::::::::::::
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
tools\gnuwin32\bin\wget.exe --no-check-certificate --content-disposition -S -O "templogs\version.txt" https://raw.githubusercontent.com/shadow2560/Ultimate-Switch-Hack-Script/master/tools/version.txt
title Shadow256 Ultimate Switch Hack Script %ushs_version%
set /p ushs_version_verif=<templogs\version.txt
IF "%ushs_version_verif%"=="" goto:end_script
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
:finish_script
endlocal
call TOOLS\Storage\menu.bat