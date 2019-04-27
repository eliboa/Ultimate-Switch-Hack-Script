::Script by Shadow256
@echo off
chcp 65001 >nul
Setlocal disabledelayedexpansion
echo.
IF "%profile_selected%"=="" (
	echo Résumé de se qui sera copié sur la SD, lecteur "%volume_letter%:":
) else (
	echo Résumé du profile %profile_selected:~0,-4%:
)
echo.
echo CFWs et packs:
IF /i "%copy_atmosphere_pack%"=="o" (
	IF /i "%atmosphere_enable_nogc_patch%"=="o" (
		IF /i NOT "%atmosphere_enable_prodinfo_write%"=="o" (
			echo Pack Atmosphere et Kosmos avec le patche NOGC, écriture sur PRODINFO désactivée
		) else (
			echo Pack Atmosphere et Kosmos avec le patche NOGC, écriture sur PRODINFO activée
		)
	) else (
		IF /i NOT "%atmosphere_enable_prodinfo_write%"=="o" (
			echo Pack Atmosphere et Kosmos, écriture sur PRODINFO désactivée
		) else (
			echo Pack Atmosphere et Kosmos, écriture sur PRODINFO activée
		)
	)
	IF NOT "%atmosphere_pass_copy_modules_pack%"=="Y" (
		Echo Modules optionnels pour Atmosphere:
		tools\gnuwin32\bin\sort.exe -n "%atmosphere_modules_profile_path%"
	) else (
		echo Aucun module optionnel à copier.
	)
	echo.
	IF /i NOT "%atmosphere_manual_config%"=="o" (
		echo Configuration du CFW par défaut.
	) else (
		echo Configuration manuelle du CFW avec les paramètres suivants:
		IF /i "%atmo_upload_enabled%"=="o" (
			echo Upload d'infos vers les serveurs de Nintendo activé.
		) else (
			echo Upload d'infos vers les serveurs de Nintendo désactivé.
		)
		IF /i "%atmo_usb30_force_enabled%"=="o" (
			echo USB3 activé.
		) else (
			echo USB3 désactivé.
		)
		IF /i "%atmo_ease_nro_restriction%"=="o" (
			echo Restrictions NRO activées.
		) else (
			echo Restrictions NRO désactivées.
		)
		IF /i "%atmo_dmnt_cheats_enabled_by_default%"=="o" (
			echo Etat des cheats par défaut: activé.
		) else (
			echo Etat des cheats par défaut: désactivé.
		)
		IF /i "%atmo_dmnt_always_save_cheat_toggles%"=="o" (
			echo Sauvegarde automatique de l'état des cheats: toujours.
		) else (
			echo Sauvegarde automatique de l'état des cheats: seulement si un fichier d'état existe pour le jeu.
		)
		IF /i "%atmo_fsmitm_redirect_saves_to_sd%"=="o" (
			echo Redirection des sauvegardes de jeu vers la SD activée.
		) else (
			echo Redirection des sauvegardes de jeu vers la SD désactivée.
		)
		IF "%atmo_fatal_auto_reboot_interval%"=="0" (
			echo Temps avant de redémarrer en cas de crash: jusqu'à l'appui d'une touche par l'utilisateur
		) else (
			echo Temps avant de redémarrer en cas de crash: %atmo_fatal_auto_reboot_interval% MS
		)
		IF "%atmo_power_menu_reboot_function%"=="1" (
			echo Action du menu redémarrer: redémarre le payload "/atmosphere/reboot_to_payload.bin" de la SD.
		) else IF "%atmo_power_menu_reboot_function%"=="2" (
			echo Action du menu redémarrer: redémarre en RCM.
		) else IF "%atmo_power_menu_reboot_function%"=="3" (
			echo Action du menu redémarrer: redémarre normalement.
		)
		IF "%inverted_atmo_hbl_override_key%"=="Y" (
			echo Touche associée à l'activation du Homebrew Menu: toutes sauf %atmo_hbl_override_key%
		) else (
			echo Touche associée à l'activation du Homebrew Menu: %atmo_hbl_override_key%
		)
		IF "%inverted_atmo_cheats_override_key%"=="Y" (
			echo Touche associée à l'activation des cheats: toutes sauf %atmo_cheats_override_key%
		) else (
			echo Touche associée à l'activation des cheats: %atmo_cheats_override_key%
		)
		IF "%inverted_atmo_layeredfs_override_key%"=="Y" (
			echo Touche associée à l'activation de Layeredfs: toutes sauf %atmo_layeredfs_override_key%
		) else (
			echo Touche associée à l'activation de Layeredfs: %atmo_layeredfs_override_key%
		)
	)
	echo.
)
IF /i "%copy_reinx_pack%"=="o" (
	IF /i "%reinx_enable_nogc_patch%"=="o" (
		echo Pack ReiNX avec le patche NOGC
	) else (
	echo Pack ReiNX
	)
	IF NOT "%reinx_pass_copy_modules_pack%"=="Y" (
		Echo Modules optionnels pour ReiNX:
		tools\gnuwin32\bin\sort.exe -n "%reinx_modules_profile_path%"
	) else (
		echo Aucun module optionnel à copier.
	)
	echo.
)
IF /i "%copy_sxos_pack%"=="o" (
	IF /i "%copy_payloads%"=="o" (
		echo Pack SX OS avec copie de payloads des autres CFWs sélectionnés à la racine de la SD pour être lancés via le SX Loader
	) else (
		echo Pack SX OS
	)
	echo.
)
IF /i "%copy_memloader%"=="o" (
	echo Pack Memloader
	echo.
)
IF /i "%copy_emu%"=="o" (
	IF /i "%keep_emu_configs%"=="o" (
		echo Pack d'émulateurs avec concervation des fichiers de configurations de ceux-ci sur la SD
	) else (
		echo Pack d'émulateurs avec suppression des fichiers de configurations de ceux-ci sur la SD
	)
	echo.
)
echo.
echo Homebrews optionnels:
IF "%pass_copy_mixed_pack%"=="Y" (
	echo Aucun homebrew optionnel ne sera copié.
) else (
	tools\gnuwin32\bin\sort.exe -n "%mixed_profile_path%"
)
echo.
IF /i "%copy_emu%"=="o" (
	echo émulateurs:
	IF "%pass_copy_emu_pack%"=="Y" (
		echo Aucun émulateur ne sera copié.
	) else (
		tools\gnuwin32\bin\sort.exe -n "%emu_profile_path%"
	)
	echo.
)
IF "%copy_cheats%"=="Y" (
	echo Cheats:
	IF "%copy_all_cheats_pack%"=="Y" (
		echo La base de données des cheats sera entièrement copiée.
	) else (
		echo Profile de cheats choisi: %cheats_profile_name%
	)
	IF /i "%atmosphere_enable_cheats%"=="o" (
		echo Les cheats pour Atmosphere seront copiés.
	) else (
		echo Les cheats pour Atmosphere ne seront pas copiés.
	)
	IF /i "%sxos_enable_cheats%"=="o" (
		echo Les cheats pour SX OS seront copiés.
	) else (
		echo Les cheats pour SX OS ne seront pas copiés.
	)
	echo.
)
IF /i "%del_files_dest_copy%"=="1" echo Attention: Les fichiers de tous les CFWs seront réinitialisé avant la copie, dossier "titles" de ceux-ci inclus.
IF /i "%del_files_dest_copy%"=="2" echo Attention: Les fichiers de la SD seront intégralement supprimés avant la copie.
IF /i "%del_files_dest_copy%"=="0" echo Les fichiers de la SD seront concervés et seul les fichiers mis à jour seront remplacés.
endlocal