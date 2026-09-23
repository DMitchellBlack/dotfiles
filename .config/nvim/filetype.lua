-----------------------------
-- Filetype configurations --
-----------------------------
vim.filetype.add({
  pattern = {
    [".*%.ng%.html"] = "htmlangular",
    [".*jetski%-prompt.*%.txt"] = "markdown",
  },
})
