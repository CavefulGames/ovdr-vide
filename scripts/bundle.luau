local process = require("@lune/process")
local serde = require("@lune/serde")
local fs = require("@lune/fs")
local darklua = require("../lune_packages/darklua_lune")
local luauPath = require("../luau_packages/luau_path")
local Path = luauPath.Path

local ENTRY_PATH = "lib.lua"
local OUTPUT_PATH = "bundled.lua"

local result = process.spawn("dalbit", {"transpile"}, { stdio = "inherit" })
if not result.ok then
	process.exit(1)
	return
end
local dalbitToml: {
	output: string,
} = serde.decode("toml", fs.readFile("dalbit.toml"))

local input = Path.from(dalbitToml.output):join(ENTRY_PATH)
darklua.process(input:toString(), OUTPUT_PATH, {
	rules = {
		-- {
		-- 	rule = "convert_require",
		-- 	current = "path",
		-- 	target = "roblox",
		-- },
		--"remove_interpolated_string",
		--"remove_compound_assignment",
		"remove_types",
		--"remove_if_expression",
		--"remove_continue",
	},
	bundle = {
		require_mode = "path",
	},
}, {
	stdio = "inherit",
})
