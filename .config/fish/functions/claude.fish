function claude --wraps claude --description 'claude, but never from $HOME'
    if test "$PWD" = "$HOME"
        mkdir -p $HOME/claude-playground
        pushd $HOME/claude-playground >/dev/null
        command claude $argv
        set -l rc $status
        popd >/dev/null
        return $rc
    else
        command claude $argv
    end
end
