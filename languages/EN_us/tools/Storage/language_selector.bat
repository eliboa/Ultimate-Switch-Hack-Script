goto:%~1

:display_title
title Language change %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:language_list_downloading
echo Downloading languages list...
goto:eof

:language_choice_begin
echo Choose language
goto:eof

:language_choice
set /p temp_language_number=Choose the wanted language: 
goto:eof

:language_choice_empty_error
echo Language choice couldn't be empty.
goto:eof

:language_choice_char_error
echo Unauthorized char in language choice.
goto:eof

:language_choice_bad_value_error
echo Unauthorized value in language choice.
goto:eof

:init_language_error
echo Initialisation of the new language error, the language will not be changed.
goto:eof

:language_change_success
echo Language change success.
echo The script will restart to apply the changes.
goto:eof

:no_internet_connection_error
echo No internet connexion, continuing the script is not possible.
goto:eof