-- **NOTE**: Only the primary colorscheme needs `priority = 1000, lazy = false`.
return {
  {
    "folke/tokyonight.nvim",
    priority = 1000, -- Load before all other plugins
    opts = {},
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {},
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = {},
  },
  {
    "EdenEast/nightfox.nvim",
    name = "nightfox",
    priority = 1000,
    opts = {},
  },
}
