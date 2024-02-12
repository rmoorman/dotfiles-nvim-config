return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "warmer",
      })
      vim.cmd.colorscheme("onedark")
    end
  },
}
