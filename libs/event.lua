-- Event stuff based on the pubsub.

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

function _M.handle(name, func, bindings, buffer)
	local binds = {
		f = string.dump(func),
		event_name = name
	}
	for k, v in pairs(bindings or {}) do
		binds[k] = v
	end
	pubsub.sub("event:"..name, function()
		msgpack = require("msgpack")
		logger = require("libs.logger")
		event = require("libs.event")
		rpc = require("libs.multirpc")
		prettify = require("prettify")
		function print(...)
			logger.log(event_name, logger.normal, prettify(...))
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
				logger.log(event_name, logger.normal, "(╯°□°）╯︵ ┻━┻: "..err)
			end
		end
	end, binds, buffer)
end

function _M.listen(name) -- ltn12 compatible listener
	local retcom = com.create()
	pubsub.sub("event:"..name, retcom)
	return function()
		local src = com.receive(retcom)
		if src then
			return msgpack.unpack(src)
		else
			return nil
		end
	end
end

function _M.netdial(in_name, out_name, proto, addr)
	local conn, err = net.dial(proto, addr)
	if err then
		error(err)
	end

	local inp = com.create()
	local out = com.create()

	net.pipe_com_background(conn, inp, out)

	pubsub.sub("netevent:"..in_name, inp)

	event.handle("event:".. in_name, function(line)
		local msgpack = require("msgpack")
		local pubsub = require("libs.pubsub")
		pubsub.pub(name, line)
	end, {
		name = "netevent:"..in_name
	})

	local tmp_pub = thread.spawn(function()
		local msgpack = require("msgpack")
		local pubsub = require("libs.pubsub")
		while true do
			pubsub.pub(name, msgpack.pack({com.receive(threadcom)}))
		end
	end, {
		name = "event:"..out_name
	})
	com.pipe_background(out, tmp_pub)
end

function _M.fire(name, ...)
	if ({...})[1] then
		pubsub.pub("event:"..name, msgpack.pack({...}))
	else
		pubsub.pub("event:"..name)
	end
end

function _M.force_fire(name, ...)
	if ({...})[1] then
		pubsub.pub("event:"..name, msgpack.pack({...}), true)
	else
		pubsub.pub("event:"..name, nil, true)
	end
end

return _M
