#!/usr/bin/env bash

ENABLE_DEBUGGING=0
PANES_WALKER_BRIDGE="$DBX_TMUX_BRIDGE"

## Arguments from tmux #{pane_id} #{pane_tty}.
pane=$1
tty=$2

debug() {
    if [ $ENABLE_DEBUGGING != 0 ]; then
        echo "$@" >> /tmp/is_not_tmux.log
    fi
}
debug "bridge location '$DBX_TMUX_BRIDGE'"
debug "pane '$pane' tty '$tty'"

ps -o comm= -t $tty | grep "distrobox-enter" >> /dev/null
if [ $? == 0 ]; then
    container_id=$(cat "$PANES_WALKER_BRIDGE/$pane/container_id")
    container_tty=$(cat "$PANES_WALKER_BRIDGE/$pane/tty")

    debug "container '$container_id' tty '$container_tty'"

    ## This is the same process list generator used by vim-tmux-navigator, with cgroup added.
    ## Then we filter by the CONTAINER_ID appearing in the cgroup to get only processes inside the DistroBox.
    ## Finally, the cut step reshapes the list to suit the grep filter down below (also borrowed from vim-tmux-navigator)
    get_process_list="ps -t '$container_tty' -o state= -o comm= -o cgroup= | grep $container_id | cut -d' ' -f1,2"
else
    ## Process list generator used by vim-tmux-navigator
    get_process_list="ps -t '$tty' -o state= -o comm="
fi

proc_list=$(eval "$get_process_list")
debug "$proc_list"

## grep filter borrowed from vim-tmux-navigator, + fzf added for Ctrl-J Ctrl-K in tui
# eval "$get_process_list" | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?(g?(view|n?vim?x?)(diff)?|fzf)$' >> /dev/null
# eval "$get_process_list" | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?(g?(view|n?vim?x?)(diff)?|fzf)$'
echo "$proc_list" | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?(g?(view|n?vim?x?)(diff)?|fzf)$'
result=$?
debug "grep result $result"
debug ""
exit $result
