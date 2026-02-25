return {
  -- Suppress noice.nvim treesitter "Invalid node type 'tab'" errors
  {
    "folke/noice.nvim",
    opts = {
      routes = {
        {
          filter = { event = "notify", find = "Invalid node type" },
          opts = { skip = true },
        },
      },
    },
  },
  -- Disable GitUI extra plugin and keybindings
  {
    "mason-org/mason.nvim",
    optional = true,
    keys = {
      { "<leader>gg", false },
      { "<leader>gG", false },
    },
  },
}