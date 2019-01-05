::Script by Shadow256
Setlocal enabledelayedexpansion
chcp 1252 > nul
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
echo Ce script va permettre d'installer et de lancer le nécessaire pour utiliser le jeu en réseau alternatif de la Switch.
echo Pour plus d'informations sur le sujet, choisissez d'ouvrir la documentation lorsque cela sera proposé.
pause
echo.
:select_install
echo Que souhaitez-vous faire:
echo.
echo 1: Lancer le client?
echo 2: Installation de Winpcap (à ne faire qu'une seule fois)?
echo 0: Lancer la documentation?
echo N'importe quel autre choix: Revenir au menu précédent.
echo.
set /p install_choice=Votre choix: 
IF NOT "%install_choice%"=="" set install_choice=%install_choice:~0,1%
IF "%install_choice%"=="1" goto:launch_client
IF "%install_choice%"=="2" goto:install_winpcap
IF "%install_choice%"=="0" goto:launch_doc
goto:finish_script
:launch_client
set install_choice=
echo.
echo Que souhaitez-vous faire:
echo.
echo 1: Lancer le client en mode interactif (recommandé)?
echo 2: Se connecter à un serveur stocké dans une liste?
echo 3: Gérer la liste des serveurs?
echo N'importe quel autre choix: Terminer ce script et revenir au menu précédent?
echo.
set /p launch_client_choice=Votre choix: 
IF NOT "%launch_client_choice%"=="" set launch_client_choice=%launch_client_choice:~0,1%
IF "%launch_client_choice%"=="1" goto:load_client
IF "%launch_client_choice%"=="2" goto:server_select
IF "%launch_client_choice%"=="3" goto:servers_manage
goto:finish_script
:server_select
set server_name=
set server_addr=
set selected_server=
IF NOT EXIST "tools\netplay\servers_list.txt" (
	echo La liste de serveurs n'existe pas, le client sera donc lancé en mode interactif.
	pause
	goto:load_client
)
TOOLS\gnuwin32\bin\grep.exe -c "" <tools\netplay\servers_list.txt > templogs\tempvar.txt
set /p count_server=<templogs\tempvar.txt
IF %count_server% EQU 0 (
	IF "%launch_client_choice%"=="2" (
		goto:load_client
	) else IF "%launch_client_choice%"=="3" (
		goto:servers_manage
	)
)
echo.
echo Choisir un serveur:
echo.
set /a temp_count=0
:server_listing
set /a temp_count+=1
IF %temp_count% GTR %count_server% (
	goto:finish_server_listing
)
TOOLS\gnuwin32\bin\sed.exe -n %temp_count%p <tools\netplay\servers_list.txt >templogs\tempvar.txt
set /p temp_server=<templogs\tempvar.txt
echo %temp_count%: %temp_server%
goto:server_listing
:finish_server_listing
IF "%launch_client_choice%"=="2" echo N'importe quel autre choix: Lancer le client en mode interactif.
IF "%launch_client_choice%"=="3" echo N'importe quel autre choix: Revenir à l'action à faire dans la gestion des serveurs.
echo.
set /p selected_server=Choisir votre serveur: 
IF "%launch_client_choice%"=="2" (
	IF "%selected_server%"=="" goto:load_client
) else IF "%launch_client_choice%"=="3" (
	IF "%selected_server%"=="" goto:servers_manage
)
call TOOLS\Storage\functions\strlen.bat nb "%selected_server%"
set i=0
:check_chars_selected_server
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!selected_server:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_selected_server
		)
	)
	IF "%launch_client_choice%"=="2" (
		IF "!check_chars!"=="0" (
			goto:load_client
		)
	else IF "%launch_client_choice%"=="3" (
		IF "!check_chars!"=="0" (
			goto:servers_manage
		)
	)
)
TOOLS\gnuwin32\bin\sed.exe -n %selected_server%p <tools\netplay\servers_list.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 2 > templogs\tempvar.txt
set /p server_addr=<templogs\tempvar.txt
IF NOT "%server_addr%"=="" (
	set server_addr=%server_addr:~1%
	IF "%launch_client_choice%"=="2" (
		set server_addr=--relay-server-addr !server_addr!
	) else IF "%launch_client_choice%"=="3" (
		TOOLS\gnuwin32\bin\sed.exe -n %selected_server%p <tools\netplay\servers_list.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 1 > templogs\tempvar.txt
		set /p server_name=<templogs\tempvar.txt
	)
) else (
	IF "%launch_client_choice%"=="2" (
		echo Le serveur sélectionné n'existe pas dans la liste, le client sera donc lancé en mode interactif.
		pause
		goto:load_client
	) else IF "%launch_client_choice%"=="3" (
		echo Le serveur sélectionné n'existe pas dans la liste, retour aux actions de la gestion des serveurs.
		pause
		goto:servers_manage
	)
)
IF "%launch_client_choice%"=="3" (
	IF "%manage_choice%"=="2" goto:modify_server
	IF "%manage_choice%"=="3" goto:del_server
)
:load_client
start tools\netplay\lan-play.exe %server_addr%
goto:select_install
:servers_manage
set manage_choice=
set install_choice=
set new_server_name=
set new_server_addr=
IF NOT EXIST "tools\netplay\servers_list.txt" (
	copy nul "tools\netplay\servers_list.txt"
)
echo.
echo Que souhaitez-vous faire:
echo.
echo 1: Ajouter un serveur?
echo 2: Modifier un serveur?
echo 3: Supprimer un serveur?
echo N'importe quel autre choix: Quitter la gestion des serveurs.
echo.
set /p manage_choice=Votre choix: 
IF NOT "%manage_choice%"=="" set manage_choice=%manage_choice:~0,1%
IF "%manage_choice%"=="1" goto:add_server
IF "%manage_choice%"=="2" goto:server_select
IF "%manage_choice%"=="3" goto:server_select
goto:select_install
:add_server
set /p new_server_name=Entrez le nom du serveur: 
IF "%new_server_name%"=="" (
	echo Le nom du serveur ne peut être vide, l'ajout est annulé.
	pause
	goto:servers_manage
)
set "new_server_name=%new_server_name:"=%"
set "new_server_name=%new_server_name:;=%"
set "new_server_name=%new_server_name:|=%"
call TOOLS\Storage\functions\strlen.bat nb "%new_server_name%"
set i=0
:check_chars_new_server_name_1
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^^ ^\ ^( ^)) do (
		::echo %%z !new_server_name:~%i%,1!
		IF "!new_server_name:~%i%,1!"=="%%z" (
			echo Un caractère non autorisé a été saisie dans le nom du serveur, l'ajout est annulé.
			goto:servers_manage
		)
	)
	set /a i+=1
	goto:check_chars_new_server_name_1
)
set /p new_server_addr=Entrez l'adresse du serveur: 
IF "%new_server_addr%"=="" (
	echo L'adresse du serveur ne peut être vide, l'ajout est annulé.
	pause
	goto:servers_manage
)
set "new_server_addr=%new_server_addr:"=%"
set "new_server_addr=%new_server_addr:;=%"
set "new_server_addr=%new_server_addr:|=%"
call TOOLS\Storage\functions\strlen.bat nb "%new_server_addr%"
set i=0
:check_chars_new_server_addr_1
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^^ ^\ ^( ^)) do (
		IF "!new_server_addr:~%i%,1!"=="%%z" (
			echo Un caractère non autorisé a été saisie dans l'adresse du serveur, l'ajout est annulé.
			goto:servers_manage
		)
	)
	set /a i+=1
	goto:check_chars_new_server_addr_1
)
echo %new_server_name%; %new_server_addr%>> tools\netplay\servers_list.txt
echo Serveur ajouté.
pause
set manage_choice=
goto:servers_manage
:modify_server
set /p new_server_name=Entrez le nouveau nom du serveur (si vide, l'ancien nom sera gardé): 
IF "%new_server_name%"=="" (
	set new_server_name=%server_name%
)
set "new_server_name=%new_server_name:"=%"
set "new_server_name=%new_server_name:;=%"
set "new_server_name=%new_server_name:|=%"
call TOOLS\Storage\functions\strlen.bat nb "%new_server_name%"
set i=0
:check_chars_new_server_name_2
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^^ ^\ ^( ^)) do (
		IF "!new_server_name:~%i%,1!"=="%%z" (
			echo Un caractère non autorisé a été saisie dans le nom du serveur, l'ajout est annulé.
			goto:servers_manage
		)
	)
	set /a i+=1
	goto:check_chars_new_server_name_2
)
set /p new_server_addr=Entrez la nouvelle adresse du serveur (si vide, l'ancienne adresse sera gardée): 
IF "%new_server_addr%"=="" (
	set new_server_addr=%server_addr%
)
set "new_server_addr=%new_server_addr:"=%"
set "new_server_addr=%new_server_addr:;=%"
set "new_server_addr=%new_server_addr:|=%"
call TOOLS\Storage\functions\strlen.bat nb "%new_server_addr%"
set i=0
:check_chars_new_server_addr_2
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^^ ^\ ^( ^)) do (
		IF "!new_server_addr:~%i%,1!"=="%%z" (
			echo Un caractère non autorisé a été saisie dans l'adresse du serveur, l'ajout est annulé.
			goto:servers_manage
		)
	)
	set /a i+=1
	goto:check_chars_new_server_addr_2
)
TOOLS\gnuwin32\bin\sed.exe "%selected_server%s/%server_name%; %server_addr:/=\/%/%new_server_name%; %new_server_addr:/=\/%/" tools\netplay\servers_list.txt > tools\netplay\servers_list_new.txt
del tools\netplay\servers_list.txt
rename tools\netplay\servers_list_new.txt servers_list.txt
echo Serveur modifié.
pause
set manage_choice=
goto:servers_manage
:del_server
TOOLS\gnuwin32\bin\sed.exe -re "%selected_server%d" tools\netplay\servers_list.txt > tools\netplay\servers_list_new.txt
del tools\netplay\servers_list.txt
rename tools\netplay\servers_list_new.txt servers_list.txt
echo Serveur supprimé.
pause
set manage_choice=
goto:servers_manage
:install_winpcap
set install_choice=
echo Winpcap va être lancé, veuillez accepter la demande d'élévation des privilèges qui va suivre pour faire fonctionner ce programme.
pause
echo.
start tools\netplay\WinPcap.exe
goto:select_install
:launch_doc
set install_choice=
echo.
start DOC\files\netplay.html
goto:select_install
:end_script
pause
:finish_script
IF EXIST templogs (
	rmdir /s /q templogs
)
chcp 65001 >nul
endlocal