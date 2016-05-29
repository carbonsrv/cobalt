-- Z-Machine Games. Yay.
if settings.zmachine then
	local dfrotz_path = settings.zmachine.dfrotz_path or "dfrotz"

	command.add("zm-load", function(from, chan, args, server, replyargs)
		if perms[from] >= 2 then
			-- Load dfrotz
			if not (type(args) == "string" and replyargs) then
				return "Usage: zm-load <IF path>"
			end

			local zm = exec.exec("./tools/faketty", dfrotzpath, "-p", "-w", "180", args)
			local zmkey = "cobalt:zmachine:zm:"..server..":"..chan
			local lockey = "cobalt:zmachine:loc:"..server..":"..chan
			local scorekey = "cobalt:zmachine:score:"..server..":"..chan
			local moveskey = "cobalt:zmachine:moves:"..server..":"..chan

			local oldzm = kvstore.get(zmkey)
			if oldzm then
				oldzm.Kill()
			end

			print("Key: "..zmkey)
			kvstore.set(zmkey, zm)
			os.sleep(0.5) -- check if it actually ran
			local didcrash = zm.State() and zm.State().Exited()
			if not didcrash then
				-- Store state
				kvstore.set(zmkey, zm)

				-- Lets go, baby!
				thread.spawn(function()
					local ltn12 = require("ltn12")
					local event = require("libs.event")
					local rpc = require("libs.multirpc")
					local prettify = require("prettify")
					local irccolors = require("libs.irccolors")

					function print(...)
						rpc.call("log.normal", "Z-Machine", prettify(...))
					end

					-- Pump it through, babe.
					local buff = "" -- for later

					local rlen = #replyargs
					ltn12.pump.all(
						exec.source_using(zm),
						function(block)
							if not block then
								return
							end

							-- TODO: replace these hacks with something proper.
							local tmp = buff .. block
							if tmp:match("key to continue") or tmp:match("%*%*%*MORE%*%*%*") or tmp:match("press a key") then -- prompts
								print("Found: "..tmp)
								zm.Write_Stdin("\n")
								buff = ""
							else
								buff = string.gsub(tmp, "(.-)[\r\n]", function(line)
									if line ~= "" then
										-- Status parsing
										local loc, score, moves = line:match("^ +(.-) +Score: (%d+) +Moves: (%d+)")
										if loc and score and moves then -- score
											-- Save location, score and ammount of moves
											kvstore.set(lockey, loc)
											kvstore.set(scorekey, score)
											kvstore.set(moveskey, moves)

											return irccolors.bold .. "> "..loc.." <"
										elseif line:match("^%>") or line:match("^%. *$") or line:match("^ +$") then -- disable the echo thing, random dots followed by spaces, just spaces, generally stuff useless
											return ""
										elseif line:match("key to continue") or line:match("%*%*%*MORE%*%*%*") or line:match("press a key") then -- prompts
											--zm.Write_Stdin("\n")
											return ""
										else
											line = line:gsub(" +$", "")
											replyargs[rlen + 1] = line
											print(line)
											rpc.call(unpack(replyargs))
										end
									end
									return ""
								end)
							end
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
				local key = "cobalt:zmachine:zm:"..server..":"..chan
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

	command.add("zm-status", function(from, chan, args, server) -- interaction
		local prefix = "cobalt:zmachine:"
		local postfix = ":"..server..":"..chan
		local zm = kvstore.get(prefix.."zm"..postfix)
		if zm then
			local irccolors = require("libs.irccolors")
			local loc = kvstore.get(prefix.."loc"..postfix)
			local score = kvstore.get(prefix.."score"..postfix)
			local moves = kvstore.get(prefix.."moves"..postfix)
			return "Z-Machine running. Currently at "..irccolors.bold..loc..irccolors.bold.." with a score of "..tostring(score)..", having done "..tostring(moves).." moves."
		else
			return "No Z-Machine running. Ask a bot administrator to start a game for you."
		end
	end)

	command.add("zm", function(from, chan, args, server) -- interaction
		local zm = kvstore.get("cobalt:zmachine:zm:"..server..":"..chan)
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
