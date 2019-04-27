# Ultimate-Switch-Hack-Script

Ceci est un ensemble de scripts batch automatisant beaucoup de choses.

La licence GPL V3 s'applique sur les scripts batch se trouvant à la racine de ce projet ainsi que sur le fichier "tools/python3_scripts/ssnc/serials.json.safe", le fichier "tools/python3_scripts/ssnc/serials.json.beta", le fichier "tools\python3_scripts\Keys_management\keys_management.py" et tous les fichiers se trouvant dans le répertoire "tools\Storage" de ce projet. Pour le reste, les licences propres aux logiciels concernés s'appliquent.

## Fonctionnalités

* Installation des drivers du mode RCM (driver "APX") et du mode libnx_USB_comms utilisé par Tinfoil (driver "libnx_USB_comms") de la Switch.
* Lancement d'un payload via le mode RCM de la Switch. Vous pouvez placer les payloads dans un dossier "Payloads" situé à la racine de ce script ou choisir un fichier de payload via un explorateur. Notez que les drivers du mode RCM de la Switch doivent être installé pour que cela fonctionne.
* Gestion d'une boîte à outils (toolbox) permettant de lancer des logiciels en mode autonome avec la possibilité de gérer une liste de logiciel personnel. Il est à noter que les programmes peuvent être intégré au dossier "tools\toolbox" du script se qui permet d'avoir un possibilité de portabilité si cela est souhaité. Enfin, évitez de modifier les fichiers de configuration de la toolbox à la main, préférez le script.
* Lancement de Linux via le mode RCM de la Switch (soit avec le kernel officiel, soit via un [kernel patché](https://gbatemp.net/attachments/image-gz-zip.121538/) (merci Krazer89 de GBATemp et à Killua de Logic-sunrise pour l'info) pour les SD non compatibles avec le kernel officiel), soit avec un fichier de kernel sélectionnalbe via un explorateur de fichiers. Notez que les drivers du mode RCM de la Switch doivent être installé pour que cela fonctionne.
* Récupération des biskey grace au payload Biskeydump dans le fichier "biskey.txt" qui sera situé à la racine du script (les biskey commencent à la ligne 7 du fichier). Notez que les drivers du mode RCM de la Switch doivent être installé pour que cela fonctionne.
* Téléchargement/mise à jour des binaires de Shofel2.
* Vérification si une console est patchée, peut-être patchée ou non patchée (fonctionnalité imparfaite, peut donner des résultats erronés, la base de donnée nécessite encore des ajustements).
* Montage de la partition Boot0, Boot1, EMMC ou de la carte SD comme périphérique de stockage USB sur le PC.
* Dump/restauration de nand ou de partitions de la Rawnand, extraction de partition d'un fichier de dump de la Rawnand, obtention d'infos sur la nand ou sur un fichier de dump...
* Création de packages de mise à jour via ChoiDuJour avec tous les paramètres.
* Téléchargement d'un firmware et préparation de la SD avec celui-ci pour ChoiDuJourNX, le homebrew est également copié durant ce script. Ce script permet également d'éventuellement  créé le package de mise à jour via ChoiDuJour dans la foulée.
* Préparation d'une SD, du formatage (FAT32 ou EXFAT) à la mise en place de différentes solutions, voir la documentation pour plus d'informations sur le contenu des packs.
* Lancement de NSC_Builder traduit en français par mes soins. Ce script est utile pour convertir des XCIs ou NSPs en XCIs ou NSPs. Les fichiers convertis via ce script sont nettoyé et rendus, en théorie, indétectable par Nintendo, surtout pour les NSPs. Enfin, ce script permet aussi de créé des NSPs ou XCIs contenant le jeu, ses mises à jour et DLCs dans un seul fichier. Pour plus d'infos, voir [cette page](https://github.com/julesontheroad/NSC_BUILDER).
* Réunification des fichiers d'un dump de la nand effectué par Hekate ou SX OS sur une SD formatée en FAT32 ou sur une SD trop petite pour accueillir le dump en une seule fois dans un fichier "rawnand.bin" qui pourra ensuite être réutilisé pour restaurer la nand.
* Conversion de fichiers XCI en NSP.
* Installation de NSP via Goldleaf et le réseau.
* Sauvegarde, restauration et réinitialisation des fichiers importants utilisés par le script.
* Vérification des NSPs.
* Conversion d'une sauvegarde de Zelda Breath Of The Wild du format Wii U vers Switch ou inversement.
* Extraction du certificat d'une console via le fichier "PRODINFO.bin" décrypté.
* Installation de NSP via Goldleaf en USB.
* Découpage de NSP ou de XCI pour pouvoir les mettre sur une SD formatée en FAT32.
* Lancement du nécessaire pour jouer en ligne sur le réseau alternatif Switch-Lan-Play. Une liste de serveurs peut aussi être créée.
* Création et lancement d'un serveur personnel pour Switch-Lan-Play.
* Lancement du compagnon pour le module HID_mitm.

## Bugs connus:

* L'utilisation de guillemets et de quelques autres signes dans les entrées utilisateurs fait planter le script.
* Lorsqu'une sortie console faite par un "echo" est effectuée, cela produit une erreur dans le fichier log. L'encodage en UTF-8 semble être à l'origine de ce problème mais je n'ai pas trouvé comment le résoudre pour l'instant.
* Le dump des biskey récupère également le résultat du programme TegraRcmSmash, les biskey commencent à partir de la ligne 7 du fichier.

## Crédits:

Il y a vraiment trop de monde à remercier pour tous les projets intégrés à ce script mais je remercie chaque contributeur de ces projets car sans eux ce script ne pourrait même pas exister (certains sont créditer dans la documentation). Je remercie également tout ceux qui m'aident à tester les scripts et ceux qui me suggèrent de nouvelles fonctionnalités.