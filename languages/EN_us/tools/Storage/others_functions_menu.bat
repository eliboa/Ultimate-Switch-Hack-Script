goto:%~1

:display_title
title Other functions menu %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:display_menu
echo Other functions menu
echo.
echo What do you want to do?
echo.
echo 1: Prepare a SD with update that could be used with ChoiDuJourNX and/or prepare a ChoiDuJour package; firmware will be downloaded with internet?
echo.
echo 2: Convert a XCI or NCA file in NSP?
echo.
echo 3: Convert a NSP to try to make it compatible with the lowest possible firmware?
echo.
echo 4: Install NSPs via the network and Goldleaf?
echo.
echo 5: Install NSPs via USB and Goldleaf?
echo.
echo 6: Convert a Zelda Breath Of The Wild gamesave from Switch to Wii U or Wii U to Switch?
echo.
echo 7: Extract the certificat of a device?
echo.
echo 8: Verify NSP files?
echo.
echo 9: Split NSPs/XCIs?
echo.
echo 10: Merge a XCI/NSP splited?
echo.
echo 11: Compress/uncompress a game with nsZip?
echo.
echo 12: Configure the emulator Nes Classic Edition?
echo.
echo 13: Configure the emulator Snes Classic Edition?
echo.
echo 14: Install Android APPS ^(USB debugging  MODE REQUIRED^)?
echo.
echo All other choices: Go back to main menu?
echo.
echo.
set /p action_choice=Make your choice: 
goto:eof