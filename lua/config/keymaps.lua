local telescope_builtin = require("telescope.builtin")
local utils = require("config.utils")

local map = vim.keymap.set

-- Don't move cursor when using space in normal or visual selection mode
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

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

-- Special keymaps for buffers attached to an LSP
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local buf_opts = utils.curried_opts({ buffer = ev.buffer })

    -- Code formatting buffer or selection
    map({ "n", "v" }, "<leader>gf", vim.lsp.buf.format, buf_opts({ desc = "code format" }))

    -- Code actions for buffer or selection
    map({ "n", "v" }, "<leader>ga", vim.lsp.buf.code_action, buf_opts({ desc = "code action" }))

    -- Hover documentation
    map("n", "K", vim.lsp.buf.hover, buf_opts({ desc = "hover documentation" }))

    -- Goto definition
    map("n", "<leader>gd", vim.lsp.buf.definition, buf_opts({ desc = "goto definition" }))

    -- Show references
    --map("n", "<leader>gr", vim.lsp.buf.references, buf_opts({ desc = "goto references" }))
    -- https://www.reddit.com/r/neovim/comments/ypaq3e/lsp_find_reference_results_in_telescope/
    map(
      "n",
      "<leader>gr",
      telescope_builtin.lsp_references,
      buf_opts({ desc = "goto references", noremap = true, silent = true })
    )
  end,
})

-- File tree
map("n", "<leader>e", ":NvimTreeToggle<CR>", {})

-- Telescope searching
map("n", "<leader>sf", telescope_builtin.find_files, {})
map("n", "<leader>sg", telescope_builtin.live_grep, {})
