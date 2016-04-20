#!/bin/zsh

#sudo up front
sudo -v

#back to lockdown!
defaults write /var/db/santa/config.plist ClientMode -int 2

sleep 1

# Load kext.
/sbin/kextload /Library/Extensions/santa-driver.kext

sleep 1

# Load santad and scheduled sync jobs.
/bin/launchctl load /Library/LaunchDaemons/com.google.santad.plist

santactl status