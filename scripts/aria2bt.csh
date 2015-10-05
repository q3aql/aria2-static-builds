#!/bin/csh

# aria2 script for bittorrent downloads.
# http://aria2.sourceforge.net/
# Created by clamsawd (clamsawd@openmailbox.org)
# Licensed by GPL v.2
# Last update: 03-10-2015
# --------------------------------------
set VERSION=7.1

  #Check if exist .aria2 folder.
  if ( -d $HOME/.aria2 ) then
     echo "$HOME/.aria2 exists"
  else
     mkdir $HOME/.aria2
  endif

  #Check if exist config file and create it.
  set CONFIG_FILE=$HOME/.aria2/aria2bt.conf

  if ( -f $CONFIG_FILE ) then
     source $CONFIG_FILE
  else
     echo "# DEFAULT ARIA2BT SCRIPT CONFIG." > $CONFIG_FILE
     echo "" >> $CONFIG_FILE
     echo "set TORRENT_FOLDER=/opt/Torrent" >> $CONFIG_FILE
     echo "set TORRENT_FILES=/opt/Torrent/Files" >> $CONFIG_FILE
     echo "set MAX_SPEED_DOWNLOAD=300K" >> $CONFIG_FILE
     echo "set MAX_SPEED_UPLOAD=5K" >> $CONFIG_FILE
     echo "set BT_MAX_PEERS=25" >> $CONFIG_FILE
     echo "set MAX_DOWNLOADS=25" >> $CONFIG_FILE
     echo "set ENCRYPTION=yes" >> $CONFIG_FILE
     echo "set RPC=yes" >> $CONFIG_FILE
     echo "set RPC_PORT=6800" >> $CONFIG_FILE
     echo "set SEEDING=yes" >> $CONFIG_FILE
     echo "set SEED_RATIO=0.0" >> $CONFIG_FILE
     echo "set DEBUG=no" >> $CONFIG_FILE
     echo "set DEBUG_LEVEL=info" >> $CONFIG_FILE
     echo "set FILE_ALLOCATION=none" >> $CONFIG_FILE
     echo "set CA_CERTIFICATE=no" >> $CONFIG_FILE
     echo "set CA_CERTIFICATE_FILE=/etc/ssl/certs/ca-certificates.crt" >> $CONFIG_FILE
     source $CONFIG_FILE
  endif

 # VARIABLES
 set SPEED_OPTIONS="--max-overall-download-limit=$MAX_SPEED_DOWNLOAD --max-overall-upload-limit=$MAX_SPEED_UPLOAD"
 set PEER_OPTIONS="--bt-max-peers=$BT_MAX_PEERS"
 if ( "$CA_CERTIFICATE" == "no" ) then
  set OTHER_OPTIONS="-V -j $MAX_DOWNLOADS --file-allocation=$FILE_ALLOCATION --auto-file-renaming=false --allow-overwrite=false"
 else if ( "$ENCRYPTION" == "yes" ) then
  set OTHER_OPTIONS="-V -j $MAX_DOWNLOADS --file-allocation=$FILE_ALLOCATION --auto-file-renaming=false --allow-overwrite=false --ca-certificate=$CA_CERTIFICATE_FILE"
 endif
 
   #check aria2 on system.
    aria2c -h > /dev/null
    if ( $status == 0 ) then
     echo "Everything OK"
    else
     clear
     echo ""
     echo "Error: 'aria2' is not installed!"
     echo "Help: http://aria2.sourceforge.net/"
     echo ""
     exit
    endif

    #Define command from variables of config file.
      if ( "$ENCRYPTION" == "no" ) then
         set TORRENT_OPTIONS="--bt-require-crypto=false"
      else if ( "$ENCRYPTION" == "yes" ) then
         set TORRENT_OPTIONS="--bt-min-crypto-level=arc4 --bt-require-crypto=true"
      endif

      if ( "$RPC" == "no" ) then
         set RPC_OPTIONS="--rpc-listen-all=false"
      else if ( "$RPC" == "yes" ) then
         set RPC_OPTIONS="--enable-rpc --rpc-listen-all=true --rpc-allow-origin-all --rpc-listen-port=$RPC_PORT"
      endif

      if ( "$SEEDING" == "no" ) then
         set SEED_OPTIONS="--seed-time=0"
      else if ( "$SEEDING" == "yes" ) then
         set SEED_OPTIONS="--seed-ratio=$SEED_RATIO"
      endif

      if ( "$DEBUG" == "no" ) then
         set ALL_OPTIONS="$TORRENT_OPTIONS $SPEED_OPTIONS $PEER_OPTIONS $RPC_OPTIONS $SEED_OPTIONS"
      else if ( "$DEBUG" == "yes" ) then
         set ALL_OPTIONS="$TORRENT_OPTIONS $SPEED_OPTIONS $PEER_OPTIONS $RPC_OPTIONS $SEED_OPTIONS --console-log-level=$DEBUG_LEVEL"
      endif

  #Show help
  if ( "$1" == "--help" ) then
    clear
    echo ""
    echo "** aria2 bittorrent script v.$VERSION **"
    echo ""
    echo "USAGE:"
    echo ""
    echo "$0 [parameter | file.torrent]"
    echo ""
    echo "AVAILABLE PARAMETERS:"
    echo ""
    echo "--help - Show help"
    echo "--now  - Run immediately the script without menu"
    echo ""
    echo "Note: If you run the script without parameters,"
    echo "      this will show a menu with all options."
    echo ""
    exit
  endif

  #Run immediately the script without menu
  if ( "$1" == "--now" ) then
    echo ""
    echo "** aria2 bittorrent script v.$VERSION **"
    echo ""
    aria2c $OTHER_OPTIONS "$TORRENT_FILES"/*.torrent $ALL_OPTIONS -d "$TORRENT_FOLDER"
  endif

  # Check input file.
  if ( -f "$1" ) then

    set CHECK_TORRENT=`echo $1 | grep ".torrent"`
    if ( "$CHECK_TORRENT" == "$1" ) then
      clear
      echo ""
      echo "* Detected torrent file!"
      echo ""
      echo "- Do you want to copy this file in '$TORRENT_FILES' directory"
      echo -n "and run aria2? (y/n); "
      set LOAD="$<"

      if ( "$LOAD" == "y" ) then
          cp "$1" "$TORRENT_FILES"
          cp -rf "$1" "$TORRENT_FILES"
      else if ( "$LOAD" == "n" ) then
          echo "Exiting..."
          exit
      else
          cp "$1" "$TORRENT_FILES"
          cp -rf "$1" "$TORRENT_FILES"
      endif
    else
     clear
     echo ""
     echo "This file is not a torrent!"
     echo ""
     echo -n "Press 'ENTER' to exit "
     set NOOPTION="$<"
     echo "Exiting..."
     exit
    endif

  else
     echo "No input file"
  endif

  set MENU_VARIABLE=1

  while ( $MENU_VARIABLE <= 2 )
   #Show menu
    clear
    echo ""
    echo "** aria2 bittorrent script v.$VERSION **"
    echo "- http://aria2.sourceforge.net/"
    echo ""
    echo "- aria2 config:"
    echo ""
    echo " * Config.file: $CONFIG_FILE"
    echo ""
    echo " * Download directory: $TORRENT_FOLDER"
    echo " * Torrent directory: $TORRENT_FILES/*.torrent"
    echo " * Download speed: $MAX_SPEED_DOWNLOAD | Upload speed: $MAX_SPEED_UPLOAD"
    echo " * Encryption: $ENCRYPTION | RPC: $RPC (Port: $RPC_PORT)"
    echo " * Max.peers: $BT_MAX_PEERS | Max.downloads: $MAX_DOWNLOADS"
    echo " * Seeding: $SEEDING | Seed ratio: $SEED_RATIO"
    echo " * Debugging: $DEBUG | Debug.level: $DEBUG_LEVEL"
    echo " * CA-Certificate: $CA_CERTIFICATE ($CA_CERTIFICATE_FILE)"
    echo " * File allocation: $FILE_ALLOCATION"
    echo ""
    echo -n  "- run(r) | list(l) | magnet(m) | urls(u) | quit(q): "
    set RUN="$<"

    if ( "$RUN" == "r" ) then

      clear
      aria2c $OTHER_OPTIONS "$TORRENT_FILES"/*.torrent $ALL_OPTIONS -d "$TORRENT_FOLDER"

    else if ( "$RUN" == "q" ) then

          set MENU_VARIABLE=3
          echo "Exiting..."

    else if ( "$RUN" == "l" ) then

       clear
       echo ""
       echo "* List of torrents that will be loaded:"
       echo ""
       ls "$TORRENT_FILES" | grep ".torrent"
       echo ""
       echo "* List of incomplete downloads:"
       echo ""
       ls "$TORRENT_FOLDER" | grep ".aria2"
       echo ""
       echo -n "Press 'ENTER' to return "
       set NOOPTION="$<"

    else if ( "$RUN" == "m" ) then

       clear
       echo ""
       echo "* Make torrent file from Magnet-link"
       echo ""
       echo -n "- Type the Magnet-link: "
       set MAGNET="$<"
       echo ""
       aria2c --bt-metadata-only=true --bt-save-metadata=true "$MAGNET" -d "$TORRENT_FILES"
       echo ""
       echo -n "Press 'ENTER' to return "
       set NOOPTION="$<"

    else if ( "$RUN" == "u" ) then
    
       set URLS_FILE="$TORRENT_FILES"/urls.txt
       if ( -f "$URLS_FILE" ) then
           echo "$URLS_FILE" detected
       else
           echo -n > "$URLS_FILE"
       endif
       clear
       echo ""
       echo "* List URLs ($URLS_FILE):"
       echo ""
       cat "$URLS_FILE"
       echo ""
       echo -n "- Load URLS? (y/n): "
       set LOAD_URLS="$<"
        if ( "$LOAD_URLS" == "y" ) then
            clear
            aria2c $OTHER_OPTIONS -i "$URLS_FILE" $ALL_OPTIONS -d "$TORRENT_FOLDER"
            echo "Exiting..."
        else
            echo "Returning..."
        endif

    else
       clear
       echo ""
       echo "Invalid option, please, choose any available option"
       echo ""
       echo -n "Press 'ENTER' to return "
       set NOOPTION="$<"
    endif
  end
