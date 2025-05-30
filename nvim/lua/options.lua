local opt = vim.opt
local o = vim.o
local g = vim.g
-- Nice and simple folding:
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-------------------------------------- options ------------------------------------------
opt.signcolumn = "yes:2"
opt.wrap = true
opt.completeopt = "menu,menuone,noselect"
opt.formatoptions = "jcroqlnt"
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"
o.autoread = true
opt.conceallevel = 2
opt.shortmess:append { W = true, I = true, c = true, C = true }
opt.cmdheight = 0
-- opt.pumheight = 10
opt.scrolloff = 4
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.laststatus = 0
opt.showmode = false

-- o.winborder = "single"
o.clipboard = "unnamedplus"
o.cursorline = true
o.autoread = true

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

o.ignorecase = true
o.smartcase = true
o.mouse = "a"

-- Numbers
o.number = true
o.relativenumber = true
o.numberwidth = 2
o.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

o.splitbelow = true
o.splitright = true
o.timeoutlen = 300
o.undofile = true
o.undolevels = 10000
-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"
-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
