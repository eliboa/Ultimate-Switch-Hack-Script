::Script by Shadow256
chcp 65001 >nul
Setlocal enabledelayedexpansion
set script_path=%~dp0
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
echo Ce script va vous permettre d'installer un fichier NSP ou un dossier contenant des fichiers NSP sur une Switch connectée sur le réseau.
echo Il faut que Tinfoil soit lancé en mode réseau sur la console et que la console soit relié au même réseau que le PC sur lequel est exécuté ce script.
echo Attention: Accepter la demande d'autorisation de votre pare-feu si elle s'affiche car sinon l'installation ne fonctionnera pas.
echo Attention: Il est conseillé de désactiver la mise en veille de la Switch pendant le processus pour éviter que les jeux ne soient pas complètements installés si la console se met en veille durant l'installation.
echo.
pause
set /p custom_ip=Entrez l'adresse IP de votre Switch: 
:select_install_type
echo.
echo Que souhaitez-vous faire:
echo 1: Installer un fichier NSP?
echo 2: Installer plusieurs NSP en sélectionnant un dossier sans la prise en compte des sous-dossiers?
echo 3: Installer plusieurs NSP en sélectionnant un dossier avec la prise en compte des sous-dossiers?
echo N'importe quel autre choix: Revenir au menu précédent.
echo.
set /p install_type=Choisissez la méthode d'installation: 
IF NOT "%install_type%"=="" set install_type=%install_type:~0,1%
IF "%install_type%"=="1" (
	%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers NSP (*.nsp)|*.nsp|" "Sélection du fichier NSP à installer" "templogs\tempvar.txt"
	set /p filepath=<templogs\tempvar.txt
	IF "!filepath!"=="" (
		echo Installation annulée.
		goto:endscript
	)
) else IF "%install_type%"=="2" (
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt"
	set /p filepath=<"templogs\tempvar.txt"
	IF "!filepath!"=="" (
		echo Installation annulée.
		goto:endscript
	)
) else IF "%install_type%"=="3" (
	%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt"
	set /p filepath=<"templogs\tempvar.txt"
	IF "!filepath!"=="" (
		echo Installation annulée.
		goto:endscript
	)
) else (
	goto:finish_script
)
set filepath=%filepath:\\=\%
IF "%install_type%"=="1" (
	TOOLS\python3_scripts\remote_NSP.exe %custom_ip% "%filepath%"
	IF !errorlevel! NEQ 0 (
		echo Une erreur s'est produite pendant l'installation.
		goto:endscript
	)
	)
IF "%install_type%"=="2" (
	%filepath:~0,1%:
	cd "%filepath%"
	FOR %%f in (*.nsp) do (
		"%script_path%\..\python3_scripts\remote_NSP.exe" %custom_ip% "%filepath%\%%f"
		IF !errorlevel! NEQ 0 (
			echo Erreur d'installation pour le fichier %filepath%\%%f
			echo.
		)
	)
	%script_path:~0,1%:
	cd "%script_path%\..\.."
)
IF "%install_type%"=="3" (
	%filepath:~0,1%:
	cd "!filepath!"
	"%script_path%\..\gnuwin32\bin\find.exe" -name "*.nsp" > "%script_path%\..\..\templogs\nsp_list.txt"
	"%script_path%\..\gnuwin32\bin\grep.exe" -c "" <"%script_path%\..\..\templogs\nsp_list.txt" >"%script_path%\..\..\templogs\count.txt"
	set /p tempcount=<"%script_path%\..\..\templogs\count.txt"
	del /q "%script_path%\..\..\templogs\count.txt"
	IF "!tempcount!"=="0" (
		echo Il n'y a aucun fichier NSP à installer dans ce dossier ou ses sous-dossiers.
		goto:endscript
	)
	:installing
	IF "!tempcount!"=="0" (
		goto:finish_installing
	)
	"%script_path%\..\gnuwin32\bin\head.exe" -!tempcount! <"%script_path%\..\..\templogs\nsp_list.txt" | "%script_path%\..\gnuwin32\bin\tail.exe" -1>"%script_path%\..\..\templogs\nsp_list2.txt"
	set /p temp_nsp=<"%script_path%\..\..\templogs\nsp_list2.txt"
	"%script_path%\..\python3_scripts\remote_NSP.exe" %custom_ip% "%filepath%\!temp_nsp!"
	IF !errorlevel! NEQ 0 (
		echo Erreur d'installation pour le fichier %filepath%\!temp_nsp!
		echo.
	)
	set temp_nsp=
	set /a tempcount-=1
	goto:installing
	:finish_installing
	%script_path:~0,1%:
	cd "%script_path%\..\.."
)
echo.
echo Installation terminée.
:endscript
pause
:finish_script
rmdir /s /q templogs
endlocal