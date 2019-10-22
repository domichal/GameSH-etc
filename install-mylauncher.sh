#!/bin/bash

homedir="/home/cpi"

if [ ! -d $homedir ]; then
  echo "No homedir [$homedir] found, don't know what to do."
  return
elif [ -f $homedir/.start ]; then
  echo "It seem that switch launcher script is already installed"
  return
elif [ -d $homedir/mylauncher ]; then
  echo "$homedir/mylauncher folder already exists, rename or remove it first if you want to install fresh copy of mylauncher"
  return
fi

whiptail --title "Confirm" --yesno "This script will install \"mylauncher\" in $homedir folder. Continue?" $ALERT_HEIGHT $WIDTH
x=$?

if ! [ $x -eq 0 ]; then
  echo "Aborted"
  return
fi

pwd="${PWD}"
cd "$homedir"

wget https://github.com/domichal/mylauncher/archive/master.zip && unzip master.zip && rm master.zip
mv mylauncher-master mylauncher

cat <<EOT>> .start
#!/bin/bash

LAUNCHER=mylauncher

if [ -f "$homedir/\$LAUNCHER/.cpirc" ] && [ -z "\$SSH_CLIENT" ] && [ -z "\$SSH_TTY" ]; then
    echo "Starting \$LAUNCHER"
    . "$homedir/\$LAUNCHER/.cpirc"
fi
EOT
chmod 644 .start

if [ "$(cat .bashrc | grep '\.start')" != "" ]; then
    echo "Start entry has already been added to $home/.bashrc"
else
    cp -f .bashrc .bashrc.bak
    sed -i '/^if \[ -f .*\.cpirc/i \if [ -f ~/.start ]; then\n    . ~/.start\nfi\n' .bashrc || echo -e "Something went wrong when trying to modify $homedir/.bash\nPlease edit it manually, more info here: https://github.com/domichal/mylauncher/blob/dev/README.md#installation"
fi
echo "Installation finished"

cd $pwd
rm -- "$0"
exit 0
