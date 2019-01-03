::Script by Shadow256
setlocal
chcp 65001 > nul
echo Ce script va permettre d'installer les drivers nécessaires au bon fonctionnement de la Switch avec le PC.
echo Pour plus d'informations sur les différentes méthodes, choisissez d'ouvrir la documentation lorsque cela sera proposé.
pause
echo.
:select_install
echo Choisissez comment installer les drivers:
echo.
echo 1: Installation automatique pour le mode RCM (installation recommandée pour ce mode)?
echo 2: Installation via Zadig?
echo 3: Installation via le gestionaire de périphériques?
echo 0: Lancer la documentation?
echo N'importe quel autre choix: Revenir au menu précédent.
echo.
set /p install_choice=Quelle méthode souhaitez-vous utiliser? 
IF NOT "%install_choice%"=="" set install_choice=%install_choice:~0,1%
IF "%install_choice%"=="1" goto:RCM_auto
IF "%install_choice%"=="2" goto:Zadig
IF "%install_choice%"=="3" goto:manual_install
IF "%install_choice%"=="0" goto:launch_doc
goto:finish_script
:RCM_auto
set install_choice=
echo *********************************************
echo ***    CONNECTEZ LA SWITCH EN MODE RCM    ***
echo *********************************************
echo 1) Connecter la Switch en USB et l'éteindre
echo 2) Appliquer le JoyCon Haxx : PIN1 + PIN10 ou PIN9 + PIN10
echo 3) Faire un appui long sur VOLUME UP + appui court sur POWER (l'écran restera noir)
echo 4) Une fois les mannipulations effectuées, appuyez sur une touche, accepter la demande d'élévation des privilèges et suivez les instructions à l'écran.
pause
cd tools\drivers\apx_drivers
InstallDriver.exe
cd ..\..\..
set /p test_payload=Souhaitez-vous lancer un payload? (O/n): 
IF NOT "%test_payload%"=="" set test_payload=%test_payload:~0,1%
IF /i "%test_payload%"=="o" (
	set test_payload=
	call tools\Storage\launch_payload.bat > log.txt 2>&1
	@echo off
)
echo.
goto:select_install

:Zadig
set install_choice=
echo Zadig va être lancé, veuillez accepter la demande d'élévation des privilèges qui va suivre pour faire fonctionner ce programme.
pause
echo.
start tools\drivers\zadig\zadig.exe
goto:select_install
:manual_install
set install_choice=
echo Le gestionnaire de périphérique va être lancé.
echo Le dossier à sélectionner pour installer les drivers est le dossier "tools\drivers\manual_installation_usb_driver" de ce script.
pause
echo.
start devmgmt.msc
goto:select_install
:launch_doc
set install_choice=
echo.
start DOC\files\install_drivers.html
goto:select_install
:end_script
pause
:finish_script
endlocal