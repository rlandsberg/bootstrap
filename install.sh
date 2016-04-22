#!/bin/bash

#Start of our install

#First we need our command line tools


touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
PROD=$(softwareupdate -l |
  grep "\*.*Command Line" |
  head -n 1 | awk -F"*" '{print $2}' |
  sed -e 's/^ *//' |
  tr -d '\n')
softwareupdate -i "$PROD" -v;

#Set up a standard user account
echo "Set up your standard user account"

echo "Enter your desired user name: "
read -r USERNAME

echo "Enter a full name for this user: "
read -r FULLNAME

echo "Enter a password for this user: "
read -r -s PASSWORD

# ====

#  Setting up our Homebrew group

echo "Creating a brew group to use Homebrew as a non-admin account"
dseditgroup -o create -r "Group to use Brew as non-admin" brew

# ====


# Create a UID that is not currently in use
echo "Creating an unused UID for new user..."

if  $UID -ne 0 ; then echo "Please run $0 as root." && exit 1; fi

# Find out the next available user ID
MAXID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1)
USERID=$((MAXID+1))


# Create the user account by running dscl (normally you would have to do each of these commands one
# by one in an obnoxious and time consuming way.
echo "Creating necessary files..."

dscl . -create /Users/"$USERNAME"
dscl . -create /Users/"$USERNAME" UserShell /bin/bash
dscl . -create /Users/"$USERNAME" RealName "$FULLNAME"
dscl . -create /Users/"$USERNAME" UniqueID "$USERID"
dscl . -create /Users/"$USERNAME" PrimaryGroupID 20
dscl . -create /Users/"$USERNAME" NFSHomeDirectory /Users/"$USERNAME"
dscl . -passwd /Users/"$USERNAME" "$PASSWORD"


# Add user to any specified groups
echo "Adding user to specified groups..."
dseditgroup -o edit -t user -a "$USERNAME" staff
dseditgroup -o edit -t user -a "$USERNAME" brew

#Add our admin account to the group too
dseditgroup -o edit -t user -a "$(whoami)" brew



# Create the home directory
echo "Creating home directory..."
createhomedir -c 2>&1 | grep -v "shell-init"

echo "Created user #$USERID: $USERNAME ($FULLNAME)"

#Let's add our user to sudoers Yolo style
echo "$USERNAME     ALL=(ALL) ALL" >> /etc/sudoers
echo "Added $USERNAME to sudoers"


#Next we need to set up our directories
dir=" /Users/$USERNAME/Workspace"
mkdir -p "$dir"
chown "$USERNAME" "$dir"



#Install Homebrew as our admin account
sudo -u "$SUDO_USER" ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Now let change our permissions so that our non-admin user can use Homebrew

sudo chgrp -R brew /usr/local
sudo chgrp -R brew /Library/Caches/Homebrew
sudo chmod -R g+w /usr/local
sudo chmod -R g+w /Library/Caches/Homebrew

# and if you plan to use caskroom too:
sudo mkdir -p /opt/homebrew-cask/Caskroom
sudo chgrp -R brew /opt/homebrew-cask
sudo chmod -R g+w /opt/homebrew-cask

# let's pull down our dotfiles and scripts

cd "$dir" || exit
sudo -u "$USERNAME" git clone --recursive https://github.com/rlandsberg/bootstrap.git

sudo -u "$USERNAME" brew doctor

sudo -u $USERNAME bash bootstrap.sh


#cd bootstrap
#bash bootstrap.sh

