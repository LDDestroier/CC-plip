print("plip is now downloading.")
if (not http) then error("HTTP is disabled.") end
local a = http.get("https://raw.githubusercontent.com/PyuuCH/CC-plip/master/plip.lua")
if (not a) then error("Failed to connect to github.") end
local b = a:readAll()
local c = fs.open("plip","w")
c.write(b)
c.close()
print("Done! You may now run plip as normal.")