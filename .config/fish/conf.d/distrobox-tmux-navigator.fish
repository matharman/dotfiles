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

set -e DBX_TMUX_BRIDGE
set -Ux DBX_TMUX_BRIDGE $XDG_RUNTIME_DIR/dbx-tmux

mkdir -p "$DBX_TMUX_BRIDGE"

# Add a prefix for which kind of pane we're managing.
# NB: Check tmux first, since it may be nested in Wezterm!
if test -n "$TMUX_PANE"
    set -g bridge_pane "tmux-$TMUX_PANE"
else if test -n "$WEZTERM_PANE"
    set -g bridge_pane "wez-$WEZTERM_PANE"
end

# Inside a distrobox container shell, DISTROBOX_ENTER_PATH is set.
# If this variable exists, then we know we're in a distrobox.
if test -n "$DISTROBOX_ENTER_PATH"
    set -g dbx_tmux_bridge_ours "$DBX_TMUX_BRIDGE/$bridge_pane"

    set tty (tty)

    mkdir -p $dbx_tmux_bridge_ours
    function remove_ours_on_exit --on-event fish_exit
        rm -r $dbx_tmux_bridge_ours
    end

    echo $container_id >$dbx_tmux_bridge_ours/container_id
    echo $tty >$dbx_tmux_bridge_ours/tty
end
