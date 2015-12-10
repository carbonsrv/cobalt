return {
	irc = { -- List your IRC networks here.
		esper = {
			proto = "tcp",
			address = "irc.esper.net",
			port = 6667,

			nick = "Cobalt",
			user = "Cobalt",
			real = "Cobalt. Really.",

			prefix = ":",

			channels = {
				"#V"
			},
			permissions = {
				["vifino!vifino@tty.sh"] = 3,
			}
		}
	}
}
