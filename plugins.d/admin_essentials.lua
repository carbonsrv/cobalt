-- Essentials, like wq and stuff.

command.add("wq", function(from, chan, args)
	if perms[from] == 3 then
		rpc.call("cobalt.exit", 0)
		return "I see ya' when I see ya'. Peace. λ"
	end
end, {
	perms = settings.permissions,
})

command.add("perms", function(from, chan, args)
	return "You have a permission level of " .. tostring(perms[from] or 0) .."."
end, {
	perms = settings.permissions,
})
