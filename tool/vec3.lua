--|==== vars ==================|
local pi,rad,deg = math.pi,math.rad,math.deg
local sin,cos,tan = math.sin,math.cos,math.tan
local flr,abs,sqrt = math.floor,math.abs,math.sqrt
--|==== metatable =============|
local vec3 = {}
vec3.__index = vec3

local function new(x,y,z)
	return setmetatable(
		{x=x or 0,y=y or 0,z=z or 0},
		vec3
	)
end

--|==== arithmetic ============|
vec3.__unm = function(v)
	return new(-a.x,-a.y,-a.z) end
vec3.__add = function(a,b)
	return new(a.x+b.x,a.y+b.y,a.z+b.z) end
vec3.__sub = function(a,b)
	return a + (-b) end
vec3.__mul = function(a,b)
	return new(a.x*b.x,a.y*b.y,a.z*b.z) end
vec3.__div = function(a,b)
	return new(a.x/b.x,a.y/b.y,a.z/b.z) end
--|==== methods ===============|
vec3.unpack = function(v)
	return v.x,v.y,v.z end
vec3.__tostring = function(v)
	return ("[%.4f,%.4f,%.4f]"):format(v:unpack())
end

vec3.len = function(v)
	return sqrt(v.x*v.x+v.y*v.y+v.z*v.z)
end
vec3.unit = function(v,n)
	return v:divN(v:len())
end
vec3.mulN = function(v,n)
	return new(v.x*n,v.y*n,v.z*n) end
vec3.divN = function(v,n)
	return new(v.x/n,v.y/n,v.z/n) end

return setmetatable(
	{ new = new },
	{
		__call = function(_,...)
			return new(...)
		end
	}
)