---@module 'lazy'
---@type LazySpec
return {
  {
    "mason-org/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonLog",
      "MasonUpdate",
    },
    lazy = true,
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      -- A list of servers to automatically install if they're not already
      -- installed.
      ensure_installed = {
        -- The Lua language server.
        "lua_ls",
        "ts_ls",
        -- TOML formatter / linter / language server
        "tombi",
      },
      -- Don't automatically call `vim.lsp.enable()` for installed servers
      automatic_enable = false,
    },
  },
}
