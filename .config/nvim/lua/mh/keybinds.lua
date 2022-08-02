if vim.g.use_telescope then
    vim.keymap.set("n", "<leader>gf", "<Cmd>Telescope git_files<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>f", "<Cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>b", "<Cmd>Telescope buffers<CR>", { noremap = true, silent = true })
else
    vim.keymap.set("n", "<leader>gf", "<Cmd>GFiles<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>f", "<Cmd>Files<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>b", "<Cmd>Buffers<CR>", { noremap = true, silent = true })
end

local config_edit_tab_id = -1

local function config_edit_open()
    if config_edit_tab_id == -1 then
        vim.cmd[[tabnew $MYVIMRC]]
        config_edit_tab_id = vim.api.nvim_get_current_tabpage()

        local augroup = vim.api.nvim_create_augroup("ConfigEditTab", {})
        vim.api.nvim_create_autocmd("TabLeave", {
            group = augroup,
            pattern = "*",
            callback = function()
                config_edit_tab_id = -1
                vim.api.nvim_del_augroup_by_id(augroup)
            end
        })
    end
end

local function on_config_edit()
    config_edit_open()

    local home = os.getenv("HOME")
    if home then
        -- TODO: want vertical split on the right, but good enough for now.
        require("telescope.builtin").find_files({
            cwd = home .. "/.config/nvim",
            attach_mappings = function()
                local actions = require("telescope.actions")
                actions.select_default:replace(actions.select_vertical)
                return true
            end,
        })
    end
end
vim.keymap.set("n", "<leader><leader>v", on_config_edit, { noremap = true, silent = true })

-- Fugitive workflow
local function open_git_if_fugitive()
    if vim.g.loaded_fugitive then
        vim.api.nvim_command[[tabnew | Git | only]]
        local current_win = vim.api.nvim_get_current_win()

        vim.api.nvim_command[[vert Git log]]
        vim.api.nvim_set_current_win(current_win)
    end
end

vim.keymap.set("n", "<leader>G", open_git_if_fugitive, { noremap = true, silent = true })
