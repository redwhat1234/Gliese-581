local self = {}
local helmet = game.ReplicatedStorage.Helmet:Clone()
helmet.Parent = workspace.CurrentCamera

local hasSetArmBool = false

function self:isHelmetEnabled(bool)
	if bool then
		local function step()
			helmet:SetPrimaryPartCFrame(workspace.CurrentCamera.CFrame)
		end
		game:GetService("RunService"):BindToRenderStep("helmetUpdate", 1, step)
	else
		game:GetService("RunService"):UnbindFromRenderStep("helmetUpdate")
	end
end

function self:renderOreNodes()
	for i,v in pairs(workspace.Natural.Ores:GetChildren()) do
		if string.find(v.Name, "Node", 1, 1) then
			v.Transparency = 1
		end
	end
end

function self:setMouseIconEnabled(bool)
	game:GetService("UserInputService").MouseIconEnabled = false
end

function self:setArmsEnabled(bool)
	if bool then
		if hasSetArmBool then print("already set, returning....") return end
		 print("hasnt set, running....")
		local function step()
			for i,v in pairs(game.Players.LocalPlayer.Character.Character:GetDescendants()) do
				if v.Name == "RightArm" and v.ClassName ~= "Motor6D" or v.Name == "RightArm2" and v.ClassName ~= "Motor6D" then
					v.LocalTransparencyModifier = 0
				end
				if game.Players.LocalPlayer.Character.Character:FindFirstChild("Mallet") then
					if v:IsDescendantOf(game.Players.LocalPlayer.Character.Character.Mallet) then
						if v.ClassName == "Part" or v.ClassName == "MeshPart" or v.ClassName == "UnionOperation" then
							v.LocalTransparencyModifier = 0
						end
					end
				end
				if v:IsDescendantOf(game.Players.LocalPlayer.Character.Character.RightArm) or  v:IsDescendantOf(game.Players.LocalPlayer.Character.Character.RightArm2) then
					if v.ClassName == "Part" or v.ClassName == "MeshPart" or v.ClassName == "UnionOperation" then
						v.LocalTransparencyModifier = 0
					end
				end
			end
		end
		game:GetService("RunService"):BindToRenderStep("armUpdate", 1, step)
		hasSetArmBool = true
	else
		if hasSetArmBool then
			hasSetArmBool = false
		end
		game:GetService("RunService"):UnbindFromRenderStep("armUpdate")
		for i,v in pairs(game.Players.LocalPlayer.Character.Character:GetDescendants()) do
			if v.Name == "RightArm" and v.ClassName ~= "Motor6D" or v.Name == "RightArm2" and v.ClassName ~= "Motor6D" then
				v.LocalTransparencyModifier = 1
			end
			if v:IsDescendantOf(game.Players.LocalPlayer.Character.Character.RightArm) or  v:IsDescendantOf(game.Players.LocalPlayer.Character.Character.RightArm2) then
				if v.ClassName == "Part" or v.ClassName == "MeshPart" or v.ClassName == "UnionOperation" then
					v.LocalTransparencyModifier = 1
				end
			end
		end
	end
end

function self:firstPersonEnabled(bool, p)
	if bool then
		p.CameraMode = Enum.CameraMode.LockFirstPerson
	else
		p.CameraMode = Enum.CameraMode.Classic
	end
end

return self
