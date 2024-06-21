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

set -Ux tide_left_prompt_items context vi_mode pwd git
set -Ux tide_right_prompt_items status direnv node python rustc go distrobox

fish_add_path $HOME/tools
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path /usr/local/go/bin

if set -q VENV_DIR
    fish_add_path $VENV_DIR/bin
end

#if command -v -q starship
#    starship init fish | source
#end
