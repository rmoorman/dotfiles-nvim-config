return {
  "tpope/vim-eunuch", -- FS utils (e.g. rename files)
  {
    -- Replacement for netrw
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    -- Filetree
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  { "folke/which-key.nvim", opts = {} },
  { "akinsho/toggleterm.nvim", opts = {} },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- {
  --   "rebelot/terminal.nvim",
  --   opts = {},
  -- },
}
