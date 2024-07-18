local Functions = {};

local Services = loadstring(game:HttpGet("https://raw.githubusercontent.com/JaimePRO200421212121/Kavo-UI-Fixed/main/Services.lua"))();

local SpecialPlayerCases = {
	["all"] = function(speaker) return Players:GetPlayers() end,
	["others"] = function(speaker)
		local plrs = {}
		for i,v in pairs(Players:GetPlayers()) do
			if v ~= speaker then
				table.insert(plrs,v)
			end
		end
		return plrs
	end,
	["me"] = function(speaker)return {speaker} end,
	["#(%d+)"] = function(speaker,args,currentList)
		local returns = {}
		local randAmount = tonumber(args[1])
		local players = {unpack(currentList)}
		for i = 1,randAmount do
			if #players == 0 then break end
			local randIndex = math.random(1,#players)
			table.insert(returns,players[randIndex])
			table.remove(players,randIndex)
		end
		return returns
	end,
	["random"] = function(speaker,args,currentList)
		local players = Players:GetPlayers()
		local localplayer = Players.LocalPlayer
		table.remove(players, table.find(players, localplayer))
		return {players[math.random(1,#players)]}
	end,
	["%%(.+)"] = function(speaker,args)
		local returns = {}
		local team = args[1]
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team and string.sub(string.lower(plr.Team.Name),1,#team) == string.lower(team) then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["allies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["enemies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["team"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nonteam"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["friends"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nonfriends"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if not plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["guests"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Guest then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["bacons"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character:FindFirstChild('Pal Hair') or plr.Character:FindFirstChild('Kate Hair') then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["age(%d+)"] = function(speaker,args)
		local returns = {}
		local age = tonumber(args[1])
		if not age == nil then return end
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.AccountAge <= age then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nearest"] = function(speaker,args,currentList)
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		local lowest = math.huge
		local NearestPlayer = nil
		for _,plr in pairs(currentList) do
			if plr ~= speaker and plr.Character then
				local distance = plr:DistanceFromCharacter(getRoot(speakerChar).Position)
				if distance < lowest then
					lowest = distance
					NearestPlayer = {plr}
				end
			end
		end
		return NearestPlayer
	end,
	["farthest"] = function(speaker,args,currentList)
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		local highest = 0
		local Farthest = nil
		for _,plr in pairs(currentList) do
			if plr ~= speaker and plr.Character then
				local distance = plr:DistanceFromCharacter(getRoot(speakerChar).Position)
				if distance > highest then
					highest = distance
					Farthest = {plr}
				end
			end
		end
		return Farthest
	end,
	["group(%d+)"] = function(speaker,args)
		local returns = {}
		local groupID = tonumber(args[1])
		for _,plr in pairs(Players:GetPlayers()) do
			if plr:IsInGroup(groupID) then  
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["alive"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["dead"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if (not plr.Character or not plr.Character:FindFirstChildOfClass("Humanoid")) or plr.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["rad(%d+)"] = function(speaker,args)
		local returns = {}
		local radius = tonumber(args[1])
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character and getRoot(plr.Character) then
				local magnitude = (getRoot(plr.Character).Position-getRoot(speakerChar).Position).magnitude
				if magnitude <= radius then table.insert(returns,plr) end
			end
		end
		return returns
	end,
	["cursor"] = function(speaker)
		local plrs = {}
		local v = GetClosestPlayerFromCursor()
		if v ~= nil then table.insert(plrs, v) end
		return plrs
	end,
	["npcs"] = function(speaker,args)
		local returns = {}
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("Model") and getRoot(v) and v:FindFirstChildWhichIsA("Humanoid") and Players:GetPlayerFromCharacter(v) == nil then
				local clone = Instance.new("Player")
				clone.Name = v.Name .. " - " .. v:FindFirstChildWhichIsA("Humanoid").DisplayName
				clone.Character = v
				table.insert(returns, clone)
			end
		end
		return returns
	end,
};

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

function splitString(str,delim)
	local broken = {}
	if delim == nil then delim = "," end
	for w in string.gmatch(str,"[^"..delim.."]+") do
		table.insert(broken,w)
	end
	return broken
end

function ToTokens(str)
	local tokens = {}
	for op,name in string.gmatch(str,"([+-])([^+-]+)") do
		table.insert(tokens,{Operator = op,Name = name})
	end
	return tokens
end

function OnlyIncludeInTable(tab,matches)
	local matchTable = {}
	local resultTable = {}
	for i,v in pairs(matches) do matchTable[v.Name] = true end
	for i,v in pairs(tab) do if matchTable[v.Name] then table.insert(resultTable,v) end end
	return resultTable
end

function RemoveTableMatches(tab,matches)
	local matchTable = {}
	local resultTable = {}
	for i,v in pairs(matches) do matchTable[v.Name] = true end
	for i,v in pairs(tab) do if not matchTable[v.Name] then table.insert(resultTable,v) end end
	return resultTable
end

function GetPlayer(list)
	if list == nil then
		return { Services.Players.LocalPlayer.Name };
	end
	local nameList = splitString(list, ",");

	local foundList = {};

	for _, name in pairs(nameList) do
		if string.sub(name, 1, 1) ~= "+" and string.sub(name, 1, 1) ~= "-" then
			name = "+" .. name;
		end
		local tokens = toTokens(name);
		local initialPlayers = Services.Players:GetPlayers();

		for i,v in pairs(tokens) do
			if v.Operator == "+" then
				local tokenContent = v.Name;
				local foundCase = false;
				for regex, case in pairs(SpecialPlayerCases) do
					local matches = { string.match(tokenContent, "^" .. regex .. "$") };
					if #matches > 0 then
						foundCase = true;
						initialPlayers = onlyIncludeInTable(initialPlayers, case(speaker, matches, initialPlayers));
					end
				end
				if not foundCase then
					initialPlayers = onlyIncludeInTable(initialPlayers, getPlayersByName(tokenContent));
				end
			else
				local tokenContent = v.Name;
				local foundCase = false;
				for regex, case in pairs(SpecialPlayerCases) do
					local matches = { string.match(tokenContent, "^" .. regex .. "$") };
					if #matches > 0 then
						foundCase = true;
						initialPlayers = removeTableMatches(initialPlayers, case(speaker, matches, initialPlayers));
					end
				end
				if not foundCase then
					initialPlayers = removeTableMatches(initialPlayers, getPlayersByName(tokenContent));
				end
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

local function PlayerESP(plr)
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
			repeat task.wait(1) until plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid");
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
					if ESPenabled then
						espLoopFunc:Disconnect();
						teamChange:Disconnect();
						ESPholder:Destroy();
						repeat task.wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid");
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
						repeat task.wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid");
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
				espLoopFunc = Services.RunService.RenderStepped:Connect(espLoop);
			end
		end
	end)
end

local function PlrFly()
	repeat task.wait() until Services.Players.LocalPlayer and Services.Players.LocalPlayer.Character and getRoot(Services.Players.LocalPlayer.Character) and Services.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid");
	repeat task.wait() until Functions.Variables.Mouse;
	if Functions.Variables.FlyKeyDown or Functions.Variables.FlyKeyUp then
		Functions.Variables.FlyKeyDown:Disconnect();
		Functions.Variables.FlyKeyUp:Disconnect();
	end

	local T = getRoot(Services.Players.LocalPlayer.Character);
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

local function PlrUnFly()
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
			Float.CFrame = getRoot(pchar).CFrame * CFrame.new(0, FloatValue, 0);
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
					Float.CFrame = getRoot(pchar).CFrame * CFrame.new(0, FloatValue, 0);
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

local function PlayerGoTo(plr)
	if plr.Character ~= nil then
		if Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') and Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').SeatPart then
			Services.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Sit = false;
			task.wait(0.1);
		end
		getRoot(Services.Players.LocalPlayer.Character).CFrame = getRoot(plr.Character).CFrame + Vector3.new(3, 1, 0);
	end
end

Functions.Variables = {
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
	["Mouse"] = Services.Players.LocalPlayer:GetMouse()
};

function Functions:NoClip()
	Functions.Variables.NoClipping = Services.RunService.Stepped:Connect(NoclipLoop);
end

function Functions:UnNoClip()
	if Functions.Variables.NoClipping then
		Functions.Variables.NoClipping:Disconnect();
	end
end

function Functions:SingleESP(plr)
	Functions.Variables.ESPEnabled = true;
	Functions.Variables.MultiESP = false;
	if plr.Name ~= Services.Players.LocalPlayer.Name then
		PlayerESP(plr);
	end
end

function Functions:AllESP()
	Functions.Variables.ESPEnabled = true;
	Functions.Variables.MultiESP = true;
	for i, v in pairs(Services.Players:GetPlayers()) do
		if v.Name ~= Services.Players.LocalPlayer.Name then
			PlayerESP(v);
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
	PlrUnFly();
	wait();
	PlrFly();
end

function Functions:UnFly()
	PlrUnFly();
end

function Functions:Float()
	Functions.Variables.Floating = true;
	PlayerFloat();
end

function Functions:UnFloat()
	Functions.Variables.Floating = false;
	PlayerUnFloat();
end

return Functions;
