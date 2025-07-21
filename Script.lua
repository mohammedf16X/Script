-- Advanced GUI System with Fixed Sliders and Two-Panel Design (Nat Hub Style)
-- Created for enhanced user experience with proper slider functionality

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuration
local CONFIG = {
    TOGGLE_KEY = Enum.KeyCode.RightControl,
    ANIMATION_SPEED = 0.3,
    TRANSPARENCY_LEVEL = 0.15,
    BLUR_SIZE = 24,
    GLOW_SIZE = 20
}

-- Variables
local isGuiVisible = false
local currentSpeed = 16
local currentJumpPower = 50
local noclipEnabled = false
local connections = {}
local currentPanel = "Character"

-- Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NatHubStyleGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Create blur effect
local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 0
blurEffect.Parent = game.Lighting

-- Create main frame with two-panel design
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = CONFIG.TRANSPARENCY_LEVEL
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Add corner radius
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Add gradient background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 65)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Create header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
header.BackgroundTransparency = 0.3
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Header title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🚀 Nat Hub Style GUI"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = header

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -45, 0, 7.5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
closeButton.BackgroundTransparency = 0.2
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Left Panel (Commands/Buttons)
local leftPanel = Instance.new("Frame")
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0, 180, 1, -60)
leftPanel.Position = UDim2.new(0, 10, 0, 60)
leftPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
leftPanel.BackgroundTransparency = 0.4
leftPanel.BorderSizePixel = 0
leftPanel.Parent = mainFrame

local leftCorner = Instance.new("UICorner")
leftCorner.CornerRadius = UDim.new(0, 8)
leftCorner.Parent = leftPanel

-- Right Panel (Content/Settings)
local rightPanel = Instance.new("Frame")
rightPanel.Name = "RightPanel"
rightPanel.Size = UDim2.new(0, 390, 1, -60)
rightPanel.Position = UDim2.new(0, 200, 0, 60)
rightPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
rightPanel.BackgroundTransparency = 0.4
rightPanel.BorderSizePixel = 0
rightPanel.Parent = mainFrame

local rightCorner = Instance.new("UICorner")
rightCorner.CornerRadius = UDim.new(0, 8)
rightCorner.Parent = rightPanel

-- Left Panel Layout
local leftLayout = Instance.new("UIListLayout")
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
leftLayout.Padding = UDim.new(0, 5)
leftLayout.Parent = leftPanel

-- Right Panel Content Frame with Scrolling
local rightScrollFrame = Instance.new("ScrollingFrame")
rightScrollFrame.Name = "RightScrollFrame"
rightScrollFrame.Size = UDim2.new(1, -10, 1, -10)
rightScrollFrame.Position = UDim2.new(0, 5, 0, 5)
rightScrollFrame.BackgroundTransparency = 1
rightScrollFrame.BorderSizePixel = 0
rightScrollFrame.ScrollBarThickness = 6
rightScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
rightScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
rightScrollFrame.Parent = rightPanel

local rightLayout = Instance.new("UIListLayout")
rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
rightLayout.Padding = UDim.new(0, 10)
rightLayout.Parent = rightScrollFrame

-- Update canvas size automatically
rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    rightScrollFrame.CanvasSize = UDim2.new(0, 0, 0, rightLayout.AbsoluteContentSize.Y + 20)
end)

-- Animation functions
local function createTweenInfo(duration, style, direction)
    return TweenInfo.new(
        duration or CONFIG.ANIMATION_SPEED,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )
end

local function animateIn(object, properties)
    local tween = TweenService:Create(object, createTweenInfo(), properties)
    tween:Play()
    return tween
end

-- Button hover effects
local function addHoverEffect(button, hoverColor, normalColor)
    local normalBg = normalColor or button.BackgroundColor3
    local hoverBg = hoverColor or Color3.fromRGB(
        math.min(255, normalBg.R * 255 + 30),
        math.min(255, normalBg.G * 255 + 30),
        math.min(255, normalBg.B * 255 + 30)
    )
    
    button.MouseEnter:Connect(function()
        animateIn(button, {BackgroundColor3 = hoverBg})
    end)
    
    button.MouseLeave:Connect(function()
        animateIn(button, {BackgroundColor3 = normalBg})
    end)
end

-- Create navigation button function
local function createNavButton(name, icon, layoutOrder, callback)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(1, -10, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    button.BackgroundTransparency = 0.3
    button.BorderSizePixel = 0
    button.Text = icon .. " " .. name
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.LayoutOrder = layoutOrder
    button.Parent = leftPanel
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        currentPanel = name
        if callback then callback() end
        updateRightPanel()
        
        -- Update button colors
        for _, child in pairs(leftPanel:GetChildren()) do
            if child:IsA("TextButton") then
                if child.Name == name .. "Button" then
                    child.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
                    child.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    child.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
                    child.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
        end
    end)
    
    addHoverEffect(button)
    return button
end

-- Fixed slider creation function
local function createSlider(parent, name, minValue, maxValue, defaultValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name .. "Slider"
    sliderFrame.Size = UDim2.new(1, 0, 0, 60)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    sliderFrame.BackgroundTransparency = 0.3
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 8)
    sliderCorner.Parent = sliderFrame
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, -20, 0, 25)
    sliderLabel.Position = UDim2.new(0, 10, 0, 5)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = name .. ": " .. defaultValue
    sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderLabel.TextScaled = true
    sliderLabel.Font = Enum.Font.GothamBold
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Parent = sliderFrame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 8)
    sliderBg.Position = UDim2.new(0, 10, 0, 35)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = sliderFrame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 4)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 4)
    sliderFillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -10, 0.5, -10)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderBg
    
    local sliderButtonCorner = Instance.new("UICorner")
    sliderButtonCorner.CornerRadius = UDim.new(0, 10)
    sliderButtonCorner.Parent = sliderButton
    
    local dragging = false
    local currentValue = defaultValue
    
    -- Fixed dragging functionality
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = Players.LocalPlayer:GetMouse()
            local relativeX = math.clamp(mouse.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            local percentage = relativeX / sliderBg.AbsoluteSize.X
            local value = math.floor(minValue + (maxValue - minValue) * percentage)
            
            currentValue = value
            sliderLabel.Text = name .. ": " .. value
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            sliderButton.Position = UDim2.new(percentage, -10, 0.5, -10)
            
            if callback then
                callback(value)
            end
        end
    end)
    
    -- Click on track to jump
    sliderBg.MouseButton1Down:Connect(function()
        if not dragging then
            local mouse = Players.LocalPlayer:GetMouse()
            local relativeX = math.clamp(mouse.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            local percentage = relativeX / sliderBg.AbsoluteSize.X
            local value = math.floor(minValue + (maxValue - minValue) * percentage)
            
            currentValue = value
            sliderLabel.Text = name .. ": " .. value
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            sliderButton.Position = UDim2.new(percentage, -10, 0.5, -10)
            
            if callback then
                callback(value)
            end
        end
    end)
    
    return sliderFrame, function() return currentValue end
end

-- Toggle button function
local function createToggleButton(parent, name, defaultState, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name .. "Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, 50)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    toggleFrame.BackgroundTransparency = 0.3
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 15, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = name
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextScaled = true
    toggleLabel.Font = Enum.Font.GothamBold
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 60, 0, 30)
    toggleButton.Position = UDim2.new(1, -75, 0.5, -15)
    toggleButton.BackgroundColor3 = defaultState and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(60, 60, 80)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    
    local toggleButtonCorner = Instance.new("UICorner")
    toggleButtonCorner.CornerRadius = UDim.new(0, 15)
    toggleButtonCorner.Parent = toggleButton
    
    local toggleIndicator = Instance.new("Frame")
    toggleIndicator.Size = UDim2.new(0, 24, 0, 24)
    toggleIndicator.Position = defaultState and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12)
    toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleIndicator.BorderSizePixel = 0
    toggleIndicator.Parent = toggleButton
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 12)
    indicatorCorner.Parent = toggleIndicator
    
    local checkIcon = Instance.new("TextLabel")
    checkIcon.Size = UDim2.new(1, 0, 1, 0)
    checkIcon.BackgroundTransparency = 1
    checkIcon.Text = defaultState and "✓" or ""
    checkIcon.TextColor3 = Color3.fromRGB(100, 150, 255)
    checkIcon.TextScaled = true
    checkIcon.Font = Enum.Font.GothamBold
    checkIcon.Parent = toggleIndicator
    
    local isToggled = defaultState
    
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        local newBgColor = isToggled and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(60, 60, 80)
        local newPosition = isToggled and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12)
        
        animateIn(toggleButton, {BackgroundColor3 = newBgColor})
        animateIn(toggleIndicator, {Position = newPosition})
        
        checkIcon.Text = isToggled and "✓" or ""
        
        if callback then
            callback(isToggled)
        end
    end)
    
    addHoverEffect(toggleButton)
    
    return toggleFrame, function() return isToggled end
end

-- Panel content storage
local panelContents = {}

-- Character Panel Content
panelContents.Character = function()
    local content = Instance.new("Frame")
    content.Name = "CharacterContent"
    content.Size = UDim2.new(1, 0, 0, 200)
    content.BackgroundTransparency = 1
    content.Parent = rightScrollFrame
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = content
    
    -- Speed control
    local speedSlider = createSlider(content, "Speed", 1, 100, currentSpeed, function(value)
        currentSpeed = value
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = value
            
            -- Add speed effect
            local speedEffect = Instance.new("Sparkles")
            speedEffect.SparkleColor = Color3.fromRGB(100, 150, 255)
            speedEffect.Parent = character:FindFirstChild("HumanoidRootPart")
            
            game:GetService("Debris"):AddItem(speedEffect, 2)
        end
    end)
    
    -- Jump power control
    local jumpSlider = createSlider(content, "Jump Power", 10, 200, currentJumpPower, function(value)
        currentJumpPower = value
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = value
            
            -- Add jump effect
            local jumpEffect = Instance.new("Fire")
            jumpEffect.Color = Color3.fromRGB(255, 150, 100)
            jumpEffect.Size = 5
            jumpEffect.Heat = 10
            jumpEffect.Parent = character:FindFirstChild("HumanoidRootPart")
            
            game:GetService("Debris"):AddItem(jumpEffect, 1.5)
        end
    end)
    
    return content
end

-- Music Panel Content
panelContents.Music = function()
    local content = Instance.new("Frame")
    content.Name = "MusicContent"
    content.Size = UDim2.new(1, 0, 0, 200)
    content.BackgroundTransparency = 1
    content.Parent = rightScrollFrame
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = content
    
    -- Noclip toggle
    local noclipToggle = createToggleButton(content, "Noclip", noclipEnabled, function(state)
        noclipEnabled = state
        local character = player.Character
        
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = not state
                end
            end
        end
    end)
    
    -- Volume control
    local volumeSlider = createSlider(content, "Volume", 0, 100, 50, function(value)
        SoundService.Volume = value / 100
    end)
    
    return content
end

-- Settings Panel Content
panelContents.Settings = function()
    local content = Instance.new("Frame")
    content.Name = "SettingsContent"
    content.Size = UDim2.new(1, 0, 0, 150)
    content.BackgroundTransparency = 1
    content.Parent = rightScrollFrame
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = content
    
    -- Transparency control
    local transparencySlider = createSlider(content, "Transparency", 0, 90, CONFIG.TRANSPARENCY_LEVEL * 100, function(value)
        CONFIG.TRANSPARENCY_LEVEL = value / 100
        mainFrame.BackgroundTransparency = CONFIG.TRANSPARENCY_LEVEL
        header.BackgroundTransparency = CONFIG.TRANSPARENCY_LEVEL + 0.1
    end)
    
    -- Animation speed control
    local animSpeedSlider = createSlider(content, "Animation Speed", 10, 100, CONFIG.ANIMATION_SPEED * 100, function(value)
        CONFIG.ANIMATION_SPEED = value / 100
    end)
    
    return content
end

-- Information Panel Content
panelContents.Information = function()
    local content = Instance.new("Frame")
    content.Name = "InformationContent"
    content.Size = UDim2.new(1, 0, 0, 200)
    content.BackgroundTransparency = 1
    content.Parent = rightScrollFrame
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = content
    
    -- Info display frame
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, 0, 0, 150)
    infoFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    infoFrame.BackgroundTransparency = 0.3
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = content
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = infoFrame
    
    local infoLayout = Instance.new("UIListLayout")
    infoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    infoLayout.Padding = UDim.new(0, 5)
    infoLayout.Parent = infoFrame
    
    -- Player info
    local playerInfoLabel = Instance.new("TextLabel")
    playerInfoLabel.Size = UDim2.new(1, -20, 0, 30)
    playerInfoLabel.Position = UDim2.new(0, 10, 0, 0)
    playerInfoLabel.BackgroundTransparency = 1
    playerInfoLabel.Text = "Player: " .. player.Name
    playerInfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    playerInfoLabel.TextScaled = true
    playerInfoLabel.Font = Enum.Font.GothamBold
    playerInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
    playerInfoLabel.LayoutOrder = 1
    playerInfoLabel.Parent = infoFrame
    
    -- FPS counter
    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Size = UDim2.new(1, -20, 0, 30)
    fpsLabel.Position = UDim2.new(0, 10, 0, 0)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text = "FPS: Calculating..."
    fpsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    fpsLabel.TextScaled = true
    fpsLabel.Font = Enum.Font.Gotham
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    fpsLabel.LayoutOrder = 2
    fpsLabel.Parent = infoFrame
    
    -- Position display
    local positionLabel = Instance.new("TextLabel")
    positionLabel.Size = UDim2.new(1, -20, 0, 30)
    positionLabel.Position = UDim2.new(0, 10, 0, 0)
    positionLabel.BackgroundTransparency = 1
    positionLabel.Text = "Position: 0, 0, 0"
    positionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    positionLabel.TextScaled = true
    positionLabel.Font = Enum.Font.Gotham
    positionLabel.TextXAlignment = Enum.TextXAlignment.Left
    positionLabel.LayoutOrder = 3
    positionLabel.Parent = infoFrame
    
    -- FPS calculation
    local frameCount = 0
    local lastTime = tick()
    
    connections.fpsCounter = RunService.Heartbeat:Connect(function()
        frameCount = frameCount + 1
        local currentTime = tick()
        
        if currentTime - lastTime >= 1 then
            local fps = math.floor(frameCount / (currentTime - lastTime))
            fpsLabel.Text = "FPS: " .. fps
            
            -- Color code FPS
            if fps >= 50 then
                fpsLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            elseif fps >= 30 then
                fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
            else
                fpsLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
            
            frameCount = 0
            lastTime = currentTime
        end
    end)
    
    -- Position tracking
    connections.positionTracker = RunService.Heartbeat:Connect(function()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local pos = character.HumanoidRootPart.Position
            positionLabel.Text = string.format("Position: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        end
    end)
    
    return content
end

-- Update right panel function
function updateRightPanel()
    -- Clear existing content
    for _, child in pairs(rightScrollFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name:find("Content") then
            child:Destroy()
        end
    end
    
    -- Add new content based on current panel
    if panelContents[currentPanel] then
        panelContents[currentPanel]()
    end
end

-- Create navigation buttons
createNavButton("Character", "🏃", 1)
createNavButton("Music", "🎵", 2)
createNavButton("Settings", "⚙️", 3)
createNavButton("Information", "📊", 4)

-- Toggle GUI function
local function toggleGui()
    isGuiVisible = not isGuiVisible
    
    if isGuiVisible then
        mainFrame.Visible = true
        animateIn(mainFrame, {
            Size = UDim2.new(0, 600, 0, 400),
            BackgroundTransparency = CONFIG.TRANSPARENCY_LEVEL
        })
        animateIn(blurEffect, {Size = CONFIG.BLUR_SIZE})
        
        -- Initialize with Character panel
        currentPanel = "Character"
        updateRightPanel()
        
        -- Set Character button as active
        for _, child in pairs(leftPanel:GetChildren()) do
            if child:IsA("TextButton") then
                if child.Name == "CharacterButton" then
                    child.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
                    child.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    child.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
                    child.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
        end
    else
        animateIn(mainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        })
        animateIn(blurEffect, {Size = 0})
        
        wait(CONFIG.ANIMATION_SPEED)
        mainFrame.Visible = false
    end
end

-- Input handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == CONFIG.TOGGLE_KEY then
        toggleGui()
    end
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    toggleGui()
end)

addHoverEffect(closeButton, Color3.fromRGB(255, 120, 120))

-- Floating toggle indicator
local toggleIndicator = Instance.new("Frame")
toggleIndicator.Name = "ToggleIndicator"
toggleIndicator.Size = UDim2.new(0, 60, 0, 60)
toggleIndicator.Position = UDim2.new(0, 20, 0, 20)
toggleIndicator.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
toggleIndicator.BackgroundTransparency = 0.1
toggleIndicator.BorderSizePixel = 0
toggleIndicator.Visible = true
toggleIndicator.Parent = screenGui

local indicatorCorner = Instance.new("UICorner")
indicatorCorner.CornerRadius = UDim.new(0, 30)
indicatorCorner.Parent = toggleIndicator

local indicatorIcon = Instance.new("TextLabel")
indicatorIcon.Size = UDim2.new(1, 0, 1, 0)
indicatorIcon.BackgroundTransparency = 1
indicatorIcon.Text = "🚀"
indicatorIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
indicatorIcon.TextScaled = true
indicatorIcon.Font = Enum.Font.GothamBold
indicatorIcon.Parent = toggleIndicator

local indicatorButton = Instance.new("TextButton")
indicatorButton.Size = UDim2.new(1, 0, 1, 0)
indicatorButton.BackgroundTransparency = 1
indicatorButton.Text = ""
indicatorButton.Parent = toggleIndicator

indicatorButton.MouseButton1Click:Connect(function()
    toggleGui()
end)

-- Update toggle function to hide/show indicator
local originalToggleGui = toggleGui
toggleGui = function()
    isGuiVisible = not isGuiVisible
    
    if isGuiVisible then
        toggleIndicator.Visible = false
        originalToggleGui()
    else
        originalToggleGui()
        toggleIndicator.Visible = true
    end
end

print("🚀 Nat Hub Style GUI loaded successfully!")
print("📋 Features:")
print("   • Fixed slider functionality with proper dragging")
print("   • Two-panel design (Commands left, Content right)")
print("   • Proper scrolling for all content including Information panel")
print("   • Character controls (Speed & Jump)")
print("   • Music controls with Noclip")
print("   • Settings panel")
print("   • Information panel with real-time data")
print("⌨️  Press Right Control to toggle interface")
print("🎯 Click the floating icon to open GUI")


-- Visual Effects Panel Content
panelContents.Effects = function()
    local content = Instance.new("Frame")
    content.Name = "EffectsContent"
    content.Size = UDim2.new(1, 0, 0, 150)
    content.BackgroundTransparency = 1
    content.Parent = rightScrollFrame
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = content
    
    -- Rainbow mode toggle
    local rainbowToggle = createToggleButton(content, "Rainbow Mode", false, function(state)
        if state then
            connections.rainbowLoop = RunService.Heartbeat:Connect(function()
                local time = tick()
                local hue = (time * 50) % 360
                local color = Color3.fromHSV(hue / 360, 1, 1)
                
                if mainFrame.Visible then
                    titleLabel.TextColor3 = color
                end
            end)
        else
            if connections.rainbowLoop then
                connections.rainbowLoop:Disconnect()
                connections.rainbowLoop = nil
            end
            titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
    
    -- Particle effects toggle
    local particleToggle = createToggleButton(content, "Particle Effects", false, function(state)
        local character = player.Character
        if not character then return end
        
        if state then
            local sparkles = Instance.new("Sparkles")
            sparkles.SparkleColor = Color3.fromRGB(100, 150, 255)
            sparkles.Parent = character:FindFirstChild("HumanoidRootPart")
            connections.sparkles = sparkles
        else
            if connections.sparkles then
                connections.sparkles:Destroy()
                connections.sparkles = nil
            end
        end
    end)
    
    return content
end

-- Quick Actions Panel Content
panelContents.Actions = function()
    local content = Instance.new("Frame")
    content.Name = "ActionsContent"
    content.Size = UDim2.new(1, 0, 0, 200)
    content.BackgroundTransparency = 1
    content.Parent = rightScrollFrame
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = content
    
    -- Action buttons frame
    local actionsFrame = Instance.new("Frame")
    actionsFrame.Size = UDim2.new(1, 0, 0, 120)
    actionsFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    actionsFrame.BackgroundTransparency = 0.3
    actionsFrame.BorderSizePixel = 0
    actionsFrame.Parent = content
    
    local actionsCorner = Instance.new("UICorner")
    actionsCorner.CornerRadius = UDim.new(0, 8)
    actionsCorner.Parent = actionsFrame
    
    local actionsLayout = Instance.new("UIListLayout")
    actionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    actionsLayout.Padding = UDim.new(0, 10)
    actionsLayout.Parent = actionsFrame
    
    -- Teleport to spawn button
    local spawnButton = Instance.new("TextButton")
    spawnButton.Size = UDim2.new(1, -20, 0, 40)
    spawnButton.Position = UDim2.new(0, 10, 0, 10)
    spawnButton.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
    spawnButton.BackgroundTransparency = 0.2
    spawnButton.BorderSizePixel = 0
    spawnButton.Text = "🏠 Teleport to Spawn"
    spawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    spawnButton.TextScaled = true
    spawnButton.Font = Enum.Font.GothamBold
    spawnButton.LayoutOrder = 1
    spawnButton.Parent = actionsFrame
    
    local spawnCorner = Instance.new("UICorner")
    spawnCorner.CornerRadius = UDim.new(0, 6)
    spawnCorner.Parent = spawnButton
    
    -- Fly toggle button
    local flyButton = Instance.new("TextButton")
    flyButton.Size = UDim2.new(1, -20, 0, 40)
    flyButton.Position = UDim2.new(0, 10, 0, 60)
    flyButton.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
    flyButton.BackgroundTransparency = 0.2
    flyButton.BorderSizePixel = 0
    flyButton.Text = "🚁 Toggle Fly"
    flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyButton.TextScaled = true
    flyButton.Font = Enum.Font.GothamBold
    flyButton.LayoutOrder = 2
    flyButton.Parent = actionsFrame
    
    local flyCorner = Instance.new("UICorner")
    flyCorner.CornerRadius = UDim.new(0, 6)
    flyCorner.Parent = flyButton
    
    -- Spawn teleport functionality
    spawnButton.MouseButton1Click:Connect(function()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local spawnLocation = workspace.SpawnLocation or workspace:FindFirstChild("Spawn")
            if spawnLocation then
                character.HumanoidRootPart.CFrame = spawnLocation.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end)
    
    -- Fly functionality
    local flying = false
    
    flyButton.MouseButton1Click:Connect(function()
        flying = not flying
        local character = player.Character
        
        if flying and character and character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = character.HumanoidRootPart
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = humanoidRootPart
            
            connections.bodyVelocity = bodyVelocity
            flyButton.Text = "🛑 Stop Flying"
            flyButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        else
            if connections.bodyVelocity then
                connections.bodyVelocity:Destroy()
                connections.bodyVelocity = nil
            end
            flyButton.Text = "🚁 Toggle Fly"
            flyButton.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
        end
    end)
    
    addHoverEffect(spawnButton, Color3.fromRGB(120, 255, 170))
    addHoverEffect(flyButton, Color3.fromRGB(170, 120, 255))
    
    return content
end

-- Add new navigation buttons
createNavButton("Effects", "✨", 5)
createNavButton("Actions", "⚡", 6)

-- Notification system
local function showNotification(message, duration)
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 60)
    notification.Position = UDim2.new(1, -320, 0, 20)
    notification.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    notification.BackgroundTransparency = 0.1
    notification.BorderSizePixel = 0
    notification.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notification
    
    local notifIcon = Instance.new("TextLabel")
    notifIcon.Size = UDim2.new(0, 40, 1, 0)
    notifIcon.Position = UDim2.new(0, 10, 0, 0)
    notifIcon.BackgroundTransparency = 1
    notifIcon.Text = "ℹ️"
    notifIcon.TextColor3 = Color3.fromRGB(100, 150, 255)
    notifIcon.TextScaled = true
    notifIcon.Font = Enum.Font.GothamBold
    notifIcon.Parent = notification
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -60, 1, 0)
    notifText.Position = UDim2.new(0, 50, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = message
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextScaled = true
    notifText.Font = Enum.Font.Gotham
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    notifText.Parent = notification
    
    -- Slide in animation
    notification.Position = UDim2.new(1, 0, 0, 20)
    animateIn(notification, {Position = UDim2.new(1, -320, 0, 20)})
    
    -- Auto hide after duration
    game:GetService("Debris"):AddItem(notification, duration or 3)
    
    spawn(function()
        wait(duration or 3 - 0.5)
        animateIn(notification, {Position = UDim2.new(1, 0, 0, 20)})
    end)
end

-- Show welcome notification
spawn(function()
    wait(1)
    showNotification("Nat Hub Style GUI loaded! Press Right Control to toggle", 4)
end)

-- Cleanup function
local function cleanup()
    for name, connection in pairs(connections) do
        if connection and typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        elseif connection and typeof(connection) == "Instance" then
            connection:Destroy()
        end
    end
    connections = {}
end

-- Cleanup on player leaving
player.CharacterRemoving:Connect(cleanup)

