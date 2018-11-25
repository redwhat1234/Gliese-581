
local loadScreen = nil

repeat wait(tick) until script.Parent:FindFirstChild("RedLibs")

local namespace = require(script.Parent.RedLibs.Namespace)

local callback

local playerInventory = {}

playerInventory.Hotbar = {
	[1] = {
		id="Mallet";
		isSwinging=false;
		mouseCallback=function(v)
			v.isSwinging=true
			local Attack = game.Players.LocalPlayer.Character.Character.AnimationController:LoadAnimation(game.Players.LocalPlayer.Character.Character.AnimationController:WaitForChild("Attack"))
			Attack:Play()
			game.Players.LocalPlayer.Character.Character:FindFirstChild("Mallet").Head.IsSwinging.Value = true
			game.Players.LocalPlayer.Character.Character:FindFirstChild("Mallet").Touch.Touched:Connect(function(hit)
				if not game.Players.LocalPlayer.Character.Character:FindFirstChild("Mallet").Head.IsSwinging.Value then return end
				print("Activated")
				if hit:FindFirstChild("Stats") then
					v.isSwinging=false
					game.Players.LocalPlayer.Character.Character:FindFirstChild("Mallet").Head.IsSwinging.Value = false
					hit.Stats.Hp.Value = hit.Stats.Hp.Value - math.random(14,18)
					v.durability[1] = v.durability[1] - math.random(1,3)
					return true
				end
				v.isSwinging=false
				game.Players.LocalPlayer.Character.Character:FindFirstChild("Mallet").Head.IsSwinging.Value = false	
			end)
		end;
		durability={50,100};
		animSet={
			["Idle"]="IdleEqp",
			["Running"]="RunningEqp"	
		}
	};
	[2] = {
		id="Locator"	
	};
	[3] = {};
	[4] = {};
	[5] = {};
	[6] = {};
	[7] = {};
}

local libraries = namespace:enumerateLibraries{
	script.Parent.PlayerRender,
	script.Parent.PlayerLogic,
	script.Parent.PlayerPhysics,
	script.Parent.PlayerUI		
}

local function playerLoadedIntoGame()
	local guiCallback = libraries.RedEnt:setRobloxUIEnabled(false)
	loadScreen, callback = libraries.RedEnt:newContainer{
		"loadingScreen",
		data={
			color=Color3.fromRGB(0,0,0);
			parent=game.Players.LocalPlayer.PlayerGui.HUD;
			hasBar=true;
		}		
	}
	if callback then
		print(callback)
	end
	if loadScreen then
		loadScreen:Enable()
		for i = 1, 100, .25 do
			game:GetService("RunService").RenderStepped:Wait()
			loadScreen:setBarPercent(i)
		end
		loadScreen:Disable()
	end
	return true
end

local playerHasLoaded, callback = playerLoadedIntoGame()

if callback then
	print(callback)
end

if playerHasLoaded then
	local hud, callback = libraries.RedEnt:newContainer{
		"hud",
		data={
			o2=true,
			psi=true,
			temp=true,
			health=true,
			waternut=true,
			stamina=true,
			parent=game.Players.LocalPlayer.PlayerGui.HUD;	
			text=true;
		}	
	}
	if hud then
		hud:statUpdatesEnabled(true, game.Players.LocalPlayer)
		libraries.Stats:BindAllKeys()
		libraries.Stats:statUpdatesEnabled(true, game.Players.LocalPlayer)
		libraries.CameraEffects:setArmsEnabled(false)
		libraries.BuildingEffects:registerBuildingsToEnter()
		libraries.CameraEffects:renderOreNodes()
		libraries.CameraEffects:setMouseIconEnabled(false)
		local playerInventory = libraries.RedEnt:makeInv{
			pdata=playerInventory;
			uiparent=game.Players.LocalPlayer.PlayerGui.HUD;
			autoListen=true;	
		}
--		libraries.CameraEffects:isHelmetEnabled(true)
		libraries.CameraEffects:firstPersonEnabled(true, game.Players.LocalPlayer)
	end
end

local function playerEffectStep()
	if libraries.Stats:findObjectInHands() then
		libraries.CameraEffects:setArmsEnabled(true)
	else
		libraries.CameraEffects:setArmsEnabled(false)
	end
end

game:GetService("RunService"):BindToRenderStep("playerEffectStep", 1, playerEffectStep)