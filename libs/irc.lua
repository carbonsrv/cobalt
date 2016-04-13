-- IRC Parser.

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

function _M.parse(message)
	local prefix_end = 0
	local prefix;

	if message:sub(1, 1) == ":" then
		prefix_end = message:find(" ")
		prefix = message:sub(2, message:find(" ") - 1)
	end

	local trailing
	local tstart = message:find(" :")
	if tstart then
		trailing = message:sub(tstart + 2)
	else
		tstart = #message
	end

	local rest = {}
	for t in (message:sub(prefix_end + 1, tstart)):gmatch("%S+") do
		table.insert(rest, t)
	end

	local command = rest[1]
	table.remove( rest, 1 )
	return prefix, command, rest, trailing
end

function _M.event_parse(server, message)
	local prefix, command, rest, trailing = _M.parse(message)

	if command then
		local last = {unpack(rest)}
		table.insert(last, trailing)
		event.fire("irc:event", server, message, prefix, command, unpack(last))
		event.fire("irc:"..string.lower(command), server, prefix, unpack(last))
	else
		event.fire("irc:other", server, message)
	end
end

return _M
