#!/bin/bash


#Start of our install

#Setup computer name
echo "Enter new hostname of the machine: "
read -r HOSTNAME
echo "Setting new hostname to $HOSTNAME..."
scutil --set HostName "$HOSTNAME"
COMPNAME=$(sudo scutil --get HostName | tr '-' '.')
echo "Setting computer name to $COMPNAME"
scutil --set ComputerName "$COMPNAME"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPNAME"



echo "Set up your standard user account"
echo "Enter your desired user name: "
read -r USERNAME
echo "Enter a full name for this user: "
read -r FULLNAME
echo "Enter a password for this user: "
read -r -s PASSWORD

# ====

#  Setting up our Homebrew group so that we can add our new user to it

echo "Creating a brew group to use Homebrew as a non-admin account"
dseditgroup -o create -r "Group to use Brew as non-admin" brew

# ====


# Create a UID that is not currently in use
echo "Creating an unused UID for new user..."

#Not an issue for us
#if  $UID -ne 0 ; then echo "Please run $0 as root." && exit 1; fi

# Find out the next available user ID
MAXID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1)
USERID=$((MAXID+1))


# Create the user account by running dscl (normally you would have to do each of these commands one
# by one in an obnoxious and time consuming way.
echo "Creating a user in the new 10.10+ way"

sudo sysadminctl -addUser $USERNAME -fullName $FULLNAME -UID $UID -password $PASSWORD -home /Users/$USERNAME

# Add user to any specified groups
echo "Adding user to specified groups..."
dseditgroup -o edit -t user -a "$USERNAME" staff
dseditgroup -o edit -t user -a "$USERNAME" brew

#Add our admin account to the group too
dseditgroup -o edit -t user -a "$(whoami)" brew

# Create the home directory
echo "Creating home directory"
createhomedir -c 2>&1 | grep -v "shell-init"

echo "Created user #$USERID: $USERNAME ($FULLNAME)"

#Let's add our user to sudoers Yolo style
echo "$USERNAME     ALL=(ALL) ALL" >> /etc/sudoers
echo "Added $USERNAME to sudoers"

echo "Creating our directories"
#Next we need to set up our directories
sudo -u "$USERNAME" mkdir -p "/Users/$USERNAME/Workspace"
sudo -u chown "$USERNAME" "/Users/$USERNAME/Workspace"
echo "/Users/$USERNAME/Workspace"

sudo -u "$USERNAME" mkdir -p "/Users/$USERNAME/Workspace/config"
sudo -u chown "$USERNAME" "/Users/$USERNAME/Workspace/config"
echo "/Users/$USERNAME/Workspace/config"


# Let's install command line tools

echo "Installing command line tools"
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
PROD=$(softwareupdate -l |
  grep "\*.*Command Line" |
  head -n 1 | awk -F"*" '{print $2}' |
  sed -e 's/^ *//' |
  tr -d '\n')
softwareupdate -i "$PROD" -v;

# Install Homebrew as our admin account

echo "Installing Homebrew"
sudo -u "$SUDO_USER" ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"   </dev/null

# Now let change our permissions so that our non-admin user can use Homebrew

echo "Setting up Homebrew for our non-admin user"
sudo chgrp -R brew /usr/local
sudo chgrp -R brew /Library/Caches/Homebrew
sudo chmod -R g+w /usr/local
sudo chmod -R g+w /Library/Caches/Homebrew

# and if you plan to use caskroom too:
sudo mkdir -p /opt/homebrew-cask/Caskroom
sudo chgrp -R brew /opt/homebrew-cask
sudo chmod -R g+w /opt/homebrew-cask

# let's pull down our dotfiles and scripts

echo "Syncing our dotfiles repo"
cd "/Users/$USERNAME/Workspace" || exit
sudo -u "$USERNAME" git clone --recursive https://github.com/rlandsberg/bootstrap.git

# Moving our dotfiles and config up to our working directory.  Any changes can be copied back and synced to the repo
 
echo "Copying our dotfiles to our working directories"
cp -r "/Users/$USERNAME/Workspace/bootstrap/dotfiles" /Users/$USERNAME/dotfiles
cp -r "/Users/$USERNAME/Workspace/bootstrap/config" /Users/$USERNAME/config

sudo -u "$USERNAME" brew doctor

#sudo -u $USERNAME bash bootstrap.sh



