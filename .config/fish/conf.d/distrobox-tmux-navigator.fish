if not status is-interactive
    exit
end

if test -e /.dockerenv
    set -g container_id (grep "memory:/" < /proc/self/cgroup | sed 's|.*/||')
    ## TODO -- get true container ID, not name
else if test -e /run/.containerenv
    # we're in podman, use this other trick
    set -g container_id (grep "^id=" /run/.containerenv | cut -d'=' -f2- | tr -d '"')
end

set -gx DBX_TMUX_BRIDGE $XDG_RUNTIME_DIR/dbx-tmux
if test -n "$TMUX"; and test -z "$container_id"
    tmux setenv DBX_TMUX_BRIDGE "$DBX_TMUX_BRIDGE"
end

mkdir -p "$DBX_TMUX_BRIDGE"

if test -n "$DISTROBOX_ENTER_PATH"
    set -g dbx_tmux_bridge_ours "$DBX_TMUX_BRIDGE/$TMUX_PANE"

    set tty (tty)

    mkdir -p $dbx_tmux_bridge_ours
    function remove_ours_on_exit --on-event fish_exit
        rm -r $dbx_tmux_bridge_ours
    end

    echo $container_id >$dbx_tmux_bridge_ours/container_id
    echo $tty >$dbx_tmux_bridge_ours/tty
end
