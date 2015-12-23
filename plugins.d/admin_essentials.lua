-- Essentials, like wq and stuff.

command.add("wq", function(from, chan, args)
	if perms[from] == 3 then
		rpc.call("cobalt.exit", 0)
		return "I see ya' when I see ya'. Peace. λ"
	end
end, {
	perms = settings.permissions,
})
