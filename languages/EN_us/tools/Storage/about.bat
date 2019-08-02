goto:%~1

:display_title
title About %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:action_choice
echo About
echo.
echo Script actual version: %ushs_version%
echo Packs actual version: %ushs_packs_version%
echo.
echo GPL V3 Licence  for my work ^(shadow256 on forums and shadow2560 on Github^), others softwares are on their own licences. Note that the language packs are also on GPL V3.
echo.
echo Language used info:
echo Name: %language_name%
echo Author^(s^): %language_authors%
echo.
echo Note: You must do the update twice if an update of the Update Manager is found.
echo.
echo What do you want to do?
echo 1: Display the most recent script changelog?
echo 2: Display the most recent packs changelog?
echo 3: Update all updatale elements ^(recomanded^) ^(the script will close after the update and must be restarted manualy^)?
echo 4: Force update  of th script ^(last choice^)  ^(the script will close after the update and must be restarted manualy^)?
echo 5: Donate to me?
echo All other choices: Go back to main menu?
echo.
set /p action_choice=Enter your choice: 
goto:eof

:no_internet_connection
echo No internet connection, displaying this information is not possible.
goto:eof