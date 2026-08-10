# Ideally we keep this in sync with https://github.com/IlanCosman/tide/blob/fcda500d2c2996e25456fb46cd1a5532b3157b16/functions/_tide_item_context.fish
# The differences are that we look for some wezterm SSHMUX specific items to trigger the SSH
# hostname.
#
# By default, tide only looks for SSH_TTY
function _tide_item_custom_context
    if set -q SSH_TTY; or set -q SSH_CONNECTION; or string match -q "*mux-server*" "$WEZTERM_EXECUTABLE"
        set -fx tide_context_color $tide_context_color_ssh
    else if test "$EUID" = 0
        set -fx tide_context_color $tide_context_color_root
    else if test "$tide_context_always_display" = true
        set -fx tide_context_color $tide_context_color_default
    else
        return
    end

    string match -qr "^(?<h>(\.?[^\.]*){0,$tide_context_hostname_parts})" @$hostname

    # We tell tide to print it as context so we get the same styling
    _tide_print_item context $USER$h
end
