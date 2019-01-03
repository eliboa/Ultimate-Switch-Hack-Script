:sc1
set "info_dir=%~1INFO"
cls
call :logo
echo ********************************************************
echo INFORMATION FICHIER
echo ********************************************************
echo.
echo -- Tapez "0" pour revenir au menu principal du script --
echo.
set bs=
set /p bs="Ou faites glisser un  fichier XCI ou NSP et appuyez sur Entrer: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto salida
set "targt=%bs%"
for /f "delims=" %%a in ("%bs%") do set "Extension=%%~xa"
for /f "delims=" %%a in ("%bs%") do set "Name=%%~na"
if "%Extension%" EQU ".nsp" ( goto sc2 )
if "%Extension%" EQU ".xci" ( goto sc2 )
echo Type de fichier nom supporté.
pause
goto sc1
:sc2
cls
call :logo
echo .......................................................
echo Tapez "1" pour voir le contenu du xci/nsp
echo Tapez "2" pour voir les infos de NUT sur le xci/nsp
echo Tapez "3" pour voir les informations sur le jeu et le FIRMWARE requis du xci/nsp
echo Tapez "4" pour lire le CNMT du xci/nsp
echo.
echo Tapez "b" pour revenir à la sélection du fichier
echo -- Tapez "0" pour revenir au menu principal du script --
echo.
echo Ou glissez un autre fichier pour changer de cible.
echo .......................................................
echo.
set bs=
set /p bs="faites votre choix: "
set bs=%bs:"=%
for /f "delims=" %%a in ("%bs%") do set "Extension=%%~xa"
if "%Extension%" EQU ".*" ( goto wch )
if "%Extension%" EQU ".nsp" ( goto snfi )
if "%Extension%" EQU ".xci" ( goto snfi )

if /i "%bs%"=="1" goto g_content
if /i "%bs%"=="2" goto n_info
if /i "%bs%"=="3" goto f_info
if /i "%bs%"=="4" goto r_cnmt

if /i "%bs%"=="b" goto sc1
if /i "%bs%"=="0" goto salida
goto wch

:snfi
for /f "delims=" %%a in ("%bs%") do set "Name=%%~na"
set "targt=%bs%"
goto sc2
:wch
echo Choix inexistant.
pause
goto sc2

:g_content
cls
call :logo
echo ********************************************************
echo Voir le contenu du NSP ou de la partition SECURE du XCI
echo ********************************************************
%pycommand% "%nut%" --ADVfilelist "%targt%"
echo.
ECHO ********************************************************
echo Souhaitez-vous copier ces informations dans un fichier texte?
ECHO ********************************************************
:g_content_wrong
echo Tapez "1" pour les copier dans un fichier texte
echo Tapez "2" pour ne pas les copier dans un fichier texte
echo.
set bs=
set /p bs="Faites votre choix: "
if /i "%bs%"=="1" goto g_content_print
if /i "%bs%"=="2" goto sc2
echo Choix inexistant.
echo.
goto g_content_wrong
:g_content_print
if not exist "%info_dir%" MD "%info_dir%">NUL 2>&1
set "i_file=%info_dir%\%Name%-content.txt"
%pycommand% "%nut%" --ADVfilelist "%targt%">"%i_file%"
ECHO Terminé.
goto sc2

:n_info
cls
call :logo
echo ********************************************************
echo NUT - INFO BY BLAWAR
echo ********************************************************
%pycommand% "%nut%" -i "%targt%"
echo.
ECHO ********************************************************
echo Souhaitez-vous copier ces informations dans un fichier texte?
ECHO ********************************************************
:n_info_wrong
echo Tapez "1" pour les copier dans un fichier texte
echo Tapez "2" pour ne pas les copier dans un fichier texte
echo.
set bs=
set /p bs="Faites votre choix: "
if /i "%bs%"=="1" goto n_info_print
if /i "%bs%"=="2" goto sc2
echo Choix inexistant
echo.
goto n_info_wrong
:n_info_print
if not exist "%info_dir%" MD "%info_dir%">NUL 2>&1
set "i_file=%info_dir%\%Name%-info.txt"
%pycommand% "%nut%" -i "%targt%">"%i_file%"
more +2 "%i_file%">"%i_file%.new"
move /y "%i_file%.new" "%i_file%" >nul
ECHO Terminé.
goto sc2

:f_info
cls
call :logo
echo ********************************************************
echo Informations et données sur le firmware requis
echo ********************************************************
%pycommand% "%nut%" --fw_req "%targt%"
ECHO ********************************************************
echo Souhaitez-vous copier ces informations dans un fichier texte?
ECHO ********************************************************
:f_info_wrong
echo Tapez "1" pour les copier dans un fichier texte
echo Tapez "2" pour ne pas les copier dans un fichier texte
echo.
set bs=
set /p bs="Faites votre choix: "
if /i "%bs%"=="1" goto f_info_print
if /i "%bs%"=="2" goto sc2
echo Choix inexistant
echo.
goto f_info_wrong
:f_info_print
if not exist "%info_dir%" MD "%info_dir%">NUL 2>&1
set "i_file=%info_dir%\%Name%-fwinfo.txt"
%pycommand% "%nut%" --fw_req "%targt%">"%i_file%"
ECHO Terminé.
goto sc2

:r_cnmt
cls
call :logo
echo ********************************************************
echo Voir le contenu du  NSP ou de la partition SECURE du XCI
echo ********************************************************
%pycommand% "%nut%" --Read_cnmt "%targt%"
echo.
ECHO ********************************************************
echo Souhaitez-vous copier ces informations dans un fichier texte?
ECHO ********************************************************
:r_cnmt_wrong
echo Tapez "1" pour les copier dans un fichier texte
echo Tapez "2" pour ne pas les copier dans un fichier texte
echo.
set bs=
set /p bs="Faites votre choix: "
if /i "%bs%"=="1" goto r_cnmt_print
if /i "%bs%"=="2" goto sc2
echo Choix inexistant
echo.
goto r_cnmt_wrong
:r_cnmt_print
if not exist "%info_dir%" MD "%info_dir%">NUL 2>&1
set "i_file=%info_dir%\%Name%-meta.txt"
%pycommand% "%nut%" --Read_cnmt "%targt%">"%i_file%"
more +1 "%i_file%">"%i_file%.new"
move /y "%i_file%.new" "%i_file%" >nul
ECHO Terminé.
goto sc2

:salida
exit /B

:logo
ECHO                                        __          _ __    __         
ECHO                  ____  _____ ____     / /_  __  __(_) /___/ /__  _____
ECHO                 / __ \/ ___/ ___/    / __ \/ / / / / / __  / _ \/ ___/
ECHO                / / / (__  ) /__     / /_/ / /_/ / / / /_/ /  __/ /    
ECHO               /_/ /_/____/\___/____/_.___/\__,_/_/_/\__,_/\___/_/     
ECHO                              /_____/                                  
ECHO -------------------------------------------------------------------------------------
ECHO                         NINTENDO SWITCH CLEANER AND BUILDER
ECHO -------------------------------------------------------------------------------------
ECHO =============================     BY JULESONTHEROAD     =============================
ECHO -------------------------------------------------------------------------------------
ECHO "                             POWERED WITH NUT BY BLAWAR                            "
ECHO "                             AND LUCA FRAGA'S HACBUILD                             "
ECHO                                     VERSION %program_version%                                     	
ECHO -------------------------------------------------------------------------------------                   
ECHO Program's github: https://github.com/julesontheroad/NSC_BUILDER
ECHO Revised hacbuild: https://github.com/julesontheroad/hacbuild
ECHO Blawar's NUT    : https://github.com/blawar/nut 
ECHO SciresM hactool : https://github.com/SciresM/hactool
ECHO -------------------------------------------------------------------------------------
exit /B
