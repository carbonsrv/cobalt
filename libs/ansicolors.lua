-- Simple ANSI color table.

--[[
	The MIT License (MIT)

	Copyright (c) 2015 - 2016 Adrian Pistol

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]

local escape = string.char(27) .. '[%dm'

return {
	-- version info
	version    = "0.0.1",
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
