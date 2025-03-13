local realEnum = Enum
local Enum = (setmetatable({}, {__index = function(self, key: string): Enum | {}
	local ok, value = pcall(function(): Enum
		return realEnum[key]
	end)
	if ok then
		self[key] = value
		return value
	end
	return {}
end}) :: any) :: typeof(Enum)

return Enum
