local utils = {}

-- Return an opts factory function that falls back to the supplied opts
utils.curried_opts = function(opts)
  local factory = function(given_opts)
    local result = {}
    for key, value in pairs(opts or {}) do
      result[key] = value
    end
    for key, value in pairs(given_opts or {}) do
      result[key] = value
    end
    return result
  end
  return factory
end

-- Find the git root based on the current buffer's path, falling back to the CWD
function utils.find_git_root()
  local cwd = vim.fn.getcwd()

  -- Determine the current directory based on the current file, falling back to
  -- the current working directory of the editor
  local current_dir
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    current_dir = cwd
  else
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the git root directory based on the established current directory
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(current_dir) .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Falling back to current working directory")
    return cwd
  end

  return git_root
end

return utils
