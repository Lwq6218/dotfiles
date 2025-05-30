return {
  {
    "nvim-treesitter/nvim-treesitter",
    versioon = false,
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    config = function()
      local opts = {
        ensure_installed = {
          "bash",
          "diff",
          "regex",
          -- Nvim
          "lua",
          "luadoc",
          "query",
          "vim",
          "vimdoc",
          -- Markdown
          "markdown",
          "markdown_inline",
          -- Typescript
          "html",
          "css",
          "json",
          "javascript",
          "typescript",
          "tsx",
          -- Goland
          "go",
          "gomod",
          "gowork",
          "gosum",
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        disable = function(lang, bufnr)
          return lang == "yaml" and vim.api.nvim_buf_line_count(bufnr) > 5000
        end,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true, disable = { "ruby" } },
      }
      local function add(lang)
        if type(opts.ensure_installed) == "table" then
          table.insert(opts.ensure_installed, lang)
        end
      end

      ---@type string
      local xdg_config = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config"

      ---@param path string
      local function have(path)
        return vim.uv.fs_stat(xdg_config .. "/" .. path) ~= nil
      end
      vim.filetype.add {
        extension = { rasi = "rasi", rofi = "rasi", wofi = "rasi" },
        filename = {
          ["vifmrc"] = "vim",
        },
        pattern = {
          [".*/waybar/config"] = "jsonc",
          [".*/mako/config"] = "dosini",
          [".*/kitty/.+%.conf"] = "kitty",
          [".*/hypr/.+%.conf"] = "hyprlang",
          ["%.env%.[%w_.-]+"] = "sh",
        },
      }
      vim.treesitter.language.register("bash", "kitty")

      add "git_config"

      if have "hypr" then
        add "hyprlang"
      end

      if have "fish" then
        add "fish"
      end

      if have "rofi" or have "wofi" then
        add "rasi"
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPost", "BufNewFile" },
    enabled = true,
    config = function()
      require("nvim-treesitter.configs").setup {
        textobjects = {
          move = {
            enable = true,
            goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
            goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
            goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
          },
        },
      }

      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require "nvim-treesitter.textobjects.move" ---@type table<string,fun(...)>
      local configs = require "nvim-treesitter.configs"
      for name, fn in pairs(move) do
        if name:find "goto" == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find "[%]%[][cC]" then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascriipt", "typescriptreact", "javascriptreact", "typescript", "xml", "markdown" },
    opts = {},
  },
}
