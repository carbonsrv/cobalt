-- Module loader, pretty basic.

local _M = {}

local logger = require("libs.logger")

local function log(level, msg)
	logger.log("Loader", level, msg)
end

function _M.load(pattern, output)
	local list = io.glob(pattern)
	local len = #list
	local start = os.clock()
	if output then log(logger.normal, "Loading '".. pattern .. "'...") end
	for i, name in pairs(list) do
		log(logger.normal, "("..tostring(i).."/"..tostring(len)..") Loading '"..name.."'...")
		dofile(name)
	end
	if output then log(logger.normal, "Loader done.") end
	return os.clock() - start
end

return _M
