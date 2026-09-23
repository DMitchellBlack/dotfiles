vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Install plugins
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = {
    colorscheme = { "desert" },
  },
  checker = {
    enabled = false,
  },
})

-- Install `vim.pack` builtin plugins
vim.cmd.packadd("nvim.difftool")
vim.cmd.packadd("nvim.undotree")

-----------------------------
-- Configure basic options --
-----------------------------
-- See `:h nvim-defaults` for Neovim's default settings
vim.cmd.colorscheme("rose-pine-moon")
vim.opt.termguicolors = true -- TrueColor support
vim.opt.number = true -- Enable line numbers
vim.opt.relativenumber = true -- Enable relative line numbers
vim.opt.cursorline = true
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest"
vim.opt.backspace = "indent,eol,start"
vim.opt.scrolloff = 3 -- Minimum num of screen lines to keep above/below cursor
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup//"
vim.opt.undofile = true
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true -- Open window in reading direction
vim.opt.splitbelow = true -- Open window in reading direction
vim.opt.wrap = false -- Don't wrap lines longer than the editor
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.updatetime = 1000 -- Controls swap-file write and CursorHold time
vim.opt.foldlevel = 99
vim.opt.conceallevel = 2 -- Determine how concealed text is shown
vim.opt.winborder = "rounded"
-- Netrw configurations
vim.g.netrw_alto = 0 -- Preview shown to right
vim.g.netrw_liststyle = 3 -- Set list style to be a tree
vim.g.netrw_preview = 1 -- Preview shown in vertically-split window
vim.g.netrw_winsize = 30 -- Window should be 30%.
-- Default indentation settings
vim.opt.expandtab = true
vim.opt.tabstop = 8 -- Best to keep a 8 for historical reasons; use softtabstop
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-------------------
-- Basic Keymaps --
-------------------
vim.keymap.set(
  { "n" },
  "<Leader><Esc>",
  ":set nohls<CR>",
  { noremap = true, silent = true, desc = "Remove search highlighs." }
)
vim.keymap.set(
  { "i" },
  "jk",
  "<Esc>",
  { noremap = true, silent = true, desc = "Exit insert mode with `jk`" }
)
-- Move things that are highlighted(visual) with J and K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- Delete but sends contents to the void register (not coppied)
vim.keymap.set(
  { "n", "v" },
  "<Leader>d",
  '"_d',
  { noremap = true, desc = "Delete to void register" }
)
vim.keymap.set(
  { "n", "v" },
  "<Leader>D",
  '"_D',
  { noremap = true, desc = "Delete to void register" }
)
-- Easier window navigation with <C-{hjkl}>
vim.keymap.set(
  "n",
  "<C-h>",
  "<C-w>h",
  { noremap = true, desc = "Move focus to left window" }
)
vim.keymap.set(
  "n",
  "<C-j>",
  "<C-w>j",
  { noremap = true, desc = "Move focus to lower window" }
)
vim.keymap.set(
  "n",
  "<C-k>",
  "<C-w>k",
  { noremap = true, desc = "Move focus to upper window" }
)
vim.keymap.set(
  "n",
  "<C-l>",
  "<C-w>l",
  { noremap = true, desc = "Move focus to right window" }
)
-- Easier buffer navigation
vim.keymap.set("n", "]b", ":bn<CR>", { desc = "Go to next buffer" })
vim.keymap.set("n", "[b", ":bp<CR>", { desc = "Go to previous buffer" })
vim.keymap.set(
  "n",
  "gb",
  ":ls<CR>:buffer<Space>",
  { desc = "List and select buffers" }
)
-- Better file navigation when jumping around
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- Diagnostic keymaps
vim.keymap.set("n", "[d", function()
  return vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", function()
  return vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set(
  "n",
  "<Leader>e",
  vim.diagnostic.open_float,
  { desc = "Show diagnostic [E]rror messages" }
)
vim.keymap.set(
  "n",
  "<Leader>q",
  vim.diagnostic.setloclist,
  { desc = "Open diagnostic [Q]uickfix list" }
)
-- Yank from / paste to system clipboard
vim.keymap.set(
  { "n", "v" },
  "<Leader>y",
  '"+y',
  { desc = "Yank to system clipboard" }
)
vim.keymap.set(
  { "n", "v" },
  "<Leader>Y",
  '"+Y',
  { desc = "Yank to system clipboard" }
)
vim.keymap.set(
  { "n", "v" },
  "<Leader>p",
  '"+p',
  { desc = "Paste after from system clipboard" }
)
vim.keymap.set(
  { "n", "v" },
  "<Leader>P",
  '"+P',
  { desc = "Paste before from system clipboard" }
)
-- Terminal-mode changes
vim.keymap.set(
  { "t" },
  "<Esc>",
  "<C-\\><C-n>",
  { desc = "Map <Esc> to exit terminal-mode" }
)

-------------------------
-- Custom User Comands --
-------------------------
vim.cmd.cabbrev({ args = { "E", "Explore" } })
