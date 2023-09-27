---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("custom.highlights")

M.ui = {
	transparency = true,
	theme = "decay",
	theme_toggle = { "onedark", "one_light" },
	lsp_semantic_tojens = false,
	extended_integrations = {
		"dap",
	},
	lsp = {
		signature = {
			silent = true,
			disabled = false,
		},
	},
	telescope = {
		style = "borderless",
	},
	statusline = {
		theme = "default",
		separator_style = "round",
		overriden_modules = nil,
	},
	tabufline = {
		show_numbers = false,
		enabled = true,
		lazyload = true,
		overriden_modules = nil,
	},
	cmp = {
		icons = true,
		style = "atom_colored",
	},
	nvdash = {
		load_on_startup = true,
	},
	hl_override = highlights.override,
	hl_add = highlights.add,
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

return M
