-- Multi-command multi-result RPC based on the pubsub.

local _M = {}

local msgpack = require("msgpack")
local pubsub = require("libs.pubsub")

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
				rpc.call("log.critical", state_name, err)
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
