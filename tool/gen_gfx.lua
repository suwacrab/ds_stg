--|==== modules
local hexdump = require("tool/hexdump")
local csvparse = require("tool/csvparse")
--|==== vars
local dat_dir = "nitrofiles/dat"
local grit_dir = "C:/KM-20/tool/devkitPro/tools/bin/grit.exe"
--|==== functions
local function grit_cmd(args)
	local cmd = ("%s %s"):format(grit_dir,args)
	print(cmd)
	os.execute(cmd)
end

local function writebin(fname,str)
	local f = io.open(fname,"wb")
	f:write(str); f:close()
end

local function gen_gfx()
	-- arcfont
	grit_cmd("wrkdat/arcfont/arcfont2.bmp -g -gB4 -Mw 16 -Mh 16 -ftb -fh! -o nitrofiles/dat/arcfont/arcfont")
	-- tecna
	-- > 12*22 tiles high == 264
	-- > 8*22 tiles high == 176
	grit_cmd("wrkdat/tekuna/tekuna.bmp -g -gB4 -Mw 8 -Mh 176 -ftb -fh! -o nitrofiles/dat/tekuna/tekuna")
	writebin("nitrofiles/dat/tekuna/tekuna.anim.bin", csvparse.gale_f("wrkdat/tekuna/tekuna.csv"))
	-- monitor
	grit_cmd("wrkdat/palrot1/palrot1.bmp -g -gB4 -Mw 2 -Mh 2 -ftb -fh! -o nitrofiles/dat/palrot1/palrot")
end

local function build_rom()
	os.execute("make clean")
	os.execute("make")
end

gen_gfx()
build_rom()

