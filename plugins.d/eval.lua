-- Eval, basic.

command.add("eval", function(from, chan, args)
	command = require("libs.command")
	event = require("libs.event")
	rpc = require("libs.multirpc")
	serialize = require("serialize")
	msgpack = require("msgpack")
	settings = msgpack.unpack(settings_packed)

	if perms[from] == 3 then
		-- Authorized.

		if not args then
			return "Usage: eval <lua code>"
		end

		local output = ""
		function print(...)
			for k, v in pairs({...}) do
				output = output .. tostring(v) .. "\n"
			end
		end
		local f, err = loadstring("return "..args)
		if err then
			f, err = loadstring(args)
			if err then
				return "Error: "..err
			end
		end
		local suc, res = pcall(f)
		if suc then
			return output.. "-> "..serialize.simple(res)
		else
			return output.."Error: "..res
		end
	else
		return "How about no?"
	end
end, {
	perms = settings.permissions,
	settings_packed = msgpack.pack(settings)
}, true)
