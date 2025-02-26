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

set -Ux tide_left_prompt_items distrobox context vi_mode pwd git
set -Ux tide_right_prompt_items status direnv node python rustc go

fish_add_path $HOME/tools
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path /usr/local/go/bin

if grep -q Ubuntu /etc/os-release
    set -gx SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
end

tide configure --auto \
    --style=Classic \
    --prompt_colors='True color' \
    --classic_prompt_color=Darkest \
    --show_time=No \
    --classic_prompt_separators=Angled \
    --powerline_prompt_heads=Sharp \
    --powerline_prompt_tails=Sharp \
    --powerline_prompt_style='One line' \
    --prompt_spacing=Sparse \
    --icons='Few icons' \
    --transient=No
