goto:%~1

:display_title
title Drivers install %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
echo This will will propose to install the drivers of the Switch on the computer.
echo For more infos on the different methods, choose to open the documentation when it will be proposed.
goto:eof

:install_choice
echo Drivers install
echo.
echo Choose how to install drivers:
echo.
echo 1: Automatic install for the RCM mode ^(recommanded for this mode^)?
echo 2: Install drivers via Zadig?
echo 3: Install drivers via the Windows Devices Manager?
echo 0: Launch the documentation?
echo All other choices: Bo back to previous menu?
echo.
set /p install_choice=Make your choice:  
goto:eof

:rcm_and_drivers_install_instructions
echo *********************************************
echo ***    CONNECTEZ LA SWITCH EN MODE RCM    ***
echo *********************************************
echo ***    Connect the Switch in RCM mode    ***
echo ********************************************* 
echo 1^) Connect the Switch to USB and shut down it.
echo 2^) Apply the JoyCon Haxx : PIN1 + PIN10 or PIN9 + PIN10
echo 3^) Maintain "Volume +" and press "Power"
echo 4^) When this is done, press a key to continue, accept the admin alert that will be shown and follow the instructions to install the drivers.
goto:eof

:test_payload_choice
set /p test_payload=Do you wish to launch a payload? ^(%lng_yes_choice%/%lng_no_choice%^): 
goto:eof

:zadig_launch_instructions
echo Zadig will be launched, accept the admin privileges elevation to use this program.
goto:eof

:manual_install_instructions
echo The Devices Manager will be launched.
echo The folder to select to  install the drivers is the "tools\drivers\manual_installation_usb_driver" folder on root of the script.
goto:eof