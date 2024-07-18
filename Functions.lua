local Functions = {};

local Services = loadstring(game:HttpGet("https://raw.githubusercontent.com/JaimePRO200421212121/Kavo-UI-Fixed/main/Services.lua"))();

local function GetRoot(character)
	local rootPart = character:FindFirstChild('HumanoidRootPart') or character:FindFirstChild('Torso') or character:FindFirstChild('UpperTorso');
	return rootPart;
end

local function Round(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0);
	return math.floor(num * mult + 0.5) / mult;
end

local function RandomString()
	local length = math.random(10, 20);
	local array = {};
	for i = 1, length do
		array[i] = string.char(math.random(32, 126));
	end
	return table.concat(array);
end

function SplitString(str, delim)
	local broken = {};
	if delim == nil then
		delim = ",";
	end
	for w in string.gmatch(str, "[^" .. delim .. "]+") do
		table.insert(broken, w);
	end
	return broken;
end

function ToTokens(str)
	local tokens = {};
	for op, name in string.gmatch(str,"([+-])([^+-]+)") do
		table.insert(tokens, { Operator = op, Name = name } );
	end
	return tokens;
end

function OnlyIncludeInTable(tab, matches)
	local matchTable = {};
	local resultTable = {};
	for i, v in pairs(matches) do
		matchTable[v.Name] = true;
	end
	for i, v in pairs(tab) do
		if matchTable[v.Name] then
			table.insert(resultTable, v);
		end
	end
	return resultTable;
end

function RemoveTableMatches(tab, matches)
	local matchTable = {};
	local resultTable = {};
	for i, v in pairs(matches) do
		matchTable[v.Name] = true;
	end
	for i, v in pairs(tab) do
		if not matchTable[v.Name] then
			table.insert(resultTable, v);
		end
	end
	return resultTable;
end

local function getPlayersByName(Name)
	local Name, Len, Found = string.lower(Name), #Name, {};
	for _, v in pairs(Services.Players:GetPlayers()) do
		if Name:sub(0, 1) == '@' then
			if string.sub(string.lower(v.Name), 1, Len - 1) == Name:sub(2) then
				table.insert(Found, v);
			end
		else
			if string.sub(string.lower(v.Name), 1, Len) == Name or string.sub(string.lower(v.DisplayName), 1, Len) == Name then
				table.insert(Found, v);
			end
		end
	end
	return Found;
end

function GetPlayer(list)
	if list == nil then
		return { Services.Players.LocalPlayer.Name };
	end
	local nameList = SplitString(list, ",");

	local foundList = {};

	for _, name in pairs(nameList) do
		if string.sub(name, 1, 1) ~= "+" and string.sub(name, 1, 1) ~= "-" then
			name = "+" .. name;
		end
		local tokens = ToTokens(name);
		local initialPlayers = Services.Players:GetPlayers();

		for i, v in pairs(tokens) do
			if v.Operator == "+" then
				initialPlayers = onlyIncludeInTable(initialPlayers, getPlayersByName(v.Name));
			else
				initialPlayers = removeTableMatches(initialPlayers, getPlayersByName(v.Name));
			end
		end

		for i, v in pairs(initialPlayers) do
			table.insert(foundList, v);
		end
	end

	local foundNames = {};
	for i, v in pairs(foundList) do
		table.insert(foundNames, v.Name);
	end

	return foundNames;
end

local function NoClipLoop()
	if Services.Players.LocalPlayer.Character ~= nil then
		for _, child in pairs(Services.Players.LocalPlayer.Character:GetDescendants()) do
			if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= Functions.Variables.FloatName then
				child.CanCollide = false;
			end
		end
	end
end

local function SingleESP(plr)
	task.spawn(function()
		for i,v in pairs(Services.CoreGui:GetChildren()) do
			if v.Name == plr.Name .. '_ESP' then
				v:Destroy();
			end
		end
		task.wait();
		if plr.Character and plr.Name ~= Services.Players.LocalPlayer.Name and not Services.CoreGui:FindFirstChild(plr.Name .. '_ESP') then
			local ESPholder = Instance.new("Folder");
			ESPholder.Name = plr.Name .. '_ESP';
			ESPholder.Parent = Services.CoreGui;
			repeat task.wait(1) until plr.Character and GetRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid");
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
					a.Color = Functions.Variables.MultiESP and Functions.Variables.ESPColor or plr.TeamColor;
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
					if Functions.Variables.ESPEnabled then
						espLoopFunc:Disconnect();
						teamChange:Disconnect();
						ESPholder:Destroy();
						repeat task.wait(1) until GetRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid");
						PlayerESP(plr);
						addedFunc:Disconnect();
					else
						teamChange:Disconnect();
						addedFunc:Disconnect();
					end
				end);
				teamChange = plr:GetPropertyChangedSignal("TeamColor"):Connect(function()
					if Functions.Variables.ESPEnabled then
						espLoopFunc:Disconnect();
						addedFunc:Disconnect();
						ESPholder:Destroy();
						repeat task.wait(1) until GetRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid");
						PlayerESP(plr);
						teamChange:Disconnect();
					else
						teamChange:Disconnect();
					end
				end);
				local function espLoop()
					if Services.CoreGui:FindFirstChild(plr.Name .. '_ESP') then
						if plr.Character and GetRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid") and Services.Players.LocalPlayer.Character and GetRoot(Services.Players.LocalPlayer.Character) and Services.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
							local pos = math.floor((GetRoot(Services.Players.LocalPlayer.Character).Position - GetRoot(plr.Character).Position).magnitude);
							TextLabel.Text = 'Name: ' .. plr.Name .. ' | Team: ' .. plr.Team .. ' | Health: ' .. Round(plr.Character:FindFirstChildOfClass('Humanoid').Health, 1) .. ' | Studs: ' .. pos;
						end
					else
						teamChange:Disconnect();
						addedFunc:Disconnect();
						espLoopFunc:Disconnect();
					end
				end
				espLoopFunc = Services.RunService.RenderStepped:Connect(espLoop);
			end
		end
	end)
end

local function PlayerFly()
	repeat task.wait() until Services.Players.LocalPlayer and Services.Players.LocalPlayer.Character and GetRoot(Services.Players.LocalPlayer.Character) and Services.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid");
	repeat task.wait() until Functions.Variables.Mouse;
	if Functions.Variables.FlyKeyDown or Functions.Variables.FlyKeyUp then
		Functions.Variables.FlyKeyDown:Disconnect();
		Functions.Variables.FlyKeyUp:Disconnect();
	end

	local T = GetRoot(Services.Players.LocalPlayer.Character);
	local CONTROL = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 };
	local lCONTROL = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 };
	local SPEED = 0;

	local function PFly()
		Functions.Variables.Flying = true;
		local BG = Instance.new('BodyGyro');
		local BV = Instance.new('BodyVelocity');
		BG.P = 9e4;
		BG.Parent = T;
		BV.Parent = T;
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9);
		BG.cframe = T.CFrame;
		BV.velocity = Vector3.new(0, 0, 0);
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9);
		task.spawn(function()
			repeat task.wait()
				if Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
					Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true;
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50;
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0;
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED;
					lCONTROL = { F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R };
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED;
				else
					BV.velocity = Vector3.new(0, 0, 0);
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame;
			until not Functions.Variables.Flying;
			CONTROL = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 };
			lCONTROL = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 };
			SPEED = 0;
			BG:Destroy();,
			BV:Destroy();
			if Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false;
			end
		end)
	end
	Functions.Variables.FlyKeyDown = Functions.Variables.Mouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = Functions.Variables.FlySpeed;
		elseif KEY:lower() == 's' then
			CONTROL.B = - Functions.Variables.FlySpeed;
		elseif KEY:lower() == 'a' then
			CONTROL.L = - Functions.Variables.FlySpeed;
		elseif KEY:lower() == 'd' then 
			CONTROL.R = Functions.Variables.FlySpeed;
		elseif Functions.Variables.QEFly and KEY:lower() == 'e' then
			CONTROL.Q = Functions.Variables.FlySpeed * 2;
		elseif Functions.Variables.QEFly and KEY:lower() == 'q' then
			CONTROL.E = -Functions.Variables.FlySpeed * 2;
		end
		pcall(function()
			workspace.CurrentCamera.CameraType = Enum.CameraType.Track;
		end);
	end);
	Functions.Variables.FlyKeyUp = Functions.Variables.Mouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0;
		elseif KEY:lower() == 's' then
			CONTROL.B = 0;
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0;
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0;
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0;
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0;
		end
	end);
	PFly();
end

local function PlayerUnFly()
	Functions.Variables.Flying = false;
	if Functions.Variables.FlyKeyDown or Functions.Variables.FlyKeyUp then
		Functions.Variables.FlyKeyDown:Disconnect();
		Functions.Variables.FlyKeyUp:Disconnect();
	end
	if Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
		Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false;
	end
	pcall(function()
		workspace.CurrentCamera.CameraType = Enum.CameraType.Custom;
	end);
end

local function PlayerFloat()
	local pchar = Services.Players.LocalPlayer.Character;
	if pchar and not pchar:FindFirstChild(Functions.Variables.FloatName) then
		task.spawn(function()
			local Float = Instance.new('Part');
			Float.Name = Functions.Variables.FloatName;
			Float.Parent = pchar;
			Float.Transparency = 1;
			Float.Size = Vector3.new(2, 0.2, 1.5);
			Float.Anchored = true;
			local FloatValue = -3.1;
			Float.CFrame = GetRoot(pchar).CFrame * CFrame.new(0, FloatValue, 0);
			Functions.Variables.QUp = Functions.Variables.Mouse.KeyUp:Connect(function(KEY)
				if KEY == 'q' then
					FloatValue = FloatValue + 0.5;
				end
			end)
			Functions.Variables.EUp = Functions.Variables.Mouse.KeyUp:Connect(function(KEY)
				if KEY == 'e' then
					FloatValue = FloatValue - 0.5;
				end
			end);
			Functions.Variables.QDown = Functions.Variables.Mouse.KeyDown:Connect(function(KEY)
				if KEY == 'q' then
					FloatValue = FloatValue - 0.5;
				end
			end);
			Functions.Variables.EDown = Functions.Variables.Mouse.KeyDown:Connect(function(KEY)
				if KEY == 'e' then
					FloatValue = FloatValue + 0.5;
				end
			end);
			Functions.Variables.FloatDied = Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Died:Connect(function()
				Functions.Variables.FloatingFunc:Disconnect();
				Float:Destroy();
				Functions.Variables.QUp:Disconnect();
				Functions.Variables.EUp:Disconnect();
				Functions.Variables.QDown:Disconnect();
				Functions.Variables.EDown:Disconnect();
				Functions.Variables.FloatDied:Disconnect();
			end);
			local function FloatPadLoop()
				if pchar:FindFirstChild(Functions.Variables.FloatName) and getRoot(pchar) then
					Float.CFrame = GetRoot(pchar).CFrame * CFrame.new(0, FloatValue, 0);
				else
					Functions.Variables.FloatingFunc:Disconnect();
					Float:Destroy();
					Functions.Variables.QUp:Disconnect();
					Functions.Variables.WUp:Disconnect();
					Functions.Variables.QDown:Disconnect();
					Functions.Variables.EDown:Disconnect();
					Functions.Variables.FloatDied:Disconnect();
				end
			end			
			Functions.Variables.FloatingFunc = Services.RunService.Heartbeat:Connect(FloatPadLoop);
		end)
	end
end

local function PlayerUnFloat()
	local pchar = Services.Players.LocalPlayer.Character;
	if pchar:FindFirstChild(Functions.Variables.FloatName) then
		pchar:FindFirstChild(Functions.Variables.FloatName):Destroy();
	end
	if Functions.Variables.FloatDied then
		Functions.Variables.FloatingFunc:Disconnect();
		Functions.Variables.QUp:Disconnect();
		Functions.Variables.EUp:Disconnect();
		Functions.Variables.QDown:Disconnect();
		Functions.Variables.EDown:Disconnect();
		Functions.Variables.FloatDied:Disconnect();
	end
end

Functions.Variables = {
	["Mouse"] = Services.Players.LocalPlayer:GetMouse(),
	["NoClipping"] = nil,
	["FlyKeyUp"] = nil,
	["FlyKeyDown"] = nil,
	["FloatDied"] = nil,
	["FloatingFunc"] = nil,
	["QUp"] = nil,
	["EUp"] = nil,
	["QDown"] = nil,
	["EDown"] = nil,
    	["FloatName"] = randomString(),
    	["ESPColor"] = Color3.fromRGB(255, 255, 255),
    	["ESPTransparency"] = 0.3,
	["MultiESP"] = false,
    	["ESPEnabled"] = false,
	["Floating"] = false,
    	["Flying"] = false,
    	["QEFly"] = true,
    	["FlySpeed"] = 1,
	["Amount"] = 1,
	["Team"] = ""
};

function Functions:NoClip()
	Functions.Variables.NoClipping = Services.RunService.Stepped:Connect(NoClipLoop);
end

function Functions:UnNoClip()
	if Functions.Variables.NoClipping then
		Functions.Variables.NoClipping:Disconnect();
	end
end

function Functions:PlayerESP(plr)
	Functions.Variables.ESPEnabled = true;
	Functions.Variables.MultiESP = false;
	if plr.Name ~= Services.Players.LocalPlayer.Name then
		SingleESP(plr);
	end
end

function Functions:TeamESP()
	Functions.Variables.ESPEnabled = true;
	Functions.Variables.MultiESP = true;
	for i, v in pairs(Services.Players:GetPlayers()) do
		if v.Team == Functions.Variables.Team then
			if v.Name ~= Services.Players.LocalPlayer.Name then
				SingleESP(v);
			end
		end
	end
end

function Functions:AllESP()
	Functions.Variables.ESPEnabled = true;
	Functions.Variables.MultiESP = true;
	for i, v in pairs(Services.Players:GetPlayers()) do
		if v.Name ~= Services.Players.LocalPlayer.Name then
			SingleESP(v);
		end
	end
end

function Functions:UnESP()
	Functions.Variables.ESPEnabled = false;
	for i, c in pairs(Services.CoreGui:GetChildren()) do
		if string.sub(c.Name, -4) == '_ESP' then
			c:Destroy();
		end
	end
end

function Functions:Fly()
	PlayerUnFly();
	task.wait();
	PlayerFly();
end

function Functions:UnFly()
	PlayerUnFly();
end

function Functions:Float()
	Functions.Variables.Floating = true;
	PlayerFloat();
end

function Functions:UnFloat()
	Functions.Variables.Floating = false;
	PlayerUnFloat();
end
	
function Functions:PlayerGoTo(plr)
	if plr.Character ~= nil then
		if Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') and Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').SeatPart then
			Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Sit = false;
			task.wait(0.1);
		end
		GetRoot(Services.Players.LocalPlayer.Character).CFrame = GetRoot(plr.Character).CFrame + Vector3.new(3, 1, 0);
	end
end

function Functions:TeamGoTo()
	for i, v in pairs(Services.Players:GetPlayers()) do
		if v.Character ~= nil then
			if v.Team == Functions.Variables.Team then
				if Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') and Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').SeatPart then
					Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Sit = false;
					task.wait(0.1);
				end
				GetRoot(Services.Players.LocalPlayer.Character).CFrame = GetRoot(v.Character).CFrame + Vector3.new(3, 1, 0);
			end
		end
		task.wait(1);
	end
end

function Functions:AllGoTo()
	for i, v in pairs(Services.Players:GetPlayers()) do
		if v.Character ~= nil then
			if v ~= Services.Players.LocalPlayer then
				if Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') and Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').SeatPart then
					Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Sit = false;
					task.wait(0.1);
				end
				GetRoot(Services.Players.LocalPlayer.Character).CFrame = GetRoot(v.Character).CFrame + Vector3.new(3, 1, 0);
			end
		end
		task.wait(1);
	end
end

function Functions:LoopPlayerGoTo(plr)
	if plr.Character ~= nil then
		for j = 1, Functions.Variables.Amount, 1 do
			if Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') and Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').SeatPart then
				Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Sit = false;
				task.wait(0.1);
			end
			GetRoot(Services.Players.LocalPlayer.Character).CFrame = GetRoot(plr.Character).CFrame + Vector3.new(3, 1, 0);
			task.wait(5);
		end
	end
end

function Functions:LoopTeamGoTo()
	for i, v in pairs(Services.Players:GetPlayers()) do
		if v.Character ~= nil then
			if v.Team == Functions.Variables.Team then
				for j = 1, Functions.Variables.Amount, 1 do
					if Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') and Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').SeatPart then
						Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Sit = false;
						task.wait(0.1);
					end
					GetRoot(Services.Players.LocalPlayer.Character).CFrame = GetRoot(v.Character).CFrame + Vector3.new(3, 1, 0);
					task.wait(5);
				end
			end
		end
		task.wait(1);
	end
end

function Functions:LoopAllGoTo()
	for i, v in pairs(Services.Players:GetPlayers()) do
		if v.Character ~= nil then
			if v ~= Services.Players.LocalPlayer then
				for j = 1, Functions.Variables.Amount, 1 do
					if Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') and Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').SeatPart then
						Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Sit = false;
						task.wait(0.1);
					end
					GetRoot(Services.Players.LocalPlayer.Character).CFrame = GetRoot(v.Character).CFrame + Vector3.new(3, 1, 0);
					task.wait(5);
				end
			end
		end
		task.wait(1);
	end
end

return Functions;
