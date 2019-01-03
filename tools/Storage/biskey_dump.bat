::Script by Shadow256
chcp 65001 > nul
echo *********************************************
echo ***    CONNECTEZ LA SWITCH EN MODE RCM    ***
echo *********************************************
echo 1) Connecter la Switch en USB et l'éteindre
echo 2) Appliquer le JoyCon Haxx : PIN1 + PIN10 ou PIN9 + PIN10
echo 3) Faire un appui long sur VOLUME UP + appui court sur POWER
echo 4) Une fois le payload lancé sur la Switch, appuyez sur le bouton POWER de celle-ci
echo En attente d'une Switch en mode RCM...
tools\TegraRcmSmash\TegraRcmSmash.exe -w tools\biskeydump\biskeydump.bin BOOT:0x0 >biskey.txt
::TOOLS\gnuwin32\bin\tail.exe -q -n+7 biskey.txt > biskey2.txt
echo.
echo Clés récupérées avec succès.
pause