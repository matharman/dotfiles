local M = {}

function M.find_project_root(max_depth, patterns)
	patterns = patterns or { ".git", ".nvimrc" }
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
	local pattern = { "*.c", "*.cc", "*.cpp", "*.h" }

	local has_clang_format = false

	local root = M.find_project_root()
	if root then
		local stat = vim.loop.fs_stat(root .. "/.clang-format")
		has_clang_format = stat ~= nil
	end

	if has_clang_format then
		M.add_on_save_hook("Format CXX on save", pattern, function()
			vim.lsp.buf.format()
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
						"--sysroot=" .. toolchain_path .. "/" .. triple,
					},
				},
			},
		})
	end)
	M.cxx_format_on_save()
end

function M.project_local_config_cxx_host(opts)
	require("mh.lsp").extend_lsp_options("ccls", function()
		return opts or {}
	end)
	M.cxx_format_on_save()
end

-- Fugitive workflow
function M.open_git_if_fugitive()
	if vim.g.loaded_fugitive then
		vim.api.nvim_command([[tabnew | Git log | only]])
		vim.api.nvim_command([[vert Git]])
	end
end

local function load_nvimrc(path)
	path = path .. "/.nvimrc"
	local fstat = vim.loop.fs_stat(path)
	if fstat then
		local uid = vim.loop.getuid()
		local gid = vim.loop.getgid()
		if fstat.uid == uid or fstat.gid == gid then
			vim.cmd("source " .. path)
			print("loaded local config from " .. path)
		end
	end
end

function M.load_project_local()
	local root = M.find_project_root()
	if root then
		load_nvimrc(root)
	end
end

return M
