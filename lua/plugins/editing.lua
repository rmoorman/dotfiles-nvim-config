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
}
