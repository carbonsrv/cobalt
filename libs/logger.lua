-- Log module

--[[
	The MIT License (MIT)

	Copyright (c) 2015 - 2016 Adrian Pistol

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]

local _M = {}

_M.version = "0.0.1"

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
