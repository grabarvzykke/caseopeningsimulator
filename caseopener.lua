local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Utwórz ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AllGamepassesGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

-- Utwórz Frame (panel)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Tytuł
local title = Instance.new("TextLabel")
title.Text = "All Gamepasses Script"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = frame

-- Label slidera
local sliderLabel = Instance.new("TextLabel")
sliderLabel.Text = "WalkSpeed: 16"
sliderLabel.Size = UDim2.new(1, -20, 0, 25)
sliderLabel.Position = UDim2.new(0, 10, 0, 40)
sliderLabel.BackgroundTransparency = 1
sliderLabel.TextColor3 = Color3.new(1, 1, 1)
sliderLabel.Font = Enum.Font.SourceSans
sliderLabel.TextSize = 18
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.Parent = frame

-- Ręczny slider (track)
local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, -20, 0, 20)
sliderTrack.Position = UDim2.new(0, 10, 0, 70)
sliderTrack.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
sliderTrack.Parent = frame
sliderTrack.BorderSizePixel = 0
sliderTrack.ClipsDescendants = true

-- Wskaźnik slidera (fill)
local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(16/460, 0, 1, 0) -- startowa wartość 16 na 460 max
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderFill.Parent = sliderTrack
sliderFill.BorderSizePixel = 0

-- Funkcja do ustawiania WalkSpeed i UI
local function setWalkSpeed(value)
    value = math.clamp(value, 0, 460)
    sliderFill.Size = UDim2.new(value / 460, 0, 1, 0)
    sliderLabel.Text = "WalkSpeed: "..math.floor(value)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end

-- Początkowa wartość
local walkSpeedValue = 16
setWalkSpeed(walkSpeedValue)

-- Obsługa kliknięcia i przeciągania slidera
local dragging = false

sliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        local relativeX = math.clamp(input.Position.X - sliderTrack.AbsolutePosition.X, 0, sliderTrack.AbsoluteSize.X)
        local newValue = (relativeX / sliderTrack.AbsoluteSize.X) * 460
        setWalkSpeed(newValue)
    end
end)

sliderTrack.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

sliderTrack.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = math.clamp(input.Position.X - sliderTrack.AbsolutePosition.X, 0, sliderTrack.AbsoluteSize.X)
        local newValue = (relativeX / sliderTrack.AbsoluteSize.X) * 460
        setWalkSpeed(newValue)
    end
end)

-- Przycisk Get All Gamepasses
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 35)
button.Position = UDim2.new(0, 10, 0, 100)
button.Text = "Get All Gamepasses"
button.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Parent = frame

button.MouseButton1Click:Connect(function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and (
            v.Parent.Name == "WeaponsRemotes" or
            v.Parent.Name == "VipRemotes" or
            v.Parent.Name == "Remotes"
        ) then
            v:FireServer()
        end
    end
end)
