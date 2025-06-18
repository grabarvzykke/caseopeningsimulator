local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AllGamepassesGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Text = "All Gamepasses Script"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = frame

-- ============ WalkSpeed SLIDER ============
local sliderLabel = Instance.new("TextLabel")
sliderLabel.Text = "WalkSpeed: 16"
sliderLabel.Size = UDim2.new(1, -20, 0, 20)
sliderLabel.Position = UDim2.new(0, 10, 0, 40)
sliderLabel.BackgroundTransparency = 1
sliderLabel.TextColor3 = Color3.new(1, 1, 1)
sliderLabel.Font = Enum.Font.SourceSans
sliderLabel.TextSize = 16
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.Parent = frame

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, -20, 0, 16)
sliderTrack.Position = UDim2.new(0, 10, 0, 60)
sliderTrack.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
sliderTrack.BorderSizePixel = 0
sliderTrack.Parent = frame

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(16 / 460, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack

local function setWalkSpeed(value)
    value = math.clamp(value, 0, 460)
    sliderFill.Size = UDim2.new(value / 460, 0, 1, 0)
    sliderLabel.Text = "WalkSpeed: " .. math.floor(value)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end

setWalkSpeed(16)
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

-- ============ JumpPower SLIDER ============
local jpLabel = Instance.new("TextLabel")
jpLabel.Text = "JumpPower: 50"
jpLabel.Size = UDim2.new(1, -20, 0, 20)
jpLabel.Position = UDim2.new(0, 10, 0, 90)
jpLabel.BackgroundTransparency = 1
jpLabel.TextColor3 = Color3.new(1, 1, 1)
jpLabel.Font = Enum.Font.SourceSans
jpLabel.TextSize = 16
jpLabel.TextXAlignment = Enum.TextXAlignment.Left
jpLabel.Parent = frame

local jpTrack = Instance.new("Frame")
jpTrack.Size = UDim2.new(1, -20, 0, 16)
jpTrack.Position = UDim2.new(0, 10, 0, 110)
jpTrack.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
jpTrack.BorderSizePixel = 0
jpTrack.Parent = frame

local jpFill = Instance.new("Frame")
jpFill.Size = UDim2.new(50 / 300, 0, 1, 0)
jpFill.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
jpFill.BorderSizePixel = 0
jpFill.Parent = jpTrack

local function setJumpPower(value)
    value = math.clamp(value, 0, 300)
    jpFill.Size = UDim2.new(value / 300, 0, 1, 0)
    jpLabel.Text = "JumpPower: " .. math.floor(value)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = value
    end
end

setJumpPower(50)
local jpDragging = false

jpTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        jpDragging = true
        local relativeX = math.clamp(input.Position.X - jpTrack.AbsolutePosition.X, 0, jpTrack.AbsoluteSize.X)
        local newValue = (relativeX / jpTrack.AbsoluteSize.X) * 300
        setJumpPower(newValue)
    end
end)

jpTrack.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        jpDragging = false
    end
end)

jpTrack.InputChanged:Connect(function(input)
    if jpDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = math.clamp(input.Position.X - jpTrack.AbsolutePosition.X, 0, jpTrack.AbsoluteSize.X)
        local newValue = (relativeX / jpTrack.AbsoluteSize.X) * 300
        setJumpPower(newValue)
    end
end)

-- ============ Get All Gamepasses Button ============
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 35)
button.Position = UDim2.new(0, 10, 0, 140)
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
            pcall(function()
                v:FireServer()
            end)
        end
    end
end)

-- ============ FAST OPEN CASE (Simulation) ============
-- Ta część nie zawsze zadziała — zależy od gry.
-- Jeśli gra sprawdza Gamepassy po stronie klienta, możemy je "oszukać".
-- Przykład: ustaw flagę quickOpen w lokalnym module (jeśli istnieje)

local function tryFastOpen()
    for _, mod in pairs(getgc(true)) do
        if type(mod) == "table" and rawget(mod, "QuickOpen") then
            mod.QuickOpen = true
        end
    end
end

tryFastOpen()
