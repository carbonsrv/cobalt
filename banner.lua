-- The Cobalt banner. Oh boy, that was fun to make.

local colors = require("libs.ansicolors")
print(colors.bright .. colors.black .. [[
+--------------------------------------------------+
| ]] .. colors.reset .. colors.blue .. [[░█▀▀░█▀█░█▀▄░█▀█░█░░░▀█▀]] .. colors.bright ..colors.black .. [[ | ]] .. colors.reset .. [[Cobalt                ]] .. colors.bright .. colors.black .. [[|
| ]] .. colors.reset .. colors.blue .. [[░█░░░█░█░█▀▄░█▀█░█░░░░█░]] .. colors.bright ..colors.black .. [[ | ]] .. colors.reset .. [[version ]]..cobalt.version..[[         ]] .. colors.bright .. colors.black .. [[|
| ]] .. colors.reset .. colors.blue .. [[░▀▀▀░▀▀▀░▀▀░░▀░▀░▀▀▀░░▀░]] .. colors.bright ..colors.black .. [[ | ]] .. colors.reset .. [[(c) vifino            ]] .. colors.bright .. colors.black .. [[|
+--------------------------------------------------+
]] .. colors.reset)
