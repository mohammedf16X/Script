-- Advanced GUI System with Effects and Animations
-- Created for enhanced user experience with transparency and smooth animations

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

-- Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Create blur effect
local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 0
blurEffect.Parent = game.Lighting

-- Create main frame with transparency
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 350)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
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

-- Add glow effect
local glowFrame = Instance.new("Frame")
glowFrame.Name = "GlowFrame"
glowFrame.Size = UDim2.new(1, CONFIG.GLOW_SIZE, 1, CONFIG.GLOW_SIZE)
glowFrame.Position = UDim2.new(0, -CONFIG.GLOW_SIZE/2, 0, -CONFIG.GLOW_SIZE/2)
glowFrame.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
glowFrame.BackgroundTransparency = 0.8
glowFrame.BorderSizePixel = 0
glowFrame.ZIndex = mainFrame.ZIndex - 1
glowFrame.Parent = mainFrame

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 16)
glowCorner.Parent = glowFrame

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
titleLabel.Text = "🚀 Advanced Control Panel"
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

-- Content frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -70)
contentFrame.Position = UDim2.new(0, 10, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Create scrolling frame for content
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.Position = UDim2.new(0, 0, 0, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
scrollFrame.Parent = contentFrame

-- Add layout for content
local contentLayout = Instance.new("UIListLayout")
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Padding = UDim.new(0, 10)
contentLayout.Parent = scrollFrame

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

local function animateOut(object, properties)
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

-- Toggle GUI function
local function toggleGui()
    isGuiVisible = not isGuiVisible
    
    if isGuiVisible then
        mainFrame.Visible = true
        animateIn(mainFrame, {
            Size = UDim2.new(0, 450, 0, 350),
            BackgroundTransparency = CONFIG.TRANSPARENCY_LEVEL
        })
        animateIn(blurEffect, {Size = CONFIG.BLUR_SIZE})
        
        -- Animate glow effect
        local glowTween = TweenService:Create(
            glowFrame,
            TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {BackgroundTransparency = 0.6}
        )
        glowTween:Play()
        connections.glowTween = glowTween
    else
        animateOut(mainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        })
        animateOut(blurEffect, {Size = 0})
        
        if connections.glowTween then
            connections.glowTween:Cancel()
            connections.glowTween = nil
        end
        
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

-- Add hover effect to close button
addHoverEffect(closeButton, Color3.fromRGB(255, 120, 120))

-- Utility functions for creating UI elements
local function createSection(name, icon, layoutOrder)
    local section = Instance.new("Frame")
    section.Name = name .. "Section"
    section.Size = UDim2.new(1, 0, 0, 120)
    section.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    section.BackgroundTransparency = 0.4
    section.BorderSizePixel = 0
    section.LayoutOrder = layoutOrder or 1
    section.Parent = scrollFrame
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = section
    
    local sectionHeader = Instance.new("TextLabel")
    sectionHeader.Name = "Header"
    sectionHeader.Size = UDim2.new(1, 0, 0, 30)
    sectionHeader.Position = UDim2.new(0, 0, 0, 0)
    sectionHeader.BackgroundTransparency = 1
    sectionHeader.Text = (icon or "⚙️") .. " " .. name
    sectionHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionHeader.TextScaled = true
    sectionHeader.Font = Enum.Font.GothamBold
    sectionHeader.TextXAlignment = Enum.TextXAlignment.Left
    sectionHeader.Parent = section
    
    local sectionContent = Instance.new("Frame")
    sectionContent.Name = "Content"
    sectionContent.Size = UDim2.new(1, -20, 1, -40)
    sectionContent.Position = UDim2.new(0, 10, 0, 35)
    sectionContent.BackgroundTransparency = 1
    sectionContent.Parent = section
    
    return section, sectionContent
end

local function createSlider(parent, name, minValue, maxValue, defaultValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name .. "Slider"
    sliderFrame.Size = UDim2.new(1, 0, 0, 25)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(0.4, 0, 1, 0)
    sliderLabel.Position = UDim2.new(0, 0, 0, 0)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = name .. ": " .. defaultValue
    sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    sliderLabel.TextScaled = true
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Parent = sliderFrame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.55, 0, 0, 8)
    sliderBg.Position = UDim2.new(0.43, 0, 0.5, -4)
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
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -8, 0.5, -8)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderBg
    
    local sliderButtonCorner = Instance.new("UICorner")
    sliderButtonCorner.CornerRadius = UDim.new(0, 8)
    sliderButtonCorner.Parent = sliderButton
    
    local dragging = false
    
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
            local relativeX = mouse.X - sliderBg.AbsolutePosition.X
            local percentage = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)
            local value = math.floor(minValue + (maxValue - minValue) * percentage)
            
            sliderLabel.Text = name .. ": " .. value
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            sliderButton.Position = UDim2.new(percentage, -8, 0.5, -8)
            
            if callback then
                callback(value)
            end
        end
    end)
    
    return sliderFrame
end

local function createToggleButton(parent, name, defaultState, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name .. "Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 0, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = name
    toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    toggleLabel.TextScaled = true
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(1, -55, 0.5, -12.5)
    toggleButton.BackgroundColor3 = defaultState and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(60, 60, 80)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12.5)
    toggleCorner.Parent = toggleButton
    
    local toggleIndicator = Instance.new("Frame")
    toggleIndicator.Size = UDim2.new(0, 19, 0, 19)
    toggleIndicator.Position = defaultState and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)
    toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleIndicator.BorderSizePixel = 0
    toggleIndicator.Parent = toggleButton
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 9.5)
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
        local newPosition = isToggled and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)
        
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

print("Advanced GUI System loaded successfully!")
print("Press Right Control to toggle the interface")



-- Character Section
local characterSection, characterContent = createSection("Character", "🏃", 1)

-- Add layout for character content
local characterLayout = Instance.new("UIListLayout")
characterLayout.SortOrder = Enum.SortOrder.LayoutOrder
characterLayout.Padding = UDim.new(0, 5)
characterLayout.Parent = characterContent

-- Speed control
local speedSlider = createSlider(characterContent, "Speed", 1, 100, currentSpeed, function(value)
    currentSpeed = value
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = value
        
        -- Add speed effect
        local speedEffect = Instance.new("Sparkles")
        speedEffect.SparkleColor = Color3.fromRGB(100, 150, 255)
        speedEffect.Parent = character:FindFirstChild("HumanoidRootPart")
        
        game:GetService("Debris"):AddItem(speedEffect, 2)
        
        -- Speed sound effect
        local speedSound = Instance.new("Sound")
        speedSound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
        speedSound.Volume = 0.3
        speedSound.Pitch = 1 + (value / 100)
        speedSound.Parent = character:FindFirstChild("HumanoidRootPart")
        speedSound:Play()
        
        speedSound.Ended:Connect(function()
            speedSound:Destroy()
        end)
    end
end)

-- Jump power control
local jumpSlider = createSlider(characterContent, "Jump Power", 10, 200, currentJumpPower, function(value)
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
        
        -- Jump sound effect
        local jumpSound = Instance.new("Sound")
        jumpSound.SoundId = "rbxasset://sounds/impact_water.mp3"
        jumpSound.Volume = 0.4
        jumpSound.Pitch = 0.8 + (value / 400)
        jumpSound.Parent = character:FindFirstChild("HumanoidRootPart")
        jumpSound:Play()
        
        jumpSound.Ended:Connect(function()
            jumpSound:Destroy()
        end)
    end
end)

-- Character reset button
local resetButton = Instance.new("TextButton")
resetButton.Name = "ResetButton"
resetButton.Size = UDim2.new(1, 0, 0, 25)
resetButton.BackgroundColor3 = Color3.fromRGB(255, 150, 100)
resetButton.BackgroundTransparency = 0.2
resetButton.BorderSizePixel = 0
resetButton.Text = "🔄 Reset Character"
resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetButton.TextScaled = true
resetButton.Font = Enum.Font.GothamBold
resetButton.LayoutOrder = 3
resetButton.Parent = characterContent

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 6)
resetCorner.Parent = resetButton

resetButton.MouseButton1Click:Connect(function()
    currentSpeed = 16
    currentJumpPower = 50
    
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = currentSpeed
        character.Humanoid.JumpPower = currentJumpPower
        
        -- Reset effect
        local resetEffect = Instance.new("Explosion")
        resetEffect.Position = character:FindFirstChild("HumanoidRootPart").Position
        resetEffect.BlastRadius = 0
        resetEffect.BlastPressure = 0
        resetEffect.Visible = false
        resetEffect.Parent = workspace
        
        -- Reset sound
        local resetSound = Instance.new("Sound")
        resetSound.SoundId = "rbxasset://sounds/button.wav"
        resetSound.Volume = 0.5
        resetSound.Parent = character:FindFirstChild("HumanoidRootPart")
        resetSound:Play()
        
        resetSound.Ended:Connect(function()
            resetSound:Destroy()
        end)
    end
    
    -- Update UI (this would need to be implemented with the slider update functions)
    print("Character stats reset to default values")
end)

addHoverEffect(resetButton, Color3.fromRGB(255, 180, 130))



-- Music Section
local musicSection, musicContent = createSection("Music", "🎵", 2)

-- Add layout for music content
local musicLayout = Instance.new("UIListLayout")
musicLayout.SortOrder = Enum.SortOrder.LayoutOrder
musicLayout.Padding = UDim.new(0, 8)
musicLayout.Parent = musicContent

-- Noclip toggle with visual indicator
local noclipToggle, getNoclipState = createToggleButton(musicContent, "Noclip", noclipEnabled, function(state)
    noclipEnabled = state
    local character = player.Character
    
    if character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = not state
            end
        end
        
        -- Noclip effect
        if state then
            local noclipEffect = Instance.new("SelectionBox")
            noclipEffect.Color3 = Color3.fromRGB(100, 255, 100)
            noclipEffect.Transparency = 0.5
            noclipEffect.Adornee = character:FindFirstChild("HumanoidRootPart")
            noclipEffect.Parent = character:FindFirstChild("HumanoidRootPart")
            
            connections.noclipEffect = noclipEffect
            
            -- Noclip sound
            local noclipSound = Instance.new("Sound")
            noclipSound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
            noclipSound.Volume = 0.4
            noclipSound.Pitch = 1.5
            noclipSound.Parent = character:FindFirstChild("HumanoidRootPart")
            noclipSound:Play()
            
            noclipSound.Ended:Connect(function()
                noclipSound:Destroy()
            end)
        else
            if connections.noclipEffect then
                connections.noclipEffect:Destroy()
                connections.noclipEffect = nil
            end
            
            -- Disable sound
            local disableSound = Instance.new("Sound")
            disableSound.SoundId = "rbxasset://sounds/button.wav"
            disableSound.Volume = 0.3
            disableSound.Pitch = 0.8
            disableSound.Parent = character:FindFirstChild("HumanoidRootPart")
            disableSound:Play()
            
            disableSound.Ended:Connect(function()
                disableSound:Destroy()
            end)
        end
    end
end)

-- Music volume control
local volumeSlider = createSlider(musicContent, "Volume", 0, 100, 50, function(value)
    SoundService.Volume = value / 100
    
    -- Volume effect
    local volumeEffect = Instance.new("Sound")
    volumeEffect.SoundId = "rbxasset://sounds/electronicpingshort.wav"
    volumeEffect.Volume = value / 100
    volumeEffect.Pitch = 1 + (value / 200)
    volumeEffect.Parent = SoundService
    volumeEffect:Play()
    
    volumeEffect.Ended:Connect(function()
        volumeEffect:Destroy()
    end)
end)

-- Music player controls
local musicControlsFrame = Instance.new("Frame")
musicControlsFrame.Name = "MusicControls"
musicControlsFrame.Size = UDim2.new(1, 0, 0, 35)
musicControlsFrame.BackgroundTransparency = 1
musicControlsFrame.LayoutOrder = 3
musicControlsFrame.Parent = musicContent

local controlsLayout = Instance.new("UIListLayout")
controlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
controlsLayout.Padding = UDim.new(0, 5)
controlsLayout.FillDirection = Enum.FillDirection.Horizontal
controlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
controlsLayout.Parent = musicControlsFrame

-- Play button
local playButton = Instance.new("TextButton")
playButton.Name = "PlayButton"
playButton.Size = UDim2.new(0, 30, 0, 30)
playButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
playButton.BackgroundTransparency = 0.2
playButton.BorderSizePixel = 0
playButton.Text = "▶️"
playButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playButton.TextScaled = true
playButton.Font = Enum.Font.GothamBold
playButton.LayoutOrder = 1
playButton.Parent = musicControlsFrame

local playCorner = Instance.new("UICorner")
playCorner.CornerRadius = UDim.new(0, 6)
playCorner.Parent = playButton

-- Pause button
local pauseButton = Instance.new("TextButton")
pauseButton.Name = "PauseButton"
pauseButton.Size = UDim2.new(0, 30, 0, 30)
pauseButton.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
pauseButton.BackgroundTransparency = 0.2
pauseButton.BorderSizePixel = 0
pauseButton.Text = "⏸️"
pauseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
pauseButton.TextScaled = true
pauseButton.Font = Enum.Font.GothamBold
pauseButton.LayoutOrder = 2
pauseButton.Parent = musicControlsFrame

local pauseCorner = Instance.new("UICorner")
pauseCorner.CornerRadius = UDim.new(0, 6)
pauseCorner.Parent = pauseButton

-- Stop button
local stopButton = Instance.new("TextButton")
stopButton.Name = "StopButton"
stopButton.Size = UDim2.new(0, 30, 0, 30)
stopButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
stopButton.BackgroundTransparency = 0.2
stopButton.BorderSizePixel = 0
stopButton.Text = "⏹️"
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopButton.TextScaled = true
stopButton.Font = Enum.Font.GothamBold
stopButton.LayoutOrder = 3
stopButton.Parent = musicControlsFrame

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 6)
stopCorner.Parent = stopButton

-- Add hover effects to music controls
addHoverEffect(playButton, Color3.fromRGB(120, 255, 120))
addHoverEffect(pauseButton, Color3.fromRGB(255, 220, 120))
addHoverEffect(stopButton, Color3.fromRGB(255, 120, 120))

-- Music control functionality
playButton.MouseButton1Click:Connect(function()
    -- Play all sounds in workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Sound") and not obj.IsPlaying then
            obj:Play()
        end
    end
    
    -- Play effect
    local playEffect = Instance.new("Sound")
    playEffect.SoundId = "rbxasset://sounds/electronicpingshort.wav"
    playEffect.Volume = 0.5
    playEffect.Pitch = 1.2
    playEffect.Parent = SoundService
    playEffect:Play()
    
    playEffect.Ended:Connect(function()
        playEffect:Destroy()
    end)
end)

pauseButton.MouseButton1Click:Connect(function()
    -- Pause all sounds in workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Sound") and obj.IsPlaying then
            obj:Pause()
        end
    end
    
    -- Pause effect
    local pauseEffect = Instance.new("Sound")
    pauseEffect.SoundId = "rbxasset://sounds/button.wav"
    pauseEffect.Volume = 0.4
    pauseEffect.Pitch = 0.9
    pauseEffect.Parent = SoundService
    pauseEffect:Play()
    
    pauseEffect.Ended:Connect(function()
        pauseEffect:Destroy()
    end)
end)

stopButton.MouseButton1Click:Connect(function()
    -- Stop all sounds in workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Sound") then
            obj:Stop()
        end
    end
    
    -- Stop effect
    local stopEffect = Instance.new("Sound")
    stopEffect.SoundId = "rbxasset://sounds/impact_water.mp3"
    stopEffect.Volume = 0.3
    stopEffect.Pitch = 0.7
    stopEffect.Parent = SoundService
    stopEffect:Play()
    
    stopEffect.Ended:Connect(function()
        stopEffect:Destroy()
    end)
end)


-- Enhanced Toggle Indicator (floating icon when GUI is closed)
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

local indicatorGradient = Instance.new("UIGradient")
indicatorGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 100, 255))
}
indicatorGradient.Rotation = 45
indicatorGradient.Parent = toggleIndicator

local indicatorIcon = Instance.new("TextLabel")
indicatorIcon.Name = "Icon"
indicatorIcon.Size = UDim2.new(1, 0, 1, 0)
indicatorIcon.BackgroundTransparency = 1
indicatorIcon.Text = "🚀"
indicatorIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
indicatorIcon.TextScaled = true
indicatorIcon.Font = Enum.Font.GothamBold
indicatorIcon.Parent = toggleIndicator

-- Floating animation for toggle indicator
local floatTween = TweenService:Create(
    toggleIndicator,
    TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Position = UDim2.new(0, 20, 0, 30)}
)
floatTween:Play()

-- Click to toggle functionality for indicator
local indicatorButton = Instance.new("TextButton")
indicatorButton.Size = UDim2.new(1, 0, 1, 0)
indicatorButton.BackgroundTransparency = 1
indicatorButton.Text = ""
indicatorButton.Parent = toggleIndicator

indicatorButton.MouseButton1Click:Connect(function()
    toggleGui()
end)

-- Add glow effect to indicator
local indicatorGlow = Instance.new("Frame")
indicatorGlow.Name = "Glow"
indicatorGlow.Size = UDim2.new(1, 20, 1, 20)
indicatorGlow.Position = UDim2.new(0, -10, 0, -10)
indicatorGlow.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
indicatorGlow.BackgroundTransparency = 0.7
indicatorGlow.BorderSizePixel = 0
indicatorGlow.ZIndex = toggleIndicator.ZIndex - 1
indicatorGlow.Parent = toggleIndicator

local indicatorGlowCorner = Instance.new("UICorner")
indicatorGlowCorner.CornerRadius = UDim.new(0, 35)
indicatorGlowCorner.Parent = indicatorGlow

-- Pulse effect for indicator glow
local pulseTween = TweenService:Create(
    indicatorGlow,
    TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {BackgroundTransparency = 0.9}
)
pulseTween:Play()

-- Update toggle function to hide/show indicator
local originalToggleGui = toggleGui
toggleGui = function()
    isGuiVisible = not isGuiVisible
    
    if isGuiVisible then
        toggleIndicator.Visible = false
        mainFrame.Visible = true
        animateIn(mainFrame, {
            Size = UDim2.new(0, 450, 0, 350),
            BackgroundTransparency = CONFIG.TRANSPARENCY_LEVEL
        })
        animateIn(blurEffect, {Size = CONFIG.BLUR_SIZE})
        
        -- Animate glow effect
        local glowTween = TweenService:Create(
            glowFrame,
            TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {BackgroundTransparency = 0.6}
        )
        glowTween:Play()
        connections.glowTween = glowTween
    else
        animateOut(mainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        })
        animateOut(blurEffect, {Size = 0})
        
        if connections.glowTween then
            connections.glowTween:Cancel()
            connections.glowTween = nil
        end
        
        wait(CONFIG.ANIMATION_SPEED)
        mainFrame.Visible = false
        toggleIndicator.Visible = true
    end
end

-- Enhanced close button with icon
closeButton.Text = "✕"

-- Add notification system
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
    
    wait(duration or 3 - 0.5)
    animateOut(notification, {Position = UDim2.new(1, 0, 0, 20)})
end

-- Show welcome notification
spawn(function()
    wait(1)
    showNotification("Advanced GUI loaded! Press Right Control to toggle", 4)
end)


-- Visual Effects Section
local effectsSection, effectsContent = createSection("Visual Effects", "✨", 3)

local effectsLayout = Instance.new("UIListLayout")
effectsLayout.SortOrder = Enum.SortOrder.LayoutOrder
effectsLayout.Padding = UDim.new(0, 5)
effectsLayout.Parent = effectsContent

-- Rainbow mode toggle
local rainbowToggle, getRainbowState = createToggleButton(effectsContent, "Rainbow Mode", false, function(state)
    if state then
        connections.rainbowLoop = RunService.Heartbeat:Connect(function()
            local time = tick()
            local hue = (time * 50) % 360
            local color = Color3.fromHSV(hue / 360, 1, 1)
            
            if mainFrame.Visible then
                glowFrame.BackgroundColor3 = color
                titleLabel.TextColor3 = color
            end
            toggleIndicator.BackgroundColor3 = color
        end)
        
        showNotification("Rainbow mode activated! 🌈", 2)
    else
        if connections.rainbowLoop then
            connections.rainbowLoop:Disconnect()
            connections.rainbowLoop = nil
        end
        
        -- Reset colors
        glowFrame.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleIndicator.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        
        showNotification("Rainbow mode deactivated", 2)
    end
end)

-- Particle effects toggle
local particleToggle, getParticleState = createToggleButton(effectsContent, "Particle Effects", false, function(state)
    local character = player.Character
    if not character then return end
    
    if state then
        local sparkles = Instance.new("Sparkles")
        sparkles.SparkleColor = Color3.fromRGB(100, 150, 255)
        sparkles.Parent = character:FindFirstChild("HumanoidRootPart")
        connections.sparkles = sparkles
        
        local fire = Instance.new("Fire")
        fire.Color = Color3.fromRGB(100, 150, 255)
        fire.SecondaryColor = Color3.fromRGB(150, 100, 255)
        fire.Size = 3
        fire.Heat = 5
        fire.Parent = character:FindFirstChild("HumanoidRootPart")
        connections.fire = fire
        
        showNotification("Particle effects enabled! ✨", 2)
    else
        if connections.sparkles then
            connections.sparkles:Destroy()
            connections.sparkles = nil
        end
        if connections.fire then
            connections.fire:Destroy()
            connections.fire = nil
        end
        
        showNotification("Particle effects disabled", 2)
    end
end)

-- Settings Section
local settingsSection, settingsContent = createSection("Settings", "⚙️", 4)

local settingsLayout = Instance.new("UIListLayout")
settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
settingsLayout.Padding = UDim.new(0, 5)
settingsLayout.Parent = settingsContent

-- Transparency control
local transparencySlider = createSlider(settingsContent, "Transparency", 0, 90, CONFIG.TRANSPARENCY_LEVEL * 100, function(value)
    CONFIG.TRANSPARENCY_LEVEL = value / 100
    mainFrame.BackgroundTransparency = CONFIG.TRANSPARENCY_LEVEL
    header.BackgroundTransparency = CONFIG.TRANSPARENCY_LEVEL + 0.1
end)

-- Animation speed control
local animSpeedSlider = createSlider(settingsContent, "Animation Speed", 10, 100, CONFIG.ANIMATION_SPEED * 100, function(value)
    CONFIG.ANIMATION_SPEED = value / 100
end)

-- Quick Actions Section
local actionsSection, actionsContent = createSection("Quick Actions", "⚡", 5)

local actionsLayout = Instance.new("UIListLayout")
actionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
actionsLayout.Padding = UDim.new(0, 5)
actionsLayout.Parent = actionsContent

-- Teleport to spawn button
local spawnButton = Instance.new("TextButton")
spawnButton.Name = "SpawnButton"
spawnButton.Size = UDim2.new(0.48, 0, 0, 30)
spawnButton.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
spawnButton.BackgroundTransparency = 0.2
spawnButton.BorderSizePixel = 0
spawnButton.Text = "🏠 Teleport to Spawn"
spawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnButton.TextScaled = true
spawnButton.Font = Enum.Font.GothamBold
spawnButton.LayoutOrder = 1
spawnButton.Parent = actionsContent

local spawnCorner = Instance.new("UICorner")
spawnCorner.CornerRadius = UDim.new(0, 6)
spawnCorner.Parent = spawnButton

-- Fly toggle button
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(0.48, 0, 0, 30)
flyButton.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
flyButton.BackgroundTransparency = 0.2
flyButton.BorderSizePixel = 0
flyButton.Text = "🚁 Toggle Fly"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextScaled = true
flyButton.Font = Enum.Font.GothamBold
flyButton.LayoutOrder = 2
flyButton.Parent = actionsContent

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 6)
flyCorner.Parent = flyButton

-- Add horizontal layout for action buttons
local actionsHorizontalLayout = Instance.new("UIListLayout")
actionsHorizontalLayout.SortOrder = Enum.SortOrder.LayoutOrder
actionsHorizontalLayout.Padding = UDim.new(0, 8)
actionsHorizontalLayout.FillDirection = Enum.FillDirection.Horizontal
actionsHorizontalLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
actionsHorizontalLayout.Parent = actionsContent

-- Spawn teleport functionality
spawnButton.MouseButton1Click:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local spawnLocation = workspace.SpawnLocation or workspace:FindFirstChild("Spawn")
        if spawnLocation then
            character.HumanoidRootPart.CFrame = spawnLocation.CFrame + Vector3.new(0, 5, 0)
            
            -- Teleport effect
            local teleportEffect = Instance.new("Explosion")
            teleportEffect.Position = character.HumanoidRootPart.Position
            teleportEffect.BlastRadius = 0
            teleportEffect.BlastPressure = 0
            teleportEffect.Parent = workspace
            
            showNotification("Teleported to spawn! 🏠", 2)
        else
            showNotification("Spawn location not found!", 2)
        end
    end
end)

-- Fly functionality
local flying = false
local flyConnection = nil

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
        
        flyConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            local camera = workspace.CurrentCamera
            local moveVector = Vector3.new(0, 0, 0)
            
            if input.KeyCode == Enum.KeyCode.W then
                moveVector = moveVector + camera.CFrame.LookVector
            elseif input.KeyCode == Enum.KeyCode.S then
                moveVector = moveVector - camera.CFrame.LookVector
            elseif input.KeyCode == Enum.KeyCode.A then
                moveVector = moveVector - camera.CFrame.RightVector
            elseif input.KeyCode == Enum.KeyCode.D then
                moveVector = moveVector + camera.CFrame.RightVector
            elseif input.KeyCode == Enum.KeyCode.Space then
                moveVector = moveVector + Vector3.new(0, 1, 0)
            elseif input.KeyCode == Enum.KeyCode.LeftShift then
                moveVector = moveVector - Vector3.new(0, 1, 0)
            end
            
            bodyVelocity.Velocity = moveVector * 50
        end)
        
        connections.flyConnection = flyConnection
        flyButton.Text = "🛑 Stop Flying"
        flyButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        showNotification("Flying enabled! Use WASD + Space/Shift", 3)
    else
        if connections.bodyVelocity then
            connections.bodyVelocity:Destroy()
            connections.bodyVelocity = nil
        end
        if connections.flyConnection then
            connections.flyConnection:Disconnect()
            connections.flyConnection = nil
        end
        
        flyButton.Text = "🚁 Toggle Fly"
        flyButton.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
        showNotification("Flying disabled", 2)
    end
end)

-- Add hover effects to action buttons
addHoverEffect(spawnButton, Color3.fromRGB(120, 255, 170))
addHoverEffect(flyButton, Color3.fromRGB(170, 120, 255))

-- Info Section
local infoSection, infoContent = createSection("Information", "📊", 6)

local infoLayout = Instance.new("UIListLayout")
infoLayout.SortOrder = Enum.SortOrder.LayoutOrder
infoLayout.Padding = UDim.new(0, 3)
infoLayout.Parent = infoContent

-- Player info display
local playerInfoLabel = Instance.new("TextLabel")
playerInfoLabel.Name = "PlayerInfo"
playerInfoLabel.Size = UDim2.new(1, 0, 0, 20)
playerInfoLabel.BackgroundTransparency = 1
playerInfoLabel.Text = "Player: " .. player.Name
playerInfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
playerInfoLabel.TextScaled = true
playerInfoLabel.Font = Enum.Font.Gotham
playerInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
playerInfoLabel.LayoutOrder = 1
playerInfoLabel.Parent = infoContent

-- FPS counter
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPSLabel"
fpsLabel.Size = UDim2.new(1, 0, 0, 20)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: Calculating..."
fpsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
fpsLabel.TextScaled = true
fpsLabel.Font = Enum.Font.Gotham
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.LayoutOrder = 2
fpsLabel.Parent = infoContent

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

-- Position display
local positionLabel = Instance.new("TextLabel")
positionLabel.Name = "PositionLabel"
positionLabel.Size = UDim2.new(1, 0, 0, 20)
positionLabel.BackgroundTransparency = 1
positionLabel.Text = "Position: 0, 0, 0"
positionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
positionLabel.TextScaled = true
positionLabel.Font = Enum.Font.Gotham
positionLabel.TextXAlignment = Enum.TextXAlignment.Left
positionLabel.LayoutOrder = 3
positionLabel.Parent = infoContent

-- Position tracking
connections.positionTracker = RunService.Heartbeat:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        positionLabel.Text = string.format("Position: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
    end
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

print("🚀 Advanced GUI System fully loaded!")
print("📋 Features included:")
print("   • Character controls (Speed & Jump)")
print("   • Music controls with Noclip")
print("   • Visual effects and particles")
print("   • Quick actions (Teleport & Fly)")
print("   • Real-time information display")
print("   • Customizable settings")
print("⌨️  Press Right Control to toggle interface")
print("🎯 Click the floating icon to open GUI")

