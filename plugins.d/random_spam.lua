-- Random... Spam? This can only go well.

local irccolors = require("libs.irccolors")
local C = irccolors

-- The logic behind the color replacement and stuff
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

-- Bull!
local asciibull = replace([[
(___)
(o o)_____/
 @@ `     \
  \ ____, /
  //    //
 ^^    ^^
]], {
	["o"] = C.bold .. C.red .. "%%" .. C.reset,
	["()^"] = C.bold .. C.white .. "%%" .. C.reset,
	["_/\\`,"] = C.brown .. "%%" .. C.reset,
	["@"] = C.red .. "%%" .. C.reset
})

-- Cake!
local asciicake = replace([[
  *  *  *  *
 _I__I__I__I_
(____________)
|############|
(____________)
]], {
	["I"] = C.yellow .. "%%" ..C.reset,
	["_()|"] = C.bold .. C.red .. "%%" ..C.reset,
	["*"] = C.red .. "%%" .. C.reset,
	["#"] = C.bold .. C.white .. "%%" ..C.reset
})

-- PIE!
local asciipie = replace([[
         (
          )
     __..---..__
 ,-='  /  |  \  `=-.
:--..___________..--;
 \.,_____________,./
]], {
	["\\/|"] = C.red .. "%%" .. C.reset,
	[".,-=_'`:;"] = C.brown .. "%%" .. C.reset,
	["()"] = C.grey .. "%%" .. C.reset,
})

-- Rat!
local asciirat = replace([[
(^)___(^)
 (O   O)
  \   /
  >\ /<
    *
]], {
	["\\/_()"] = C.grey .. "%%" .. C.reset,
	["><"] = C.bold .. C.black .. "%%" .. C.reset,
	["*"] = C.bold .. C.pink .. "%%" .. C.reset,
	["^"] = C.pink .. "%%" .. C.reset,
	["O"] = C.bold .. C.white .. "%%" .. C.reset
})

local asciideadrat = asciirat:gsub("O", "X")

-- Binary
local asciibinary = C.green.."01001000011001010111100100101110"..C.reset

-- Heart! For you, Lizzy :3
local asciiheart = replace([[
 .:::.   .:::.
:::::::.:::::::
:::::::::::::::
':::::::::::::'
  ':::::::::'
    ':::::'
      ':'
]], {
	[".:'"] = C.red.."%%"..C.reset
})

-- Make the spam table!
local spamtable = {
	bull = asciibull,

	pangu = asciicake,
	cake = asciicake,

	pie = asciipie,

	rat = asciirat,
	deadrat = asciideadrat,
	ratbot = asciirat,

	binary = asciibinary,

	heart = asciiheart,
	lizzy = asciiheart
}

local spamkeys = {}
local spamlist = ""
for k, _ in pairs(spamtable) do
	table.insert(spamkeys, k)
	spamlist = spamlist .. k .. " "
end

command.add("spam", function(from, chan, msg)
	if msg then
		return spam[string.lower(msg)] or "No such spaaam?!? :<"
	else
		return "Available spam: " .. list
	end
end, {
	spam = spamtable,
	available = spamkeys,
	list = spamlist
})
