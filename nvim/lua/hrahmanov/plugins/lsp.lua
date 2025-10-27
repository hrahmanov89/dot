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
  },

  config = function()
    require("mason").setup()

    local ensure_installed = {
      "lua_ls",
      "gopls",
      "helm_ls",
      "yamlls",
      "dockerls",
      "ansiblels",
      "bashls",
      "jinja_lsp",
      "python_lsp_server",
      "black",
    }
    require("mason-lspconfig").setup({
      ensure_installed = ensure_installed,
    })

    for _, ei in ipairs(ensure_installed) do
      vim.lsp.enable(ei)
    end

    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = 'Lsp: ' .. desc })
        end

        local tele = require("telescope.builtin")
        map('gd', tele.lsp_definitions, 'Goto Definition')
        map('<leader>gs', tele.lsp_document_symbols, 'Doc Symbols')
        map('<leader>gS', tele.lsp_dynamic_workspace_symbols, 'Dynamic Symbols')
        map('<leader>gt', tele.lsp_type_definitions, 'Goto Type')
        map('<leader>gr', tele.lsp_references, 'Goto References')
        map('<leader>gi', tele.lsp_implementations, 'Goto Impl')

        map('K', vim.lsp.buf.hover, 'hover')
        map('<leader>E', vim.diagnostic.open_float, 'diagnostic')
        map('<leader>k', vim.lsp.buf.signature_help, 'sig help')
        map('<leader>rn', vim.lsp.buf.rename, 'rename')
        map('<leader>ca', vim.lsp.buf.code_action, 'code action')
        map('<leader>wf', vim.lsp.buf.format, 'format')

        vim.keymap.set('v',
          '<leader>ca',
          vim.lsp.buf.code_action, { buffer = ev.buf, desc = 'Lsp: code_action' })
      end,
    })
    require("nvim-autopairs").setup({})
    require("fidget").setup({})
    require("mason").setup()

    local cmp = require("cmp")
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    local ls = require("luasnip")
    cmp.setup({
      snippet = {
        expand = function(args)
          ls.lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(4),  -- scroll up preview
        ["<C-l>"] = cmp.mapping.scroll_docs(-4), -- scroll down preview
        ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-y>"] = cmp.mapping.select_next_item(cmp_select),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
      }),
      sources = cmp.config.sources({
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "buffer" }, -- text within current buffer
        { name = "path" },   -- file system paths
      }),

      vim.diagnostic.config({
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      }),
    })
    vim.diagnostic.config({
      virtual_text = {
        prefix = "", -- Customize the prefix icon for diagnostics
        spacing = 4, -- Space between icon and text
        source = "always", -- Always show the source in the diagnostic popup
      },
      float = {
        focusable = true,   -- Make float focusable for interaction
        style = "minimal",  -- Style for minimalistic float
        border = "rounded", -- Rounded border
        source = "always",  -- Always show the source in the popup
        header = "",        -- Optionally add a header for the float
        prefix = "",        -- Optionally adjust the prefix if no icon is desired
      },
    })
    -- local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    -- for type, icon in pairs(signs) do
    --   local hl = "DiagnosticSign" .. type
    --   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    -- end
  end,
}
