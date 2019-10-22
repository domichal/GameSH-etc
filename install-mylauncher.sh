#!/bin/bash

homedir="/home/cpi"

if [ ! -d $homedir ]; then
  echo "No homedir [$homedir] found, don't know what to do."
  exit 1
elif [ -f $homedir/.startrc ]; then
  echo "It seem that switch launcher script is already installed"
  exit 1
elif [ -d $homedir/mylauncher ]; then
  echo "$homedir/mylauncher folder already exists, rename or remove it first if you want to install fresh copy of mylauncher"
  exit 1
fi

whiptail --title "Confirm" --yesno "This script will install \"mylauncher\" in $homedir folder. Continue?" 12 40
x=$?

if ! [ "$x" -eq 0 ]; then
  echo "Aborted"
  exit
fi

pwd="${PWD}"
cd "$homedir"

wget https://github.com/domichal/mylauncher/archive/master.zip && unzip master.zip && rm master.zip
mv mylauncher-master mylauncher

cat <<EOT>> .startrc
#!/bin/bash

LAUNCHER=mylauncher

if [ -f "$homedir/\$LAUNCHER/.cpirc" ] && [ -z "\$SSH_CLIENT" ] && [ -z "\$SSH_TTY" ]; then
    echo "Starting \$LAUNCHER"
else
    echo "Couldn't load \"\$LAUNCHER\", loading \"launcher\" instead"
    LAUNCHER=launcher
fi
. "$homedir/launcher/.cpirc"

exit
EOT
chmod 644 .startrc

if [ "$(cat .bashrc | grep '\.startrc')" != "" ]; then
  echo "Start entry has already been added to $home/.bashrc"
else
  cp -f .bashrc .bashrc.bak
  sed -i "/^if \[ -f .*\.cpirc/i \if [ -f $homedir/.startrc ]; then\n    . $homedir/.startrc\nfi\n" .bashrc || echo -e "Something went wrong when trying to modify $homedir/.bash\nPlease edit it manually, more info here: https://github.com/domichal/mylauncher/blob/dev/README.md#installation"
fi
echo "Installation finished"

cd $pwd
if [ "$0" != bash ]; then
  rm -- "$0"
fi
exit 0
