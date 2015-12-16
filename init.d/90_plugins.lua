-- Loads plugins.

local function log(level, msg)
	rpc.call("log", "PluginInit", level, msg)
end

log(logger.normal, "Loading plugins...")
local loaded, loadtime = loader.load(var.root.."/plugins.d/*")
log(logger.normal, "Done loading "..tostring(loaded).." Plugins. Took "..tostring(loadtime).."s.")
