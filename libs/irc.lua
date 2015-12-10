-- IRC Parser.

local _M = {}

function _M.parse(message)
	local prefix_end = 0
	local prefix;

	if message:sub(1, 1) == ":" then
		prefix_end = message:find(" ")
		prefix = message:sub(2, message:find(" ") - 1)
	end

	local trailing
	local tstart = message:find(" :")
	if tstart then
		trailing = message:sub(tstart + 2)
	else
		tstart = #message
	end

	local rest = {}
	for t in (message:sub(prefix_end + 1, tstart)):gmatch("%S+") do
		table.insert(rest, t)
	end

	local command = rest[1]
	table.remove( rest, 1 )
	return prefix, command, rest, trailing
end

function _M.event_parse(server, message)
	local prefix, command, rest, trailing = _M.parse(message)

	if command then
		local last = {unpack(rest)}
		table.insert(last, trailing)
		event.fire("irc:event", server, message, prefix, command, unpack(last))
		event.fire("irc:"..string.lower(command), server, prefix, unpack(last))
	else
		event.fire("irc:other", server, message)
	end
end

return _M
