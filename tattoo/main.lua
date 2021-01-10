local password = ""

for line in io.lines("input.txt") do
	local channel = {}
	local i = 0

	for ch in line:gmatch("........") do
		channel[i] = tonumber(ch, 2)
		i = i + 1
	end

	local pc = 0
	while not channel[channel[pc]] do
		pc = pc + 1
	end
	while channel[pc] do
		pc = channel[pc]
	end
	password = password .. string.char(pc)
end

print(password)