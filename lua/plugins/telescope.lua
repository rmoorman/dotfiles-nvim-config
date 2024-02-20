return {
  "nvim-telescope/telescope-ui-select.nvim",
  {
    -- More optimal fuzzy finder algorithm (requires build step and tools)
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = function()
      return vim.fn.executable("make") == 1
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      local telescope_themes = require("telescope.themes")

      telescope.setup({
        extensions = {
          ["ui-select"] = {
            telescope_themes.get_dropdown({}),
          },
        }
      })

      telescope.load_extension("ui-select")
      telescope.load_extension("fzf")
    end,
  },
}
