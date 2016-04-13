-- Module loader, pretty basic.

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
	return len, os.clock() - start
end

return _M
