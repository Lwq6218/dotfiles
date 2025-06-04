return {
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",
  {
    "alexghergh/nvim-tmux-navigation",
    keys = {
      {
        "<C-h>",
        "<Cmd>NvimTmuxNavigateLeft<cr>",
        desc = "Navigate left",
      },
      {
        "<C-j>",
        "<Cmd>NvimTmuxNavigateDown<cr>",
        desc = "Navigate down",
      },
      {
        "<C-k>",
        "<Cmd>NvimTmuxNavigateUp<cr>",
        desc = "Navigate up",
      },
      {
        "<C-l>",
        "<Cmd>NvimTmuxNavigateRight<cr>",
        desc = "Navigate right",
      },
    },
    config = true,
  },
  {
    "echasnovski/mini.icons",
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
        [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
        [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
        [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
        [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
        ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
        gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
      user_default_options = {
        names = false, -- "Name" codes like Blue or red.  Added from `vim.api.nvim_get_color_map()`
        names_opts = { -- options for mutating/filtering names.
          lowercase = true, -- name:lower(), highlight `blue` and `red`
          camelcase = true, -- name, highlight `Blue` and `Red`
          uppercase = false, -- name:upper(), highlight `BLUE` and `RED`
        },
        rgb_fn = true,
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        -- Highlighting mode.  'background'|'foreground'|'virtualtext'
        mode = "virtualtext", -- Set the display mode
        virtualtext = " ",
        virtualtext_inline = "before",
      },
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  -- stylua: ignore
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    { "<leader>qS", function() require("persistence").select() end,desc = "Select Session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
  },
  },
}
