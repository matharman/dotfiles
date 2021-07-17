local M = {}

local function file_exists(path)
    local stat = vim.loop.fs_stat(path)
    return (stat and stat.type) or false
end

local function is_project_root(dir, root_file)
    return file_exists(dir .. '/' .. root_file)
end

function M.find_project_root(root_file, max_depth)
    max_depth = max_depth or 10

    local path = vim.fn.getcwd()
    local root = path

    local parent_path = function(path)
        local rev = path:reverse()
        for i = 1, #rev do
            if rev:sub(i,i) == '/' then
                return path:sub(1, #path - i)
            end
        end

        return path
    end

    while max_depth >= 0 do
        if is_project_root(path, root_file) then
            root = path
            break
        end

        local parent = parent_path(path)
        if parent == path then
            break
        end

        path = parent
        max_depth = max_depth - 1
    end

    return root
end

return M
