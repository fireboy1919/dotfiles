-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set leader key to "."
vim.g.mapleader = "."
vim.g.maplocalleader = "."

-- System clipboard integration
vim.opt.clipboard = "unnamedplus"

-- Auto change directory to project root
vim.opt.autochdir = false -- Don't auto change to file directory
vim.opt.autowrite = true -- Auto save when switching buffers

-- Configure LazyVim root detection (prioritize Gradle over git)
vim.g.root_spec = {
  {
    -- Gradle/Maven first
    "build.gradle.kts",
    "build.gradle",
    "settings.gradle.kts",
    "settings.gradle",
    "pom.xml",
    -- Bazel workspace markers
    "WORKSPACE",
    "WORKSPACE.bazel",
    "MODULE.bazel",
  },
  { ".git", "lua" },
  "cwd"
}
