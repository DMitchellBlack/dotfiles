---@module 'lazy'
---@type LazySpec
return {
  "stevearc/conform.nvim",
  version = "*",
  enabled = true,
  lazy = true,
  cmd = {
    "ConformInfo",
    "Format",
    "FormatEnable",
    "FormatDisable",
    "FormatToggle",
  },
  event = { "BufWritePre" },
  keys = {
    -- This correspond to the vanilla Neovim way to call `formatexpr`, which
    -- is set below to call this plugin.
    { "gq", mode = { "v", "n" } },
  },
  ---@module 'conform'
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      bzl = { "buildifier" },
      css = { "prettier" },
      html = { "prettier" },
      java = { "google-java-format" },
      javascript = { "prettier" },
      json = { "prettier" },
      less = { "prettier" },
      lua = { "stylua" },
      markdown = { "mdformat" },
      python = { "black" },
      sass = { "prettier" },
      typescript = { "prettier" },
      cpp = { "clang-format" },
      sql = { "sleek" },
    },
    format_on_save = function()
      if vim.g.autoformat_enabled then
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end
    end,
    formatters = {
      ["clang-format"] = {
        prepend_args = { "-style", "Google" },
      },
      ["mdformat"] = {
        append_args = {
          "--wrap",
          "80",
          "--number",
        },
      },
      ["prettier"] = {
        append_args = {
          "--single-quote",
          "true",
          "--no-bracket-spacing",
          "--bracket-same-line",
          "false",
          "--print-width",
          "80",
          "--prose-wrap",
          "always",
        },
        options = {
          ext_parsers = {
            ["ng.html"] = "angular",
          },
        },
      },
      ["stylua"] = {
        stdin = true,
        prepend_args = {
          "--column-width",
          "80",
          "--indent-type",
          "Spaces",
          "--call-parentheses",
          "Always",
          "--indent-width",
          "2",
        },
      },
    },
  },
  init = function()
    vim.g.autoformat_enabled = true
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  config = function(_, opts)
    local conform = require("conform")
    conform.setup(opts)

    -- Command to format file or visual block range.
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line =
          vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      conform.format({
        async = true,
        lsp_format = "fallback",
        range = range,
      })
    end, { range = true, desc = "Format buffer" })

    -- Create commands to manage autoformat on save.
    vim.api.nvim_create_user_command("FormatDisable", function()
      vim.g.autoformat_enabled = false
    end, { desc = "Disable autoformat-on-save", bang = true })
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.g.autoformat_enabled = true
    end, { desc = "Enable autoformat-on-save", bang = true })
    vim.api.nvim_create_user_command("FormatToggle", function()
      vim.g.autoformat_enabled = not vim.g.autoformat_enabled
    end, { desc = "Toggle autoformat-on-save", bang = true })
  end,
}
