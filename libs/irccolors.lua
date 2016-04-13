-- Simple IRC color table.

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

local c = "\x03"

return {
	-- version info
	version    = "0.0.1",
	-- reset
	reset      = "\x0F",

	-- misc
	escape    = c,
	bold      = "\x02",
	italic    = "\x1D",
	underline = "\x1F",
	swap      = "\x16",

	-- colors
	white     = c.."00",
	black     = c.."01",
	blue      = c.."02",
	green     = c.."03",
	red       = c.."04",
	brown     = c.."05",
	purple    = c.."06",
	orange    = c.."07",
	yellow    = c.."08",
	lime      = c.."09",
	teal      = c.."10",
	cyan      = c.."11",
	royalblue = c.."12",
	pink      = c.."13",
	grey      = c.."14",
	lightgrey = c.."15"
}
