#!/usr/bin/env carbon
-- Cobalt

cobalt = {}
cobalt.version = "v0.01"

dofile("banner.lua")

local colors = require("libs.ansicolors")

-- Check for carbon: We need it, if we don't have it, we'll refuse to go further since it's not going to work for much longer...
if not carbon then
	print(colors.red.."Carbon not found! Get Carbon! Get it NOW!")
	os.exit(1)
end

if args[1] == nil then
	print("Usage: cobalt settings.lua")
	os.exit(1)
else
	settings = dofile(args[1])
end

-- Load libs.
thread = require("thread")
logger = require("libs.logger")
loader = require("libs.loader")

local function log(level, msg)
	rpc.call("log", "Main", level, msg)
end

logger.log("Main", logger.normal, "Loading Init files...")
local loaded, loadtime = loader.load("init.d/*")
logger.log("Main", logger.normal, "Loaded "..tostring(loaded).." Init Files. Took "..tostring(loadtime).."s.")

-- Just wait here until we get signaled that we're done.
-- To exit: rpc.call("cobalt.exit", status)
local quitcom = com.create()
pubsub.sub("cmd:cobalt.exit", quitcom)

local status = com.receive(quitcom)
log(logger.important, "Shutting down...")

-- TODO: Replace with proper shutdown stub.
os.sleep(5) -- Let cleanup and stuff happen.
log(logger.important, "Goodbye!")
os.exit(status or 0)
