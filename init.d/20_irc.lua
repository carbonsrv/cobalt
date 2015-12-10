-- IRC!

local thread = require("thread")
local logger = require("libs.logger")
local event = require("libs.event")

if settings.irc then -- Only continue if there are actually IRC Servers in the config.
	event.handle("irc:send", function(name, line) -- Easy hook for message sending: event.fire("irc:send", "esper", "NICK Cobalt")
		event = event or require("libs.event")
		logger = logger or require("libs.logger")
		print("Sending")
		event.fire("irc:send_"..name, line)
	end)


	event.handle("irc:new_conn", function(server_name) -- Handle new connections
		-- TODO: Replace stub.
		print("New con")
		event = event or require("libs.event")
		event.fire("irc:send_".. server_name, "NICK "..irc_set[server_name].nick)
		event.fire("irc:send_".. server_name, "USER "..irc_set[server_name].user.." ~ ~ :"..irc_set[server_name].real)

		event.fire("irc:finished_init", server_name)
		print("Fired events.")
	end, {
		irc_set = settings.irc
	})

	event.handle("irc:finished_init", function(server_name) -- Handle new connections
		event = event or require("libs.event")
		os.sleep(10)

		for n, chan in pairs(luar.slice2table(irc_set[server_name].channels)) do
			os.sleep(0.5)
			event.fire("irc:send_"..server_name, "JOIN "..chan)
		end
		print("Fired events.")
	end, {
		irc_set = settings.irc
	})

	event.handle("irc:raw", function(server_name, line)
		logger = logger or require("libs.logger")
		logger.log("irc:"..server_name, logger.normal, line)

		event = event or require("libs.event")
		if line:match("^PING") then
			event.fire("irc:send", server_name, line:gsub("^PING", "PONG"))
		end
	end, {
		irc_set = settings.irc
	})

	local length = #settings.irc
	local i = 0

	for name, data in pairs(settings.irc) do -- Loop through servers
		i = i + 1
		logger.log("IRC", logger.normal, "("..tostring(i).."/"..tostring(length)..") Connecting to "..name.."...")
		local conn = net.dial(data.proto or "tcp", data.address..":"..tostring(data.port)) -- Connect
		kvstore.set("irc:conn_"..name, conn)
		net.write(conn, "") -- Just to initialize.

		event.handle("irc:send_"..name, function(line)
			print("Sending to "..short_name)
			if not conn then
				conn = kvstore.get("irc:conn_"..short_name) -- Get the connection, but repeat if we fail.
			end
			net.write(conn, line.."\r\n")
		end, {
			["short_name"] = name
		})

		os.sleep(0.5)

		thread.spawn(function() -- The receiving part, fires event irc:raw.
			local event = require("libs.event")

			conn = kvstore.get("irc:conn_"..short_name) -- Get the connection.
			print(conn)
			event.fire("irc:new_conn", short_name) -- Fire the init event.
			print("Got conn")
			while true do
				local line, err = net.readline(conn)
				if err == "EOF" then
					event.fire("irc:eof", short_name)
					break -- Should handle it better, I think.
				else
					event.fire("irc:raw", short_name, line:sub(1, -3))
				end
			end
		end, {
			["short_name"] = name
		})
		logger.log("IRC", logger.normal, "Connected to "..name..".")
	end
end