-- Obsidian.nvim
--
-- A Neovim plugin for writing and navigating Obsidian vaults.
--
-- About:
-- - Configured for daily journals
-- - Supports vaults under `~/Obsidian/...`.
-- - Obsidian commands start with `<Leader>o`
-- - Follow wiki and markdown links with `gf`
--
-- Entry points:
-- - `:Obsidian` - The entry point user command for the plugin
-- - `<Leader>oj` - Alias for `:Obsidian today`
-- - `<Leader>on` - Alias for `:Obsidian new`

local obsidian_path = vim.fs.normalize("~/Obsidian")
local obsidian_real_path =
  vim.fs.normalize(vim.uv.fs_realpath(obsidian_path) or obsidian_path)

---@module 'lazy'
---@type LazySpec
return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- Recommended, use latest release instead of latest commit
  lazy = true,
  dependencies = {
    "nvim-telescope/telescope.nvim", -- Picker config
  },
  cmd = { "Obsidian" },
  event = {
    {
      event = { "BufReadPre", "BufNewFile" },
      pattern = obsidian_path == obsidian_real_path
          and vim.fs.joinpath(obsidian_real_path, "**", "*.md")
          or {
            vim.fs.joinpath(obsidian_path, "**", "*.md"),
            vim.fs.joinpath(obsidian_real_path, "**", "*.md"),
          },
    },
  },
  keys = {
    {
      "<Leader>oj",
      "<cmd>Obsidian today<CR>",
      mode = "n",
      desc = "Create / open today's [o]bsidian [j]ournal",
    },
    {
      "<Leader>on",
      "<cmd>Obsidian new ",
      mode = "n",
      desc = "Create a new [o]bsidian [n]ote",
    },
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    link = {
      style = "markdown",
      format = "absolute",
    },
    workspaces = {
      {
        name = "Brain RAM",
        path = vim.fs.joinpath(obsidian_real_path, "brain_ram"),
      },
      {
        name = "Google",
        path = vim.fs.joinpath(obsidian_real_path, "google"),
      },
    },
    daily_notes = {
      enabled = true,
      folder = "dailies",
      date_format = "YYYY-MM-DD",
      alias_format = "B DD, YYYY",
      default_tags = { "daily-notes" },
    },
    picker = {
      name = "telescope.nvim",
    },
  },
  config = function(_, opts)
    require("obsidian").setup(opts)
  end,
}
