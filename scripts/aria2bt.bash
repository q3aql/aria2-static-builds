#!/bin/bash

# aria2 script for bittorrent downloads.
# http://aria2.sourceforge.net/
# Created by Quique (quuiqueee@gmail.com)
# Licensed by GPL v.2
# Last update: 27-10-2014
# --------------------------------------
VERSION=6.5

  #Check if exist .aria2 folder.
  if [ -d $HOME/.aria2 ] ; then
      echo "$HOME/.aria2 exists"
  else
      mkdir $HOME/.aria2
  fi

  #Check if exist config file and create it.
  CONFIG_FILE=$HOME/.aria2/aria2bt.conf

  if [ -f $CONFIG_FILE ] ; then
     source $CONFIG_FILE
  else
     echo "# DEFAULT ARIA2BT SCRIPT CONFIG." > $CONFIG_FILE
     echo "" >> $CONFIG_FILE
     echo "TORRENT_FOLDER=/opt/Torrent" >> $CONFIG_FILE
     echo "TORRENT_FILES=/opt/Torrent/Files" >> $CONFIG_FILE
     echo "MAX_SPEED_DOWNLOAD=300K" >> $CONFIG_FILE
     echo "MAX_SPEED_UPLOAD=5K" >> $CONFIG_FILE
     echo "BT_MAX_PEERS=25" >> $CONFIG_FILE
     echo "MAX_DOWNLOADS=25" >> $CONFIG_FILE
     echo "ENCRYPTION=yes" >> $CONFIG_FILE
     echo "RPC=yes" >> $CONFIG_FILE
     echo "SEEDING=yes" >> $CONFIG_FILE
     echo "SEED_RATIO=0.0" >> $CONFIG_FILE
     echo "DEBUG=no" >> $CONFIG_FILE
     echo "DEBUG_LEVEL=info" >> $CONFIG_FILE
     echo "FILE_ALLOCATION=none" >> $CONFIG_FILE
     source $CONFIG_FILE
  fi

 # VARIABLES
 SPEED_OPTIONS="--max-overall-download-limit=$MAX_SPEED_DOWNLOAD --max-overall-upload-limit=$MAX_SPEED_UPLOAD"
 PEER_OPTIONS="--bt-max-peers=$BT_MAX_PEERS"
 OTHER_OPTIONS="-V -j $MAX_DOWNLOADS --file-allocation=$FILE_ALLOCATION"

   #check aria2 on system.
    aria2c -h > /dev/null
    if [ "$?" -eq 0 ] ; then
     echo "Everything OK"
    else
     clear
     echo ""
     echo "Error: 'aria2' is not installed!"
     echo "Help: http://aria2.sourceforge.net/"
     echo ""
     exit
    fi

    #Define command from variables of config file.
      if [ "$ENCRYPTION" == "no" ] ; then
         TORRENT_OPTIONS="--bt-require-crypto=false"
      elif [ "$ENCRYPTION" == "yes" ] ; then
         TORRENT_OPTIONS="--bt-min-crypto-level=arc4 --bt-require-crypto=true"
      fi

      if [ "$RPC" == "no" ] ; then
         RPC_OPTIONS="--rpc-listen-all=false"
      elif [ "$RPC" == "yes" ] ; then
         RPC_OPTIONS="--enable-rpc --rpc-listen-all=true --rpc-allow-origin-all"
      fi

      if [ "$SEEDING" == "no" ] ; then
         SEED_OPTIONS="--seed-time=0"
      elif [ "$SEEDING" == "yes" ] ; then
         SEED_OPTIONS="--seed-ratio=$SEED_RATIO"
      fi

      if [ "$DEBUG" == "no" ] ; then
         ALL_OPTIONS="$TORRENT_OPTIONS $SPEED_OPTIONS $PEER_OPTIONS $RPC_OPTIONS $SEED_OPTIONS"
      elif [ "$DEBUG" == "yes" ] ; then
         ALL_OPTIONS="$TORRENT_OPTIONS $SPEED_OPTIONS $PEER_OPTIONS $RPC_OPTIONS $SEED_OPTIONS --console-log-level=$DEBUG_LEVEL"
      fi

  # Check input file.
  if [ -f "$1" ] ; then

    CHECK_TORRENT=`echo $1 | grep ".torrent"`
    if [ "$CHECK_TORRENT" == "$1" ] ; then
      clear
      echo ""
      echo "Detected torrent file!"
      echo ""
      echo "Can you copy this file to '$TORRENT_FILES' directory and"
      echo -n "run aria2? (y/n); " ; read LOAD

      if [ "$LOAD" == "y" ] ; then
          cp "$1" $TORRENT_FILES
          cp -rf "$1" $TORRENT_FILES
      elif [ "$LOAD" == "n" ] ; then
          echo "Exiting..."
          exit
      else
          cp "$1" $TORRENT_FILES
          cp -rf "$1" $TORRENT_FILES
      fi
    else
      clear
      echo ""
      echo "This file is not a torrent!"
      echo ""
      echo -n "Press 'ENTER' to exit "
      read notoption
      echo "Exiting..."
      exit
    fi

  else
     echo "No input file"
  fi

  MENU_VARIABLE=1
  while [ $MENU_VARIABLE -le 2 ] ; do
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
    echo " * Encryption: $ENCRYPTION | RPC: $RPC"
    echo " * Max.peers: $BT_MAX_PEERS | Max.downloads: $MAX_DOWNLOADS"
    echo " * Seeding: $SEEDING | Seed ratio: $SEED_RATIO"
    echo " * Debugging: $DEBUG | Debug.level: $DEBUG_LEVEL"
    echo " * File allocation: $FILE_ALLOCATION"
    echo ""
    echo -n "- run(r) | list(l) | magnet(m) | file(f) | quit(q): " ; read RUN

    if [ "$RUN" == "r" ] ; then

      clear
      aria2c $OTHER_OPTIONS $TORRENT_FILES/*.torrent $ALL_OPTIONS -d $TORRENT_FOLDER
      echo "Exiting..."

    elif [ "$RUN" == "q" ] ; then

      echo "Exiting..."
      MENU_VARIABLE=3

    elif [ "$RUN" == "l" ] ; then

       clear
       echo ""
       echo "* List of torrents that will be loaded:"
       echo ""
       ls $TORRENT_FILES | grep ".torrent"
       echo ""
       echo "* List of incomplete downloads:"
       echo ""
       ls $TORRENT_FOLDER | grep ".aria2"
       echo ""
       echo -n "Press 'ENTER' to return "
       read notoption

    elif [ "$RUN" == "m" ] ; then

       clear
       echo ""
       echo "* Make torrent file from Magnet-link"
       echo ""
       echo -n "- Type the Magnet-link: " ; read MAGNET
       echo ""
       aria2c --bt-metadata-only=true --bt-save-metadata=true "$MAGNET" -d $TORRENT_FILES
       echo ""
       echo -n "Press 'ENTER' to return "
       read notoption

    elif [ "$RUN" == "f" ] ; then

       clear
       echo ""
       echo "* Load links from a file/metalink"
       echo ""
       echo -n "- Type the path of the file: " ; read FILE
       echo ""
        if [ "${FILE:-NO_VALUE}" != "NO_VALUE" ] ; then
          if [ -f $FILE ] ; then
            clear
            echo ""
            echo "* File: $FILE"
            echo ""
            echo -n "Press 'ENTER' to load file "
            read notoption
            clear
            aria2c $OTHER_OPTIONS -i "$FILE" $ALL_OPTIONS -d $TORRENT_FOLDER
            echo "Exiting..."
          else
            clear
            echo ""
            echo "* '$FILE' not exist!"
            echo ""
            echo -n "Press 'ENTER' to return "
            read notoption
          fi
        else
          clear
          echo ""
          echo "Invalid path (empty)"
          echo ""
          echo -n "Press 'ENTER' to return "
          read notoption
        fi

    else
       clear
       echo ""
       echo "Invalid option, please, choose any available version"
       echo ""
       echo -n "Press 'ENTER' to return "
       read notoption
    fi
  done
