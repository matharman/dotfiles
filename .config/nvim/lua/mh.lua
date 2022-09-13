local M = {}

function M.find_project_root(max_depth, patterns)
    patterns = patterns or { ".git", ".nvimrc", }
    max_depth = max_depth or 10

    local path = vim.fn.getcwd()

    for _ = 1, max_depth do
        for _, value in pairs(patterns) do
            local fstat = vim.loop.fs_stat(path .. "/" .. value)
            if fstat then
                return path
            end
        end
        path = path .. "/.."
    end

    return nil
end

function M.create_automagic_cmd(desc, event, opts)
    if not opts.group then
        opts.group = vim.api.nvim_create_augroup("automagic", { clear = false })
    end
    opts.desc = desc
    vim.api.nvim_create_autocmd(event, opts)
end

function M.add_on_save_hook(desc, patterns, callback)
    M.create_automagic_cmd(desc, "BufWritePre", {
        pattern = patterns,
        callback = callback,
    })
end

function M.cxx_format_on_save()
    local pattern = {"*.c","*.cc","*.cpp","*.h"}

    local has_clang_format = false

    local root = M.find_project_root()
    if root then
        local stat = vim.loop.fs_stat(root .. "/.clang-format")
        has_clang_format = stat ~= nil
    end

    if has_clang_format then
        M.add_on_save_hook("Format CXX on save", pattern, function()
            vim.lsp.buf.formatting_sync()
        end)
    end
end

function M.project_local_config_cxx_cross(triple, toolchain_path, opts)
    require("mh.lsp").extend_lsp_options("ccls", function()
        return vim.tbl_deep_extend("keep", opts or {}, {
            init_options = {
                clang = {
                    extraArgs = {
                        "--target=" .. triple,
                        "--gcc-toolchain=" .. toolchain_path,
                        "--sysroot=" .. toolchain_path .. "/" .. triple .. "/libc",
                        },
                    },
                }
        })
    end)
    require("mh").cxx_format_on_save()
end

function M.project_local_config_cxx_host(opts)
    require("mh.lsp").extend_lsp_options("ccls", function()
        return opts or {}
    end)
    require("mh").cxx_format_on_save()
end

return M
