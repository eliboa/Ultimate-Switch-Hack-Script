::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%ushs_base_path%=!
set associed_language_script=%ushs_base_path%%associed_language_script%
IF EXIST "%~0.version" (
	set /p this_script_version=<"%~0.version"
) else (
	set this_script_version=1.00.00
)
call "%associed_language_script%" "display_title"
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
call "%associed_language_script%" "intro"
pause
:define_action_choice
cls
set action_choice=
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "first_action_choice"
IF "%action_choice%"=="1" cls & goto:info_nand
IF "%action_choice%"=="2" cls & goto:dump_nand
IF "%action_choice%"=="3" cls & goto:restaure_nand
IF "%action_choice%"=="4" cls & goto:autorcm_management
IF "%action_choice%"=="5" (
	cls
	call tools\storage\nand_joiner.bat
	IF EXIST templogs (
		del /q templogs 2>nul
		rmdir /s /q templogs 2>nul
	)
	mkdir templogs
	goto:define_action_choice
)
IF "%action_choice%"=="6" (
	cls
	call tools\storage\nand_spliter.bat
	IF EXIST templogs (
		del /q templogs 2>nul
		rmdir /s /q templogs 2>nul
	)
	mkdir templogs
	goto:define_action_choice
)
IF "%action_choice%"=="7" (
	cls
	call tools\storage\emunand_partition_file_create.bat
	IF EXIST templogs (
		del /q templogs 2>nul
		rmdir /s /q templogs 2>nul
	)
	mkdir templogs
	goto:define_action_choice
)
IF "%action_choice%"=="8" (
	cls
	call tools\storage\extract_nand_files_from_emunand_partition_file.bat
	IF EXIST templogs (
		del /q templogs 2>nul
		rmdir /s /q templogs 2>nul
	)
	mkdir templogs
	goto:define_action_choice
)
IF "%action_choice%"=="9" (
	cls
	call tools\storage\nand_firmware_detect.bat
	IF EXIST templogs (
		del /q templogs 2>nul
		rmdir /s /q templogs 2>nul
	)
	mkdir templogs
	goto:define_action_choice
)
IF "%action_choice%"=="0" (
	cls
	call tools\storage\mount_discs.bat
	IF EXIST templogs (
		del /q templogs 2>nul
		rmdir /s /q templogs 2>nul
	)
	mkdir templogs
	goto:define_action_choice
)
goto:end_script

:info_nand
set input_path=
set action_choice=
call "%associed_language_script%" "nand_infos_begin"
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice% info_nand
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
	)
)
IF "%input_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:info_nand
)
tools\NxNandManager\NxNandManager.exe --info -i "%input_path%"
echo.
pause
goto:define_action_choice

:dump_nand
set input_path=
set output_path=
set action_choice=
call "%associed_language_script%" "dump_input_begin"
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice% dump_nand
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
	)
)
IF "%input_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:dump_nand
)
set partition=
call :get_type_nand "%input_path%"
IF /i "%nand_type%"=="RAWNAND" call :partition_select dump_nand
IF /i "%nand_type%"=="RAWNAND (splitted dump)" call :partition_select dump_nand
echo.
call "%associed_language_script%" "dump_output_folder_choice"
set /p output_path=<templogs\tempvar.txt
IF "%output_path%"=="" (
	call "%associed_language_script%" "dump_output_folder_empty_error"
	goto:dump_nand
)
IF NOT "%output_path%"=="" set output_path=%output_path%\
IF NOT "%output_path%"=="" set output_path=%output_path:\\=\%
call :get_type_nand "%input_path%"
IF NOT "%partition%"=="" (
	set output_path=%output_path%%partition%
) else (
	IF "%nand_type%"=="RAWNAND" (
		set output_path=%output_path%rawnand.bin
	) else IF "%nand_type%"=="RAWNAND (splitted dump)" (
		set output_path=%output_path%rawnand.bin
	) else (
		set output_path=%output_path%%nand_type%
	)
)
IF EXIST "%output_path%" (
	call "%associed_language_script%" "dump_erase_existing_file_choice"
)
IF NOT "%erase_output_file%"=="" set erase_output_file=%erase_output_file:~0,1%
IF EXIST "%output_path%" (
	IF /i NOT "%erase_output_file%"=="o" (
		call "%associed_language_script%" "canceled"
		goto:dump_nand
	) else (
		del /q "%output_path%"
	)
)
call :set_NNM_params
::echo -i "%input_path%" -o "%output_path%" %params%%lflags%
tools\NxNandManager\NxNandManager.exe -i "%input_path%" -o "%output_path%" %params%%lflags%
echo.
pause
goto:define_action_choice

:restaure_nand
set input_path=
set output_path=
call "%associed_language_script%" "restaure_input_file_begin"
pause
call :nand_file_input_select
IF "%input_path%"=="" (
	call "%associed_language_script%" "restaure_input_empty_error"
	echo.
	goto:define_action_choice
)
set action_choice=
call "%associed_language_script%" "restaure_output_begin"
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice% restaure_nand
IF "%action_choice%" == "0" (
	call :nand_file_output_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p output_path=<templogs\tempvar.txt
	)
)
IF "%output_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:restaure_nand
)
set partition=
call :get_type_nand "%output_path%"
IF /i "%nand_type%"=="RAWNAND" call :partition_select restaure_nand
IF /i "%nand_type%"=="RAWNAND (splitted dump)" call :partition_select restaure_nand
call :get_type_nand "%input_path%"
set input_nand_type=%nand_type%
IF "%input_nand_type%"=="UNKNOWN" (
	call "%associed_language_script%" "restaure_input_dump_invalid_error"
	goto:restaure_nand
)
IF "%input_nand_type%"=="RAWNAND (splitted dump)" (
	set input_nand_type=RAWNAND
)
call :get_type_nand "%output_path%"
set output_nand_type=%nand_type%
IF "%output_nand_type%"=="UNKNOWN" (
	call "%associed_language_script%" "restaure_output_dump_invalid_error"
	goto:restaure_nand
)
IF "%output_nand_type%"=="RAWNAND (splitted dump)" (
	set output_nand_type=RAWNAND
)

IF NOT "%partition%"=="" (
	IF NOT "%output_nand_type%"=="RAWNAND" (
		call "%associed_language_script%" "restaure_try_partition_on_other_than_rawnand_error"
		goto:restaure_nand
	) else (
		IF NOT "PARTITION %partition%"=="%input_nand_type%" (
			call "%associed_language_script%" "restaure_partitions_not_match_error"
			goto:restaure_nand
		)
	)
) else (
	IF NOT "%input_nand_type%"=="%output_nand_type%" (
		call "%associed_language_script%" "restaure_input_and_output_type_not_match_error"
		goto:restaure_nand
	)
)
call :set_NNM_params
::echo -i "%input_path%" -o "%output_path%" %params%%lflags%
tools\NxNandManager\NxNandManager.exe -i "%input_path%" -o "%output_path%" %params%%lflags%
echo.
pause
goto:define_action_choice

:autorcm_management
set input_path=
set action_choice=
call "%associed_language_script%" "autorcm_dump_choice_begin"
call :list_disk
call "%associed_language_script%" "nand_choice"
IF "%action_choice%" == "" (
	goto:define_action_choice
)
call :verif_disk_choice %action_choice% autorcm_management
IF "%action_choice%" == "0" (
	call :nand_file_input_select
) else (
	IF EXIST templogs\disks_list.txt (
		TOOLS\gnuwin32\bin\sed.exe -n %action_choice%p <templogs\disks_list.txt > templogs\tempvar.txt 2> nul
		set /p input_path=<templogs\tempvar.txt
	)
)
IF "%input_path%"=="" (
	call "%associed_language_script%" "dump_not_exist_error"
	echo.
	goto:autorcm_management
)
echo.
set action_choice=
set autorcm_param=
call "%associed_language_script%" "autorcm_choice"
IF "%action_choice%" == "1" (
	set autorcm_param=--enable_autoRCM
) else IF "%action_choice%" == "2" (
	set autorcm_param=--disable_autoRCM
) else (
	goto:autorcm_management
)
call :get_type_nand "%input_path%"
set input_nand_type=%nand_type%
IF NOT "%input_nand_type%"=="BOOT0" (
	call "%associed_language_script%" "autorcm_nand_type_must_be_boot0_error"
	goto:autorcm_management
)
tools\NxNandManager\NxNandManager.exe %autorcm_param% -i "%input_path%" >nul 2>&1
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "autorcm_action_error"
) else (
	IF "%action_choice%" == "1" call "%associed_language_script%" "autorcm_enabled_success"
IF "%action_choice%" == "2" call "%associed_language_script%" "autorcm_disabled_success"
)
echo.
pause
goto:define_action_choice

:get_type_nand
set nand_type=
set nand_file_or_disk=
set temp_input_file=%~1
tools\NxNandManager\NxNandManager.exe --info -i "%temp_input_file%" >templogs\infos_nand.txt
set temp_input_file=
tools\gnuwin32\bin\grep.exe "NAND type :" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p nand_type=<templogs\tempvar.txt
set nand_type=%nand_type:~1%
tools\gnuwin32\bin\grep.exe "File/Disk :" <"templogs\infos_nand.txt" | tools\gnuwin32\bin\cut.exe -d : -f 2 >templogs\tempvar.txt
set /p nand_file_or_disk=<templogs\tempvar.txt
set nand_file_or_disk=%nand_file_or_disk:~1%
exit /B

:list_disk
IF EXIST templogs\disks_list.txt del /q templogs\disks_list.txt
tools\NxNandManager\NxNandManager.exe --list >templogs\temp_disks_list.txt
if %errorlevel% EQU -1009 (
	del /q templogs\temp_disks_list.txt
	exit /B
)
TOOLS\gnuwin32\bin\grep.exe -c "" <templogs\temp_disks_list.txt > templogs\tempvar.txt
set /p count_disks=<templogs\tempvar.txt
set /a temp_count=0
set /a real_count=0
copy nul templogs\disks_list.txt >nul
:disks_listing
set /a temp_count+=1
IF %temp_count% GTR %count_disks% (
	goto:finish_disks_listing
)
TOOLS\gnuwin32\bin\sed.exe -n %temp_count%p <templogs\temp_disks_list.txt >templogs\tempvar.txt
set /p temp_disk=<templogs\tempvar.txt
IF NOT "%temp_disk:~0,4%" == "\\.\" goto:disks_listing
call :get_type_nand "%temp_disk%"
echo %temp_disk%>>templogs\disks_list.txt
set /a real_count=%real_count%+1
echo %real_count%: %temp_disk%;  %nand_type%
goto:disks_listing
:finish_disks_listing
del /q templogs\temp_disks_list.txt
exit /b

:nand_file_input_select
call "%associed_language_script%" "nand_file_select_choice"
set /p input_path=<templogs\tempvar.txt
exit /b

:nand_file_output_select
call "%associed_language_script%" "nand_file_select_choice"
set /p output_path=<templogs\tempvar.txt
exit /b

:verif_disk_choice
set choice=%~1
set label_verif_disk_choice=%~2
call TOOLS\Storage\functions\strlen.bat nb "%choice%"
set i=0
:check_chars_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_choice
		)
	)
	IF "!check_chars!"=="0" (
	call "%associed_language_script%" "nand_choice_char_error"
	goto:%label_verif_disk_choice%
	)
)
exit /b

:partition_select
set partition=
set label_partition_select=%~1
set choose_partition=
call "%associed_language_script%" "partition_choice_begin"
echo 1: PRODINFO.
echo 2: PRODINFOF.
echo 3: BCPKG2-1-Normal-Main
echo 4: BCPKG2-2-Normal-Sub
echo 5: BCPKG2-3-SafeMode-Main
echo 6: BCPKG2-4-SafeMode-Sub
echo 7: BCPKG2-5-Repair-Main
echo 8: BCPKG2-6-Repair-Sub
echo 9: SAFE
echo 10: SYSTEM
echo 11: USER
call "%associed_language_script%" "partition_choice"
IF "%choose_partition%" == "" goto:%label_partition_select%
call :verif_disk_choice %choose_partition% partition_select
IF %choose_partition% GTR 11 (
	call "%associed_language_script%" "bad_value"
	goto:partition_select
)
IF %choose_partition% EQU 1 set partition=PRODINFO
IF %choose_partition% EQU 2 set partition=PRODINFOF
IF %choose_partition% EQU 3 set partition=BCPKG2-1-Normal-Main
IF %choose_partition% EQU 4 set partition=BCPKG2-2-Normal-Sub
IF %choose_partition% EQU 5 set partition=BCPKG2-3-SafeMode-Main
IF %choose_partition% EQU 6 set partition=BCPKG2-4-SafeMode-Sub
IF %choose_partition% EQU 7 set partition=BCPKG2-5-Repair-Main
IF %choose_partition% EQU 8 set partition=BCPKG2-6-Repair-Sub
IF %choose_partition% EQU 9 set partition=SAFE
IF %choose_partition% EQU 10 set partition=SYSTEM
IF %choose_partition% EQU 11 set partition=USER
exit /b

:set_NNM_params
set params=
set lflags=
IF NOT "%partition%"=="" set params=-part=%partition% 
call "%associed_language_script%" "force_param_choice"
IF NOT "%force_option%"=="" set force_option=%force_option:~0,1%
IF /i "%force_option%"=="o" (
	set lflags=%lflags%FORCE 
)
call "%associed_language_script%" "skipmd5_param_choice"
IF NOT "%skip_md5%"=="" set skip_md5=%skip_md5:~0,1%
IF /i "%skip_md5%"=="o" (
	set lflags=%lflags%BYPASS_MD5SUM 
)
call "%associed_language_script%" "debug_param_choice"
IF NOT "%debug_option%"=="" set debug_option=%debug_option:~0,1%
IF /i "%debug_option%"=="o" (
	set lflags=%lflags%DEBUG_MODE 
)
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
)
endlocal