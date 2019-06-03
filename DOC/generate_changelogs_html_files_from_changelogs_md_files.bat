::script by shadow256
chcp 65001 >nul
call :write_begining_of_file "files\changelog.html"
call :write_begining_of_file "files\packs_changelog.html"
"..\tools\gnuwin32\bin\tail.exe" -n+1 <"..\changelog.md" >>"files\changelog.html"
"..\tools\gnuwin32\bin\tail.exe" -n+1 <"..\packs_changelog.md" >>"files\packs_changelog.html"
call :write_ending_of_file "files\changelog.html"
call :write_ending_of_file "files\packs_changelog.html"

:write_begining_of_file
set file=%~1
copy nul "%file%" >nul
echo ^<!DOCTYPE HTML^>>>"%file%"
echo ^<html lang="fr-FR"^>>>"%file%"
echo ^<head^>>>"%file%"
echo ^<title>Changelog Ultimate Switch Hack Script</title^>>>"%file%"
echo ^<meta charset="UTF-8"^>>>"%file%"
echo ^<meta http-equiv="X-UA-Compatible" content="IE=edge"^>>>"%file%"
echo ^</head^>>>"%file%"
echo ^<body^>>>"%file%"
exit /b

:write_ending_of_file
set file=%~1
echo ^</body^>>>"%file%"
echo ^</html^>>>"%file%"
exit /b