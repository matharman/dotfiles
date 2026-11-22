function __update_west_config_local --on-variable PWD --description "Point west at a per-worktree local config so concurrent shells don't share manifest.path"
    set -l topdir /opt/ncs
    set -l worktree_root $HOME/m2md/zephyr-tracker-root

    if not test -d $topdir/.west
        return
    end

    set -l name (string match -r -g -- "^"(string escape --style=regex $worktree_root)"/([^/]+)" $PWD)
    if test -z "$name"
        set -e WEST_CONFIG_LOCAL
        return
    end

    set -l config $topdir/.west/$name.config
    if not test -f $config
        set -l manifest_path (realpath --relative-to=$topdir $worktree_root/$name)
        printf '[manifest]\npath = %s\nfile = west.yml\n\n[zephyr]\nbase = zephyr\n' $manifest_path >$config
    end
    set -gx WEST_CONFIG_LOCAL $config
end

# --on-variable only fires on change; handle shells started inside a worktree.
__update_west_config_local
