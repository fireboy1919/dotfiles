return {
  -- Gradle syntax highlighting and filetype detection
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "groovy" })
      end
    end,
  },

  -- Remove groovyls since it's unreliable, rely on treesitter for syntax highlighting

  -- File associations for Gradle files
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.filetype.add({
        filename = {
          ["build.gradle"] = "groovy",
          ["build.gradle.kts"] = "kotlin",
          ["settings.gradle"] = "groovy",
          ["settings.gradle.kts"] = "kotlin",
        },
        pattern = {
          [".*%.gradle"] = "groovy",
          [".*%.gradle%.kts"] = "kotlin",
        },
      })
    end,
  },
}