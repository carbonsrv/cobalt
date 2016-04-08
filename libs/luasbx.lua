local sbox, usr, out
local _M = {}

local function maxval(tbl)
	local mx = 0
	for k, v in pairs(tbl) do
		if type(k) == "number" then
			mx = math.max(k,mx)
		end
	end
	return mx
end

function _M.reset()
	local tsbox = {}
	sbox = {
		_VERSION = _VERSION .. " Sandbox",
		assert = assert,
		error = error,
		getfenv = function(func)
			if tsbox[func] then
				return false, "Nope."
			end
			local res = getfenv(func)
			if res == _G then
				return sbox
			end
			return res
		end,
		getmetatable = getmetatable,
		ipairs = ipairs,
		loadstring = function(txt, name)
			if string.sub (txt, 1, 1) == "\27" then
				return false, "Nope."
			end
			local func,err = loadstring(txt, name)
			if func then
				setfenv(func, sbox)
			end
			return func,err
		end,
		next = next,
		pairs = pairs,
		print = function(...)
			local newt = {}
			for k, v in pairs({...}) do
				newt[k] = tostring(v)
			end
			out=out .. tostring(table.concat(newt, " ")) .. "\n"
		end,
		select = select,
		setfenv = function(func,env)
			if tsbox[func] then
				return false, "Nope."
			end
			return setfenv(func, env)
		end,
		tonumber = tonumber,
		tostring = tostring,
		type = type,
		xpcall = xpcall,
		setmetatable = function(i, x)
			if i == sbox or i == _G then
				error("Not allowed.")
			end
			setmetatable(i, x)
		end,
		unpack = unpack,
		rawget = rawget,
		rawset = rawset,
		rawequal = rawequal,
		os ={
			clock = os.clock,
			date = os.date,
			difftime = os.difftime,
			exit = function()
				error()
			end,
			time = os.time,
		},
		io = {
			write = function(...)
				out = out..table.concat({...})
			end,
		},
		coroutine = coroutine,
		channel = "",
		nick = "",
		pcall = pcall,
		username = username,
		string=string,
	}
	for k, v in pairs({
		math = math,
		table = table
	})
	do
		sbox[k] = {}
		for n, l in pairs(v) do
			sbox[k][n] = l
		end
	end
	sbox["math"]["round"] = (function(num, idp)
		local mult = 10^(idp or 0)
		return math.floor(num * mult + 0.5) / mult
	end)
	sbox["math"]["signum"] = (function(f)
		return f == 0 and 1 or f/math.abs(f)
	end)
	for k, v in pairs(sbox) do
		if type(v) == "table" then
			for n, l in pairs(v) do
				if type(v) == "function" then
					tsbox[l] = true
				end
			end
		elseif type(v) == "function" then
			tsbox[v] = true
		end
	end
	sbox._G = sbox
end

_M.reset()

_M.eval = function(txt, extravals)
	out = ""
	if extravals then
		for k, v in pairs(extravals) do
			sbox[k] = v
		end
	end
	if jit then
		jit.off()
	end
	local func, err = loadstring("return " .. txt, "=lua")
	if not func then
		func, err = loadstring(txt, "=lua")
		if not func then
			return nil, err:gsub("^[\r\n]+", ""):gsub("[\r\n]+$", ""):gsub("[\r\n]+", " | "):sub(1,440)
		end
	end
	local func = coroutine.create(setfenv(func, sbox))
	debug.sethook(func, function()
		debug.sethook(func)
		debug.sethook(func, function()
			error("Error: Took too long.", 0)
		end, "", 1)
		error("Error: Took too long.", 0)
	end, "", 20000)
	local res = {coroutine.resume(func)}
	if jit then
		jit.on()
	end
	return res
end

_M.eval_textres = function(txt, extravals)
	out = ""
	if extravals then
		for k, v in pairs(extravals) do
			sbox[k] = v
		end
	end
	if jit then
		jit.off()
	end
	local func, err = loadstring("return " .. txt, "=lua")
	if not func then
		func, err = loadstring(txt, "=lua")
		if not func then
			return err:gsub("^[\r\n]+", ""):gsub("[\r\n]+$", ""):gsub("[\r\n]+", " | "):sub(1,440)
		end
	end
	local func = coroutine.create(setfenv(func, sbox))
	debug.sethook(func, function()
		debug.sethook(func)
		debug.sethook(func, function()
			error("Error: Took too long.", 0)
		end, "", 1)
		error("Error: Took too long.", 0)
	end, "", 20000)
	local res = {coroutine.resume(func)}
	local o
	for l1 = 2, #res do
		o = (o or "") .. tostring(res[l1]) .. "\n"
	end
	if jit then
		jit.on()
	end
	return string.gsub(out .. (o or "nil"), "[\r\n]+$", "")
end


return _M
