local M = {}
require'snippy'.setup({
    snippet_dirs = '~/.config/nvim/snippets',
})

local snippy = require'snippy'
local cmp = require'cmp'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

M.setup_params = {
    snippet = {
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
        end,
    },
    mapping = {
--           ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert, }),
--           ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert, }),
           ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif snippy.can_expand_or_advance() then
                snippy.expand_or_advance()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif snippy.can_jump(-1) then
                snippy.previous()
              else
                fallback()
              end
            end, { "i", "s" }),
            ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true, }),
        },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'snippy' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'tmux' },
    })
}

function M.setup(params)
    M.setup_params = vim.tbl_deep_extend("force", M.setup_params, params)
    cmp.setup(M.setup_params)
end

return M
