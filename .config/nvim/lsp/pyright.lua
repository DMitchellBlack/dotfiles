--- The config for the pyright-langserver language server
--- See: https://microsoft.github.io/pyright
---@type vim.lsp.Config
return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
  },
  settings = {
    pyright = {},
    python = {
      analysis = {},
    },
  },
}
