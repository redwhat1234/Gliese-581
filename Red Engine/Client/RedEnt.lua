local self = {}
self.ColorType = {}
self.ColorType.Enemy = Color3.fromRGB(255,0,0)
self.ColorType.Normal = Color3.fromRGB(0,200,200)
self.ColorType.NormalText = Color3.fromRGB(0,100,100)

self.sub = "[Red Engine]"

self.FontType = {}

self.FontType.SaucerBB = {
	["a"]=Vector2.new(0,0);	
	["b"]=Vector2.new(100,0);
	["c"]=Vector2.new(200,0);
	["d"]=Vector2.new(300,0);
	["e"]=Vector2.new(400,0);	
	["f"]=Vector2.new(508,0);		
	["g"]=Vector2.new(608,0);
	["h"]=Vector2.new(712,0);	
	["i"]=Vector2.new(0,100);	
	["j"]=Vector2.new(100,100);		
	["k"]=Vector2.new(200,100);
	["l"]=Vector2.new(304,100);
	["m"]=Vector2.new(408,100);
	["n"]=Vector2.new(508,100);	
	["o"]=Vector2.new(608,100);
	["p"]=Vector2.new(712,100);
	["q"]=Vector2.new(0,200);
	["r"]=Vector2.new(100,200);	
	["s"]=Vector2.new(200,200);
	["t"]=Vector2.new(300,200);
	["u"]=Vector2.new(400,200);
	["v"]=Vector2.new(508,200);
	["w"]=Vector2.new(608,200);
	["x"]=Vector2.new(712,200);
	["y"]=Vector2.new(0,300);
	["z"]=Vector2.new(100,300);
	["."]=Vector2.new(512,400);						
}

function self:makeCustomText(data)
	if data.fontType then
		print(self.sub.." String: "..data.text.."")
		local textFrameSize = string.len(data.text)*64
		local localizedLength = textFrameSize*data.parent.Size.X.Offset
		local frame = Instance.new("Frame", data.parent or data.player.PlayerGui.Fallback)
		frame.Size = UDim2.new(1,0,1,0)
		frame.BackgroundTransparency = 1
		for i = 1, string.len(data.text) do
			local letter = string.sub(data.text, i, i)
			if self.FontType.SaucerBB[string.lower(letter)] then
				local newImage = Instance.new("ImageLabel", frame)
				newImage.Image = "rbxgameasset://Images/SaucerBB (1)"
				newImage.BackgroundTransparency = 1
				newImage.ImageRectOffset = self.FontType.SaucerBB[string.lower(letter)]
				newImage.ImageRectSize = Vector2.new(108,108)
				newImage.Size = UDim2.new(0,textFrameSize/string.len(data.text)/4,0,textFrameSize/string.len(data.text)/4)
				newImage.Position = UDim2.new(0,textFrameSize/string.len(data.text)/5*(i-1),0,0)
				if data.textColor then
					newImage.ImageColor3 = data.textColor or self.ColorType.Normal
				end
			end
		end
		return frame
	end
end

function self:newBar(data)
	local newData = {}
	local frame1 = Instance.new("Frame", data.parent)
	local frame2 = Instance.new("Frame", frame1)
	if data.colorType then
		frame2.BackgroundColor3 = data.colorType or self.ColorType.Normal
	end
	frame1.BorderSizePixel = 2
	frame1.BackgroundColor3 = Color3.fromRGB(100,100,100)
	frame1.Size = data.size
	frame1.AnchorPoint=Vector2.new(.5,.5)
	frame1.Position=data.pos
	
	newData.object = frame1
	
	if data.hasText then
		if data.text then
			frame2.ClipsDescendants = true
			newData.t1 = self:makeCustomText{
				fontType=true;
				text=data.text;
				parent=frame1;	
			}
			newData.t2 = self:makeCustomText{
				fontType=true;
				textColor=self.ColorType.NormalText;
				text=data.text;
				parent=frame2;	
			}
		end
	end
	
	function newData:UpdatePosition(amt, maxamt)
		frame2:TweenSize(UDim2.new((amt/maxamt),0,1,0), "Out", "Linear", 1)
	end
	return newData
end

function self:makeInv(data)
	if data.pdata then
		for i,v in pairs(data.pdata.Hotbar) do
			v.SlotUI = Instance.new("Frame", data.uiparent)
			local num = self:makeCustomText{
				fontType=true;
				parent=v.SlotUI;
				text=i	
			}
			num.Size = UDim2.new(.15,0,.15,0)
			num.Position = UDim2.new(0,0,.85,0)
			local slotImage = Instance.new("ImageLabel", v.SlotUI)
			slotImage.Size = UDim2.new(1,0,1,0)
			slotImage.BackgroundTransparency = 1
			slotImage.Image = ""
			v.SlotUI.Size = UDim2.new(.045,0,.08,0)
			v.SlotUI.BorderSizePixel = 2
			v.SlotUI.BackgroundColor3 = Color3.fromRGB(100,100,100)
			v.SlotUI.BackgroundTransparency = .65
			v.SlotUI.Position = UDim2.new(.6,((workspace.CurrentCamera.ViewportSize.X*.048)*i),.9,-((workspace.CurrentCamera.ViewportSize.X*.01)*i))
			local function listenForInput()
				print(self.sub.." Calling Listen Event...")
				local function equipItem(a,s,b)
					print(self.sub.." Registered Call for EquipChange")
					if s ~= Enum.UserInputState.Begin then return end
					if data.pdata.equipped == nil or data.pdata.equipped ~= v.id then
						data.pdata.itemEquipped=true
						if data.pdata.equipped ~= nil then
							game.Players.LocalPlayer.Character.Character:FindFirstChild(data.pdata.equipped):Destroy()
						end
						if v.id == nil then
							data.pdata.equipped = nil
							data.pdata.itemEquipped=false
							return 
						end
						local newObject = game.ReplicatedStorage.Items.Tools[v.id]:Clone()
						newObject.Parent = game.Players.LocalPlayer.Character.Character
						local newWeld = Instance.new("Weld", newObject.PrimaryPart)
						newWeld.Part0 = newObject.PrimaryPart
						newWeld.Part1 = game.Players.LocalPlayer.Character.Character.RightArm2
						newWeld.C0 = CFrame.new() * CFrame.Angles(-math.rad(180),-math.rad(90),0)
						data.pdata.equipped = v.id
						if v.mouseCallback then
							local function callback(a,s,b)
								if s ~= Enum.UserInputState.Begin then return end
								print("callback")
								v.mouseCallback(v)
							end
							game:GetService("ContextActionService"):BindAction("mouseCallback", callback, false, Enum.UserInputType.MouseButton1)
						else
							game:GetService("ContextActionService"):UnbindAction("mouseCallback")
						end
					else
						data.pdata.itemEquipped=false
					end
				end
				if v.durability then
					v.Bar = self:newBar{
						parent=v.SlotUI;	
						colorType=self.ColorType.Normal;
						size=UDim2.new(.9,0,.1,0);
						pos=UDim2.new(.5,0,.9,0);
					}
					local lastId = v.id
					local function durabilityStep()
						if v.id ~= lastId then
							game:GetService("RunService"):UnbindFromRenderStep("durStep")
						end
						v.Bar:UpdatePosition(v.durability[1], v.durability[2])
						if v.durability[1] < 0 then
							v.durability[1] = v.durability[2]
						end
					end
					game:GetService("RunService"):BindToRenderStep("durStep"..i, 1, durabilityStep)
				end
				local keyTable = {
					[1]=Enum.KeyCode.One;
					[2]=Enum.KeyCode.Two;
					[3]=Enum.KeyCode.Three;
					[4]=Enum.KeyCode.Four;
					[5]=Enum.KeyCode.Five;
					[6]=Enum.KeyCode.Six;
					[7]=Enum.KeyCode.Seven;	
				}
				game:GetService("ContextActionService"):BindAction("EquipChange"..i, equipItem, false, keyTable[i])
			end
			
			if v.animSet then
				local isRunning = false
				local isIdle = true
				local isSprinting = false
				print(self.sub.." Found Anim Set")
				local lastId = v.id
				local idleAnim = game.Players.LocalPlayer.Character.Character.AnimationController:LoadAnimation(game.Players.LocalPlayer.Character.Character.AnimationController.IdleEqp)
				local runAnim = game.Players.LocalPlayer.Character.Character.AnimationController:LoadAnimation(game.Players.LocalPlayer.Character.Character.AnimationController.RunningEqp)
				local sprintAnim = game.Players.LocalPlayer.Character.Character.AnimationController:LoadAnimation(game.Players.LocalPlayer.Character.Character.AnimationController.SprintEqp)
				local function step()
					local speed = (game.Players.LocalPlayer.Character.PrimaryPart.Velocity).Magnitude
					if speed > 15 then
						isIdle = false
						isRunning = false
						isSprinting = true
					elseif speed > 5 then
						isIdle = false
						isRunning = true
						isSprinting = false
					elseif speed < 1 then
						isRunning = false
						isIdle = true
						isSprinting = false
					end
					runAnim:AdjustSpeed(speed/8,1/60)
					sprintAnim:AdjustSpeed(speed/16,1/60)
					if isRunning then
						idleAnim:Stop()
						sprintAnim:Stop()
						if not runAnim.IsPlaying then
							runAnim:Play()
						end
					elseif isIdle then
						runAnim:Stop()
						sprintAnim:Stop()
						if not idleAnim.IsPlaying then
							idleAnim:Play()
						end
					elseif isSprinting then
						idleAnim:Stop()	
						runAnim:Stop()
						if not sprintAnim.IsPlaying then
							sprintAnim:Play()
						end
					end
				end
				game:GetService("RunService"):BindToRenderStep("eqpAnim", 1, step)
			end
			
			if data.autoListen then
				print(self.sub.." listening for input on channel "..i)
				listenForInput()
			end
		end
	end
	return data.pdata
end

local function createLoadingScreen(data)
	print(self.sub.." new loading screen")
	local newLoadingScreen = {}
	
	newLoadingScreen.hasBar = false
	newLoadingScreen.barPercent = 0
	newLoadingScreen.barPercentCallback = 100
		
	function newLoadingScreen:setBarEnabled(bool)
		if newLoadingScreen.bar then 
			newLoadingScreen.hasBar = bool
		end
		return true
	end
	
	function newLoadingScreen:setBarPercent(amt, callback)
		if amt then
			newLoadingScreen.barPercent = amt
		end
		if callback then
			newLoadingScreen.barPercentCallback = callback
		end
		return true
	end
	
	function newLoadingScreen:setScreenEnabled(bool)
		if bool then
			newLoadingScreen.object.Visible = true
		else
			newLoadingScreen.object.Visible = false
		end
		return true
	end	
	
	function newLoadingScreen:step()
		if newLoadingScreen.bar then
			newLoadingScreen.bar:UpdatePosition(newLoadingScreen.barPercent, newLoadingScreen.barPercentCallback)
		end
	end
	
	function newLoadingScreen:Enable()
		local function step()
			newLoadingScreen:step()	
		end
		game:GetService("RunService"):BindToRenderStep("newLoadingScreen", 1, step)
		newLoadingScreen:setScreenEnabled(true)
		return true
	end
	
	function newLoadingScreen:Disable()
		game:GetService("RunService"):UnbindFromRenderStep("newLoadingScreen")
		newLoadingScreen:setScreenEnabled(false)
		return true
	end
	
	newLoadingScreen.parent = data.parent or data.player.PlayerGui.Fallback
	newLoadingScreen.object = Instance.new("Frame", newLoadingScreen.parent)
	newLoadingScreen.object.Size = UDim2.new(1,0,1.1,0)
	newLoadingScreen.object.Position = UDim2.new(0,0,-.1,0)
	newLoadingScreen.object.BackgroundColor3=data.color
	
	if data.hasBar then
		newLoadingScreen.bar = self:newBar{
			parent=newLoadingScreen.object;	
			colorType=self.ColorType.Normal;
			size=UDim2.new(.4,0,.025,0);
			pos=UDim2.new(.5,0,.65,0);
			hasText=true;
			text="Loading..."
		}
		newLoadingScreen:setBarEnabled(true)
	else
		newLoadingScreen.bar = false
		newLoadingScreen:setBarEnabled(false)
	end
	return newLoadingScreen, self.sub.." success..."
end

function newHud(data)
	local hud = {}
	hud.baseObject = Instance.new("Frame", data.parent or data.player.PlayerGui.Fallback)
	hud.baseObject.BackgroundTransparency = 1
	hud.baseObject.AnchorPoint = Vector2.new(.5,.5)
	hud.baseObject.Size = UDim2.new(1,0,1.1,0)
	hud.baseObject.Position = UDim2.new(.5,0,.45,0)
	if data.stamina then
		hud.stamina = self:newBar{
			parent=hud.baseObject;
			colorType=self.ColorType.Normal;
			size=UDim2.new(.2,0,.05,0);
			pos=UDim2.new(.5,0,.97,0);
			hasText=data.text;
			text="Stamina";
		}
		hud.stamina.t1.Position = UDim2.new(.5,0,.5,0)
		hud.stamina.t2.Position = UDim2.new(.5,0,.5,0)
		hud.stamina.t1.AnchorPoint = Vector2.new(.5,.5)
		hud.stamina.t2.AnchorPoint = Vector2.new(.5,.5)
	end
	if data.o2 then
		hud.o2 = self:newBar{
			parent=hud.baseObject;
			colorType=self.ColorType.Normal;
			size=UDim2.new(.1,0,.025,0);
			pos=UDim2.new(0.075,0,0.97,0);	
			hasText=data.text;
			text="o2";
		}
	end
	if data.health then
		hud.health = self:newBar{
			parent=hud.baseObject;
			colorType=self.ColorType.Normal;
			size=UDim2.new(.1,0,.025,0);
			pos=UDim2.new(0.075,0,0.93,0);	
			hasText=data.text;	
			text="Health";
		}
	end
	if data.waternut then
		hud.water = self:newBar{
			parent=hud.baseObject;
			colorType=self.ColorType.Normal;
			size=UDim2.new(.1,0,.0125,0);
			pos=UDim2.new(0.075,0,0.895,0);	
			hasText=data.text;	
			text="Water";
		}
		hud.nutrition = self:newBar{
			parent=hud.baseObject;
			colorType=self.ColorType.Normal;
			size=UDim2.new(.1,0,.0125,0);
			pos=UDim2.new(0.075,0,0.875,0);
			hasText=data.text;	
			text="Nutrition";	
		}
	end
	if data.psi then
		hud.psi = self:newBar{
			parent=hud.baseObject;
			colorType=self.ColorType.Normal;
			size=UDim2.new(.1,0,.025,0);
			pos=UDim2.new(0.075,0,0.835,0);	
			hasText=data.text;
			text="Psi";	
		}
	end
	
	function hud:statUpdatesEnabled(bool, player)
		local function step()
			if player then
				local oxygen, psi, st, water, nut, health = player.Oxygen.Value or 0, player.psi.Value or 0, player.Stamina.Value or 0, player.Water.Value or 0, player.Nutrition.Value or 0, player.Character.Humanoid.Health or 0
				hud.o2:UpdatePosition(oxygen, 100)
				hud.psi:UpdatePosition(psi, 100)
				hud.stamina:UpdatePosition(st, 100)
				hud.water:UpdatePosition(water, 100)
				hud.nutrition:UpdatePosition(nut, 100)
				hud.health:UpdatePosition(health, 100)
			end
		end
		if bool then
			game:GetService("RunService"):BindToRenderStep("hudVitalsUpdate", 1, step)
		else
			game:GetService("RunService"):UnbindFromRenderStep("hudVitalsUpdate")
		end
	end
	return hud, self.sub.." success..."
end

function self:newContainer(data)
	if data[1] then
		local type = data[1]
		if type ~= nil then
			if type == "loadingScreen" then
				local success, callback = createLoadingScreen(data.data)
				return success, callback or ""
			elseif type == "hud" then
				local success, callback = newHud(data.data)
				return success, callback or ""
			end
		end
	end
end

function self:setRobloxUIEnabled(bool)
	print(self.sub.." Toggled Roblox GUI")
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, bool)
	game.StarterGui:SetCore("TopbarEnabled", bool)
	return true
end

return self
