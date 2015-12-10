-- Loads plugins.

local function log(level, msg)
	logger.log("PluginInit", level, msg)
end

log(logger.normal, "Loading plugins...")
local loaded, loadtime = loader.load("plugins.d/*")
log(logger.normal, "Done loading "..tostring(loaded).." Plugins. Took "..tostring(loadtime).."s.")
