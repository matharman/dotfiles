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

fish_config theme choose fox

set -gx CMAKE_EXPORT_COMPILE_COMMANDS 1
set -gx CMAKE_GENERATOR Ninja
set -gx EDITOR (type -p nvim || echo "")
set -gx GPG_TTY (tty)

if command -v -q secret-tool
    set -gx GITHUB_PAT_TOKEN (secret-tool lookup service github_pat token_type bearer 2> /dev/null)
end

set -Ux tide_left_prompt_items distrobox custom_context vi_mode pwd git
set -Ux tide_right_prompt_items status direnv node python rustc go

fish_add_path $HOME/tools
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path /usr/local/go/bin

if grep -q Ubuntu /etc/os-release
    set -gx SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
end
