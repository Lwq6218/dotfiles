-- Terminal Mappings
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end 
require("snacks").setup {
  notifier = { enabled = true, reflesh = 120, margin = { top = 5, right = 2, bottom = 0 } },
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  indent = {
    enabled = true,
    indent = {
      enabled = false,
    },
    filter = function(buf)
      local exclude = { "help" }
      return vim.g.snacks_indent ~= false
        and vim.b[buf].snacks_indent ~= false
        and vim.bo[buf].buftype == ""
        and not vim.tbl_contains(exclude, vim.bo[buf].filetype)
    end,
  },
  input = { enabled = true },
  picker = {
    enabled = true,
    debug = {
      scores = true, -- show scores in the list
    },
    layout = {
      preset = "ivy",
      -- When reaching the bottom of the results in the picker, I don't want
      -- it to cycle and go back to the top
      cycle = false,
    },
    win = {
      input = {
        keys = {
          -- to close the picker on ESC instead of going to normal mode,
          -- add the following keymap to your config
          ["<Esc>"] = { "close", mode = { "n", "i" } },
          -- I'm used to scrolling like this in LazyGit
          ["J"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["K"] = { "preview_scroll_up", mode = { "i", "n" } },
          ["H"] = { "preview_scroll_left", mode = { "i", "n" } },
          ["L"] = { "preview_scroll_right", mode = { "i", "n" } },
        },
      },
    },
    formatters = {
      file = {
        filename_first = true, -- display filename before the file path
        truncate = 80,
      },
    },
    matcher = {
      frecency = true,
    },
    layouts = {
      -- I wanted to modify the ivy layout height and preview pane width,
      -- this is the only way I was able to do it
      -- NOTE: I don't think this is the right way as I'm declaring all the
      -- other values below, if you know a better way, let me know
      --
      -- Then call this layout in the keymaps above
      -- got example from here
      -- https://github.com/folke/snacks.nvim/discussions/468
      ivy = {
        layout = {
          box = "vertical",
          backdrop = false,
          row = -1,
          width = 0,
          height = 0.5,
          border = "top",
          title = " {title} {live} {flags}",
          title_pos = "left",
          { win = "input", height = 1, border = "bottom" },
          {
            box = "horizontal",
            { win = "list", border = "none" },
            { win = "preview", title = "{preview}", width = 0.5, border = "left" },
          },
        },
      },
      -- I wanted to modify the layout width
      --
      vertical = {
        layout = {
          backdrop = false,
          width = 0.8,
          min_width = 80,
          height = 0.8,
          min_height = 30,
          box = "vertical",
          border = "single",
          title = "{title} {live} {flags}",
          title_pos = "center",
          { win = "input", height = 1, border = "bottom" },
          { win = "list", border = "none" },
          { win = "preview", title = "{preview}", height = 0.4, border = "top" },
        },
      },
    },
    sources = {
      ---@class snacks.picker.explorer.Config: snacks.picker.files.Config|{}
      explorer = {
        finder = "explorer",
        debug = {
          scores = false,
        },
        icons = {
          tree = {
            vertical = "  ",
            middle = "  ",
            last = "  ",
          },
        },
        auto_close = true,
        layout = { layout = { position = "right" } },
        hidden = true,
      },
    },
  },
  layout = {
    enabled = true,
  },
  win = { border = "single" },
  words = { enabled = false },
  dashboard = { enabled = true },
  explorer = { enabled = false },
  scope = { enabled = false },
  scroll = { enabled = false },
  terminal = {
    win = {
      keys = {
        nav_h = { "<C-h>", term_nav "h", desc = "Go to Left Window", expr = true, mode = "t" },
        nav_j = { "<C-j>", term_nav "j", desc = "Go to Lower Window", expr = true, mode = "t" },
        nav_k = { "<C-k>", term_nav "k", desc = "Go to Upper Window", expr = true, mode = "t" },
        nav_l = { "<C-l>", term_nav "l", desc = "Go to Right Window", expr = true, mode = "t" },
      },
    },
  },
  statuscolumn = {
    enabled = true,
    left = { "mark", "sign" }, -- priority of signs on the left (high to low)
    right = { "fold", "git" }, -- priority of signs on the right (high to low)
    folds = {
      open = true, -- show open fold icons
      git_hl = true, -- use Git Signs hl for fold icons
    },
    git = {
      -- patterns to match Git signs
      patterns = { "GitSign", "MiniDiffSign" },
    },
    refresh = 50, -- refresh at most every 50ms
  },
  styles = {
    zen = {
      keys = { q = "close" },
    },
    notification = {
      border = "single",
    },
    notification_history = {
      border = "single",
    },
  },
}
