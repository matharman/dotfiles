local M = {}
M._server_opts = {}

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
            compilationDatabaseDirectory = "build",
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
        end,
    })

    return {
        settings = {
            analyses = {
                staticcheck = true,
            },
        },
    }
end)

function M.extend_options(base)
    local opts = base or {}

    for server, ext in pairs(M._server_opts) do
        for _, enhancer in pairs(ext) do
            opts[server] = vim.tbl_deep_extend("force", opts[server] or {}, enhancer() or {})
        end
    end

    return opts
end

return M
