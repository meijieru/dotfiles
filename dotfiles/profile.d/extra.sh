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
    export GDK_SCALE=2
    export QT_SCALE_FACTOR=2

	# otherwise opengl program may failed
    export LIBGL_ALWAYS_INDIRECT=0
fi

# load torch
export TORCH_HOME=$HOME/lib/torch
[ -f $TORCH_HOME/install/bin/torch-activate ] && \. $TORCH_HOME/install/bin/torch-activate
