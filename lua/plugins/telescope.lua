return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {"nvim-lua/plenary.nvim"},
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>sf", builtin.find_files, {})
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, {})

      -- https://www.reddit.com/r/neovim/comments/ypaq3e/lsp_find_reference_results_in_telescope/
      --vim.keymap.set("n", "<leader>gr", require("telescope.builtin").lsp_references, {noremap=true, silent=true})
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({})
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
}
