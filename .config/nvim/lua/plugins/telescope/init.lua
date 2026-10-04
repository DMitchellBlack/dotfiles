return {
  "nvim-telescope/telescope.nvim",
  tag = "v0.2.2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "smartpde/neoscopes",
  },
  opts = function(_, opts)
    opts = opts or {}
    return opts
  end,
  config = function(_, opts)
    require("telescope").setup(opts)
    local builtin = require("telescope.builtin")
    local utils = require("telescope.utils")
    local neoscopes = require("neoscopes")
    local full_live_grep =
      require("plugins.telescope.full_live_grep").full_live_grep

    vim.keymap.set({ "n" }, "<Leader>ff", function()
      builtin.find_files({
        search_dirs = neoscopes.get_current_dirs(),
        prompt_title = "Find Files (Scope)",
      })
    end, { desc = "[F]ind [F]iles in current scope" })
    -- live_grep requires ripgrep
    vim.keymap.set({ "n" }, "<Leader>fg", function()
      full_live_grep({
        search_dirs = neoscopes.get_current_dirs(),
        prompt_title = "Live Grep (Scope)",
      })
    end, { desc = "[F]ind by [G]rep in current scope" })
    vim.keymap.set({ "n" }, "<Leader>fG", function()
      full_live_grep({
        cwd = utils.buffer_dir(),
        prompt_title = "Live Grep (Buffer Dir)",
      })
    end, { desc = "[F]ind by [G]rep in buffer directory" })
    vim.keymap.set(
      { "n" },
      "<Leader>fh",
      builtin.help_tags,
      { desc = "[F]ind [H]elp" }
    )
    vim.keymap.set(
      { "n" },
      "<Leader>fb",
      builtin.buffers,
      { desc = "[F]ind [B]uffers" }
    )
    vim.keymap.set(
      { "n" },
      "<Leader>fts",
      builtin.treesitter,
      { desc = "[F]ind [T]ree[S]itter" }
    )
    vim.keymap.set(
      { "n" },
      "<Leader>f?",
      builtin.oldfiles,
      { desc = "[F]ind recent files" }
    )
    vim.keymap.set({ "n" }, "<Leader>/", function()
      builtin.current_buffer_fuzzy_find(
        require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        })
      )
    end, { desc = "[/] Fuzzily search in current buffer" })
    vim.keymap.set({ "n" }, "<Leader>f/", function()
      full_live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep (Open Files)",
      })
    end, { desc = "[F]ind [/] in Open Files" })
    vim.keymap.set({ "n" }, "<Leader>fd", function()
      builtin.find_files({
        cwd = utils.buffer_dir(),
        prompt_title = "Find Files (Buffer Dir)",
      })
    end, { desc = "[F]ind files in current [D]irectory" })
    vim.keymap.set(
      "n",
      "<leader>l",
      builtin.diagnostics,
      { desc = "Open telescope diagnostic " }
    )
    vim.keymap.set({ "n" }, "<Leader>fr", function()
      builtin.resume()
    end, { desc = "Resume the previous file picker" })

    vim.api.nvim_create_user_command("PickColorscheme", function()
      builtin.colorscheme({ enable_preview = true })
    end, { desc = "Pick a colorscheme with preview!" })
  end,
}
