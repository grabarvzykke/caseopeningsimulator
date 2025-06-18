-- SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local uis = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- GUI SETUP
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "GalacticCaseUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 320, 0, 320)
frame.Position = UDim2.new(0, 20, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- STYLING
local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 16)

local uiGradient = Instance.new("UIGradient", frame)
uiGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 150))
}
uiGradient.Rotation = 45
uiGradient.Transparency = NumberSequence.new(0.1)

-- MINIMIZE BUTTON
local minimized = false
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0, 25, 0, 25)
toggleBtn.Position = UDim2.new(1, -30, 0, 5)
toggleBtn.Text = "-"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)

toggleBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, c in ipairs(frame:GetChildren()) do
        if c ~= toggleBtn and not c:IsA("UIGradient") and not c:IsA("UICorner") then
            c.Visible = not minimized
        end
    end
    toggleBtn.Text = minimized and "+" or "-"
end)

uis.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightBracket then
        frame.Visible = not frame.Visible
    end
end)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "🚀 Galactic Case Tool"
title.Font = Enum.Font.GothamBlack
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextSize = 20

-- SLIDERS
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
gpBtn.AutoButtonColor = true
gpBtn.MouseButton1Click:Connect(function()
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Parent.Name:find("Remotes") or v.Parent.Name:find("Pass")) then
            pcall(function() v:FireServer() end)
        end
    end
end)
y = y + 45

-- AUTOCLICKER BUTTON
local autoClick = false
local clickBtn = Instance.new("TextButton", frame)
clickBtn.Size = UDim2.new(1, -20, 0, 40)
clickBtn.Position = UDim2.new(0, 10, 0, y)
clickBtn.Text = "Start Autoclicker"
clickBtn.Font = Enum.Font.GothamBold
clickBtn.TextSize = 16
clickBtn.TextColor3 = Color3.new(1,1,1)
clickBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)

clickBtn.MouseButton1Click:Connect(function()
    autoClick = not autoClick
    clickBtn.Text = autoClick and "Stop Autoclicker" or "Start Autoclicker"
end)

-- AUTOCLICK LOOP
RunService.RenderStepped:Connect(function()
    if autoClick then
        -- Zmodyfikuj te wartości, żeby klik był idealnie w przycisk
        local x, y = 1550, 510 -- << Współrzędne zbliżone do Twojego screena
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
        wait(0.01) -- SUPER SZYBKI AUTOKLIK
    end
end)
