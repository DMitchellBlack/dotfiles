--- The config for the lua-language-server
---@type vim.lsp.Config
return {
  filetypes = { "lua" },
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua we are using (most
        -- likely LuaJIT in the case of Neovim).
        version = "LuaJIT",
        -- Tell the language server how to find Lua modules the same wasy as
        -- Neovim (see `:h lua-module-load`).
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      -- Make the server aware of Neovim's runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
      completion = {
        callSnippet = "Replace",
      },
      format = {
        -- Use `stylua` from Mason
        enable = false,
      },
    },
  },
}
