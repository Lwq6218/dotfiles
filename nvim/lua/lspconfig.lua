vim.lsp.enable "gopls"
vim.lsp.enable "lua_ls"
vim.lsp.enable "vtsls"
vim.lsp.enable "jsonls"

for _, bind in ipairs { "grn", "gra", "gri", "grr" } do
  pcall(vim.keymap.del, "n", bind)
end

-- stylua: ignore
local custom_on_attach = function(client, buf)
  local map = function(keys, func, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, keys, func, { buffer = buf, desc = "LSP: " .. desc })
  end
  map("K", function() vim.lsp.buf.hover { border = "single" } end, "LSP show details")
  map("<leader>ca", '<cmd>lua require("fastaction").code_action()<CR>', "Display Code Actions")
  map("<leader>cr", vim.lsp.buf.rename, "Rname")
  map("gd", function()require("snacks").picker.lsp_definitions() end,  "Goto Definition")
  map("gD", vim.lsp.buf.declaration, "Goto Declaration")
  map("gr", function() require("snacks").picker.lsp_references() end, "Goto References")
  map("gI", function() require("snacks").picker.lsp_implementations() end, "Goto Implementation")

  if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, buf) then
    local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.clear_references,
    })
    vim.api.nvim_create_autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event2.buf }
      end,
    })
  end

  if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange, buf) then
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
  end

  if client.name == "gopls" then
    if not client.server_capabilities.semanticTokensProvider then
      local semantic = client.config.capabilities.textDocument.semanticTokens
      client.server_capabilities.semanticTokensProvider = {
        full = true,
        legend = {
          tokenTypes = semantic.tokenTypes,
          tokenModifiers = semantic.tokenModifiers,
        },
        range = true,
      }
    end
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    custom_on_attach(client, event.buf)
  end,
})
vim.diagnostic.config {
  virtual_lines = { current_line = true },
  -- virtual_text = { prefix = "" },
  float = { severity_sort = true, border = "single" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅙 ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
}
local function restart_lsp(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local clients
  if vim.lsp.get_clients then
    clients = vim.lsp.get_clients { bufnr = bufnr }
  else
    ---@diagnostic disable-next-line: deprecated
    clients = vim.lsp.get_active_clients { bufnr = bufnr }
  end

  for _, client in ipairs(clients) do
    vim.lsp.stop_client(client.id)
  end

  vim.defer_fn(function()
    vim.cmd "edit"
  end, 100)
end

vim.api.nvim_create_user_command("LspRestart", function()
  restart_lsp()
end, {})

local function lsp_status()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients and vim.lsp.get_clients { bufnr = bufnr }

  if #clients == 0 then
    print "󰅚 No LSP clients attached"
    return
  end

  print("󰒋 LSP Status for buffer " .. bufnr .. ":")
  print "─────────────────────────────────"

  for i, client in ipairs(clients) do
    print(string.format("󰌘 Client %d: %s (ID: %d)", i, client.name, client.id))
    print("  Root: " .. (client.config.root_dir or "N/A"))
    print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

    -- Check capabilities
    local caps = client.server_capabilities
    local features = {}
    if caps then
      if caps.completionProvider then
        table.insert(features, "completion")
      end
      if caps.hoverProvider then
        table.insert(features, "hover")
      end
      if caps.definitionProvider then
        table.insert(features, "definition")
      end
      if caps.referencesProvider then
        table.insert(features, "references")
      end
      if caps.renameProvider then
        table.insert(features, "rename")
      end
      if caps.codeActionProvider then
        table.insert(features, "code_action")
      end
      if caps.documentFormattingProvider then
        table.insert(features, "formatting")
      end
    end
    print("  Features: " .. table.concat(features, ", "))
    print ""
  end
end
vim.api.nvim_create_user_command("LspStatus", lsp_status, { desc = "Show detailed LSP status" })

local function check_lsp_capabilities()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients and vim.lsp.get_clients { bufnr = bufnr }

  if #clients == 0 then
    print "No LSP clients attached"
    return
  end

  for _, client in ipairs(clients) do
    print("Capabilities for " .. client.name .. ":")
    local caps = client.server_capabilities
    if not caps then
      print "No server capabilities available"
      return
    end
    local capability_list = {
      { "Completion", caps.completionProvider },
      { "Hover", caps.hoverProvider },
      { "Signature Help", caps.signatureHelpProvider },
      { "Go to Definition", caps.definitionProvider },
      { "Go to Declaration", caps.declarationProvider },
      { "Go to Implementation", caps.implementationProvider },
      { "Go to Type Definition", caps.typeDefinitionProvider },
      { "Find References", caps.referencesProvider },
      { "Document Highlight", caps.documentHighlightProvider },
      { "Document Symbol", caps.documentSymbolProvider },
      { "Workspace Symbol", caps.workspaceSymbolProvider },
      { "Code Action", caps.codeActionProvider },
      { "Code Lens", caps.codeLensProvider },
      { "Document Formatting", caps.documentFormattingProvider },
      { "Document Range Formatting", caps.documentRangeFormattingProvider },
      { "Rename", caps.renameProvider },
      { "Folding Range", caps.foldingRangeProvider },
      { "Selection Range", caps.selectionRangeProvider },
    }

    for _, cap in ipairs(capability_list) do
      local status = cap[2] and "✓" or "✗"
      print(string.format("  %s %s", status, cap[1]))
    end
    print ""
  end
end

vim.api.nvim_create_user_command("LspCapabilities", check_lsp_capabilities, { desc = "Show LSP capabilities" })
