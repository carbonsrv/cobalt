-- Eval, basic.

command.add("eval", function(from, args)
	if perms[from] == 3 then
		-- Authorized.
		local output = ""
		function print(...)
			for k, v in pairs({...}) do
				output = output .. tostring(v) .. "\n"
			end
		end
		local f, err = loadstring("return "..args)
		if err then
			f, err = loadstring(args)
			if err then
				return "Error: "..err
			end
		end
		local suc, res = pcall(f)
		if suc then
			return output.. "-> "..tostring(res)
		else
			return output.."Error: "..err
		end
	else
		return "How about no?"
	end
end, {
	perms = settings.permissions,
})
