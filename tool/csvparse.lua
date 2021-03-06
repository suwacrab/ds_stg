--|==== modules
local hexdump = require("tool/hexdump")
--|==== int functions
local function tostr_u16(n)
	n = n & 0xFFFF
	return string.char(n&0xFF,n>>8)
end

local function tostr_u32(n)
	n = n & 0xFFFFFFFF
	return tostr_u16(n)..tostr_u16(n>>16)
end

--|==== csv functions
local function csvparse_norm(csvstr)
	local list_types = {}
	local list_data = {}
	-- > load type & data
	local types,data = csvstr:match("([^\n]+)\n(.*)")
	--print("types:",types)
	--print("data: ",data)
	-- > get types
	-- '"([^,^"]+)"' only gets the strings between quotes.
	for str in types:gmatch('"([^,^"]+)"') do
		list_types[#list_types+1] = str
		list_data[#list_data+1] = {}
		list_types[str] = #list_data
	end
	-- > get data
	-- "([^\n]+)" gets any string that isn't a newline.
	for data_str in data:gmatch("([^\n]+)") do
		local data_index = 1
		for str in data_str:gmatch('"([^,^"]+)"') do
			local dat = list_data[data_index]
			dat[#dat+1] = str
			--print(data_index,list_types[data_index],str)
			data_index = data_index+1
		end
	end
	
	return { list_types,list_data }
end

local function csvparse_gale(csvstr)
	local list_types,list_data = table.unpack(csvparse_norm(csvstr))
	local delays = {}
	local delay_dat = list_data[list_types["Delay(1/60)"]]
	local frame_cnt = #delay_dat
	-- convert delays to integers
	for i = 1,frame_cnt do
		delays[i] = tonumber(delay_dat[i])
	end
	-- convert integers to a binary string
	local binstr = {}
	-- > add the number of frames
	binstr[#binstr+1] = tostr_u32(frame_cnt)
	-- > add the delays
	for i = 1,frame_cnt do
		binstr[#binstr+1] = tostr_u16(delays[i])
	end
	-- > convert to string
	binstr = table.concat(binstr)
	print( hexdump(binstr) )
	return binstr
end

local csvparse_norm_f = function(fname)
	local f = io.open(fname,"rb")
	local csvstr = f:read("*all")
	f:close()
	return csvparse_norm(csvstr)
end

local csvparse_gale_f = function(fname)
	local f = io.open(fname,"rb")
	local csvstr = f:read("*all")
	f:close()
	return csvparse_gale(csvstr)
end

local str = [["Name","Delay(1/60)","Column","Row"
"1","31","0","0"
"2","3","0","1"
"3","3","0","2"
"4","8","0","3"
"5","4","0","4"
"6","4","0","5"
"7","4","0","6"
"8","4","0","7"
"9","4","0","8"
"10","25","0","9"
"11","4","0","10"
"12","4","0","11"
"13","6","0","12"
"14","6","0","13"
"15","8","0","14"
"16","1","0","15"
"17","8","0","16"
"18","62","0","17"
"19","4","0","18"
"20","4","0","19"
"21","4","0","20"
"22","4","0","21"]]

--csvparse_norm(str)
--csvparse_gale(str)

return { 
	norm = csvparse_norm,gale = csvparse_gale,
	norm_f = nil,gale_f = csvparse_gale_f
}
