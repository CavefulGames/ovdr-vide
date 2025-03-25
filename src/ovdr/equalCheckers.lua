local areDataTypesEqual = {}

function areDataTypesEqual.Vector3(v1: Vector3, v2: Vector3)
	return v1.X == v2.X and v1.Y == v2.Y and v1.Z == v2.Z
end

function areDataTypesEqual.UDim2(u1: UDim2, u2: UDim2)
	return areDataTypesEqual.UDim(u1.X, u2.X) and areDataTypesEqual.UDim(u1.Y, u2.Y)
end

local function cfComponents(cf: CFrame)
	local xVec = cf.XVector
	local yVec = cf.YVector
	local zVec = cf.ZVector
	local pos = cf.Position
	return pos.X, pos.Y, pos.Z, xVec.X, yVec.X, zVec.X, xVec.Y, yVec.Y, zVec.Y, xVec.Z, yVec.Z, zVec.Z
end

function areDataTypesEqual.CFrame(cf1: CFrame, cf2: CFrame)
	local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cfComponents(cf1)
	local x2, y2, z2, r200, r201, r202, r210, r211, r212, r220, r221, r222 = cfComponents(cf2)
	return x == x2 and y == y2 and z == z2 and r00 == r200 and r01 == r201 and r02 == r202 and r10 == r210 and r11 == r211 and r12 == r212 and r20 == r220 and r21 == r221 and r22 == r222
end

function areDataTypesEqual.Color3(c1: Color3, c2: Color3)
	return c1.R == c2.R and c1.G == c2.G and c1.B == c2.B
end

function areDataTypesEqual.UDim(u1: UDim, u2: UDim)
	return u1.Scale == u2.Scale and u1.Offset == u2.Offset
end

return areDataTypesEqual
