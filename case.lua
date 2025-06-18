local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Utwórz GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AllGamepassesGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250)
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

-- WalkSpeed Slider Label
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

-- WalkSpeed Slider Track
local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, -20, 0, 20)
sliderTrack.Position = UDim2.new(0, 10, 0, 70)
sliderTrack.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
sliderTrack.Parent = frame
sliderTrack.BorderSizePixel = 0
sliderTrack.ClipsDescendants = true

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(16/460, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderFill.Parent = sliderTrack
sliderFill.BorderSizePixel = 0

-- WalkSpeed logic
local function setWalkSpeed(value)
    value = math.clamp(value, 0, 460)
    sliderFill.Size = UDim2.new(value / 460, 0, 1, 0)
    sliderLabel.Text = "WalkSpeed: "..math.floor(value)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end

local walkSpeedValue = 16
setWalkSpeed(walkSpeedValue)

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

-- JumpPower Label
local jumpLabel = Instance.new("TextLabel")
jumpLabel.Text = "JumpPower: 50"
jumpLabel.Size = UDim2.new(1, -20, 0, 25)
jumpLabel.Position = UDim2.new(0, 10, 0, 100)
jumpLabel.BackgroundTransparency = 1
jumpLabel.TextColor3 = Color3.new(1, 1, 1)
jumpLabel.Font = Enum.Font.SourceSans
jumpLabel.TextSize = 18
jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
jumpLabel.Parent = frame

-- JumpPower Slider Track
local jumpTrack = Instance.new("Frame")
jumpTrack.Size = UDim2.new(1, -20, 0, 20)
jumpTrack.Position = UDim2.new(0, 10, 0, 130)
jumpTrack.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
jumpTrack.BorderSizePixel = 0
jumpTrack.ClipsDescendants = true
jumpTrack.Parent = frame

local jumpFill = Instance.new("Frame")
jumpFill.Size = UDim2.new(50/300, 0, 1, 0)
jumpFill.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
jumpFill.BorderSizePixel = 0
jumpFill.Parent = jumpTrack

-- JumpPower logic
local function setJumpPower(value)
    value = math.clamp(value, 0, 300)
    jumpFill.Size = UDim2.new(value / 300, 0, 1, 0)
    jumpLabel.Text = "JumpPower: "..math.floor(value)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = value
    end
end

local jumpValue = 50
setJumpPower(jumpValue)

local draggingJump = false
jumpTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingJump = true
        local relativeX = math.clamp(input.Position.X - jumpTrack.AbsolutePosition.X, 0, jumpTrack.AbsoluteSize.X)
        local newValue = (relativeX / jumpTrack.AbsoluteSize.X) * 300
        setJumpPower(newValue)
    end
end)
jumpTrack.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingJump = false
    end
end)
jumpTrack.InputChanged:Connect(function(input)
    if draggingJump and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = math.clamp(input.Position.X - jumpTrack.AbsolutePosition.X, 0, jumpTrack.AbsoluteSize.X)
        local newValue = (relativeX / jumpTrack.AbsoluteSize.X) * 300
        setJumpPower(newValue)
    end
end)

-- Przycisk Unlock All Gamepasses (przykładowy)
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 30)
button.Position = UDim2.new(0, 10, 0, 160)
button.Text = "Unlock All Gamepasses"
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

-- Fast Case Open Button
local fastButton = Instance.new("TextButton")
fastButton.Size = UDim2.new(1, -20, 0, 30)
fastButton.Position = UDim2.new(0, 10, 0, 200)
fastButton.Text = "Fast Case Open"
fastButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
fastButton.TextColor3 = Color3.new(1, 1, 1)
fastButton.Font = Enum.Font.SourceSansBold
fastButton.TextSize = 18
fastButton.Parent = frame

local isFarming = false

fastButton.MouseButton1Click:Connect(function()
    isFarming = not isFarming
    fastButton.Text = isFarming and "Stop Case Open" or "Fast Case Open"

    if isFarming then
        task.spawn(function()
            while isFarming do
                for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local n = string.lower(remote.Name)
                        if n:find("open") or n:find("case") or n:find("crate") then
                            pcall(function()
                                remote:FireServer("BasicCase") -- lub bez argumentu, jeśli nie wymagany
                            end)
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)
