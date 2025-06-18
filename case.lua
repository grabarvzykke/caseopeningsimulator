-- SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local uis = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI SETUP
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "EnhancedCaseUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 450)
frame.Position = UDim2.new(0, 20, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

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
        if c ~= toggleBtn then
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

-- CASE SELECTION DROPDOWN
local cases = {}
local pickFrame = Instance.new("Frame", frame)
pickFrame.Size = UDim2.new(1, -20, 0, 30)
pickFrame.Position = UDim2.new(0, 10, 0, y)
pickFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner", pickFrame)
local pickTxt = Instance.new("TextLabel", pickFrame)
pickTxt.Size = UDim2.new(1, -40, 1, 0)
pickTxt.Position = UDim2.new(0, 10, 0, 0)
pickTxt.Text = "Choose Case"
pickTxt.Font = Enum.Font.Gotham
pickTxt.TextSize = 14
pickTxt.TextColor3 = Color3.fromRGB(200,200,200)
local pickBtn = Instance.new("TextButton", pickFrame)
pickBtn.Size = UDim2.new(0, 30, 1, 0)
pickBtn.Position = UDim2.new(1, -35, 0, 0)
pickBtn.Text = "▼"
pickBtn.Font = Enum.Font.GothamBold
pickBtn.TextSize = 18
pickBtn.BackgroundTransparency = 1
y = y + 40

local listFrame = Instance.new("Frame", frame)
listFrame.Size = UDim2.new(1, -20, 0, 120)
listFrame.Position = UDim2.new(0, 10, 0, y)
listFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
listFrame.Visible = false
Instance.new("UICorner", listFrame)

local function refreshCases()
    cases = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:find("Skrzynka") or obj.Name:find("Case") then
            table.insert(cases, obj)
        end
    end
end

local function updateList()
    for _, v in ipairs(listFrame:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    for i, c in ipairs(cases) do
        local b = Instance.new("TextButton", listFrame)
        b.Size = UDim2.new(1, -10, 0, 30)
        b.Position = UDim2.new(0, 5, 0, (i-1)*35+5)
        b.Text = c.Name
        b.Font = Enum.Font.Gotham
        b.TextSize = 14
        b.TextColor3 = Color3.new(1,1,1)
        b.BackgroundColor3 = Color3.fromRGB(45,45,45)
        b.AutoButtonColor = true
        b.MouseButton1Click:Connect(function()
            pickTxt.Text = c.Name
            listFrame.Visible = false
        end)
    end
end

pickBtn.MouseButton1Click:Connect(function()
    refreshCases()
    updateList()
    listFrame.Visible = not listFrame.Visible
end)
y = y + 130

-- AUTO-OPEN TOGGLE
local autoOpen = false
local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(1, -20, 0, 40)
autoBtn.Position = UDim2.new(0, 10, 0, y)
autoBtn.Text = "Start Auto-Open"
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextSize = 16
autoBtn.TextColor3 = Color3.new(1,1,1)
autoBtn.BackgroundColor3 = Color3.fromRGB(0,200,100)

autoBtn.MouseButton1Click:Connect(function()
    autoOpen = not autoOpen
    autoBtn.Text = autoOpen and "Stop Auto-Open" or "Start Auto-Open"
end)

-- AUTO OPEN LOOP
RunService.Heartbeat:Connect(function()
    if autoOpen and pickTxt.Text ~= "Choose Case" then
        for _, c in ipairs(workspace:GetDescendants()) do
            if c:IsA("Model") and c.Name == pickTxt.Text then
                local evt = c:FindFirstChild("OpenCase") or c:FindFirstChildWhichIsA("RemoteEvent")
                if evt and evt:IsA("RemoteEvent") then
                    pcall(function() evt:FireServer() end)
                end
            end
        end
    end
end)
