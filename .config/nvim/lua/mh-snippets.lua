luasnip = require("luasnip")

-- Nodes
local snip = luasnip.snippet
local snipnode = luasnip.snippet_node
local text = luasnip.text_node
local insert = luasnip.insert_node
local func = luasnip.function_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local lambda = require("luasnip.extras").lambda
local lambda = require("luasnip.extras").lambda
local dlambda = require("luasnip.extras").dynamic_lambda
local events = require("luasnip.util.events")

luasnip.config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI",
})

local cxx_include_guard_snip = snip("guard",
        fmt("#ifndef {}_H\n#define {}_H\n\n{}\n\n#endif  // {}_H", {
            insert(1, "GUARD"),
            rep(1), insert(0), rep(1),
        })
)

local cxx_externc_ifdef = snip("nocpp", 
        fmt([[
            #ifdef __cplusplus
            extern "C" {{
            #endif

            {}

            #ifdef __cplusplus
            }}
            #endif
            ]],
            insert(0)))

luasnip.snippets = {
    c = {
        cxx_include_guard_snip,
        cxx_externc_ifdef,
    },
    cpp = {
        cxx_include_guard_snip,
        cxx_externc_ifdef,
    },
}
