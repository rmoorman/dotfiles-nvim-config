return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = ":TSUpdate",
  config = function()
    local setup = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        -- install all available languages for less hassle
        -- install them automatically
        -- and install as many at once as possible
        ensure_installed = "all",
        ignore_install = {},
        auto_install = true,
        sync_install = false,

        -- enable highlighting and indenting based on treesitter
        highlight = { enable = true },
        indent = { enable = true },

        -- custom modules to use
        modules = {},

        -- incrementally extend visual selection based on grammar
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-Space>",
            node_incremental = "<C-Space>",
            scope_incremental = "<C-s>",
            node_decremental = "<C-Del>",
          },
        },

        -- textobjects
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- auto jump forward to text object similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
        -- swapping could be nice but the need for swapping parameters doesn't
        -- occur that often and when it does, it can be done with code actions
        -- swap = {
        --   enable = true,
        --   swap_next = {
        --     ["<leader>a"] = "@parameter.inner",
        --   },
        --   swap_previous = {
        --     ["<leader>A"] = "@parameter.inner",
        --   },
        -- },
      })
    end

    -- Defer setup until after the first render to improve startup time when
    -- editing a file directly (e.g. `nvim example_file.py`)
    vim.defer_fn(setup, 0)
  end,
}
