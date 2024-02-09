-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic tab settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")



-- Make sure lazy package manager is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)



-- Setup packages
local plugins = {
  {"catppuccin/nvim", name = "catppuccin", priority = 1000},
  {"navarasu/onedark.nvim", priority = 1000 },
  {"nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = {"nvim-lua/plenary.nvim"}},
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  {"nvim-tree/nvim-tree.lua", version="*", lazy = false, dependencies = {"nvim-tree/nvim-web-devicons"}},
}
local opts = {}
require("lazy").setup(plugins, opts)

--- theme
-- require("catppuccin").setup()
-- vim.cmd.colorscheme("catppuccin")
require("onedark").setup({ style = "warmer" })
vim.cmd.colorscheme("onedark")

--- telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

--- treesitter
local config = require("nvim-treesitter.configs")
config.setup({
  ensure_installed = "all",
  highlight = { enable = true },
  indent = { enable = true },
})


--- nvim-tree
require("nvim-tree").setup()
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", {})
