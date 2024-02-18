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
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "elixirls",
          "gopls",
          "pyright",
          "tsserver",
          "ansiblels",
        }
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = {
                "vim",
              },
            },
            workspace = {
              -- pull in all of 'runtimepath'. NOTE: this is a lot slower
              library = vim.api.nvim_get_runtime_file("", true),
              -- or pull in only specific paths manually
              -- library = {
              --   vim.env.VIMRUNTIME
              --   -- "${3rd}/luv/library"
              --   -- "${3rd}/busted/library",
              -- }
              -- checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })
      lspconfig.elixirls.setup({})
      lspconfig.gopls.setup({})
      lspconfig.pyright.setup({})
      lspconfig.tsserver.setup({})
      lspconfig.ansiblels.setup({})

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
      })
    end
  },
}
