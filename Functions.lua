local Functions = {};

local Services = loadstring(game:HttpGet("https://raw.githubusercontent.com/JaimePRO200421212121/Kavo-UI-Fixed/main/Services.lua"))();

Functions.Variables = {
    ["NoClipping"] = nil,
    ["ESPColor"] = Color3.fromRGB(255, 255, 255),
    ["ESPTransparency"] = 0.3,
    ["ESPEnabled"] = false,
    ["Flying"] = false,
    ["QEFly"] = true,
    ["FlySpeed"] = 1
};

local function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso');
	return rootPart;
end

local function round(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0);
	return math.floor(num * mult + 0.5) / mult;
end

function Functions:ESP(plr)
	task.spawn(function()
		for i,v in pairs(Services.CoreGui:GetChildren()) do
			if v.Name == plr.Name .. '_ESP' then
				v:Destroy();
			end
		end
		wait();
		if plr.Character and plr.Name ~= Services.Players.LocalPlayer.Name and not Services.CoreGui:FindFirstChild(plr.Name .. '_ESP') then
			local ESPholder = Instance.new("Folder");
			ESPholder.Name = plr.Name .. '_ESP';
			ESPholder.Parent = Services.CoreGui;
			repeat wait(1) until plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid");
			for b, n in pairs (plr.Character:GetChildren()) do
				if (n:IsA("BasePart")) then
					local a = Instance.new("BoxHandleAdornment");
					a.Name = plr.Name;
					a.Parent = ESPholder;
					a.Adornee = n;
					a.AlwaysOnTop = true;
					a.ZIndex = 10;
					a.Size = n.Size;
					a.Transparency = Functions.Variables.ESPTransparency;
					a.Color = Functions.Variables.ESPColor;
				end
			end
			if plr.Character and plr.Character:FindFirstChild('Head') then
				local BillboardGui = Instance.new("BillboardGui");
				local TextLabel = Instance.new("TextLabel");
				BillboardGui.Adornee = plr.Character.Head;
				BillboardGui.Name = plr.Name;
				BillboardGui.Parent = ESPholder;
				BillboardGui.Size = UDim2.new(0, 100, 0, 150);
				BillboardGui.StudsOffset = Vector3.new(0, 1, 0);
				BillboardGui.AlwaysOnTop = true;
				TextLabel.Parent = BillboardGui;
				TextLabel.BackgroundTransparency = 1;
				TextLabel.Position = UDim2.new(0, 0, 0, -50);
				TextLabel.Size = UDim2.new(0, 100, 0, 100);
				TextLabel.Font = Enum.Font.SourceSansSemibold;
				TextLabel.TextSize = 20;
				TextLabel.TextColor3 = Color3.new(1, 1, 1);
				TextLabel.TextStrokeTransparency = 0;
				TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom;
				TextLabel.Text = 'Name: ' .. plr.Name;
				TextLabel.ZIndex = 10;
				local espLoopFunc;
				local teamChange;
				local addedFunc;
				addedFunc = plr.CharacterAdded:Connect(function()
					if ESPenabled then
						espLoopFunc:Disconnect();
						teamChange:Disconnect();
						ESPholder:Destroy();
						repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid");
						ESP(plr);
						addedFunc:Disconnect();
					else
						teamChange:Disconnect();
						addedFunc:Disconnect();
					end
				end);
				teamChange = plr:GetPropertyChangedSignal("TeamColor"):Connect(function()
					if ESPenabled then
						espLoopFunc:Disconnect();
						addedFunc:Disconnect();
						ESPholder:Destroy();
						repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid");
						ESP(plr);
						teamChange:Disconnect();
					else
						teamChange:Disconnect();
					end
				end);
				local function espLoop()
					if Services.CoreGui:FindFirstChild(plr.Name .. '_ESP') then
						if plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid") and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
							local pos = math.floor((getRoot(Players.LocalPlayer.Character).Position - getRoot(plr.Character).Position).magnitude);
							TextLabel.Text = 'Name: ' .. plr.Name .. ' | Team: ' .. plr.Team .. ' | Health: ' .. round(plr.Character:FindFirstChildOfClass('Humanoid').Health, 1) .. ' | Studs: ' .. pos;
						end
					else
						teamChange:Disconnect();
						addedFunc:Disconnect();
						espLoopFunc:Disconnect();
					end
				end
				espLoopFunc = RunService.RenderStepped:Connect(espLoop);
			end
		end
	end)
end

function Functions:UnESP()
    ESPenabled = false;
	for i,c in pairs(COREGUI:GetChildren()) do
		if string.sub(c.Name, -4) == '_ESP' then
			c:Destroy();
		end
	end
end



return Functions;
