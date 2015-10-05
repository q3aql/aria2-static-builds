@echo off
 
rem # aria2 script for bittorrent downloads.
rem # http://aria2.sourceforge.net/
rem # Created by clamsawd (clamsawd@openmailbox.org)
rem # Licensed by GPL v.2
rem # Last update: 03-10-2015
rem # --------------------------------------
 set VERSION=7.1
 
 set COMMAND_TEST=aria2c -v
 set ARIA2_PATH=%USERPROFILE%\aria2
 set CONFIG_FILE=%ARIA2_PATH%\aria2bt-conf.cmd
 
 if not exist %ARIA2_PATH% mkdir %ARIA2_PATH%
 if exist %CONFIG_FILE% goto load_config_file
 if not exist %CONFIG_FILE% goto create_config_file
 
 :create_config_file
   echo rem # DEFAULT ARIA2BT SCRIPT CONFIG > %CONFIG_FILE%
   echo. >> %CONFIG_FILE%
   echo set DISC_FILES=C:>> %CONFIG_FILE%
   echo set TORRENT_FOLDER=C:\Torrent>> %CONFIG_FILE%
   echo set TORRENT_FILES=C:\Torrent\Files>> %CONFIG_FILE%
   echo set MAX_SPEED_DOWNLOAD=300K>> %CONFIG_FILE%
   echo set MAX_SPEED_UPLOAD=5K>> %CONFIG_FILE%
   echo set BT_MAX_PEERS=25>> %CONFIG_FILE%
   echo set MAX_DOWNLOADS=25>> %CONFIG_FILE%
   echo set ENCRYPTION=yes>> %CONFIG_FILE%
   echo set RPC=yes>> %CONFIG_FILE%
   echo set RPC_PORT=6800>> %CONFIG_FILE%
   echo set DEBUG=no>> %CONFIG_FILE%
   echo set SEEDING=yes>> %CONFIG_FILE%
   echo set SEED_RATIO=0.0>> %CONFIG_FILE%
   echo set DEBUG_LEVEL=info>> %CONFIG_FILE%
   echo set FILE_ALLOCATION=none>> %CONFIG_FILE%
   echo set CA_CERTIFICATE=no>> %CONFIG_FILE%
   echo set CA_CERTIFICATE_FILE=C:\Program Files\aria2\certs\ca-certificates.crt>> %CONFIG_FILE%
   call %CONFIG_FILE%
  
 :load_config_file
 
   call %CONFIG_FILE%
 
 rem # VARIABLES
 set SPEED_OPTIONS=--max-overall-download-limit=%MAX_SPEED_DOWNLOAD% --max-overall-upload-limit=%MAX_SPEED_UPLOAD%
 set PEER_OPTIONS=--bt-max-peers=%BT_MAX_PEERS%
 if %CA_CERTIFICATE%==no set OTHER_OPTIONS=-V -j %MAX_DOWNLOADS% --file-allocation=%FILE_ALLOCATION% --auto-file-renaming=false --allow-overwrite=false
 if %CA_CERTIFICATE%==yes set OTHER_OPTIONS=-V -j %MAX_DOWNLOADS% --file-allocation=%FILE_ALLOCATION% --auto-file-renaming=false --allow-overwrite=false --ca-certificate="%CA_CERTIFICATE_FILE%"
 set TEMP_FILE=aria2-list.txt
 
 if %ENCRYPTION%==yes set TORRENT_OPTIONS=--bt-min-crypto-level=arc4 --bt-require-crypto=true
 if %RPC%==yes set RPC_OPTIONS=--enable-rpc --rpc-listen-all=true --rpc-allow-origin-all --rpc-listen-port=%RPC_PORT%
 if %ENCRYPTION%==no set TORRENT_OPTIONS=--bt-require-crypto=false
 if %RPC%==no set RPC_OPTIONS=--rpc-listen-all=false
 if %SEEDING%==no set SEED_OPTIONS=--seed-time=0
 if %SEEDING%==yes set SEED_OPTIONS=--seed-ratio=%SEED_RATIO%
 
 set ALL_OPTIONS=%TORRENT_OPTIONS% %SPEED_OPTIONS% %PEER_OPTIONS% %RPC_OPTIONS% %SEED_OPTIONS%

 :check_aria2_system
   %COMMAND_TEST%
   if %ERRORLEVEL%==0 goto check_input
   cls
   echo.
   echo Error: 'aria2' is not installed!
   echo Help: http://aria2.sourceforge.net/
   echo.
   echo Press 'ENTER' to exit
   pause > nul
   exit

 :check_input

   if exist "%1" goto input_file
   if "%1"=="--help" goto show_help
   if "%1"=="--now" goto run_now
   if not exist "%1" goto aria2_run

 :show_help
   cls
   echo.
   echo ** aria2 bittorrent script v.%VERSION% **
   echo.
   echo USAGE:
   echo.
   echo aria2bt.cmd [parameter / file.torrent]
   echo.
   echo AVAILABLE PARAMETERS:
   echo.
   echo --help - Show help
   echo --now  - Run immediately the script without menu
   echo.
   echo Note: If you run the script without parameters,
   echo       this will show a menu with all options.
   echo.
   goto exit_aria2_script
 
 :run_now
   cls
   echo.
   echo ** aria2 bittorrent script v.%VERSION% **
   echo.
   %DISC_FILES%
   cd %TORRENT_FILES%
   dir /B | find ".torrent" > %TEMP_FILE%
   if %DEBUG%==yes (
   aria2c %OTHER_OPTIONS% -i %TEMP_FILE% %ALL_OPTIONS% -d %TORRENT_FOLDER% --console-log-level=%DEBUG_LEVEL%)
   if %DEBUG%==no (
   aria2c %OTHER_OPTIONS% -i %TEMP_FILE% %ALL_OPTIONS% -d %TORRENT_FOLDER%) 
   goto aria2_run

 :input_file
   cls
   echo.
   echo * File detected: "%1"
   echo.
   echo - Do you want to copy file to "%TORRENT_FILES%" directory
   set /p LOAD=and run aria2 (y/n): 
   if %LOAD%==* goto copy_input_file
   if %LOAD%==y goto copy_input_file
   if %LOAD%==n goto exit_aria2_script
   
 :copy_input_file
 
   copy /Y "%1" "%TORRENT_FILES%"
   xcopy /Y "%1" "%TORRENT_FILES%"
   goto aria2_run
   
 :aria2_run
   cls
   echo.
   echo ** aria2 bittorrent script v.%VERSION% **
   echo - http://aria2.sourceforge.net/
   echo.
   echo - aria2 config:
   echo.
   echo  * Config.file: %CONFIG_FILE%
   echo.
   echo  * Download directory: %TORRENT_FOLDER%
   echo  * Torrent directory: %TORRENT_FILES%\*.torrent (%DISC_FILES%)
   echo  * Download speed: %MAX_SPEED_DOWNLOAD% / Upload speed: %MAX_SPEED_UPLOAD%
   echo  * Encryption: %ENCRYPTION% / RPC: %RPC% (Port: %RPC_PORT%)
   echo  * Max.peers: %BT_MAX_PEERS% / Max.downloads: %MAX_DOWNLOADS%
   echo  * Seeding: %SEEDING% / Seed ratio: %SEED_RATIO%
   echo  * Debugging: %DEBUG% / Debug.level: %DEBUG_LEVEL%
   echo  * CA-Certificate: %CA_CERTIFICATE% (%CA_CERTIFICATE_FILE%)
   echo  * File allocation: %FILE_ALLOCATION%
   echo.
   set /p RUN=- run(r) / list(l) / magnet(m) / urls(u) / quit(q): 
   
   if %RUN%==* goto error_msg
   if %RUN%==r goto aria2_command
   if %RUN%==run goto aria2_command
   if %RUN%==q goto exit_aria2_script
   if %RUN%==quit goto exit_aria2_script
   if %RUN%==l goto list_torrent
   if %RUN%==list goto list_torrent
   if %RUN%==m goto magnet_link
   if %RUN%==magnet goto magnet_link
   if %RUN%==urls goto load_urls
   if %RUN%==u goto load_urls
 
 :aria2_command
   cls
   %DISC_FILES%
   cd %TORRENT_FILES%
   dir /B | find ".torrent" > %TEMP_FILE%
   if %DEBUG%==yes (
   aria2c %OTHER_OPTIONS% -i %TEMP_FILE% %ALL_OPTIONS% -d %TORRENT_FOLDER% --console-log-level=%DEBUG_LEVEL%)
   if %DEBUG%==no (
   aria2c %OTHER_OPTIONS% -i %TEMP_FILE% %ALL_OPTIONS% -d %TORRENT_FOLDER%)   
   
   del %TEMP_FILE%
   goto aria2_run
   
 :list_torrent
   cls
   %DISC_FILES%
   cd %TORRENT_FILES%
   dir /B | find ".torrent" > %TEMP_FILE%
   cls
   echo.
   echo * List of torrents that will be loaded:
   echo.
   type %TEMP_FILE%
   echo.
   echo * List of incomplete downloads:
   echo.
   dir /B %TORRENT_FOLDER% | find ".aria2"
   echo.
   echo Press 'ENTER' to return
   pause > nul
   del %TEMP_FILE%
   goto aria2_run
   
 :magnet_link
   cls
   echo.
   echo * Make torrent file from Magnet-link
   echo.
   set /p MAGNET=- Type the Magnet-link: 
   echo.
   aria2c --bt-metadata-only=true --bt-save-metadata=true "%MAGNET%" -d %TORRENT_FILES%
   echo.
   echo Press 'ENTER' to return
   pause > nul
   goto aria2_run
   
 :load_urls
   set URLS_FILE=%TORRENT_FILES%\urls.txt
   if not exist %URLS_FILE% echo.> %URLS_FILE%
   cls
   echo.
   echo * List URLs (%URLS_FILE%):
   echo.
   type %URLS_FILE%
   echo.
   set /p LOAD_URLS=- Load URLs? (y/n): 
   if %LOAD_URLS%==* goto init_load_urls
   if %LOAD_URLS%==y goto init_load_urls
   if %LOAD_URLS%==n goto aria2_run
  
  :init_load_urls
   cls
   if %DEBUG%==yes (
   aria2c %OTHER_OPTIONS% -i "%URLS_FILE%" %ALL_OPTIONS% -d %TORRENT_FOLDER% --console-log-level=%DEBUG_LEVEL%)
   if %DEBUG%==no (
   aria2c %OTHER_OPTIONS% -i "%URLS_FILE%" %ALL_OPTIONS% -d %TORRENT_FOLDER%)
   goto aria2_run
   
 :error_msg
   cls  
   echo.
   echo Invalid option, please, choose any available option
   echo.
   echo Press 'ENTER' to return
   pause > nul
   goto aria2_run
   
 :exit_aria2_script
   echo Exiting...
