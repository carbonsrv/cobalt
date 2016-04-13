-- Multi-command multi-result RPC based on the pubsub.

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

msgpack = require("msgpack")
pubsub = require("pubsub")

function _M.command(name, func, bindings, buffer)
	local binds = {
		f = string.dump(func),
		event_name = name
	}
	for k, v in pairs(bindings or {}) do
		binds[k] = v
	end
	pubsub.sub("cmd:"..name, function()
		msgpack = require("msgpack")
		logger = require("libs.logger")
		rpc = require("libs.multirpc")
		event = require("libs.event")
		prettify = require("prettify")
		function print(...)
			rpc.call("log.normal", event_name, prettify(...))
		end
		local func = loadstring(f)
		f = nil
		while true do
			local src = com.receive(threadcom)
			local args
			if src then
				args = msgpack.unpack(src)
			else
				args = {}
			end
			local suc, err = pcall(func, unpack(args))
			if not suc then
				rpc.call("log.critical", state_name, "(╯°□°）╯︵ ┻━┻: "..err)
			end
		end
	end, binds, buffer)
end

function _M.call(name, ...)
	if ({...})[1] then
		pubsub.pub("cmd:"..name, msgpack.pack({...}))
	else
		pubsub.pub("cmd:"..name)
	end
end

return _M
