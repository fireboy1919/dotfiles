return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- Language servers
        "lua-language-server",
        "typescript-language-server",
        "pyright",
        "bash-language-server",
        -- Formatters
        "prettier",
        "black",
        "google-java-format",
        -- Linters
        "eslint_d",
        "flake8",
      },
      -- Mason settings
      ui = {
        border = "rounded",
      },
      -- Increase timeout for installations
      max_concurrent_installers = 4,
    },
  },
  -- DAP integration with Mason
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        "debugpy",
      },
      automatic_installation = true,
      handlers = {},
    },
  },
}