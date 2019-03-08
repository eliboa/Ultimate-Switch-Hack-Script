::Script by Shadow256
Setlocal enabledelayedexpansion
@echo off
::chcp 1252 >nul
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs

echo Bienvenue dans la boîte à outils pour la nand.
echo.
echo Ici, vous pouvez effectuer un grand nombre d'actions sur la nand de la Switch ou sur un fichier de nand déjà dumpé.
echo Si vous n'avez pas lancé l'Ultimate Switch Hack Script en tant qu'administrateur (Windows 8 et versions supérieurs), toutes les fonctionnalités permettant d'intervenir sur un disque physique seront inutilisables.
::echo.
echo Note: Pour sélectionner un dump splittés, il suffit de sélectionner le premier fichier de celui-ci.
echo.
echo Attention: Les opérations effectuées par ces fonctions peuvent intervenir sur la nand de votre console, vous êtes seul responsable de se que vous faites.
pause
:define_action_choice
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: obtenir des infos sur un fichier de dump ou sur une partie de la nand de la console?
echo 2: Dumper la nand ou une partition de la nand de la console, copier un fichier ou extraire une partition d'un fichier de dump?
echo 3: Restaurer la nand ou une partition de la nand de la console?
echo 4: Activer/désactiver l'auto-RCM d'une partition BOOT0 ?
echo 5: Joindre un dump fait en plusieurs parties, par exemple un dump fait via Hekate sur une SD formatée en FAT32.
echo 0: Charger une partie de la nand avec Memloader?
echo N'importe quel autre choix: Revenir au menu précédent?
echo.
set action_choice=
set /p action_choice=Faites votre choix: 
IF "%action_choice%"=="1" goto:info_nand
IF "%action_choice%"=="2" goto:dump_nand
IF "%action_choice%"=="3" goto:restaure_nand
IF "%action_choice%"=="4" goto:autorcm_management
IF "%action_choice%"=="5" (
	call tools\storage\nand_joiner.bat
	goto:define_action_choice
)
IF "%action_choice%"=="0" (
	call tools\storage\mount_discs.bat
	goto:define_action_choice
)
goto:end_script

:info_nand
set input_path=
echo Sur quelle nand souhaitez-vous avoir des infos?
call :list_disk
echo 0: Fichier de dump?
echo Aucune valeur: Revenir au choix du mode?
echo.
set action_choice=
set /p action_choice=Faites votre choix: 
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice% info_nand
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
	)
)
IF "%input_path%"=="" (
	echo Le fichier de dump n'a pas été indiqué ou le numéro de disque n'existe pas.
	echo.
	goto:info_nand
)
tools\NxNandManager\NxNandManager.exe --info -i "%input_path%"
echo.
goto:info_nand

:dump_nand
set input_path=
set output_path=
echo Choisissez le support depuis lequel faire le dump:
call :list_disk
echo 0: Fichier de dump?
echo Aucune valeur: Revenir au choix du mode?
echo.
set action_choice=
set /p action_choice=Faites votre choix: 
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice% dump_nand
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
	)
)
IF "%input_path%"=="" (
	echo Le fichier de dump n'a pas été indiqué ou le numéro de disque n'existe pas.
	echo.
	goto:dump_nand
)
call :partition_select dump_nand
echo.
echo Vous allez devoir sélectionner le dossier vers lequel extraire le dump.
pause
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\select_dir.vbs "templogs\tempvar.txt"
set /p output_path=<templogs\tempvar.txt
IF "%output_path%"=="" (
	echo Le répertoire pour extraire le dump ne peut être vide, la fonction va être annulée.
	goto:dump_nand
)
IF NOT "%output_path%"=="" set output_path=%output_path%\
IF NOT "%output_path%"=="" set output_path=%output_path:\\=\%
call :get_type_nand "%input_path%"
IF NOT "%partition%"=="" (
	set output_path=%output_path%%partition%
) else (
	IF "%nand_type%"=="RAWNAND" (
		set output_path=%output_path%rawnand.bin
	) else IF "%nand_type%"=="RAWNAND (splitted dump)" (
		set output_path=%output_path%rawnand.bin
	) else (
		set output_path=%output_path%%nand_type%
	)
)
IF EXIST "%output_path%" (
	set /p erase_output_file=Ce dossier contient déjà un fichier de ce type de dump, souhaitez-vous vraiment continuer en écrasant le fichier existant? ^(O/n^): 
)
IF NOT "%erase_output_file%"=="" set erase_output_file=%erase_output_file:~0,1%
IF EXIST "%output_path%" (
	IF /i NOT "%erase_output_file%"=="o" (
		echo Opération annulée par l'utilisateur.
		goto:dump_nand
	)
)
call :set_NNM_params
::echo -i "%input_path%" -o "%output_path%" %params%%lflags%
tools\NxNandManager\NxNandManager.exe -i "%input_path%" -o "%output_path%" %params%%lflags%
echo.
goto:dump_nand

:restaure_nand
set input_path=
set output_path=
echo Vous allez devoir sélectionner le fichier depuis lequel restaurer.
pause
call :nand_file_input_select
IF "%input_path%"=="" (
	echo Le fichier de dump n'a pas été indiqué, retour au choix du mode.
	echo.
	goto:define_action_choice
)
echo Choisissez le support vers lequel restaurer le dump:
call :list_disk
IF NOT EXIST templogs\disks_list.txt (
	echo Aucun disque vers lequel restaurer, retour au choix du mode.
	goto:define_action_choice
)
echo Aucune valeur: Revenir au choix du mode?
echo.
set action_choice=
set /p action_choice=Faites votre choix: 
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice% restaure_nand
IF EXIST templogs\disks_list.txt (
	TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
	set /p output_path=<templogs\tempvar.txt
)
IF "%output_path%"=="" (
	echo Le numéro de disque n'existe pas.
	echo.
	goto:dump_nand
)
call :partition_select restaure_nand
call :get_type_nand "%input_path%"
set input_nand_type=%nand_type%
IF "%input_nand_type%"=="RAWNAND (splitted dump)" (
	set input_nand_type=RAWNAND
)
call :get_type_nand "%output_path%"
set output_nand_type=%nand_type%
IF "%output_nand_type%"=="RAWNAND (splitted dump)" (
	set output_nand_type=RAWNAND
)

IF NOT "%partition%"=="" (
	IF NOT "%output_nand_type%"=="RAWNAND" (
		echo Impossible de restaurer une partition spécifique si le type de nand en sortie n'est pas "RAWNAND", l'opération est annulée.
		goto:restaure_nand
	) else (
		IF NOT "PARTITION %partition%"=="%input_nand_type%" (
			echo Le type de partition ne semble pas correspondre avec le fichier choisi pour restaurer. Par mesure de sécurité, l'opération est annulée.
			goto:restaure_nand
		)
	)
) else (
	IF NOT "%input_nand_type%"=="%output_nand_type%" (
		echo Le type de la nand en entrée ne correspond pas avec le type de la nand en sortie, il n'est pas possible de continuer.
		goto:restaure_nand
	)
)
call :set_NNM_params
::echo -i "%input_path%" -o "%output_path%" %params%%lflags%
tools\NxNandManager\NxNandManager.exe -i "%input_path%" -o "%output_path%" %params%%lflags%
echo.
goto:restaure_nand

:autorcm_management
set input_path=
echo Sur quelle partition BOOT0 souhaitez-vous travailler?
call :list_disk
echo 0: Fichier de dump?
echo Aucune valeur: Revenir au choix du mode?
echo.
set action_choice=
set /p action_choice=Faites votre choix: 
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice% autorcm_management
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
	)
)
IF "%input_path%"=="" (
	echo Le fichier de dump n'a pas été indiqué ou le numéro de disque n'existe pas.
	echo.
	goto:autorcm_management
)
echo.
echo Que souhaitez-vous faire:
echo 1: Activer l'auto-RCM?
echo 2: Désactiver l'auto-RCM?
echo Tout autre choix: Annuler le processus.
echo.
set action_choice=
set autorcm_param=
set /p action_choice=Faites votre choix: 
IF "%action_choice%" == "1" (
	set autorcm_param=--enable_autoRCM
) else IF "%action_choice%" == "2" (
	set autorcm_param=--disable_autoRCM
) else (
	goto:autorcm_management
)
call :get_type_nand "%input_path%"
set input_nand_type=%nand_type%
IF NOT "%input_nand_type%"=="BOOT0" (
	echo Le type de la nand doit être BOOT0, le processus ne peut continuer.
	goto:autorcm_management
)
tools\NxNandManager\NxNandManager.exe %autorcm_param% -i "%input_path%" >nul 2>&1
IF %errorlevel% NEQ 0 (
	echo Une erreur inconnue semble s'être produite pendant la tentative d'activation/désactivation de l'auto-RCM.
	echo Vérifiez que le script a bien été exécuté en tant qu'administrateur et que le fichier ou le périphérique est bien accessible. Dans le cas d'un fichier, vérifiez également qu'il n'est pas en lecture seul.
) else (
	IF "%action_choice%" == "1" echo Auto-RCM activé.
IF "%action_choice%" == "2" echo Auto-RCM désactivé.
)
pause
echo.
goto:autorcm_management

:get_type_nand
set nand_type=
set nand_file_or_disk=
set temp_input_file=%~1
tools\NxNandManager\NxNandManager.exe --info -i "%temp_input_file%" >templogs\infos_nand.txt
set temp_input_file=
tools\gnuwin32\bin\grep.exe "NAND type :" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p nand_type=<templogs\tempvar.txt
set nand_type=%nand_type:~1%
tools\gnuwin32\bin\grep.exe "File/Disk :" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p nand_file_or_disk=<templogs\tempvar.txt
set nand_file_or_disk=%nand_file_or_disk:~1%
exit /B

:list_disk
IF EXIST templogs\disks_list.txt del /q templogs\disks_list.txt
tools\NxNandManager\NxNandManager.exe --list >templogs\temp_disks_list.txt
if %errorlevel% EQU -1009 (
	del /q templogs\temp_disks_list.txt
	exit /B
)
TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\temp_disks_list.txt > templogs\tempvar.txt
set /p count_disks=<templogs\tempvar.txt
set /a temp_count=0
set /a real_count=0
copy nul templogs\disks_list.txt >nul
set /a count_disks=%count_disks%-1
:disks_listing
set /a temp_count+=1
IF %temp_count% GTR %count_disks% (
	goto:finish_disks_listing
)
TOOLS\gnuwin32\bin\sed.exe -n %temp_count%p <templogs\temp_disks_list.txt >templogs\tempvar.txt
set /p temp_disk=<templogs\tempvar.txt
IF NOT "%temp_disk:~0,4%" == "\\.\" goto:disks_listing
call :get_type_nand "%temp_disk%"
echo %temp_disk%>>templogs\disks_list.txt
set /a real_count=%real_count%+1
echo %real_count%: %temp_disk%;  %nand_type%
goto:disks_listing
:finish_disks_listing
del /q templogs\temp_disks_list.txt
exit /b

:nand_file_input_select
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Tout les fichiers (*.*)|*.*|" "Sélection du fichier de dump" "templogs\tempvar.txt"
set /p input_path=<templogs\tempvar.txt
exit /b

:verif_disk_choice
set choice=%~1
set label_verif_disk_choice=%~2
call TOOLS\Storage\functions\strlen.bat nb "%choice%"
set i=0
:check_chars_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_choice
		)
	)
	IF "!check_chars!"=="0" (
	echo Un caractère non-autorisé a été saisie.
	goto:%label_verif_disk_choice%
	)
)
exit /b

:partition_select
set partition=
set label_partition_select=%~1
echo Sur quelle partition travailler?
echo 0: Aucune.
echo 1: PRODINFO.
echo 2: PRODINFOF.
echo 3: BCPKG2-1-Normal-Main
echo 4: BCPKG2-2-Normal-Sub
echo 5: BCPKG2-3-SafeMode-Main
echo 6: BCPKG2-4-SafeMode-Sub
echo 7: BCPKG2-5-Repair-Main
echo 8: BCPKG2-6-Repair-Sub
echo 9: SAFE
echo 10: SYSTEM
echo 11: USER
echo Aucun choix: Annuler l'opération.
echo.
set choose_partition=
set /p choose_partition=Faites votre choix: 
IF "%choose_partition%" == "" goto:%label_partition_select%
call :verif_disk_choice %choose_partition% partition_select
IF %choose_partition% GTR 11 (
	echo Choix inexistant.
	goto:partition_select
)
IF %choose_partition% EQU 1 set partition=PRODINFO
IF %choose_partition% EQU 2 set partition=PRODINFOF
IF %choose_partition% EQU 3 set partition=BCPKG2-1-Normal-Main
IF %choose_partition% EQU 4 set partition=BCPKG2-2-Normal-Sub
IF %choose_partition% EQU 5 set partition=BCPKG2-3-SafeMode-Main
IF %choose_partition% EQU 6 set partition=BCPKG2-4-SafeMode-Sub
IF %choose_partition% EQU 7 set partition=BCPKG2-5-Repair-Main
IF %choose_partition% EQU 8 set partition=BCPKG2-6-Repair-Sub
IF %choose_partition% EQU 9 set partition=SAFE
IF %choose_partition% EQU 10 set partition=SYSTEM
IF %choose_partition% EQU 11 set partition=USER
exit /b

:set_NNM_params
set params=
set lflags=
IF NOT "%partition%"=="" set params=-part=%partition% 
set /p force_option=Souhaitez-vous que le programme ne pose aucune question durant le traitement (mode FORCE)? (O/n): 
IF NOT "%force_option%"=="" set skip_md5=%skip_md5:~0,1%
IF /i "%force_option%"=="o" (
	set lflags=%lflags%FORCE 
)
set /p skip_md5=Souhaitez-vous passer la vérification MD5? (O/n): 
IF NOT "%skip_md5%"=="" set skip_md5=%skip_md5:~0,1%
IF /i "%skip_md5%"=="o" (
	set lflags=%lflags%BYPASS_MD5SUM 
)
set /p debug_option=Souhaitez-vous activer les informations de débogage? (O/n): 
IF NOT "%debug_option%"=="" set debug_option=%debug_option:~0,1%
IF /i "%debug_option%"=="o" (
	set lflags=%lflags%DEBUG_MODE 
)
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
)
::chcp 65001 >nul
endlocal