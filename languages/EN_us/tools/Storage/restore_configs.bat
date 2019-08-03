goto:%~1

:display_title
title Restaure a configuration of the script %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:restaure_file_select
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers ushs ^(*.ushs^)|*.ushs|" "Select restaure file" "templogs\tempvar.txt"
goto:eof

:restaure_success
echo Restaure success.
goto:eof

:restaure_cancel
echo Restaure canceled.
goto:eof