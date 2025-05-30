-- local flash_on_picker = function(picker)
--   require("flash").jump {
--     pattern = "^",
--     label = { after = { 0, 0 } },
--     search = {
--       mode = "search",
--       exclude = {
--         function(win)
--           return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
--         end,
--       },
--     },
--     action = function(match)
--       local idx = picker.list:row2idx(match.pos[1])
--       picker.list:_move(idx, true, true)
--       -- you can also add auto confirm here
--     end,
--   }
-- end
--: ddd
return {
  -- {
  --   "folke/snacks.nvim",
  --   opts = {
  --     picker = {
  --       actions = {
  --         flash = flash_on_picker,
  --       },
  --       win = {
  --         input = {
  --           keys = {
  --             ["<a-s>"] = { "flash", mode = { "n", "i" } },
  --             ["s"] = { "flash" },
  --           },
  --         },
  --       },
  --     },
  --   },
  --   keys = {
  --     {
  --       "<leader>b",
  --       function()
  --         Snacks.picker.buffers {
  --           on_show = function(picker)
  --             vim.cmd.stopinsert()
  --
  --             -- you can auto enable it if you want
  --             vim.schedule(function()
  --               flash_on_picker(picker)
  --             end)
  --           end,
  --         }
  --       end,t
  --       desc = "Buffers",
  --     },
  --   },
  -- },
  {
    "folke/ts-comments.nvim",
    event = "BufRead",
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    cmd = { "TodoTrouble", "TodoTelescope" },
    opts = {},
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next Todo Comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous Todo Comment",
      },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      {
        "<leader>xT",
        "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
        desc = "Todo/Fix/Fixme (Trouble)",
      },
    },
  },
  {
    "folke/flash.nvim",
    event = "BufRead",
    opts = {},
    keys = {
      {
        "gm",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "gM",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "gr",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "jemote Flash",
      },
      {
        "gR",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
    },
  },
  {
    "folke/flash.nvim",
    optional = true,
    specs = {
      {
        "folke/snacks.nvim",
        opts = {
          picker = {
            win = {
              input = {
                keys = {
                  ["<a-s>"] = { "flash", mode = { "n", "i" } },
                  ["s"] = { "flash" },
                },
              },
            },
            actions = {
              flash = function(picker)
                require("flash").jump {
                  pattern = "^",
                  label = { after = { 0, 0 } },
                  search = {
                    mode = "search",
                    exclude = {
                      function(win)
                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                      end,
                    },
                  },
                  action = function(match)
                    local idx = picker.list:row2idx(match.pos[1])
                    picker.list:_move(idx, true, true)
                  end,
                }
              end,
            },
          },
        },
      },
    },
  },

  {
    "echasnovski/mini.pairs",
    event = { "InsertEnter" },
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
  },
  {
    "echasnovski/mini.ai",
    event = "BufRead",
    opts = function()
      local ai = require "mini.ai"
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter { -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          },
          f = ai.gen_spec.treesitter { a = "@function.outer", i = "@function.inner" }, -- function
          c = ai.gen_spec.treesitter { a = "@class.outer", i = "@class.inner" }, -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call { name_pattern = "[%w_]" }, -- without dot in function name
        },
      }
    end,
  },
  {
    "echasnovski/mini.surround",
    event = "BufRead",

    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = function()
      local keys = {
        {
          "<leader>oo",
          function()
            local harpoon = require "harpoon"
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon open",
        },
        {
          "<leader>oa",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon file",
        },
        {
          "<leader>or",
          function()
            require("harpoon"):list():remove()
          end,
          desc = "Unharpoon file",
        },
        {
          "<leader>oc",
          function()
            require("harpoon"):list():clear()
          end,
          desc = "Unharpoon all files",
        },
      }

      for i = 1, 5 do
        table.insert(keys, {
          "<leader>" .. i,
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "Harpoon " .. i,
        })

        table.insert(keys, {
          "<leader>o" .. i,
          function()
            require("harpoon"):list():replace_at(i)
          end,
          desc = "Set buffer as " .. i,
        })
      end

      return keys
    end,

    opts = {},
  },
}
