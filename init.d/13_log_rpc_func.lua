-- Log endpoints.

rpc.command("log", function(phonetic_name, level, message)
	logger.log(phonetic_name, level, message)
end)

rpc.command("print", function(...)
	logger.orig_print(prettify(...))
end)
