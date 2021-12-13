local M = {}
M.server_configs = {}

local nvim_lsp = require'lspconfig'

function M.maybe_format()
    if not vim.b.no_format then
        vim.lsp.buf.formatting_sync()
    end
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
function M.on_attach(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', '<leader>gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', '<leader>gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>p', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '<leader>n', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

    if client.name ~= "cmake" and not client.config.no_format then
        vim.api.nvim_command[[ autocmd BufWritePre <buffer> lua require'my/lsp'.maybe_format() ]]
    end
end

local default_config = {
    on_attach = M.on_attach,
}

M.server_configs.pylsp = default_config
nvim_lsp.pylsp.setup(default_config)

M.server_configs.ccls = default_config
nvim_lsp.ccls.setup(default_config)

M.server_configs.gopls = default_config
nvim_lsp.gopls.setup(default_config)

M.server_configs.rust_analyzer = default_config
nvim_lsp.rust_analyzer.setup(default_config)

require'rust-tools'.setup({
    tools = {
        autoSetHints = true,
        inlay_hints = {
            show_parameter_hints = false,
        },
    },
    server = default_config,
})

M.server_configs.cmake = default_config
nvim_lsp.cmake.setup(default_config)

function M.extend_config(server, config)
    local old_config = M.server_configs[server]
    local new_config = vim.tbl_deep_extend('force', old_config, config)
    M.server_configs[server] = new_config
    nvim_lsp[server].setup(new_config)
end

return M
