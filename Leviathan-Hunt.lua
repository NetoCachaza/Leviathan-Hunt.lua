-- Leviathan-Hunt.lua
-- Interfaz personalizada parecida a Rayfield según lo pedido.

-- Limpieza: eliminar GUI previa si existe
local existing = game:GetService("CoreGui"):FindFirstChild("LeviathanHuntGUI")
if existing then
    existing:Destroy()
end

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LeviathanHuntGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Contenedor principal
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 300, 0, 180)
Main.Position = UDim2.new(0.05, 0, 0.25, 0)
Main.AnchorPoint = Vector2.new(0,0)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0,10)
Corner.Parent = Main

-- Left vertical bar for buttons
local LeftBar = Instance.new("Frame")
LeftBar.Name = "LeftBar"
LeftBar.BackgroundTransparency = 1
LeftBar.Size = UDim2.new(0, 140, 1, 0)
LeftBar.Position = UDim2.new(0, 10, 0, 10)
LeftBar.Parent = Main

-- Helper to create big buttons
local function makeButton(parent, name, posY)
    local btn = Instance.new("TextButton")
    btn.Name = name:gsub("%s","")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Text = name
    btn.BorderSizePixel = 0
    btn.Parent = parent
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0,6)
    return btn
end

-- Botones: Leviathan, Configuration (oculto al inicio, mismo lugar), UI
local LeviathanBtn = makeButton(LeftBar, "Leviathan", 0)
local ConfigurationBtn = makeButton(LeftBar, "Configuration", 0) -- empieza en la misma posición
ConfigurationBtn.Visible = false
local UIBtn = makeButton(LeftBar, "UI", 46)

-- Panel derecho (donde aparecen las opciones al tocar Configuration)
local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(0, 130, 0, 160)
RightPanel.Position = UDim2.new(0, 150, 0, 10)
RightPanel.BackgroundColor3 = Color3.fromRGB(24,24,24)
RightPanel.BorderSizePixel = 0
RightPanel.Parent = Main
RightPanel.Visible = false
local rpCorner = Instance.new("UICorner", RightPanel); rpCorner.CornerRadius = UDim.new(0,8)

-- Panel UI (aparece a la derecha cuando presionas UI)
local UIPanel = Instance.new("Frame")
UIPanel.Name = "UIPanel"
UIPanel.Size = UDim2.new(0, 130, 0, 160)
UIPanel.Position = UDim2.new(0, 150, 0, 10)
UIPanel.BackgroundColor3 = Color3.fromRGB(24,24,24)
UIPanel.BorderSizePixel = 0
UIPanel.Parent = Main
UIPanel.Visible = false
local uiCorner = Instance.new("UICorner", UIPanel); uiCorner.CornerRadius = UDim.new(0,8)

-- Title labels
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 28)
title.Position = UDim2.new(0, 10, 0, -6)
title.BackgroundTransparency = 1
title.Text = "Leviathan Hunt"
title.TextColor3 = Color3.fromRGB(220,220,220)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = Main

-- Estado de apertura del submenu
local openedConfig = false

-- Animación: al tocar Leviathan, Configuration se desliza hacia abajo desde su posición
LeviathanBtn.MouseButton1Click:Connect(function()
    openedConfig = not openedConfig
    if openedConfig then
        -- poner visible y animar hacia abajo
        ConfigurationBtn.Visible = true
        ConfigurationBtn.Position = LeviathanBtn.Position -- comienza en la misma pos
        local targetPos = UDim2.new(ConfigurationBtn.Position.X.Scale, ConfigurationBtn.Position.X.Offset, 0, 46)
        local tween = TweenService:Create(ConfigurationBtn, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos})
        tween:Play()
    else
        -- animar hacia arriba y ocultar
        local tween = TweenService:Create(ConfigurationBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = LeviathanBtn.Position})
        tween:Play()
        tween.Completed:Wait()
        ConfigurationBtn.Visible = false
        RightPanel.Visible = false
        UIPanel.Visible = false
    end
end)

-- CLICK Configuration: mostrar panel derecho con toggles
ConfigurationBtn.MouseButton1Click:Connect(function()
    RightPanel.Visible = true
    UIPanel.Visible = false
end)

-- CLICK UI: mostrar panel de UI options a la derecha
UIBtn.MouseButton1Click:Connect(function()
    UIPanel.Visible = true
    RightPanel.Visible = false
end)

-- Función para crear toggles en RightPanel (se ponen verdes cuando activados)
local function createToggleButton(parent, text, posY, callback)
    local tbtn = Instance.new("TextButton")
    tbtn.Size = UDim2.new(1, -12, 0, 36)
    tbtn.Position = UDim2.new(0, 6, 0, posY)
    tbtn.BackgroundColor3 = Color3.fromRGB(0,0,0) -- negro por defecto
    tbtn.Text = text
    tbtn.Font = Enum.Font.GothamBold
    tbtn.TextSize = 14
    tbtn.TextColor3 = Color3.fromRGB(255,255,255)
    tbtn.BorderSizePixel = 0
    tbtn.Parent = parent
    local c = Instance.new("UICorner", tbtn); c.CornerRadius = UDim.new(0,6)
    local active = false
    tbtn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            tbtn.BackgroundColor3 = Color3.fromRGB(0,200,0) -- verde
        else
            tbtn.BackgroundColor3 = Color3.fromRGB(0,0,0) -- negro
        end
        if callback then
            callback(active, tbtn)
        end
    end)
    return tbtn
end

-- Find Leviathan toggle (solo para probar: si active -> manda "hola" en chat)
createToggleButton(RightPanel, "Find Leviathan", 10, function(active)
    if active then
        -- intentar usar el evento de chat; si no existe, hacer print
        local success, err = pcall(function()
            local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if chatEvent and chatEvent:FindFirstChild("SayMessageRequest") then
                chatEvent.SayMessageRequest:FireServer("hola", "All")
            else
                -- fallback: algunos juegos no exponen el evento en ReplicatedStorage
                print("[Leviathan-Hunt] No se encontró SayMessageRequest. Esto es solo una prueba: hola")
            end
        end)
        if not success then
            warn("[Leviathan-Hunt] Error al enviar mensaje de prueba:", err)
        end
    end
end)

-- UI Panel: botones de tamaño
local function createSizeBtn(parent, text, posY, newSize)
    local sbtn = Instance.new("TextButton")
    sbtn.Size = UDim2.new(1, -12, 0, 36)
    sbtn.Position = UDim2.new(0, 6, 0, posY)
    sbtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    sbtn.Text = text
    sbtn.Font = Enum.Font.GothamBold
    sbtn.TextSize = 14
    sbtn.TextColor3 = Color3.fromRGB(255,255,255)
    sbtn.BorderSizePixel = 0
    sbtn.Parent = parent
    local c = Instance.new("UICorner", sbtn); c.CornerRadius = UDim.new(0,6)
    sbtn.MouseButton1Click:Connect(function()
        -- animar al cambiar tamaño
        local tween = TweenService:Create(Main, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = newSize})
        tween:Play()
    end)
    return sbtn
end

createSizeBtn(UIPanel, "Pequeña", 10, UDim2.new(0, 220, 0, 140))
createSizeBtn(UIPanel, "Mediana", 56, UDim2.new(0, 300, 0, 180))
createSizeBtn(UIPanel, "Grande", 102, UDim2.new(0, 380, 0, 260))

-- Mejoras opcionales: arrastrar la UI (drag)
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(Main)

-- FIN del script
