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

-- Apple
local asciiapple = replace([[
        .:'
    __ :'__
 .'`  `-'  ``.
:             :
:             :
 :           :
  `.__.-.__.'
]], {
	["._-':;`"] = C.red .. "%%" .. C.reset,
})

-- Champagne
local asciimartini = replace([[
    .
  o  .
  . o
_______
\~~~~°/
 '-v-'
   |
  _|_
 `"""`
]], {
	["~.o"] = C.yellow .. "%%" .. C.reset,
	["_|`\",'-v\\/"] = C.royalblue .. "%%" .. C.reset
}):gsub("°", C.green.."°"..C.reset)

-- Coffee! =.=
local asciicoffee = [[
        (
         )
   ,.----------.
 ((|            |
 .--\          /--.
'._  '========'  _.'
   `""""""""""""`
]]

-- Bills
local asciibills = {
	["1$"] = C.green.."[̲̅$̲̅(̲̅1̲̅)̲̅$̲̅]"..C.reset,
	["5$"] = C.green.."[̲̅$̲̅(̲̅5)̲̅$̲̅]"..C.reset,
	["100$"] = C.green.."[̲̅$̲̅(̲̅ιοο̲̅)̲̅$̲̅]"..C.reset,
	["200$"] = C.green.."[̲̅$̲̅(̲̅2οο̲̅)̲̅$̲̅]"..C.reset,
}

-- emotes
local emotes = {
	yuno = "ლ(ಠ益ಠლ)",
	lenny = "( ͡° ͜ʖ ͡°)",
	pedo = "ᶘ ᵒᴥᵒᶅ",
	killerpedo = (C.bold..C.grey.."ᶘ ᵒᴥᵒᶅ"..C.reset):gsub("ᵒ", C.red.."ᵒ"..C.grey),
	cool = "(⌐■_■)",
	supercool = ("(⌐■_■)"):gsub("■", C.bold..C.yellow.."■"..C.reset)
}

-- Database-like index.
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
	lizzy = asciiheart,

	apple = asciiapple,

	martini = asciimartini,

	coffee = asciicoffee,
}

for k, v in pairs(asciibills) do
	spamtable[k] = v
end
for k, v in pairs(emotes) do
	spamtable[k] = v
end

-- Logic part.
local spamkeys = {}
local spamlist = ""
for k, _ in pairs(spamtable) do
	table.insert(spamkeys, k)
	spamlist = spamlist .. k .. " "
end

command.add("spam", function(from, chan, msg)
	if msg and (perms[from] or 0) >= 1 then
		return spam[string.lower(msg)] or "Ain't no spam like dat. Check your spamledge."
	else
		return "Available spam: " .. list
	end
end, {
	spam = spamtable,
	available = spamkeys,
	list = spamlist,
	perms = settings.permissions
})
