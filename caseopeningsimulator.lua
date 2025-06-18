-- LocalScript
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Tworzenie RemoteEventów jeśli ich nie ma (do testów)
local remoteFolder = ReplicatedStorage:FindFirstChild("DevPanelRemotes") or Instance.new("Folder", ReplicatedStorage)
remoteFolder.Name = "DevPanelRemotes"

local changeColorEvent = remoteFolder:FindFirstChild("ChangePlayerColor") or Instance.new("RemoteEvent", remoteFolder)
changeColorEvent.Name = "ChangePlayerColor"

local doubleMoneyEvent = remoteFolder:FindFirstChild("DoubleMoney") or Instance.new("RemoteEvent", remoteFolder)
doubleMoneyEvent.Name = "DoubleMoney"

local simulateGamepassEvent = remoteFolder:FindFirstChild("SimulateGamepass") or Instance.new("RemoteEvent", remoteFolder)
simulateGamepassEvent.Name = "SimulateGamepass"

-- GUI
local screenGui = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "DevPanelGUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Visible = true

local uiList = Instance.new("UIListLayout", frame)
uiList.Padding = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Text = "🛠️ Dev Panel – Główne"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 30)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

-- Button: Zmień kolor graczy
local colorButton = Instance.new("TextButton", frame)
colorButton.Text = "🔵 Zmień kolor graczy"
colorButton.Size = UDim2.new(1, 0, 0, 40)
colorButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
colorButton.TextColor3 = Color3.new(1, 1, 1)
colorButton.MouseButton1Click:Connect(function()
	changeColorEvent:FireServer(Color3.fromRGB(0, 150, 255))
end)

-- Button: Podwój pieniądze
local doubleMoneyButton = Instance.new("TextButton", frame)
doubleMoneyButton.Text = "💰 Podwój swoje pieniądze"
doubleMoneyButton.Size = UDim2.new(1, 0, 0, 40)
doubleMoneyButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
doubleMoneyButton.TextColor3 = Color3.new(1, 1, 1)
doubleMoneyButton.MouseButton1Click:Connect(function()
	doubleMoneyEvent:FireServer()
end)

-- Button: Symuluj Gamepassy
local gamepassButton = Instance.new("TextButton", frame)
gamepassButton.Text = "🎫 Symuluj posiadanie gamepassów"
gamepassButton.Size = UDim2.new(1, 0, 0, 40)
gamepassButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
gamepassButton.TextColor3 = Color3.new(1, 1, 1)
gamepassButton.MouseButton1Click:Connect(function()
	simulateGamepassEvent:FireServer()
end)
