return {
  {
    "mrjones2014/smart-splits.nvim",
    -- Load eagerly so the IS_NVIM user variable is set for wezterm detection
    lazy = false,
    opts = {},
    keys = {
      -- Navigation (Ctrl+h/j/k/l — same keys vim-tmux-navigator used)
      -- smart-splits auto-detects whether it's running inside tmux or wezterm
      -- and delegates pane navigation to the correct multiplexer.
      { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Navigate left" },
      { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Navigate down" },
      { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Navigate up" },
      { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Navigate right" },
    },
  },
}
