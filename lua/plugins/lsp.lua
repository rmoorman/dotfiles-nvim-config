-- FIXME: mason needs `gh` (github cli) installed for fetching it's module index
--
-- ## WHY?
--
-- Probably related to a bug in `mason-core/managers/github/client.lua`
-- around line 24, as `:MasonLog` shows errors like this:
--
-- [ERROR Tue 13 Feb 2024 07:56:00 PM CET] ...el/lazy/mason.nvim/lua/mason-registry/sources/github.lua:146: Failed to install registry GitHubRegistrySource(repo=mason-org/mason-registry). "Failed to fetch latest registry version from GitHub API."
-- [ERROR Tue 13 Feb 2024 07:56:05 PM CET] ...gepiel/lazy/mason.nvim/lua/mason-core/providers/init.lua:80: Provider "github" "get_latest_release" failed: "Expected the end but found invalid token at character 998"
-- [ERROR Tue 13 Feb 2024 07:56:05 PM CET] ...gepiel/lazy/mason.nvim/lua/mason-core/providers/init.lua:80: Provider "github" "get_latest_release" failed: "Expected the end but found invalid token at character 5038"
-- [ERROR Tue 13 Feb 2024 07:56:05 PM CET] ...gepiel/lazy/mason.nvim/lua/mason-core/providers/init.lua:91: No provider implementation succeeded for github.get_latest_release
--
-- ## Install GH CLIsee:
--
-- <https://github.com/cli/cli/blob/trunk/docs/install_linux.md> might need
-- a little tweaking as seen in
-- <https://github.com/cli/cli/discussions/6222#discussioncomment-3840641>,
-- like:
-- ```
-- sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 23F3D4EA75716059
-- ```
-- and not adding a custom key file for signing

return {
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  "nvimtools/none-ls.nvim", -- Tools integration via LSP (e.g. formatting)
  { "j-hui/fidget.nvim", opts = {} }, -- LSP status notifications
  "folke/neodev.nvim", -- nvim lua config integration
  {
    "neovim/nvim-lspconfig",
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local mason_tool_installer = require("mason-tool-installer")
      local lspconfig = require("lspconfig")
      local null_ls = require("null-ls")
      local neodev = require("neodev")

      local specs = {
        -- lua
        {
          install = { "lua_ls", "stylua" },
          lsp = {
            lua_ls = {},
            --lua_ls = {
            --  settings = {
            --    Lua = {
            --      diagnostics = { globals = { "vim" } },
            --      workspace = {
            --        -- pull in all of 'runtimepath'. NOTE: this is a lot slower
            --        library = vim.api.nvim_get_runtime_file("", true),
            --        -- or pull in only specific paths manually
            --        -- library = {
            --        --   vim.env.VIMRUNTIME
            --        --   -- "${3rd}/luv/library"
            --        --   -- "${3rd}/busted/library",
            --        -- }
            --        -- checkThirdParty = false,
            --      },
            --    },
            --  },
            --},
          },
          null_ls = { null_ls.builtins.formatting.stylua },
        },
        -- elixir
        {
          install = { "elixirls" },
          lsp = { elixirls = {} },
        },
        -- golang
        {
          install = { "gopls" },
          lsp = { gopls = {} },
        },
        -- python
        {
          install = { "pyright", "black" },
          lsp = { pyright = {} },
          null_ls = { null_ls.builtins.formatting.black },
        },
        -- js/ts
        {
          install = { "tsserver" },
          lsp = { tsserver = {} },
        },
        -- ansible
        {
          install = { "ansiblels" },
          lsp = { ansiblels = {} },
        },
        -- other null ls sources
        {
          null_ls = {
            null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.completion.spell,
            null_ls.builtins.code_actions.gitsigns,
          },
        },
      }

      neodev.setup()
      mason.setup()
      mason_lspconfig.setup()

      -- Install lsps and tools based on spec
      local mason_tool_installables = {}
      for _, spec in pairs(specs) do
        for _, id in pairs(spec.install or {}) do
          table.insert(mason_tool_installables, id)
        end
      end
      mason_tool_installer.setup({
        ensure_installed = mason_tool_installables,
      })

      -- Setup lsps based on spec
      local lspconfig_setups = {}
      for _, spec in pairs(specs) do
        for lsp_name, lsp_opts in pairs(spec.lsp or {}) do
          local lsp_settings = lsp_opts.settings or {}
          lspconfig_setups[lsp_name] = { settings = lsp_settings }
        end
      end
      for key, setup in pairs(lspconfig_setups) do
        lspconfig[key].setup(setup)
      end

      -- Setup null ls based on spec
      local null_ls_sources = {}
      for _, spec in pairs(specs) do
        for _, null_ls_source in pairs(spec.null_ls or {}) do
          table.insert(null_ls_sources, null_ls_source)
        end
      end
      null_ls.setup({ sources = null_ls_sources })
    end,
  },
}
