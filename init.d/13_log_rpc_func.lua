-- Log endpoints.

rpc.command("log", function(phonetic_name, level, message)
	logger.log(phonetic_name, level, message)
end)

-- The three log levels.
rpc.command("log.normal", function(phonetic_name, message)
	logger.log(phonetic_name, logger.normal, message)
end)
rpc.command("log.important", function(phonetic_name, message)
	logger.log(phonetic_name, logger.important, message)
end)
rpc.command("log.critical", function(phonetic_name, message)
	logger.log(phonetic_name, logger.critical, message)
end)

-- This one is basically critical + exit with code 1.
rpc.command("log.fatal", function(phonetic_name, message)
	logger.log(phonetic_name, logger.critical, message)
	rpc.call("cobalt.exit", 1)
end)

rpc.command("print", function(...)
	logger.orig_print(prettify(...))
end)
