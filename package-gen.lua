function string.split (str, sep) -- Split string
	local results = {}
	for v in string.gmatch(str, "([^"..sep.."]+)") do
		results[#results+1] = v:sub(1,v:len()-1)
	end
	return results
end
xHandler = io.open("packageList_nc.txt","rb")
data = xHandler:read("*a")
xHandler:close()

local end_data = ""

lines = data:split("\n")
print("Lines = " .. #lines)
for index=1, math.floor(#lines/7) do
    local line_offset = (index-1)*7
    local ref = lines[1 + line_offset]
    local name = lines[2 + line_offset]
    local author = lines[3 + line_offset]
    local download = lines[4 + line_offset]
    local location = lines[5 + line_offset]
    local autorun = lines[6 + line_offset]
    local blank = lines[7 + line_offset]
    local ed = ref .. ",{[\"name\"]=\"" .. name .. "\",[\"author\"]=\"" .. author .. "\",[\"downloadURL\"]=\"" .. download .. "\",[\"suggestedLocation\"]=\"" .. location .. "\",[\"launchAfterDownload?\"]=" .. autorun .. "}\n"
    end_data=end_data .. ed
    print(ed)
end

ak=io.open("packageList.txt","wb")
ak:write(end_data)
ak:close()

io.read()