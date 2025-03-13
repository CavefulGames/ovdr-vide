local abs = math.abs
local atan2 = math.atan2
local ceil = math.ceil
local clamp = math.clamp
local floor = math.floor
local sign = math.sign

local vector_create = Vector3.new

local function vector_magnitude(vec: Vector3): number
	return vec.Magnitude
end

local function vector_normalize(vec: Vector3): Vector3
	return vec.Unit
end

local function vector_cross(vec1: Vector3, vec2: Vector3): Vector3
    return vec1:Cross(vec2)
end

local function vector_dot(vec1: Vector3, vec2: Vector3): number
    return vec1:Dot(vec2)
end

local function vector_angle(vec1: Vector3, vec2: Vector3, axis: Vector3?): number
    local cross = { vec1.Y * vec2.Z - vec1.Z * vec2.Y, vec1.Z * vec2.X - vec1.X * vec2.Z, vec1.X * vec2.Y - vec1.Y * vec2.X }

    local sin_vec1 = (cross[1] ^ 2 + cross[2] ^ 2 + cross[3] ^ 2) ^ 0.5
    local cos_vec1 = vec1.X * vec2.X + vec1.Y * vec2.Y + vec1.Z * vec2.Z
    local angle = atan2(sin_vec1, cos_vec1)

    if axis then
        if (cross[1] * axis.X + cross[2] * axis.Y + cross[3] * axis.Z) < 0 then
            angle = -angle
        end
    end

    return angle
end

local function vector_floor(vec: Vector3): Vector3
    return vector_create(floor(vec.X), floor(vec.Y), floor(vec.Z))
end

local function vector_ceil(vec: Vector3): Vector3
    return vector_create(ceil(vec.X), ceil(vec.Y), ceil(vec.Z))
end

local function vector_abs(vec: Vector3)
    return vector_create(abs(vec.X), abs(vec.Y), abs(vec.Z))
end

local function vector_sign(vec: Vector3): Vector3
    return vector_create(sign(vec.X), sign(vec.Y), sign(vec.Z))
end

local function vector_clamp(vec: Vector3, min: Vector3, max: Vector3): Vector3
	if min.X > max.X or min.Y > max.Y or min.Z > max.Z then
		error("invalid argument #3 to 'clamp' (max must be greater than or equal to min)")
	end

    return vector_create(clamp(vec.X, min.X, max.X), clamp(vec.Y, min.Y, max.Y), clamp(vec.Z, min.Z, max.Z))
end

-- print(vector.clamp(vector.create(10, -10, 50), vector.create(1, 1, 1), vector.create(5, 100, 100)))
-- print(vector_clamp(vector_create(10, -10, 50), vector_create(1, 1, 1), vector_create(5, 100, 100)))

local function vector_min(vector: Vector3, ...: Vector3): Vector3
    return vector:Min(...)
end

local function vector_max(vector: Vector3, ...: Vector3): Vector3
    return vector:Max(...)
end

return ({
    abs = vector_abs,
    angle = vector_angle,
    ceil = vector_ceil,
    clamp = vector_clamp,
    create = vector_create,
    cross = vector_cross,
    dot = vector_dot,
    floor = vector_floor,
    magnitude = vector_magnitude,
    max = vector_max,
    min = vector_min,
    normalize = vector_normalize,
    sign = vector_sign,

    zero = Vector3.zero,
    one = Vector3.one,
} :: any) :: typeof(vector)
