-- Obsidian.nvim
--
-- A Neovim plugin for writing and navigating Obsidian vaults.
--
-- About:
-- - Configures a weekly-oriented journal
-- - Supports vaults under `~/Obsidian/...`
-- - Obsidian commands start with `<Leader>o`
-- - Follow wiki and markdown links with `gf`
--
-- Entry points:
-- - `:Obsidian` - The entry point user command for the plugin
-- - `:Obsidian weekly [OFFSET]` - Open / create a weekly note
-- - `:Obsidian weeklies` - Open a picker list of weekly notes
-- - `<Leader>oj` - Alias for `:Obsidian weekly`
-- - `<Leader>on` - Alias for `:Obsidian new`

local obsidian_path = vim.fs.normalize("~/Obsidian")
local obsidian_real_path =
  vim.fs.normalize(vim.uv.fs_realpath(obsidian_path) or obsidian_path)
local vault_patterns = obsidian_path == obsidian_real_path
    and { vim.fs.joinpath(obsidian_real_path, "**", "*.md") }
  or {
    vim.fs.joinpath(obsidian_path, "**", "*.md"),
    vim.fs.joinpath(obsidian_real_path, "**", "*.md"),
  }

---@module 'lazy'
---@type LazySpec
return {
  "obsidian-nvim/obsidian.nvim",
  tag = "v3.16.8",
  lazy = true,
  dependencies = {
    "nvim-telescope/telescope.nvim", -- Picker config
  },
  cmd = { "Obsidian" },
  event = {
    {
      event = { "BufReadPre", "BufNewFile" },
      pattern = vault_patterns,
    },
  },
  keys = {
    {
      "<Leader>oj",
      "<cmd>Obsidian weekly<CR>",
      mode = "n",
      desc = "Open current weekly [o]bsidian [j]ournal",
    },
    {
      "<Leader>on",
      ":Obsidian new ",
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
    },
    -- Place new notes in the vault root (`notes_subdir = nil`) rather than the
    -- current buffer's subdirectory.
    notes_subdir = nil,
    new_notes_location = "notes_subdir",
    -- Convert daily note commands to generate weekly notes instead
    daily_notes = {
      enabled = true,
      folder = "weeklies",
      date_format = "YYYY[w]WW",
      alias_format = "YYYY [week] WW",
      default_tags = { "weekly-notes" },
      template = nil,
    },
    -- Customize how IDs are generated given an optional title.
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID
      -- that looks like '1657296016-my-new-note', and therefore the file name
      -- '1657296016-my-new-note.md'. If no usable title is given, falls back
      -- to `zettel_id()` (e.g. '1657296016-ABCD').
      local builtin = require("obsidian.builtin")
      local slug = builtin.title_to_slug(title)
      if slug:match("^%d+%-[A-Z][A-Z][A-Z][A-Z]$") then
        return slug
      end
      return tostring(os.time()) .. "-" .. slug
    end,
    picker = {
      name = "telescope.nvim",
    },
  },
  config = function(_, opts)
    local group =
      vim.api.nvim_create_augroup("obsidian_conceal", { clear = true })
    vim.api.nvim_create_autocmd("BufEnter", {
      group = group,
      pattern = vault_patterns,
      callback = function()
        vim.opt_local.conceallevel = 2
      end,
    })
    vim.api.nvim_create_autocmd("BufLeave", {
      group = group,
      pattern = vault_patterns,
      callback = function()
        vim.opt_local.conceallevel = 0
      end,
    })

    local obsidian = require("obsidian")
    obsidian.setup(opts)

    -- `:Obsidian weekly [OFFSET]` to open / create a new weekly note. This
    -- command takes an optional offset in weeks, e.g. use `:Obsidian weekly -1`
    -- to go to last week's note.
    obsidian.register_command("weekly", {
      nargs = "?",
      func = function(data)
        local offset_days = 0
        local arg = string.gsub(data.args, " ", "")
        if string.len(arg) > 0 then
          local offset = tonumber(arg)
          if offset == nil then
            obsidian.log.err("Invalid argument, expected an integer offset")
            return
          end
          offset_days = offset * 7
        end
        local note = require("obsidian.daily").daily({ offset = offset_days })
        if note ~= nil then
          if not note:exists() then
            note:write()
          end
          note:open()
        end
      end,
    })

    -- `:Obsidian weeklies` to open a picker list of weekly notes.
    obsidian.register_command("weeklies", {
      nargs = 0,
      func = function()
        Obsidian.picker.find_notes({
          prompt_title = "Weekly Notes",
          dir = Obsidian.dir / Obsidian.opts.daily_notes.folder,
        })
      end,
    })
  end,
}
