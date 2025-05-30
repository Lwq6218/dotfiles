return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets", "giuxtaposition/blink-cmp-copilot" },
    version = "1.*",
    config = function()
      require "config.cmp"
    end,
  },
}
