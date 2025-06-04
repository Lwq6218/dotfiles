return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.*",
    config = function()
      require "config.cmp"
    end,
  },
}
