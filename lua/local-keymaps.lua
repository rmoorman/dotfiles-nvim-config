local telescope_builtin = require("telescope.builtin")
local utils = require("utils")

-- Don't move cursor when using space in normal or visual selection mode
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Exit insert mode from the home row without reaching for escape
vim.keymap.set("i", "jj", "<Esc>", { noremap = true })

-- Remap for dealing with word wrap by switching j and k to move the cursor
-- inside the wrapped line down and up instead of just skipping to the next and
-- previous line
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "go to next diagnostic message" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "open diagnostics list" })

-- Special keymaps for buffers attached to an LSP
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local buf_opts = utils.curried_opts({ buffer = ev.buffer })

    -- Code formatting buffer or selection
    vim.keymap.set({ "n", "v" }, "<leader>gf", vim.lsp.buf.format, buf_opts({ desc = "code format" }))

    -- Code actions for buffer or selection
    vim.keymap.set({ "n", "v" }, "<leader>ga", vim.lsp.buf.code_action, buf_opts({ desc = "code action" }))

    -- Hover documentation
    vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts({ desc = "hover documentation" }))

    -- Goto definition
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, buf_opts({ desc = "goto definition" }))

    -- Show references
    --vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, buf_opts({ desc = "goto references" }))
    -- https://www.reddit.com/r/neovim/comments/ypaq3e/lsp_find_reference_results_in_telescope/
    vim.keymap.set(
      "n",
      "<leader>gr",
      telescope_builtin.lsp_references,
      buf_opts({ desc = "goto references", noremap = true, silent = true })
    )
  end,
})

-- File tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", {})

-- Telescope searching
vim.keymap.set("n", "<leader>sf", telescope_builtin.find_files, {})
vim.keymap.set("n", "<leader>sg", telescope_builtin.live_grep, {})


