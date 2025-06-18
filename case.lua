-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
screenGui.Name = "EnhancedCaseGUI"
screenGui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 500)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Rounded Corners
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Title Bar
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Case Opener + Gamepasses"
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 20
titleText.TextColor3 = Color3.fromRGB(255,255,255)

-- Close Button
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(200,200,200)
closeBtn.BackgroundTransparency = 1
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Helper to add section labels
local function addSection(name, posY)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -20, 0, 25)
    lbl.Position = UDim2.new(0, 10, 0, posY)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 16
    lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return posY + 30
end

-- WalkSpeed & JumpPower sliders --
local currentY = addSection("🏃 WalkSpeed / JumpPower", 60)

-- WalkSpeed
local sliderLabel = Instance.new("TextLabel", frame)
sliderLabel.Text = "WalkSpeed: 16"
sliderLabel.Size = UDim2.new(1, -20, 0, 20)
sliderLabel.Position = UDim2.new(0, 10, 0, currentY)
sliderLabel.BackgroundTransparency = 1
sliderLabel.TextColor3 = Color3.new(1,1,1)
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 16
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left

local sliderTrack = Instance.new("Frame", frame)
sliderTrack.Size = UDim2.new(1, -20, 0, 16)
sliderTrack.Position = UDim2.new(0, 10, 0, currentY + 20)
sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderTrack.BorderSizePixel = 0
local sliderFill = Instance.new("Frame", sliderTrack)
sliderFill.Size = UDim2.new(16/460,0,1,0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderFill.BorderSizePixel = 0

local function setWalkSpeed(val)
    local v = math.clamp(val, 0, 460)
    sliderFill.Size = UDim2.new(v/460,0,1,0)
    sliderLabel.Text = "WalkSpeed: "..math.floor(v)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = v
    end
end
setWalkSpeed(16)

local dragging = false
sliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        local relX = math.clamp(input.Position.X - sliderTrack.AbsolutePosition.X, 0, sliderTrack.AbsoluteSize.X)
        setWalkSpeed((relX / sliderTrack.AbsoluteSize.X) * 460)
    end
end)
sliderTrack.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
sliderTrack.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relX = math.clamp(input.Position.X - sliderTrack.AbsolutePosition.X, 0, sliderTrack.AbsoluteSize.X)
        setWalkSpeed((relX / sliderTrack.AbsoluteSize.X) * 460)
    end
end)

currentY = currentY + 50

-- JumpPower
local jpLabel = Instance.new("TextLabel", frame)
jpLabel.Text = "JumpPower: 50"
jpLabel.Size = UDim2.new(1, -20, 0, 20)
jpLabel.Position = UDim2.new(0, 10, 0, currentY)
jpLabel.BackgroundTransparency = 1
jpLabel.TextColor3 = Color3.new(1,1,1)
jpLabel.Font = Enum.Font.Gotham
jpLabel.TextSize = 16
jpLabel.TextXAlignment = Enum.TextXAlignment.Left

local jpTrack = Instance.new("Frame", frame)
jpTrack.Size = UDim2.new(1, -20, 0, 16)
jpTrack.Position = UDim2.new(0, 10, 0, currentY + 20)
jpTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jpTrack.BorderSizePixel = 0
local jpFill = Instance.new("Frame", jpTrack)
jpFill.Size = UDim2.new(50/300,0,1,0)
jpFill.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
jpFill.BorderSizePixel = 0

local function setJumpPower(val)
    local v = math.clamp(val, 0, 300)
    jpFill.Size = UDim2.new(v/300,0,1,0)
    jpLabel.Text = "JumpPower: "..math.floor(v)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = v
    end
end
setJumpPower(50)

local jpDragging = false
jpTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        jpDragging = true
        local relX = math.clamp(input.Position.X - jpTrack.AbsolutePosition.X, 0, jpTrack.AbsoluteSize.X)
        setJumpPower((relX / jpTrack.AbsoluteSize.X) * 300)
    end
end)
jpTrack.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        jpDragging = false
    end
end)
jpTrack.InputChanged:Connect(function(input)
    if jpDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relX = math.clamp(input.Position.X - jpTrack.AbsolutePosition.X, 0, jpTrack.AbsoluteSize.X)
        setJumpPower((relX / jpTrack.AbsoluteSize.X) * 300)
    end
end)

currentY = currentY + 60

-- Gamepasses Button
currentY = addSection("🎟️ Gamepasses", currentY)
local gpBtn = Instance.new("TextButton", frame)
gpBtn.Size = UDim2.new(1, -20, 0, 35)
gpBtn.Position = UDim2.new(0, 10, 0, currentY)
gpBtn.Text = "Unlock All Gamepasses"
gpBtn.Font = Enum.Font.GothamBold
gpBtn.TextSize = 18
gpBtn.TextColor3 = Color3.new(1,1,1)
gpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
gpBtn.AutoButtonColor = true

gpBtn.MouseButton1Click:Connect(function()
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and (
           v.Parent.Name:find("WeaponsRemotes") or
           v.Parent.Name:find("VipRemotes") or
           v.Parent.Name:find("Remotes")
        ) then
            pcall(function() v:FireServer() end)
        end
    end
end)

currentY = currentY + 60

-- Case Opening Section
currentY = addSection("📦 Auto Case Opening", currentY)

-- Dropdown selection
local cases = {}
local pickFrame = Instance.new("Frame", frame)
pickFrame.Size = UDim2.new(1, -20, 0, 30)
pickFrame.Position = UDim2.new(0, 10, 0, currentY)
pickFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
local pCorner = Instance.new("UICorner", pickFrame)

local pickTxt = Instance.new("TextLabel", pickFrame)
pickTxt.Size = UDim2.new(1, -40, 1, 0)
pickTxt.Text = "Choose Case"
pickTxt.TextColor3 = Color3.fromRGB(200,200,200)
pickTxt.Font = Enum.Font.Gotham
pickTxt.TextXAlignment = Enum.TextXAlignment.Left
pickTxt.Position = UDim2.new(0, 10, 0, 0)

local pickBtn = Instance.new("TextButton", pickFrame)
pickBtn.Size = UDim2.new(0, 30, 1, 0)
pickBtn.Position = UDim2.new(1, -35, 0, 0)
pickBtn.Text = "▼"
pickBtn.Font = Enum.Font.GothamBold
pickBtn.TextSize = 18
pickBtn.TextColor3 = Color3.new(1,1,1)
pickBtn.BackgroundTransparency = 1

currentY = currentY + 40

-- Dropdown list
local listFrame = Instance.new("Frame", frame)
listFrame.Size = UDim2.new(1, -20, 0, 150)
listFrame.Position = UDim2.new(0, 10, 0, currentY)
listFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
listFrame.Visible = false
local lCorner = Instance.new("UICorner", listFrame)

local function refreshCases()
    cases = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:find("Case") then
            table.insert(cases, obj)
        end
    end
end

local function updateList()
    for _, child in ipairs(listFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for i, c in ipairs(cases) do
        local btn = Instance.new("TextButton", listFrame)
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Position = UDim2.new(0, 5, 0, (i-1)*35+5)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 15
        btn.Text = c.Name
        btn.TextColor3 = Color3.new(1,1,1)
        btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        btn.AutoButtonColor = true
        btn.MouseButton1Click:Connect(function()
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

currentY = currentY + 160

-- Auto-open toggle button
local autoOpen = false
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -20, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, currentY)
toggleBtn.Text = "Start Auto-Open"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
toggleBtn.AutoButtonColor = true

toggleBtn.MouseButton1Click:Connect(function()
    autoOpen = not autoOpen
    toggleBtn.Text = autoOpen and "Stop Auto-Open" or "Start Auto-Open"
end)

-- Auto-open loop
spawn(function()
    while true do
        wait(1)
        if autoOpen and pickTxt.Text ~= "Choose Case" then
            for _, c in ipairs(workspace:GetDescendants()) do
                if c:IsA("Model") and c.Name == pickTxt.Text then
                    local evt = c:FindFirstChild("OpenCase")
                    if evt and evt:IsA("RemoteEvent") then
                        pcall(function() evt:FireServer() end)
                    end
                end
            end
        end
    end
end)
