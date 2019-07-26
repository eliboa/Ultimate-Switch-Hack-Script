:sc1
set "info_dir=%~1INFO"
cls
call :logo
echo ********************************************************
echo Information sur le fichier
echo ********************************************************
echo.
echo -- Tapez "0" pour revenir au menu principal du script --
echo.
set /p bs="Ou faites glisser un  fichier XCI ou NSP et appuyez sur Entrer: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto salida
set "targt=%bs%"
for /f "delims=" %%a in ("%bs%") do set "Extension=%%~xa"
for /f "delims=" %%a in ("%bs%") do set "Name=%%~na"
if "%Extension%" EQU ".nsp" ( goto sc2 )
if "%Extension%" EQU ".nsx" ( goto sc2 )
if "%Extension%" EQU ".xci" ( goto sc2 )
if "%Extension%" EQU ".nca" ( goto sc3 )
echo Type de fichier non supporté.
pause
goto sc1
:sc2
cls
call :logo
echo .......................................................
echo Tapez "1" pour voir le contenu du xci/nsp
echo Tapez "2" pour obtenir la liste de contenu du xci \ nsp
echo Tapez "3" pour voir les infos de NUT sur le xci/nsp
echo Tapez "4" pour voir les informations sur le jeu et le FIRMWARE requis du xci/nsp
echo Tapez "5" pour lire le CNMT du xci/nsp
echo Input "6" Pour lire le NACP du xci\nsp
echo Tapez "7" pour vérifier le fichier (xci \ nsp \ nsx \ nca)
echo.
echo Tapez "b" pour revenir à la sélection du fichier
echo Tapez "0" pour revenir au menu principal du script --
echo.
echo Ou glissez un autre fichier pour changer de cible.
echo .......................................................
echo.
set /p bs="faites votre choix: "
set bs=%bs:"=%
for /f "delims=" %%a in ("%bs%") do set "Extension=%%~xa"
if "%Extension%" EQU ".*" ( goto wch )
if "%Extension%" EQU ".nsp" ( goto snfi )
if "%Extension%" EQU ".nsx" ( goto snfi )
if "%Extension%" EQU ".xci" ( goto snfi )
if "%Extension%" EQU ".nca" ( goto snfi_nca ) 

if /i "%bs%"=="1" goto g_file_content
if /i "%bs%"=="2" goto g_content_list
if /i "%bs%"=="3" goto n_info
if /i "%bs%"=="4" goto f_info
if /i "%bs%"=="5" goto r_cnmt
if /i "%bs%"=="6" goto r_nacp
if /i "%bs%"=="7" goto verify

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

:g_file_content
cls
call :logo
echo ********************************************************
echo Voir le contenu du NSP ou de la partition SECURE du XCI
echo ********************************************************
%pycommand% "%nut%" -o "%info_dir%" --ADVfilelist "%targt%"
goto sc2

:g_content_list
cls
call :logo
echo ********************************************************
echo AFFICHER LE CONTENU NSP OU XCI ORGANISÉ PAR ID
echo ********************************************************
%pycommand% "%nut%" -o "%info_dir%" --ADVcontentlist "%targt%"
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
echo Afficher les Informations et données sur le firmware requis
echo ********************************************************
%pycommand% "%nut%" -o "%info_dir%" --fw_req "%targt%"
goto sc2

:r_cnmt
cls
call :logo
echo ********************************************************
echo Afficher les données CMT de META NCA dans NSP\XCI
echo ********************************************************
%pycommand% "%nut%" -o "%info_dir%" --Read_cnmt "%targt%"
goto sc2

:r_nacp
cls
call :logo
echo ********************************************************
echo Afficher les données NACP du contrôle NCA dans NSP\XCI
echo *******************************************************
echo Mise en oeuve de la bibliotheque 0LIAM'S NACP
%pycommand% "%nut%" -o "%info_dir%" --Read_nacp "%targt%"
goto sc2

:verify
cls
call :logo
echo ********************************************************
echo Vérification  NSP\XCI\NCA
echo ********************************************************
%pycommand% "%nut%" -b %buffer% -o "%info_dir%" -v "%targt%" 
goto sc2

:sc3
cls
call :logo
echo .......................................................
echo Tapez "1" pour obtenir les infos NUT du fichier xci\nsp
echo Tapez "2" pour lire le CNMT du fichier xci\nsp
echo Tapez "3" pour lire le NACP du fichier xci\nsp
echo Tapez "4" pour vérifier le fichier (xci\nsp\nsx\nca)
echo.
echo Tapez "b" pour revenir au chargement de fichiers
echo Tapez "0" pour revenir au programme principal
echo.
echo --- ou glisser un nouveau fichier pour changer la destination actuelle ---
echo .......................................................
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
for /f "delims=" %%a in ("%bs%") do set "Extension=%%~xa"
if "%Extension%" EQU ".*" ( goto wch_nca )
if "%Extension%" EQU ".nca" ( goto snfi_nca )
if "%Extension%" EQU ".nsp" ( goto snfi )
if "%Extension%" EQU ".nsx" ( goto snfi )
if "%Extension%" EQU ".xci" ( goto snfi )

if /i "%bs%"=="1" goto n_info_nca
if /i "%bs%"=="2" goto r_cnmt_nca
if /i "%bs%"=="3" goto r_nacp_nca
if /i "%bs%"=="4" goto verify_nca

if /i "%bs%"=="b" goto sc1
if /i "%bs%"=="0" goto salida
goto wch

:snfi_nca
for /f "delims=" %%a in ("%bs%") do set "Name=%%~na"
set "targt=%bs%"
goto sc3
:wch_nca
echo Mauvaix choix
pause
goto sc3

:n_info_nca
cls
call :logo
echo ********************************************************
echo NUT - information par BLAWAR
echo ********************************************************
%pycommand% "%nut%" -i "%targt%"
echo.
ECHO ********************************************************
echo Souhaitez-vous copier ces informations dans un fichier texte?
ECHO ********************************************************
:n_info_wrong_nca
echo Tapez "1" pour les copier dans un fichier texte
echo Tapez "2" pour ne pas les copier dans un fichier texte
echo.
set /p bs="Faites votre choix: "
if /i "%bs%"=="1" goto n_info_print_nca
if /i "%bs%"=="2" goto sc3
echo Choix inexistant
echo.
goto n_info_wrong_nca
:n_info_print_nca
if not exist "%info_dir%" MD "%info_dir%">NUL 2>&1
set "i_file=%info_dir%\%Name%-info.txt"
%pycommand% "%nut%" -i "%targt%">"%i_file%"
more +2 "%i_file%">"%i_file%.new"
move /y "%i_file%.new" "%i_file%" >nul
ECHO Terminé
goto sc3

:r_cnmt_nca
cls
call :logo
echo ********************************************************
echo Afficher les données CMT de META NCA dans le fichier NSP\XCI
echo ********************************************************
%pycommand% "%nut%" -o "%info_dir%" --Read_cnmt "%targt%"
goto sc3

:r_nacp_nca
cls
call :logo
echo ********************************************************
echo Afficher les données NACP de contrôle NCA dans le fichier NSP\XCI
echo ********************************************************
echo Mise en oeuve de la bibliotheque 0LIAM'S NACP
%pycommand% "%nut%" -o "%info_dir%" --Read_nacp "%targt%"
goto sc3

:verify_nca
cls
call :logo
echo ********************************************************
echo Vérifier un  NSP \ XCI \ NCA
echo ********************************************************
%pycommand% "%nut%" -b %buffer% -o "%info_dir%" -v "%targt%" 
goto sc3


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
ECHO                      (THE XCI MULTI CONTENT BUILDER AND MORE)
ECHO -------------------------------------------------------------------------------------
ECHO =============================     BY JULESONTHEROAD     =============================
ECHO -------------------------------------------------------------------------------------
ECHO "                                POWERED BY SQUIRREL                                "
ECHO "                    BASED IN THE WORK OF BLAWAR AND LUCA FRAGA                     "
ECHO                                     VERSION %program_version%
ECHO -------------------------------------------------------------------------------------                   
ECHO Program's github: https://github.com/julesontheroad/NSC_BUILDER
ECHO Blawar's github:  https://github.com/blawar
ECHO Blawar's tinfoil: https://github.com/digableinc/tinfoil
ECHO Luca Fraga's github: https://github.com/LucaFraga
ECHO -------------------------------------------------------------------------------------
exit /B