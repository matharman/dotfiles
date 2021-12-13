local cxx_guard =
[[#ifndef ${1:GUARD|S.v:upper():gsub("%s+", "_")}_H
#define ${|S[1]:upper():gsub("%s+", "_")}_H

$0

#endif // ${|S[1]:upper():gsub("%s+", "_")}_H]]

local cxx_extern_c =
[[#ifdef __cplusplus
extern "C" {
#endif

$0

#ifdef __cplusplus
}
#endif]]

local common_snippets = {
    guard = cxx_guard,
    extern = cxx_extern_c,
}

require'snippets'.snippets = {
    c = common_snippets,
    cpp = common_snippets,
}
