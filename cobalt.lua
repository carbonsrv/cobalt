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

-- Load libs.
logger = require("libs.logger")
loader = require("libs.loader")

local function log(level, msg)
	logger.log("Main", level, msg)
end

log(logger.normal, "Loading init files...")
local loadtime = loader.load("init.d/*")
log(logger.normal, "Done loading. Took "..tostring(loadtime).."s.")

-- Just wait here until we get signaled that we're done.
local quitcom = com.create()
pubsub.sub("cobalt.quit", quitcom)

local status = com.receive(quitcom)
log(logger.important, "Shutting down...")

-- TODO: Replace with proper shutdown stub.
os.exit(status or 0)
