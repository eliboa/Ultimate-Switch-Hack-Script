goto:%~1

:display_title
title Save important files of the script %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:filename_choice
set /p filename=Enter save name: 
goto:eof

:filename_empty_error
echo The save name couldn't be empty.
goto:eof

:filename_char_error
echo Unauthorized char in save name.
goto:eof

:output_folder_choice
%windir%\system32\wscript.exe //Nologo tools\Storage\functions\select_dir.vbs "templogs\tempvar.txt" "Select save output folder"
goto:eof

:save_begin
echo Creating save file...
goto:eof

:save_end
echo Save file created.
goto:eof