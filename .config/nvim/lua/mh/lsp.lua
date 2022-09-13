local M = {}
M._server_opts = {}

local default_on_attach = function(_, bufnr)
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

-- For use in project-local configs (ie cross-compiler flags for CCLS)
function M.extend_lsp_options(server, enhance_opts)
    if M._server_opts[server] then
        table.insert(M._server_opts[server], enhance_opts)
    else
        M._server_opts[server] = { enhance_opts }
    end
end

M.extend_lsp_options("ccls", function()
    return {
        init_options = {
            cache = { directory = "/tmp/ccls-cache" },
        },
    }
end)

M.extend_lsp_options("clangd", function()
    return { cmd = { "clangd", "--header-insertion=never" } }
end)

M.extend_lsp_options("gopls", function()
    local organize_imports = function(wait_ms)
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }

        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
        for _, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
                else
                    vim.lsp.buf.execute_command(r.command)
                end
            end
        end
    end

    require("mh").create_automagic_cmd("Format GO on save", "BufWritePre", {
        pattern = "*.go",
        callback = function()
            vim.lsp.buf.formatting_sync()
            organize_imports(3000)
        end
    })

    return {
        settings = {
            analyses = {
                staticcheck = true,
            },
        }
    }
end)

M.extend_lsp_options("sumneko_lua", function()
    -- Make runtime files discoverable to the server
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')

    return {
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = runtime_path,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim' },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file('', true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        }
    }
end)

local function get_extended_options(server)
    local cmp_capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

    local opts = {
        on_attach = default_on_attach,
        capabilities = cmp_capabilities,
    }

    for _, enhancer in pairs(M._server_opts[server] or {}) do
        local extensions = enhancer()
        opts = vim.tbl_deep_extend("force", opts, extensions or {})
    end

    return opts
end

function M.setup_lsp()
    require("lspconfig").ccls.setup(get_extended_options("ccls"))
    require("mason-lspconfig").setup_handlers {
        -- Default handler
        function(server)
            local options = get_extended_options(server)
            require("lspconfig")[server].setup(options)
        end,
        ["clangd"] = function()
            -- nothing because using ccls for now
        end,
        ["rust_analyzer"] = function()
            require("mh").create_automagic_cmd("Format RUST on save", "BufWritePre", {
                pattern = "*.rs",
                callback = function()
                    vim.lsp.buf.formatting_sync()
                end
            })

            -- Initialize the LSP via rust-tools instead
            require("rust-tools").setup {
                -- The "server" property provided in rust-tools setup function are the
                -- settings rust-tools will provide to lspconfig during init.
                -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
                -- with the user's own settings (opts).
                server = get_extended_options("rust_analyzer"),
            }
        end,
    }
end

return M
