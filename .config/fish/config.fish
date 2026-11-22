set -gx CMAKE_EXPORT_COMPILE_COMMANDS 1
set -gx CMAKE_GENERATOR Ninja

fish_add_path -g $HOME/tools
fish_add_path -g $HOME/.local/bin
fish_add_path -g $HOME/.fzf/bin
fish_add_path -g $HOME/.cargo/bin
fish_add_path -g /usr/local/go/bin

# For NCS distroboxes
fish_add_path -g /opt/venv/bin

set -gx EDITOR (type -p nvim || echo "")

if grep -q Ubuntu /etc/os-release
    set -gx SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
end

# tide renders the prompt in a background `fish -c`, which sources this file on every prompt.
status is-interactive; or return

set fish_greeting
fish_hybrid_key_bindings
fish_config theme choose fox

set -gx GPG_TTY (tty)

alias vi="vim"
alias vim="nvim"
alias dots='git --git-dir=$HOME/.dots --work-tree=$HOME'

if command -v -q rg
    set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --glob '!.git'"
end
set -gx FZF_DEFAULT_OPTS "--layout=reverse --border --info=hidden --height 60% --multi"

if functions -q _tide_item_vcs
    set my_tide_vcs_item vcs
else
    set my_tide_vcs_item git
end

set -g tide_left_prompt_items distrobox custom_context vi_mode pwd $my_tide_vcs_item
set -g tide_right_prompt_items status direnv node python rustc go

if command -v -q zoxide
    zoxide init fish --cmd cd | source
end
