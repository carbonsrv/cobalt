-- Simple IRC color table.
local c = "\x03"
return {
	-- reset
	reset      = "\x0F",

	-- misc
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
