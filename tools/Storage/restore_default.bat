::Script by Shadow256
setlocal
chcp 65001 >nul
IF EXIST templogs\*.* rmdir /s /q templogs
IF EXIST downloads\*.* rmdir /s /q downloads
IF EXIST update_packages\*.* rmdir /s /q update_packages
IF EXIST TOOLS\Hactool_based_programs\keys.txt del /q TOOLS\Hactool_based_programs\keys.txt
IF EXIST TOOLS\Hactool_based_programs\keys.dat del /q TOOLS\Hactool_based_programs\keys.dat
IF EXIST TOOLS\Hactool_based_programs\ChoiDuJour_keys.txt del /q TOOLS\Hactool_based_programs\ChoiDuJour_keys.txt
IF EXIST "TOOLS\Hactool_based_programs\tools\update_update" rmdir /q /s "TOOLS\Hactool_based_programs\tools\update_update"
IF EXIST "TOOLS\Hactool_based_programs\4nxci_extracted_xci\*.*" rmdir /q /s "TOOLS\Hactool_based_programs\4nxci_extracted_xci"
IF EXIST "tools\netplay\servers_list.txt" del /q "tools\netplay\servers_list.txt"
IF EXIST "tools\NSC_Builder\keys.txt" del /q "tools\NSC_Builder\keys.txt"
IF EXIST "tools\Storage\verif_update.ini" del /q "tools\Storage\verif_update.ini"
del /q tools\sd_switch\cheats\profiles\*.ini 2>nul
del /q tools\sd_switch\emulators\profiles\*.ini 2>nul
del /q tools\sd_switch\mixed\profiles\*.ini 2>nul
del /q tools\sd_switch\modules\profiles\*.ini 2>nul
del /q tools\sd_switch\profiles\*.ini 2>nul
del /q tools\megatools\mega.ini
copy /v tools\default_configs\mega.ini tools\megatools\mega.ini
copy /v "tools\default_configs\servers_list.txt" "tools\netplay\servers_list.txt"
rmdir /s /q tools\toolbox
mkdir tools\toolbox
copy tools\default_configs\default_tools.txt tools\toolbox\default_tools.txt
copy nul tools\toolbox\user_tools.txt
IF EXIST log.txt del /q log.txt
IF EXIST biskey.txt del /q biskey.txt
IF EXIST HacDiskMount.log del /q HacDiskMount.log
IF EXIST tools\HacDiskMount\HacDiskMount.log del /q tools\HacDiskMount\HacDiskMount.log
echo Remise à zéro du script effectuée.
pause
endlocal