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

# https://www.scm.com/doc/Installation/Remote_GUI.html
if [ -f /usr/lib/x86_64-linux-gnu/mesa/libGL.so ]; then
	export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/mesa/libGL.so
fi

# Customize to your needs...
export ANACONDA_HOME=$HOME/lib/anaconda
export PATH=$HOME/.local/bin/:$HOME/lib/anaconda/bin:$PATH:/usr/local/cuda/bin
export LD_LIBRARY_PATH=$HOME/.local/lib:$ANACONDA_HOME/lib:$LD_LIBRARY_PATH
export CMAKE_PREFIX_PATH=$ANACONDA_HOME:$CMAKE_PREFIX_PATH

export GTAGSLABEL='native-pygments'
export GTAGSCONF=$HOME/.config/gtags.conf

export XAUTHORITY=$HOME/.Xauthority
