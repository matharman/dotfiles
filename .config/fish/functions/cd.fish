function cd --wraps=z
    # Forward to cd if z is not available
    if command -v z >/dev/null 2>&1
        z $argv
    else
        builtin cd $argv
    end
end
