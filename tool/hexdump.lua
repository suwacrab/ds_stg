function hexdump(s)
	local str = {}
	for i=1,#s,16 do str[#str+1]=("%08X "):format(i-1) 
		for b = 0,15,1 do
			if i+b>#s then str[#str+1]="   " else
			str[#str+1]=("%02X "):format(s:byte(i+b,i+b)) end
		end
		for b = 0,15 do if i+b>#s then str[#str+1]=" " else
				if s:byte(i+b,i+b)>32 then
					str[#str+1]=s:sub(i+b,i+b) else
					str[#str+1]="."
				end 
			end 
		end
		str[#str+1]="\n"
	end
	return table.concat(str)
end

-- print( "ヘックスダンプ  版 201207" )
-- print( hexdump("blah blah blah blah nyan nyan piss nyan aaaaaaaawwwwwwwawawa^_^") )
-- print( hexdump("ああいいううaaiえかかききくくけけ") )

return hexdump


