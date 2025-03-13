local function color3_new(r: number?, g: number?, b: number?): Color3
	if r then
		r *= 255
	end
	if g then
		g *= 255
	end
	if b then
		b *= 255
	end
	return Color3.new(r, g, b)
end

return {
	new = color3_new,
}
