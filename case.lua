--[[
Case Opener + Gamepasses + Auto Sell / Reroll + GUI [vFinal]
Autor: ChatGPT x Twoje wymagania
]]--

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CaseOpenerGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

-- Draggable Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 180)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Text = "🎁 Case Opener + Gamepasses"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

-- WalkSpeed / JumpPower Labels
local wsLabel = Instance.new("TextLabel")
wsLabel.Text = "WalkSpeed: 16"
wsLabel.Position = UDim2.new(0, 10, 0, 40)
wsLabel.Size = UDim2.new(1, -20, 0, 20)
wsLabel.TextColor3 = Color3.new(1,1,1)
wsLabel.Font = Enum.Font.SourceSans
wsLabel.BackgroundTransparency = 1
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.Parent = frame

local jpLabel = Instance.new("TextLabel")
jpLabel.Text = "JumpPower: 50"
jpLabel.Position = UDim2.new(0, 10, 0, 70)
jpLabel.Size = UDim2.new(1, -20, 0, 20)
jpLabel.TextColor3 = Color3.new(1,1,1)
jpLabel.Font = Enum.Font.SourceSans
jpLabel.BackgroundTransparency = 1
jpLabel.TextXAlignment = Enum.TextXAlignment.Left
jpLabel.Parent = frame

-- Set WalkSpeed
local function setWalkSpeed(value)
    local char = player.Character
    wsLabel.Text = "WalkSpeed: "..value
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end

-- Set JumpPower
local function setJumpPower(value)
    local char = player.Character
    jpLabel.Text = "JumpPower: "..value
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = value
    end
end

setWalkSpeed(16)
setJumpPower(50)

-- Button: Unlock Gamepasses
local gamepassBtn = Instance.new("TextButton")
gamepassBtn.Size = UDim2.new(1, -20, 0, 30)
gamepassBtn.Position = UDim2.new(0, 10, 0, 100)
gamepassBtn.Text = "Unlock All Gamepasses"
gamepassBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
gamepassBtn.TextColor3 = Color3.new(1,1,1)
gamepassBtn.Font = Enum.Font.GothamBold
gamepassBtn.TextSize = 14
gamepassBtn.Parent = frame

gamepassBtn.MouseButton1Click:Connect(function()
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

-- Fast Open Hack (if QuickOpen exists)
local function tryFastOpen()
    for _, mod in pairs(getgc(true)) do
        if type(mod) == "table" and rawget(mod, "QuickOpen") then
            mod.QuickOpen = true
        end
    end
end
tryFastOpen()

-- Auto Click (by screen position)
local autoOpening = false
local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(1, -20, 0, 40)
autoBtn.Position = UDim2.new(0, 10, 0, 140)
autoBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
autoBtn.TextColor3 = Color3.new(1,1,1)
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextSize = 16
autoBtn.Text = "Start Auto-Open"
autoBtn.Parent = frame

-- Pozycja kliknięcia "Sprzedaj za $..." wg screena (mniej więcej środek przycisku, 1920x1080)
local sellButtonX = 890
local sellButtonY = 336

spawn(function()
    while true do
        if autoOpening then
            VirtualInputManager:SendMouseButtonEvent(sellButtonX, sellButtonY, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(sellButtonX, sellButtonY, 0, false, game, 0)
        end
        task.wait(0.2)
    end
end)

autoBtn.MouseButton1Click:Connect(function()
    autoOpening = not autoOpening
    autoBtn.Text = autoOpening and "Stop Auto-Open" or "Start Auto-Open"
    autoBtn.BackgroundColor3 = autoOpening and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(0, 200, 100)
end)

-- Minimize GUI with ]
local minimized = false
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightBracket then
        minimized = not minimized
        frame.Visible = not minimized
    end
end)
