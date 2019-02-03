#!/usr/bin/python
# -*- coding:Utf-8 -*-

"""
	This file has been created by shadow256 
	This file is on GPL V3 licence
"""

from copy import deepcopy
import sys
import hashlib
import os
# import time

# start_time = time.time()

def file_exist(fname):
	try:
		f = open(fname,'r')
		f.close()
		return 1
	except:
		return 0

def create_md5_file(keys_file):
	keys_source_file = open(keys_file, 'r', encoding='utf-8')
	keys_source_list = keys_source_file.readlines()
	keys_source_file.close()
	i = 0
	for item in keys_source_list:
		if (item == ''):
			continue
		keys_source_list[i] = item.split('=')
		keys_source_list[i][0] = keys_source_list[i][0].strip()
		keys_source_list[i][1] = keys_source_list[i][1][0:-1].strip()
		i +=1
	i = 0
	md5_list = deepcopy(keys_source_list)
	md5_output_file = open(os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'md5_sources.txt'), 'w', encoding='utf-8')
	for item in keys_source_list:
		md5_list[i][1] = hashlib.md5(item[1].upper().encode('utf-8')).hexdigest()
		md5_output_file.write(md5_list[i][0] + ' = ' + md5_list[i][1] + '\n')
		i +=1
	md5_output_file.close()
	return 1

def test_keys_file(keys_file):
	keys_source_file = open(keys_file, 'r', encoding='utf-8')
	keys_source_list = keys_source_file.readlines()
	keys_source_file.close()
	i = 0
	for item in keys_source_list:
		if (item == ''):
			continue
		keys_source_list[i] = item.split('=')
		keys_source_list[i][0] = keys_source_list[i][0].strip()
		keys_source_list[i][1] = keys_source_list[i][1][0:-1].strip()
		i +=1
	i = 0
	md5_list = deepcopy(keys_source_list)
	for item in keys_source_list:
		md5_list[i][1] = hashlib.md5(item[1].upper().encode('utf-8')).hexdigest()
		i += 1
	md5_source_file = open(os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'md5_sources.txt'), 'r', encoding='utf-8')
	md5_source_list = md5_source_file.readlines()
	md5_source_file.close()
	i = 0
	for item in md5_source_list:
		if (item == ''):
			continue
		md5_source_list[i] = item.split('=')
		md5_source_list[i][0] = md5_source_list[i][0].strip()
		md5_source_list[i][1] = md5_source_list[i][1][0:-1].strip()
		i +=1
	keys_not_verified = []
	keys_incorrect =[]
	for keys_source in md5_list:
		i = 0
		for keys_verified in md5_source_list:
			if (keys_source[0] == keys_verified[0]):
				if (keys_source[1] != keys_verified[1]):
					keys_incorrect.append(keys_source[0])
				break
			else:
				if (i+1 == len(md5_source_list)):
					keys_not_verified.append(keys_source[0])
			i += 1
	i = 0
	for key_name in keys_not_verified:
		j = 0
		for keys in keys_source_list:
			if (key_name == keys[0]):
				del(keys_source_list[j])
				del(md5_list[j])
				break
			j += 1
		i += 1
	i = 0
	for key_name in keys_incorrect:
		j = 0
		for keys in keys_source_list:
			if (key_name == keys[0]):
				del(keys_source_list[j])
				del(md5_list[j])
				break
			j += 1
		i += 1
	print ('nombre de clés possibles à analyser: ' + str(len(md5_source_list)))
	if (len(keys_not_verified) == 0):
		print ('Aucune clé inconnue ou unique à la console trouvée')
	elif (len(keys_not_verified) == 1):
		print ('Clé inconnue ou unique à la console trouvée: ' + keys_not_verified[0])
	else:
		print ('Clés inconnues ou uniques à la console trouvées: ' + ', '.join(keys_not_verified))
	if (len(keys_incorrect) == 0):
		print ('Aucune clé incorrecte trouvée.')
	elif (len(keys_incorrect) == 1):
		print ('Clé incorrecte trouvée: ' + keys_incorrect[0])
	else:
		print ('Clés incorrectes trouvées: ' + ', '.join(keys_incorrect))
	return(keys_source_list)

def create_choidujour_keys_file(keys_file):
	keys_source_list = test_keys_file(keys_file)
	choidujour_keys_needed = ['master_key_source', 'master_key_00', 'master_key_01', 'header_key', 'aes_kek_generation_source', 'aes_key_generation_source', 'key_area_key_application_source', 'key_area_key_ocean_source', 'key_area_key_system_source', 'package2_key_source']
	choidujour_keys_prefered = ['master_key_02', 'master_key_03', 'master_key_04', 'master_key_05', 'master_key_06', 'master_key_07']
	choidujour_list_prefered_usable = []
	stop_keys_prefered_insertion = 0
	for keys_prefered in choidujour_keys_prefered:
		j = 0
		for keys_source in keys_source_list:
			if (keys_source[0] == keys_prefered):
				choidujour_list_prefered_usable.append(keys_source)
				break
			else:
				if (j+1 == len(keys_source_list)):
					stop_keys_prefered_insertion = 1
			j +=1
		if (stop_keys_prefered_insertion == 1):
			break
	choidujour_list_needed_usable = []
	stop_keys_needed_insertion = 0
	for keys_needed in choidujour_keys_needed:
		j = 0
		for keys_source in keys_source_list:
			if (keys_source[0] == keys_needed):
				choidujour_list_needed_usable.append(keys_source)
				break
			else:
				if (j+1 == len(keys_source_list)):
					stop_keys_needed_insertion = 1
			j +=1
		if (stop_keys_needed_insertion == 1):
			print ('La clé "' + keys_needed + '" obligatoire ne se trouve pas dans le fichier de clé, le script ne peux pas continuer.')
			return 0
	print('La dernière clé facultative trouvée est la clé "' + choidujour_list_prefered_usable[-1][0] + '", vous ne pourrez générer que des packages de mise à jour jusqu\'au firmware n\'utilisant que les clés jusqu\'à celle-ci.')
	choidujour_keys_file = open('ChoiDuJour_keys.txt', 'w', encoding='utf-8')
	choidujour_keys_file.write(choidujour_list_needed_usable[0][0] + ' = ' + choidujour_list_needed_usable[0][1] + '\n')
	choidujour_keys_file.write(choidujour_list_needed_usable[1][0] + ' = ' + choidujour_list_needed_usable[1][1] + '\n')
	choidujour_keys_file.write(choidujour_list_needed_usable[2][0] + ' = ' + choidujour_list_needed_usable[2][1] + '\n')
	del(choidujour_list_needed_usable[0])
	del(choidujour_list_needed_usable[0])
	del(choidujour_list_needed_usable[0])
	for keys_source in choidujour_list_prefered_usable:
		choidujour_keys_file.write(keys_source[0] + ' = ' + keys_source[1] + '\n')
	for keys_source in choidujour_list_needed_usable:
		choidujour_keys_file.write(keys_source[0] + ' = ' + keys_source[1] + '\n')
	choidujour_keys_file.close()
	print ('Création du fichier "ChoiDuJour_keys.txt" effectuée avec succès.')
	return 1

def help():
	print ('Utilisation:')
	print()
	print('keys_management.py Action Fichier_de_clés')
	print()
	print('Le paramètre "Action" peut avoir les valeurs suivantes:')
	print('create_md5_file : Cré le fichier MD5 servant ensuite à la vérification des clés. La fonction analyse le fichier de clés et cré un fichier contenant le nom de chaque clé associé au MD5 de celle-ci. Attention car aucune vérification n\'est faite sur les clés uniques pour chaque console ou pour des erreurs éventuelles donc soyez certain de se que vous faites si vous utilisez cette fonction car l\'ancien fichier de vérification sera supprimé.')
	print ('test_keys_file : Test un fichier de clés en le comparant au fichier contenant les MD5 des clés connues et affiche le nombre de clés analysées, les clés inconnues ou uniques à la console trouvées ainsi que les clés incorrectes trouvées.')
	print ('create_choidujour_keys_file : Permet de créé un fichier de clés ne contenant que les clés nécessaire à ChoiDuJour pour créer un package de mise à jour. Le fichier sera nommé "ChoiDuJour_keys.txt" et se trouvera dans le dossier à partir duquel le script a été exécuté.')
	return 1

if (len(sys.argv) != 3):
	print ('Nombre d\'arguments incorrect.')
	help()
	sys.exit(102)
if not (file_exist(sys.argv[2])):
	print ('Le fichier indiqué dans le second argument n\'existe pas.')
	sys.exit(101)
if (sys.argv[1] == 'create_md5_file'):
	create_md5_file(sys.argv[2])
	sys.exit(0)
elif (sys.argv[1] == 'test_keys_file'):
	test_keys_file(sys.argv[2])
	# print("Temps d execution : %s secondes ---" % (time.time() - start_time))
	sys.exit(0)
elif (sys.argv[1] == 'create_choidujour_keys_file'):
	create_choidujour_keys_file(sys.argv[2])
	sys.exit(0)
else:
	print ('Premier argument incorrect')
	help()
	sys.exit(100)