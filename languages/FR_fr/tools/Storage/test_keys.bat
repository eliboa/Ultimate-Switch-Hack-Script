goto:%~1

:display_title
title Tester un fichier de clés %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo Ce script permet de vérifier le contenu d'un fichier de clés et d'indiquer les clés inconnues/uniques qu'il contient ainsi que les clés incorrecte.
goto:eof

:keys_file_choice
%windir%\system32\wscript.exe //Nologo "TOOLS\Storage\functions\open_file.vbs" "" "Tous les fichiers ^(*.*^)|*.*|" "Sélection du fichier de clés" "templogs\tempvar.txt"
goto:eof

:no_keys_file_selected_error
echo Aucun fichier sélectionné, le script va s'arrêter.
goto:eof