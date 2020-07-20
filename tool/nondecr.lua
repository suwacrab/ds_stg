--look way down!
 
local function check(test) 
 
local function uglytest(arr)
    local function nondecreasing(arr)
        for i = 1, #arr - 1 do
            if arr[i] > arr[i + 1] then
                return false
            end
        end
 
        return true
    end
 
    for j = 1, #arr do
        local val = table.remove(arr, j)
        if not nondecreasing(arr) then
            table.insert(arr, j, val)
        else
            return true
        end
    end
 
    return false
end
 
assert(test({ }) == true)
 
assert(test({ 0 }) == true)
 
assert(test({ 0, 0 }) == true)
assert(test({ 0, 1 }) == true)
assert(test({ 1, 0 }) == true)
 
for a = 0, 2 do for b = 0, 2 do for c = 0, 2 do
    print(a, b, c, test({ a, b, c }))
    assert(test({ a, b, c }) == uglytest({ a, b, c }))
end end end
for a = 0, 3 do for b = 0, 3 do for c = 0, 3 do for d = 0, 3 do
    print(a, b, c, d, test({ a, b, c, d }))
    assert(test({ a, b, c, d }) == uglytest({ a, b, c, d }))
end end end end
 
for a = 0, 4 do for b = 0, 4 do for c = 0, 4 do for d = 0, 4 do for e = 0, 4 do
    print(a, b, c, d, e, test({ a, b, c, d, e }))
    assert(test({ a, b, c, d, e }) == uglytest({ a, b, c, d, e }))
end end end end end
 
end


function check_decr(t,didit)
	local nondecr = false
	for i = 2,#t do
		for j = i-1,1,-1 do
			print(t[i],t[j],t[j]<=t[i])
			nondecr = t[j]<=t[i]
			if not nondecr then
				if didit then return false end
				t[j] = t[i]
				return check_decr(t,true)
			end
		end
	end
	return true
end
function CanBeNonDecreasing(t)
	local nondecr = false
	if(#t<=1) then return true end
	return check_decr(t,false)
	
	--return nondecr
end

check(CanBeNonDecreasing) --pass your function to this