-- ╔════════════════════════════════════════════════════════════════════════════╗
-- ║  SHADOW HUB - SCRIPT LAUNCHER                                              ║
-- ║  Multi-Script Selector | Universal Executor                               ║
-- ║  by Bandidoquer67rezenh                                                    ║
-- ╚════════════════════════════════════════════════════════════════════════════╝

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- ══════════════════════════════════════════════════════════════════════════════
-- 📜 SCRIPTS DISPONÍVEIS
-- ══════════════════════════════════════════════════════════════════════════════

local SCRIPTS = {
	{
		name = "🌑 Shadow Hub V2",
		description = "Script principal com 40+ funções",
		icon = "⚫",
		url = "https://raw.githubusercontent.com/guilhermelourencoramos051-ship-it/ShadowHubV2/main/ShadowHubV2.lua"
	},
	{
		name = "⚔️ Combat Suite",
		description = "Sistema de combate avançado",
		icon = "🗡️",
		url = "https://raw.githubusercontent.com/guilhermelourencoramos051-ship-it/ShadowHubV2/main/CombatSuite.lua"
	},
	{
		name = "🎮 Utility Pack",
		description = "Utilidades gerais e teleportes",
		icon = "🔧",
		url = "https://raw.githubusercontent.com/guilhermelourencoramos051-ship-it/ShadowHubV2/main/UtilityPack.lua"
	},
}

-- ══════════════════════════════════════════════════════════════════════════════
-- 🎨 CRIAÇÃO DA GUI DO LAUNCHER
-- ══════════════════════════════════════════════════════════════════════════════

local function CreateLauncherUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ScriptLauncher"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndex = 9999
	screenGui.Parent = Player:WaitForChild("PlayerGui")
	
	-- Background
	local bgFrame = Instance.new("Frame")
	bgFrame.Size = UDim2.new(1, 0, 1, 0)
	bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bgFrame.BackgroundTransparency = 0.7
	bgFrame.BorderSizePixel = 0
	bgFrame.Parent = screenGui
	
	-- Main Container
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 600, 0, 500)
	mainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
	mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 15)
	corner.Parent = mainFrame
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(100, 150, 255)
	stroke.Thickness = 3
	stroke.Parent = mainFrame
	
	-- Title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, 0, 0, 60)
	titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
	titleLabel.TextColor3 = Color3.fromRGB(150, 255, 200)
	titleLabel.Text = "⚫ SCRIPT LAUNCHER ⚫"
	titleLabel.TextSize = 22
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.BorderSizePixel = 0
	titleLabel.Parent = mainFrame
	
	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 15)
	titleCorner.Parent = titleLabel
	
	-- Subtitle
	local subtitleLabel = Instance.new("TextLabel")
	subtitleLabel.Size = UDim2.new(1, 0, 0, 40)
	subtitleLabel.Position = UDim2.new(0, 0, 0, 60)
	subtitleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
	subtitleLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
	subtitleLabel.Text = "Selecione um script para carregar"
	subtitleLabel.TextSize = 14
	subtitleLabel.Font = Enum.Font.Gotham
	subtitleLabel.BorderSizePixel = 0
	subtitleLabel.Parent = mainFrame
	
	-- Scroll Frame
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size = UDim2.new(1, -20, 0, 350)
	scrollFrame.Position = UDim2.new(0, 10, 0, 110)
	scrollFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 8
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1)
	scrollFrame.Parent = mainFrame
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 10)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = scrollFrame
	
	layout.Changed:Connect(function()
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
	end)
	
	-- Script Buttons
	for i, script in ipairs(SCRIPTS) do
		local scriptBtn = Instance.new("TextButton")
		scriptBtn.Size = UDim2.new(1, -20, 0, 80)
		scriptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
		scriptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		scriptBtn.Text = ""
		scriptBtn.BorderSizePixel = 0
		scriptBtn.Parent = scrollFrame
		scriptBtn.LayoutOrder = i
		
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 10)
		btnCorner.Parent = scriptBtn
		
		-- Icon
		local iconLabel = Instance.new("TextLabel")
		iconLabel.Size = UDim2.new(0, 60, 1, 0)
		iconLabel.BackgroundTransparency = 1
		iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		iconLabel.Text = script.icon
		iconLabel.TextSize = 30
		iconLabel.Font = Enum.Font.GothamBold
		iconLabel.Parent = scriptBtn
		
		-- Info Container
		local infoFrame = Instance.new("Frame")
		infoFrame.Size = UDim2.new(1, -80, 1, 0)
		infoFrame.Position = UDim2.new(0, 60, 0, 0)
		infoFrame.BackgroundTransparency = 1
		infoFrame.Parent = scriptBtn
		
		-- Script Name
		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, -10, 0, 30)
		nameLabel.Position = UDim2.new(0, 10, 0, 5)
		nameLabel.BackgroundTransparency = 1
		nameLabel.TextColor3 = Color3.fromRGB(150, 255, 200)
		nameLabel.Text = script.name
		nameLabel.TextSize = 14
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.Parent = infoFrame
		
		-- Description
		local descLabel = Instance.new("TextLabel")
		descLabel.Size = UDim2.new(1, -10, 0, 30)
		descLabel.Position = UDim2.new(0, 10, 0, 35)
		descLabel.BackgroundTransparency = 1
		descLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
		descLabel.Text = script.description
		descLabel.TextSize = 11
		descLabel.Font = Enum.Font.Gotham
		descLabel.TextXAlignment = Enum.TextXAlignment.Left
		descLabel.Parent = infoFrame
		
		-- Load Button
		local loadBtn = Instance.new("TextButton")
		loadBtn.Size = UDim2.new(0, 80, 0, 30)
		loadBtn.Position = UDim2.new(1, -95, 0.5, -15)
		loadBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
		loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		loadBtn.Text = "CARREGAR"
		loadBtn.TextSize = 10
		loadBtn.Font = Enum.Font.GothamBold
		loadBtn.BorderSizePixel = 0
		loadBtn.Parent = scriptBtn
		
		local loadCorner = Instance.new("UICorner")
		loadCorner.CornerRadius = UDim.new(0, 5)
		loadCorner.Parent = loadBtn
		
		loadBtn.MouseButton1Click:Connect(function()
			LoadScript(script.url, screenGui)
		end)
		
		loadBtn.MouseEnter:Connect(function()
			loadBtn.BackgroundColor3 = Color3.fromRGB(70, 170, 120)
		end)
		
		loadBtn.MouseLeave:Connect(function()
			loadBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
		end)
		
		scriptBtn.MouseEnter:Connect(function()
			scriptBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
		end)
		
		scriptBtn.MouseLeave:Connect(function()
			scriptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
		end)
	end
	
	return screenGui
end

-- ══════════════════════════════════════════════════════════════════════════════
-- 📥 FUNÇÃO DE CARREGAR SCRIPT
-- ══════════════════════════════════════════════════════════════════════════════

function LoadScript(url, launcherGui)
	local loadingGui = Instance.new("ScreenGui")
	loadingGui.Name = "LoadingScreen"
	loadingGui.ResetOnSpawn = false
	loadingGui.ZIndex = 10000
	loadingGui.Parent = Player:WaitForChild("PlayerGui")
	
	local loadingFrame = Instance.new("Frame")
	loadingFrame.Size = UDim2.new(1, 0, 1, 0)
	loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	loadingFrame.BackgroundTransparency = 0.8
	loadingFrame.BorderSizePixel = 0
	loadingFrame.Parent = loadingGui
	
	local loadingLabel = Instance.new("TextLabel")
	loadingLabel.Size = UDim2.new(0, 300, 0, 100)
	loadingLabel.Position = UDim2.new(0.5, -150, 0.5, -50)
	loadingLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
	loadingLabel.TextColor3 = Color3.fromRGB(150, 255, 200)
	loadingLabel.Text = "⏳ CARREGANDO...\n\nPor favor aguarde..."
	loadingLabel.TextSize = 16
	loadingLabel.Font = Enum.Font.GothamBold
	loadingLabel.BorderSizePixel = 0
	loadingLabel.TextWrapped = true
	loadingLabel.Parent = loadingGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = loadingLabel
	
	spawn(function()
		wait(1)
		
		-- Tenta carregar o script
		local success = pcall(function()
			local httpService = game:GetService("HttpService")
			local scriptCode = httpService:GetAsync(url)
			
			if scriptCode then
				-- Remove o launcher
				launcherGui:Destroy()
				loadingGui:Destroy()
				
				-- Executa o novo script
				loadstring(scriptCode)()
				
				print("✅ Script carregado com sucesso!")
			end
		end)
		
		if not success then
			loadingLabel.Text = "❌ ERRO AO CARREGAR\n\nTente novamente"
			loadingLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
			wait(3)
			loadingGui:Destroy()
		end
	end)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- 🚀 INICIAR LAUNCHER
-- ══════════════════════════════════════════════════════════════════════════════

local launcherGui = CreateLauncherUI()

print("✅ Script Launcher Ativado!")
print("📜 Selecione um script para carregar")
