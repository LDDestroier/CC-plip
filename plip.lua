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
local packageDirectory = "https://raw.githubusercontent.com/PyuuCH/CC-plip/master/packageList.txt"
local packages = {}


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
    local dataLines = data:split("\n")
    for index=1, #dataLines do
        local packageName = dataLines[index]:sub(1,dataLines[index]:find(",")-1)
        local packageData = textutils.unserialize(dataLines[index]:sub(packageName:len()+2))
        packages[packageName]=packageData
    end
end

