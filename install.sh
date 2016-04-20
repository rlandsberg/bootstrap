#!/bin/bash

#Start of our install

#First we need our command line tools

#First we need our command line tools

touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
PROD=$(softwareupdate -l |
  grep "\*.*Command Line" |
  head -n 1 | awk -F"*" '{print $2}' |
  sed -e 's/^ *//' |
  tr -d '\n')
softwareupdate -i "$PROD" -v;


#Next we need to set up our directories
dir="$HOME/Workspace
echo "Making Directory"
mkdir -p $dir
cd $dir
git clone --recursive https://github.com/rlandsberg/bootstrap.git
cd bootstrap
#bash bootstrap.sh

