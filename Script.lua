--!noverify

--[[ 
    Script by Best Players 0.1v
    A powerful and elegant Roblox UI script with visual effects.
    Inspired by Nat Hub Script.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BestPlayersUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 800, 0, 500) -- Increased size for more content
MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- UI Corner for rounded edges
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- UI Gradient for subtle background effect
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new(Color3.fromRGB(40, 40, 40), Color3.fromRGB(20, 20, 20))
UIGradient.Rotation = 90
UIGradient.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "script by best players 0.1v"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 20
TitleLabel.TextScaled = false
TitleLabel.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Vertical Menu (Left Panel)
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MenuFrame"
MenuFrame.Size = UDim2.new(0, 180, 1, -40) -- Adjusted size to fit below title bar
MenuFrame.Position = UDim2.new(0, 0, 0, 40)
MenuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MenuFrame.BorderSizePixel = 0
MenuFrame.Parent = MainFrame

local MenuLayout = Instance.new("UIListLayout")
MenuLayout.Name = "MenuLayout"
MenuLayout.FillDirection = Enum.FillDirection.Vertical
MenuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
MenuLayout.Padding = UDim.new(0, 10)
MenuLayout.Parent = MenuFrame

-- Main Content Panel (Right Panel)
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -180, 1, -40) -- Adjusted size
ContentFrame.Position = UDim2.new(0, 180, 0, 40)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- Function to create a menu button
local function createMenuButton(text, parentFrame)
    local Button = Instance.new("TextButton")
    Button.Name = text .. "Button"
    Button.Size = UDim2.new(0.9, 0, 0, 40)
    Button.BackgroundTransparency = 1
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Font = Enum.Font.SourceSansSemibold
    Button.TextSize = 16
    Button.TextScaled = false
    Button.Parent = parentFrame

    -- Hover effect
    Button.MouseEnter:Connect(function()
        Button:TweenBackgroundColor3(Color3.fromRGB(60, 60, 60), "Out", "Quad", 0.2, true)
    end)
    Button.MouseLeave:Connect(function()
        Button:TweenBackgroundColor3(Color3.fromRGB(40, 40, 40), "Out", "Quad", 0.2, true)
    end)

    return Button
end

-- Function to create a toggle button
local function createToggleButton(name, parentFrame, defaultState, onToggleCallback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "ToggleFrame"
    ToggleFrame.Size = UDim2.new(0.9, 0, 0, 40)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parentFrame

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ":"
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0.2, 0, 0.8, 0)
    ToggleButton.Position = UDim2.new(0.75, 0, 0.1, 0)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.TextSize = 14
    ToggleButton.Parent = ToggleFrame

    local currentState = defaultState

    local function updateToggleVisual()
        if currentState then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Green for on
            ToggleButton.Text = "ON"
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Red for off
            ToggleButton.Text = "OFF"
        end
    end

    updateToggleVisual()

    ToggleButton.MouseButton1Click:Connect(function()
        currentState = not currentState
        updateToggleVisual()
        if onToggleCallback then
            onToggleCallback(currentState)
        end
    end)

    return ToggleFrame, ToggleButton, function() return currentState end
end

-- Character Menu Button
local CharacterButton = createMenuButton("Character", MenuFrame)

-- Character Sub-Menu (initially hidden)
local CharacterPanel = Instance.new("Frame")
CharacterPanel.Name = "CharacterPanel"
CharacterPanel.Size = UDim2.new(1, 0, 1, 0)
CharacterPanel.Position = UDim2.new(0, 0, 0, 0)
CharacterPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CharacterPanel.BorderSizePixel = 0
CharacterPanel.Visible = false -- Hidden by default
CharacterPanel.Parent = ContentFrame

local CharacterLayout = Instance.new("UIListLayout")
CharacterLayout.Name = "CharacterLayout"
CharacterLayout.FillDirection = Enum.FillDirection.Vertical
CharacterLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
CharacterLayout.Padding = UDim.new(0, 10)
CharacterLayout.Parent = CharacterPanel

-- Speed Section
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Name = "SpeedFrame"
SpeedFrame.Size = UDim2.new(0.9, 0, 0, 80)
SpeedFrame.BackgroundTransparency = 1
SpeedFrame.Parent = CharacterPanel

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(1, 0, 0.4, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "WalkSpeed:"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.TextSize = 16
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SpeedFrame

local SpeedTextBox = Instance.new("TextBox")
SpeedTextBox.Name = "SpeedTextBox"
SpeedTextBox.Size = UDim2.new(0.6, 0, 0.5, 0)
SpeedTextBox.Position = UDim2.new(0, 0, 0.5, 0)
SpeedTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTextBox.PlaceholderText = "Enter speed (e.g., 30)"
SpeedTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SpeedTextBox.Text = "16" -- Default speed
SpeedTextBox.Font = Enum.Font.SourceSans
SpeedTextBox.TextSize = 14
SpeedTextBox.Parent = SpeedFrame

local ActivateSpeedButton = Instance.new("TextButton")
ActivateSpeedButton.Name = "ActivateSpeedButton"
ActivateSpeedButton.Size = UDim2.new(0.3, 0, 0.5, 0)
ActivateSpeedButton.Position = UDim2.new(0.65, 0, 0.5, 0)
ActivateSpeedButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Green for activate
ActivateSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ActivateSpeedButton.Text = "Activate"
ActivateSpeedButton.Font = Enum.Font.SourceSansBold
ActivateSpeedButton.TextSize = 16
ActivateSpeedButton.Parent = SpeedFrame

ActivateSpeedButton.MouseButton1Click:Connect(function()
    local success, speed = pcall(tonumber, SpeedTextBox.Text)
    if success and speed then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
        print("WalkSpeed set to: " .. speed)
    else
        warn("Invalid speed value: " .. SpeedTextBox.Text)
    end
end)

-- No Clip Toggle
local noClipEnabled = false
local NoClipToggleFrame, NoClipToggleButton, getNoClipState = createToggleButton("No Clip", CharacterPanel, false, function(state)
    noClipEnabled = state
    if LocalPlayer.Character then
        for i, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = not state
            end
        end
    end
    print("No Clip " .. (state and "Enabled" or "Disabled"))
end)

-- Player Avatar
local PlayerAvatar = Instance.new("ImageLabel")
PlayerAvatar.Name = "PlayerAvatar"
PlayerAvatar.Size = UDim2.new(0, 100, 0, 100)
PlayerAvatar.Position = UDim2.new(0.5, -50, 1, -140) -- Position at the bottom of the menu frame
PlayerAvatar.BackgroundTransparency = 1
PlayerAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420" -- Roblox avatar thumbnail
PlayerAvatar.Parent = MenuFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(0, 50) -- Make it circular
AvatarCorner.Parent = PlayerAvatar

-- Teleport Section (New Feature)
local TeleportButton = createMenuButton("Teleport", MenuFrame)

local TeleportPanel = Instance.new("Frame")
TeleportPanel.Name = "TeleportPanel"
TeleportPanel.Size = UDim2.new(1, 0, 1, 0)
TeleportPanel.Position = UDim2.new(0, 0, 0, 0)
TeleportPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TeleportPanel.BorderSizePixel = 0
TeleportPanel.Visible = false -- Hidden by default
TeleportPanel.Parent = ContentFrame

local TeleportLayout = Instance.new("UIListLayout")
TeleportLayout.Name = "TeleportLayout"
TeleportLayout.FillDirection = Enum.FillDirection.Vertical
TeleportLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TeleportLayout.Padding = UDim.new(0, 10)
TeleportLayout.Parent = TeleportPanel

local TeleportLabel = Instance.new("TextLabel")
TeleportLabel.Name = "TeleportLabel"
TeleportLabel.Size = UDim2.new(0.9, 0, 0, 30)
TeleportLabel.BackgroundTransparency = 1
TeleportLabel.Text = "Teleport to:"
TeleportLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportLabel.Font = Enum.Font.SourceSans
TeleportLabel.TextSize = 16
TeleportLabel.TextXAlignment = Enum.TextXAlignment.Left
TeleportLabel.Parent = TeleportPanel

local TeleportTextBox = Instance.new("TextBox")
TeleportTextBox.Name = "TeleportTextBox"
TeleportTextBox.Size = UDim2.new(0.9, 0, 0, 40)
TeleportTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TeleportTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportTextBox.PlaceholderText = "Enter X, Y, Z coordinates (e.g., 0, 100, 0)"
TeleportTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
TeleportTextBox.Font = Enum.Font.SourceSans
TeleportTextBox.TextSize = 14
TeleportTextBox.Parent = TeleportPanel

local TeleportButtonExecute = Instance.new("TextButton")
TeleportButtonExecute.Name = "TeleportButtonExecute"
TeleportButtonExecute.Size = UDim2.new(0.9, 0, 0, 40)
TeleportButtonExecute.BackgroundColor3 = Color3.fromRGB(0, 100, 150) -- Blue for teleport
TeleportButtonExecute.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButtonExecute.Text = "Teleport"
TeleportButtonExecute.Font = Enum.Font.SourceSansBold
TeleportButtonExecute.TextSize = 16
TeleportButtonExecute.Parent = TeleportPanel

TeleportButtonExecute.MouseButton1Click:Connect(function()
    local coordsStr = TeleportTextBox.Text
    local coords = {}
    for s in string.gmatch(coordsStr, "[^,]+") do
        table.insert(coords, tonumber(s))
    end

    if #coords == 3 and LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(coords[1], coords[2], coords[3])
        print("Teleported to: " .. coordsStr)
    else
        warn("Invalid coordinates or character not found: " .. coordsStr)
    end
end)

-- Function to hide all content panels
local function hideAllPanels()
    for _, panel in pairs(ContentFrame:GetChildren()) do
        if panel:IsA("Frame") and panel.Name:match("Panel$") then
            panel.Visible = false
        end
    end
end

-- Menu button click logic
CharacterButton.MouseButton1Click:Connect(function()
    hideAllPanels()
    CharacterPanel.Visible = true
end)

TeleportButton.MouseButton1Click:Connect(function()
    hideAllPanels()
    TeleportPanel.Visible = true
end)

-- Initial visibility setup
CharacterPanel.Visible = true -- Show Character panel by default

-- Drag functionality for MainFrame
local dragging
local dragInput
local dragStart
local startPosition

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragInput = input
        dragStart = input.Position
        startPosition = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.Ended then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)

print("UI Script Loaded!")


