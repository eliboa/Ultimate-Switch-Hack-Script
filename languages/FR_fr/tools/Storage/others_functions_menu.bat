goto:%~1

:display_title
title Shadow256 Ultimate Switch Hack Script %ushs_version%
goto:eof

:display_menu
echo Menu des autres fonctionnalités
echo.
echo Que souhaitez-vous faire?
echo.
echo 1: Préparer une mise à jour via ChoiDuJour-NX sur la SD et/ou un package de mise à jour via ChoiDuJour en téléchargeant le firmware via internet?
echo.
echo 2: Convertir un fichier XCI ou NCA en NSP?
echo.
echo 3: Convertir un NSP pour le rendre compatible avec le firmware de la Switch le plus bas possible.
echo.
echo 4: Installer des NSP via Goldleaf et le réseau.
echo.
echo 5: Installer des NSP via Goldleaf et l'USB.
echo.
echo 6: Convertir une sauvegarde de Zelda Breath Of The Wild du format Wii U vers Switch ou inversement?
echo.
echo 7: Extraire le certificat d'une console?
echo.
echo 8: Vérifier des fichiers NSP?
echo.
echo 9: Découper un fichier NSP ou XCI en fichiers de 4 GO?
echo.
echo 10: Rassembler un XCI ou NSP découpé.
echo.
echo 11: Compresser/décompresser un jeu grâce à nsZip?
echo.
echo 12: Configurer l'émulateur Nes Classic Edition?
echo.
echo 13: Configurer l'émulateur Snes Classic Edition?
echo.
echo 14: Installer des applications Android ^(mode débogage USB requis^)?
echo.
echo N'importe quelle autre choix: Revenir au menu précédent?
echo.
echo.
set /p action_choice=Entrez le numéro correspondant à l'action à faire: 
goto:eof