return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({})
    require("nvim-treesitter").install({ "lua", "markdown" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "lua", "markdown" },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
