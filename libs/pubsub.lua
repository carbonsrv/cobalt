-- Com dispatcher/pubsub, listens to one, dispatches to many, similar to a mailbox!
-- It's a pubsub. :v

local _M = {}

thread = require("thread")
local msgpack = require("msgpack")

_M.dispatcher = kvstore.get("dispatcher_thread") or thread.spawn(function()
	local logger = require("libs.logger")
	local msgpack = require("msgpack")
	local thread = require("thread")
	while true do
		local msg = msgpack.unpack(com.receive(threadcom))
		if msg.type == "sub" then
			local compath = kvstore.get("coms:"..msg.path)
			if not compath then
				compath = {}
			end
			table.insert(compath, kvstore.get("dispatcher_tmp:"..msg.path))
			kvstore.set("coms:"..msg.path, compath)
			com.send(threadcom, nil)
		elseif msg.type == "pub" then
			path = msg.path
			message = msg.msg
			local sender = function()
				local compath = kvstore.get("coms:"..path)
				if not compath then
					compath = {}
				end
				if compath then
					for i, chan in pairs(compath) do
						com.send(chan, message)
					end
				else
					rpc.call("log.important", "Dispatcher", "Pubsub event for "..path.." fired but nobody cared!")
				end
			end
			if #(kvstore.get("coms:"..path) or {}) >= 3 then
				thread.spawn(sender, {
					path = msg.path,
					message = msg.msg
				})
			else
				sender()
			end
		end
	end
end)
kvstore.set("dispatcher_thread", _M.dispatcher)

-- Subscribe to topic.
function _M.sub(path, chan, bindings, buffer)
	if chan then
		local chan = chan
		if type(chan) == "function" then
			chan = thread.spawn(chan, bindings, buffer or 64)
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
