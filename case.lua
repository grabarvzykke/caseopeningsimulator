-- SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local uis = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- GUI SETUP
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "EnhancedCaseUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 450)
frame.Position = UDim2.new(0, 20, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Gradient background
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 255))
}
gradient.Rotation = 45

-- Particle effect (confined to frame)
local particleEmitter = Instance.new("ParticleEmitter")
particleEmitter.Texture = "rbxassetid://243660364"
particleEmitter.Rate = 5
particleEmitter.Lifetime = NumberRange.new(2)
particleEmitter.Speed = NumberRange.new(0.2, 0.5)
particleEmitter.Size = NumberSequence.new(0.5)
particleEmitter.Rotation = NumberRange.new(0, 360)
particleEmitter.RotSpeed = NumberRange.new(-90, 90)
particleEmitter.LightEmission = 1
particleEmitter.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.5),
    NumberSequenceKeypoint.new(1, 1)
})
particleEmitter.Parent = frame

-- MINIMIZE/OPEN BUTTON
local minimized = false
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0, 25, 0, 25)
toggleBtn.Position = UDim2.new(1, -30, 0, 5)
toggleBtn.Text = "-"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local function toggleUI()
    minimized = not minimized
    for _, c in ipairs(frame:GetChildren()) do
        if c ~= toggleBtn and not c:IsA("UIGradient") and not c:IsA("ParticleEmitter") then
            c.Visible = not minimized
        end
    end
    toggleBtn.Text = minimized and "+" or "-"
end
toggleBtn.MouseButton1Click:Connect(toggleUI)
uis.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightBracket then
        frame.Visible = not frame.Visible
    end
end)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Case Opener + Gamepasses"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextSize = 18

-- WALK/JUMP SLIDERS
local function addSlider(name, maxV, defaultV, yPos, color, callback)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -20, 0, 20)
    lbl.Position = UDim2.new(0, 10, 0, yPos)
    lbl.Text = name..": "..defaultV
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1

    local track = Instance.new("Frame", frame)
    track.Size = UDim2.new(1, -20, 0, 12)
    track.Position = UDim2.new(0, 10, 0, yPos+20)
    track.BackgroundColor3 = Color3.fromRGB(60,60,60)
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(defaultV/maxV, 0, 1, 0)
    fill.BackgroundColor3 = color

    local dragging = false
    local function update(x)
        local rel = math.clamp(x - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
        local val = (rel / track.AbsoluteSize.X) * maxV
        fill.Size = UDim2.new(val/maxV, 0, 1, 0)
        lbl.Text = name..": "..math.floor(val)
        callback(math.floor(val))
    end

    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(i.Position.X)
        end
    end)
    track.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    track.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            update(i.Position.X)
        end
    end)

    return yPos + 40
end

local y = 40
y = addSlider("WalkSpeed", 460, 16, y, Color3.fromRGB(0,170,255), function(v)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = v
    end
end)
y = addSlider("JumpPower", 300, 50, y, Color3.fromRGB(255,170,0), function(v)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.UseJumpPower = true
        player.Character.Humanoid.JumpPower = v
    end
end)

-- UNLOCK GAMEPASSES BUTTON
local gpBtn = Instance.new("TextButton", frame)
gpBtn.Size = UDim2.new(1, -20, 0, 35)
gpBtn.Position = UDim2.new(0, 10, 0, y)
gpBtn.Text = "Unlock All Gamepasses"
gpBtn.Font = Enum.Font.GothamBold
gpBtn.TextSize = 16
gpBtn.BackgroundColor3 = Color3.fromRGB(0,150,255)
gpBtn.TextColor3 = Color3.new(1,1,1)
gpBtn.MouseButton1Click:Connect(function()
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Parent.Name:find("Remotes") or v.Parent.Name:find("Hydra Pass") or v.Parent.Name:find("Bloodhound Pass")) then
            pcall(function() v:FireServer() end)
        end
    end
end)
y = y + 45

-- AUTOCLICKER
local autoClicking = false
local clickPos = Vector2.new(0, 0)

local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(1, -20, 0, 40)
autoBtn.Position = UDim2.new(0, 10, 0, y)
autoBtn.Text = "Autoclicker ["]
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextSize = 16
autoBtn.TextColor3 = Color3.new(1,1,1)
autoBtn.BackgroundColor3 = Color3.fromRGB(0,200,100)
y = y + 50

uis.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.LeftBracket then
        autoClicking = not autoClicking
        if autoClicking then
            clickPos = uis:GetMouseLocation()
        end
    end
end)

spawn(function()
    while true do
        if autoClicking then
            local success, err = pcall(function()
                local virtualInput = game:GetService("VirtualInputManager")
                virtualInput:SendMouseButtonEvent(clickPos.X, clickPos.Y, 0, true, game, 0)
                virtualInput:SendMouseButtonEvent(clickPos.X, clickPos.Y, 0, false, game, 0)
            end)
        end
        task.wait(0.3)
    end
end)
