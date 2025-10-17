return {
  -- Override LazyVim kotlin extra to use official kotlin-lsp instead of kotlin_language_server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable kotlin_language_server from LazyVim extra
        kotlin_language_server = false,
        -- Enable official kotlin-lsp
        kotlin_lsp = {
          on_attach = function(client, bufnr)
            -- Debug: Write client info to file
            local debug_file = io.open("/tmp/kotlin_lsp_debug.log", "a")
            if debug_file then
              debug_file:write("=== KOTLIN LSP ATTACHED ===\n")
              debug_file:write("Time: " .. os.date() .. "\n")
              debug_file:write("File: " .. vim.api.nvim_buf_get_name(bufnr) .. "\n")
              debug_file:write("Client name: " .. client.name .. "\n")
              debug_file:write("Root dir: " .. (client.root_dir or "nil") .. "\n")
              debug_file:write("Capabilities: " .. vim.inspect({
                definitionProvider = client.server_capabilities.definitionProvider,
                referencesProvider = client.server_capabilities.referencesProvider,
                workspaceSymbolProvider = client.server_capabilities.workspaceSymbolProvider,
                implementationProvider = client.server_capabilities.implementationProvider,
              }) .. "\n")
              debug_file:write("===========================\n")
              debug_file:close()
            end

            -- Custom Telescope workspace symbols with symbol name first
            local function telescope_workspace_symbols(class_only)
              local pickers = require("telescope.pickers")
              local finders = require("telescope.finders")
              local conf = require("telescope.config").values

              local params = { query = "" }
              vim.lsp.buf_request(0, "workspace/symbol", params, function(err, result)
                if err or not result then return end

                local symbols = {}
                for _, symbol in ipairs(result) do
                  -- Filter for classes if requested
                  if not class_only or (symbol.kind >= 5 and symbol.kind <= 11) then
                    table.insert(symbols, symbol)
                  end
                end

                pickers.new({}, {
                  prompt_title = class_only and "Workspace Classes" or "Workspace Symbols",
                  finder = finders.new_table {
                    results = symbols,
                    entry_maker = function(symbol)
                      local filename = vim.uri_to_fname(symbol.location.uri)
                      local short_filename = vim.fn.fnamemodify(filename, ":t")
                      local package_name = symbol.containerName or ""

                      return {
                        value = symbol,
                        display = string.format("%-18s  %-25s  %s", symbol.name, short_filename, package_name),
                        ordinal = symbol.name,
                        filename = filename,
                        lnum = symbol.location.range.start.line + 1,
                        col = symbol.location.range.start.character + 1,
                      }
                    end,
                  },
                  sorter = conf.generic_sorter({}),
                  previewer = conf.file_previewer({}),
                }):find()
              end)
            end

            vim.keymap.set("n", "<leader>sS", function()
              telescope_workspace_symbols(false)
            end, { buffer = bufnr, desc = "Workspace Symbols" })

            vim.keymap.set("n", "<leader>sC", function()
              telescope_workspace_symbols(true)
            end, { buffer = bufnr, desc = "Workspace Classes" })

            -- Add debug command to test references manually
            vim.keymap.set("n", "<leader>dr", function()
              local params = vim.lsp.util.make_position_params()
              params.context = { includeDeclaration = true }

              local results = vim.lsp.buf_request_sync(bufnr, "textDocument/references", params, 5000)

              local debug_file2 = io.open("/tmp/kotlin_lsp_debug.log", "a")
              if debug_file2 then
                debug_file2:write("=== REFERENCES DEBUG ===\n")
                debug_file2:write("Time: " .. os.date() .. "\n")
                debug_file2:write("File: " .. vim.api.nvim_buf_get_name(bufnr) .. "\n")
                debug_file2:write("Position: " .. vim.inspect(params.position) .. "\n")
                debug_file2:write("Results: " .. vim.inspect(results) .. "\n")
                debug_file2:write("========================\n")
                debug_file2:close()
              end
            end, { buffer = bufnr, desc = "Debug References" })
          end,
        },
      },
    },
  },
}
