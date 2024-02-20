return {
  "tpope/vim-fugitive", -- vim git client tools
  {
    -- Add git related signs to gutter and support utilities
    -- for managing changes through things like code actions
    "lewis6991/gitsigns.nvim",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
}
