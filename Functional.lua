local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local DataStoreService = game:GetService("DataStoreService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local ModuleConfig = script.Configuration
local Loaded = ModuleConfig.Loaded
local Khim_Functional = {}
Khim_Functional.__index = Khim_Functional

local Main = script.Parent
local LoadedModule = {
	Server = {},
	Client = {}
}

local ServerConfig = {}
local ClientConfig = {}

if RunService:IsClient() then
	if not Loaded then
		repeat task.wait() until Loaded.Value
	end
end
if RunService:IsServer() and not Loaded.Value then
	warn("[Functional] Loading : Functional by Khim")
	for _, v in pairs(Main.Modules:GetDescendants()) do
		if v:IsA("ModuleScript") then
			LoadedModule[v.Name] = v
			task.spawn(function()
				Khim_Functional[v.Name] = v
			end)
			task.wait()
		end
	end
	if not Loaded.Value then
		Loaded.Value = true
		warn("[Functional] Loaded Functional")
	end
end
function Khim_Functional:GetModule(Name, Return)
	if not Loaded.Value then repeat task.wait() until Loaded.Value end
	if LoadedModule[Name] or LoadedModule[string.lower(Name)] then
		if Return then
			return LoadedModule[Name]
		else
			return require(LoadedModule[Name])
		end
	else
		warn("[Functional] The " .. string.lower(Name) .. " module you requested could not be found!")
	end
end
function Khim_Functional:FindObject(Object, Target)
	if Object:FindFirstChild(Target) then
		return Object:FindFirstChild(Target)
	elseif Object:FindFirstChildOfClass(Target) then
		return Object:FindFirstChildOfClass(Target)
	end
end
function Khim_Functional:Debris(Object, DebrisTime)
	if typeof(Object) == "table" then
		for _, v in pairs(Object) do
			task.spawn(function()
				Debris:AddItem(v, DebrisTime)
			end)
		end
	else
		Debris:AddItem(Object, DebrisTime)
	end
end
function Khim_Functional:Damage(Object, Damage)
	if Object.ClassName == "Humanoid" then
		Object:TakeDamage(Damage)
	else
		local Humanoid = self:FindObject(Object, "Humanoid")
		if Humanoid then
			Humanoid:TakeDamage(Damage)
		end
	end
end
function Khim_Functional:LoadData(DatastoreName, Key)
	local Data = DataStoreService:GetDataStore(DatastoreName)
	return Data:GetAsync(Key)
end
function Khim_Functional:SaveData(DatastoreName, Key, Data)
	local DataStore = DataStoreService:GetDataStore(DatastoreName)
	local Success, Error = pcall(function()
		DataStore:SetAsync(Key, Data)
	end)
	return Success, Error
end
function Khim_Functional:TweenObject(Object, TweenInfoData, Properties)
	local Tween = TweenService:Create(Object, TweenInfo.new(unpack(TweenInfoData)), Properties)
	return Tween
end
function Khim_Functional:SpawnPart(Properties, Parent)
	local Part = Instance.new("Part",Parent)
	for Property, Value in pairs(Properties) do
		Part[Property] = Value
	end
	return Part
end
function Khim_Functional:CreateLight(LightType, Properties, Parent)
	local Light = Instance.new(LightType, Parent)
	for Property, Value in pairs(Properties) do
		Light[Property] = Value
	end
	return Light
end
function Khim_Functional:TeleportPlayer(Player, Position, Orientation)
	if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
		local HRP = Player.Character.HumanoidRootPart
		HRP.CFrame = CFrame.new(Position) * CFrame.Angles(math.rad(Orientation.X), math.rad(Orientation.Y), math.rad(Orientation.Z))
	end
end
function Khim_Functional:ApplyForce(Object, ForceVector, DebrisTime)
	local BodyForce = Instance.new("BodyForce")
	BodyForce.Force = ForceVector
	BodyForce.Parent = Object
	Debris:AddItem(BodyForce, DebrisTime)
end
function Khim_Functional:GiveTool(Player, ToolName)
	local Tool = ReplicatedStorage:FindFirstChild(ToolName):Clone()
	Tool.Parent = Player.Backpack
end
function Khim_Functional:ChangeLighting(Property, Value)
	if Lighting[Property] ~= nil then
		Lighting[Property] = Value
	end
end
function Khim_Functional:FreezePlayer(Player, Duration)
	if Player.Character and Player.Character:FindFirstChild("Humanoid") then
		local Humanoid = Player.Character.Humanoid
		Humanoid.WalkSpeed = 0
		task.delay(Duration, function()
			Humanoid.WalkSpeed = 16
		end)
	end
end
function Khim_Functional:BroadcastMessage(Message, Color)
	for _, Player in pairs(Players:GetPlayers()) do
		local MessageEvent = ReplicatedStorage:FindFirstChild("MessageEvent")
		if MessageEvent then
			MessageEvent:FireClient(Player, Message, Color)
		end
	end
end
function Khim_Functional:SendHttpRequest(Url, Method, Headers, Body)
	local Success, Response = pcall(function()
		return HttpService:RequestAsync({
			Url = Url,
			Method = Method,
			Headers = Headers,
			Body = HttpService:JSONEncode(Body)
		})
	end)
	return Success, Response
end
function Khim_Functional:CreateShield(Player, Duration, Transparency)
	local Shield = Instance.new("ForceField")
	Shield.Visible = Transparency ~= nil and Transparency or true
	Shield.Parent = Player.Character
	task.delay(Duration, function()
		Shield:Destroy()
	end)
	return Shield
end
function Khim_Functional:TriggerEffect(EffectName, Properties, Parent)
	local Effect = ReplicatedStorage.Assets.FX:FindFirstChild(EffectName):Clone()
	for Property, Value in pairs(Properties) do
		Effect[Property] = Value
	end
	Effect.Parent = Parent or workspace
end
function Khim_Functional:SetPlayerWalkSpeed(Player, Speed)
	if Player.Character and Player.Character:FindFirstChild("Humanoid") then
		Player.Character.Humanoid.WalkSpeed = Speed
	end
end
function Khim_Functional:SetPlayerJumpPower(Player, Power)
	if Player.Character and Player.Character:FindFirstChild("Humanoid") then
		Player.Character.Humanoid.JumpPower = Power
	end
end
function Khim_Functional:CloneObject(Object, Parent)
	Object.Archivable = true
	local Clone = Object:Clone()
	Clone.Parent = Parent
	return Clone
end
function Khim_Functional:Raycast(Origin, Direction, Params)
	local RaycastParams = Params or RaycastParams.new()
	return workspace:Raycast(Origin, Direction, RaycastParams)
end
function Khim_Functional:FindNearestPlayer(Position, MaxDistance)
	local NearestPlayer = nil
	local ShortestDistance = MaxDistance
	for _, Player in pairs(Players:GetPlayers()) do
		if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
			local Distance = (Player.Character.HumanoidRootPart.Position - Position).Magnitude
			if Distance < ShortestDistance then
				NearestPlayer = Player
				ShortestDistance = Distance
			end
		end
	end
	return NearestPlayer
end
function Khim_Functional:MonitorPartDestruction(Part, Callback)
	assert(typeof(Part) == "Instance" and Part:IsA("BasePart"), "MonitorPartDestruction expects a BasePart.")
	assert(typeof(Callback) == "function", "MonitorPartDestruction expects a callback function.")

	Part.AncestryChanged:Connect(function(_, Parent)
		if not Parent then
			Callback()
		end
	end)
end
function Khim_Functional:PlaySound(SoundId, Volume)
	assert(typeof(SoundId) == "string" or typeof(SoundId) == "number", "PlaySound expects a string or number for SoundId.")
	Volume = Volume or 1 

	local Sound = Instance.new("Sound")
	Sound.SoundId = "rbxassetid://" .. SoundId
	Sound.Volume = Volume
	Sound.PlayOnRemove = true 
	Sound.Parent = workspace

	Sound:Destroy() 
	return Sound
end
function Khim_Functional:CreateHighlight(Properties)
	assert(typeof(Properties) == "table", "CreateHighlight expects a table of properties.")

	local Highlight = Instance.new("Highlight")
	for Property, Value in pairs(Properties) do
		if Highlight[Property] ~= nil then 
			Highlight[Property] = Value
		else
			warn(string.format("Invalid property '%s' for Highlight. Skipping.", Property))
		end
	end
	return Highlight
end
function Khim_Functional:AddClickDetector(Part, Callback)
	assert(Part:IsA("BasePart"), "AddClickDetector expects a BasePart.")
	assert(typeof(Callback) == "function", "AddClickDetector expects a callback function.")

	local ClickDetector = Instance.new("ClickDetector", Part)
	ClickDetector.MouseClick:Connect(function(Player)
		Callback(Player)
	end)

	return ClickDetector
end
function Khim_Functional:CreateProximityPrompt(Part, Properties, Callback)
	assert(Part:IsA("BasePart"), "CreateProximityPrompt expects a BasePart.")
	assert(typeof(Properties) == "table", "CreateProximityPrompt expects a table of properties.")
	assert(typeof(Callback) == "function", "CreateProximityPrompt expects a callback function.")

	local ProximityPrompt = Instance.new("ProximityPrompt", Part)

	for Property, Value in pairs(Properties) do
		if ProximityPrompt[Property] ~= nil then
			ProximityPrompt[Property] = Value
		else
			warn(string.format("Invalid property '%s' for ProximityPrompt. Skipping.", Property))
		end
	end

	ProximityPrompt.Triggered:Connect(Callback)

	return ProximityPrompt
end

function Khim_Functional:ToggleState(StateTable, StateName, Value)
	assert(typeof(StateTable) == "table", "ToggleGameState expects a table of states.")
	assert(typeof(StateName) == "string", "ToggleGameState expects a state name.")

	StateTable[StateName] = Value
	return StateTable[StateName]
end

return Khim_Functional
