local self = {}

function self:disableSSAroundBuilding(building)
	local hb = building.Hitbox
	local config = building.Configuration
	if config.IsCompleted.Value then
		if workspace.Sandstorm.Value then
			local region = Region3.new(hb.Position-(hb.Size/2), hb.Position+(hb.Size/2))
			local part = workspace:FindPartsInRegion3WithWhiteList(region, workspace:FindFirstChild("SandStorm"):GetChildren(), math.huge)
			if part then
				for i,v in pairs(part) do
					v.Smoke.Enabled = false
				end
			end
		end
	end
end

function self:registerBuildingsToEnter()
	for i,v in pairs(workspace.Buildings:GetChildren()) do
		local function step()
			self:disableSSAroundBuilding(v)
		end
		game:GetService("RunService"):BindToRenderStep(v.Name, 1, step)
		v.Changed:Connect(function()
			if v == nil then
				game:GetService("RunService"):UnbindFromRenderStep(v.Name)
			end	
		end)
	end
end

return self
