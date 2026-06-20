local Remote = game:GetService("ReplicatedStorage").Remotes.QuickChatEvent
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

pcall(function()
	local old = PlayerGui:FindFirstChild("QuickChatMobile")
	if old then
		old:Destroy()
	end
end)

local Gui = Instance.new("ScreenGui")
Gui.Name = "QuickChatMobile"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 120)
Frame.Position = UDim2.new(0.5, -150, 0.5, -60)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Parent = Gui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "Quick Chat"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, -10, 0, 40)
TextBox.Position = UDim2.new(0, 5, 0, 30)
TextBox.PlaceholderText = "Escribe tu mensaje..."
TextBox.Text = ""
TextBox.ClearTextOnFocus = false
TextBox.Parent = Frame

local SendButton = Instance.new("TextButton")
SendButton.Size = UDim2.new(1, -10, 0, 35)
SendButton.Position = UDim2.new(0, 5, 0, 80)
SendButton.Text = "Enviar"
SendButton.Parent = Frame

SendButton.MouseButton1Click:Connect(function()
	local mensaje = TextBox.Text
	if mensaje ~= "" then
		Remote:FireServer(mensaje)
		TextBox.Text = ""
	end
end)

TextBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local mensaje = TextBox.Text
		if mensaje ~= "" then
			Remote:FireServer(mensaje)
			TextBox.Text = ""
		end
	end
end)

-- Sistema de arrastre para móvil y PC
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	Frame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
	or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
	or input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		update(input)
	end
end)
