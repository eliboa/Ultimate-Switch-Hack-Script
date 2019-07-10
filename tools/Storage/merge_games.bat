::Script by Shadow256
@echo off
chcp 65001 >nul
Setlocal enabledelayedexpansion
set this_script_dir=%~dp0
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
echo Ce script permet de joindre les parties d'un fichier XCI ou NSP découpé en un seul fichier XCI ou NSP.
pause
echo Quel est le type de fichier à joindre?
echo 1: NSP via fichiers.
echo 2: XCI via fichiers.
echo 3: NSP via dossier.
echo 4: XCI via dossier.
echo N'importe quel autre choix: Retourne au menu précédent.
echo.
set game_type=
set /p game_type=Faites votre choix: 
IF "%game_type%"=="1" goto:input_choice
IF "%game_type%"=="2" goto:input_choice
IF "%game_type%"=="3" goto:input_choice
IF "%game_type%"=="4" goto:input_choice
goto:end_script_2
:input_choice
echo.
echo Vous allez devoir sélectionner le premier fichier du jeu splitté.
pause
IF "%game_type%"=="1" (
	%windir%\system32\wscript.exe //Nologo tools\Storage\functions\open_file.vbs "" "Premier fichier d'un jeu NSP splitté (*.ns0)|*.ns0|" "Sélection du premier fichier du contenu" "templogs\tempvar.txt"
) else IF "%game_type%"=="2" (
	%windir%\system32\wscript.exe //Nologo tools\Storage\functions\open_file.vbs "" "Premier fichier d'un jeu XCI splitté (*.xc0)|*.xc0|" "Sélection du premier fichier du contenu" "templogs\tempvar.txt"
) else (
	%windir%\system32\wscript.exe //Nologo tools\Storage\functions\open_file.vbs "" "Premier fichier d'un jeu NSP ou XCI splitté via dossier (00)|00|" "Sélection du premier fichier du contenu" "templogs\tempvar.txt"
)
set /p dump_input=<"templogs\tempvar.txt"
IF "%dump_input%"=="" (
	echo Aucun fichier sélectionné, le script va s'arrêter.
	goto:end_script
)
call :extract_input_filename "%dump_input%"
echo.
echo Vous allez devoir sélectionner le répertoire vers lequel créé le fichier réunifié.
pause
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\select_dir.vbs" "templogs\tempvar.txt"
set /p dump_output=<"templogs\tempvar.txt"
IF "%dump_output%"=="" (
	echo Aucun dossier sélectionné, le script va s'arrêter.
	goto:end_script
)
set dump_output=%dump_output%\
set dump_output=%dump_output:\\=\%
:define_filename
set filename=
set /p filename=Entrez le nom du fichier que vous souhaitez en sortie sans l'extension, laissez vide pour annuler: 
IF "%filename%"=="" (
	goto:end_script_2
) else (
	set filename=%filename:"=%
)
call tools\Storage\functions\strlen.bat nb "%filename%"
set i=0
:check_chars_filename
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^/ ^* ^? ^: ^^ ^| ^\) do (
		IF "!filename:~%i%,1!"=="%%z" (
			echo Un caractère non autorisé a été saisie dans le nom du jeu.
			set filename=
			goto:define_filename
		)
	)
	set /a i+=1
	goto:check_chars_filename
)
IF "%game_type%"=="1" (
	IF EXIST "%dump_output%%filename%.nsp" (
		set erase_file=
		set /p erase_file=Le fichier existe déjà à l'emplacement indiqué, souhaitez-vous l'écraser? ^(O/n^): 
		IF NOT "!erase_file!"=="" set erase_file=!erase_file:0,1!
		IF /i NOT "!erase_file!"=="o" (
			echo Action annulée par l'utilisateur.
			goto:end_script
		)
	)
) else IF "%game_type%"=="3" (
IF EXIST "%dump_output%%filename%.nsp" (
		set erase_file=
		set /p erase_file=Le fichier existe déjà à l'emplacement indiqué, souhaitez-vous l'écraser? ^(O/n^): 
		IF NOT "!erase_file!"=="" set erase_file=!erase_file:0,1!
		IF /i NOT "!erase_file!"=="o" (
			echo Action annulée par l'utilisateur.
			goto:end_script
		)
	)
) else IF "%game_type%"=="2" (
IF EXIST "%dump_output%%filename%.xci" (
		set erase_file=
		set /p erase_file=Le fichier existe déjà à l'emplacement indiqué, souhaitez-vous l'écraser? ^(O/n^): 
		IF NOT "!erase_file!"=="" set erase_file=!erase_file:0,1!
		IF /i NOT "!erase_file!"=="o" (
			echo Action annulée par l'utilisateur.
			goto:end_script
		)
	)
) else IF "%game_type%"=="4" (
IF EXIST "%dump_output%%filename%.xci" (
		set erase_file=
		set /p erase_file=Le fichier existe déjà à l'emplacement indiqué, souhaitez-vous l'écraser? ^(O/n^): 
		IF NOT "!erase_file!"=="" set erase_file=!erase_file:0,1!
		IF /i NOT "!erase_file!"=="o" (
			echo Action annulée par l'utilisateur.
			goto:end_script
		)
	)
)
set copy_files_param=
set /a temp_count=0
IF "%game_type%"=="1" (
	for %%f in ("%input_dirrectory%\%input_filename%.ns*") do (
		set /a temp_count+=1
	)
	for /l %%i in (0,1,!temp_count!) do (
		IF NOT EXIST "%input_dirrectory%\%input_filename%.ns%%i" (
			echo Erreur, il semble qu'un fichier soit manquant dans le nombre des parties de celui-ci, le script ne peut continuer.
			goto:end_script
		)
		IF %%i NEQ !temp_count! (
			set copy_files_param=!copy_files_param!^"%input_dirrectory%\%input_filename%.ns%%i^" + 
		) else (
			set copy_files_param=!copy_files_param!^"%input_dirrectory%\%input_filename%.ns%%i^"
		)
	)
) else IF "%game_type%"=="2" (
	for %%f in ("%input_dirrectory%\%input_filename%.xc*") do (
		set /a temp_count+=1
	)
	for /l %%i in (0,1,!temp_count!) do (
		IF NOT EXIST "%input_dirrectory%\%input_filename%.xc%%i" (
			echo Erreur, il semble qu'un fichier soit manquant dans le nombre des parties de celui-ci, le script ne peut continuer.
			goto:end_script
		)
		IF %%i NEQ !temp_count! (
			set copy_files_param=!copy_files_param!^"%input_dirrectory%\%input_filename%.xc%%i^" + 
		) else (
			set copy_files_param=!copy_files_param!^"%input_dirrectory%\%input_filename%.xc%%i^"
		)
	)
) else (
	for %%f in ("%input_dirrectory%\*.*") do (
		set /a temp_count+=1
	)
	for /l %%i in (0,1,!temp_count!) do (
		IF !temp_count! LEQ 9 (
			IF NOT EXIST "%input_dirrectory%\0%%i" (
				echo Erreur, il semble qu'un fichier soit manquant dans le nombre des parties de celui-ci, le script ne peut continuer.
				goto:end_script
			)
			IF %%i NEQ !temp_count! (
				set copy_files_param=!copy_files_param!^"%input_dirrectory%\0%%i^" + 
			) else (
				set copy_files_param=!copy_files_param!^"%input_dirrectory%\0%%i^"
			)
		) else (
			IF NOT EXIST "%input_dirrectory%\%%i" (
				echo Erreur, il semble qu'un fichier soit manquant dans le nombre des parties de celui-ci, le script ne peut continuer.
				goto:end_script
			)
			IF %%i NEQ !temp_count! (
				set copy_files_param=!copy_files_param!^"%input_dirrectory%\%%i^" + 
			) else (
				set copy_files_param=!copy_files_param!^"%input_dirrectory%\%%i^"
			)
		)
	)
)
IF "%game_type%"=="1" (
	copy /v /b %copy_files_param% "%dump_output%%filename%.nsp"
) else IF "%game_type%"=="2" (
	copy /v /b %copy_files_param% "%dump_output%%filename%.xci"
) else IF "%game_type%"=="3" (
	copy /v /b %copy_files_param% "%dump_output%%filename%.nsp"
) else IF "%game_type%"=="4" (
	copy /v /b %copy_files_param% "%dump_output%%filename%.xci"
)
goto:end_script

:extract_input_filename
set input_filename=%~n1
set input_dirrectory=%~dp1
exit /b

:end_script
pause
:end_script_2
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
endlocal