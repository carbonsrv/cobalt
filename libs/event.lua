-- Event stuff based on the pubsub.

local _M = {}

msgpack = require("msgpack")
pubsub = require("libs.pubsub")

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

return _M
