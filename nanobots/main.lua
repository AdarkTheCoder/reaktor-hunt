local freq_mt = {
	__index = function(t, i)
		t[i] = {c=i,n=1}
		t.sort[#t.sort + 1] = t[i]
		return t[i]
	end;
}
freq = setmetatable({sort={}}, freq_mt)

local freq_sec = setmetatable({}, {
	__index = function(t, i)
		t[i] = setmetatable({sort={}}, freq_mt)
		return t[i]
	end;
})


local prev
for line in io.lines("input.txt") do -- really only one line but I'm lazy~~
	for c in line:gmatch(".") do
		freq[c].n = freq[c].n + 1
		if prev then
			freq_sec[prev][c].n = freq_sec[prev][c].n + 1
		end
		prev = c
	end
end

local function sort(a, b)
	return a.n > b.n
end

table.sort(freq.sort, sort)
for _, v in pairs(freq_sec) do
	table.sort(v.sort, sort)
end


local password = freq.sort[1].c
prev = password

while true do
	local ch = freq_sec[prev].sort[1].c
	if ch == ";" then break end
	password = password .. ch
	prev = ch
end

print(password)