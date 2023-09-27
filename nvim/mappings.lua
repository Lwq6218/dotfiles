---@type MappingsTable
local M = {}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },
		["<C-Up>"] = { "<cmd>resize +2 <CR>", "Increase window height", opts = { silent = true } },
		["<C-Down>"] = { "<cmd>resize -2 <CR>", "Decrease window height", opts = { silent = true } },
		["<C-Left>"] = { "<cmd>vertical resize -2 <CR>", "Decrease window width", opts = { silent = true } },
		["<C-Right>"] = { "<cmd>vertical resize +2 <CR>", "Increase window width", opts = { silent = true } },
		["<leader>lf"] = {
			function()
				vim.lsp.buf.format({ async = true })
			end,
			"LSP formatting",
		},
	},
	x = {
		["y"] = { "ygv<esc>", "improve yank", opts = { noremap = true, silent = true } },
	},
}
M.lspconfig = {
	 plugin = true,
	n = {
		["<leader>rn"] = {
			function()
				require("nvchad.renamer").open()
			end,
			"LSP rename",
		},
	},
}
M.nvimtree = {
	plugin = true,
	n = {
		-- toggle
		["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },

		-- focus
		["<C-n>"] = { "<cmd> NvimTreeFocus <CR>", "Focus nvimtree" },
	},
}
M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line"
    },
    ["<leader>dr"] = {
      "<cmd> DapContinue <CR>",
      "Run or continue the debugger"
    }
  },
}
-- more keybinds!

return M
