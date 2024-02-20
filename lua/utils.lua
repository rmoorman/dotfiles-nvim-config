local utils = {}

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

return utils
