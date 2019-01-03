::script by shadow256
@echo off
echo Préparation et lancement du serveur...
echo cd server >tools\Switch_Lan_Play\Data\temp_script.bat
echo npm.cmd install >>tools\Switch_Lan_Play\Data\temp_script.bat
tools\Switch_Lan_Play\NodeJSPortable.exe
echo cd server >tools\Switch_Lan_Play\Data\temp_script.bat
echo npm.cmd run build >>tools\Switch_Lan_Play\Data\temp_script.bat
tools\Switch_Lan_Play\NodeJSPortable.exe
echo cd server >tools\Switch_Lan_Play\Data\temp_script.bat
echo npm.cmd start >>tools\Switch_Lan_Play\Data\temp_script.bat
start tools\Switch_Lan_Play\NodeJSPortable.exe
echo Le serveur pour Switch-Lan-Play devrait être lancé. Pour le fermer, faire le raccourci  "ctrl+c" ou fermer la fenêtre exécutant le serveur.
echo Ce script va se terminer et revenir au menu précédent si vous appuyez sur une touche mais cela ne fermera pas votre serveur actif.
pause >nul
del /q tools\Switch_Lan_Play\Data\temp_script.bat