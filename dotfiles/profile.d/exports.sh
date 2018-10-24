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
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PYTHONPATH=$PYTHONPATH

export GTAGSLABEL='native-pygments'
export GTAGSCONF=$HOME/.config/gtags.conf

export XAUTHORITY=$HOME/.Xauthority
