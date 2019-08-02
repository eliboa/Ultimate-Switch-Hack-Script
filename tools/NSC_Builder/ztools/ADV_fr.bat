@ECHO OFF
:TOP_INIT
CD /d "%prog_dir%"

REM //////////////////////////////////////////////////
REM /////////////////////////////////////////////////
REM Mode avancé
REM /////////////////////////////////////////////////
REM ////////////////////////////////////////////////
:normalmode
cls
call :program_logo
echo -------------------------------------------------
echo Mode avancé activé
echo -------------------------------------------------
if exist "advlist.txt" goto prevlist
goto manual_INIT
:prevlist
set conta=0
for /f "tokens=*" %%f in (advlist.txt) do (
echo %%f
) >NUL 2>&1
setlocal enabledelayedexpansion
for /f "tokens=*" %%f in (advlist.txt) do (
set /a conta=!conta! + 1
) >NUL 2>&1
if !conta! LEQ 0 ( del advlist.txt )
endlocal
if not exist "advlist.txt" goto manual_INIT
ECHO .............................................................................
ECHO Une liste précédente à été trouvée. Que souhaitez-vous faire?
:prevlist0
ECHO .............................................................................
echo Tapez "1" pour démarrer automatiquement le traitement de la liste précédente
echo Tapez "2" pour effacer la liste et en créer une nouvelle.
echo Tapez "3" pour continuer à construire la liste précédente
echo .............................................................................
echo NOTE: En appuyant sur 3, vous verrez la liste précédente 
echo avant de commencer le traitement des fichiers et vous pourrez 
echo ajouter et supprimer des éléments de la liste
echo.
ECHO *************************************************
echo Ou Tapez "0" pour revenir au menu du mode de sélection
ECHO *************************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="3" goto showlist
if /i "%bs%"=="2" goto delist
if /i "%bs%"=="1" goto start_cleaning
if /i "%bs%"=="0" exit /B
echo.
echo Choix inexistant.
goto prevlist0
:delist
del advlist.txt
cls
call :program_logo
echo -------------------------------------------------
echo Mode avancé activé
echo -------------------------------------------------
echo ..................................
echo Vous avez décidé de commencer une nouvelle liste
echo ..................................

:manual_INIT
endlocal
ECHO ******************************************************
echo Ou Tapez "0" pour revenir au menu du mode de sélection
ECHO ******************************************************
echo.
%pycommand% "%nut%" -t nsp xci nsx -tfile "%prog_dir%advlist.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal
if /i "%eval%"=="0" exit /B
goto checkagain
echo.
:checkagain
echo Que souhaitez-vous faire?
echo ..............................................................................................
echo "Déposez un autre fichier ou dossier et appuyez sur enter pour ajouter des fichiers à la liste"
echo.
echo Tapez "1" pour commencer le traitement
echo Tapez "e" Pour sortir
echo Tapez "i" pour voir la liste des fichiers à traiter
echo Tapez "r" pour supprimer des fichiers (en partant du bas)
echo Tapez "z" pour effacer toute la liste
echo ..............................................................................................
ECHO *************************************************
echo Ou Tapez "0" pour revenir au menu du mode de sélection
ECHO *************************************************
echo.
%pycommand% "%nut%" -t nsp xci -tfile "%prog_dir%advlist.txt" -uin "%uinput%" -ff "uinput"
set /p eval=<"%uinput%"
set eval=%eval:"=%
setlocal enabledelayedexpansion
echo+ >"%uinput%"
endlocal

if /i "%eval%"=="0" exit /B
if /i "%eval%"=="1" goto start_cleaning
if /i "%eval%"=="e" goto salida
if /i "%eval%"=="i" goto showlist
if /i "%eval%"=="r" goto r_files
if /i "%eval%"=="z" del advlist.txt

goto checkagain

:r_files
set /p bs="Entrez le nombre de fichiers à supprimer de la liste en partant du bas: "
set bs=%bs:"=%

setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (advlist.txt) do (
set /a conta=!conta! + 1
)

set /a pos1=!conta!-!bs!
set /a pos2=!conta!
set string=

:update_list1
if !pos1! GTR !pos2! ( goto :update_list2 ) else ( set /a pos1+=1 )
set string=%string%,%pos1%
goto :update_list1 
:update_list2
set string=%string%,
set skiplist=%string%
Set "skip=%skiplist%"
setlocal DisableDelayedExpansion
(for /f "tokens=1,*delims=:" %%a in (' findstr /n "^" ^<advlist.txt'
) do Echo=%skip%|findstr ",%%a," 2>&1>NUL ||Echo=%%b
)>advlist.txt.new
endlocal
move /y "advlist.txt.new" "advlist.txt" >nul
endlocal

:showlist
cls
call :program_logo
echo -------------------------------------------------
echo Mode avancé activé
echo -------------------------------------------------
ECHO -------------------------------------------------
ECHO                 Fichiers à traiter 
ECHO -------------------------------------------------
for /f "tokens=*" %%f in (advlist.txt) do (
echo %%f
)
setlocal enabledelayedexpansion
set conta=
for /f "tokens=*" %%f in (advlist.txt) do (
set /a conta=!conta! + 1
)
echo .................................................
echo Vous avez ajouté !conta! fichiers à traiter
echo .................................................
endlocal

goto exit /B

:s_cl_wrongchoice
echo Choix inexistant
echo ............
:start_cleaning
echo *******************************************************
echo CHOISISSEZ COMMENT TRAITER LES FICHIERS
echo *******************************************************
echo Tapez "1" pour extraire les fichiers nca
echo Tapez "2" pour l'extraction brute (à utiliser si un nca donne une erreur)
echo Tapez "3" pour extraire tous les fichiers nca en texte clair
echo Tapez "4" pour extraire le contenu nca du nsp \ xci
echo Tapez "5" pour patcher la demande de compte lié
echo.
ECHO ******************************************
echo Ou tapez "b" pour revenir aux options de la liste
ECHO ******************************************
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
set vrepack=none
if /i "%bs%"=="b" goto checkagain
if /i "%bs%"=="1" goto extract
if /i "%bs%"=="2" goto raw_extract
if /i "%bs%"=="3" goto ext_plaintext
if /i "%bs%"=="4" goto ext_fromnca
if /i "%bs%"=="5" goto patch_lnkacc
if %vrepack%=="none" goto s_cl_wrongchoice


:extract
cls
call :program_logo
echo ********************************************************
echo Extraire tous le fichiers d'une NSP/XCI
echo ********************************************************
CD /d "%prog_dir%"
for /f "tokens=*" %%f in (advlist.txt) do (

%pycommand% "%nut%" %buffer% -o "%prog_dir%NSCB_extracted" -tfile "%prog_dir%advlist.txt" -x ""

more +1 "advlist.txt">"advlist.txt.new"
move /y "advlist.txt.new" "advlist.txt" >nul
call :contador_NF
)
ECHO -------------------------------------------------------------
ECHO *********** Tous les fichiers ont été traités!! *************
ECHO -------------------------------------------------------------
goto s_exit_choice

:raw_extract
cls
call :program_logo
echo ********************************************************
echo Extraire tous les fichiers d'une nsp/XCI en mode brut
echo ********************************************************
CD /d "%prog_dir%"
for /f "tokens=*" %%f in (advlist.txt) do (

%pycommand% "%nut%" %buffer% -o "%prog_dir%NSCB_extracted" -tfile "%prog_dir%advlist.txt" -raw_x ""

more +1 "advlist.txt">"advlist.txt.new"
move /y "advlist.txt.new" "advlist.txt" >nul
call :contador_NF
)
ECHO -------------------------------------------------------------
ECHO *********** Tous les fichiers ont été traités!! *************
ECHO -------------------------------------------------------------
goto s_exit_choice

:ext_plaintext
cls
call :program_logo
echo ************************************************************
echo Etraire tous les fichiers d'un NSP/XCI dans un fichier texte 
echo ************************************************************
CD /d "%prog_dir%"
for /f "tokens=*" %%f in (advlist.txt) do (

%pycommand% "%nut%" %buffer% -o "%prog_dir%NSCB_extracted" -tfile "%prog_dir%advlist.txt" -plx ""

more +1 "advlist.txt">"advlist.txt.new"
move /y "advlist.txt.new" "advlist.txt" >nul
call :contador_NF
)
ECHO -------------------------------------------------------------
ECHO *********** Tous les fichiers ont été traités!! *************
ECHO -------------------------------------------------------------
goto s_exit_choice

:ext_fromnca
cls
call :program_logo
echo ********************************************************
echo Extraire les fichiers NCA internes d'une NSP/XCI
echo ********************************************************
CD /d "%prog_dir%"
for /f "tokens=*" %%f in (advlist.txt) do (

%pycommand% "%nut%" %buffer% -o "%prog_dir%NSCB_extracted" -tfile "%prog_dir%advlist.txt" -nfx ""

more +1 "advlist.txt">"advlist.txt.new"
move /y "advlist.txt.new" "advlist.txt" >nul
call :contador_NF
)
ECHO ---------------------------------------------------
ECHO *********** Tous les fichiers ont été traités! *************
ECHO ---------------------------------------------------
goto s_exit_choice

:patch_lnkacc
cls
call :program_logo
echo ********************************************************
echo Patcher une demande de compte lié
echo ********************************************************
CD /d "%prog_dir%"
for /f "tokens=*" %%f in (advlist.txt) do (

%pycommand% "%nut%" %buffer% -tfile "%prog_dir%advlist.txt" --remlinkacc ""

more +1 "advlist.txt">"advlist.txt.new"
move /y "advlist.txt.new" "advlist.txt" >nul
call :contador_NF
)
ECHO ---------------------------------------------------
ECHO *********** Tous les fichiers ont été traités! *************
ECHO ---------------------------------------------------
goto s_exit_choice


:s_exit_choice
if exist advlist.txt del advlist.txt
if /i "%va_exit%"=="true" echo Le programme va fermé maintenant
if /i "%va_exit%"=="true" ( PING -n 2 127.0.0.1 >NUL 2>&1 )
if /i "%va_exit%"=="true" goto salida
echo.
echo Tapez "0" pour revenir au mode de sélection
echo Tapez "1" pour quitter le programme
echo.
set /p bs="Faites votre choix: "
set bs=%bs:"=%
if /i "%bs%"=="0" goto manual_Reentry
if /i "%bs%"=="1" goto salida
goto s_exit_choice

:contador_NF
setlocal enabledelayedexpansion
set /a conta=0
for /f "tokens=*" %%f in (advlist.txt) do (
set /a conta=!conta! + 1
)
echo ...................................................
echo Encore !conta! fichiers à traiter
echo ...................................................
PING -n 2 127.0.0.1 >NUL 2>&1
set /a conta=0
endlocal
exit /B



::///////////////////////////////////////////////////
::SUBROUTINES
::///////////////////////////////////////////////////

:squirrell
echo                    ,;:;;,
echo                   ;;;;;
echo           .=',    ;:;;:,
echo          /_', "=. ';:;:;
echo          @=:__,  \,;:;:'
echo            _(\.=  ;:;;'
echo           `"_(  _/="`
echo            `"'		
exit /B

:program_logo

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

:delay
PING -n 2 127.0.0.1 >NUL 2>&1
exit /B

:thumbup
echo.
echo    /@
echo    \ \
echo  ___\ \
echo (__O)  \
echo (____@) \
echo (____@)  \
echo (__o)_    \
echo       \    \
echo.
echo Bon amusement
exit /B


:salida
exit /B


