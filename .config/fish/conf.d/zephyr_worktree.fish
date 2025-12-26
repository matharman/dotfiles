function __update_west_manifest_path --on-variable PWD --description "Update west's manifest.path as we navigate through worktrees"
    if not type -q west
        return
    end

    set -l new_worktree_root "$HOME/m2md/zephyr-tracker-root"
    set -l worktree_root "$HOME/work/zephyr-tracker-root"
    set -l legacy_root "$HOME/work/zephyr-tracker"

    if string match -q "$worktree_root*" "$PWD"
        set -l worktree $worktree_root/(string split -f2 "$worktree_root" "$PWD" | string split -f2 "/")
        west config --local manifest.path "$worktree" 2>/dev/null
    else if string match -q "$new_worktree_root*" "$PWD"
        set -l worktree $new_worktree_root/(string split -f2 "$new_worktree_root" "$PWD" | string split -f2 "/")
        west config --local manifest.path "$worktree" 2>/dev/null
    else if string match -q "$legacy_root*" "$PWD"
        west config --local manifest.path "$legacy_root" 2>/dev/null
    end
end
