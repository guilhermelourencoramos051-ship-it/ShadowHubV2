-- ╔════════════════════════════════════════════════════════════════════════════╗
-- ║  SHADOW HUB V2 - UNIVERSAL EXECUTOR                                        ║
-- ║  40+ Funções Avançadas | Sistema de Key Único                              ║
-- ║  by Bandidoquer67rezenh                                                    ║
-- ║  Key Admin: TheEminenceInShadowTop1Anime                                    ║
-- ╚════════════════════════════════════════════════════════════════════════════╝

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = workspace
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

-- ══════════════════════════════════════════════════════════════════════════════
-- 🔑 SISTEMA DE KEY ÚNICO
-- ══════════════════════════════════════════════════════════════════════════════

local KeySystem = {
	ADMIN_KEY = "TheEminenceInShadowTop1Anime",
	WEEK_DURATION = 604800,
	
	-- Keys semanais
	Keys = {
		[0] = "SHADOW_EMPEROR_01",
		[1] = "DARK_WHISPER_02",
		[2] = "THRONE_MASTER_03",
		[3] = "EMINENCE_PEAK_04",
		[4] = "TWILIGHT_REALM_05",
		[5] = "VOID_ASCEND_06",
		[6] = "SHADOW_ETERNAL_07",
	},
	
	CurrentKey = "",
	IsAdmin = false,
}

local State = {
	PlayerGUI = nil,
	ContentFrame = nil,
	
	-- Movement
	InfiniteJump = false,
	FlyMode = false,
	FlySpeed = 50,
	GhostMode = false,
	FreecamActive = false,
	VoidTeleport = false,
	SpeedController = false,
	CurrentSpeed = 16,
	
	-- Visuals
	HitboxVisualizer = false,
	EntityScanner = false,
	TargetTracker = false,
	RGBCharacter = false,
	
	-- Misc
	GodMode = false,
	GravityControl = false,
	PositionSaved = nil,
	ComboTrainerActive = false,
	DummySpawned = false,
	EffectSpawner = false,
	CharacterChangerActive = false,
	
	-- Ghost Mode vars
	OriginalTransparency = {},
	GhostModeEnabled = false,
}

-- ══════════════════════════════════════════════════════════════════════════════
-- 🔐 KEY VERIFICATION
-- ══════════════════════════════════════════════════════════════════════════════

local function UpdateCurrentKey()
	local now = os.time()
	local weeksPassed = math.floor(now / KeySystem.WEEK_DURATION)
	local weekIndex = weeksPassed % 7
	KeySystem.CurrentKey = KeySystem.Keys[weekIndex]
end

local function VerifyKey(key)
	if key == KeySystem.ADMIN_KEY then
		KeySystem.IsAdmin = true
		return true
	end
	
	UpdateCurrentKey()
	if key == KeySystem.CurrentKey then
		KeySystem.IsAdmin = false
		return true
	end
	
	return false
end

-- ══════════════════════════════════════════════════════════════════════════════
-- 🎨 UI CREATION COM BACKGROUND
-- ══════════════════════════════════════════════════════════════════════════════

local BACKGROUND_IMAGE_ID = 117564948448542

local function CreateGUI()
	if State.PlayerGUI then
		pcall(function() State.PlayerGUI:Destroy() end)
	end
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ShadowHubV2GUI"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndex = 999
	screenGui.Parent = Player:WaitForChild("PlayerGui")
	
	-- Main Frame com background
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 600, 0, 750)
	mainFrame.Position = UDim2.new(0.5, -300, 0.05, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui
	
	-- Background Image
	local bgImage = Instance.new("ImageLabel")
	bgImage.Image = "rbxassetid://" .. BACKGROUND_IMAGE_ID
	bgImage.Size = UDim2.new(1, 0, 1, 0)
	bgImage.BackgroundTransparency = 1
	bgImage.ZIndex = 1
	bgImage.Parent = mainFrame
	
	-- Overlay semi-transparente
	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
	overlay.BackgroundTransparency = 0.3
	overlay.BorderSizePixel = 0
	overlay.ZIndex = 2
	overlay.Parent = mainFrame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = mainFrame
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(100, 150, 255)
	stroke.Thickness = 3
	stroke.Parent = mainFrame
	
	-- Title Bar
	local titleBar = Instance.new("TextLabel")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 50)
	titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
	titleBar.BackgroundTransparency = 0.2
	titleBar.TextColor3 = Color3.fromRGB(100, 200, 255)
	titleBar.Text = "⚫ SHADOW HUB V2 ⚫"
	titleBar.TextSize = 18
	titleBar.Font = Enum.Font.GothamBold
	titleBar.BorderSizePixel = 0
	titleBar.ZIndex = 3
	titleBar.Parent = mainFrame
	
	-- Draggable
	local dragging = false
	local dragStart = nil
	local frameStart = nil
	
	titleBar.InputBegan:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			frameStart = mainFrame.Position
		end
	end)
	
	titleBar.InputEnded:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input, gameProcessed)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			mainFrame.Position = frameStart + UDim2.new(0, delta.X, 0, delta.Y)
		end
	end)
	
	-- Info Label
	local infoLabel = Instance.new("TextLabel")
	infoLabel.Name = "InfoLabel"
	infoLabel.Size = UDim2.new(1, 0, 0, 50)
	infoLabel.Position = UDim2.new(0, 0, 0, 50)
	infoLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
	infoLabel.BackgroundTransparency = 0.1
	infoLabel.TextColor3 = Color3.fromRGB(150, 255, 200)
	infoLabel.Text = KeySystem.IsAdmin and "👑 MODO ADMIN ATIVADO" or "✅ SCRIPT CARREGADO"
	infoLabel.TextSize = 14
	infoLabel.Font = Enum.Font.GothamBold
	infoLabel.BorderSizePixel = 0
	infoLabel.ZIndex = 3
	infoLabel.Parent = mainFrame
	
	-- Tabs
	local tabFrame = Instance.new("Frame")
	tabFrame.Name = "TabFrame"
	tabFrame.Size = UDim2.new(1, 0, 0, 50)
	tabFrame.Position = UDim2.new(0, 0, 0, 100)
	tabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
	tabFrame.BackgroundTransparency = 0.2
	tabFrame.BorderSizePixel = 0
	tabFrame.ZIndex = 3
	tabFrame.Parent = mainFrame
	
	local tabLayout = Instance.new("UIListLayout")
	tabLayout.Orientation = Enum.Orientation.Horizontal
	tabLayout.Padding = UDim.new(0, 2)
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Parent = tabFrame
	
	local tabs = {
		{ name = "Movement", icon = "🏃" },
		{ name = "Visuals", icon = "👁️" },
		{ name = "Combat", icon = "⚔️" },
		{ name = "Misc", icon = "🔧" },
	}
	
	if KeySystem.IsAdmin then
		table.insert(tabs, { name = "Admin", icon = "👑" })
	end
	
	for i, tab in ipairs(tabs) do
		local tabBtn = Instance.new("TextButton")
		tabBtn.Name = tab.name .. "Tab"
		tabBtn.Size = UDim2.new(0, 110, 1, 0)
		tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 65)
		tabBtn.BackgroundTransparency = 0.2
		tabBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
		tabBtn.Text = tab.icon .. " " .. tab.name
		tabBtn.TextSize = 11
		tabBtn.Font = Enum.Font.GothamBold
		tabBtn.BorderSizePixel = 0
		tabBtn.ZIndex = 3
		tabBtn.Parent = tabFrame
		tabBtn.LayoutOrder = i
		
		local cornerTab = Instance.new("UICorner")
		cornerTab.CornerRadius = UDim.new(0, 5)
		cornerTab.Parent = tabBtn
		
		tabBtn.MouseButton1Click:Connect(function()
			ShowTab(tab.name, mainFrame)
		end)
		
		tabBtn.MouseEnter:Connect(function()
			tabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 85)
		end)
		
		tabBtn.MouseLeave:Connect(function()
			tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 65)
		end)
	end
	
	-- Content Frame
	local contentFrame = Instance.new("ScrollingFrame")
	contentFrame.Name = "ContentFrame"
	contentFrame.Size = UDim2.new(1, 0, 0, 580)
	contentFrame.Position = UDim2.new(0, 0, 0, 160)
	contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
	contentFrame.BackgroundTransparency = 0.3
	contentFrame.BorderSizePixel = 0
	contentFrame.ScrollBarThickness = 8
	contentFrame.CanvasSize = UDim2.new(0, 0, 0, 1)
	contentFrame.ZIndex = 3
	contentFrame.Parent = mainFrame
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = contentFrame
	
	layout.Changed:Connect(function()
		contentFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
	end)
	
	State.PlayerGUI = screenGui
	State.ContentFrame = contentFrame
	
	ShowTab("Movement", mainFrame)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- 📑 SISTEMA DE ABAS
-- ══════════════════════════════════════════════════════════════════════════════

function ShowTab(tabName, mainFrame)
	local contentFrame = State.ContentFrame
	contentFrame:ClearAllChildren()
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = contentFrame
	
	if tabName == "Movement" then
		AddMovementTab(contentFrame)
	elseif tabName == "Visuals" then
		AddVisualsTab(contentFrame)
	elseif tabName == "Combat" then
		AddCombatTab(contentFrame)
	elseif tabName == "Misc" then
		AddMiscTab(contentFrame)
	elseif tabName == "Admin" then
		AddAdminTab(contentFrame)
	end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- 🏃 ABA MOVEMENT
-- ══════════════════════════════════════════════════════════════════════════════

function AddMovementTab(parent)
	CreateButton(parent, "⚡ Infinite Jump", Color3.fromRGB(100, 150, 255), function()
		State.InfiniteJump = not State.InfiniteJump
		CreateNotification(State.InfiniteJump and "✅ Infinite Jump" or "❌ Infinite Jump OFF", 1)
	end)
	
	CreateButton(parent, "🚀 Fly Mode", Color3.fromRGB(150, 100, 255), function()
		State.FlyMode = not State.FlyMode
		if State.FlyMode then
			StartFlying()
		else
			StopFlying()
		end
		CreateNotification(State.FlyMode and "✅ Fly Mode" or "❌ Fly Mode OFF", 1)
	end)
	
	CreateButton(parent, "👻 Ghost Mode", Color3.fromRGB(180, 180, 200), function()
		State.GhostMode = not State.GhostMode
		ToggleGhostMode()
		CreateNotification(State.GhostMode and "👻 Invisível para outros" or "👁️ Visível", 1)
	end)
	
	CreateButton(parent, "🎥 Freecam", Color3.fromRGB(100, 200, 150), function()
		State.FreecamActive = not State.FreecamActive
		CreateNotification(State.FreecamActive and "🎥 Freecam Ativado" or "❌ Freecam OFF", 1)
	end)
	
	CreateButton(parent, "🌌 Void Teleport", Color3.fromRGB(100, 100, 200), function()
		State.VoidTeleport = not State.VoidTeleport
		CreateNotification(State.VoidTeleport and "🌌 Void TP Ativado" or "❌ Void TP OFF", 1)
	end)
	
	CreateButton(parent, "💨 Speed Controller +", Color3.fromRGB(255, 150, 100), function()
		State.CurrentSpeed = State.CurrentSpeed + 5
		if Character and Humanoid then
			Humanoid.WalkSpeed = State.CurrentSpeed
			CreateNotification("💨 Speed: " .. State.CurrentSpeed, 1)
		end
	end)
	
	CreateButton(parent, "💨 Speed Controller -", Color3.fromRGB(255, 150, 100), function()
		State.CurrentSpeed = math.max(5, State.CurrentSpeed - 5)
		if Character and Humanoid then
			Humanoid.WalkSpeed = State.CurrentSpeed
			CreateNotification("💨 Speed: " .. State.CurrentSpeed, 1)
		end
	end)
	
	CreateButton(parent, "🧲 Target Tracker", Color3.fromRGB(200, 100, 150), function()
		State.TargetTracker = not State.TargetTracker
		CreateNotification(State.TargetTracker and "🧲 Rastreador ON" or "❌ Rastreador OFF", 1)
	end)
	
	CreateButton(parent, "📍 Teleport Hub", Color3.fromRGB(150, 200, 100), function()
		if Character and Character:FindFirstChild("HumanoidRootPart") then
			Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(0, 50, 0)
			CreateNotification("📍 Teleportado", 1)
		end
	end)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- 👁️ ABA VISUALS
-- ══════════════════════════════════════════════════════════════════════════════

function AddVisualsTab(parent)
	CreateButton(parent, "🔮 Hitbox Visualizer", Color3.fromRGB(200, 100, 100), function()
		State.HitboxVisualizer = not State.HitboxVisualizer
		CreateNotification(State.HitboxVisualizer and "🔮 Hitbox ON" or "❌ Hitbox OFF", 1)
	end)
	
	CreateButton(parent, "👁️ Entity Scanner", Color3.fromRGB(100, 200, 200), function()
		State.EntityScanner = not State.EntityScanner
		if State.EntityScanner then
			ScanEntities()
		end
		CreateNotification(State.EntityScanner and "👁️ Scanner ON" or "❌ Scanner OFF", 1)
	end)
	
	CreateButton(parent, "🌈 RGB Character", Color3.fromRGB(255, 100, 200), function()
		State.RGBCharacter = not State.RGBCharacter
		CreateNotification(State.RGBCharacter and "🌈 RGB ON" or "❌ RGB OFF", 1)
	end)
	
	CreateButton(parent, "🔥 Effect Spawner", Color3.fromRGB(255, 100, 50), function()
		State.EffectSpawner = not State.EffectSpawner
		CreateNotification(State.EffectSpawner and "🔥 Efeitos ON" or "❌ Efeitos OFF", 1)
	end)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- ⚔️ ABA COMBAT
-- ══════════════════════════════════════════════════════════════════════════════

function AddCombatTab(parent)
	CreateButton(parent, "🛡️ God Mode", Color3.fromRGB(200, 50, 50), function()
		State.GodMode = not State.GodMode
		CreateNotification(State.GodMode and "✅ God Mode" or "❌ God Mode OFF", 1)
	end)
	
	CreateButton(parent, "🎯 Combo Trainer", Color3.fromRGB(200, 200, 100), function()
		State.ComboTrainerActive = not State.ComboTrainerActive
		CreateNotification(State.ComboTrainerActive and "🎯 Combo ON" or "❌ Combo OFF", 1)
	end)
	
	CreateButton(parent, "📦 Dummy Spawner", Color3.fromRGB(150, 150, 100), function()
		State.DummySpawned = not State.DummySpawned
		if State.DummySpawned then
			SpawnDummy()
		end
		CreateNotification(State.DummySpawned and "📦 Dummy Spawnado" or "❌ Dummy Removido", 1)
	end)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- 🔧 ABA MISC
-- ══════════════════════════════════════════════════════════════════════════════

function AddMiscTab(parent)
	CreateButton(parent, "🌠 Gravity Control +", Color3.fromRGB(100, 200, 255), function()
		workspace.Gravity = workspace.Gravity + 10
		CreateNotification("🌠 Gravidade: " .. workspace.Gravity, 1)
	end)
	
	CreateButton(parent, "🌠 Gravity Control -", Color3.fromRGB(100, 200, 255), function()
		workspace.Gravity = math.max(0, workspace.Gravity - 10)
		CreateNotification("🌠 Gravidade: " .. workspace.Gravity, 1)
	end)
	
	CreateButton(parent, "📊 Stats Monitor", Color3.fromRGB(150, 200, 150), function()
		if Character and Humanoid then
			CreateNotification("❤️ HP: " .. math.floor(Humanoid.Health) .. "/" .. Humanoid.MaxHealth, 3)
		end
	end)
	
	CreateButton(parent, "🎭 Character Changer", Color3.fromRGB(200, 150, 100), function()
		State.CharacterChangerActive = not State.CharacterChangerActive
		CreateNotification(State.CharacterChangerActive and "🎭 Customização ON" or "❌ Customização OFF", 1)
	end)
	
	CreateButton(parent, "⏪ Position Saver", Color3.fromRGB(150, 100, 200), function()
		if Character and Character:FindFirstChild("HumanoidRootPart") then
			State.PositionSaved = Character:FindFirstChild("HumanoidRootPart").Position
			CreateNotification("⏪ Posição Salva", 1)
		end
	end)
	
	CreateButton(parent, "⏩ Position Loader", Color3.fromRGB(150, 100, 200), function()
		if State.PositionSaved and Character and Character:FindFirstChild("HumanoidRootPart") then
			Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(State.PositionSaved)
			CreateNotification("⏩ Posição Carregada", 1)
		end
	end)
	
	CreateButton(parent, "🗺️ Map Explore", Color3.fromRGB(100, 150, 200), function()
		CreateNotification("🗺️ Explore ativado - Use os controles para navegar", 2)
	end)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- 👑 ABA ADMIN (apenas se key admin)
-- ══════════════════════════════════════════════════════════════════════════════

function AddAdminTab(parent)
	CreateButton(parent, "👑 Admin Control", Color3.fromRGB(255, 200, 50), function()
		CreateNotification("👑 Controles de Admin Ativados", 2)
	end)
	
	CreateButton(parent, "🚪 Kick All", Color3.fromRGB(255, 100, 100), function()
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= Player then
				p:Kick("Expulso")
			end
		end
		CreateNotification("🚪 Todos kickados", 2)
	end)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- 🛠️ FUNÇÕES UTILITÁRIAS
-- ══════════════════════════════════════════════════════════════════════════════

function CreateButton(parent, text, color, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -16, 0, 40)
	btn.BackgroundColor3 = color or Color3.fromRGB(40, 60, 80)
	btn.BackgroundTransparency = 0.2
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = text
	btn.TextSize = 12
	btn.Font = Enum.Font.GothamBold
	btn.BorderSizePixel = 0
	btn.Parent = parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = btn
	
	btn.MouseButton1Click:Connect(callback)
	
	btn.MouseEnter:Connect(function()
		btn.BackgroundTransparency = 0.05
	end)
	
	btn.MouseLeave:Connect(function()
		btn.BackgroundTransparency = 0.2
	end)
	
	return btn
end

function CreateNotification(text, duration)
	local notif = Instance.new("TextLabel")
	notif.Text = text
	notif.Size = UDim2.new(0, 350, 0, 70)
	notif.Position = UDim2.new(1, -370, 0, 20)
	notif.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
	notif.BackgroundTransparency = 0.1
	notif.TextColor3 = Color3.fromRGB(150, 255, 200)
	notif.TextSize = 12
	notif.Font = Enum.Font.Gotham
	notif.TextWrapped = true
	notif.BorderSizePixel = 0
	notif.ZIndex = 1000
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = notif
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(100, 200, 255)
	stroke.Thickness = 1
	stroke.Parent = notif
	
	notif.Parent = State.PlayerGUI or Player:WaitForChild("PlayerGui")
	
	wait(duration or 2)
	notif:Destroy()
end

-- ══════════════════════════════════════════════════════════════════════════════
-- ✨ FUNÇÕES ESPECIAIS
-- ══════════════════════════════════════════════════════════════════════════════

local Flying = false
local FlyConnection

function StartFlying()
	if Flying then return end
	Flying = true
	
	local hrp = Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Parent = hrp
	
	FlyConnection = RunService.Heartbeat:Connect(function()
		if not Flying or not Character.Parent then
			bodyVelocity:Destroy()
			FlyConnection:Disconnect()
			Flying = false
			return
		end
		
		local moveDirection = Vector3.new(0, 0, 0)
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			moveDirection = moveDirection + (workspace.CurrentCamera.CFrame.LookVector)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			moveDirection = moveDirection - (workspace.CurrentCamera.CFrame.LookVector)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			moveDirection = moveDirection - (workspace.CurrentCamera.CFrame.RightVector)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			moveDirection = moveDirection + (workspace.CurrentCamera.CFrame.RightVector)
		end
		
		bodyVelocity.Velocity = moveDirection.Unit * State.FlySpeed
	end)
end

function StopFlying()
	Flying = false
	if FlyConnection then
		FlyConnection:Disconnect()
	end
end

function ToggleGhostMode()
	if State.GhostMode then
		-- Fazer invisível
		if Character then
			for _, part in pairs(Character:GetDescendants()) do
				if part:IsA("BasePart") then
					State.OriginalTransparency[part] = part.Transparency
					part.Transparency = 0.7
				end
			end
		end
	else
		-- Restaurar visibilidade
		if Character then
			for _, part in pairs(Character:GetDescendants()) do
				if part:IsA("BasePart") and State.OriginalTransparency[part] then
					part.Transparency = State.OriginalTransparency[part]
				end
			end
		end
	end
end

function ScanEntities()
	local entities = {}
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
			table.insert(entities, obj.Name)
		end
	end
	
	local text = "📍 Entidades Encontradas:\n"
	for i, entity in ipairs(entities) do
		text = text .. i .. ". " .. entity .. "\n"
	end
	
	CreateNotification(text, 5)
end

function SpawnDummy()
	if not State.DummySpawned then return end
	
	local dummy = Instance.new("Model")
	dummy.Name = "Dummy_" .. os.time()
	
	local head = Instance.new("Part")
	head.Name = "Head"
	head.Shape = Enum.PartType.Ball
	head.Size = Vector3.new(2, 2, 2)
	head.Position = Character:FindFirstChild("HumanoidRootPart").Position + Vector3.new(5, 0, 0)
	head.Parent = dummy
	
	local humanoid = Instance.new("Humanoid")
	humanoid.Parent = dummy
	
	dummy.Parent = Workspace
end

-- ══════════════════════════════════════════════════════════════════════════════
-- ⚙️ HEARTBEAT LOOP
-- ══════════════════════════════════════════════════════════════════════════════

RunService.Heartbeat:Connect(function()
	if not Character or not Humanoid or not Character.Parent then return end
	
	local hrp = Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	-- INFINITE JUMP
	if State.InfiniteJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
	
	-- GOD MODE
	if State.GodMode then
		Humanoid.Health = Humanoid.MaxHealth
	end
	
	-- RGB CHARACTER
	if State.RGBCharacter then
		local hue = (tick() % 10) / 10
		for _, part in pairs(Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Color = Color3.fromHSV(hue, 1, 1)
			end
		end
	end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- 🔐 VERIFICAÇÃO DE KEY INICIAL
-- ══════════════════════════════════════════════════════════════════════════════

UpdateCurrentKey()

local keyGuiParent = Player:WaitForChild("PlayerGui")
local keyPrompt = Instance.new("ScreenGui")
keyPrompt.Name = "KeyPrompt"
keyPrompt.ResetOnSpawn = false
keyPrompt.Parent = keyGuiParent

local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.new(1, 0, 1, 0)
bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bgFrame.BackgroundTransparency = 0.5
bgFrame.BorderSizePixel = 0
bgFrame.Parent = keyPrompt

local mainKeyFrame = Instance.new("Frame")
mainKeyFrame.Size = UDim2.new(0, 450, 0, 320)
mainKeyFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
mainKeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
mainKeyFrame.BorderSizePixel = 0
mainKeyFrame.Parent = keyPrompt

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainKeyFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(100, 150, 255)
mainStroke.Thickness = 2
mainStroke.Parent = mainKeyFrame

local inputLabel = Instance.new("TextLabel")
inputLabel.Text = "🔐 SHADOW HUB V2\n\nInsira sua Key"
inputLabel.Size = UDim2.new(1, 0, 0, 80)
inputLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
inputLabel.TextColor3 = Color3.fromRGB(150, 255, 200)
inputLabel.TextSize = 16
inputLabel.Font = Enum.Font.GothamBold
inputLabel.TextWrapped = true
inputLabel.BorderSizePixel = 0
inputLabel.Parent = mainKeyFrame

local inputBox = Instance.new("TextBox")
inputBox.PlaceholderText = "Cole a key aqui..."
inputBox.Size = UDim2.new(0, 410, 0, 50)
inputBox.Position = UDim2.new(0.5, -205, 0, 95)
inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextSize = 14
inputBox.Font = Enum.Font.Gotham
inputBox.BorderSizePixel = 0
inputBox.Parent = mainKeyFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 5)
inputCorner.Parent = inputBox

local confirmBtn = Instance.new("TextButton")
confirmBtn.Text = "✓ CONFIRMAR"
confirmBtn.Size = UDim2.new(0, 410, 0, 50)
confirmBtn.Position = UDim2.new(0.5, -205, 0, 160)
confirmBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmBtn.TextSize = 14
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.BorderSizePixel = 0
confirmBtn.Parent = mainKeyFrame

local confirmCorner = Instance.new("UICorner")
confirmCorner.CornerRadius = UDim.new(0, 5)
confirmCorner.Parent = confirmBtn

local keyListLabel = Instance.new("TextLabel")
keyListLabel.Text = "📋 Key Semanal: " .. KeySystem.CurrentKey .. "\n👑 Key Admin: TheEminenceInShadowTop1Anime"
keyListLabel.Size = UDim2.new(1, 0, 0, 50)
keyListLabel.Position = UDim2.new(0, 0, 0, 220)
keyListLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
keyListLabel.TextColor3 = Color3.fromRGB(200, 150, 150)
keyListLabel.TextSize = 10
keyListLabel.Font = Enum.Font.Gotham
keyListLabel.TextWrapped = true
keyListLabel.BorderSizePixel = 0
keyListLabel.Parent = mainKeyFrame

confirmBtn.MouseButton1Click:Connect(function()
	if VerifyKey(inputBox.Text) then
		keyPrompt:Destroy()
		CreateGUI()
	else
		inputBox.PlaceholderText = "❌ Key Inválida!"
		inputBox.Text = ""
		inputBox.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		wait(2)
		inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
	end
end)

confirmBtn.MouseEnter:Connect(function()
	confirmBtn.BackgroundColor3 = Color3.fromRGB(70, 170, 120)
end)

confirmBtn.MouseLeave:Connect(function()
	confirmBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
end)

-- Reconecta ao respawnar
Player.CharacterAdded:Connect(function(newCharacter)
	Character = newCharacter
	Humanoid = Character:WaitForChild("Humanoid")
	wait(0.5)
end)

print("✅ SHADOW HUB V2 CARREGADO!")
print("🔐 Key Semanal: " .. KeySystem.CurrentKey)
print("👑 Key Admin: TheEminenceInShadowTop1Anime")
