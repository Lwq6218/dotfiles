local null_ls = require("null-ls")

local b = null_ls.builtins

local sources = {

	-- webdev stuff
	b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
	b.formatting.prettierd.with({ filetypes = { "html", "markdown", "css" } }), -- so prettier works only on these filetypes
	b.diagnostics.eslint,
  b.code_actions.eslint,
	-- Lua
	b.formatting.stylua,

	-- -- cpp
	-- b.formatting.clang_format,
}

null_ls.setup({
	debug = true,
	sources = sources,
})
