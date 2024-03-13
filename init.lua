--------------------------------------------------------------------------------
-- Set the leader key
--------------------------------------------------------------------------------
-- Set <space> as the leader key
-- NOTE: Must be setbefore plugins are loaded (or wrong leader might get used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

-- Basic tab settings
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- Decrease update time (amount of ms after which editing is assumed to be a
-- little idle and the swap file can be written for recovery; some other
-- functionaly may use the related CursorHold event as well)
vim.o.updatetime = 250

-- time to wait for mappings to be completed in ms
vim.o.timeoutlen = 300

-- time to wait for mappings to be completed in ms
vim.o.timeoutlen = 300

-- track undo state
vim.o.undofile = true

-- integrate with the regular clipboard
vim.o.clipboard = "unnamedplus"

-- Enable more colors
-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

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

-- Highlight on yank
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- Don't create a new comment line automatically when pressing enter
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

local colorscheme = "onedark"

--------------------------------------------------------------------------------
-- Load package manager and plugins
--------------------------------------------------------------------------------

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
local lazy_specs = "plugins"
local lazy_opts = {
  install = { colorscheme = { colorscheme } },
  ui = { border = "rounded" },
}
require("lazy").setup(lazy_specs, lazy_opts)

-- Set the colorscheme
vim.cmd.colorscheme(colorscheme)

--------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------

local telescope_builtin = require("telescope.builtin")
-- local which_key = require("which-key")
local utils = require("config.utils")

local map = vim.keymap.set

-- Don't move cursor when using space in normal or visual selection mode
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- In file search hightlighting control
map("n", "<leader>hs", ":set hlsearch! hlsearch?<CR>", { silent = true, desc = "toggle search highlight" })
map("n", "<leader>hc", ":noh<CR>", { silent = true, desc = "clear search hightlight" })

-- Exit insert mode from the home row without reaching for escape
map("i", "jj", "<Esc>", { noremap = true })
map("i", "jk", "<Esc>", { noremap = true })

-- Fast saving
map("n", "<leader>w", ":write!<CR>", {})
map("n", "<leader>q", ":q!<CR>", {})

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", {})
map("n", "<C-u>", "<C-u>zz", {})

-- Move selected line / block of text in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", {})
map("v", "K", ":m '<-2<CR>gv=gv", {})

-- Better visual mode multi line indenting behaviour when using < and >
map("v", "<", "<gv", {})
map("v", ">", ">gv", {})

-- Page over current selection without yanking
map("v", "p", '"_dp', {})
map("v", "P", '"_dP', {})

-- Move vertically between lines on screen rather than the lines in the file
map("n", "j", "gj", {})
map("n", "k", "gk", {})

-- Map enter to ciw in normal mode
map("n", "<CR>", "ciw", {})
map("n", "<BS>", "ci", {})

-- Navigate buffers
map("n", "<Right>", ":bnext<CR>", {})
map("n", "<Left>", ":bprevious<CR>", {})

-- Diagnostic keymaps
map("n", "[d", vim.diagnostic.goto_prev, { desc = "go to previous diagnostic message" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "go to next diagnostic message" })
map("n", "<leader>dm", vim.diagnostic.open_float, { desc = "open floating diagnostic message" })
map("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "open diagnostics list" })

-- Autocomplete
map("n", "<leader>a", ":AutoCmpToggle<CR>", { silent = true })

-- Special keymaps for buffers attached to an LSP
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- FIXME: check if all telescope_builtin calls are useful/usable
    local buf_opts = utils.curried_opts({ buffer = ev.buffer })

    -- info
    map("n", "K", vim.lsp.buf.hover, buf_opts({ desc = "hover docs" }))
    map("n", "<C-k>", vim.lsp.buf.signature_help, buf_opts({ desc = "signature docs" })) -- redundant??
    map("n", "<leader>D", telescope_builtin.lsp_type_definitions, buf_opts({ desc = "type definition" }))
    map("n", "<leader>ds", telescope_builtin.lsp_document_symbols, buf_opts({ desc = "document symbols" }))
    map("n", "<leader>ws", telescope_builtin.lsp_dynamic_workspace_symbols, buf_opts({ desc = "workspace symbols" }))

    -- goto
    --map("n", "<leader>gd", vim.lsp.buf.definition, buf_opts({ desc = "goto definition" }))

    map("n", "<leader>gd", function()
      telescope_builtin.lsp_definitions({ jump_type = "tab" })
    end, buf_opts({ desc = "goto definition" }))
    map("n", "<leader>gD", vim.lsp.buf.declaration, buf_opts({ desc = "goto declaration" }))
    map("n", "<leader>gi", function()
      telescope_builtin.lsp_implementations({ jump_type = "tab" })
    end, buf_opts({ desc = "goto implementation" }))
    map("n", "<leader>gr", telescope_builtin.lsp_references, buf_opts({ desc = "goto references" }))

    -- workspace management
    map("n", "<leader>gwa", vim.lsp.buf.add_workspace_folder, buf_opts({ desc = "add workspace folder" }))
    map("n", "<leader>gwr", vim.lsp.buf.remove_workspace_folder, buf_opts({ desc = "remove workspace folder" }))
    map("n", "<leader>gwl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, buf_opts({ desc = "list workspace folders" }))

    -- do
    map({ "n", "v" }, "<leader>gf", vim.lsp.buf.format, buf_opts({ desc = "code format" }))
    map({ "n", "v" }, "<leader>ga", vim.lsp.buf.code_action, buf_opts({ desc = "code action" }))
    map("n", "<leader>rn", vim.lsp.buf.rename, buf_opts({ desc = "rename" }))
  end,
})

-- File tree
map("n", "<leader>e", ":NvimTreeToggle<CR>", {})

-- Telescope searching
map("n", "<leader>/", ":FuzzyFindCurrentBuffer<CR>", { desc = "fuzzy find in current buffer" })
map("n", "<leader><space>", telescope_builtin.buffers, { desc = "find open buffers" })
map("n", "<leader>s/", ":LiveGrepOpenFiles<CR>", { desc = "grep open files" })
map("n", "<leader>?", telescope_builtin.oldfiles, { desc = "find recently opened files" })
map("n", "<leader>ss", telescope_builtin.builtin, { desc = "search telescope itself" })
map("n", "<leader>gf", telescope_builtin.git_files, { desc = "search git files" })
map("n", "<leader>sf", telescope_builtin.find_files, { desc = "find files" })
map("n", "<leader>sh", telescope_builtin.help_tags, { desc = "search help" })
map("n", "<leader>sw", telescope_builtin.grep_string, { desc = "grep for current word" })
map("n", "<leader>sg", telescope_builtin.live_grep, { desc = "grep cwd" })
map("n", "<leader>sG", ":LiveGrepGitRoot<CR>", { desc = "grep in git root" })
map("n", "<leader>sd", telescope_builtin.diagnostics, { desc = "search diagnostics" })
map("n", "<leader>sr", telescope_builtin.resume, { desc = "resume search" })

-- -- document existing key chains
-- which_key.register({
--   ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
--   ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
--   ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
--   ["<leader>h"] = { name = "Git [H]unk", _ = "which_key_ignore" },
--   ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
--   ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
--   ["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
--   ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
-- })
--
-- -- register which-key VISUAL mode
-- -- required for visual <leader>hs (hunk stage) to work
-- which_key.register({
--   ["<leader>"] = { name = "VISUAL <leader>" },
--   ["<leader>h"] = { "Git [H]unk" },
-- }, { mode = "v" })
