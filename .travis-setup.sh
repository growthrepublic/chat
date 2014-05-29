#!/bin/bash

set -x
set -e

# Make sure /dev/shm has correct permissions.
ls -l /dev/shm
sudo chmod 1777 /dev/shm
ls -l /dev/shm

uname -a
cat /etc/lsb-release

sudo apt-get update --fix-missing

export BROWSER="Chrome"
export VERSION="stable"

sudo ln -sf $(which true) $(which xdg-desktop-menu)

echo "Getting $VERSION of $BROWSER"
export CHROME=google-chrome-${VERSION}_current_amd64.deb
wget https://dl.google.com/linux/direct/$CHROME
sudo dpkg --install $CHROME || sudo apt-get -f install
which google-chrome
ls -l `which google-chrome`

if [ -f /opt/google/chrome/chrome-sandbox ]; then
  export CHROME_SANDBOX=/opt/google/chrome/chrome-sandbox
else
  export CHROME_SANDBOX=$(ls /opt/google/chrome*/chrome-sandbox)
fi

# Download a custom chrome-sandbox which works inside OpenVC containers (used on travis).
sudo rm -f $CHROME_SANDBOX
sudo wget https://googledrive.com/host/0B5VlNZ_Rvdw6NTJoZDBSVy1ZdkE -O $CHROME_SANDBOX
sudo chown root:root $CHROME_SANDBOX; sudo chmod 4755 $CHROME_SANDBOX
sudo md5sum $CHROME_SANDBOX

google-chrome --version

$CHROME_DRIVER_ZIP=/tmp/chromedriver.zip

sudo apt-get install unzip
sudo wget http://chromedriver.storage.googleapis.com/2.10/chromedriver_linux64.zip -O $CHROME_DRIVER_ZIP
sudo unzip $CHROME_DRIVER_ZIP -d /bin # should be in $PATH already