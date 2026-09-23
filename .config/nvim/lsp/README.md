# Neovim LSP Config Documentation

See `:h lsp-config` for LSP configuration documentation.

When an LSP client starts, it resolves its configuration by merging from the
following (in increasing priority):

1. Configuration defined for the `'*'` name.
1. Configuration from the result of merging all tables returned by
   `lsp/<name>.lua` files in the `'runtimepath'` for a server of name `name`.
1. Configurations defined elsewhere.
