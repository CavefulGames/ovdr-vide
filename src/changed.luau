local action = require "./action"()
local cleanup = require "./cleanup"

local function changed<T>(property: string, callback: (T) -> ())
    return action(function(instance)
        local con = instance.Changed:Connect(function(changedProperty)
			if changedProperty ~= property then
				return
			end
            callback((instance :: any)[property])
        end)

        cleanup(function()
            con:Disconnect()
        end)

        callback((instance :: any)[property])
    end)
end

return changed
