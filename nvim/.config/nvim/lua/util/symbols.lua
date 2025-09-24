local M = {}

function M.smart_workspace_symbols()
  local tb = require("telescope.builtin")
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  local has_workspace_symbols = false

  for _, c in ipairs(clients) do
    local caps = c.server_capabilities or {}
    if caps.workspaceSymbolProvider then
      has_workspace_symbols = true
      break
    end
  end

  if has_workspace_symbols then
    -- dynamic version queries as you type
    tb.lsp_dynamic_workspace_symbols()
  else
    vim.notify("LSP workspace symbols unavailable; falling back to ripgrep", vim.log.levels.INFO)
    tb.live_grep()
  end
end

return M

