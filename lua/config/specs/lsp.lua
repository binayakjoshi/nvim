-- lua/config/plugins/lsp.lua

return {
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "ts_ls", "lua_ls", "pyright" },
			})

			-- Shared on_attach: keymaps + disable ts_ls formatting (conform handles it)
			local on_attach = function(client, bufnr)
				if client.name == "ts_ls" then
					client.server_capabilities.documentFormattingProvider = false
				end

				local map = function(mode, lhs, rhs)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
				end

				map("n", "gd", vim.lsp.buf.definition)
				map("n", "k", vim.lsp.buf.hover)
				map("n", "<leader>rn", vim.lsp.buf.rename)
			end

			-- Capabilities enhanced with nvim-cmp
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if ok then
				capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
			end

			-- TypeScript / JavaScript LSP
			vim.lsp.config("ts_ls", {
				cmd = { "typescript-language-server", "--stdio" },
				root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
				on_attach = on_attach,
				capabilities = capabilities,
				single_file_support = false,
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "none",
							includeInlayVariableTypeHints = false,
						},
					},
				},
			})
			vim.lsp.enable("ts_ls")

			vim.lsp.config("pyright", {
				cmd = { "pyright-langserver", "--stdio" },
				root_markers = {
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"pyrightconfig.json",
				},
				filetypes = { "python" },
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
						},
					},
				},
				on_attach = on_attach,
				capabilities = capabilities,
			})
			vim.lsp.enable("pyright")
		end,
	},
}
