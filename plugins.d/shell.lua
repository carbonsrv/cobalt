-- Run Shell commands.

command.add("sh", function(from, args)
	if perms[from] == 3 then
		-- Authorized.
			local output = io.popen(args.." 2>&1"):read("*a")
			return "| "..output:gsub("\n$", ""):gsub("\n", "\n| ")
	else
		return "How about no?"
	end
end, {
	perms = settings.permissions,
}, true)
