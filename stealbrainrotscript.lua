-- === SYSTEM KLUCZA Z PEŁNYM SKRYPTEM ===

-- 🔑 Lista poprawnych kluczy
local validKeys = {
    "KOD123",
    "SEKRET456",
    "VIP789"
}

-- 🧠 Weryfikacja
local function verifyKey(key)
    for _, valid in ipairs(validKeys) do
        if key == valid then
            return true
        end
    end
    return false
end

-- 🖼️ UI
local function createKeyUI()
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Input = Instance.new("TextBox")
    local Submit = Instance.new("TextButton")
    local Status = Instance.new("TextLabel")

    ScreenGui.Name = "KeySystemUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Frame.Name = "MainFrame"
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    Frame.Size = UDim2.new(0, 300, 0, 200)

    Title.Name = "Title"
    Title.Parent = Frame
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🔐 Wpisz Klucz"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 16

    Input.Name = "KeyInput"
    Input.Parent = Frame
    Input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Input.Position = UDim2.new(0.5, -125, 0.3, 0)
    Input.Size = UDim2.new(0, 250, 0, 30)
    Input.Font = Enum.Font.Gotham
    Input.PlaceholderText = "Wpisz swój klucz..."
    Input.Text = ""
    Input.TextColor3 = Color3.new(1, 1, 1)
    Input.TextSize = 14

    Submit.Name = "SubmitButton"
    Submit.Parent = Frame
    Submit.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    Submit.Position = UDim2.new(0.5, -60, 0.6, 0)
    Submit.Size = UDim2.new(0, 120, 0, 30)
    Submit.Font = Enum.Font.GothamSemibold
    Submit.Text = "Sprawdź Klucz"
    Submit.TextColor3 = Color3.new(1, 1, 1)
    Submit.TextSize = 14

    Status.Name = "StatusLabel"
    Status.Parent = Frame
    Status.BackgroundTransparency = 1
    Status.Position = UDim2.new(0, 0, 0.85, 0)
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.Font = Enum.Font.Gotham
    Status.Text = ""
    Status.TextColor3 = Color3.new(1, 1, 1)
    Status.TextSize = 12

    return {
        ScreenGui = ScreenGui,
        Input = Input,
        Submit = Submit,
        Status = Status
    }
end

-- ▶️ Główna część skryptu
local function runMainScript()
    -- Tu wklej swój loader lub pobierany skrypt
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/StealaBrainrot"))()
    end)

    if success and type(result) == "table" then
        for placeId, scriptUrl in pairs(result) do
            if placeId == game.PlaceId then
                loadstring(game:HttpGet(scriptUrl))()
                return
            end
        end
    else
        warn("Nie udało się załadować głównego skryptu.")
    end
end

-- 🔃 Start
local function initKeySystem()
    local ui = createKeyUI()

    ui.Submit.MouseButton1Click:Connect(function()
        local key = ui.Input.Text

        if key == "" then
            ui.Status.Text = "⚠️ Wpisz klucz!"
            ui.Status.TextColor3 = Color3.fromRGB(255, 0, 0)
            return
        end

        ui.Status.Text = "🔍 Sprawdzanie..."
        ui.Status.TextColor3 = Color3.fromRGB(255, 255, 0)

        task.wait(1)

        if verifyKey(key) then
            ui.Status.Text = "✅ Poprawny klucz!"
            ui.Status.TextColor3 = Color3.fromRGB(0, 255, 0)
            task.wait(1)
            ui.ScreenGui:Destroy()
            runMainScript()
        else
            ui.Status.Text = "❌ Niepoprawny klucz!"
            ui.Status.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    end)
end

-- 🔓 Odpal wszystko
initKeySystem()
