local M = {}

M.ensure_installed = { "sumneko_lua", "rust_analyzer", "pyright" }

M.setup_handlers = {
    ["rust_analyzer"] = function()
        local rt = require("rust-tools")
        rt.setup({
            on_attach = core.lsp.on_attach,
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
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

return M
