local namespace = {}

function namespace:enumerateLibraries(data)
	local dataToReturn = {}
	for i,v in pairs(data) do
		print(v.Name)
		for a, lib in pairs(v:GetChildren()) do
			if lib.ClassName == "ModuleScript" then
				dataToReturn[lib.Name] = require(lib)
			end
		end
	end
	return dataToReturn
end

return namespace