-- Allows calling methods via a rest-like api

srv.POST("/api/call/:name", mw.new(function()
	rpc = rpc or require("libs.multirpc")
	logger = logger or require("libs.logger")

	if whitelist[context.ClientIP():gsub(":(%d+)$", "")] then
		local funcname = param("name")
		if funcname then
			local args = {}
			for i=1,10 do
				local p = form("arg"..tostring(i))
				if p then
					local x = p
					x = tonumber(p) or p
					args[i] = x
				else
					break
				end
			end

			logger.log("webrpc", logger.normal, "Calling "..funcname.." with " .. tostring(#args) .. " arguments.")
			rpc.call(funcname, unpack(args))
			content("", 200)
		else
			logger.log("webrpc", logger.important, "Unauthorized call to "..funcname.." with " .. tostring(#args) .. " arguments blocked.")
			content("IP not in whitelist!", 401)
		end
	else
		content("No function name given.", 406)
	end
end, {
	whitelist = settings.webrpc.whitelist,
}))

local nofunc = mw.echo("No function name given.", 406)
srv.POST("/api/call", nofunc)
srv.POST("/api/call/", nofunc)

srv.DefaultRoute(mw.new(function()
	rpc = rpc or require("libs.multirpc")

	-- Send the 404 early, log afterwards.
	content("404 page not found", 404)

	-- Log with priority "important".
	rpc.call("log", "HTTP", 1, context.ClientIP():gsub(":(%d+)$", "").. " tried to access "..path..", resulting in 404.")
end))
