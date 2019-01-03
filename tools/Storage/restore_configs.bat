::Script by Shadow256
setlocal
chcp 65001 >nul
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
%windir%\system32\wscript.exe //Nologo TOOLS\Storage\functions\open_file.vbs "" "Fichiers ushs (*.ushs)|*.ushs|" "Sélection du fichier de restauration" "templogs\tempvar.txt"
set /p filepath=<templogs\tempvar.txt
IF NOT "%filepath%"=="" (
	TOOLS\7zip\7za.exe x -y -sccUTF-8 "%filepath%" -o"." -r
	echo Restauration terminée.
) else (
	echo Restauration annulée.
)
rmdir /s /q templogs
pause 
endlocal