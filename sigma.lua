-- SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local uis = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- GUI SETUP
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "DokurwionyCaseUI"
screenGui.ResetOnSpawn = false

-- MAIN FRAME
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 320, 0, 700)
frame.Position = UDim2.new(0, 30, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

-- GRADIENT + NEON
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
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)
local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = Color3.fromRGB(0, 255, 255)
toggleStroke.Thickness = 2

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
title.Text = "Dokurwiony Case Opener"
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
    Instance.new("UICorner", track).CornerRadius = UDim.new(0,6)
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(defaultV/maxV, 0, 1, 0)
    fill.BackgroundColor3 = color
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0,6)

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

-- Autoclicker Delay slider (ms)
local autoclickDelay = 300
y = addSlider("AutoClick Delay (ms)", 1000, autoclickDelay, y, Color3.fromRGB(0,255,150), function(v)
    autoclickDelay = math.clamp(v, 50, 1000)
end)

-- GAMEPASS UNLOCKER
local gpBtn = Instance.new("TextButton", frame)
gpBtn.Size = UDim2.new(1, -20, 0, 35)
gpBtn.Position = UDim2.new(0, 10, 0, y)
gpBtn.Text = "Unlock All Gamepasses"
gpBtn.Font = Enum.Font.GothamBold
gpBtn.TextSize = 16
gpBtn.BackgroundColor3 = Color3.fromRGB(0,150,255)
gpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", gpBtn).CornerRadius = UDim.new(0, 8)
local gpStroke = Instance.new("UIStroke", gpBtn)
gpStroke.Color = Color3.fromRGB(0,255,255)
gpStroke.Thickness = 2
gpStroke.Transparency = 0.3
gpBtn.MouseButton1Click:Connect(function()
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Parent.Name:find("Remotes") or v.Parent.Name:find("Pass")) then
            pcall(function() v:FireServer() end)
        end
    end
end)
y = y + 45

-- AUTOCLICKER TOGGLE BUTTON
local autoClickBtn = Instance.new("TextButton", frame)
autoClickBtn.Size = UDim2.new(1, -20, 0, 35)
autoClickBtn.Position = UDim2.new(0, 10, 0, y)
autoClickBtn.Text = "Toggle Autoclicker ["]"]"
autoClickBtn.Font = Enum.Font.GothamBold
autoClickBtn.TextSize = 16
autoClickBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
autoClickBtn.TextColor3 = Color3.new(0,0,0)
Instance.new("UICorner", autoClickBtn).CornerRadius = UDim.new(0, 8)
local acStroke = Instance.new("UIStroke", autoClickBtn)
acStroke.Color = Color3.fromRGB(0,255,100)
acStroke.Thickness = 2
acStroke.Transparency = 0.2
autoClickBtn.MouseButton1Click:Connect(function()
    clicking = not clicking
end)
y = y + 45

-- CASES OPENED COUNTER
local openedLabel = Instance.new("TextLabel", frame)
openedLabel.Size = UDim2.new(1, -20, 0, 20)
openedLabel.Position = UDim2.new(0, 10, 0, y)
openedLabel.Text = "Cases Opened: 0"
openedLabel.Font = Enum.Font.Gotham
openedLabel.TextSize = 14
openedLabel.TextColor3 = Color3.new(1, 1, 1)
openedLabel.BackgroundTransparency = 1
y = y + 25

-- LOADSTRING EXECUTOR
local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(1, -20, 0, 60)
box.Position = UDim2.new(0, 10, 0, y)
box.PlaceholderText = "Wklej kod Lua..."
box.Text = ""
box.TextWrapped = true
box.ClearTextOnFocus = false
box.Font = Enum.Font.Code
box.TextSize = 14
box.TextColor3 = Color3.new(1,1,1)
box.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
y = y + 65

local executeBtn = Instance.new("TextButton", frame)
executeBtn.Size = UDim2.new(1, -20, 0, 35)
executeBtn.Position = UDim2.new(0, 10, 0, y)
executeBtn.Text = "Execute Code"
executeBtn.Font = Enum.Font.GothamBold
executeBtn.TextSize = 16
executeBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)
executeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", executeBtn).CornerRadius = UDim.new(0, 8)
local execStroke = Instance.new("UIStroke", executeBtn)
execStroke.Color = Color3.fromRGB(255,40,40)
execStroke.Thickness = 2
execStroke.Transparency = 0.3
executeBtn.MouseButton1Click:Connect(function()
    local code = box.Text
    local func, err = loadstring(code)
    if func then
        pcall(func)
    else
        warn("Błąd w kodzie:", err)
    end
end)
y = y + 45

-- AUTOCLICKER SETUP
local clicking = false
local totalOpened = 0
local antiAFK = true

-- AUTCLICK LOOP - Klikacz klika dokładnie w miejsce kursora myszy co autoclickDelay ms
spawn(function()
    while true do
        if clicking then
            local mousePos = uis:GetMouseLocation()
            VirtualInputManager:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, false, game, 0)
            totalOpened += 1
            openedLabel.Text = "Cases Opened: "..totalOpened
        end
        task.wait(autoclickDelay / 1000)
    end
end)

-- TOGGLE GUI [RIGHT BRACKET]
uis.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightBracket then
        frame.Visible = not frame.Visible
    end
end)

-- START AUTOCLICKER [LEFT BRACKET]
uis.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.LeftBracket then
        clicking = not clicking
    end
end)

-- ANTI-AFK
if antiAFK then
    player.Idled:Connect(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
end
