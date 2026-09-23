--- The config for the typescript-language-server
---@type vim.lsp.Config
return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "javascript" },
  settings = {},
}
