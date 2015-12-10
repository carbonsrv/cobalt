#!/usr/bin/env carbon

local conn, err = net.dial("tcp", "google.de:http")
if err then
	error(err)
end
net.write(conn, "GET / HTTP/1.0\r\n\r\n")

kvstore.set("conn", conn)

thread = require("thread")
thread.spawn(function()
	local conn
	while not conn do
		conn = kvstore.get("conn")
	end
	while true do
		line, err = net.readline(conn)
		print(line)
		if err == "EOF" then
			error("EOF")
		end
	end
end)

com.receive(com.create())
