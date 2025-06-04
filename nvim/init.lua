require "options"
require "autocmds"
require "commands"
require "keymaps"
require "lspconfig"

-- Neovide
if vim.g.neovide then
  vim.opt.guifont = "Maple Mono NF CN:h10.5"
  vim.opt.linespace = 0
  vim.g.neovide_fullscreen = false
  vim.g.neovide_theme = "auto"
  vim.g.neovide_opacity = 1
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_hide_mouse_when_typing = true
end
-- Wsl clipboard
if vim.fn.has "wsl" == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end
-- 自定义的 lazy.nvim 安装路径
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
-- 如果lazy.nvim不存在，则通过 Git 克隆它到指定路径
if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

-- 将 lazy.nvim 的安装路径添加到 Neovim 的运行时路径中，以便 Neovim 能找到它
vim.opt.rtp:prepend(lazypath)

-- local lazy_config = require("configs.lazy")

-- 通过 lazy.nvim 加载插件
-- lazy.nvim 会自动下载在 `.setup` 中指定的插件并加载它们
require("lazy").setup({
  -- 然后从 `plugins/` 目录（也就是你当前配置文件夹的 `lua/plugins/` 目录）中查找插件并加载
  { import = "plugins" },
}, {
  defaults = { lazy = true, version = false },
  install = { colorscheme = { "tokyonight" } },

  ui = {
    border = "single",
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
})
