#!/bin/zsh

    # PATH
    export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:~/workspace/exercism"
    export EDITOR="subl -w"
    export GOPATH="/Users/$USER_NAME/Workspace/"
    export PYTHONPATH=$PYTHONPATH
    
    # export MANPATH="/usr/local/man:$MANPATH"

    # Virtual Environment
    #export WORKON_HOME=$HOME/.virtualenvs
    #export PROJECT_HOME=$HOME/workspace
    # source /usr/local/bin/virtualenvwrapper.sh

    # Owner
    export USER_NAME="Richard Landsberg"

    # FileSearch
    function f() { find . -iname "*$1*" ${@:2} }
    function r() { grep "$1" ${@:2} -R . }

    #mkdir and cd
    function mkcd() { mkdir -p "$@" && cd "$_"; }

    # Aliases
    alias cppcompile='c++ -std=c++11 -stdlib=libc++'
    alias subl='subl --command toggle_full_screen'
    alias signapp='codesign --force --sign "Developer ID Application: Richard Landsberg"'

    # Add syntax highlighting to zsh
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh