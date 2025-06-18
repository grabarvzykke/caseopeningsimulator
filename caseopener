-- Utwórz ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleGamepassGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui") -- albo PlayerGui, ale CoreGui działa zawsze w executorach

-- Utwórz Frame (panel)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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

-- Slider label
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

-- Slider (używamy slidera z Roblox UI)
local slider = Instance.new("Slider")
slider.Size = UDim2.new(1, -20, 0, 20)
slider.Position = UDim2.new(0, 10, 0, 70)
slider.Min = 0
slider.Max = 460
slider.Value = 16
slider.Parent = frame

-- Przycisk WalkSpeed (zadziała automatycznie przy zmianie slidera)
slider.Changed:Connect(function()
    local speed = slider.Value
    sliderLabel.Text = "WalkSpeed: "..math.floor(speed)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speed
    end
end)

-- Przycisk Get All Gamepasses
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 30)
button.Position = UDim2.new(0, 10, 0, 100)
button.Text = "Get All Gamepasses"
button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Parent = frame

button.MouseButton1Click:Connect(function()
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and (
            v.Parent.Name == "WeaponsRemotes" or
            v.Parent.Name == "VipRemotes" or
            v.Parent.Name == "Remotes"
        ) then
            v:FireServer()
        end
    end
end)
