::script by shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "start_launch"
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
call "%associed_language_script%" "end_launch"
pause
del /q tools\Node.js_programs\App\Server.cmd
copy tools\Node.js_programs\App\Server.cmd.orig tools\Node.js_programs\App\Server.cmd >nul
goto:end_script

:write_begin_node.js_launch_file
echo @echo off>tools\Node.js_programs\App\Server.cmd
echo title NodeJS>>tools\Node.js_programs\App\Server.cmd
echo cls>>tools\Node.js_programs\App\Server.cmd
echo echo.>>tools\Node.js_programs\App\Server.cmd
echo echo Node>>tools\Node.js_programs\App\Server.cmd
echo node --version>>tools\Node.js_programs\App\Server.cmd
echo echo.>>tools\Node.js_programs\App\Server.cmd
exit /b

:end_script
endlocal