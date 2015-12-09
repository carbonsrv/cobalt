-- Simple ANSI color table.

local escape = string.char(27) .. '[%dm'

return {
	-- reset
	reset      = escape:format("0"),

	-- misc
	bright     = escape:format("1"),
	dim        = escape:format("2"),
	underline  = escape:format("4"),
	blink      = escape:format("5"),
	reverse    = escape:format("7"),
	hidden     = escape:format("8"),

	-- foreground colors
	black     = escape:format("30"),
	red       = escape:format("31"),
	green     = escape:format("32"),
	yellow    = escape:format("33"),
	blue      = escape:format("34"),
	magenta   = escape:format("35"),
	cyan      = escape:format("36"),
	white     = escape:format("37"),

	-- background colors
	blackbg   = escape:format("40"),
	redbg     = escape:format("41"),
	greenbg   = escape:format("42"),
	yellowbg  = escape:format("43"),
	bluebg    = escape:format("44"),
	magentabg = escape:format("45"),
	cyanbg    = escape:format("46"),
	whitebg   = escape:format("47")
}
