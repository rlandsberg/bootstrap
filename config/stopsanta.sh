#!/bin/zsh

#sudo up front
sudo -v

# Unload santad and scheduled sync job.
/bin/launchctl remove com.google.santad >/dev/null 2>&1

sleep 1

# Unload kext.
/sbin/kextunload -b com.google.santa-driver >/dev/null 2>&1

sleep 1

# Back to monitor mode
sudo defaults write /var/db/santa/config.plist ClientMode -int 1

santactl status