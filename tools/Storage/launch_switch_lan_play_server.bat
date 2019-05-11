::script by shadow256
@echo off
echo Préparation et lancement du serveur...
call :write_begin_node.js_launch_file
echo cd Switch_Lan_Play >>tools\Node.js_programs\App\Server.cmd
echo npm.cmd install >>tools\Node.js_programs\App\Server.cmd
tools\Node.js_programs\NodeJSPortable.exe
call :write_begin_node.js_launch_file
echo cd Switch_Lan_Play >>tools\Node.js_programs\App\Server.cmd
echo npm.cmd run build >>tools\Node.js_programs\App\Server.cmd
tools\Node.js_programs\NodeJSPortable.exe
call :write_begin_node.js_launch_file
echo cd Switch_Lan_Play >>tools\Node.js_programs\App\Server.cmd
echo npm.cmd start >>tools\Node.js_programs\App\Server.cmd
start tools\Node.js_programs\NodeJSPortable.exe
echo Le serveur pour Switch-Lan-Play devrait être lancé. Pour le fermer, faire le raccourci  "ctrl+c" ou fermer la fenêtre exécutant le serveur.
echo Ce script va se terminer et revenir au menu précédent si vous appuyez sur une touche mais cela ne fermera pas votre serveur actif.
pause
del /q tools\Node.js_programs\App\Server.cmd
copy tools\Node.js_programs\App\Server.cmd.orig tools\Node.js_programs\App\Server.cmd >nul

:write_begin_node.js_launch_file
echo @echo off>tools\Node.js_programs\App\Server.cmd
echo title NodeJS>>tools\Node.js_programs\App\Server.cmd
echo cls>>tools\Node.js_programs\App\Server.cmd
echo echo.>>tools\Node.js_programs\App\Server.cmd
echo echo Node>>tools\Node.js_programs\App\Server.cmd
echo node --version>>tools\Node.js_programs\App\Server.cmd
echo echo.>>tools\Node.js_programs\App\Server.cmd
exit /b