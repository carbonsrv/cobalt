-- Run Shell commands.

event.handle("irc:privmsg", function(server, from, to, message)
	if (luar.map2table(irc_set[server].permissions))[from] == 3 then
		-- Authorized.
		message:gsub("^"..irc_set[server].prefix.."sh (.-)$", function(match)
			if match and match ~= "" then
				local sender = from:match("^(.-)!")
				local sendto = sender == irc_set[server].nick and sender or to

				thread.spawn(function()
					rpc = rpc or require("libs.multirpc")
					local output = io.popen(cmd.." 2>&1"):read("*a")
					rpc.call("irc.msg", server, sendto, "| "..output:gsub("\n", "\n| "))
				end, {
					cmd = match,
				})
			end
		end)
	end
end, {
	irc_set = settings.irc,
})
