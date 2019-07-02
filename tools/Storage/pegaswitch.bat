::script by shadow256
@echo off
chcp 65001 >nul
Setlocal enabledelayedexpansion
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
echo Ce script va permettre de préparer le nécessaire pour utiliser l'exploit Nereba et Cafeine ou plus exactement d'utiliser PegaSwitch ou PegaScape via un serveur local.
echo Pour utiliser un CFW ou plus généralement préparer correctement une SD, veuillez en premier lieu préparer une SD via le script approprié (ce choix sera proposé dans la suite de ce script).
pause
:set_nereba_choice
echo.
echo Que souhaitez-vous faire?
echo 1: Préparer la SD avec les exploits.
echo 2: Lancer le serveur Pegaswitch ou PegaScape.
echo 3: Préparer la SD avec les exploits puis lancer le serveur.
echo 0: Lancer le script de préparation d'une SD pour, entre autres, installer un CFW sur celle-ci.
echo Tout autre choix: Revenir au menu précédent.
echo.
set nereba_choice=
set /p nereba_choice=Faites votre choix: 
IF "%nereba_choice%"=="1" (
	call :prepare_sd
	goto:set_nereba_choice
)
IF "%nereba_choice%"=="2" (
	call :launch_server
	goto:set_nereba_choice
)
IF "%nereba_choice%"=="3" (
	call :prepare_sd
	call :launch_server
	goto:set_nereba_choice
)
IF "%nereba_choice%"=="0" (
	call tools\storage\prepare_sd_switch.bat
mkdir templogs
	goto:set_nereba_choice
)
goto:end_script

:prepare_sd
:define_volume_letter
%windir%\system32\wscript //Nologo //B TOOLS\Storage\functions\list_volumes.vbs
TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\volumes_list.txt >templogs\count.txt
set /p tempcount=<templogs\count.txt
del /q templogs\count.txt
IF "%tempcount%"=="0" (
	echo Aucun disque compatible trouvé. Veuillez insérer votre carte SD puis relancez le script.
	echo Le script va maintenant s'arrêté.
	goto:endscript
)
echo.
echo Liste des disques:
:list_volumes
IF "%tempcount%"=="0" goto:set_volume_letter
TOOLS\gnuwin32\bin\tail.exe -%tempcount% <templogs\volumes_list.txt | TOOLS\gnuwin32\bin\head.exe -1
set /a tempcount-=1
goto:list_volumes
:set_volume_letter
echo.
echo.
set volume_letter=
set /p volume_letter=Entrez la lettre du volume de la SD que vous souhaitez utiliser ou entrez "0" pour annuler la préparation de la SD pour Nereba:
call TOOLS\Storage\functions\strlen.bat nb "%volume_letter%"
IF %nb% EQU 0 (
	echo La lettre de lecteur ne peut être vide. Réessayez.
	goto:define_volume_letter
)
set volume_letter=%volume_letter:~0,1%
IF "%volume_letter%"=="0" goto:set_nereba_choice
set nb=1
CALL TOOLS\Storage\functions\CONV_VAR_to_MAJ.bat volume_letter
set i=0
:check_chars_volume_letter
IF %i% LSS %nb% (
	set check_chars_volume_letter=0
	FOR %%z in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
		IF "!volume_letter:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars_volume_letter=1
			goto:check_chars_volume_letter
		)
	)
	IF "!check_chars_volume_letter!"=="0" (
		echo Un caractère non autorisé a été saisie dans la lettre du lecteur. Recommencez.
		set volume_letter=
		goto:define_volume_letter
	)
)
IF NOT EXIST "%volume_letter%:\" (
	echo Ce volume n'existe pas. Recommencez.
	set volume_letter=
	goto:define_volume_letter
)
TOOLS\gnuwin32\bin\grep.exe "Lettre volume=%volume_letter%" <templogs\volumes_list.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 1 | TOOLS\gnuwin32\bin\cut.exe -d = -f 2 > templogs\tempvar.txt
set /p temp_volume_letter=<templogs\tempvar.txt
IF NOT "%volume_letter%"=="%temp_volume_letter%" (
	echo Cette lettre de volume n'est pas dans la liste. Recommencez.
	goto:define_volume_letter
)
:list_payloads
echo.
echo Sélectionnez le payload qui sera lancé par l'exploit Cafeine/Nereba:
copy nul templogs\payload_list.txt
set max_payload=1
cd Payloads
for %%z in (*.bin) do (
	echo !max_payload!: %%z >>..\templogs\payloads_list.txt
	set /a max_payload+=1
)
cd ..
:select_payload
TOOLS\gnuwin32\bin\tail.exe -q -n+0 templogs\payloads_list.txt
echo 0: Choisir un fichier de payload
echo N'importe quel autre choix: Annuler la préparation de la SD pour Nereba.
echo.
set /p payload_number=Entrez le numéro du payload à lancer:
IF "%payload_number%"=="" goto:set_nereba_choice
call TOOLS\Storage\functions\strlen.bat nb "%payload_number%"
set i=0
:check_chars_payload_number
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!payload_number:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_payload_number
		)
	)
	IF "!check_chars!"=="0" (
		goto:set_nereba_choice
	)
)
IF "%payload_number%"=="0" (
	%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichier de payload Switch (*.bin)|*.bin|" "Sélection du payload" "templogs\tempvar.txt"
	set /p payload_path=<templogs\tempvar.txt
)
IF "%payload_number%"=="0" (
	IF "%payload_path%"=="" (
		echo Aucun payload sélectionné, retour à la sélection de payloads.
		set payload_number=
		goto:select_payload
	)
	goto:copy_nereba
)
TOOLS\gnuwin32\bin\grep.exe "%payload_number%: " <templogs\payloads_list.txt | TOOLS\gnuwin32\bin\cut.exe -d : -f 2 > templogs\tempvar.txt
set /p payload_path=<templogs\tempvar.txt
IF "%payload_path%"=="" (
	goto:set_nereba_choice
)
set payload_path=%payload_path:~1,-1%
:copy_nereba
"%windir%\system32\robocopy.exe" tools\sd_switch\pegaswitch %volume_letter%:\ /e >nul
IF NOT EXIST "%volume_letter%:\nereba\*.*" mkdir "%volume_letter%:\nereba" >nul
copy /v "%payload_path%" "%volume_letter%:\nereba\nereba.bin" >nul
copy /v "tools\sd_switch\mixed\base\hbmenu.nro" %volume_letter%:\ >nul
copy /v "tools\sd_switch\atmosphere\atmosphere\hbl.nsp" "%volume_letter%:\pegascape"
IF NOT EXIST "%volume_letter%:\atmosphere\*.*" mkdir "%volume_letter%:\atmosphere" >nul
copy /v "tools\sd_switch\atmosphere\atmosphere\hbl.nsp" "%volume_letter%:\atmosphere"
echo Préparation de la SD terminée.
pause
exit /b

:launch_server
echo Quel serveur souhaitez-vous utiliser?
echo
echo 1: PegaScape (recommandé)?
echo 2: PegaSwitch?
echo N'importe quel autre choix: Ne pas lancer le serveur et revenir au menu précédent.
echo.
set pegaswitch_server_type=
set /p pegaswitch_server_type=Faites votre choix: 
IF "%pegaswitch_server_type%"=="1" goto:define_pegaswitch_launch_mode
IF "%pegaswitch_server_type%"=="2" goto:define_pegaswitch_launch_mode
exit /b
:define_pegaswitch_launch_mode
echo Comment souhaitez-vous utiliser PegaSwitch/PegaScape?
echo.
echo 1: Via le test de connexion Wifi (firmware 2.0.0 et supérieur)?
echo 2: Via la webapplet (firmware 1.0.0 et la version japonaise de Puyo Puyo Tetris ou si vous utiliser le point d'entrée Fake News)?
echo N'importe quel autre choix: Ne pas lancer le serveur et revenir au menu précédent.
echo.
set pegaswitch_launch_mode=
set /p pegaswitch_launch_mode=Faites votre choix: 
IF "%pegaswitch_launch_mode%"=="1" goto:continue_launch_server
IF "%pegaswitch_launch_mode%"=="2" goto:continue_launch_server
exit /b
:continue_launch_server
echo Vous aurez besoin de connaître l'IP de votre PC et de la recopier dans les DNS de la console pour accéder au serveur.
echo La console et le PC doivent se trouver sur le même réseau.
echo.
echo Préparation et lancement du serveur...
call :write_begin_node.js_launch_file
IF "%pegaswitch_server_type%"=="1" echo cd Pegascape>>tools\Node.js_programs\App\Server.cmd
IF "%pegaswitch_server_type%"=="2" echo cd Pegaswitch>>tools\Node.js_programs\App\Server.cmd
echo npm.cmd install>>tools\Node.js_programs\App\Server.cmd
tools\Node.js_programs\NodeJSPortable.exe
call :write_begin_node.js_launch_file
IF "%pegaswitch_server_type%"=="1" echo cd Pegascape>>tools\Node.js_programs\App\Server.cmd
IF "%pegaswitch_server_type%"=="2" echo cd Pegaswitch>>tools\Node.js_programs\App\Server.cmd
IF "%pegaswitch_launch_mode%"=="1" echo npm.cmd start>>tools\Node.js_programs\App\Server.cmd
IF "%pegaswitch_launch_mode%"=="2" echo npm.cmd start --webapplet>>tools\Node.js_programs\App\Server.cmd
start tools\Node.js_programs\NodeJSPortable.exe
echo Le serveur pour Pegaswitch devrait être lancé. Pour le fermer, tapper la commande "exit" sans les guillemets dans la fenêtre du serveur.
pause
del /q tools\Node.js_programs\App\Server.cmd
copy tools\Node.js_programs\App\Server.cmd.orig tools\Node.js_programs\App\Server.cmd >nul
exit /b

:write_begin_node.js_launch_file
echo @echo off>tools\Node.js_programs\App\Server.cmd
echo title NodeJS>>tools\Node.js_programs\App\Server.cmd
echo cls>>tools\Node.js_programs\App\Server.cmd
echo echo.>>tools\Node.js_programs\App\Server.cmd
echo echo Node>>tools\Node.js_programs\App\Server.cmd
echo node --version>>tools\Node.js_programs\App\Server.cmd
echo echo.>>tools\Node.js_programs\App\Server.cmd
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal