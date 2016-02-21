-- Lua Sandbox.
command.add("lua", function(from, chan, args)
	if not args then return "nil" end
	sbx = require("libs.luasbx")
	local extra = {
		["from"] = from,
		["chan"] = chan
	}
	local success, retval = pcall(sbx.eval, args, extra)
	if not success then
		return "> " .. retval:gsub("^[\r\n]+", ""):gsub("[\r\n]+$", ""):gsub("[\r\n]+", " | "):sub(1,440)
	else
		return "> " .. retval
	end
end, {}, true)
