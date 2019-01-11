::Script by Shadow256
Setlocal enabledelayedexpansion
@echo off
chcp 1252 >nul
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
IF EXIST tools\toolbox\user_tools.txt\*.* rmdir /s /qtools\toolbox\user_tools.txt
IF NOT EXIST tools\toolbox\user_tools.txt copy nul tools\toolbox\user_tools.txt

echo Bienvenue dans la bo�te � outils.
echo.
echo Ici, vous pouvez g�rer le lancement de programmes ayant une interface graphique et qui ne sont donc pas interractif avec mon script.
echo Vous trouverez une liste d'outils par d�faut qui interviennent parfois dans mon script et cette liste ne sera pas modifiable.
echo Par contre, vous pouvez �galement g�rer votre liste de programmes personnel et donc en ajouter ou en supprimer un.
echo.
echo Attention, du fait du fonctionnement qui peut diff�rer pour chaque programme, vous vous devez de g�rer vous-m�me les d�pendances de ceux-ci, cette bo�te � outils ne sert qu'� lancer ou organiser vos outils.
:define_action_choice
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Lancer un programme?
echo 2: Ouvrir le dossier principal d'un programme de la liste de programmes personnels?
echo 3: G�rer la liste de programmes personnels?
echo N'importe quel autre choix: Revenir au menu pr�c�dent.
echo.
set action_choice=
set /p action_choice=Faites votre choix: 
IF "%action_choice%"=="1" goto:launch_software
IF "%action_choice%"=="2" goto:launch_working_folder
IF "%action_choice%"=="3" goto:config_softwares_list
goto:end_script

:launch_software
echo.
echo Liste des logiciels:
echo.
echo Logiciels par d�faut:
echo.
TOOLS\gnuwin32\bin\grep.exe -c "" <tools\toolbox\default_tools.txt > templogs\tempvar.txt
set /p count_software_default=<templogs\tempvar.txt
TOOLS\gnuwin32\bin\grep.exe -c "" <tools\toolbox\user_tools.txt > templogs\tempvar.txt
set /p count_software_user=<templogs\tempvar.txt
set /a temp_count=0
set /a temp_count_default=0
:software_default_listing
set /a temp_count+=1
set /a temp_count_default+=1
IF %temp_count_default% GTR %count_software_default% (
	goto:finish_software_default_listing
)
TOOLS\gnuwin32\bin\sed.exe -n %temp_count_default%p <tools\toolbox\default_tools.txt >templogs\tempvar.txt
set /p temp_software=<templogs\tempvar.txt
echo %temp_count%: %temp_software%
goto:software_default_listing
:finish_software_default_listing
set /a temp_count_user=0
IF %count_software_user% EQU 0 goto:finish_software_user_listing
echo.
echo Logiciels personnels:
echo.
set /a temp_count-=1
:software_user_listing
set /a temp_count+=1
set /a temp_count_user+=1
IF %temp_count_user% GTR %count_software_user% (
	goto:finish_software_user_listing
)
TOOLS\gnuwin32\bin\sed.exe -n %temp_count_user%p <tools\toolbox\user_tools.txt >templogs\tempvar.txt
set /p temp_software=<templogs\tempvar.txt
echo %temp_count%: %temp_software%
goto:software_user_listing
:finish_software_user_listing
echo.
echo N'importe quel autre chiffres: Revenir au menu de s�lection du mode de la toolbox.
echo.
set launch_software_choice=
set /p launch_software_choice=Choisissez un logiciel � lancer ou une action � faire: 
IF "%launch_software_choice%"=="" set launch_software_choice=0
call TOOLS\Storage\functions\strlen.bat nb "%launch_software_choice%"
set i=0
:check_chars_selected_launch_software_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!launch_software_choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_selected_launch_software_choice
		)
	)
	IF "!check_chars!"=="0" (
	echo Un caract�re non-autoris� a �t� saisie.
	goto:launch_software
	)
)
IF %launch_software_choice% GEQ %temp_count% goto:define_action_choice
IF %launch_software_choice% EQU 0 goto:define_action_choice
set software_list_choice=0
IF %launch_software_choice% GTR %count_software_default% (
	set /a launch_software_choice-=%count_software_default%
	set software_list_choice=1
)
IF "%software_list_choice%"=="0" (
	TOOLS\gnuwin32\bin\sed.exe -n %launch_software_choice%p <tools\toolbox\default_tools.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 2 > templogs\tempvar.txt
)
IF "%software_list_choice%"=="1" (
	TOOLS\gnuwin32\bin\sed.exe -n %launch_software_choice%p <tools\toolbox\user_tools.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 2 > templogs\tempvar.txt
)
set /p software_path=<templogs\tempvar.txt
IF NOT "%software_path%"=="" (
	set software_path=%software_path:~1%
)
call :extract_base_folder "%software_path%"
start "" /d "%software_folder_path%" "%software_path%"
goto:launch_software
:launch_working_folder
TOOLS\gnuwin32\bin\grep.exe -c "" <tools\toolbox\user_tools.txt > templogs\tempvar.txt
set /p count_software_user=<templogs\tempvar.txt
IF %count_software_user% EQU 0 (
	echo Aucun logiciel personnel d�fini, cette fonctionnalit� ne peut donc pas �tre utilis�e.
	goto:define_action_choice
)
echo.
echo Liste des logiciels personnels:
echo.
set /a temp_count=0
set /a temp_count_user=0
:software_user_f_listing
set /a temp_count+=1
set /a temp_count_user+=1
IF %temp_count_user% GTR %count_software_user% (
	goto:finish_software_user_f_listing
)
TOOLS\gnuwin32\bin\sed.exe -n %temp_count_user%p <tools\toolbox\user_tools.txt >templogs\tempvar.txt
set /p temp_software=<templogs\tempvar.txt
echo %temp_count%: %temp_software%
goto:software_user_f_listing
:finish_software_user_f_listing
echo.
echo N'importe quel autre chiffres: Revenir au menu de s�lection du mode de la toolbox.
echo.
set launch_software_choice=
set /p launch_software_choice=Choisissez un logiciel pour lequel son dossier de travail sera ouvert ou une action � faire: 
IF "%launch_software_choice%"=="" set launch_software_choice=0
call TOOLS\Storage\functions\strlen.bat nb "%launch_software_choice%"
set i=0
:check_chars_selected_launch_f_software_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!launch_software_choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_selected_launch_f_software_choice
		)
	)
	IF "!check_chars!"=="0" (
	echo Un caract�re non-autoris� a �t� saisie.
	goto:launch_working_folder
	)
)
IF %launch_software_choice% GEQ %temp_count% goto:define_action_choice
IF %launch_software_choice% EQU 0 goto:define_action_choice
TOOLS\gnuwin32\bin\sed.exe -n %launch_software_choice%p <tools\toolbox\user_tools.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 2 > templogs\tempvar.txt
set /p software_path=<templogs\tempvar.txt
IF NOT "%software_path%"=="" (
	set software_path=%software_path:~1%
)
call :extract_base_folder "%software_path%"
start explorer.exe "%software_folder_path%"
goto:launch_working_folder
:config_softwares_list
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Ajouter un logiciel?
echo 2: Modifier le nom d'un logiciel?
echo 3: Supprimer un logiciel?
echo N'importe quel autre choix: Revenir au menu de s�lection du mode de la toolbox.
echo.
set manage_choice=
set /p manage_choice=Faites votre choix: 
IF "%manage_choice%"=="1" goto:add_software
IF "%manage_choice%"=="2" goto:modify_software
IF "%manage_choice%"=="3" goto:del_software
goto:define_action_choice

:add_software
:define_software_name
set software_name=
set /p software_name=Entrez le nom du logiciel: 
IF "%software_name%"=="" (
	echo Le nom du logiciel ne peut �tre vide.
	goto:define_software_name
) else (
	set software_name=%software_name:"=%
)
call TOOLS\Storage\functions\strlen.bat nb "%software_name%"
set i=0
:check_chars_software_name
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^/ ^* ^? ^: ^^ ^| ^\) do (
		IF "!software_name:~%i%,1!"=="%%z" (
			echo Un caract�re non autoris� a �t� saisie dans le nom du logiciel.
			set software_name=
			goto:define_software_name
		)
	)
	set /a i+=1
	goto:check_chars_software_name
)
echo.
set software_copy=
set /p software_copy=Souhaitez-vous copier le logiciel dans le r�pertoire de travail du script? (O/n): 
IF NOT "%software_copy%"=="" set software_copy=%software_copy:~0,1%
IF /i "%software_copy%"=="o" (
	IF EXIST "tools\toolbox\%software_name%" (
		echo Ce logiciel semble d�j� avoir �t� copi� dans le r�pertoire "toolbox" du script, l'ajout est donc annul�.
		goto:config_softwares_list
	)
)
:define_software_type
IF /i "%software_copy%"=="o" (
	echo.
	echo Quel est le type du logiciel?
	echo.
	echo 1: Un logiciel n'utilisant qu'un seul fichier pour �tre lanc�?
	echo 2: Un logiciel contenu dans un dossier dont les autres fichiers/dossiers de ce dossier sont n�cessaires � sont fonctionnement?
	echo 0: Annuler la configuration de cet ajout et revenir au menu pr�c�dent.
	echo.
	set software_type=
	set /p software_type=Faites votre choix: 
)
IF /i "%software_copy%"=="o" (
	IF "%software_type%"=="0" goto:config_softwares_list
	IF "%software_type%"=="1" goto:define_software_path
	IF "%software_type%"=="2" goto:define_software_path
	echo Ce choix n'est pas disponible.
	goto:define_software_type
)
:define_software_path
echo.
echo Dans la prochaine �tape, vous devrez indiquer o� se trouve le logiciel sur votre ordinateur.
echo Si vous avez choisi de copier le logiciel et selon le type de logiciel choisi, le fichier indiqu� et/ou le dossier qui le contient seront copi�s dans le dossier "tools\toolbox" du script et le chemin sera adapt� pour n'�tre qu'un chemin relatif vers l'ex�cutable choisi.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file2.vbs "" "Tout les fichiers (*.*)|*.*|" "S�lection du fichier principal de votre logiciel" "templogs\tempvar.txt"
set /p software_path=<templogs\tempvar.txt
IF "%software_path%"=="" (
	echo Le fichier n'a pas �t� indiqu�, la proc�dure d'ajout est annul�e.
	goto:config_softwares_list
)
IF /i "%software_copy%"=="o" (
	mkdir "tools\toolbox\%software_name%"
	IF "%software_type%"=="1" copy /v /b "%software_path%" "tools\toolbox\%software_name%"
)
call :extract_base_folder "%software_path%"
IF /i "%software_copy%"=="o" (
	IF "%software_type%"=="2" %windir%\System32\Robocopy.exe "%software_path%" "tools\toolbox\%software_name%" /e
)
call :get_software_file_name "%software_path%"
IF /i "%software_copy%"=="o" (
	set software_path=tools\toolbox\%software_name%\%software_file_name%
)
echo %software_name%; %software_path%>> tools\toolbox\user_tools.txt
echo Logiciel ajout�.
pause
goto:config_softwares_list
:modify_software
TOOLS\gnuwin32\bin\grep.exe -c "" <tools\toolbox\user_tools.txt > templogs\tempvar.txt
set /p count_software_user=<templogs\tempvar.txt
IF %count_software_user% EQU 0 (
	echo Aucun logiciel personnel d�fini, cette fonctionnalit� ne peut donc pas �tre utilis�e.
	goto:config_softwares_list
)
echo.
echo Liste des logiciels personnels:
echo.
set /a temp_count=0
set /a temp_count_user=0
:software_user_m_listing
set /a temp_count+=1
set /a temp_count_user+=1
IF %temp_count_user% GTR %count_software_user% (
	goto:finish_software_user_m_listing
)
TOOLS\gnuwin32\bin\sed.exe -n %temp_count_user%p <tools\toolbox\user_tools.txt >templogs\tempvar.txt
set /p temp_software=<templogs\tempvar.txt
echo %temp_count%: %temp_software%
goto:software_user_m_listing
:finish_software_user_m_listing
echo.
echo N'importe quel autre chiffres: Revenir au menu  pr�c�dent.
echo.
set launch_software_choice=
set /p launch_software_choice=Faites votre choix: 
IF "%launch_software_choice%"=="" set launch_software_choice=0
call TOOLS\Storage\functions\strlen.bat nb "%launch_software_choice%"
set i=0
:check_chars_selected_launch_m_software_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!launch_software_choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_selected_launch_m_software_choice
		)
	)
	IF "!check_chars!"=="0" (
	echo Un caract�re non-autoris� a �t� saisie.
	goto:modify_software
	)
)
IF %launch_software_choice% GEQ %temp_count% goto:config_softwares_list
IF %launch_software_choice% EQU 0 goto:config_softwares_list
TOOLS\gnuwin32\bin\sed.exe -n %launch_software_choice%p <tools\toolbox\user_tools.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 2 > templogs\tempvar.txt
set /p software_path=<templogs\tempvar.txt
IF NOT "%software_path%"=="" (
	set software_path=%software_path:~1%
)
TOOLS\gnuwin32\bin\sed.exe -n %launch_software_choice%p <tools\toolbox\user_tools.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 1 > templogs\tempvar.txt
set /p software_name=<templogs\tempvar.txt
:define_new_software_name
echo.
set new_software_name=
set /p new_software_name=Entrez le nouveau nom du logiciel (si vide ou si le nom est exactement le m�me, l'ancien nom sera gard�): 
IF "%new_software_name%"=="" (
	echo Le logiciel n'a pas �t� renomm�, retour au menu pr�c�dent.
	goto:config_softwares_list
) else IF "%new_software_name%"=="%software_name%" (
	echo Le logiciel n'a pas �t� renomm�, retour au menu pr�c�dent.
	goto:config_softwares_list
	) else (
	set new_software_name=%new_software_name:"=%
)
call TOOLS\Storage\functions\strlen.bat nb "%new_software_name%"
set i=0
:check_chars_new_software_name
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^/ ^* ^? ^: ^^ ^| ^\) do (
		IF "!new_software_name:~%i%,1!"=="%%z" (
			echo Un caract�re non autoris� a �t� saisie dans le nom du logiciel.
			set new_software_name=
			goto:define_new_software_name
		)
	)
	set /a i+=1
	goto:check_chars_new_software_name
)
IF "%software_path:~0,14%"=="tools\toolbox\" (
	set rename_software_folder=O
	call :get_software_file_name "%software_path%"
) else (
	set new_software_path=%software_path%
	goto:renaming_in_list
)
move "tools\toolbox\%software_name%" "tools\toolbox\%new_software_name%"
set new_software_path=tools\toolbox\%new_software_name%\%software_file_name%
:renaming_in_list
TOOLS\gnuwin32\bin\sed.exe -re "%launch_software_choice%s/%software_name%; %software_path:\=\\%/%new_software_name%; %new_software_path:\=\\%/" tools\toolbox\user_tools.txt > tools\toolbox\user_tools_new.txt
del tools\toolbox\user_tools.txt
rename tools\toolbox\user_tools_new.txt user_tools.txt
echo Nom du logiciel modifi�.
pause
goto:config_softwares_list
:del_software
TOOLS\gnuwin32\bin\grep.exe -c "" <tools\toolbox\user_tools.txt > templogs\tempvar.txt
set /p count_software_user=<templogs\tempvar.txt
IF %count_software_user% EQU 0 (
	echo Aucun logiciel personnel d�fini, cette fonctionnalit� ne peut donc pas �tre utilis�e.
	goto:config_softwares_list
)
echo.
echo Liste des logiciels personnels:
echo.
set /a temp_count=0
set /a temp_count_user=0
:software_user_d_listing
set /a temp_count+=1
set /a temp_count_user+=1
IF %temp_count_user% GTR %count_software_user% (
	goto:finish_software_user_d_listing
)
TOOLS\gnuwin32\bin\sed.exe -n %temp_count_user%p <tools\toolbox\user_tools.txt >templogs\tempvar.txt
set /p temp_software=<templogs\tempvar.txt
echo %temp_count%: %temp_software%
goto:software_user_d_listing
:finish_software_user_d_listing
echo.
echo N'importe quel autre chiffres: Revenir au menu  pr�c�dent.
echo.
set launch_software_choice=
set /p launch_software_choice=Faites votre choix: 
IF "%launch_software_choice%"=="" set launch_software_choice=0
call TOOLS\Storage\functions\strlen.bat nb "%launch_software_choice%"
set i=0
:check_chars_selected_launch_d_software_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!launch_software_choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_selected_launch_d_software_choice
		)
	)
	IF "!check_chars!"=="0" (
	echo Un caract�re non-autoris� a �t� saisie.
	goto:del_software
	)
)
IF %launch_software_choice% GEQ %temp_count% goto:config_softwares_list
IF %launch_software_choice% EQU 0 goto:config_softwares_list
TOOLS\gnuwin32\bin\sed.exe -n %launch_software_choice%p <tools\toolbox\user_tools.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 2 > templogs\tempvar.txt
set /p software_path=<templogs\tempvar.txt
IF NOT "%software_path%"=="" (
	set software_path=%software_path:~1%
)
IF NOT "%software_path:~0,14%"=="tools\toolbox\" goto:del_from_list
TOOLS\gnuwin32\bin\sed.exe -n %launch_software_choice%p <tools\toolbox\user_tools.txt | TOOLS\gnuwin32\bin\cut.exe -d ; -f 1 > templogs\tempvar.txt
set /p software_name=<templogs\tempvar.txt
rmdir /s /q tools\toolbox\%software_name% 2>nul
:del_from_list
TOOLS\gnuwin32\bin\sed.exe "%launch_software_choice%d" tools\toolbox\user_tools.txt > tools\toolbox\user_tools_new.txt
del tools\toolbox\user_tools.txt
rename tools\toolbox\user_tools_new.txt user_tools.txt
echo Logiciel supprim�.
pause
goto:config_softwares_list

:extract_base_folder
set software_folder_path=%~dp1
exit /B

:get_software_file_name
set software_file_name=%~nx1
exit /B
:end_script
IF EXIST templogs (
	rmdir /s /q templogs
)
chcp 65001 >nul
endlocal