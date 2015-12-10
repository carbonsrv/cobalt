-- Com dispatcher/pubsub, listens to one, dispatches to many, similar to a mailbox!
-- It's a pubsub. :v

local _M = {}

thread = require("thread")
local msgpack = require("msgpack")

_M.dispatcher = kvstore.get("dispatcher_thread") or thread.spawn(function()
	local msgpack = require("msgpack")
	local coms = {}
	while true do
		local msg = msgpack.unpack(com.receive(threadcom))
		if msg.type == "sub" then
			coms[msg.path] = coms[msg.path] or {}
			table.insert(coms[msg.path], kvstore.get("dispatcher_tmp:"..msg.path))
			com.send(threadcom, nil)
		elseif msg.type == "pub" then
			for i, chan in pairs(coms[msg.path] or {}) do
				com.send(chan, msg.msg)
			end
		end
	end
end)
kvstore.set("dispatcher_thread", _M.dispatcher)

-- Subscribe to topic.
function _M.sub(path, chan)
	if chan then
		local chan = chan
		if type(chan) == "function" then
			chan = thread.spawn(chan)
		end
		kvstore.set("dispatcher_tmp:"..path, chan)
		com.send(_M.dispatcher, msgpack.pack{
			type="sub",
			path=path
		})
		com.receive(_M.dispatcher) -- Block until it's done for safety reasons.
	else
		error("chan not given!")
	end
end

function _M.pub(path, msg)
	com.send(_M.dispatcher, msgpack.pack{
		type="pub",
		path=path,
		msg=msg
	})
end

return _M
