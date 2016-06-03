#!/bin/bash
# Most of this is from https://github.com/paulmillr/dotfiles/blob/master/symlink-dotfiles.sh

echo "Remember to install Package Manager from https://packagecontrol.io/installation#st3"


dotfiles="$HOME/dotfiles"

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

cd "$HOME/Library/Application\ Support/Sublime\ Text\ 3/"
rm -rf "$HOME/Library/Application\ Support/Sublime\ Text\ 3/User"
ln -s "$HOME/Workspace/dotfiles/Sublime/User/ User"

# Setting up our iTerm2 preferences

defaults write com.googlecode.iterm2 PrefsCustomFolder "$HOME/dotfiles"

# Add our applications to the Dock.

# Chrome 
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/opt/homebrew-cask/Caskroom/google-chrome/latest/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

#iTerm2
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/opt/homebrew-cask/Caskroom/iterm2-beta/2.9.20160313/iTerm.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

#Sublime 
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>'/opt/homebrew-cask/Caskroom/sublime-text3/3103/Sublime\ Text.app'</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

#TaskExplorer
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/opt/homebrew-cask/Caskroom/taskexplorer/1.4.0/TaskExplorer.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'


killall Dock





