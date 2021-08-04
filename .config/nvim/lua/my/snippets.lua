local cxx_guard =
        [[
#ifndef ${1:GUARD|S.v:upper():gsub("%s+", "_")}_H
#define ${|S[1]:upper():gsub("%s+", "_")}_H

$0

#endif // ${|S[1]:upper():gsub("%s+", "_")}_H
        ]]

local cxx_extern_c =
        [[
#ifdef __cplusplus
extern "C" {
#endif

$0

#ifdef __cplusplus
}
#endif
        ]]

require'snippets'.snippets = {
    c = {
        guard = cxx_guard,
        extern = cxx_extern_c,
    },
    cpp = {
        guard = cxx_guard,
        extern = cxx_extern_c,
    }
}
