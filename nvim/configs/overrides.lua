local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",

    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",

    "ninja",
    "python",
    "rst",
    "toml",

    "json",
    "json5",
    "jsonc",
    "yaml",
    "c",
    "markdown",
    "markdown_inline",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",
    --python stuff
    "python",
    "ruff-lsp",
    "debugpy",
    --json stuff
    "json-lsp",
    --yaml stuff
    "yaml-language-server",
    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "deno",
    "prettierd",
    "typescript-language-server",
    "eslint_d",
    "js-debug-adapter",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
