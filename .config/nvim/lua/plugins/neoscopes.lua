return {
  "smartpde/neoscopes",
  lazy = true,
  keys = {
    {
      "<Leader>ss",
      '<Cmd>lua require("neoscopes").select()<CR>',
      desc = "[S]elect [s]cope",
      mode = "n",
    },
  },
  opts = function(_, opts)
    opts.scopes = opts.scopes or {}
    table.insert(opts.scopes, {
      name = "Neovim Config Dev",
      dirs = {
        "~/.config/nvim",
      },
    })
    table.insert(opts.scopes, {
      name = "Obsidian Vaults",
      dirs = {
        "~/Obsidian",
      },
    })
    table.insert(opts.scopes, {
      name = "Brain RAM Vault",
      dirs = {
        "~/Obsidian/brain_ram",
      },
    })
    table.insert(opts.scopes, {
      name = "Project Austin",
      dirs = {
        "~/austin",
      },
    })
    table.insert(opts.scopes, {
      name = "Bears Baseball V2",
      dirs = {
        "~/Documents/BearsBaseballV2",
      },
    })
  end,
  config = function(_, opts)
    local neoscopes = require("neoscopes")
    neoscopes.add_startup_scope()

    for _, scope in ipairs(opts.scopes) do
      neoscopes.add(scope)
    end
  end,
}
