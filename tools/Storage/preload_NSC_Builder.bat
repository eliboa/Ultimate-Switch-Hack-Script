::Script by Shadow256
@echo off
chcp 65001 >nul
Setlocal enabledelayedexpansion
cd >temp.txt
set /p calling_script_dir=<temp.txt
del /q temp.txt
set this_script_dir=%~dp0
%this_script_dir:~0,1%:
cd "%this_script_dir%"
IF EXIST "%calling_script_dir%\templogs\*.*" (
	del /q "%calling_script_dir%\templogs" 2>nul
	rmdir /s /q "%calling_script_dir%\templogs" 2>nul
)
mkdir "%calling_script_dir%\templogs"
cd ..\Hactool_based_programs
IF NOT EXIST "..\NSC_Builder\keys.txt" (
	IF EXIST keys.dat (
		copy keys.dat ..\NSC_Builder\keys.txt
		goto:skip_keys_file_creation
	) else IF EXIST keys.txt (
		copy keys.txt ..\NSC_Builder\keys.txt
		goto:skip_keys_file_creation
		) else (
		echo Fichiers clés non trouvé, veuillez suivre les instructions.
		goto:keys_file_creation
	)
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
	
	copy "%keys_file_path%" ..\NSC_Builder\keys.txt
	
:skip_keys_file_creation
%calling_script_dir:~0,1%:
cd "%calling_script_dir%"
call TOOLS\NSC_Builder\NSCB.bat
color
title Shadow256 Ultimate Switch Hack Script %ushs_version%
cd ..\..
echo.
set /p open_output_dir=Souhaitez-vous ouvrir le répertoire contenant les fichiers convertis? (O/n): 
IF NOT "%open_output_dir%"=="" set open_output_dir=%open_output_dir:~0,1%
IF /I "%open_output_dir%"=="o" (
	"TOOLS\NSC_Builder\ztools\listmanager\listmanager.exe" -rl "TOOLS\NSC_Builder\zconfig\NSCB_options.cmd" -ln "10" -nl "Output dir: " | TOOLS\gnuwin32\bin\cut.exe -d = -f 2 >templogs\tempvar.txt
	set /p NSCB_output_dir=<templogs\tempvar.txt
)
set NSCB_output_dir=%NSCB_output_dir:"=%
IF /I "%open_output_dir%"=="o" (
	IF "%NSCB_output_dir:~1,1%"==":" (
		start explorer.exe "%NSCB_output_dir%"
	) else (
		start explorer.exe "%~dp0..\NSC_Builder\%NSCB_output_dir%"
	)
)
set open_output_dir=
set NSCB_output_dir=
:endscript
pause
%calling_script_dir:~0,1%:
cd "%calling_script_dir%"
IF EXIST templogs\*.* (
	rmdir /s /q templogs
)
endlocal