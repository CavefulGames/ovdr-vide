local Enum = require("./polyfill/Enum")
local vector = require("./polyfill/vector")

local defaults = {
    Part = {
        Material = Enum.Material.Plastic,
        Size = vector.create(1, 1, 1),
        Anchored = true
    },

    BillboardGui = {
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    },

    CanvasGroup = nil,

    Frame = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0
    },

    ImageButton = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        AutoButtonColor = false
    },

    ImageLabel = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
    },

    ScreenGui = {
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    },

    ScrollingFrame = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        ScrollBarImageColor3 = Color3.new(0, 0, 0)
    },

    SurfaceGui = {
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

        PixelsPerStud = 50,
        SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    },

    TextBox = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Font = Enum.Font.SourceSans,
        Text = "",
        TextColor3 = Color3.new(0, 0, 0)
    },

    TextButton = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Font = Enum.Font.SourceSans,
        Text = "",
        TextColor3 = Color3.new(0, 0, 0)
    },

    TextLabel = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        Font = Enum.Font.SourceSans,
        Text = "",
        TextColor3 = Color3.new(0, 0, 0)
    },

    UIListLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder
    },

    UIGridLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder
    },

    UITableLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder
    },

    UIPageLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder
    },

    VideoFrame = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0
    },

    ViewportFrame = {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0
    }
}

for className, props in (defaults :: any) :: { [string]: { [string]: any } } do
	local ok, instance = pcall(Instance.new, className)
	if not ok then
		defaults[className] = nil
		continue
	end
	for key, _ in props do
		if not pcall(function()
			return instance[key]
		end) then
			props[key] = nil
		end
	end
end

return defaults
