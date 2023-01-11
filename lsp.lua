local M = {}

M.ensure_installed = { "sumneko_lua", "rust_analyzer", "pyright" }

local codelldb_path = [[C:\Users\vivek\AppData\Local\nvim-data\mason\packages\codelldb\extension\adapter\codelldb.exe]]
local liblldb_path = [[C:\Users\vivek\AppData\Local\nvim-data\mason\packages\codelldb\extension\lldb\bin\liblldb.dll]]

M.setup_handlers = {
    ["rust_analyzer"] = function()
        local rt = require("rust-tools")
        rt.setup({
            tools = {
                hover_actions = {
                    border = {
                        { "╭", "LspSagaHoverBorder" },
                        { "─", "LspSagaHoverBorder" },
                        { "╮", "LspSagaHoverBorder" },
                        { "│", "LspSagaHoverBorder" },
                        { "╯", "LspSagaHoverBorder" },
                        { "─", "LspSagaHoverBorder" },
                        { "╰", "LspSagaHoverBorder" },
                        { "│", "LspSagaHoverBorder" },
                    },
                    auto_focus = true,
                },
            },
            server = {
                on_attach = function(client, bufnr)
                    core.lsp.on_attach(client, bufnr)
                    -- Hover actions
                    vim.keymap.set(
                        "n",
                        "<leader>lrh",
                        rt.hover_actions.hover_actions,
                        { buffer = bufnr, desc = "Rust tools hover actions" }
                    )
                    -- Code action groups
                    vim.keymap.set(
                        "n",
                        "<leader>la",
                        rt.code_action_group.code_action_group,
                        { buffer = bufnr, desc = "Rust tools code action group" }
                    )
                end,
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            },
            dap = {
                adapter = require("rust-tools.dap").get_codelldb_adapter(
                    codelldb_path,
                    liblldb_path
                ),
            },
        })
    end,
    ["sumneko_lua"] = function()
        require("lspconfig")["sumneko_lua"].setup({
            on_attach = function(client, bufnr)
                core.lsp.on_attach(client, bufnr)
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentFormattingRangeProvider = false
            end,
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                    runtime = {
                        version = "LuaJIT",
                        path = vim.split(package.path, ";"),
                    },
                    workspace = {
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                        },
                    },
                },
            },
        })
    end,
}

M.system_lsps = {}

M.null_ls_sources = {
    sources = {},
}

return M
