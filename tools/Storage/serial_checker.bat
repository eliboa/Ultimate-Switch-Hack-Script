::Script by Shadow256
chcp 65001 > nul
Setlocal enabledelayedexpansion
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
echo Ce script va vous permettre de tester un ou plusieurs numéro(s) de série  de console(s) pour savoir si celle(s)-ci est/sont patchée(s), peut-être patchée(s) ou non-patchée(s).
echo.
echo Ces données peuvent parfois être imprécises, si vous rencontrez une situation contradictoire avec le résultat de ce script, merci de m'en avertir  en indiquant les dix premiers chiffres du numéro de série ainsi que la base de données utilisée, le résultat obtenu et enfin la contradiction.
echo Il est important de rapporter également les données concernant des consoles pour lequel le résultat est "peut-être patchée", cela permettra d'affiner la base de données des numéros de série compatible ou non avec plus de certitudes.
echo.
echo Un grand merci à AkdM de logic-sunrise pour le script python qui sera utilisé tout au long de ce script et merci à tout ceux qui m'ont aider et m'aideront à affiner la base de données.
echo.
echo Attention: Il est recommandé d'avoir une connexion à internet pour exécuter ce script pour que la base de donnée soit mise à jour vers la dernière version.
pause
:begin_script
echo.
echo Mise à jour de la base de données...
ping /n 2 www.google.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	IF NOT EXIST "tools\python3_scripts\ssnc\serials.json" (
		echo Aucune connexion à internet et il n'y a aucun fichier de base de donnée de téléchargé, le script ne peut pas continuer et va donc revenir au menu précédent.
		goto:end_script
	)
	echo Aucune connexion à internet pour télécharger la base de données, la dernière version téléchargée sera donc utilisée.
) else (
	echo.
	echo Choix de la base de données à télécharger:
	echo.
	echo 1: Base de données classique, moins précise mais plus juste et plus testée?
	echo 2: Base de données beta, plus précise mais peut contenir plus d'erreurs?
	echo 0: Terminer ce script et revenir au menu précédent?
	echo N'importe quel autre choix: Ne pas télécharger de base de données et utiliser la dernière version qui a été téléchargée?
	echo.
	set /p database_choice=Faites votre choix: 
	IF "!database_choice!"=="1" (
		tools\gnuwin32\bin\wget.exe --no-check-certificate --content-disposition -S -O "tools\python3_scripts\ssnc\serials.json" https://raw.githubusercontent.com/shadow2560/Ultimate-Switch-Hack-Script/master/tools/python3_scripts/ssnc/serials.json.safe
	) else IF "!database_choice!"=="2" (
		tools\gnuwin32\bin\wget.exe --no-check-certificate --content-disposition -S -O "tools\python3_scripts\ssnc\serials.json" https://raw.githubusercontent.com/shadow2560/Ultimate-Switch-Hack-Script/master/tools/python3_scripts/ssnc/serials.json.beta
	) else IF "!database_choice!"=="0" (
		goto:finish_script
	) else (
		goto:skip_update
	)
	echo Mise à jour de la base de donnée effectuée avec succès.
	title Shadow256 Ultimate Switch Hack Script %ushs_version%
)
:skip_update
cd tools\python3_scripts\ssnc
:enter_serial
set console_serial=
echo Que souhaitez-vous faire?
echo.
echo 0: Revenir au menu précédent.
echo 1: M'avertir  sur une incohérence ou un résultat permettant d'affiner la vérification.
echo 2: Changer de base de données (nécessite une connexion à internet)?
echo.
set /p console_serial=Entrez un numéro de série ou choisissez une option: 
IF "%console_serial%"=="" (
	echo Ce choix ne peut être vide.
	goto:enter_serial
)
IF "%console_serial%"=="0" goto:end_script
IF "%console_serial%"=="1" (
	start explorer.exe "http://www.logic-sunrise.com/forums/topic/84485-base-de-donees-des-numeros-de-serie-de-consoles-patchees-ou-non/"
	set console_serial=
	goto:enter_serial
)
IF "%console_serial%"=="2" (
	set console_serial=
	cd ..\..\..
	goto:begin_script
)
.\ssnc.exe %console_serial% >..\..\..\templogs\tempvar.txt
set /p console_status=<..\..\..\templogs\tempvar.txt
IF /i "%console_status%"=="patched" (
	echo.
	echo La console %console_serial% est patchée.
	echo.
	goto:enter_serial
)
IF /i "%console_status%"=="warning" (
	echo.
	echo La console %console_serial% est peut-être patchée.
	echo.
	goto:enter_serial
)
IF /i "%console_status%"=="safe" (
	echo.
	echo La console %console_serial% n'est pas patchée.
	echo.
	goto:enter_serial
)
IF /i "%console_status%"=="incorrect" (
	echo.
	echo Le numéro de série entré est incorrect.
	echo.
	goto:enter_serial
)
echo Une erreur inconnue s'est produite, réessayez.
goto:enter_serial
:end_script
cd ..\..\..
:finish_script
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal