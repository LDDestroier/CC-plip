--[[
MIT License

Copyright (c) 2016 Christopher H.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local varargs = {...}
local constructedArgs = {}
local constructableArgs = {}
for key, value in pairs(varargs) do
    if (value == "install" or value == "to") then
        constructableArgs[value] = key
    elseif (value == "no-autorun") then
        constructedArgs["no-autorun"]=true
    end
end
for key, value in pairs(constructableArgs) do
    constructedArgs[key]=varargs[value+1]
end

local packageDirectory = "https://raw.githubusercontent.com/PyuuCH/CC-plip/master/packageList.txt"


function string.split (str, sep) -- Split string
	local results = {}
	for v in string.gmatch(str, "([^"..sep.."]+)") do
		results[#results+1] = v
	end
	return results
end

function fetchPackageList ()
    if http == nil then
        error("HTTP is not enabled.")
    end
    local httpHandler = http.get(packageDirectory)
    if (httpHandler == nil) then -- Could not fetch.
        error("Failed to connect to the package directory.")
    end
    local data = httpHandler:readAll()
    if (httpHandler.close) then httpHandler:close() end
    local dataLines = string.split(data,"\n") -- CC doesn't support the object oriented stuff pure lua does.
    for index=1, #dataLines do
        local packageName = dataLines[index]:sub(1,dataLines[index]:find(",")-1)
        local packageData = textutils.unserialize(dataLines[index]:sub(packageName:len()+2))
        plip_packages[packageName]=packageData
    end
end

if (plip_packages == nil) then
    plip_packages = {}
    print("[PROCESS] Fetching package list...")
    fetchPackageList()
    print("[OK] Done!")
end

local function print_help ()
    print("plip is a package manager designed by Pyuu for CC.")
    print("To use it, for example, do \"plip install firewolf\"!")
    print("If you are an advanced user, please see the documentation at\nhttps://github.com/PyuuCH/CC-plip/wiki")
end

if (#varargs == 0) then
    print_help()
else
    if (constructedArgs["install"] == nil) then
        print_help()
    else
        local cPackage = plip_packages[constructedArgs["install"]]
        if (cPackage == nil) then
            print("[BAD] No such package (\"" .. tostring(constructedArgs["install"]) .. "\") found.")
        else
            local fail = false
            print("[OK] Found package \"" .. tostring(cPackage.name) .. "\" by " .. tostring(cPackage.author))
            print("[OK] Downloading package \"" .. tostring(cPackage.name) .. "\"")
            local httpHandler = http.get(cPackage.downloadURL)
            if (httpHandler == nil) then
                print("[BAD] Failed to connect to the package's repository.")
                fail = true
            else
                local data = httpHandler:readAll()
                httpHandler:close()
                local destination = cPackage.suggestedLocation
                
                if (constructedArgs["to"]) then
                    destination = constructedArgs.to
                end
                local dFile = fs.open(destination,"w")
                dFile.write(data)
                dFile.close()
                print("[OK] Downloaded to \"" .. tostring(destination) .. "\"")
                if (cPackage["launchAfterDownload?"] == true) then
                    if (constructedArgs["no-autorun"] == true) then
                        print("[OK] The package downloaded wants to launch but due to no-autorun it will not.")
                    else
                        print("[OK] This package will now run.")
                        dofile(destination)
                    end
                end
            end

            if (fail == true) then
                print("[ERROR] Failed to install package.")
            else
                print("[OK] Completed installation without errors.")
            end
        end
    end
end

