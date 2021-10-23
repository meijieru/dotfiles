# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
else # OS X `ls`
	colorflag="-G"
fi

# List all files colorized in long format
alias l="ls -lF ${colorflag}"
alias ll="ls -AlFh"
# List all files colorized in long format, including dot files
alias la="ls -laF ${colorflag}"
# List only directories
alias lsd='ls -lF ${colorflag} | grep "^d"'

# Always use color output for `ls`
alias ls="command ls ${colorflag}"
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# Customize to your needs...
alias mk='make'
alias matlab='matlab -nodesktop -nosplash'
alias proxychains='proxychains -q'
alias zc='z -c'      # match subdir of current dir
# alias zz='z -i'      # interactively
# alias zf='z -I'      # fuzzy finder
alias zb='z -b'      
alias zbi='z -b -i'  # jump to parent dir
alias zbf='z -b -I'  # jump to parent dir using fzf
alias rm='echo "This is not the command you are looking for."; false'

alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s zip='unzip'
alias -s bz2='tar -xjvf'

# TODO(meijieru): macos compatible
alias copytoclipboard='xclip -selection c'
alias pastefromclipboard='xclip -o -selection c'

if [ -x "$(command -v ccat)" ]; then
	alias cat='ccat'
fi
if [ -x "$(command -v tmux-next)" ]; then
	alias tmux='tmux-next -2'
else
	alias tmux='tmux -2'
fi
if [ -x "$(command -v nvim)" ]; then
	alias vim='nvim'
	alias vi='nvim'
fi
