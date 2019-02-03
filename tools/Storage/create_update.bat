::Script by Shadow256
@echo off
chcp 65001 >nul
Setlocal enabledelayedexpansion
cd >temp.txt
set /p calling_script_dir=<temp.txt
del /q temp.txt
set this_script_dir=%~dp0
%this_script_dir:~0,1%:
IF NOT "%~1"=="" (
	IF EXIST "%~1\*.*" (
		set update_file_path=%~1
		set update_type=1
	) else (
		echo Une erreur de saisie du paramètre du dossier s'est produite, le script va s'arrêter.
		goto:endscript
	)
)
cd "%this_script_dir%"
IF EXIST "%calling_script_dir%\templogs" (
	del /q "%calling_script_dir%\templogs" 2>nul
	rmdir /s /q "%calling_script_dir%\templogs" 2>nul
)
mkdir "%calling_script_dir%\templogs"
cd ..\Hactool_based_programs
IF NOT EXIST keys.txt (
	IF EXIST keys.dat (
		copy keys.dat keys.txt
		goto:skip_keys_file_creation
	)
	echo Fichiers clés non trouvé, veuillez suivre les instructions.
	goto:keys_file_creation
) else (
	goto:skip_keys_file_creation
)
:keys_file_creation
echo.
echo Veuillez renseigner le fichier de clés dans la fenêtre suivante.
pause
%windir%\system32\wscript.exe //Nologo "%calling_script_dir%\TOOLS\Storage\functions\open_file.vbs" "" "Fichier de liste de clés Switch(*.*)|*.*|" "Sélection du fichier de clés pour Hactool" "%calling_script_dir%\templogs\tempvar.txt"
	set /p keys_file_path=<"%calling_script_dir%\templogs\tempvar.txt"
	IF "%keys_file_path%"=="" (
	echo Aucun fichier clés renseigné, le script va s'arrêter.
	goto:endscript
	)
	
	copy "%keys_file_path%" keys.txt
	
:skip_keys_file_creation
IF EXIST ChoiDuJour_keys.txt del /q ChoiDuJour_keys.txt
..\python3_scripts\Keys_management\keys_management.exe create_choidujour_keys_file keys.txt
IF NOT EXIST ChoiDuJour_keys.txt (
	echo Il semble que le fichier de clés nécessaire à ChoiDuJour n'ait pu être créé, veuillez vérifier votre fichier de clés et relancer le script.
	echo Pour vous aider, regarder les clés incorrectes qui se sont affichées juste avant.
	goto:endscript
)
IF NOT "%update_file_path%"=="" goto:skip_hfs0_select
echo Il est possible de lancer XCI Explorer pour extraire la partition "update" d'un fichier XCI. Notez que si vous choisissez de le lancer, le script ne pourra continuer qu'après la fermeture de XCI Explorer.
set /p launch_xci_explorer=Souhaitez-vous lancer XCI Explorer? (O/n): 
IF NOT "%launch_xci_explorer%"=="" set launch_xci_explorer=%launch_xci_explorer:~0,1%
IF /i "%launch_xci_explorer%"=="o" XCI-Explorer.exe
:update_package_select
echo.
echo Quel est le type de package de mise à jour:
echo 1: Répertoire?
echo 2: Fichier?
echo.
set /p update_type=Sélectionner le type de package de mise à jour: 
IF "%update_type%"=="" (
	echo Vous devez sélectionner un type de package.
	set update_type=
	goto:update_package_select
) else (
	set update_type=%update_type:~0,1%
)
IF "%update_type%"=="1" (
	%windir%\system32\wscript.exe //Nologo "%calling_script_dir%\TOOLS\Storage\functions\select_dir.vbs" "%calling_script_dir%\templogs\tempvar.txt"
	set /p update_file_path=<"%calling_script_dir%\templogs\tempvar.txt"
) else IF "%update_type%"=="2" (
	%windir%\system32\wscript.exe //Nologo "%calling_script_dir%\TOOLS\Storage\functions\open_file.vbs" "" "Fichier de partition Switch(*.hfs0)|*.hfs0|" "Sélection du fichier de mise à jour firmware Switch" "%calling_script_dir%\templogs\tempvar.txt"
	set /p update_file_path=<"%calling_script_dir%\templogs\tempvar.txt"
) else (
	echo Ce choix n'est pas supporté.
	echo.
	set update_type=
	goto:update_package_select
)
IF "%update_file_path%"=="" (
	echo Aucun fichier ou répertoire de mise à jour  renseigné, le script va s'arrêter.
	goto:endscript
)
set update_file_path=%update_file_path:\\=\%
:skip_hfs0_select
cd "%this_script_dir%"
:define_fspatches
set fspatches=--fspatches=nocmac
set /p enable_sigpatches=Souhaitez-vous désactiver la vérification des signatures (nécessaire pour installer du contenu non signé)? (O/n): 
IF NOT "%enable_sigpatches%"=="" set enable_sigpatches=%enable_sigpatches:~0,1%
IF /i "%enable_sigpatches%"=="o" set fspatches=%fspatches%,nosigchk
set /p disable_gamecard=Souhaitez-vous désactiver le port cartouche pour éviter la mise à jour du firmware de celui-ci (à utiliser si la console n'est jamais passé au-dessus du firmware 4.0.0)? (O/n): 
IF NOT "%disable_gamecard%"=="" set disable_gamecard=%disable_gamecard:~0,1%
IF /i "%disable_gamecard%"=="o" set fspatches=%fspatches%,nogc
set /p no_exfat=Souhaitez-vous désactiver le support pour le format EXFAT des cartes SD? (O/n): 
IF NOT "%no_exfat%"=="" set no_exfat=%no_exfat:~0,1%
IF /i "%no_exfat%"=="o" set no_exfat_param=--noexfat
:start_update_creation
IF NOT EXIST "%calling_script_dir%\update_packages\*.*" (
	del /q "%calling_script_dir%\update_packages" 2>nul
	mkdir "%calling_script_dir%\update_packages"
)
%calling_script_dir:~0,1%:
cd "%calling_script_dir%\update_packages"
del /q list_of_dirs.ini 2>nul
dir /A:D >list_of_dirs.ini
"%this_script_dir%\..\Hactool_based_programs\tools\ChoiDujour.exe" --keyset="%this_script_dir%\..\Hactool_based_programs\ChoiDuJour_keys.txt" %no_exfat_param% %fspatches% "%update_file_path%"
IF %errorlevel% EQU 0 (
	echo Firmware créé avec succès dans le répertoire "update_packages" du script.
	goto:skip_verif_fw_dir
) else (
	echo Un problème est survenu pendant la création du firmware.
	echo Vérifiez que les fichiers "ChoiDujour.exe", "hactool.exe", "keys.txt", "libmbedcrypto.dll", "libmbedtls.dll", "libmbedx509.dll" et "update.hfs0" sont bien à côté de ce script.
	echo Vérifiez également que vous avez bien toutes les clés requises dans le fichier "keys.txt".
	goto:verif_fw_dir
)
:verif_fw_dir
del /q list_of_dirs_2.ini 2>nul
dir /A:D >list_of_dirs_2.ini
"%this_script_dir%\..\gnuwin32\bin\diff.exe" list_of_dirs.ini list_of_dirs_2.ini | "%this_script_dir%\..\gnuwin32\bin\head.exe" -2 | "%this_script_dir%\..\gnuwin32\bin\tail.exe" -1 >new_dir.ini
::pause
::rmdir /q /s "%fw_dir%"
:skip_verif_fw_dir
IF "%update_type%"=="2" rmdir /q /s "%this_script_dir%\..\Hactool_based_programs\tools\update_update"
del /q list_of_dirs.ini 2>nul
del /q list_of_dirs_2.ini 2>nul
del /q new_dir.ini 2>nul
:endscript
pause
%calling_script_dir:~0,1%:
cd "%calling_script_dir%"
IF EXIST templogs\*.* (
	rmdir /s /q templogs
)
endlocal