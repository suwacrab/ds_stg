--|==== vars ==================|
local pi,rad,deg = math.pi,math.rad,math.deg
local sin,cos,tan = math.sin,math.cos,math.tan
local flr,abs,sqrt = math.floor,math.abs,math.sqrt
--|==== modules ===============|
local vec3 = require("tool/vec3")
--|==== metatable =============|
local mat4 = {}
mat4.__index = mat4

local function new(x,y,z)
	local m = {
		x or { 1,0,0, 0};
		y or { 0,1,0, 0};
		z or { 0,0,1, 0};
		{ 0,0,0,1 };
	}
	return setmetatable(m,mat4)
end

--|==== arithmetic ============|
mat4.__mul = function(a,b)
	if b.z then 
		-- if its a vector, it has a Z axis, probably
		-- if it doesnt then who cares ill rewrite this routine later
		-- rotating a matrix by a vector can be done
		-- with ( pos +  xv*b.x + yv*b.y + zv*b.z )
		local xv = vec3(a[1][1],a[1][2],a[1][3])
		local yv = vec3(a[2][1],a[2][2],a[2][3])
		local zv = vec3(a[3][1],a[3][2],a[3][3])
		local pos = vec3(a[1][4],a[2][4],a[3][4])
		
		return pos + xv:mulN(b.x) + yv:mulN(b.y) + zv:mulN(b.z)
	end
	-- this code below should only run if it's a matrix.
	local m = new(); for i = 1,4 do m[i] = {0,0,0,0} end
	for y = 1,4 do
		for x = 1,4 do
			for p = 1,4 do
				m[y][x] = m[y][x] + a[y][p] * b[p][x]
			end
		end
	end
	return m
end
--|==== methods ===============|
mat4.__tostring = function(m)
	local str = {}
	local sign_lut = { [true]="-",[false]="+" }
	for i = 1,3 do
		local n = { table.unpack(m[i]) }
		for i = 1,4 do 
			n[i] = ("%s%.4f"):format(sign_lut[n[i]<0],abs(n[i]))
		end
		local v = ("[%s,%s,%s,%s]"):format(table.unpack(n))
		str[#str+1] = v
	end
	return table.concat(str,"\n")
end

local m1 = new(
	{ 1,0,0,0 },
	{ 0,0,-1,0 },
	{ 0,1,0,0 }
)
local v1 = vec3.new(0,0,1)
io.write("ｍａｔｒｉｘ：\n",tostring(m1),"\n")
io.write("ｖｅｃｔｏｒ：\n",tostring(v1),"\n")
io.write("ｍ＊ｖ：\n",tostring(m1*v1),"\n")
io.write("ｉｄｅｎｔｉｔｙ＊ｍ：:\n",tostring(new() * m1),"\n")

return mat4
