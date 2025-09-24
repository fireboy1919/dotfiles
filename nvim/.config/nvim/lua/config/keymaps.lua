-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Explorer
vim.keymap.set("n", "<F5>", "<leader>fe", { desc = "Explorer NeoTree (Root Dir)", remap = true })
