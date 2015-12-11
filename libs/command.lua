-- Commands for the chat bot thing, mostly just an event responder.

local _M = {}

local msgpack = require("msgpack")
local pubsub = require("libs.pubsub")

function _M.command(name, func, bindings)
	local binds = {
		f = string.dump(func),
		event_name = name
	}
	for k, v in pairs(bindings or {}) do
		binds[k] = v
	end
	pubsub.sub("chatcmd:"..name, function()
		msgpack = require("msgpack")
		logger = require("libs.logger")
		rpc = require("libs.multirpc")
		event = require("libs.event")
		prettify = require("prettify")
		function print(...)
			logger.log(event_name, logger.normal, prettify(...))
		end
		local func = loadstring(f)
		f = nil
		while true do
			local src = com.receive(threadcom)
			local res = msgpack.unpack(src)

			local args = res.args

			local suc, res = pcall(func, unpack(args))
			if not suc then
				logger.log(state_name, logger.critical, res)
			end
		end
	end, binds)
end

function _M.call(rpc_name, rpcargs, ...)
	if ({...})[1] then
		pubsub.pub("chatcmd:"..name, msgpack.pack({
			["rpc_name"] = rpc_name,
			["rpc"] = rpcargs,
			["args"] = {...}
		}))
	else
		pubsub.pub("chatcmd:"..name, msgpack.pack({
			["rpc_name"] = rpc_name,
			["rpc"] = rpcargs,
			["args"] = {}
		}))
	end
end

return _M
