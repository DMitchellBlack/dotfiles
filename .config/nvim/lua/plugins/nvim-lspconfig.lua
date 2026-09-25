---@module 'lazy'
---@type LazySpec
return {
  "neovim/nvim-lspconfig",
  tag = "v2.9.0",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        --- Util function for creating normal mode keymaps
        ---
        ---@param keys string Left-hand side of the mapping
        ---@param func string|function Right-hand side of the mapping
        ---@param desc string Description of the keymap
        local map = function(keys, func, desc)
          -- stylua: ignore
          vim.keymap.set("n", keys, func, { noremap = true, silent = true, buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- **NOTE**: When LSP activates, it by default enables various LSP
        -- features and sets options and keymaps. For details, see
        -- `:h lsp-defaults` GLOBAL DEFAULTS and BUFFER_LOCAL DEFAULTS.
        map(
          "gd",
          require("telescope.builtin").lsp_definitions,
          "[G]oto [D]efinition"
        )
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map(
          "gr",
          require("telescope.builtin").lsp_references,
          "[G]oto [R]eferences"
        )
        map(
          "gI",
          require("telescope.builtin").lsp_implementations,
          "[G]oto [I]mplementation"
        )
        map(
          "gt",
          require("telescope.builtin").lsp_type_definitions,
          "[G]oto [T]ype Definition"
        )
        map("gs", vim.lsp.buf.signature_help, "[G]et [S]ignature help")
        map("<Leader>ca", vim.lsp.buf.code_action, "[C]ode [a]ction")
        -- mapping for rename

        local lsp_group =
          vim.api.nvim_create_augroup("LSP_group", { clear = false })
        -- Highlight the word under cursor
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if
          client and client:supports_method("textDocument/documentHighlight")
        then
          -- Highlight word under cursor
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = lsp_group,
            callback = vim.lsp.buf.document_highlight,
          })
          -- Remove highlight when you move
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = lsp_group,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- Cleanup
        vim.api.nvim_create_autocmd("LspDetach", {
          group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({
              group = lsp_group,
              buffer = event2.buf,
            })
          end,
        })
      end,
    })

    -- Create capabilities including any from plugins
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend(
      "force",
      capabilities,
      require("cmp_nvim_lsp").default_capabilities()
    )

    -- Capabilities for all clients,
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    -- The typescript-language-server in `lsp/ts_ls.lua`
    vim.lsp.enable("ts_ls")
    -- The lua-language-server in `lsp/lua_ls.lua`
    vim.lsp.enable("lua_ls")
    -- The pyright-langserver in `lsp/pyright.lua`
    vim.lsp.enable("pyright")
  end,
}
