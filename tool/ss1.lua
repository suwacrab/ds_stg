--|==== modules ===============|
local hexdump = require("tool/hexdump")
--|==== misc functions ========|
local function tostr_u8(b)
	return string.char(b&0xFF) end
local function tostr_u16(w)
	return tostr_u8(w)..tostr_u8(w>>8) end
local function tostr_u32(l)
	return tostr_u16(l)..tostr_u16(l>>16) end

--|==== lookup tables =========|
local lut_opcode = {
	[0] = 
	"ADD";
	"ADDI";
	"SUB";
	"SUBI";
}
for i,v in next,lut_opcode do
	lut_opcode[v] = i end

local lut_reg = {
	["A"]=0,["B"]=1;
	["C"]=2,["D"]=3;
	["E"]=4,["F"]=5;
	["X"]=6,["Y"]=7;
}
--|==== asm functions =========|
local function tonum_tokn(str)
	if str:sub(1,1) == "$" then
		return tonumber(str:sub(2),16)
	elseif str:sub(1,1) == "#" then
		return tonumber(str:sub(2),10)
	end
end

local function asm_compile(asm)
	local token_pattern = "([%w%$#]+)"
	local tokens = {}
	print("asm:")
	for token in asm:gmatch(token_pattern) do
		-- > if it's an opcode name...
		if lut_opcode[token] then
			print(token,lut_opcode[token])
			tokens[#tokens+1] = tostr_u8(lut_opcode[token])
		-- > if it's a register name...
		elseif lut_reg[token:upper()] then
			print(token,lut_reg[token:upper()])
			tokens[#tokens+1] = tostr_u8(lut_reg[token:upper()])
		-- > if it's a number...
		else
			print(token,tonum_tokn(token))
			tokens[#tokens+1] = tostr_u32(tonum_tokn(token))
		end
	end

	return table.concat(tokens)
end

local asm = [[
	ADDI $0200 A
	SUBI $0400 B
	ADD A C
	ADD B D
]]
local bin = asm_compile(asm)
print( hexdump(bin) )

