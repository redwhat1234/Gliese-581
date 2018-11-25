
local pi = math.pi
local c = CFrame.new
local ca = CFrame.Angles
local v3 = Vector3.new

function Weld(a, b, c0)
	local w = Instance.new("Weld", a)
	w.Part0 = a
	w.Part1 = b
	if c0 then
		w.C0 = w.C0 * c0
	end
end

function s_createValues(player)
	local s, sm = Instance.new("NumberValue", player), Instance.new("NumberValue", player)
	s.Name, sm.Name = "Stamina", "StaminaMax"
	sm.Value = 100
	s.Value = 100
	local o2 = Instance.new("NumberValue", player)
	o2.Name = "Oxygen"
	o2.Value = 98
	local psi, water, nut = Instance.new("NumberValue", player),Instance.new("NumberValue", player),Instance.new("NumberValue", player)
	psi.Name = "psi"
	water.Name = "Water"
	nut.Name = "Nutrition"
	psi.Value = 34
	water.Value = 99
	nut.Value = 99
end

local currentOreNodes = {}

function generateBaseOre(node)
	local newOreBase = game.ServerStorage["Red Engine"].Assets.Natural.RockBase:Clone()
	newOreBase.Parent = node
	newOreBase.CFrame = node.CFrame * CFrame.Angles(math.rad(math.random(-90,90)),0,0) + Vector3.new(0,newOreBase.Size.Y/4,0)
	local stats = newOreBase.Stats
	stats.Type.Value = "BaseMetal"
	stats.StartHp.Value = math.random(100,200)
	stats.Hp.Value = stats.StartHp.Value
	return newOreBase
end

function generatePreciousOre()
	
end

function generateOres()
	for i,v in pairs(workspace.Natural.Ores:GetChildren()) do
		if string.find(v.Name, "Node", 1, 1) then
			if string.find(v.Name, "Base", 1, 1 ) then
				generateBaseOre(v)
			else
				
			end
		end
	end
end

local function createPlayerCharacter(player, character)
	local newCharacter = game.ServerStorage["Red Engine"].Assets.Characters.Character:Clone()
	local desc = character:GetChildren()
	local root = newCharacter:WaitForChild("HumanoidRootPart")
	local head = newCharacter:WaitForChild("Head")
	local ctorso = character:WaitForChild("Torso")
	local hum = character:WaitForChild("Humanoid")
	for i=1, #desc do
		if desc[i]:IsA("Part") then
			desc[i].Transparency = 1
			if desc[i].Name == "Head" then
				desc[i].face.Parent = head
			end
		end
		if desc[i]:IsA("Accessory") then
			desc[i].Handle.Transparency = 1
		end
	end
	
	hum.HipHeight = 2
	newCharacter.Parent = character

	root.CFrame = ctorso.CFrame
	Weld(ctorso, root, c(0,-2,0))
	s_createValues(player)
	return true
end

game.Players.PlayerAdded:Connect(function(player)
	repeat wait(tick) until player.Character
	createPlayerCharacter(player, player.Character)	
end)

generateOres()