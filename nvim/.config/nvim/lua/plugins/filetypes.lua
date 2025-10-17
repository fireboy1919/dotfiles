return {
  {
    -- Ensure Kotlin files get the correct filetype
    "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.filetype.add({
        extension = {
          kt = "kotlin",
          kts = "kotlin",
        },
      })
    end,
  },
}

