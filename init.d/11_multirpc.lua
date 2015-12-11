-- MultiRPC initializer

rpc = require("libs.multirpc")

-- Eval a string, for random stuff or something.
rpc.command("lua.eval", function(code, ...)
	local f, err = loadstring("return "..code)
	if err then
		f, err = loadstring(code)
		if err then
			rpc.call("log.critical", "lua.eval", "Error: "..err)
			return
		end
	end
	local suc, res = pcall(f, ...)
	if suc then
		rpc.call("log.normal", "lua.eval", "-> "..tostring(res))
	else
		rpc.call("log.critical", "lua.eval", "Error: "..res)
	end
end)

rpc.command("lua.exec", function(funcname, ...)
	local suc, f = pcall(loadstring("return "..funcname))
	if not suc then
		rpc.call("log.critical", "lua.exec", "Error: "..f)
	end
	if type(f) ~= "function" then
		rpc.call("log.critical", "lua.exec", "Error: "..funcname.." is not a function!")
	else
		local suc, res = pcall(f, ...)
		if suc then
			rpc.call("log.normal", "lua.exec", "-> "..tostring(res))
		else
			rpc.call("log.critical", "lua.exec", "Error: "..res)
		end
	end
end)
