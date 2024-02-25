return {
  "tpope/vim-sleuth", -- tab settings detection
  {
    -- Add indentation guides even on blank lines (`:help ibl`)
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
  {
    -- Quickly comment line or selection
    "numToStr/Comment.nvim",
    opts = {},
  },
  {
    "NvChad/nvim-colorizer.lua",
    main = "colorizer",
    opts = {
      user_default_options = {
        mode = "virtualtext",
      },
    },
  },
  {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- cmp
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",

      -- -- Adds a number of user-friendly snippets
      -- "rafamadriz/friendly-snippets",
      --
      -- -- Adds vscode-like pictograms
      -- "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local luasnip_loaders_from_vscode = require("luasnip.loaders.from_vscode")

      luasnip_loaders_from_vscode.lazy_load()
      luasnip.config.setup()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        enabled = false,
        completion = {
          completeopt = "menu,menuone,noinsert,noselect",
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        preselect = "None",
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-5),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete({}),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            -- select = false,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          {
            name = "nvim_lsp",
            -- Filter out all "Text" completion items from LSP
            entry_filter = function(entry)
              return cmp.lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
            end,
          },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })

      local function auto_cmp_toggle()
        local enabled = cmp.get_config().enabled
        if enabled then
          cmp.setup({ enabled = false })
          vim.notify("Autocomplete disabled")
        else
          cmp.setup({ enabled = true })
          vim.notify("Autocomplete enabled")
        end
      end
      vim.api.nvim_create_user_command("AutoCmpToggle", auto_cmp_toggle, {})
    end,
  },
}
