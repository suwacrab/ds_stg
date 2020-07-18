local function RGB16(r,g,b,a)
	return (a*0x8000) | r | (g<<5) | (b<<10)
end

local function RGB15(r,g,b)
	return r | (g<<5) | (b<<10)
end

local function u8str_le(n)
	return string.char(n&0xFF) end
local function u16str_le(n)
	return u8str_le(n)..u8str_le(n>>8) end

local img = {}
for y = 0,15 do
	for x = 0,15 do
		img[x+y*16] = 0x8000 | RGB15(x<<1,0,y<<1)
	end
end

do local f = io.open("nitrofiles/dat/test/dummy0.dat","wb")
	for i = 0,255 do
		f:write(u16str_le(img[i]))
	end
	f:close()
end