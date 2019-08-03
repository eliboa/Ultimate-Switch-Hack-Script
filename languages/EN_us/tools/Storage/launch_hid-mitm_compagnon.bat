goto:%~1

:display_title
title Launch HID-mitm_compagnon %this_script_version% - Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:intro
ECHO ////////////////////// hid_mitm ^(starting script by Krank, modified by Shadow256^) //////////////////////
ECHO.
ECHO Working dir: %cd%
goto:eof

:ip_choice
set /p IP_Adress=Enter IP adress of your Switch or leave it empty to go back to previous menu: 
goto:eof