local servers = {
  -- Lua
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        diagnostics = { disable = { "missing-fields" } },
        hint = {
          enable = true,
        },
      },
    },
  },
  --typescripts
  vtsls = {
    -- explicitly add default filetypes, so that we can extend
    -- them in related extras
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = {
          maxInlayHintLength = 30,
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
    },
  },
  -- GoLand
  -- goimports = {},
  -- gofumpt = {},
  -- gomodifytags = {},
  -- impl = {},
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        codelenses = {
          gc_details = false,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        analyses = {
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        semanticTokens = true,
      },
    },
  },
}
for _, bind in ipairs { "grn", "gra", "gri", "grr" } do
  pcall(vim.keymap.del, "n", bind)
end

local custom_on_attach = function(client, buf)
  -- NOTE: Remember that Lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local map = function(keys, func, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, keys, func, { buffer = buf, desc = "LSP: " .. desc })
  end

  map("K", function()
    vim.lsp.buf.hover { border = "single" }
  end, "LSP show details")
  map("<leader>ca", '<cmd>lua require("fastaction").code_action()<CR>', "Display code actions")
  -- Rename the variable under your cursor.
  --  Most Language Servers support renaming across files, etc.
  -- map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  -- map("gra", vim.lsp.buf.code_action, "Goto Code Action", { "n", "x" })

  -- Find references for the word under your cursor.
  -- map("grr", require("telescope.builtin").lsp_references, "Goto References")

  -- Jump to the implementation of the word under your cursor.
  --  Useful when your language has ways of declaring types without an actual implementation.
  -- map("gri", require("telescope.builtin").lsp_implementations, "Goto Implementation")

  -- Jump to the definition of the word under your cursor.
  --  This is where a variable was first declared, or where a function is defined, etc.
  --  To jump back, press <C-t>.
  -- map("grd", require("telescope.builtin").lsp_definitions, "Goto Definition")

  -- WARN: This is not Goto Definition, this is Goto Declaration.
  --  For example, in C this would take you to the header.
  -- map("grD", vim.lsp.buf.declaration, "Goto Geclaration")

  -- Fuzzy find all the symbols in your current document.
  --  Symbols are things like variables, functions, types, etc.
  -- map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")

  -- Fuzzy find all the symbols in your current workspace.
  --  Similar to document symbols, except searches over your entire project.
  -- map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

  -- Jump to the type of the word under your cursor.
  --  Useful when you're not sure what type a variable is and you want to see
  --  the definition of its *type*, not where it was *defined*.
  -- map("grt", require("telescope.builtin").lsp_type_definitions, "Goto Type Definition")

  -- When you move your cursor, the highlights will be cleared (the second autocommand).

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
  -- The following code creates a keymap to toggle inlay hints in your
  -- code, if the language server you are using supports them
  --
  -- This may be unwanted, since they displace some of your code
  if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, buf) then
    map("<leader>th", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = buf })
    end, "[T]oggle Inlay [H]ints")
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
-- disable semanticTokens
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- local on_init = function(client, _)
--   if client.supports_method "textDocument/semanticTokens" then
--     client.server_capabilities.semanticTokensProvider = nil
--   end
-- end
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
local default_lspconfig_setup_options = {
  capabilities = capabilities,
}

for name, opts in pairs(servers) do
  vim.lsp.config(name, vim.tbl_deep_extend("force", {}, default_lspconfig_setup_options, opts or {}))
  vim.lsp.enable(name)
end

local function truncate_message(message, max_length)
  if #message > max_length then
    return message:sub(1, max_length) .. "..."
  end
  return message
end
-- wrappers to allow for toggling
local def_virtual_text = {
  isTrue = {
    severity = { max = "WARN" },
    source = "if_many",
    spacing = 4,
    prefix = "󱓻 ",
  },
  isFalse = false,
}
local def_virtual_lines = {
  isTrue = {
    current_line = true,
    severity = { min = "ERROR" },
    format = function(diagnostic)
      local max_length = 100 -- Set your preferred max length
      return "󱓻 " .. truncate_message(diagnostic.message, max_length)
    end,
  },
  isFalse = false,
}

vim.diagnostic.config {
  virtual_lines = def_virtual_lines.isTrue,
  virtual_text = def_virtual_text.isTrue,
  -- virtual_text = { prefix = "" },
  update_in_insert = false,
  -- virtual_lines = true,
  underline = true,
  -- float = { border = "single" },
  float = {
    focusable = false,
    style = "minimal",
    border = "single",
    source = true,
    header = "",
    prefix = "",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅙 ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      -- [vim.diagnostic.severity.ERROR] = "",
      -- [vim.diagnostic.severity.WARN] = "",
      -- [vim.diagnostic.severity.INFO] = "",
      -- [vim.diagnostic.severity.HINT] = "",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg", -- Just cause its also bold
      [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticHint",
    },
  },
}
