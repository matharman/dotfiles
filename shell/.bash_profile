# bash_profile -- runs for login shells

## Gather env and aliases for login shells (ie tmux)
if [ -f "$HOME/.bashrc" ]; then
    source $HOME/.bashrc
fi

## set PATH so it includes user's private bin directories
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

## On arch, initiates the GUI configured by xsession
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    [[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1 &> /dev/null
fi
