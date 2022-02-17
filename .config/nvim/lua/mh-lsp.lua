local M = {}
M._server_opts = {}

local on_attach = function(_, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
 --   local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', '<leader>gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', '<leader>gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<leader>gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>p', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '<leader>n', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)
end

local cmp_capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

function M.extend_lsp_options(server, enhance_opts)
    M._server_opts[server] = enhance_opts
end

local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
    local opts = {
        on_attach = on_attach,
        capabilities = cmp_capabilities,
    }

    if M._server_opts[server.name] then
        M._server_opts[server.name](opts)
    end

    if server.name == "rust_analyzer" then
        -- Initialize the LSP via rust-tools instead
        require("rust-tools").setup {
            -- The "server" property provided in rust-tools setup function are the
            -- settings rust-tools will provide to lspconfig during init.
            -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
            -- with the user's own settings (opts).
            server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
        }
        server:attach_buffers()
    elseif server.name == "sumneko_lua" then
        local luadev = require("lua-dev").setup({
            lspconfig = opts
        })
        server:setup(luadev)
    elseif server.name == "ccls" then
        opts.init_options = {
            cache = {
                directory = "/tmp/ccls-cache"
            }
        }
        server:setup(opts)
    else
        server:setup(opts)
    end
end)

return M
