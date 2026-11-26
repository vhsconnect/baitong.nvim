local M = {}

local DEFAULT_TIMEOUT = 3000

---@class Job
---@field cmd string[]
---@field timeout? integer

---@param job Job
---@return string? output
function M.run(job)
  local result = vim.system(job.cmd, { text = true }):wait(job.timeout or DEFAULT_TIMEOUT)
  if result.code ~= 0 then
    vim.notify(("%s failed: %s"):format(job.cmd[1], result.stderr), vim.log.levels.ERROR)
    return nil
  end
  return vim.trim(result.stdout)
end

function M.branches()
  local out = M.run({ cmd = { "git", "branch", "--format=%(refname:short)" } }) or ""
  local names = {}
  for name in out:gmatch("[^\n]+") do
    if not name:match("^HEAD") then
      table.insert(names, name)
    end
  end
  return names
end

return M
