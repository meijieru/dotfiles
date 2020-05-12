# Modified/Stolen from:
# http://mths.be/dotfiles

# Make vim the default editor
export EDITOR="nvim"

# Larger bash history (allow 32³ entries; default is 500)
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Prefer US English and use UTF-8
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Highlight section titles in manual pages
export LESS_TERMCAP_md="$ORANGE"

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# term
export TERM="xterm-256color"

# Customize to your needs...
export PATH=$HOME/.local/bin/:$PATH
export LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH

export GTAGSLABEL='native-pygments'
export GTAGSCONF=$HOME/.config/gtags.conf

export XAUTHORITY=$HOME/.Xauthority

# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export IPYTHONDIR=$XDG_CONFIG_HOME/ipython
export JUPYTER_CONFIG_DIR=$XDG_CONFIG_HOME/jupyter
# export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/config
