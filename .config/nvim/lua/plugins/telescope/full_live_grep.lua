local conf = require("telescope.config").values
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local utils = require("telescope.utils")

local Path = require("plenary.path")

local M = {}

-- Common aliases for ripgrep file types (especially Google-specific and common shorthand)
local type_aliases = {
  ["bash"] = "sh",
  ["build"] = "bazel",
  ["bzl"] = "bazel",
  ["c++"] = "cpp",
  ["js"] = "javascript",
  ["md"] = "markdown",
  ["proto"] = "protobuf",
  ["py"] = "python",
  ["rs"] = "rust",
  ["sh"] = "sh",
  ["textproto"] = "protobuf",
  ["ts"] = "typescript",
  ["yaml"] = "yaml",
  ["yml"] = "yaml",
  ["zsh"] = "zsh",
}

---Get a relative filelist of currently listed open buffers.
---Filters out unnamed and unreadable buffers so ripgrep receives only valid file paths.
---@param cwd string The root directory to make paths relative to
---@return string[] List of relative file paths
local get_open_filelist = function(cwd)
  local bufnrs = vim.tbl_filter(function(b)
    return vim.fn.buflisted(b) == 1
  end, vim.api.nvim_list_bufs())

  local filelist = {}
  for _, bufnr in ipairs(bufnrs) do
    local file = vim.api.nvim_buf_get_name(bufnr)
    if file ~= "" and vim.fn.filereadable(file) == 1 then
      table.insert(filelist, Path:new(file):make_relative(cwd))
    end
  end
  return filelist
end

---Check if the grep program (ripgrep) is installed and executable.
---Notifies the user with an error message if missing.
---@param picker_name string The name of the calling picker
---@param program string The binary name or path to check (e.g. `rg`)
---@return boolean True if executable, false otherwise
local has_rg_program = function(picker_name, program)
  if vim.fn.executable(program) == 1 then
    return true
  end

  utils.notify(picker_name, {
    msg = string.format(
      "'%s' is not executable. Please install ripgrep: https://github.com/BurntSushi/ripgrep",
      program
    ),
    level = "ERROR",
  })
  return false
end

---@class FullLiveGrepOpts
---@field cwd? string Root directory to run search in. Defaults to `vim.loop.cwd()`.
---@field search_dirs? string[] Directories or files to search in.
---@field grep_open_files? boolean Restrict search to currently open buffers.
---@field additional_args? string[] | fun(opts: FullLiveGrepOpts): string[] Extra arguments passed to ripgrep.
---@field type_filter? string Filter by ripgrep file type (`--type=<type>`).
---@field glob_pattern? string | string[] Glob pattern(s) to include or exclude (`--glob=<pattern>`).
---@field vimgrep_arguments? string[] Command and default arguments for ripgrep.
---@field prompt_title? string Custom title for the Telescope picker window.
---@field max_results? number Maximum number of results to display.
---@field entry_maker? fun(line: string): table Custom entry maker for Telescope results.

---Live grep with dynamic argument parsing directly in the prompt.
---
---Supports inline filters (Google Code Search style):
--- - `lang:<language>` (e.g. `lang:python`, `lang:proto`, `lang:bzl`) - filters by language using `rg --type=<lang>`
--- - `--type=<type>` (e.g. `--type=cpp`) - filters by ripgrep type
--- - `f:<glob>` or `file:<glob>` (e.g. `f:BUILD`, `f:*_test.*`) - filters files using `rg --glob=<glob>`
--- - `--glob=<glob>` (e.g. `--glob=*.lua`) - filters files using ripgrep glob
--- - `case:yes` / `case:no` or `-s` / `-i` - forces case sensitivity or insensitivity
---
---@param opts? FullLiveGrepOpts Configuration options matching `telescope.builtin.live_grep`
M.full_live_grep = function(opts)
  opts = opts or {}
  local vimgrep_arguments = opts.vimgrep_arguments or conf.vimgrep_arguments
  if not has_rg_program("full_live_grep", vimgrep_arguments[1]) then
    return
  end
  opts.cwd = opts.cwd and utils.path_expand(opts.cwd) or vim.loop.cwd()

  local additional_args = {}
  if opts.additional_args ~= nil then
    if type(opts.additional_args) == "function" then
      additional_args = opts.additional_args(opts)
    elseif type(opts.additional_args) == "table" then
      additional_args = opts.additional_args
    end
  end

  if opts.type_filter then
    additional_args[#additional_args + 1] = "--type=" .. opts.type_filter
  end

  if type(opts.glob_pattern) == "string" then
    additional_args[#additional_args + 1] = "--glob=" .. opts.glob_pattern
  elseif type(opts.glob_pattern) == "table" then
    for i = 1, #opts.glob_pattern do
      additional_args[#additional_args + 1] = "--glob=" .. opts.glob_pattern[i]
    end
  end

  local args = utils.flatten({ vimgrep_arguments, additional_args })

  -- Pre-compute and expand search paths ONCE outside of the per-keystroke job
  local search_list = {}
  if opts.grep_open_files then
    search_list = get_open_filelist(opts.cwd)
    if #search_list == 0 then
      utils.notify("full_live_grep", {
        msg = "No open buffers to grep",
        level = "WARN",
      })
      return
    end
  elseif opts.search_dirs then
    for i, path in ipairs(opts.search_dirs) do
      opts.search_dirs[i] = utils.path_expand(path)
    end
    search_list = opts.search_dirs
  end

  local full_live_grepper = finders.new_job(
    function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local parsed_args = {}
      local unmatched_words = {}

      for word in string.gmatch(prompt, "%S+") do
        local matched = false

        -- Match 'lang:<lang>' (e.g. lang:proto, lang:bzl, lang:python)
        local lang = word:match("^lang:([%w_+-]+)$")
        if lang then
          local t = type_aliases[lang:lower()] or lang
          table.insert(parsed_args, "--type=" .. t)
          matched = true
        end

        -- Match '--type=<type>'
        local type_arg = word:match("^%-%-type=([%w_+-]+)$")
        if type_arg then
          local t = type_aliases[type_arg:lower()] or type_arg
          table.insert(parsed_args, "--type=" .. t)
          matched = true
        end

        -- Match 'f:<glob>' or 'file:<glob>' (e.g. f:BUILD, f:*.proto, file:*_test.*)
        local file_glob = word:match("^f:(%S+)$") or word:match("^file:(%S+)$")
        if file_glob then
          table.insert(parsed_args, "--glob=" .. file_glob)
          matched = true
        end

        -- Match '--glob=<glob>'
        local glob_arg = word:match("^%-%-glob=(%S+)$")
        if glob_arg then
          table.insert(parsed_args, "--glob=" .. glob_arg)
          matched = true
        end

        -- Match case sensitivity switches
        if word == "case:yes" or word == "case:y" or word == "-s" then
          table.insert(parsed_args, "--case-sensitive")
          matched = true
        elseif word == "case:no" or word == "case:n" or word == "-i" then
          table.insert(parsed_args, "--ignore-case")
          matched = true
        end

        if not matched then
          table.insert(unmatched_words, word)
        end
      end

      local parsed_prompt = table.concat(unmatched_words, " ")

      -- If the user only typed filter tokens (e.g. 'lang:python '), do not execute
      -- an empty grep that would match every single line in the codebase.
      if parsed_prompt == "" then
        return nil
      end

      return utils.flatten({
        args,
        parsed_args,
        "--",
        parsed_prompt,
        search_list,
      })
    end,
    opts.entry_maker or make_entry.gen_from_vimgrep(opts),
    opts.max_results,
    opts.cwd
  )

  pickers
    .new(opts, {
      prompt_title = "Live Grep",
      finder = full_live_grepper,
      previewer = conf.grep_previewer(opts),
      sorter = sorters.highlighter_only(opts),
      push_cursor_on_edit = true,
    })
    :find()
end

return M
