#!/bin/bash

homedir="/home/cpi"

if [ ! -d $homedir ]; then
  echo "No homedir [$homedir] found, don't know what to do."
  exit 1
elif ! [ -d $homedir/skins ]; then
  echo "It seem that switch launcher script is already installed"
  exit 1
fi

whiptail --title "Confirm" --yesno "This script will install \"Greey\" skin for GameShell. Continue?" 12 40
x=$?

if ! [ "$x" -eq 0 ]; then
  echo "Aborted"
  exit
fi

pwd="${PWD}"
cd "$homedir/skins"

wget https://github.com/domichal/GameSH-Theme-Greey/archive/master.zip && unzip master.zip && rm master.zip
mv "GameSH-Theme-Greey-master" Greey

cd $pwd
echo "Installation finished"

if [ "$0" != bash ]; then
  rm -- "$0"
fi
exit 0
