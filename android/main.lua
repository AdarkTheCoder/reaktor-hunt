local grid2D = {
	__index = function(t, i)
		t[i] = {}
		return t[i]
	end;
}

local grid = setmetatable({}, grid2D)
local finish = setmetatable({}, grid2D)
local start;

local moves = {
	U = {x=0,y=-1};
	D = {x=0,y=1};
	L = {x=-1,y=0};
	R = {x=1,y=0};
}

local miny,maxy,minx,maxx = math.huge, -math.huge, math.huge, -math.huge

for line in io.lines("input.txt") do
	local x, y, dirs = line:match("^(%d+),(%d+)(.*)$")
	x, y = tonumber(x), tonumber(y)
	grid[y][x] = true

	if dirs ~= "" then
		dirs = dirs:sub(2) .. ","
		miny,maxy,minx,maxx = math.min(miny, y), math.max(maxy, y), math.min(minx, x), math.max(maxx, x)
		for c in dirs:gmatch("(.),") do
			if moves[c] then
				y = y + moves[c].y
				x = x + moves[c].x
				grid[y][x] = true
			elseif c == "X" then
				grid[y][x] = false
			elseif c == "S" then
--				if start then assert(start.y == y and start.x == x) end
				start = {y=y,x=x}
			else --if c == "F" then
				finish[y][x] = true
			end
		end
	end
end

--[[
for y = miny, maxy do
	for x = minx, maxx do
		if y == start.y and x == start.x then
			io.write("S")
		elseif finish[y][x] then
			io.write("F")
		else
			io.write(grid[y][x] and string.char(219) or ".")
		end
	end
	io.write("\n")
end
--]]

local visited = setmetatable({}, grid2D)
local dirs = {"U", "D", "L", "R"}

local queue = {{x=start.x,y=start.y,path=""}}
local winPath

while #queue > 0 do
	-- TODO: optimize queue operations / path operations
	local cur = table.remove(queue, 1)
	if finish[cur.y][cur.x] then
		-- NOTE: early-outs here since I don't care about the length of the valid path, only that it's valid!
		winPath = cur.path
		break
	end

	local n = visited[cur.y][cur.x] or math.huge
	if grid[cur.y][cur.x] and n > #cur.path then
--		print(cur.x, cur.y)
		visited[cur.y][cur.x] = #cur.path
		for _, d in pairs(dirs) do
			table.insert(queue, {
				x = cur.x + moves[d].x;
				y = cur.y + moves[d].y;
				path = cur.path .. d
			})
		end
	end
end

print(winPath)