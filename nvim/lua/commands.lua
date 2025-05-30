vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd "MasonInstall shfmt lua-language-server stylua gopls goimports gofumpt vtsls prettierd"
end, {})
