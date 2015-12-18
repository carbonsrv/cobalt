-- Command handler

event.handle("irc:privmsg", function(server, from, to, message)
	local handler = function(cmd, match)
		if cmd and cmd ~= "" then
			local sender = from:match("^(.-)!")
			local sendto = sender == irc_set[server].nick and sender or to

			-- Arguments
			local replyargs = {"irc.msg", server, sendto}

			event.fire("chatcmd:"..cmd, replyargs, from, match)

			return ""
		end
	end
	local matched = message:gsub("^"..irc_set[server].prefix.."(.-) (.*)$", handler) ~= message
	if not matched then
		message:gsub("^"..irc_set[server].prefix.."(.+)", handler)
	end
end, {
	irc_set = settings.irc,
})

command = {}
function command.add(name, func, binds)
	local args =  {
		fn = string.dump(func)
	}
	if binds then
		for k, v in pairs(binds) do
			if k ~= "fn" then
				args[k] = v
			end
		end
	end
	event.handle("chatcmd:"..name, function(replyargs, ...)
		cmd_func = cmd_func or loadstring(fn)
		local suc, res = pcall(cmd_func, ...)
		if suc then
			table.insert(replyargs, res)
			rpc.call(unpack(replyargs))
		else
			print("Error: "..res)
		end
	end, args)
end
