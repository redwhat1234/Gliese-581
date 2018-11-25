local self = {}

self.isSprinting = false

self.sub = "[Red Engine]"
p = game.Players.LocalPlayer

function contextPreProcess(a,t,b)
	print(self.sub.."Action: "..a)
	if a == "sprint" then
		self.EnumToValue(Enum.KeyCode.LeftShift)
	end
end

function self:BindAllKeys()
	game:GetService("ContextActionService"):BindAction("sprint", contextPreProcess, false, Enum.KeyCode.LeftShift)
end

function self.EnumToValue(enum)
	if enum == Enum.KeyCode.LeftShift then
		self:updateBooleanAction(self.isSprinting, not self.isSprinting)
	end
end

function self:findObjectInHands()
	for i,v in pairs(game.Players.LocalPlayer.Character.Character:GetChildren()) do
		if game.ReplicatedStorage.Items.Tools:FindFirstChild(v.Name) then
			return true
		end
	end
	return false
end

function self:statUpdatesEnabled(bool, player)
	if player then
		if bool then
			local function step()
				if self.isSprinting then
					player.Character.Humanoid.WalkSpeed = 24
					player.Oxygen.Value = player.Oxygen.Value - .01
					player.Stamina.Value = player.Stamina.Value - .1
					if player.Stamina.Value <= 0 then
						 player.Stamina.Value = 0
						self:updateBooleanAction(self.isSprinting, false)
					end
				else
					player.Character.Humanoid.WalkSpeed = 12
					if player.Oxygen.Value < 98 then
						player.Oxygen.Value = player.Oxygen.Value + .005
					end
					if player.Stamina.Value < 100 then
						player.Stamina.Value = player.Stamina.Value + .05
					end
				end
			end
			game:GetService("RunService"):BindToRenderStep("statUpdatesEnabled", 1, step)
		else
			game:GetService("RunService"):UnbindFromRenderStep("statUpdatesEnabled")
		end
	end
end

function self:updateBooleanAction(value, bool)
	if value == self.isSprinting then
		self.isSprinting = bool
	end
	if bool then
		print(self.sub.." true")
	else
		print(self.sub.." false")
	end
	return true
end

return self
