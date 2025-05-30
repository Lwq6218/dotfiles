require("conform").setup {
  notify_on_error = true,
  format_on_save = {
    timeout_ms = 1000,
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    bash = { "shellcheck", "shfmt" },
    sh = { "shellcheck", "shfmt" },
    zsh = { "shellcheck" },
    javascript = { "prettierd", "eslint_d" },
    javascriptreact = { "prettierd", "eslint_d" },
    typescript = { "prettierd", "eslint_d" },
    typescriptreact = { "prettierd", "eslint_d" },
    css = { "prettierd" },
    jsonc = { "prettierd" },
    go = { "goimports", "gofumpt" },
    html = { "prettierd" },
    lua = { "stylua" },
    python = function(bufnr)
      if require("conform").get_formatter_info("ruff_format", bufnr).available then
        return { "ruff_format" }
      else
        return { "isort", "black" }
      end
    end,
    rust = { "rustfmt" },
  },
}
