-- Multi-command multi-result RPC based on the pubsub.

local _M = {}

local msgpack = require("msgpack")
local pubsub = require("libs.pubsub")

function _M.command(name, func)
	pubsub.sub("command:"..name, function()
		local msgpack = require("msgpack")
		local logger = require("libs.logger")
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
				logger.log(state_name, logger.critical, err)
			end
		end
	end, {
		f = string.dump(func),
		state_name = name
	})
end

function _M.call(name, ...)
	if ({...})[1] then
		pubsub.pub("command:"..name, msgpack.pack({...}))
	else
		pubsub.pub("command:"..name)
	end
end

return _M
