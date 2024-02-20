-- Basic tab settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

--------------------------------------------------------------------------------
-- Theme
--------------------------------------------------------------------------------

vim.cmd.colorscheme("onedark")

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

--------------------------------------------------------------------------------
-- Aids
--------------------------------------------------------------------------------

-- show cursor position
vim.o.cursorline = true
--vim.o.cursorcolumn = true

-- enable mouse
vim.o.mouse = "a"

-- highlight preferable wrapping columns
vim.opt.colorcolumn = { 81, 161, 241, 321, 401, 481, 561, 641, 721, 801 }

-- show current line number and use relative numbering
vim.wo.number = true
vim.wo.relativenumber = true

-- show signcolumn by default
vim.wo.signcolumn = "yes"

-- Enable break indent
vim.o.breakindent = true

-- highlight search
vim.o.hlsearch = true

-- case insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Set completeopt to enable a better completion experience
vim.o.completeopt = "menuone,noselect"

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

--------------------------------------------------------------------------------
-- File saving and history
--------------------------------------------------------------------------------

vim.o.undofile = true

--------------------------------------------------------------------------------
-- Clipboard
--------------------------------------------------------------------------------

vim.o.clipboard = "unnamedplus"