-- Essentials, basically. Handles colorful output. Yay.

event.handle("irc:other", function(server, line)
	logger.log(server, logger.normal, line)
end)

event.handle("irc:001", function(server, prefix, nick, welcome)
	logger.log(server, logger.normal, welcome)
end)

event.handle("irc:privmsg", function(server, prefix, chan, message)
	colors = colors or require("libs.ansicolors")
	if message:match("^\1ACTION (.-)\1$") then -- Action
		logger.log(server, logger.normal, colors.red.."["..chan.."] * "..colors.blue..prefix..colors.reset.." "..message:gsub("^\1ACTION (.-)\1$", function(s) return s end))
	else
		logger.log(server, logger.normal, colors.red.."["..chan.."] "..colors.blue.."<"..prefix..">"..colors.reset.." "..message)
	end
end)

event.handle("irc:notice", function(server, prefix, chan, message)
	colors = colors or require("libs.ansicolors")
	logger.log(server, logger.normal, colors.red.."--- ["..chan.."] "..colors.blue.."<"..prefix..">"..colors.reset.." "..message..colors.red.." ---" ..colors.reset)
end)

event.handle("irc:topic", function(server, prefix, chan, topic)
	colors = colors or require("libs.ansicolors")
	logger.log(server, logger.normal, colors.blue..prefix..colors.reset.." has changed topic of "..colors.red..chan..colors.reset.." to: "..topic)
end)

event.handle("irc:332", function(server, prefix, nick, chan, topic)
	colors = colors or require("libs.ansicolors")
	logger.log(server, logger.normal, "Topic of "..colors.red..chan..colors.reset..": "..topic)
end)

event.handle("irc:join", function(server, prefix, chan)
	colors = colors or require("libs.ansicolors")
	logger.log(server, logger.normal, colors.blue..prefix..colors.reset.." has joined "..colors.red..chan..colors.reset)
end)

event.handle("irc:part", function(server, prefix, chan)
	colors = colors or require("libs.ansicolors")
	logger.log(server, logger.normal, colors.blue..prefix..colors.reset.." has left "..colors.red..chan..colors.reset)
end)

event.handle("irc:nick", function(server, prefix, name)
	colors = colors or require("libs.ansicolors")
	logger.log(server, logger.normal, colors.blue..prefix..colors.reset.." is now known as "..colors.bright..colors.blue..name..colors.reset)
end)

event.handle("irc:event", function(server, message, prefix, command, chan, data)
	if not handeled[command or "placeholder"] then
		logger.log(server, logger.normal, message)
	end
end, {
	handeled = {
		["placeholder"] = true,
		["001"] = true,
		["PRIVMSG"] = true,
		["NOTICE"] = true,
		["TOPIC"] = true,
		["332"] = true,
		["JOIN"] = true,
		["PART"] = true,
		["NICK"] = true,
	}
})
