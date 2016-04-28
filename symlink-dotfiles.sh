#!/bin/bash
# Most of this is from https://github.com/paulmillr/dotfiles/blob/master/symlink-dotfiles.sh

<<<<<<< HEAD
dev="$HOME/Workspace"
dotfiles="$dev/dotfiles"
=======
dotfiles="$HOME/dotfiles"
>>>>>>> odd

if [[ -d "$dotfiles" ]]; then
  echo "Symlinking dotfiles from $dotfiles"
else
  echo "$dotfiles does not exist"
  exit 1
fi

link() {
  from="$1"
  to="$2"
  echo "Linking '$from' to '$to'"
  rm -f "$to"
  ln -s "$from" "$to"
}

for location in $dotfiles/.{zshrc,tmux.conf,gitignore,gitconfig,zprofile} ; do
  file="${location##*/}"
  file="${file%.sh}"
  link "$location" "$HOME/$file"
done

# Setting up Sublime 3 Packages and settings

rm -rf "$HOME/Library/Application\ Support/Sublime\ Text\ 3/User"
ln -s "$HOME/Workspace/bootstrap/Sublime/User/ User"

echo "Remember to install Package Manager from https://packagecontrol.io/installation#st3"

# Setting up our iTerm2 preferences

defaults write com.googlecode.iterm2 PrefsCustomFolder "$HOME/bootstrap/dotfiles"

# Add our applications to the Dock.

# Chrome 
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/opt/homebrew-cask/Caskroom/google-chrome/latest/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

#iTerm2
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/opt/homebrew-cask/Caskroom/iterm2-beta/2.9.20160313/iTerm.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

#Sublime 
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>'/opt/homebrew-cask/Caskroom/sublime-text3/3103/Sublime\ Text.app'</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

<<<<<<< HEAD
#Vmware Fusion
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>'/opt/homebrew-cask/Caskroom/vmware-fusion/8.1.0-3272237/VMware\ Fusion.app'</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

=======
>>>>>>> odd
#TaskExplorer
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/opt/homebrew-cask/Caskroom/taskexplorer/1.4.0/TaskExplorer.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'


killall Dock





