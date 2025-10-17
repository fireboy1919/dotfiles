return {
  -- Bazel syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "starlark" })
      end
    end,
  },

  -- File associations for Bazel files
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.filetype.add({
        filename = {
          ["BUILD"] = "bzl",
          ["BUILD.bazel"] = "bzl",
          ["WORKSPACE"] = "bzl",
          ["WORKSPACE.bazel"] = "bzl",
          [".bazelrc"] = "conf",
        },
        pattern = {
          [".*%.bzl"] = "bzl",
          [".*%.BUILD"] = "bzl",
        },
      })
    end,
  },

  -- Remove starlark_rust since it's unreliable, rely on treesitter for syntax highlighting
}