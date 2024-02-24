return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    opts = {
      style = "warmer",
    },
  },
  { "morhetz/gruvbox" },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = false,
        component_separators = "|",
        section_separators = "",
      },
    },
  },
}
