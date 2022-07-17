local M = {}

function M.create_automagic_cmd(desc, event, opts)
    if not opts.group then
        opts.group = vim.api.nvim_create_augroup("automagic", { clear = false })
    end
    opts.desc = desc
    vim.api.nvim_create_autocmd(event, opts)
end

return M
