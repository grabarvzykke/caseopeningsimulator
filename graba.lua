--// GIGADOKURWIONY CASE OPENER UI //

-- SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local uis = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- VARIABLES
local clicking = false
local clickPos = Vector2.new(0, 0)
local totalOpened = 0
local legendaryCount = 0
local autoSellEnabled = false
local antiAFK = true
local lastOpenTime = 0
local autoTheme = "Dark"

-- GUI SETUP
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "DokurwionyCaseUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 320, 0, 600)
frame.Position = UDim2.new(0, 30, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 255))
}
gradient.Rotation = 45

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(0, 200, 255)
stroke.Transparency = 0.2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- MINIMIZE BUTTON
local minimized = false
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0, 25, 0, 25)
toggleBtn.Position = UDim2.new(1, -30, 0, 5)
toggleBtn.Text = "-"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.ZIndex = 5

local function toggleUI()
    minimized = not minimized
    for _, c in ipairs(frame:GetChildren()) do
        if c ~= toggleBtn and not c:IsA("UIGradient") and not c:IsA("UIStroke") then
            c.Visible = not minimized
        end
    end
    toggleBtn.Text = minimized and "+" or "-"
end
toggleBtn.MouseButton1Click:Connect(toggleUI)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Giga Dokurwiony Case Opener"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextSize = 18

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
    track.ClipsDescendants = true
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

-- ANTI-AFK
if antiAFK then
    player.Idled:Connect(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
end

-- TOGGLE GUI [RIGHT BRACKET]
uis.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightBracket then
        frame.Visible = not frame.Visible
    end
end)

-- START AUTCLICKER [LEFT BRACKET]
uis.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.LeftBracket then
        clicking = not clicking
    end
end)

-- AUTOCLICK LOOP
spawn(function()
    while true do
        if clicking then
            local btn = nil
            for _, v in ipairs(game:GetDescendants()) do
                if v:IsA("ImageButton") and v.Name == "OpenCase" and v.BackgroundColor3 == Color3.fromRGB(0, 255, 0) then
                    btn = v
                    break
                end
            end
            if btn and btn:IsDescendantOf(game) then
                local pos = btn.AbsolutePosition + btn.AbsoluteSize/2
                VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
                VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
                totalOpened += 1
            end
        end
        task.wait(0.3)
    end
end)"
}
