# load fzf
for file in /usr/share/fzf/{key-bindings,completion}.zsh; do
    [ -f "$file" ] && source "$file"
done
unset file

# wsl
if [[ $(uname -r) =~ Microsoft$ ]]; then
    unsetopt BG_NICE
    unsetopt beep
    umask 022

    export DISPLAY=localhost:0 
    export LIBGL_ALWAYS_INDIRECT=1
	export GDK_SCALE=2
fi
