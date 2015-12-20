-- Random... Spam? This can only go well.

local irccolors = require("libs.irccolors")
local C = irccolors

local asciibull = [[
(___)
(o o)_____/
 @@ `     \
  \ ____, /
  //    //
 ^^    ^^
]]

local function replace(str, chars, replacement)
	if type(chars) == "table" then
		local r = str
		for k, v in pairs(chars) do
			r = replace(r, k, v)
		end
		return r
	else
		local replmap = {}
		tostring(chars):gsub("(.)", function(c)
			replmap[c] = true
		end)
		return str:gsub("(.)", function(c)
			if replmap[c] then
				return replacement:gsub("%%%%", c)
			end
		end)
	end
end

local asciibull = replace(asciibull, {
	["o"] = C.bold .. C.red .. "%%" .. C.reset,
	["()^"] = C.bold .. C.white .. "%%" .. C.reset,
	["_/\\`,"] = C.brown .. "%%" .. C.reset,
	["@"] = C.red .. "%%" .. C.reset
})

command.add("bull", function()
	return bull
end, {
	bull = asciibull
})


local asciicake = [[
 _I__I__I__I_
(____________)
|############|
(____________)
]]

local asciicake = replace(asciicake, {
	["I"] = C.yellow .. "%%" ..C.reset,
	["_()|"] = C.bold .. C.red .. "%%" ..C.reset,
	["#"] = C.bold .. C.white .. "%%" ..C.reset,
})

command.add("cake", function()
	return cake
end, {
	cake = asciicake
})

command.add("pangu", function()
	return cake
end, {
	cake = asciicake
})
