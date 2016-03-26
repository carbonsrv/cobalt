-- LuaForth Sandbox.

forth_env = {
	["%L"] = {
		_fn=function(stack, env, str)
			sbx = sbx or require("libs.luasbx")
			local extra = {
				["from"] = env.from,
				["chan"] = env.chan
			}
			local r = sbx.eval_textres(str, extra)
			return r
		end,
		_parse = "line"
	},
	["[L"] = {
		_fn=function(stack, env, str)
			sbx = sbx or require("libs.luasbx")
			local extra = {
				["from"] = env.from,
				["chan"] = env.chan
			}
			local r = sbx.eval_textres(str, extra)
			return r
		end,
		_parse = "endsign",
		_endsign = "L]"
	},
	["("] = {
		_fn=function()end,
		_parse="endsign",
		_endsign=")"
	}
}

-- function creation!
forth_env[":"] = {
	_fn = function(stack, env, fn)
		local nme, prg = string.match(fn, "^(.-) (.-)$")
		forth_env[nme] = {
			_fn = function(stack, env)
				return luaforth.eval(prg, env, stack)
			end,
			_fnret = "newstack"
		}
	end,
	_parse = "endsign",
	_endsign = ";"
}
forth_env[":[L"] = {
	_fn = function(stack, env, fn)
		local nme, argno, prg = string.match(fn, "^(.-) (%d-) (.-)$")
		forth_env[nme] = {
			_fn = function(stack, env, ...)
				sbx = sbx or require("libs.luasbx")
				local extra = {
					["from"] = env.from,
					["chan"] = env.chan,
					["arg"] = {...}
				}
				local r, e = sbx.eval(prg, extra)
				if e then
					error(e, 0)
				end
				return unpack(r)
			end,
			_args=tonumber(argno)
		}
	end,
	_parse = "endsign",
	_endsign = "L];"

}

command.add("forth", function(from, chan, args)
	if not args then
		return "Usage: forth <code>"
	end
	forth_env["from"] = from
	forth_env["chan"] = chan
	luaforth = require("libs.luaforth.luaforth")
	local success, retval = pcall(luaforth.eval, args, forth_env)
	if not success then
		return "> " .. retval:gsub("^[\r\n]+", ""):gsub("[\r\n]+$", ""):gsub("[\r\n]+", " | "):sub(1,440)
	else
		return "> " .. retval[#retval] and tostring(retval[#retval]) or "null"
	end
end, {
	["forth_env"] = forth_env
}, true)
