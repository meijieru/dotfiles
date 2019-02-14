#use extended color palette if available
if [[ $terminfo[colors] -ge 256 ]]; then
    turquoise="%F{81}"
    orange="%F{166}"
    purple="%F{135}"
    hotpink="%F{161}"
    limegreen="%F{118}"
else
    turquoise="%F{cyan}"
    orange="%F{yellow}"
    purple="%F{magenta}"
    hotpink="%F{red}"
    limegreen="%F{green}"
fi

# https://unix.stackexchange.com/q/26844
_getShortPwd() {
    echo -n `pwd | sed -e "s!$HOME!~!" | sed "s:\([^/]\)[^/]*/:\1/:g"`
}

PR_RST="%f"
PROMPT=$'%{$purple%}%n${PR_RST}@%{$orange%}%m${PR_RST} $(_getShortPwd)${PR_RST}$ '
