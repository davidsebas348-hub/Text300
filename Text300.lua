-- Esperar a que el juego cargue
if not game:IsLoaded() then game.Loaded:Wait() end

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local HumFolder = Workspace:WaitForChild("Hum")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Crear GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TPGui"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 350)
MainFrame.Position = UDim2.new(0.5, -110, 0.3, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Título superior
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundColor3 = Color3.fromRGB(20,20,20)
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextScaled = true
Title.Text = "TP HUB"
Title.Parent = MainFrame

-- Contenedor de pestañas
local TabsContainer = Instance.new("Frame")
TabsContainer.Size = UDim2.new(1,0,1,-60)
TabsContainer.Position = UDim2.new(0,0,0,30)
TabsContainer.BackgroundTransparency = 1
TabsContainer.Parent = MainFrame

-------------------------------------------------
-- PESTAÑA 1 (HUM ANOMALY)
-------------------------------------------------

local TPScroll = Instance.new("ScrollingFrame")
TPScroll.Size = UDim2.new(1,0,1,0)
TPScroll.BackgroundTransparency = 1
TPScroll.ScrollBarThickness = 6
TPScroll.CanvasSize = UDim2.new(0,0,0,0)
TPScroll.Parent = TabsContainer

local layout1 = Instance.new("UIListLayout")
layout1.Padding = UDim.new(0,5)
layout1.Parent = TPScroll

local function updateCanvas1()
    TPScroll.CanvasSize = UDim2.new(0,0,0,layout1.AbsoluteContentSize.Y + 5)
end
layout1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas1)

local function getRoot()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function createButton(model)
    if not model:FindFirstChild("Man1") then return end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95,0,0,40)
    btn.BackgroundColor3 = Color3.fromRGB(0,255,0) -- default verde
    btn.TextColor3 = Color3.fromRGB(1,1,1)
    btn.TextScaled = true
    btn.BorderSizePixel = 0
    btn.Text = model.Name
    btn.Parent = TPScroll

    -- Cambiar color según atributo Anomaly
    local anomaly = model:GetAttribute("Anomaly")
    if anomaly == true then
        btn.BackgroundColor3 = Color3.fromRGB(255,0,0) -- rojo vivo
    else
        btn.BackgroundColor3 = Color3.fromRGB(0,255,0) -- verde vivo
    end

    btn.MouseButton1Click:Connect(function()
        local root = getRoot()
        local manModel = model:FindFirstChild("Man1")
        if manModel then
            root.CFrame = manModel:GetPivot() + Vector3.new(0,3,0)
        end
    end)
end

local function refreshList()
    -- Limpiar botones viejos
    for _, child in ipairs(TPScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    -- Crear botones
    for _, model in ipairs(HumFolder:GetChildren()) do
        if model:IsA("Model") and model:FindFirstChild("Man1") then
            createButton(model)
        end
    end
end

refreshList()
HumFolder.ChildAdded:Connect(refreshList)
HumFolder.ChildRemoved:Connect(refreshList)

-------------------------------------------------
-- PESTAÑA 2 (PLAYERS)
-------------------------------------------------

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1,0,1,0)
PlayerScroll.Position = UDim2.new(0,0,0,0)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.ScrollBarThickness = 6
PlayerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerScroll.Visible = false
PlayerScroll.Parent = TabsContainer

local PlayerLayout = Instance.new("UIListLayout")
PlayerLayout.Padding = UDim.new(0,5)
PlayerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
PlayerLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerLayout.Parent = PlayerScroll

local function updatePlayerList()
    for _, child in ipairs(PlayerScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.95,0,0,35)
            btn.BackgroundColor3 = Color3.fromRGB(90,90,90)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.TextScaled = true
            btn.Text = plr.DisplayName -- ahora usa DisplayName
            btn.Parent = PlayerScroll

            btn.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame =
                        plr.Character.HumanoidRootPart.CFrame
                end
            end)
        end
    end
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

-------------------------------------------------
-- BARRA INFERIOR Y CAMBIO DE PESTAÑAS
-------------------------------------------------

local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1,0,0,30)
Footer.Position = UDim2.new(0,0,1,-30)
Footer.BackgroundColor3 = Color3.fromRGB(20,20,20)
Footer.Parent = MainFrame

local TabIndex = 1

local TabLabel = Instance.new("TextLabel")
TabLabel.Size = UDim2.new(0.6,0,1,0)
TabLabel.Position = UDim2.new(0.2,0,0,0)
TabLabel.BackgroundTransparency = 1
TabLabel.TextColor3 = Color3.fromRGB(255,255,255)
TabLabel.TextScaled = true
TabLabel.Text = "1/2"
TabLabel.Parent = Footer

local LeftBtn = Instance.new("TextButton")
LeftBtn.Size = UDim2.new(0.2,0,1,0)
LeftBtn.Position = UDim2.new(0,0,0,0)
LeftBtn.Text = "<"
LeftBtn.TextScaled = true
LeftBtn.Parent = Footer

local RightBtn = Instance.new("TextButton")
RightBtn.Size = UDim2.new(0.2,0,1,0)
RightBtn.Position = UDim2.new(0.8,0,0,0)
RightBtn.Text = ">"
RightBtn.TextScaled = true
RightBtn.Parent = Footer

local function switchTab()
    if TabIndex == 1 then
        TPScroll.Visible = true
        PlayerScroll.Visible = false
    else
        TPScroll.Visible = false
        PlayerScroll.Visible = true
    end
    TabLabel.Text = TabIndex.."/2"
end

LeftBtn.MouseButton1Click:Connect(function()
    TabIndex = 1
    switchTab()
end)

RightBtn.MouseButton1Click:Connect(function()
    TabIndex = 2
    switchTab()
end)

-------------------------------------------------
-- BOTÓN MINIMIZAR
-------------------------------------------------

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0,30,0,30)
MinimizeBtn.Position = UDim2.new(1,-30,0,0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
MinimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinimizeBtn.Text = "-"
MinimizeBtn.TextScaled = true
MinimizeBtn.Parent = MainFrame

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    if minimized then
        MainFrame.Size = UDim2.new(0,220,0,350)
        TabsContainer.Visible = true
        Footer.Visible = true
        minimized = false
        MinimizeBtn.Text = "-"
    else
        MainFrame.Size = UDim2.new(0,220,0,30)
        TabsContainer.Visible = false
        Footer.Visible = false
        minimized = true
        MinimizeBtn.Text = "+"
    end
end)

-------------------------------------------------
-- DRAG
-------------------------------------------------

local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
