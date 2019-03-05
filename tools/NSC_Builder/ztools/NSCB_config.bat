:sc1
set "op_file=%~1"
set "listmanager=%~2"
set "batdepend=%~3"
cls
call :logo
echo ********************************************************
echo OPTION - CONFIGURATION
echo ********************************************************
echo Tapez "1" pour les options du mode automatique
echo Tapez "2" pour les OPTIONS globales et manuelles.
echo Tapez "3" pour vérifier le fichier de clés.
::echo Input "4" to INSTALL DEPENDENCIES
echo.
echo Tapez "c" pour voir le profile actuel
echo Tapez "d" pour remettre les paramètres par défaut
echo Tapez "0" pour revenir au menu principal du script
echo .......................................................
echo.
set bs=
set /p bs="Faites votre choix: "
if /i "%bs%"=="1" goto sc2
if /i "%bs%"=="2" goto sc3
if /i "%bs%"=="3" goto verify_keys
if /i "%bs%"=="4" goto idepend

if /i "%bs%"=="c" call :curr_set1
if /i "%bs%"=="c" call :curr_set2
if /i "%bs%"=="c" echo.
if /i "%bs%"=="c" pause

if /i "%bs%"=="d" call :def_set1
if /i "%bs%"=="d" call :def_set2
if /i "%bs%"=="d" echo.
if /i "%bs%"=="d" pause

if /i "%bs%"=="0" goto salida
echo Choix inexistant.
echo.
goto sc1

:sc2
cls
call :logo
echo ********************************************************
echo AUTO-MODE - CONFIGURATION
echo ********************************************************
echo Tapez "1" pour changer le paramètre de réempactage
echo Tapez "2" pour changer le traitement d'un répertoire
echo Tapez "3" pour changer la configuration du patchage RSV
echo Tapez "4" pour changer la configuration de la KEYGENERATION (crypto des NCA)
echo.
echo Tapez "c" pour connaître les paramètres du mode automatique
echo Input "d" to set DEFAULT AUTO-MODE SETTINGS
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo .......................................................
echo.
set bs=
set /p bs="Faites votre choix: "
if /i "%bs%"=="1" goto op_repack
if /i "%bs%"=="2" goto op_pfolder
if /i "%bs%"=="3" goto op_RSV
if /i "%bs%"=="4" goto op_KGEN

if /i "%bs%"=="c" call :curr_set1
if /i "%bs%"=="c" echo.
if /i "%bs%"=="c" pause

if /i "%bs%"=="d" call :def_set1
if /i "%bs%"=="d" echo.
if /i "%bs%"=="d" pause
if /i "%bs%"=="d" goto sc1

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida
echo Choix inexistant.
echo.
goto sc2

:op_repack
cls
call :logo
echo *******************************************************
echo Configuration du réempactage
echo *******************************************************
echo Option de réempactage pour le mode automatique
echo .......................................................
echo Tapez "1" pour réempacter en NSP
echo Tapez "2" pour réempacter en XCI
echo Tapez "3" pour réempacter dans les deux formats
echo.
echo Tapez "b" pour revenir au menu de configuration du mode automatique
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo .......................................................
echo.
set bs=
set /p bs="Faites votre choix: "
set "v_rep=none"
if /i "%bs%"=="1" set "v_rep=nsp"
if /i "%bs%"=="2" set "v_rep=xci"
if /i "%bs%"=="3" set "v_rep=both"

if /i "%bs%"=="b" goto sc2
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_rep%"=="none" echo Choix inexistant
if "%v_rep%"=="none" echo.
if "%v_rep%"=="none" goto op_repack

set v_rep="vrepack=%v_rep%"
set v_rep="%v_rep%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "57" -nl "set %v_rep%"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "57" -nl "Line in config was changed to: "
echo.
pause
goto sc2

:op_pfolder
cls
call :logo
echo **********************************************************************
echo traitement de répertoire
echo **********************************************************************
echo Comment traiter un répertoire en mode automatique?
echo ......................................................................
echo Tapez "1" pour réempacter les fichiers du répertoire individuellement (un fichier pour un contenu)
echo Tapez "2" pour réempacter les fichiers du répertoire ensemble (1 fichier incluant tout le contenu)
echo.
echo Tapez "b" pour revenir au menu de configuration du mode automatique
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ......................................................................
echo.
set bs=
set /p bs="Faites votre choix: "
set "v_fold=none"
if /i "%bs%"=="1" set "v_fold=indiv"
if /i "%bs%"=="2" set "v_fold=multi"

if /i "%bs%"=="b" goto sc2
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_fold%"=="none" echo Choix inexistant.
if "%v_fold%"=="none" echo.
if "%v_fold%"=="none" goto op_pfolder

set v_fold="fi_rep=%v_fold%"
set v_fold="%v_fold%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "61" -nl "set %v_fold%" 
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "61" -nl "Line in config was changed to: "
echo.
pause
goto sc2

:op_RSV
cls
call :logo
echo ***************************************************************************
echo Patch de la version du système requise
echo ***************************************************************************
echo Patch de la version du système requise via les meta des NCA en mode automatique
echo ...........................................................................
echo Patch la version du système requise, permettant que la console ne demande pas de mettre à jour sur le firmware requis pour lire le jeu.
echo.
echo Tapez "1" pour patcher la version du système requise dans les  meta NCA
echo Tapez "2" pour ne pas patcher la version du système requise dans les  meta NCA
echo.
echo Tapez "b" pour revenir au menu de configuration du mode automatique
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ...........................................................................
echo.
set bs=
set /p bs="Faites votre choix: "
set "v_RSV=none"
if /i "%bs%"=="1" set "v_RSV=-pv true"
if /i "%bs%"=="2" set "v_RSV=-pv false"

if /i "%bs%"=="b" goto sc2
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_RSV%"=="none" echo Choix inexistant.
if "%v_RSV%"=="none" echo.
if "%v_RSV%"=="none" goto op_RSV

set v_RSV="patchRSV=%v_RSV%"
set v_RSV="%v_RSV%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "41" -nl "set %v_RSV%" 
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "41" -nl "Line in config was changed to: "
echo.
pause
goto sc2

:op_KGEN
cls
call :logo
echo ***************************************************************************
echo Patcher si la KEYGENERATION est plus grande que
echo ***************************************************************************
echo Changer la  KEYGENERATION si elle est plus grande que le numéro configuré ici en mode automatique.
echo ...........................................................................
echo Change la kegeneration et recalcul le keyblock pour utiliser une masterkey inférieur pour décrypter les NCA.
echo.
echo Tapez "f" pour ne pas changer la keygeneration
echo Tapez "0" pour configurer la keygeneration à 0 (FW 1.0)
echo Tapez "1" pour configurer la keygeneration à 1 (FW 2.0-2.3)
echo Tapez "2" pour configurer la keygeneration à 2 (FW 3.0)
echo Tapez "3" pour configurer la keygeneration à 3 (FW 3.0.1-3.02)
echo Tapez "4" pour configurer la keygeneration à 4 (FW 4.0.0-4.1.0)
echo Tapez "5" pour configurer la keygeneration à 5 (FW 5.0.0-5.1.0)
echo Tapez "6" pour configurer la keygeneration à 6 (FW 6.0.0-6.1.0)
echo Tapez "7" pour configurer la keygeneration à 7 (FW 6.2.0)
echo.
echo Tapez "b" pour revenir au menu de configuration du mode automatique
echo Tapez "c" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ...........................................................................
echo.
set bs=
set /p bs="Faites votre choix: "
set "v_KGEN=none"
if /i "%bs%"=="f" set "v_KGEN=-kp false"
if /i "%bs%"=="0" set "v_KGEN=-kp 0"
if /i "%bs%"=="1" set "v_KGEN=-kp 1"
if /i "%bs%"=="2" set "v_KGEN=-kp 2"
if /i "%bs%"=="3" set "v_KGEN=-kp 3"
if /i "%bs%"=="4" set "v_KGEN=-kp 4"
if /i "%bs%"=="5" set "v_KGEN=-kp 5"
if /i "%bs%"=="6" set "v_KGEN=-kp 6"
if /i "%bs%"=="7" set "v_KGEN=-kp 7"

if /i "%bs%"=="b" goto sc2
if /i "%bs%"=="c" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_RSV%"=="none" echo Choix inexistant
if "%v_RSV%"=="none" echo.
if "%v_RSV%"=="none" goto op_RSV

set v_KGEN="vkey=%v_KGEN%"
set v_KGEN="%v_KGEN%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "95" -nl "set %v_KGEN%" 
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "95" -nl "Line in config was changed to: "
echo.
pause
goto sc2

:sc3
cls
call :logo
echo **********************************************
echo configuration des options globales
echo **********************************************
echo Tapez "1" pour changer la couleur du texte et du fond
echo Tapez "2" -pour changer le nom du répertoire de travail (répertoire temporaire)
echo Tapez "3" pour changer le nom du répertoire de sortie
echo Tapez "4" Pour changer le traitement des fichiers DELTA
echo Tapez "5" pour changer la configuration zip (cré ou non un fichier zip contenant les NCA)
echo Tapez "6" pour changer l'option de sortie automatique du script
echo Tapez "7" pour configurer l'affichage du message concernant le réglage de la KEY-GENERATION
echo Tapez "8" pour régler le buffer
echo Tapez "9" pour régler les options EXFAT/FAT32
echo Tapez "10" pour régler comment organiser les fichiers en sortie
echo.
echo Tapez "c" pour voir les paramètres globaux courant
echo Tapez "d" pour remettre les paramètres globaux par défaut
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo.
set bs=
set /p bs="Faites votre choix: "

if /i "%bs%"=="1" goto op_color
if /i "%bs%"=="2" goto op_wfolder
if /i "%bs%"=="3" goto op_ofolder
if /i "%bs%"=="4" goto op_delta
if /i "%bs%"=="5" goto op_zip
if /i "%bs%"=="6" goto op_aexit
if /i "%bs%"=="7" goto op_kgprompt
if /i "%bs%"=="8" goto op_buffer
if /i "%bs%"=="9" goto op_fat
if /i "%bs%"=="10" goto op_oforg

if /i "%bs%"=="c" call :curr_set2
if /i "%bs%"=="c" echo.
if /i "%bs%"=="c" pause

if /i "%bs%"=="d" call :def_set2
if /i "%bs%"=="d" echo.
if /i "%bs%"=="d" pause
if /i "%bs%"=="d" goto sc1

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

echo Choix inexistant.
echo.
goto sc3

:op_color
cls
call :logo
echo ********************************************************
echo configuration des couleurs
echo ********************************************************
echo --------------------------------------------------------
echo Couleur du texte
echo --------------------------------------------------------
echo Tapez "1" pour changer la couleur du texte en blanc clair (défaut)
echo Tapez "2" pour changer la couleur du texte en noir
echo Tapez "3" pour changer la couleur du texte en bleu
echo Tapez "4" pour changer la couleur du texte en vert
echo Tapez "5" pour changer la couleur du texte en AQUA
echo Tapez "6" pour changer la couleur du texte en rouge
echo Tapez "7" pour changer la couleur du texte en pourpre
echo Tapez "8" pour changer la couleur du texte en jaune
echo Tapez "9" pour changer la couleur du texte en blanc
echo Tapez "10" pour changer la couleur du texte en gris
echo Tapez "11" pour changer la couleur du texte en bleu clair
echo Tapez "12" pour changer la couleur du texte en vert clair
echo Tapez "13" pour changer la couleur du texte en AQUA clair
echo Appuyez surt "14" pour changer la couleur du texte en rouge clair
echo Tapez "15" pour changer la couleur du texte en pourpre clair
echo Tapez "16" pour changer la couleur du texte en jaune clair
echo.
echo Tapez "d" pour remettre la couleur du texte par défaut
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo.
set bd=
set /p bd="Faite votre choix: "

set "v_colF=F"
if /i "%bd%"=="1" set "v_colF=F"
if /i "%bd%"=="2" set /a "v_colF=0"
if /i "%bd%"=="3" set /a "v_colF=3"
if /i "%bd%"=="4" set /a "v_colF=1"
if /i "%bd%"=="5" set /a "v_colF=2"
if /i "%bd%"=="6" set /a "v_colF=4"
if /i "%bd%"=="7" set /a "v_colF=5"
if /i "%bd%"=="8" set /a "v_colF=6"
if /i "%bd%"=="9" set /a "v_colF=7"
if /i "%bd%"=="10" set /a "v_colF=8"
if /i "%bd%"=="11" set /a "v_colF=9"
if /i "%bd%"=="12" set "v_colF=A"
if /i "%bd%"=="13" set "v_colF=B"
if /i "%bd%"=="14" set "v_colF=C"
if /i "%bd%"=="15" set "v_colF=D"
if /i "%bd%"=="16" set "v_colF=E"

if /i "%bd%"=="d" set "v_colF=F"
if /i "%bd%"=="d" set /a "v_colB=1"
if /i "%bd%"=="d" goto do_set_col

if /i "%bd%"=="b" goto sc3
if /i "%bd%"=="0" goto sc1
if /i "%bd%"=="e" goto salida

echo -----------------------------------------------------
echo Couleur de fond
echo -----------------------------------------------------
echo Tapez "1" pour changer la couleur de fond en bleu (défaut)
echo Tapez "2" pour changer la couleur de fond en noir
echo Tapez "3" pour changer la couleur de fond en vert
echo Tapez "4" pour changer la couleur de fond en AQUA
echo Tapez "5" pour changer la couleur de fond en rouge
echo Tapez "6" pour changer la couleur de fond en pourpre
echo Tapez "7" pour changer la couleur de fond en jaune
echo Tapez "8" pour changer la couleur de fond en blanc
echo Tapez "9" pour changer la couleur de fond en gris
echo Tapez "10" pour changer la couleur de fond en blanc clair
echo Tapez "11" pour changer la couleur de fond en bleu clair
echo Tapez "12" pour changer la couleur de fond en vert clair
echo Tapez "13" pour changer la couleur de fond en AQUA clair
echo Tapez "14" pour changer la couleur de fond en rouge clair
echo Tapez "15" pour changer la couleur de fond en pourpre clair
echo Tapez "16" pour changer la couleur de fond en jaune clair
echo.
echo Tapez "d" pour remettre la couleur de fond par défaut
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo.
set bs=
set /p bs="Faites votre choix: "

set /a "v_colB=1"
if /i "%bs%"=="1" set /a "v_colB=1"
if /i "%bs%"=="2" set /a "v_colB=0"
if /i "%bs%"=="3" set /a "v_colB=2"
if /i "%bs%"=="4" set /a "v_colB=3"
if /i "%bs%"=="5" set /a "v_colB=4"
if /i "%bs%"=="6" set /a "v_colB=5"
if /i "%bs%"=="7" set /a "v_colB=6"
if /i "%bs%"=="8" set /a "v_colB=7"
if /i "%bs%"=="9" set /a "v_colB=8"
if /i "%bs%"=="10" set "v_colB=F"
if /i "%bs%"=="11" set /a "v_colB=9"
if /i "%bs%"=="12" set "v_colB=A"
if /i "%bs%"=="13" set "v_colB=B"
if /i "%bs%"=="14" set "v_colB=C"
if /i "%bs%"=="15" set "v_colB=D"
if /i "%bs%"=="16" set "v_colB=E"

if /i "%bs%"=="d" set "v_colF=F"
if /i "%bs%"=="d" set /a "v_colB=1"
if /i "%bs%"=="d" goto do_set_col

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

:do_set_col
setlocal enabledelayedexpansion
set "v_col=!v_colB!!v_colF!"
color !v_col!
%pycommand% "%listmanager%" -cl "%op_file%" -ln "3" -nl "color !v_col!"
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "3" -nl "Line in config was changed to: "
endlocal
echo.
pause
goto sc3

:op_wfolder
cls
call :logo
echo ***********************************
echo Configuration du répertoire de travail
echo ***********************************
echo Tapez "1" pour remettre le répertoire de travail par défaut
echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo.
set bs=
set /p bs="Ou entrez un nouveau nom: "
set "v_wf=%bs%"
if /i "%bs%"=="1" set "v_wf=NSCB_temp"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

set v_wf="w_folder=%v_wf%"
set v_wf="%v_wf%"

%pycommand% "%listmanager%" -cl "%op_file%" -ln "8" -nl "set %v_wf%" 
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "8" -nl "Line in config was changed to: "
echo.
pause
goto sc3


:op_ofolder
cls
call :logo
echo *************************************
echo Configuration du répertoire de sortie
echo *************************************
echo Tapez "1" pour remettre le répertoire de sortie par défaut
echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo.
set bs=
set /p bs="Ou entrez un nouveau nom: "
set "v_of=%bs%"
if /i "%bs%"=="1" set "v_of=NSCB_output"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

set v_of="fold_output=%v_of%"
set v_of="%v_of%"

%pycommand% "%listmanager%" -cl "%op_file%" -ln "10" -nl "set %v_of%" 
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "10" -nl "Line in config was changed to: "
echo.
pause
goto sc3


:op_delta
cls
call :logo
echo ***************************************************************************
echo Configuration du traitement des fichiers DELTA
echo ***************************************************************************
echo Passer les fichiers NCA DELTA lors de l'extraction d'une mise à jour
echo ...........................................................................
echo Les deltas servent à convertir une mise à jour précédente vers la nouvelle, les mises à jour peuvent contenir la mise à jour complète et les deltasS. Les deltas sont nossives et non nécessaires pour les  xci, ils peuvent servir à installer un NSP plus rapidement et à convertir une précédente mise à jour vers la nouvelle. Sans les deltas la mise à jour précédente restera dans le système et devra être désinstallée manuellement.
echo.
echo Tapez "1" pour passer les fichiers  deltas (configuration par défaut)
echo Tapez "2" pour réempacter les fichiers deltas
echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ...........................................................................
echo.
set bs=
set /p bs="Faites votre choix: "
set "v_delta=none"
if /i "%bs%"=="1" set "v_delta=--C_clean_ND"
if /i "%bs%"=="2" set "v_delta=--C_clean"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_delta%"=="none" echo Choix inexistant.
if "%v_delta%"=="none" echo.
if "%v_delta%"=="none" goto op_delta

set v_delta="nf_cleaner=%v_delta%"
set v_delta="%v_delta%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "36" -nl "set %v_delta%" 
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "36" -nl "Line in config was changed to: "
echo.
pause
goto sc3

:op_zip
cls
call :logo
echo ***************************************************************************
echo Génération de fichiers zip
echo ***************************************************************************
echo Génère des fichiers ZIP contenant les KEYBLOCK et les informations du fichier
echo ...........................................................................
echo.
echo Tapez "1" pour générer les fichiers zip (configuration par défaut)
echo Tapez "2" pour ne pas générer de fichiers zip
echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ...........................................................................
echo.
set bs=
set /p bs="Faites votre choix: "
set "v_gzip=none"
if /i "%bs%"=="1" set "v_gzip=true"
if /i "%bs%"=="2" set "v_gzip=false"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_gzip%"=="none" echo Choix inexistant.
if "%v_gzip%"=="none" echo.
if "%v_gzip%"=="none" goto op_zip

set v_gzip="zip_restore=%v_gzip%"
set v_gzip="%v_gzip%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "78" -nl "set %v_gzip%" 
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "78" -nl "Line in config was changed to: "
echo.
pause
goto sc3

:op_aexit
cls
call :logo
echo ***************************************************************************
echo Configuration de la sortie automatique du script en mode manuel
echo ***************************************************************************
echo Quitter le script automatiquement à la fin du traitement ou demander d'appuyez sur une touche pour continuer.
echo ...........................................................................
echo.
echo Tapez "1" pour désactiver la sortie automatique (configuration par défaut)
echo Tapez "2" pour activer la sortie automatique
echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ...........................................................................
echo.
set bs=
set /p bs="Faites votre choix: "
set "v_exit=none"
if /i "%bs%"=="1" set "v_exit=false"
if /i "%bs%"=="2" set "v_exit=true"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_exit%"=="none" echo Choix inexistant.
if "%v_exit%"=="none" echo.
if "%v_exit%"=="none" goto op_aexit

set v_exit="va_exit=%v_exit%"
set v_exit="%v_exit%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "101" -nl "set %v_exit%" 
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "101" -nl "Line in config was changed to: "
echo.
pause
goto sc3

:op_kgprompt
cls
call :logo
echo ***************************************************************************
echo Voir ou non le message permettant de configurer la version du système requise et le changement de la KEYGENERATION
echo ***************************************************************************
echo.
echo Tapez "1" pour voir le message de configuration du RSV (option par défaut)
echo Tapez "2" pour ne pas voir le message de configuration du RSV (option par défaut)
echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ...........................................................................
echo.
set bs=
set /p bs="Faites votre choix: "
set "skipRSVprompt=none"
if /i "%bs%"=="1" set "skipRSVprompt=false"
if /i "%bs%"=="2" set "skipRSVprompt=true"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%skipRSVprompt%"=="none" echo Choix inexistant.
if "%skipRSVprompt%"=="none" echo.
if "%skipRSVprompt%"=="none" goto op_kgprompt

set skipRSVprompt="skipRSVprompt=%skipRSVprompt%"
set skipRSVprompt="%skipRSVprompt%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "108" -nl "set %skipRSVprompt%" 
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "108" -nl "Line in config was changed to: "
echo.
pause
goto sc3

:op_buffer
cls
call :logo
echo ***************************************************************************
echo Régler le buffer pour la copie et l'ajout de fichier récupéré ou copier de/vers un NSP\XCI
echo ***************************************************************************
echo Cette option affecte la vitesse de ces processus et dépend de votre système. Le buffer par défaut est réglé à 64kB.
echo.
echo Tapez "1" pour régler le buffer à 80kB
echo Tapez "2" pour régler le buffer à 72kB
echo Tapez "3" pour régler le buffer à 64kB (Default)
echo Tapez "4" pour régler le buffer à 56kB
echo Tapez "5" pour régler le buffer à 48kB
echo Tapez "6" pour régler le buffer à 40kB
echo Tapez "7" pour régler le buffer à 32kB
echo Tapez "8" pour régler le buffer à 24kB
echo Tapez "9" pour régler le buffer à 16kB
echo Tapez "10" pour régler le buffer à 8kB

REM echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ...........................................................................
echo.
set bs=
set /p bs="Faites votre choix: "
set "v_buffer=none"
if /i "%bs%"=="1" set "v_buffer=-b 81920"
if /i "%bs%"=="2" set "v_buffer=-b 73728"
if /i "%bs%"=="3" set "v_buffer=-b 65536"
if /i "%bs%"=="4" set "v_buffer=-b 57344"
if /i "%bs%"=="5" set "v_buffer=-b 49152"
if /i "%bs%"=="6" set "v_buffer=-b 40960"
if /i "%bs%"=="7" set "v_buffer=-b 32768"
if /i "%bs%"=="8" set "v_buffer=-b 24576"
if /i "%bs%"=="9" set "v_buffer=-b 16384"
if /i "%bs%"=="10" set "v_buffer=-b 8192"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_buffer%"=="none" echo Choix inexistant.
if "%v_buffer%"=="none" echo.
if "%v_buffer%"=="none" goto op_buffer

set v_buffer="buffer=%v_buffer%"
set v_buffer="%v_buffer%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "32" -nl "set %v_buffer%" 
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "32" -nl "Line in config was changed to: "
echo.
pause
goto sc3

:op_fat
cls
call :logo
echo ***************************************************************************
echo Régler l'option permettant de générer des fichiers utilisables sur des cartes SD formatées en FAT32
echo ***************************************************************************
echo Le Rommenu de SX OS  supporte les fichiers ns0, ns1,.. pour les fichiers nsp splittés et également les fichiers 00, 01 dans un répertoire noté comme archivé, c'est pour cela que les deux options sont proposées. Les autres installeurs ne supporte quand à eux que l'option des répertoires archivées.
echo.
echo Tapez "1" pour utiliser le format exfat (option par défaut)
echo Tapez "2" pour utiliser le format FAT32 spécifique à SX OS (fichiers xc0 et ns0)
echo Tapez "3" pour utiliser le format FAT32 fat32 pour tous les CFWs (répertoire archivé)

echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ...........................................................................
echo.
set bs=
set /p bs="Faites votre choix: "
set "v_fat1=none"
set "v_fat2=none"
if /i "%bs%"=="1" set "v_fat1=-fat exfat"
if /i "%bs%"=="1" set "v_fat2=-fx files"
if /i "%bs%"=="2" set "v_fat1=-fat fat32"
if /i "%bs%"=="2" set "v_fat2=-fx files"
if /i "%bs%"=="3" set "v_fat1=-fat fat32"
if /i "%bs%"=="3" set "v_fat2=-fx folder"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_fat1%"=="none" echo Choix inexistant.
if "%v_fat1%"=="none" echo.
if "%v_fat1%"=="none" goto op_fat
if "%v_fat2%"=="none" echo WRONG CHOICE
if "%v_fat2%"=="none" echo.
if "%v_fat2%"=="none" goto op_fat

set v_fat1="fatype=%v_fat1%"
set v_fat1="%v_fat1%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "116" -nl "set %v_fat1%" 
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "116" -nl "Line in config was changed to: "
echo.
set v_fat2="fexport=%v_fat2%"
set v_fat2="%v_fat2%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "117" -nl "set %v_fat2%" 
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "117" -nl "Line in config was changed to: "
echo.
pause
goto sc3

:op_oforg
cls
call :logo
echo ***************************************************************************
echo Organisation des fichiers du répertoire de sortie
echo ***************************************************************************
echo.
echo Tapez "1" pour organiser les fichiers séparément (default)
echo Tapez "2" pour organiser les fichiers dans des répertoires selon le contenu
echo.
echo Tapez "b" pour revenir au menu de configuration des paramètres globaux
echo Tapez "0" pour revenir au menu de configuration
echo Tapez "e" pour revenir au menu principal du script
echo ...........................................................................
echo.
set bs=
set /p bs="Faites votre choix: "
set "v_oforg=none"
if /i "%bs%"=="1" set "v_oforg=inline"
if /i "%bs%"=="2" set "v_oforg=subfolder"

if /i "%bs%"=="b" goto sc3
if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="e" goto salida

if "%v_oforg%"=="none" echo Choix inexistant.
if "%v_oforg%"=="none" echo.
if "%v_oforg%"=="none" goto op_oforg

set v_oforg="oforg=%v_oforg%"
set v_oforg="%v_oforg%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "125" -nl "set %v_oforg%" 
echo.
%pycommand% "%listmanager%" -rl "%op_file%" -ln "125" -nl "Line in config was changed to: "
echo.
pause
goto sc3

:def_set1
echo.
echo **Options du mode automatique**
REM vrepack
set "v_rep=both"
set v_rep="vrepack=%v_rep%"
set v_rep="%v_rep%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "57" -nl "set %v_rep%"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "57" -nl "Line in config was changed to: "

REM fi_rep
set "v_fold=multi"
set v_fold="fi_rep=%v_fold%"
set v_fold="%v_fold%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "61" -nl "set %v_fold%" 
%pycommand% "%listmanager%" -rl "%op_file%" -ln "61" -nl "Line in config was changed to: "

REM v_RSV
set "v_RSV=-pv false"
set v_RSV="patchRSV=%v_RSV%"
set v_RSV="%v_RSV%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "41" -nl "set %v_RSV%" 
%pycommand% "%listmanager%" -rl "%op_file%" -ln "41" -nl "Line in config was changed to: "

REM vkey
set "v_KGEN=-kp false"
set v_KGEN="vkey=%v_KGEN%"
set v_KGEN="%v_KGEN%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "95" -nl "set %v_KGEN%" 
%pycommand% "%listmanager%" -rl "%op_file%" -ln "95" -nl "Line in config was changed to: "

exit /B

:def_set2
echo.
echo **Paramètres globaux**
REM OP_COLOR
set "v_colF=F"
set /a "v_colB=1"
setlocal enabledelayedexpansion
set "v_col=!v_colB!!v_colF!"
color !v_col!
%pycommand% "%listmanager%" -cl "%op_file%" -ln "3" -nl "color !v_col!"
%pycommand% "%listmanager%" -rl "%op_file%" -ln "3" -nl "Line in config was changed to: "
endlocal

REM w_folder
set "v_wf=NSCB_temp"
set v_wf="w_folder=%v_wf%"
set v_wf="%v_wf%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "8" -nl "set %v_wf%" 
%pycommand% "%listmanager%" -rl "%op_file%" -ln "8" -nl "Line in config was changed to: "

REM v_of
set "v_of=NSCB_output"
set v_of="fold_output=%v_of%"
set v_of="%v_of%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "10" -nl "set %v_of%" 
%pycommand% "%listmanager%" -rl "%op_file%" -ln "10" -nl "Line in config was changed to: "

REM v_delta
set "v_delta=--C_clean_ND"
set v_delta="nf_cleaner=%v_delta%"
set v_delta="%v_delta%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "36" -nl "set %v_delta%" 
%pycommand% "%listmanager%" -rl "%op_file%" -ln "36" -nl "Line in config was changed to: "

REM zip_restore
set "v_gzip=false"
set v_gzip="zip_restore=%v_gzip%"
set v_gzip="%v_gzip%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "78" -nl "set %v_gzip%" 
%pycommand% "%listmanager%" -rl "%op_file%" -ln "78" -nl "Line in config was changed to: "

REM AUTO-EXIT
set "v_exit=false"
set v_exit="va_exit=%v_exit%"
set v_exit="%v_exit%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "101" -nl "set %v_exit%" 
%pycommand% "%listmanager%" -rl "%op_file%" -ln "101" -nl "Line in config was changed to: "

REM skipRSVprompt
set "skipRSVprompt=false"
set skipRSVprompt="skipRSVprompt=%skipRSVprompt%"
set skipRSVprompt="%skipRSVprompt%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "108" -nl "set %skipRSVprompt%" 
%pycommand% "%listmanager%" -rl "%op_file%" -ln "108" -nl "Line in config was changed to: "

REM buffer
set "v_buffer=buffer=-b 65536"
set v_buffer="buffer=%v_buffer%"
set v_buffer="%v_buffer%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "32" -nl "set %v_buffer%" 
%pycommand% "%listmanager%" -rl "%op_file%" -ln "32" -nl "Line in config was changed to: "


REM FAT format
set "v_fat1=-fat exfat"
set v_fat1="fatype=%v_fat1%"
set v_fat1="%v_fat1%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "116" -nl "set %v_fat1%" 
%pycommand% "%listmanager%" -rl "%op_file%" -ln "116" -nl "Line in config was changed to: "

set "v_fat2=-fx files"
set v_fat2="fexport=%v_fat2%"
set v_fat2="%v_fat2%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "117" -nl "set %v_fat2%" 
%pycommand% "%listmanager%" -rl "%op_file%" -ln "117" -nl "Line in config was changed to: "

REM OUTPUT ORGANIZING format
set "v_oforg=inline"
set v_oforg="oforg=%v_oforg%"
set v_oforg="%v_oforg%"
%pycommand% "%listmanager%" -cl "%op_file%" -ln "125" -nl "set %v_oforg%" 
%pycommand% "%listmanager%" -rl "%op_file%" -ln "125" -nl "Line in config was changed to: "

exit /B

:curr_set1
echo.
echo **Paramètres actuels du mode automatique**
REM vrepack
%pycommand% "%listmanager%" -rl "%op_file%" -ln "57" -nl "File repack is set to: "

REM fi_rep
%pycommand% "%listmanager%" -rl "%op_file%" -ln "61" -nl "Folder processing is set to: "

REM v_RSV
%pycommand% "%listmanager%" -rl "%op_file%" -ln "41" -nl "RequiredSystemVersion patching is set to: "

REM vkey
%pycommand% "%listmanager%" -rl "%op_file%" -ln "95" -nl "Keygeneration variable is set to: "

exit /B

:curr_set2
echo.
echo **Paramètres courant des paramètres globaux**
REM OP_COLOR
%pycommand% "%listmanager%" -rl "%op_file%" -ln "3" -nl "Color is set to: "
endlocal

REM w_folder
%pycommand% "%listmanager%" -rl "%op_file%" -ln "8" -nl "Work Folder is set to: "

REM v_of
%pycommand% "%listmanager%" -rl "%op_file%" -ln "10" -nl "Output Folder is set to: "

REM v_delta
%pycommand% "%listmanager%" -rl "%op_file%" -ln "36" -nl "Delta Skipping is set to: "

REM zip_restore
%pycommand% "%listmanager%" -rl "%op_file%" -ln "78" -nl "Zip generation is set to: "

REM AUTO-EXIT
%pycommand% "%listmanager%" -rl "%op_file%" -ln "101" -nl "Auto-exit is set to: "

REM skipRSVprompt
%pycommand% "%listmanager%" -rl "%op_file%" -ln "108" -nl "Skip RSV selection is set to: "

REM buffer
%pycommand% "%listmanager%" -rl "%op_file%" -ln "32" -nl "Buffer is set to: "

REM FAT format
%pycommand% "%listmanager%" -rl "%op_file%" -ln "116" -nl "SD File Format is set to: "
%pycommand% "%listmanager%" -rl "%op_file%" -ln "117" -nl "Split nsp format is set to: "
REM OUTPUT ORGANIZING format
%pycommand% "%listmanager%" -rl "%op_file%" -ln "125" -nl "Output organization is set to: "

exit /B

:verify_keys
cls
call :logo
echo ***************************************************************************
echo Vérification des clés dans le fichier KEYS.TXT avec les HASHES SHA256 des bonnes clés
echo ***************************************************************************

%pycommand% "%nut%" -nint_keys "%dec_keys%"

echo ...........................................................................
echo Tapez "0" pour revenir au menu de configuration.
echo Tapez "1" pour revenir au menu principal.
echo ...........................................................................
echo.
set bs=
set /p bs="Enter your choice: "
set bs=%bs:"=%

if /i "%bs%"=="0" goto sc1
if /i "%bs%"=="1" goto salida

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
ECHO                                  VERSION %program_version%
ECHO -------------------------------------------------------------------------------------                   
ECHO Program's github: https://github.com/julesontheroad/NSC_BUILDER
ECHO Blawar's github:  https://github.com/blawar
ECHO Blawar's tinfoil: https://github.com/digableinc/tinfoil
ECHO Luca Fraga's github: https://github.com/LucaFraga
ECHO -------------------------------------------------------------------------------------
exit /B

:idepend
cls
call :logo
call "%batdepend%"
goto sc1