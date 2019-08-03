goto:%~1

:display_title
title Main menu %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:display_menu
echo ::Shadow256 Ultimate Switch Hack Script %ushs_version%::
echo :::::::::::::::::::::::::::::::::::::
echo.
echo Main menu
echo.
echo What do you want to do?
echo.
echo 1: Launch a payload via the RCM mode?
echo.
echo 2: Launch a payload with PegaScape/PegaSwitch or prepare the SD with the necessary files?
echo.
echo 3: Mount the nand, the boot0 partition, the boot1 partition or the SD card like an HDD on your OS?
echo.
echo 4: Prepare a SD card for the hack?
echo.
echo 5: Nand toolbox?
echo.
echo 6: Launch NSC_Builder witch could display infos, to convert NSPs/XCIs, see the documentation for more infos?
echo.
echo 7: Launch or configure the software toolbox?
echo.
echo 8: Other functions?
echo.
echo 9: Ocasionnal functions?
echo.
echo 10: Save/restaure and script's settings?
echo.
echo 11: Launch or configure the network gaming client ^(Switch-Lan-Play client^)?
echo.
echo 12: Launch a network gaming server ^(Switch-Lan-Play server^)?
echo.
echo 13: change language?
echo.
echo 14: About the script?
echo.
echo 15: Donate to me?
echo.
echo 0: Launch the documentation ^(recommanded^)?
echo.
echo All other choices: exit?
echo.
echo.
set /p action_choice=Make your choice: 
goto:eof