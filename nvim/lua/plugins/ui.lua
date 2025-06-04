return {
  ---@class tokyonight.Config
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true, -- Enable this to disable setting the background color
      style = "night",
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "transparent", -- style for sidebars, see below
        floats = "transparent", -- style for floating windows
      },
      dim_inactive = false, -- dims inactive windows
      on_highlights = function(hl, c)
        hl.WinSeparator = {
          bold = false,
          cterm = {
            bold = false,
          },
          fg = c.fg_dark,
        }
        hl.WinBar = {
          link = c.back,
        }
        hl.WinBarNC = {
          link = c.back,
        }
        hl.NornalNC = {}
      end,
    },
    init = function()
      vim.cmd [[colorscheme tokyonight]]
    end,
  },

  {
    "folke/noice.nvim",
    keys = { ":", "/", "?" }, -- lazy load cmp on more keys along with insert mode
    opts = {
      views = {
        cmdline_popup = {
          border = { style = "single" },
        },
        mini = {
          win_options = {
            winblend = 0, -- Set winblend to 0 for the mini view
          },
        },
      },
      presets = {
        command_palette = false,
        lsp_doc_border = {
          views = {
            hover = {
              border = {
                style = "single",
              },
            },
          },
        },
      },
      notify = {
        enabled = false,
      },
      messages = {
        enabled = true,
      },
      popupmenu = {
        enabled = false,
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          enabled = false,
        },
        progress = {
          enabled = false,
        },
        hover = {
          enabled = false,
        },
      },
    },
  },
}
