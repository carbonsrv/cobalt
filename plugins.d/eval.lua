-- Eval, basic.

event.handle("irc:privmsg", function(server, from, to, message)
	if (luar.map2table(irc_set[server].permissions))[from] == 3 then
		-- Authorized.
		message:gsub("^"..irc_set[server].prefix.."eval (.-)$", function(match)
			if match and match ~= "" then
				local sender = from:match("^(.-)!")
				local sendto = sender == irc_set[server].nick and sender or to
				function print(...)
					for k, v in pairs({...}) do
						event.fire("irc:send", server, "PRIVMSG "..sendto.." :"..tostring(v))
					end
				end
				local f, err = loadstring("return "..match)
				if err then
					f, err = loadstring(match)
					if err then
						event.fire("irc:send", server, "PRIVMSG "..sendto.." :".."Error: "..err)
						return
					end
				end
				local suc, res = pcall(f)
				if suc then
					if res then
						event.fire("irc:send", server, "PRIVMSG "..sendto.." :".."-> "..tostring(res))
					end
				else
					event.fire("irc:send", server, "PRIVMSG "..sendto.." :".."Error: "..res)
				end
			end
		end)
	end
end, {
	irc_set = settings.irc,
})
