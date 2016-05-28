-- Command handler and stuff.

local _M = {}
function _M.start_handler()
	event.handle("irc:privmsg", function(server, from, to, message)
		local handler = function(cmd, match)
			if cmd and cmd ~= "" then
				local sender = from:match("^(.-)!")
				local sendto = to == irc_set[server].nick and sender or to

				-- Arguments
				local replyargs = {"irc.msg", server, sendto}

				event.fire("chatcmd:"..cmd, replyargs, from, sendto, match, server)

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
end

function _M.add(name, func, binds, spawnthread, buffer)
	if spawnthread then
		event.handle("chatcmd:"..name, function(replyargs, ...)
			local targs = {
				["fn"] = fn,
				cmdname = cmd_name,
				call_args = table.pack(...),
				rargs = replyargs,
			}
			for k, v in pairs(vars) do
				if k ~= "fn" and k ~= "cmdname" and k ~= "call_args" and k ~= "rargs" then
					targs[k] = v
				end
			end
			thread.spawn(function()
				rpc = require("libs.multirpc")
				local replyargs = rargs
				table.insert(call_args, rargs)
				local suc, res = pcall(loadstring(fn), unpack(call_args))
				if suc then
					table.insert(replyargs, res)
					rpc.call(unpack(replyargs))
				else
					rpc.call("log.important", "chatcmd:"..cmdname, "Error: "..res)
				end
			end, targs)
		end, {
			fn=string.dump(func),
			replargs = replyargs,
			cmd_name = name,
			vars = binds or {},
		}, buffer)
	else
		local args =  {
			fn = string.dump(func),
			cmd_name = name,
		}
		if binds then
			for k, v in pairs(binds) do
				if k ~= "fn" and k ~= "name_of_command" then
					args[k] = v
				end
			end
		end
		event.handle("chatcmd:"..name, function(replyargs, ...)
			cmd_func = cmd_func or loadstring(fn)
			local args = table.pack(...)
			table.insert(args, replyargs)
			local suc, res = pcall(cmd_func, unpack(args, 1, args.n))
			if suc then
				table.insert(replyargs, res)
				rpc.call(unpack(replyargs))
			else
				print("Error: "..res)
			end
		end, args, buffer)
	end
end

return _M
