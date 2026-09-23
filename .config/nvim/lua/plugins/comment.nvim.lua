return {
  "numToStr/Comment.nvim",
  lazy = true,
  keys = {
    -- Start a line-wise comment
    { "gc", mode = { "v", "n" } },
    -- Start a block comment
    { "gb", mode = { "v", "n" } },
  },
  opts = {},
  config = function(_, opts)
    require("Comment").setup(opts)
    require("Comment.ft").set("scss", { "// %s", "// %s" })
  end,
}
