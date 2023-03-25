#!/usr/bin/env bash

ENABLE_DEBUGGING=0

## Arguments from tmux #{pane_id} #{pane_tty}.
pane=$1
tty=$2

debug() {
    if [ $ENABLE_DEBUGGING != 0 ]; then
        echo "$@" >> /tmp/is_not_tmux.log
    fi
}
debug "pane $pane tty $tty"

ps -o comm= -t $tty | grep "distrobox-enter" >> /dev/null
if [ $? == 0 ]; then
    container_id=$(cat $DBX_TMUX_BRIDGE/$pane/container_id)
    distrobox_tmux_tty=$(cat $DBX_TMUX_BRIDGE/$pane/tty)

    debug "tmux_tty $distrobox_tmux_tty container $container_id"

    ## This is the same process list generator used by vim-tmux-navigator, with cgroup added.
    ## Then we filter by the CONTAINER_ID appearing in the cgroup to get only processes inside the DistroBox.
    ## Finally, the cut step reshapes the list to suit the grep filter down below (also borrowed from vim-tmux-navigator)
    get_process_list="ps -t '$distrobox_tmux_tty' -o state= -o comm= -o cgroup= | grep $container_id | cut -d' ' -f1,2"
else
    ## Process list generator used by vim-tmux-navigator
    get_process_list="ps -t '$tty' -o state= -o comm="
fi

## grep filter borrowed from vim-tmux-navigator, + fzf added for Ctrl-J Ctrl-K in tui
eval "$get_process_list" | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?(g?(view|n?vim?x?)(diff)?|fzf)$' >> /dev/null
result=$?
debug "grep result $result"
debug ""
exit $result
