local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

local playerGui = player:WaitForChild("PlayerGui")

local guiParent
pcall(function()
    if gethui then
        guiParent = gethui()
    end
end)

if not guiParent then
    guiParent = CoreGui
end

if not guiParent then
    guiParent = playerGui
end

local checkedParents = {}
for _, parent in ipairs({guiParent, CoreGui, playerGui}) do
    if parent and not checkedParents[parent] then
        checkedParents[parent] = true

        local oldGui = parent:FindFirstChild("LeviathanHuntUI")
        if oldGui then
            oldGui:Destroy()
        end
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LeviathanHuntUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
    end
end)

local parented = pcall(function()
    screenGui.Parent = guiParent
end)

if not parented then
    screenGui.Parent = playerGui
end

local theme = {
    background = Color3.fromRGB(7, 11, 16),
    backgroundAlt = Color3.fromRGB(14, 20, 28),
    panel = Color3.fromRGB(18, 24, 33),
    panelAlt = Color3.fromRGB(11, 15, 21),
    stroke = Color3.fromRGB(42, 52, 67),
    text = Color3.fromRGB(245, 247, 250),
    muted = Color3.fromRGB(138, 148, 160),
    accent = Color3.fromRGB(0, 186, 173),
    accentDark = Color3.fromRGB(0, 120, 112),
    success = Color3.fromRGB(46, 190, 88),
    off = Color3.fromRGB(0, 0, 0),
}

local tweenFast = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local tweenMedium = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local tweenSlow = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local sizePresets = {
    Pequena = UDim2.fromOffset(440, 265),
    Mediana = UDim2.fromOffset(540, 315),
    Grande = UDim2.fromOffset(650, 385),
}

local function addCorner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = object
    return corner
end

local function addStroke(object, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.Parent = object
    return stroke
end

local function createLabel(parent, text, size, font, color, alignment)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or theme.text
    label.TextSize = size
    label.Font = font or Enum.Font.Gotham
    label.TextXAlignment = alignment or Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = parent
    return label
end

local function createButton(parent, text, height)
    local button = Instance.new("TextButton")
    button.AutoButtonColor = false
    button.BackgroundColor3 = theme.panel
    button.Size = UDim2.new(1, 0, 0, height or 42)
    button.Text = text
    button.TextColor3 = theme.text
    button.TextSize = 16
    button.Font = Enum.Font.GothamBold
    button.Parent = parent

    addCorner(button, 12)
    addStroke(button, theme.stroke, 1, 0.15)

    return button
end

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.fromScale(0.5, 0.5)
mainFrame.Size = sizePresets.Mediana
mainFrame.BackgroundColor3 = theme.background
mainFrame.Parent = screenGui

addCorner(mainFrame, 22)
addStroke(mainFrame, theme.stroke, 1.2, 0.05)

local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, theme.backgroundAlt),
    ColorSequenceKeypoint.new(1, theme.background),
})
mainGradient.Rotation = 135
mainGradient.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, -20, 0, 54)
topBar.Position = UDim2.fromOffset(10, 10)
topBar.BackgroundTransparency = 1
topBar.Parent = mainFrame

local title = createLabel(topBar, "Leviathan Hunt", 20, Enum.Font.GothamBold, theme.text, Enum.TextXAlignment.Left)
title.Size = UDim2.new(1, -90, 1, 0)

local subtitle = createLabel(topBar, "Caeligladius", 12, Enum.Font.Gotham, theme.muted, Enum.TextXAlignment.Right)
subtitle.Size = UDim2.new(0, 100, 1, 0)
subtitle.Position = UDim2.new(1, -100, 0, 0)

local content = Instance.new("Frame")
content.Name = "Content"
content.BackgroundTransparency = 1
content.Position = UDim2.fromOffset(12, 70)
content.Size = UDim2.new(1, -24, 1, -82)
content.Parent = mainFrame

local leftColumn = Instance.new("Frame")
leftColumn.Name = "LeftColumn"
leftColumn.BackgroundColor3 = theme.panelAlt
leftColumn.Size = UDim2.new(0, 180, 1, 0)
leftColumn.Parent = content

addCorner(leftColumn, 18)
addStroke(leftColumn, theme.stroke, 1, 0.2)

local leftGradient = Instance.new("UIGradient")
leftGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(13, 17, 23)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 24, 33)),
})
leftGradient.Rotation = 90
leftGradient.Parent = leftColumn

local leftPadding = Instance.new("UIPadding")
leftPadding.PaddingTop = UDim.new(0, 12)
leftPadding.PaddingLeft = UDim.new(0, 12)
leftPadding.PaddingRight = UDim.new(0, 12)
leftPadding.Parent = leftColumn

local leviathanButton = createButton(leftColumn, "Leviathan", 48)
leviathanButton.BackgroundColor3 = theme.accent
leviathanButton.TextColor3 = theme.text

local submenuHolder = Instance.new("Frame")
submenuHolder.Name = "SubmenuHolder"
submenuHolder.BackgroundTransparency = 1
submenuHolder.ClipsDescendants = true
submenuHolder.Position = UDim2.fromOffset(0, 58)
submenuHolder.Size = UDim2.new(1, 0, 0, 0)
submenuHolder.Parent = leftColumn

local submenuLayout = Instance.new("UIListLayout")
submenuLayout.FillDirection = Enum.FillDirection.Vertical
submenuLayout.Padding = UDim.new(0, 10)
submenuLayout.Parent = submenuHolder

local configurationButton = createButton(submenuHolder, "Configuration", 42)
configurationButton.BackgroundColor3 = theme.panel

local uiButton = createButton(submenuHolder, "UI", 42)
uiButton.BackgroundColor3 = theme.panel

local panelArea = Instance.new("Frame")
panelArea.Name = "PanelArea"
panelArea.BackgroundTransparency = 1
panelArea.Position = UDim2.new(0, 196, 0, 0)
panelArea.Size = UDim2.new(1, -196, 1, 0)
panelArea.Parent = content

local panelTitle = createLabel(panelArea, "Leviathan", 24, Enum.Font.GothamBold, theme.text, Enum.TextXAlignment.Left)
panelTitle.Size = UDim2.new(1, 0, 0, 30)

local panelSubtitle = createLabel(panelArea, "Toca Leviathan para abrir el menu.", 13, Enum.Font.Gotham, theme.muted, Enum.TextXAlignment.Left)
panelSubtitle.Size = UDim2.new(1, 0, 0, 20)
panelSubtitle.Position = UDim2.fromOffset(0, 32)

local cardArea = Instance.new("Frame")
cardArea.Name = "CardArea"
cardArea.BackgroundTransparency = 1
cardArea.Position = UDim2.fromOffset(0, 66)
cardArea.Size = UDim2.new(1, 0, 1, -66)
cardArea.Parent = panelArea

local configPanel = Instance.new("Frame")
configPanel.Name = "ConfigurationPanel"
configPanel.BackgroundColor3 = theme.panelAlt
configPanel.Size = UDim2.new(1, 0, 1, 0)
configPanel.Visible = false
configPanel.Parent = cardArea

addCorner(configPanel, 20)
addStroke(configPanel, theme.stroke, 1, 0.2)

local configPanelGradient = Instance.new("UIGradient")
configPanelGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(17, 23, 31)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 14, 20)),
})
configPanelGradient.Rotation = 135
configPanelGradient.Parent = configPanel

local configPadding = Instance.new("UIPadding")
configPadding.PaddingTop = UDim.new(0, 18)
configPadding.PaddingLeft = UDim.new(0, 18)
configPadding.PaddingRight = UDim.new(0, 18)
configPadding.Parent = configPanel

local configHeader = createLabel(configPanel, "Configuration", 18, Enum.Font.GothamBold, theme.text, Enum.TextXAlignment.Left)
configHeader.Size = UDim2.new(1, 0, 0, 24)

local configHint = createLabel(configPanel, "Activa o desactiva opciones desde los botones de la derecha.", 13, Enum.Font.Gotham, theme.muted, Enum.TextXAlignment.Left)
configHint.Size = UDim2.new(1, 0, 0, 18)
configHint.Position = UDim2.fromOffset(0, 28)

local toggleRow = Instance.new("Frame")
toggleRow.Name = "ToggleRow"
toggleRow.BackgroundTransparency = 1
toggleRow.Position = UDim2.fromOffset(0, 70)
toggleRow.Size = UDim2.new(1, 0, 0, 58)
toggleRow.Parent = configPanel

local toggleTitle = createLabel(toggleRow, "Find Leviathan", 16, Enum.Font.GothamBold, theme.text, Enum.TextXAlignment.Left)
toggleTitle.Size = UDim2.new(0.55, 0, 1, 0)

local findLeviathanButton = createButton(toggleRow, "Off", 44)
findLeviathanButton.AnchorPoint = Vector2.new(1, 0.5)
findLeviathanButton.Position = UDim2.new(1, 0, 0.5, 0)
findLeviathanButton.Size = UDim2.new(0, 130, 0, 44)
findLeviathanButton.BackgroundColor3 = theme.off

local uiPanel = Instance.new("Frame")
uiPanel.Name = "UIPanel"
uiPanel.BackgroundColor3 = theme.panelAlt
uiPanel.Size = UDim2.new(1, 0, 1, 0)
uiPanel.Visible = false
uiPanel.Parent = cardArea

addCorner(uiPanel, 20)
addStroke(uiPanel, theme.stroke, 1, 0.2)

local uiPanelGradient = Instance.new("UIGradient")
uiPanelGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(17, 23, 31)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 14, 20)),
})
uiPanelGradient.Rotation = 135
uiPanelGradient.Parent = uiPanel

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 18)
uiPadding.PaddingLeft = UDim.new(0, 18)
uiPadding.PaddingRight = UDim.new(0, 18)
uiPadding.Parent = uiPanel

local uiHeader = createLabel(uiPanel, "UI", 18, Enum.Font.GothamBold, theme.text, Enum.TextXAlignment.Left)
uiHeader.Size = UDim2.new(1, 0, 0, 24)

local uiHint = createLabel(uiPanel, "Cambia el tamano de la interfaz con los botones de la derecha.", 13, Enum.Font.Gotham, theme.muted, Enum.TextXAlignment.Left)
uiHint.Size = UDim2.new(1, 0, 0, 18)
uiHint.Position = UDim2.fromOffset(0, 28)

local sizeRow = Instance.new("Frame")
sizeRow.Name = "SizeRow"
sizeRow.BackgroundTransparency = 1
sizeRow.Position = UDim2.fromOffset(0, 70)
sizeRow.Size = UDim2.new(1, 0, 0, 48)
sizeRow.Parent = uiPanel

local sizeLayout = Instance.new("UIListLayout")
sizeLayout.FillDirection = Enum.FillDirection.Horizontal
sizeLayout.Padding = UDim.new(0, 10)
sizeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
sizeLayout.Parent = sizeRow

local toastHolder = Instance.new("Frame")
toastHolder.Name = "ToastHolder"
toastHolder.AnchorPoint = Vector2.new(1, 1)
toastHolder.BackgroundTransparency = 1
toastHolder.Position = UDim2.new(1, -20, 1, -20)
toastHolder.Size = UDim2.fromOffset(320, 180)
toastHolder.Parent = screenGui

local toastLayout = Instance.new("UIListLayout")
toastLayout.FillDirection = Enum.FillDirection.Vertical
toastLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
toastLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
toastLayout.Padding = UDim.new(0, 10)
toastLayout.Parent = toastHolder

local panels = {
    Configuration = configPanel,
    UI = uiPanel,
}

local menuButtons = {
    Configuration = configurationButton,
    UI = uiButton,
}

local sizeButtons = {}
local currentPanel = nil
local currentSize = "Mediana"
local menuExpanded = false
local findLeviathanEnabled = false

local function tween(object, info, properties)
    TweenService:Create(object, info, properties):Play()
end

local function showToast(message)
    local toast = Instance.new("Frame")
    toast.BackgroundColor3 = theme.panel
    toast.BackgroundTransparency = 0.04
    toast.Size = UDim2.fromOffset(0, 52)
    toast.AutomaticSize = Enum.AutomaticSize.X
    toast.Parent = toastHolder

    addCorner(toast, 14)
    addStroke(toast, theme.stroke, 1, 0.2)

    local toastPadding = Instance.new("UIPadding")
    toastPadding.PaddingLeft = UDim.new(0, 16)
    toastPadding.PaddingRight = UDim.new(0, 16)
    toastPadding.Parent = toast

    local toastLabel = createLabel(toast, message, 14, Enum.Font.GothamMedium, theme.text, Enum.TextXAlignment.Left)
    toastLabel.AutomaticSize = Enum.AutomaticSize.X
    toastLabel.Size = UDim2.new(0, 0, 1, 0)

    toast.Position = UDim2.new(1, 40, 0, 0)
    toast.BackgroundTransparency = 1
    toastLabel.TextTransparency = 1

    tween(toast, tweenFast, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.04})
    tween(toastLabel, tweenFast, {TextTransparency = 0})

    task.delay(2.2, function()
        tween(toast, tweenFast, {Position = UDim2.new(1, 40, 0, 0), BackgroundTransparency = 1})
        tween(toastLabel, tweenFast, {TextTransparency = 1})
        task.delay(0.25, function()
            toast:Destroy()
        end)
    end)
end

local function setMenuHighlight(button, selected)
    tween(button, tweenFast, {
        BackgroundColor3 = selected and theme.accentDark or theme.panel,
    })
end

local function setLeviathanState(expanded)
    tween(leviathanButton, tweenFast, {
        BackgroundColor3 = expanded and theme.accent or theme.panel,
    })
end

local function updateSizeSelection()
    for name, button in pairs(sizeButtons) do
        local selected = name == currentSize
        tween(button, tweenFast, {
            BackgroundColor3 = selected and theme.accentDark or theme.panel,
        })
    end
end

local function applySize(name)
    currentSize = name
    tween(mainFrame, tweenMedium, {Size = sizePresets[name]})
    updateSizeSelection()
end

local function setFindLeviathanState(enabled)
    findLeviathanEnabled = enabled
    findLeviathanButton.Text = enabled and "On" or "Off"
    tween(findLeviathanButton, tweenFast, {
        BackgroundColor3 = enabled and theme.success or theme.off,
    })
end

local function openPanel(name)
    currentPanel = name

    for panelName, panel in pairs(panels) do
        panel.Visible = panelName == name
    end

    for buttonName, button in pairs(menuButtons) do
        setMenuHighlight(button, buttonName == name)
    end

    if name == "Configuration" then
        panelTitle.Text = "Configuration"
        panelSubtitle.Text = "Opciones de prueba para Leviathan."
    elseif name == "UI" then
        panelTitle.Text = "UI"
        panelSubtitle.Text = "Controla el tamano de la interfaz."
    else
        panelTitle.Text = "Leviathan"
        panelSubtitle.Text = "Toca Leviathan para abrir el menu."
    end
end

local function setMenuExpanded(expanded)
    menuExpanded = expanded
    local targetHeight = expanded and 94 or 0

    setLeviathanState(expanded)
    tween(submenuHolder, tweenSlow, {Size = UDim2.new(1, 0, 0, targetHeight)})

    if expanded and not currentPanel then
        openPanel("Configuration")
    end
end

for _, name in ipairs({"Pequena", "Mediana", "Grande"}) do
    local button = createButton(sizeRow, name, 44)
    button.Size = UDim2.fromOffset(112, 44)
    sizeButtons[name] = button

    button.Activated:Connect(function()
        applySize(name)
    end)
end

leviathanButton.Activated:Connect(function()
    setMenuExpanded(not menuExpanded)
end)

configurationButton.Activated:Connect(function()
    if not menuExpanded then
        setMenuExpanded(true)
    end
    openPanel("Configuration")
end)

uiButton.Activated:Connect(function()
    if not menuExpanded then
        setMenuExpanded(true)
    end
    openPanel("UI")
end)

findLeviathanButton.Activated:Connect(function()
    setFindLeviathanState(not findLeviathanEnabled)

    if findLeviathanEnabled then
        showToast("Prueba: escribe hola en el chat.")
    end
end)

applySize(currentSize)
setFindLeviathanState(false)
setMenuExpanded(false)

local dragging = false
local dragInput
local dragStart
local startPosition

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)
