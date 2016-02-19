#!/bin/bash
#About:
#   This scrpit will install Virtualbox and phpVirtualbox.
#   And create a user add to vboxusers group.

vboxusersGoup="vboxusers"

if [ $(id -u) -eq 0 ]; then
    echo -e "\e[1;32mNote: This scrpit will add a user allow Virtual box remote access.\e[0m"
    read -p "Enter new username: " username

    id $username > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        echo -e "\e[1;31mWaring: user exist.\e[0"
        exit 1
    fi
    
    read -s -p "Enter password for new user: " password
    pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
    sudo useradd -m -p $pass $username
    [ $? -eq 0 ] && echo "\e[1;32mUser has been added to system!\e[0m" || echo "\e[1;31mFailed to add a user!\e[0m"
else
    echo -e "\e[31mWaring: Only root can run this script.\e[0m"
    exit 1
fi

echo "#######################################################################"
echo "#                           Add repository                            #"
echo "#######################################################################"
echo

sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian vivid contrib"
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add - -y

echo
echo "#######################################################################"
echo "#                         Install Virtualbox                          #"
echo "#######################################################################"
echo

sudo apt-get update -y
sudo apt-get install virtualbox-5.0 zip -y

echo
echo "#######################################################################"
echo "#                    Install Virtualbox Extension                     #"
echo "#######################################################################"
echo

wget http://download.virtualbox.org/virtualbox/5.0.14/Oracle_VM_VirtualBox_Extension_Pack-5.0.14-105127.vbox-extpack
if [ $? -ne 0 ]; then
    echo -e "\e[1;31mError: Download Virtualbox Extension fail.\e[0m"
    exit 1
fi

sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-5.0.14-105127.vbox-extpack
if [ $? -ne 0 ]; then
    echo -e "\e[1;31mError: Install Virtaubox Extension fail.\e[0m"
    exit 1
fi

rm -f Oracle_VM_VirtualBox_Extension_Pack-5.0.14-105127.vbox-extpack

echo
echo "#######################################################################"
echo "#                        Install PHPVirutalbox                        #"
echo "#######################################################################"
echo

sudo apt-get install apache2 php5 php-soap zip -y

wget http://sourceforge.net/projects/phpvirtualbox/files/phpvirtualbox-5.0-5.zip
if [ $? -ne 0 ]; then
    echo -e "\e[1;31mError: Download phpVirtualbox fail.\e[0m"
    exit 1
fi

unzip phpvirtualbox-5.0-5.zip
sudo mv phpvirtualbox-5.0-5 /var/www/html/virtualbox
rf -f phpvirtualbox-5.0-5.zip
