-- stripdefines.lua

for line in  io.lines("xproto.lua") do
	if line:find("//#define") then
		print(line)
	end
end

