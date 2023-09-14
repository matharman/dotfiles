if status is-interactive
    set fish_greeting
    fish_hybrid_key_bindings

    alias vi="vim"
    alias vim="nvim"
    alias dots='git --git-dir=$HOME/.dots --work-tree=$HOME'

    if command -v -q rg
        set -gx FZF_DEFAULT_COMMAND "rg --files --hidden"
    end
end

set -gx CMAKE_EXPORT_COMPILE_COMMANDS 1
set -gx CMAKE_GENERATOR Ninja
set -gx EDITOR nvim
set -gx GPG_TTY (tty)

fish_add_path $HOME/tools
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path /usr/local/go/bin

#if command -v -q starship
#    starship init fish | source
#end
