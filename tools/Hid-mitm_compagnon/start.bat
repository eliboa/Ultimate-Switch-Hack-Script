chcp 65001 > nul
@ECHO off
setlocal
cls

:Header
ECHO ////////////////////// hid_mitm (script de démarrage par Krank, modifié par Shadow256) //////////////////////
ECHO.
goto start

:start
ECHO.
ECHO Répertoire de travail: %cd%
ECHO.
set IP_Adress=
set /p IP_Adress="Entrez l'adresse IP de votre Switch ou laissez vide pour revenir au menu précédent: "
IF "%IP_Adress%"=="" goto:end_script
input_pc_win.exe %IP_Adress%
ECHO.
goto start
:end_script
endlocal