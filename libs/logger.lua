-- Log module
local _M = {}

-- Libraries
local colors = require("libs.ansicolors")

-- Variables
_M.print = print
_M.debug = cobalt and cobalt.debug or false -- Debugging turned on or off depending on cobalt setting.

-- Levels:
--  0: Critical priority, for _very_ _important_ messages. Red.
--  1: Important info, but not critical. Yellow.
--  2: Normal level, to be viewed, but generally nobody cares.
--  3: Debug output, won't output unless debug is enabled.
_M.critical = 0
_M.important = 1
_M.normal = 2
_M.debug = 3

-- The most commonly used log function, its colorful!
-- Format (log level colored): [STATENAME]> message
function _M.log(state_name, level, message)
	local level = level and tonumber(level) or 2
	local msg = "[" .. colors.bright .. colors.black .. (state_name or "Unnamed") .. colors.reset .. "]> "
	if level == 0 then
		msg = msg .. colors.bright .. colors.red .. message .. colors.reset
	elseif level == 1 then
		msg = msg .. colors.yellow .. message .. colors.reset
	elseif level == 2 then
		msg = msg .. message
	elseif level >= 3 then
		if _M.debug then
			msg = msg .. message
		else
			return
		end
	else
		return -- Don't do anything.
	end
	_M.print(msg)
end

return _M
