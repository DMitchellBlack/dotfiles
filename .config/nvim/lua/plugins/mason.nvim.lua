return {
  {
    "mason-org/mason.nvim",
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
      ensure_instaled = {
        -- The Lua language server.
        "lua_ls",
        "ts_ls",
      },
    },
  },
}
