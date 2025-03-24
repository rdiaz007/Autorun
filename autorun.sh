# This script configures the system (executed from preseed late_command)
# 01/22/2025 / Corporate IT / corpitsystem@hotelbeds.com

set -x

# Ensure proper logging
#if [ "$1" != "stage2" ]; then
#  sudo mkdir /root/log
#  /bin/bash /root/desktop-bootstrap.sh 'stage2' &> /root/log/desktop-bootstrap.log
#  exit
#fi

###### PACKAGE MANAGEMENT & ADDITIONAL PACKAGES ######
######################################################

#Create folder for download
sudo mkdir /root/software

# Install Edge: Install Essential Packages: Install necessary packages for Microsoft Edge setup:
#apt install curl gpg
sudo wget -O /root/software/microsoft-edge-stable_123.0.2420.81-1_amd64.deb "https://sharesfiles.blob.core.windows.net/sharefiles/microsoft-edge-stable_123.0.2420.81-1_amd64.deb?sp=r&st=2024-04-10T20:36:50Z&se=2025-05-15T04:36:50Z&spr=https&sv=2022-11-02&sr=b&sig=3pYQK3qlBrJSlibq5UZnpe16IWgCWd0vCWN%2F0F7cjzY%3D"
sudo dpkg -i /root/software/microsoft-edge-stable_123.0.2420.81-1_amd64.deb
sudo apt-get update
sudo apt install microsoft-edge-stable

# Install Chrome:
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt --fix-broken install

#Install the TeamViewer App
sudo wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo apt update
sudo apt -y install ./teamviewer_amd64.deb

#Install the PowerShell 7.5
sudo wget https://github.com/PowerShell/PowerShell/releases/download/v7.5.0/powershell_7.5.0-1.deb_amd64.deb
sudo apt update
sudo apt -y install ./powershell_7.5.0-1.deb_amd64.deb
sudo snap install powershell --classic
# Install Company Portal
sudo wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/24.04/prod noble main" > /etc/apt/sources.list.d/microsoft-ubuntu-noble-prod.list'
sudo rm microsoft.gpg

# Install the Microsoft Intune app
sudo apt-get update
sudo apt-get -fy install intune-portal
sudo update-grub

# Install Crowdstrike
# Download the CrowdStrike Falcon Sensor package
sudo wget -O /root/software/falcon-sensor_7.19.0-17219_amd64.deb "https://sharesfiles.blob.core.windows.net/sharefiles/falcon-sensor_7.19.0-17219_amd64.deb?sp=r&st=2025-01-22T17:43:08Z&se=2026-02-01T01:43:08Z&spr=https&sv=2022-11-02&sr=b&sig=JhxXi3TInzspgF4UgP1DHAX12sGhUTAbAlx0OMG%2F%2FKI%3D"
# Install the package
sudo dpkg -i /root/software/falcon-sensor_7.19.0-17219_amd64.deb
# After installing, run this falconctl command to remove the host's agent ID:
sudo /opt/CrowdStrike/falconctl -d -f --aid
# Set your CID on the sensor and assing Tags
sudo /opt/CrowdStrike/falconctl -s --cid=9698B431537C41C790312F0739D4A257-19 --tags="EndpointHB"
sudo update-grub
# Install Forticlient
#Prerequisites
# Downloading packages
wget http://ftp.it.debian.org/debian/pool/main/g/gconf/gconf2_3.2.6-8_amd64.deb
wget http://ftp.it.debian.org/debian/pool/main/g/gconf/libgconf-2-4_3.2.6-8_amd64.deb
wget http://ftp.it.debian.org/debian/pool/main/g/gconf/gconf2-common_3.2.6-8_all.deb
wget http://ftp.it.debian.org/debian/pool/main/g/gconf/gconf-service_3.2.6-8_amd64.deb
wget http://ftp.it.debian.org/debian/pool/main/o/openldap/libldap-2.5-0_2.5.13%2bdfsg-5_amd64.deb
wget https://security.ubuntu.com/ubuntu/pool/universe/liba/libappindicator/libappindicator1_12.10.1+20.10.20200706.1-0ubuntu1_amd64.deb
wget http://mirrors.kernel.org/ubuntu/pool/universe/libd/libdbusmenu/libdbusmenu-gtk4_16.04.1+18.10.20180917-0ubuntu8_amd64.deb

# Configuring the libgconf-2-4 package
sudo dpkg --configure -a

# Installing the libldap-2.5-0 package
sudo apt install libldap-2.5-0

# missing libnss3-tools
sudo apt install libnss3-tools

# Installing the gconf packages
sudo dpkg -i libldap-2.5-0_2.5.13+dfsg-5_amd64.deb
sudo dpkg -i libdbusmenu-gtk4_16.04.1+18.10.20180917-0ubuntu8_amd64.deb
sudo dpkg -i libgconf-2-4_3.2.6-8_amd64.deb
sudo dpkg -i gconf2-common_3.2.6-8_all.deb
sudo dpkg -i gconf-service_3.2.6-8_amd64.deb
sudo dpkg -i gconf2_3.2.6-8_amd64.deb
sudo dpkg -i libappindicator1_12.10.1+20.10.20200706.1-0ubuntu1_amd64.deb

# Resolving any potential dependency issues
sudo apt -f install
#sudo apt-get -fy install libappindicator1 libgconf-2-4 libnss3-tools
# Download the Forticlient package
sudo wget -O /root/software/forticlient_vpn_7.2.4.0809_amd64.deb "https://sharesfiles.blob.core.windows.net/sharefiles/forticlient_vpn_7.2.4.0809_amd64.deb?sp=r&st=2024-04-09T08:58:34Z&se=2025-04-10T16:58:34Z&spr=https&sv=2022-11-02&sr=b&sig=8Jamcr1tez6U%2FFL8N4fTo1YgYXCz0QR%2B7I1U8F8dkDw%3D"
# Install the package
sudo dpkg -i /root/software/forticlient_vpn_7.2.4.0809_amd64.deb
sudo apt -fy install
#apt update
#apt -fy upgrade

# Install appropriate graphics and wlan drivers
#apt purge ~nvidia
#apt autoremove
#apt clean
#add-apt-repository ppa:graphics-drivers/ppa
#ubuntu-drivers autoinstall
#apt-get install -y ubuntu-drivers-common
sudo lspci | grep VGA | grep -iq nvidia && apt-get install -y  nvidia-current-updates
#apt-get install -y $(nvidia-detector)
sudo lspci | grep VGA | grep -q ATI && apt-get install -y fglrx-updates

#### ONLY FOR DELL 5550 ####
# Backup the original grub file
#cp /etc/default/grub /etc/default/grub.bak
# Use sed to replace the line in the grub file
#sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="nomodeset"/g' /etc/default/grub
# Update grub to apply the changes
#sudo update-grub
#echo "GRUB configuration updated. The system will now use 'nomodeset' at boot."

#### FIX THE RESOLV.CONF FILE SO IT CAN SAVE CHANGES ####
sudo cp /etc/resolv.conf /etc/resolv.conf.bak
sudo chattr +i /etc/resolv.conf.bak
sudo rm /etc/resolv.conf
sudo cp /etc/resolv.conf.bak /etc/resolv.conf
#sudo echo -e "nameserver 10.255.0.102 \nnameserver 8.8.8.8 \nnameserver 127.0.0.53 \noptions edns0 trust-ad \noptions wlp0s20f3 trust-ad \nsearch ." > /etc/resolv.conf
sudo echo -e "nameserver 10.255.0.102 \nnameserver 8.8.8.8 \noptions edns0 trust-ad \noptions wlp0s20f3 trust-ad \nsearch ." > /etc/resolv.conf

 ### Prevent message error Sudo: Unable to resolve host
sudo sed -i "s/LNX-L-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]/$HOSTNAME/" /etc/hosts

# Download Wallpaper
sudo wget -O /usr/share/backgrounds/HBX-WALLPAPER.jpg "https://sharesfiles.blob.core.windows.net/sharefiles/HBX-WALLPAPER.jpg?sp=r&st=2024-01-18T17:55:34Z&se=2025-01-20T01:55:34Z&spr=https&sv=2022-11-02&sr=b&sig=L%2F838S0xTliV4bW6HvFM1a5wKJQEiBb36cfnj3poXys%3D"

# Download Change-hostname
sudo wget -O /root/change-hostname.sh "https://sharesfiles.blob.core.windows.net/sharefiles/change-hostname.sh?sp=r&st=2024-05-17T11:36:45Z&se=2025-05-22T19:36:45Z&spr=https&sv=2022-11-02&sr=b&sig=2h1JXuoWE1gxhwH4Nue6ffnWDTjBgVwSxbzuCauO8Kk%3D"
sudo chmod +x /root/change-hostname.sh

##### SUDOERS ####
sudo cat << EOF > /etc/sudoers
Defaults	env_reset
Defaults	mail_badpass
Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
Defaults	use_pty
# Cmnd alias specification
Cmnd_Alias NOALLOWED = !/usr/bin/systemctl * falcon-sensor*
# User privilege specification
root	ALL=(ALL:ALL) ALL

# Members of the admin group may gain root privileges
%admin ALL=(ALL) ALL

# Allow members of group sudo to execute any command
%sudo	ALL=(ALL:ALL) ALL, NOALLOWED
%HOTELBEDS\\\\domain^users ALL=(ALL:ALL) ALL

# See sudoers(5) for more information on "@include" directives:

@includedir /etc/sudoers.d
hbxadmin ALL=(ALL:ALL) NOPASSWD: /root/change-hostname.sh
hbxuser ALL=(ALL:ALL) NOPASSWD: /root/change-hostname.sh

EOF

###Modify Slash by double###
sudo sed -i 's\%HOTELBEDS\\domain^users ALL=(ALL:ALL) ALL\%HOTELBEDS\\\\domain^users ALL=(ALL:ALL) ALL\g' /etc/sudoers


###Disable Updates###
#systemctl status unattended-upgrades.service
sudo apt remove unattended-upgrades -y
sudo cp /etc/apt/apt.conf.d/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades.bak
sudo sed -i 's\APT::Periodic::Update-Package-Lists "1";\APT::Periodic::Update-Package-Lists "0";\g' /etc/apt/apt.conf.d/20auto-upgrades
sudo sed -i 's\APT::Periodic::Unattended-Upgrade "1";\APT::Periodic::Unattended-Upgrade "0";\g' /etc/apt/apt.conf.d/20auto-upgrades
sudo apt-config dump APT::Periodic::Update-Package-List
sudo apt-config dump APT::Periodic::Unattended-Upgrade
sudo systemctl disable --now unattended-upgrades

#### Modify BASH ####
sudo echo "sudo /root/change-hostname.sh" | sudo tee -a /etc/bash.bashrc

#### CREATE USER GENERIC ####

sudo useradd -p $(openssl passwd -1 91ea.Wmf,rkL.381) -m -d /home/hbxuser -G sudo hbxuser
sudo passwd --expire hbxuser

### Join HBX Domain ###
### It Suggest to Create and Admin User just for this Purpose ###
### Install PBIS Package to join HBX Domain ###
sudo wget download package  https://github.com/BeyondTrust/pbis-open/releases/download/9.1.0/pbis-open-9.1.0.551.linux.x86_64.deb.sh
sudo chmod +x pbis-open-9.1.0.551.linux.x86_64.deb.sh
sudo ./pbis-open-9.1.0.551.linux.x86_64.deb.sh
#/opt/pbis/bin/domainjoin-cli join --disable ssh hotelbeds.local ADM_XXXXXX XXXXXX
#/opt/pbis/bin/config LoginShellTemplate "/bin/bash"

### Permit All Users Domain to open Firefox, SnapStore Apps ###
sudo sed -i 's\#@{HOMEDIRS}+=\@{HOMEDIRS}+="/home/local/HOTELBEDS"\g' /etc/apparmor.d/tunables/home.d/ubuntu 

### Permit All Users Domain to introduce Admin Password in GUI Mode ###
sudo sed -i 's/AdminIdentities=unix-group:sudo;unix-group:admin/AdminIdentities=unix-group:sudo;unix-group:admin;unix-group:HOTELBEDS\\\\domain^users/g' /etc/polkit-1/localauthority.conf.d/51-ubuntu-admin.conf

###### GENERAL SYSTEM SETTINGS ######
#####################################

# Set locale
sudo cat > /etc/default/locale <<EOF
LANG=en_US.UTF-8
LC_NUMERIC=en_US.UTF-8
LC_TIME=en_US.UTF-8
LC_MONETARY=en_US.UTF-8
LC_MEASUREMENT=en_US.UTF-8
EOF

# regenerate locales
sudo locale-gen

###### Prepare End User Configuration #####
###########################################
# Save installation date
sudo date +%c > /root/install-date
# Installing Ubuntu Kernel Version 6.5.0-45
#apt -y install linux-image-6.5.0-45-generic
#apt -y install linux-headers-6.5.0-45-generic
#apt-get -y install dkms
#apt -y install linux-modules-extra-6.5.0-45-generic
#apt -y purge linux-headers-6.2.0-39-generic
#apt -y purge linux-image-6.2.0-39-generic
#reboot
#apt -y purge linux-headers-6.2.0-39-generic

# Installing Security tools
sudo apt-get -y install apt-listbugs apt-listchanges
sudo apt-get -y install needrestart

# Generate GRUB Password

#cp /etc/grub.d/40_custom /etc/grub.d/40_custom.bak
#touch grub.sh
#chmod +x grub.sh
#echo "CADENA=$(echo -e 'Password*\nPassword*' | grub-mkpasswd-pbkdf2 | awk '/grub.pbkdf/{print$NF}') | sudo tee -a /etc/grub.d/40_custom" | sudo tee -a grub.sh
#CADENA=$(echo -e 'Password*\nPassword*' | grub-mkpasswd-pbkdf2 | awk '/grub.pbkdf/{print$NF}')
#echo 'set superusers="User"' >> /home/hbxadmin/Documents/Data.txt
#echo "password_pbkdf2 User $CADENA" >> /home/hbxadmin/Documents/Data.txt
#sudo cat /home/hbxadmin/Documents/Data.txt | sudo tee -a /etc/grub.d/40_custom
#echo "echo 'set superusers="User"' | sudo tee -a /etc/grub.d/40_custom" |sudo tee -a grub.sh
#echo "echo "password_pbkdf2 User $CADENA" | sudo tee -a /etc/grub.d/40_custom" |sudo tee -a grub.sh
#sudo cat /home/hbxadmin/Documents/Data.txt | sudo tee -a /etc/grub.d/40_custom
#./grub.sh
sudo update-grub

sudo update-initramfs -u
sudo apt-get update
sudo apt-get -y upgrade


#apt -y install linux-hwe-6.5-tools
#apt -y install linux-hwe-6.5-source-6.5.0
####apt-get upgrade linux-generic-hwe-20.04
#update-grub
