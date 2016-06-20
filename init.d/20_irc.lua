-- IRC!

thread = require("thread")
logger = require("libs.logger")
event = require("libs.event")

if settings.irc then -- Only continue if there are actually IRC Servers in the config.
	event.handle("irc:send", function(name, line) -- Easy hook for message sending: event.fire("irc:send", "esper", "NICK Cobalt")
		event = require("libs.event")
		event.fire("irc:send_"..name, line)
	end)

	event.handle("irc:new_conn", function(server_name) -- Handle new connections
		-- TODO: Replace stub.
		event = require("libs.event")
		event.fire("irc:send_".. server_name, "NICK "..irc_set[server_name].nick)
		event.fire("irc:send_".. server_name, "USER "..irc_set[server_name].user.." ~ ~ :"..irc_set[server_name].real)

		event.fire("irc:finished_init", server_name)
	end, {
		irc_set = settings.irc
	})

	event.handle("irc:finished_init", function(server_name) -- Handle finished connections
		event = require("libs.event")
		os.sleep(5)
		if irc_set[server_name].postinit then
			event.fire("irc:send_"..server_name, irc_set[server_name].postinit)
		end
		os.sleep(5)

		for n, chan in pairs(irc_set[server_name].channels) do
			os.sleep(0.5)
			event.fire("irc:send_"..server_name, "JOIN "..chan)
		end
	end, {
		irc_set = settings.irc
	})

	event.handle("irc:raw", function(server_name, line)
		--logger = logger or require("libs.logger")
		--rpc.call("log", "irc:"..server_name, logger.normal, line)

		event = require("libs.event")
		if line:match("^PING") then
			event.fire("irc:send", server_name, line:gsub("^PING", "PONG"))
		end
	end, {
		irc_set = settings.irc
	})

	local length = 0
	for _ in pairs(settings.irc) do
		length = length + 1
	end
	local i = 0

	for name, data in pairs(settings.irc) do -- Loop through servers
		i = i + 1
		rpc.call("log.normal", "IRC", "("..tostring(i).."/"..tostring(length)..") Connecting to "..name.."...")
		local conn, err = net.dial(data.proto or "tcp", data.address..":"..tostring(data.port)) -- Connect
		if conn then
			kvstore.set("irc:conn_"..name, conn)
			net.write(conn, "") -- Just to initialize.

			event.handle("irc:send_"..name, function(line)
				if not conn then
					conn = kvstore.get("irc:conn_"..short_name) -- Get the connection
				end
				if line and line ~= "" then
					net.write(conn, line.."\r\n")
					-- Rate Limiting(tm)
					os.sleep(0.3)
				end
			end, {
				["short_name"] = name
			}, 1024)

			-- The below breaks cobalt, sadly.
			--[[event.handle("irc:finished_init", function(server_name)
				if server_name == identifier then
					rpc.command("log", function(phonetic_name, level, message)
						if level <= logger.important then
							for n, chan in pairs(list) do
								event.fire("print", "irc:send_"..identifier, "PRIVMSG "..chan.." :["..phonetic_name.."]> " .. ((level == 3 and "\x034") or (level == 2 and "\x0315")) .. message .. "\x0f")
								event.fire("irc:send_"..identifier, "PRIVMSG "..chan.." :["..phonetic_name.."]> " .. ((level == 3 and "\x034") or (level == 2 and "\x0315")) .. message .. "\x0f")
							end
						end
					end, {
						["identifier"] = name,
						["list"] = list,
					})
				end
			end, {
				["identifier"] = name,
				["list"] = settings.irc[name].log_output,
			})]]

			os.sleep(0.5)

			thread.spawn(function() -- The receiving part, fires event irc:raw.
				event = require("libs.event")

				conn = kvstore.get("irc:conn_"..short_name) -- Get the connection.
				event.fire("irc:new_conn", short_name) -- Fire the init event.

				local buff = ""
				while true do
					local txt, err = net.read(conn, 1)
					if err == "EOF" then
						event.fire("irc:eof", short_name)
						break -- Should handle it better, I think.
					else
						local tmp = (buff .. txt)
						buff = string.gsub(tmp, "(.-)[\r\n]", function(line)
							if line ~= "" then
								event.fire("irc:raw", short_name, line)
							end
							return ""
						end)
					end
				end
			end, {
				["short_name"] = name
			})
			rpc.call("log.normal", "IRC", "Connected to "..name..".")
		else
			rpc.call("log.critical", "IRC", "Failed to connect to "..name..": "..tostring(err))
		end
	end

	event.handle("irc:raw", function(server, line) -- throw the messages in the parser!
		irc = require("libs.irc")
		irc.event_parse(server, line)
	end)

	rpc.command("irc.send", function(server, line) -- throw the messages in the parser!
		event = require("libs.event")
		event.fire("irc:send_"..server, line)
	end, nil, 1024)

	rpc.command("irc.msg", function(server, to, msg)
		event = require("libs.event")
		local msg = msg .. "\n"
		for m in msg:gmatch("(.-)\n") do
			if m and m ~= "" then
				event.fire("irc:send", server, "PRIVMSG "..to.." :"..m)
				-- Rate Limiting(tm)
				os.sleep(0.3)
			end
		end
	end)

	rpc.command("irc.action", function(server, chan, text) -- throw the messages in the parser!
		event = require("libs.event")
		event.fire("irc:send", server, "PRIVMSG "..chan.." :\1ACTION "..(text or "").."\1")
	end)

end
