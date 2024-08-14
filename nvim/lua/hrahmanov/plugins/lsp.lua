return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
		"windwp/nvim-autopairs",
		"windwp/nvim-ts-autotag",
		"rafamadriz/friendly-snippets",
	},

	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)
		local function on_attach(client, bufnr) -- function(client, bufnr)
			-- show / edit actions
			local opts = { noremap = true, silent = true, buffer = bufnr }
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
			vim.keymap.set("n", "[e", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "]e", vim.diagnostic.goto_next)
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
			vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
			vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
			vim.keymap.set("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, opts)
			vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "<leader>gf", function()
				vim.lsp.buf.format({ async = true })
			end, opts)

			vim.api.nvim_create_autocmd("CursorHold", {
				buffer = bufnr,
				callback = function()
					local diagnostics_opts = {
						focusable = false,
						close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
						border = "rounded",
						source = "always", -- show source in diagnostic popup window
						prefix = " ",
					}
					vim.diagnostic.open_float(nil, diagnostics_opts)
				end,
			})

			-- Set autocommands conditional on server_capabilities
			if client.server_capabilities.documentHighlightProvider then
				vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true, bold = true })
				vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true })
				vim.api.nvim_set_hl(0, "LspReferenceWrite", { reverse = true })
				local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
				vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
				vim.api.nvim_create_autocmd(
					"CursorHold",
					{ group = group, buffer = bufnr, callback = vim.lsp.buf.document_highlight }
				)
				vim.api.nvim_create_autocmd(
					"CursorMoved",
					{ group = group, buffer = bufnr, callback = vim.lsp.buf.clear_references }
				)
			end
		end

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		require("nvim-autopairs").setup({})
		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"gofumpt",
				"gopls",
				"goimports",
				"terraformls",
				"tflint",
				"yamlls",
				"ansiblels",
				"bashls",
				"dockerls",
				"helm_ls",
				"jinja_lsp",
				"taplo",
			},
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,

				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim", "it", "describe", "before_each", "after_each" },
								},
							},
						},
					})
				end,
				["terraformls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.terraformls.setup({

						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,
				["gopls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.gopls.setup({

						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,
				["yamlls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.yamlls.setup({

						on_attach = on_attach,
						capabilities = require("cmp_nvim_lsp").default_capabilities(
							vim.lsp.protocol.make_client_capabilities()
						),
						settings = {
							yaml = {
								schemaStore = {
									enable = true,
									url = "https://www.schemastore.org/api/json/catalog.json",
								},
								schemas = {
									kubernetes = "*.yaml",
									["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
									["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
									["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = "azure-pipelines.{yml,yaml}",
									["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/tasks"] = "roles/tasks/*.{yml,yaml}",
									["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook"] = "*play*.{yml,yaml}",
									["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
									["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
									["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
									["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
									["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*gitlab-ci*.{yml,yaml}",
									["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
									["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
									["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
								},
								format = { enabled = false },
								-- anabling this conflicts between Kubernetes resources and kustomization.yaml and Helmreleases
								-- see utils.custom_lsp_attach() for the workaround
								-- how can I detect Kubernetes ONLY yaml files? (no CRDs, Helmreleases, etc.)
								validate = false,
								completion = true,
								hover = true,
							},
						},
					})
				end,
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }
		require("luasnip.loaders.from_vscode").lazy_load()
		local ls = require("luasnip")
		cmp.setup({
			snippet = {
				expand = function(args)
					ls.lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-d>"] = cmp.mapping.scroll_docs(4), -- scroll up preview
				["<C-l>"] = cmp.mapping.scroll_docs(-4), -- scroll down preview
				["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-y>"] = cmp.mapping.select_next_item(cmp_select),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
			}),
			sources = cmp.config.sources({
				{ name = "codeium" }, -- snippets
				{ name = "luasnip" }, -- snippets
				{ name = "nvim_lsp" },
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
			}),

			vim.diagnostic.config({
				-- update_in_insert = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			}),
			-- Global mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
		})

		vim.keymap.set({ "i", "s" }, "<c-k>", function()
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
			end
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<c-j>", function()
			if ls.jumpable(-1) then
				ls.jump(-1)
			end
		end, { silent = true })
	end,
}
