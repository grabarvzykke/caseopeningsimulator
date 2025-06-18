local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/grabarvzykke/caseopeningsimulator/refs/heads/main/caseopeningsimulator.lua"))()

local Window = Rayfield:CreateWindow({
   Name = "All Gamepasses Script",
   LoadingTitle = "All Gamepasses Script",
   LoadingSubtitle = "by Sture_14",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = true,
      FileName = "AGS"
   }
})

local MainTab = Window:CreateTab("Main", 4483362458)
local Section = MainTab:CreateSection("Main Features")

MainTab:CreateButton({
   Name = "Universal Script",
   Callback = function()
        loadstring(game:HttpGet("https://[Log in to view URL]"))()
   end,
})

MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {0, 460},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1",
   Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

MainTab:CreateButton({
   Name = "Get All Gamepasses",
   Callback = function()
        for _,v in pairs(game:GetDescendants()) do
            if v.ClassName == "RemoteEvent" then
                if v.Parent.Name == "WeaponsRemotes" or v.Parent.Name == "VipRemotes" or v.Parent.Name == "Remotes" then
                    v:FireServer()
                end
            end
        end
   end,
})
