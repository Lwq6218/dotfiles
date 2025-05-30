return {
  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      return require "config.lsp"
    end,
  },

  {
    "mason-org/mason.nvim",
    event = "User FilePost",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    init = function()
      -- Make mason packages available before loading it; allows to lazy-load mason.
      vim.env.PATH = vim.fn.stdpath "data" .. "/mason/bin:" .. vim.env.PATH
      -- Do not crowd home directory with NPM cache folder
      vim.env.npm_config_cache = vim.env.HOME .. "/.cache/npm"
    end,
    opts = {
      PATH = "skip",
      ui = {
        border = "single",
        width = 0.7,
        height = 0.7,
        icons = {
          package_pending = " ",
          package_installed = " ",
          package_uninstalled = " ",
        },
      },
    },
    config = function()
      require "config.mason"
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "InsertEnter" },
    cmd = { "ConformInfo", "FormatEnable", "FormatDisable" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format { async = true, lsp_fallback = true }
        end,
        desc = "Format buffer",
      },
    },
    config = function()
      require "config.conform"
    end,
  },
  {
    "Chaitanyabsprip/fastaction.nvim",
    event = "LspAttach",
    opts = {},
  },
}
