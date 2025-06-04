local kind_icons = {
  Namespace = "󰌗",
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰆧",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󱓻",
  File = "󰈚",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰊄",
  Table = "",
  Object = "󰅩",
  Tag = "",
  Array = "[]",
  Boolean = "",
  Number = "",
  Null = "󰟢",
  Supermaven = "",
  String = "󰉿",
  Calendar = "",
  Watch = "󰥔",
  Package = "",
  Copilot = "",
  Codeium = "",
  TabNine = "",
  BladeNav = "",
}
local menu_cols = { { "label" }, { "kind_icon" }, { "kind" } }
local components = {
  kind_icon = {
    text = function(ctx)
      local icons = kind_icons
      local icon = (icons[ctx.kind] or "󰈚")
      return icon
    end,
  },
  kind = {
    highlight = function(ctx)
      return ctx.kind
    end,
  },
}
local menu = {
  scrollbar = false,
  border = "single",
  draw = {
    columns = menu_cols,
    components = components,
  },
}
require("blink.cmp").setup {
  enabled = function()
    return not vim.tbl_contains({ "minifiles" }, vim.bo.filetype)
  end,
  sources = {
    -- default = { 'lsp', 'path', 'snippets', 'buffer' },
    default = { "lsp", "path", "snippets", "buffer", "lazydev" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- make lazydev completions top priority (see `:h blink.cmp`)
        score_offset = 100,
      },
      cmdline = {
        min_keyword_length = function(ctx)
          -- when typing a command, only show when the keyword is 3 characters or longer
          if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
            return 3
          end
          return 0
        end,
      },
    },
  },
  appearance = { nerd_font_variant = "mono" },
  completion = {
    ghost_text = { enabled = true },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = { border = "single" },
    },
    menu = menu,
  },
  signature = {
    window = { border = "single" },
  },
  cmdline = {
    enabled = true,
    keymap = {
      ["<Tab>"] = { "show", "accept" },
      ["<CR>"] = { "accept_and_enter", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
    },
    completion = {
      menu = {
        ---@diagnostic disable-next-line: unused-local
        auto_show = function(ctx)
          return vim.fn.getcmdtype() == ":"
          -- enable for inputs as well, with:
          -- or vim.fn.getcmdtype() == '@'
        end,
      },
    },
  },
  fuzzy = {
    implementation = "prefer_rust_with_warning",
    sorts = {
      "exact",
      -- defaults
      "score",
      "sort_text",
    },
  },
  keymap = {
    preset = "default",
    ["<CR>"] = { "accept", "fallback" },
    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-k>"] = { "select_prev", "fallback" },
    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
  },
}
