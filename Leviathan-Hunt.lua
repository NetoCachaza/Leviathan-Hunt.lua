-- UI BASE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.Parent = ScreenGui

-- BOTON LEVIATHAN
local LeviathanBtn = Instance.new("TextButton")
LeviathanBtn.Size = UDim2.new(1, 0, 0, 40)
LeviathanBtn.Position = UDim2.new(0, 0, 0, 0)
LeviathanBtn.Text = "Leviathan"
LeviathanBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
LeviathanBtn.TextColor3 = Color3.new(1,1,1)
LeviathanBtn.Parent = MainFrame

-- BOTON CONFIGURATION (oculto al inicio)
local ConfigBtn = Instance.new("TextButton")
ConfigBtn.Size = UDim2.new(1, 0, 0, 40)
ConfigBtn.Position = UDim2.new(0, 0, 0, 0)
ConfigBtn.Text = "Configuration"
ConfigBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
ConfigBtn.TextColor3 = Color3.new(1,1,1)
ConfigBtn.Visible = false
ConfigBtn.Parent = MainFrame

-- BOTON UI
local UIBtn = Instance.new("TextButton")
UIBtn.Size = UDim2.new(1, 0, 0, 40)
UIBtn.Position = UDim2.new(0, 0, 0, 80)
UIBtn.Text = "UI"
UIBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
UIBtn.TextColor3 = Color3.new(1,1,1)
UIBtn.Parent = MainFrame

-- PANEL DERECHO
local SidePanel = Instance.new("Frame")
SidePanel.Size = UDim2.new(0, 150, 0, 120)
SidePanel.Position = UDim2.new(1, 5, 0, 0)
SidePanel.BackgroundColor3 = Color3.fromRGB(25,25,25)
SidePanel.Visible = false
SidePanel.Parent = MainFrame

-- TOGGLE FIND LEVIATHAN
local FindBtn = Instance.new("TextButton")
FindBtn.Size = UDim2.new(1, 0, 0, 40)
FindBtn.Text = "Find Leviathan"
FindBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
FindBtn.TextColor3 = Color3.new(1,1,1)
FindBtn.Parent = SidePanel

local active = false

FindBtn.MouseButton1Click:Connect(function()
    active = not active
    if active then
        FindBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("hola", "All")
    else
        FindBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    end
end)

-- PANEL UI SETTINGS
local UIPanel = Instance.new("Frame")
UIPanel.Size = UDim2.new(0, 150, 0, 120)
UIPanel.Position = UDim2.new(1, 5, 0, 0)
UIPanel.BackgroundColor3 = Color3.fromRGB(25,25,25)
UIPanel.Visible = false
UIPanel.Parent = MainFrame

local function createSizeButton(text, size)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,40)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = UIPanel

    btn.MouseButton1Click:Connect(function()
        MainFrame.Size = size
    end)
end

createSizeButton("Small", UDim2.new(0,150,0,120))
createSizeButton("Medium", UDim2.new(0,200,0,150))
createSizeButton("Large", UDim2.new(0,260,0,200))

-- ANIMACION LEVIATHAN -> CONFIG
local TweenService = game:GetService("TweenService")

local opened = false

LeviathanBtn.MouseButton1Click:Connect(function()
    opened = not opened

    if opened then
        ConfigBtn.Visible = true
        local tween = TweenService:Create(ConfigBtn, TweenInfo.new(0.3), {
            Position = UDim2.new(0,0,0,40)
        })
        tween:Play()
    else
        ConfigBtn.Visible = false
        SidePanel.Visible = false
        UIPanel.Visible = false
    end
end)

-- CLICK CONFIGURATION
ConfigBtn.MouseButton1Click:Connect(function()
    SidePanel.Visible = true
    UIPanel.Visible = false
end)

-- CLICK UI
UIBtn.MouseButton1Click:Connect(function()
    UIPanel.Visible = true
    SidePanel.Visible = false
end)
