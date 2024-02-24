return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      {
        -- More optimal fuzzy finder algorithm (requires build step and tools)
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    config = function()
      local telescope = require("telescope")
      local telescope_builtin = require("telescope.builtin")
      local telescope_themes = require("telescope.themes")
      local utils = require("config.utils")

      telescope.setup({
        extensions = {
          ["ui-select"] = {
            telescope_themes.get_dropdown({}),
          },
        },
      })

      telescope.load_extension("ui-select")
      telescope.load_extension("fzf")

      local function live_grep_git_root()
        local git_root = utils.find_git_root()
        telescope_builtin.live_grep({ search_dirs = { git_root } })
      end
      vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

      local function live_grep_open_files()
        telescope_builtin.live_grep({ grep_open_files = true, prompt_title = "live grep open files" })
      end
      vim.api.nvim_create_user_command("LiveGrepOpenFiles", live_grep_open_files, {})

      local function fuzzy_find_current_buffer()
        telescope_builtin.current_buffer_fuzzy_find(telescope_themes.get_dropdown({ winblend = 10, previewer = false }))
      end
      vim.api.nvim_create_user_command("FuzzyFindCurrentBuffer", fuzzy_find_current_buffer, {})
    end,
  },
}
