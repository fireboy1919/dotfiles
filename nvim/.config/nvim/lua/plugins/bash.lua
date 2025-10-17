return {
  -- Bash syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "bash" })
      end
    end,
  },

  -- LSP support for Bash
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          settings = {
            bashIde = {
              globPattern = "**/*@(.sh|.inc|.bash|.command)",
            },
          },
        },
      },
    },
  },

  -- Additional shell script file associations
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.filetype.add({
        extension = {
          sh = "sh",
          bash = "sh",
          zsh = "sh",
        },
        filename = {
          [".bashrc"] = "sh",
          [".bash_profile"] = "sh",
          [".bash_login"] = "sh",
          [".bash_logout"] = "sh",
          [".zshrc"] = "sh",
          [".zprofile"] = "sh",
          [".zshenv"] = "sh",
        },
      })
    end,
  },
}