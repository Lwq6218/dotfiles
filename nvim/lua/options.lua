vim.loader.enable()
local opt = vim.opt
local o = vim.o
local g = vim.g
-- Nice and simple folding:
vim.o.foldcolumn = "0" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldmethod = "expr"
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- Source: https://www.reddit.com/r/neovim/comments/1fzn1zt/custom_fold_text_function_with_treesitter_syntax/
local function fold_virt_text(result, s, lnum, coloff)
  if not coloff then
    coloff = 0
  end
  local text = ""
  local hl
  for i = 1, #s do
    local char = s:sub(i, i)
    local hls = vim.treesitter.get_captures_at_pos(0, lnum, coloff + i - 1)
    local _hl = hls[#hls]
    if _hl then
      local new_hl = "@" .. _hl.capture
      if new_hl ~= hl then
        table.insert(result, { text, hl })
        text = ""
        hl = nil
      end
      text = text .. char
      hl = new_hl
    else
      text = text .. char
    end
  end
  table.insert(result, { text, hl })
end
function _G.custom_foldtext()
  local start = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop))
  local nline = vim.v.foldend - vim.v.foldstart
  local result = {}
  fold_virt_text(result, start, vim.v.foldstart - 1)
  table.insert(result, { " ... ↙ " .. nline .. " lines", "DapBreakpointCondition" })
  return result
end
vim.opt.foldtext = "v:lua.custom_foldtext()"
-------------------------------------- options ------------------------------------------
g.mapleader = " "
g.maplocalleader = " "
opt.signcolumn = "auto"
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
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)
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
