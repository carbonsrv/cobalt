-- Z-Machine Games. Yay.
if settings.zmachine then
	local dfrotz_path = settings.zmachine.dfrotz_path or "dfrotz"

	command.add("zm-load", function(from, chan, args, server, replyargs)
		if perms[from] >= 2 then
			-- Load dfrotz
			if not (type(args) == "string" and replyargs) then
				return "Usage: zm-load <IF path>"
			end

			local cmd = exec.exec("./tools/faketty", dfrotzpath, "-p", "-w", "100", args)
			local cmdkey = "cobalt:zmachine:cmd:"..server..":"..chan

			local oldcmd = kvstore.get(cmdkey)
			if oldcmd then
				oldcmd.Kill()
			end

			print("Key: "..cmdkey)
			kvstore.set(cmdkey, cmd)
			os.sleep(0.5) -- check if it actually ran
			local didcrash = cmd.State() and cmd.State().Exited()
			if not didcrash then
				-- Store state
				kvstore.set(cmdkey, cmd)

				-- Lets go, baby!
				thread.spawn(function()
					local ltn12 = require("ltn12")
					local event = require("libs.event")
					local rpc = require("libs.multirpc")
					local prettify = require("prettify")

					function print(...)
						rpc.call("log.normal", "Z-Machine", prettify(...))
					end

					-- Pump it through, babe.
					local buff = "" -- for later
					local rlen = #replyargs
					ltn12.pump.all(
						exec.source_using(cmd),
						function(block)
							if not block then
								return
							end

							local tmp = buff .. block
							buff = string.gsub(tmp, "(.-)[\r\n]", function(line)
								if line ~= "" then
									-- TODO: replace these hacks with something proper.
									if line:match("^%>") then -- disable the echo thing
										return ""
									elseif line:match("to begin]") or line:match("to continue]") or line:match("%*%*%*MORE%*%*%*") or line:match("press a key") or line:match("any other") then
										cmd.Write_Stdin("\n")
										return ""
									else
										replyargs[rlen + 1] = line
										print(line)
										rpc.call(unpack(replyargs))
									end
								end
								return ""
							end)
							return 1
						end
					)
				end)
			else
				return "Error launching dfrotz"
			end
		else
			return "You are not permitted to start the Z-Machine."
		end
	end, {
		perms = settings.permissions,
		dfrotzpath = dfrotz_path,
	}, true)

	command.add("zm-stop", function(from, chan, args, server) -- stopping Z-Machine, not sure why you would do that. Only not fun persons do that, meanie. :(
			if perms[from] >= 2 then
				local key = "cobalt:zmachine:cmd:"..server..":"..chan
				local zm = kvstore.get(key)
				if zm then
					zm.Kill()
					kvstore.del(key)
					return "Killed."
				else
					return "No Z-Machine running."
				end
			else
				return "You are not permitted to stop the Z-Machine."
			end
	end, {
		perms = settings.permissions,
	})

	command.add("zm", function(from, chan, args, server)
		local zm = kvstore.get("cobalt:zmachine:cmd:"..server..":"..chan)
		if zm then
			if args then
				zm.Write_Stdin(args.."\n")
			else
				return "Usage: zm <action>"
			end
		else
			return "No Z-Machine running. Ask a bot administrator to start a game for you."
		end
	end)
end
