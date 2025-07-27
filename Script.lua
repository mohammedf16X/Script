-- Advanced Character Control GUI with Enhanced Effects
-- Created with Luau for Roblox Studio

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuration
local Config = {
    Theme = {
        Dark = {
            Primary = Color3.fromRGB(20, 20, 30),
            Secondary = Color3.fromRGB(35, 35, 50),
            Accent = Color3.fromRGB(100, 150, 255),
            Text = Color3.fromRGB(255, 255, 255),
            Success = Color3.fromRGB(46, 204, 113),
            Error = Color3.fromRGB(231, 76, 60),
            Background = Color3.fromRGB(15, 15, 25)
        },
        Light = {
            Primary = Color3.fromRGB(240, 240, 245),
            Secondary = Color3.fromRGB(220, 220, 230),
            Accent = Color3.fromRGB(70, 130, 255),
            Text = Color3.fromRGB(30, 30, 40),
            Success = Color3.fromRGB(39, 174, 96),
            Error = Color3.fromRGB(192, 57, 43),
            Background = Color3.fromRGB(250, 250, 255)
        }
    },
    CurrentTheme = "Dark",
    DefaultSpeed = 16,
    DefaultJump = 50,
    MaxSpeed = 100,
    MaxJump = 200
}

-- State Management
local State = {
    SpeedValue = Config.DefaultSpeed,
    JumpValue = Config.DefaultJump,
    NoClipEnabled = false,
    UIVisible = true,
    Connections = {}
}

-- Utility Functions
local function CreateTweenInfo(duration, style, direction)
    return TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )
end

local function AnimateElement(element, properties, duration, style)
    local tween = TweenService:Create(element, CreateTweenInfo(duration, style), properties)
    tween:Play()
    return tween
end

local function CreateGradient(colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colors)
    gradient.Rotation = rotation or 45
    return gradient
end

local function CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    return corner
end

local function CreateStroke(thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    return stroke
end

local function CreateShadow(parent, offset, blur)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Parent = parent
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/Controls/DropShadow.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Size = UDim2.new(1, blur or 20, 1, blur or 20)
    shadow.Position = UDim2.new(0, offset or 5, 0, offset or 5)
    shadow.ZIndex = parent.ZIndex - 1
end

-- Icon System
local Icons = {
    Character = "rbxassetid://4483345998",
    Speed = "rbxassetid://4483362458",
    Jump = "rbxassetid://4483345875",
    NoClip = "rbxassetid://4483362748",
    Settings = "rbxassetid://4483345737",
    Check = "rbxassetid://4507466504",
    Cross = "rbxassetid://4507466882",
    Moon = "rbxassetid://4483345998",
    Sun = "rbxassetid://4483362458"
}

-- Theme Manager
local ThemeManager = {}

function ThemeManager:GetCurrentTheme()
    return Config.Theme[Config.CurrentTheme]
end

function ThemeManager:SwitchTheme()
    Config.CurrentTheme = Config.CurrentTheme == "Dark" and "Light" or "Dark"
    self:ApplyTheme()
end

function ThemeManager:ApplyTheme()
    local theme = self:GetCurrentTheme()
    -- Theme application will be handled by individual components
end

-- GUI Components
local function CreateMainFrame()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdvancedCharacterGUI"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = ThemeManager:GetCurrentTheme().Primary
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
    mainFrame.Size = UDim2.new(0, 350, 0, 450)
    mainFrame.ClipsDescendants = true
    
    CreateCorner(12).Parent = mainFrame
    CreateStroke(2, ThemeManager:GetCurrentTheme().Accent).Parent = mainFrame
    CreateShadow(mainFrame, 8, 25)
    
    -- Animated background gradient
    local bgGradient = CreateGradient({
        ThemeManager:GetCurrentTheme().Primary,
        ThemeManager:GetCurrentTheme().Secondary
    }, 135)
    bgGradient.Parent = mainFrame
    
    -- Pulse animation for background
    spawn(function()
        while true do
            AnimateElement(bgGradient, {Rotation = bgGradient.Rotation + 360}, 10, Enum.EasingStyle.Linear)
            wait(10)
        end
    end)
    
    return screenGui, mainFrame
end

local function CreateHeader(parent)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Parent = parent
    header.BackgroundColor3 = ThemeManager:GetCurrentTheme().Accent
    header.BorderSizePixel = 0
    header.Size = UDim2.new(1, 0, 0, 60)
    header.Position = UDim2.new(0, 0, 0, 0)
    
    CreateCorner(12).Parent = header
    
    local headerGradient = CreateGradient({
        ThemeManager:GetCurrentTheme().Accent,
        Color3.fromRGB(
            ThemeManager:GetCurrentTheme().Accent.R * 255 * 0.8,
            ThemeManager:GetCurrentTheme().Accent.G * 255 * 0.8,
            ThemeManager:GetCurrentTheme().Accent.B * 255 * 0.8
        )
    })
    headerGradient.Parent = header
    
    -- Character Icon
    local icon = Instance.new("ImageLabel")
    icon.Name = "CharacterIcon"
    icon.Parent = header
    icon.BackgroundTransparency = 1
    icon.Image = Icons.Character
    icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    icon.Size = UDim2.new(0, 35, 0, 35)
    icon.Position = UDim2.new(0, 15, 0.5, -17.5)
    
    -- Rotating animation for icon
    spawn(function()
        while true do
            AnimateElement(icon, {Rotation = icon.Rotation + 360}, 3, Enum.EasingStyle.Linear)
            wait(3)
        end
    end)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = header
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "CHARACTER CONTROL"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Size = UDim2.new(1, -130, 1, 0)
    title.Position = UDim2.new(0, 60, 0, 0)
    
    -- Settings Button
    local settingsBtn = Instance.new("ImageButton")
    settingsBtn.Name = "SettingsButton"
    settingsBtn.Parent = header
    settingsBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    settingsBtn.BackgroundTransparency = 0.9
    settingsBtn.Image = Icons.Settings
    settingsBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
    settingsBtn.Size = UDim2.new(0, 30, 0, 30)
    settingsBtn.Position = UDim2.new(1, -45, 0.5, -15)
    
    CreateCorner(6).Parent = settingsBtn
    
    return header, settingsBtn
end

local function CreateControlSlider(parent, name, iconId, minVal, maxVal, currentVal, yPos)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Parent = parent
    container.BackgroundColor3 = ThemeManager:GetCurrentTheme().Secondary
    container.BorderSizePixel = 0
    container.Position = UDim2.new(0, 15, 0, yPos)
    container.Size = UDim2.new(1, -30, 0, 80)
    
    CreateCorner(10).Parent = container
    CreateStroke(1, ThemeManager:GetCurrentTheme().Accent).Parent = container
    
    -- Icon
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Parent = container
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = ThemeManager:GetCurrentTheme().Accent
    icon.Size = UDim2.new(0, 25, 0, 25)
    icon.Position = UDim2.new(0, 15, 0, 12)
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.Text = name:upper()
    label.TextColor3 = ThemeManager:GetCurrentTheme().Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Size = UDim2.new(1, -120, 0, 20)
    label.Position = UDim2.new(0, 50, 0, 8)
    
    -- Value Display
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Parent = container
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = tostring(currentVal)
    valueLabel.TextColor3 = ThemeManager:GetCurrentTheme().Accent
    valueLabel.TextSize = 16
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -70, 0, 8)
    
    -- Slider Background
    local sliderBg = Instance.new("Frame")
    sliderBg.Name = "SliderBackground"
    sliderBg.Parent = container
    sliderBg.BackgroundColor3 = ThemeManager:GetCurrentTheme().Primary
    sliderBg.BorderSizePixel = 0
    sliderBg.Position = UDim2.new(0, 15, 0, 45)
    sliderBg.Size = UDim2.new(1, -30, 0, 20)
    
    CreateCorner(10).Parent = sliderBg
    
    -- Slider Fill
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Parent = sliderBg
    sliderFill.BackgroundColor3 = ThemeManager:GetCurrentTheme().Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new((currentVal - minVal) / (maxVal - minVal), 0, 1, 0)
    
    CreateCorner(10).Parent = sliderFill
    
    local fillGradient = CreateGradient({
        ThemeManager:GetCurrentTheme().Accent,
        Color3.fromRGB(
            ThemeManager:GetCurrentTheme().Accent.R * 255 * 1.2,
            ThemeManager:GetCurrentTheme().Accent.G * 255 * 1.2,
            ThemeManager:GetCurrentTheme().Accent.B * 255 * 1.2
        )
    })
    fillGradient.Parent = sliderFill
    
    -- Slider Knob
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Parent = sliderBg
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Size = UDim2.new(0, 24, 0, 24)
    knob.Position = UDim2.new((currentVal - minVal) / (maxVal - minVal), -12, 0.5, -12)
    
    CreateCorner(12).Parent = knob
    CreateShadow(knob, 2, 8)
    
    return container, sliderBg, sliderFill, knob, valueLabel
end

local function CreateToggleButton(parent, name, iconId, yPos)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Parent = parent
    container.BackgroundColor3 = ThemeManager:GetCurrentTheme().Secondary
    container.BorderSizePixel = 0
    container.Position = UDim2.new(0, 15, 0, yPos)
    container.Size = UDim2.new(1, -30, 0, 60)
    
    CreateCorner(10).Parent = container
    CreateStroke(1, ThemeManager:GetCurrentTheme().Accent).Parent = container
    
    -- Icon
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Parent = container
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = ThemeManager:GetCurrentTheme().Accent
    icon.Size = UDim2.new(0, 25, 0, 25)
    icon.Position = UDim2.new(0, 15, 0.5, -12.5)
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.Text = name:upper()
    label.TextColor3 = ThemeManager:GetCurrentTheme().Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Size = UDim2.new(1, -150, 1, 0)
    label.Position = UDim2.new(0, 50, 0, 0)
    
    -- Toggle Button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleButton"
    toggleBtn.Parent = container
    toggleBtn.BackgroundColor3 = ThemeManager:GetCurrentTheme().Error
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Text = ""
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 12
    toggleBtn.Size = UDim2.new(0, 80, 0, 35)
    toggleBtn.Position = UDim2.new(1, -95, 0.5, -17.5)
    
    CreateCorner(8).Parent = toggleBtn
    
    -- Toggle Icon
    local toggleIcon = Instance.new("ImageLabel")
    toggleIcon.Name = "ToggleIcon"
    toggleIcon.Parent = toggleBtn
    toggleIcon.BackgroundTransparency = 1
    toggleIcon.Image = Icons.Cross
    toggleIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    toggleIcon.Size = UDim2.new(0, 20, 0, 20)
    toggleIcon.Position = UDim2.new(0.5, -10, 0.5, -10)
    
    -- Status Text
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Parent = toggleBtn
    statusText.BackgroundTransparency = 1
    statusText.Font = Enum.Font.GothamSemibold
    statusText.Text = "OFF"
    statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusText.TextSize = 10
    statusText.Size = UDim2.new(1, 0, 0, 12)
    statusText.Position = UDim2.new(0, 0, 1, -15)
    
    return container, toggleBtn, toggleIcon, statusText
end

local function CreateSettingsPanel(parent)
    local settingsPanel = Instance.new("Frame")
    settingsPanel.Name = "SettingsPanel"
    settingsPanel.Parent = parent
    settingsPanel.BackgroundColor3 = ThemeManager:GetCurrentTheme().Secondary
    settingsPanel.BorderSizePixel = 0
    settingsPanel.Position = UDim2.new(0, 15, 0, 380)
    settingsPanel.Size = UDim2.new(1, -30, 0, 55)
    settingsPanel.Visible = false
    
    CreateCorner(10).Parent = settingsPanel
    CreateStroke(1, ThemeManager:GetCurrentTheme().Accent).Parent = settingsPanel
    
    -- Theme Toggle
    local themeLabel = Instance.new("TextLabel")
    themeLabel.Name = "ThemeLabel"
    themeLabel.Parent = settingsPanel
    themeLabel.BackgroundTransparency = 1
    themeLabel.Font = Enum.Font.GothamSemibold
    themeLabel.Text = "THEME"
    themeLabel.TextColor3 = ThemeManager:GetCurrentTheme().Text
    themeLabel.TextSize = 12
    themeLabel.Size = UDim2.new(0, 60, 1, 0)
    themeLabel.Position = UDim2.new(0, 15, 0, 0)
    
    local themeBtn = Instance.new("TextButton")
    themeBtn.Name = "ThemeButton"
    themeBtn.Parent = settingsPanel
    themeBtn.BackgroundColor3 = ThemeManager:GetCurrentTheme().Accent
    themeBtn.BorderSizePixel = 0
    themeBtn.Font = Enum.Font.GothamBold
    themeBtn.Text = Config.CurrentTheme:upper()
    themeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    themeBtn.TextSize = 11
    themeBtn.Size = UDim2.new(0, 70, 0, 30)
    themeBtn.Position = UDim2.new(1, -85, 0.5, -15)
    
    CreateCorner(6).Parent = themeBtn
    
    local themeIcon = Instance.new("ImageLabel")
    themeIcon.Name = "ThemeIcon"
    themeIcon.Parent = themeBtn
    themeIcon.BackgroundTransparency = 1
    themeIcon.Image = Config.CurrentTheme == "Dark" and Icons.Moon or Icons.Sun
    themeIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    themeIcon.Size = UDim2.new(0, 16, 0, 16)
    themeIcon.Position = UDim2.new(0, 5, 0.5, -8)
    
    return settingsPanel, themeBtn, themeIcon
end

-- Main GUI Creation
local function CreateGUI()
    local screenGui, mainFrame = CreateMainFrame()
    local header, settingsBtn = CreateHeader(mainFrame)
    
    -- Character Controls
    local speedContainer, speedSliderBg, speedSliderFill, speedKnob, speedValueLabel = 
        CreateControlSlider(mainFrame, "Speed", Icons.Speed, 16, Config.MaxSpeed, State.SpeedValue, 80)
    
    local jumpContainer, jumpSliderBg, jumpSliderFill, jumpKnob, jumpValueLabel = 
        CreateControlSlider(mainFrame, "Jump", Icons.Jump, 16, Config.MaxJump, State.JumpValue, 180)
    
    local noclipContainer, noclipToggleBtn, noclipToggleIcon, noclipStatusText = 
        CreateToggleButton(mainFrame, "NoClip", Icons.NoClip, 280)
    
    -- Settings Panel
    local settingsPanel, themeBtn, themeIcon = CreateSettingsPanel(mainFrame)
    
    -- Slider Logic
    local function SetupSlider(sliderBg, sliderFill, knob, valueLabel, minVal, maxVal, currentVal, callback)
        local dragging = false
        
        local function UpdateSlider(value)
            value = math.clamp(value, minVal, maxVal)
            local percentage = (value - minVal) / (maxVal - minVal)
            
            AnimateElement(sliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
            AnimateElement(knob, {Position = UDim2.new(percentage, -12, 0.5, -12)}, 0.1)
            
            valueLabel.Text = tostring(math.floor(value))
            
            if callback then
                callback(value)
            end
        end
        
        knob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                AnimateElement(knob, {Size = UDim2.new(0, 28, 0, 28)}, 0.1)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                dragging = false
                AnimateElement(knob, {Size = UDim2.new(0, 24, 0, 24)}, 0.1)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mouse = Players.LocalPlayer:GetMouse()
                local relativeX = mouse.X - sliderBg.AbsolutePosition.X
                local percentage = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)
                local value = minVal + (maxVal - minVal) * percentage
                
                UpdateSlider(value)
            end
        end)
        
        UpdateSlider(currentVal)
    end
    
    -- Setup Speed Slider
    SetupSlider(speedSliderBg, speedSliderFill, speedKnob, speedValueLabel, 16, Config.MaxSpeed, State.SpeedValue, function(value)
        State.SpeedValue = value
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end)
    
    -- Setup Jump Slider
    SetupSlider(jumpSliderBg, jumpSliderFill, jumpKnob, jumpValueLabel, 16, Config.MaxJump, State.JumpValue, function(value)
        State.JumpValue = value
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = value
        end
    end)
    
    -- NoClip Toggle Logic
    local function ToggleNoClip()
        State.NoClipEnabled = not State.NoClipEnabled
        
        if State.NoClipEnabled then
            AnimateElement(noclipToggleBtn, {BackgroundColor3 = ThemeManager:GetCurrentTheme().Success}, 0.2)
            noclipToggleIcon.Image = Icons.Check
            noclipStatusText.Text = "ON"
            
            -- Enable NoClip
            State.Connections.NoClip = RunService.Stepped:Connect(function()
                if player.Character then
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            AnimateElement(noclipToggleBtn, {BackgroundColor3 = ThemeManager:GetCurrentTheme().Error}, 0.2)
            noclipToggleIcon.Image = Icons.Cross
            noclipStatusText.Text = "OFF"
            
            -- Disable NoClip
            if State.Connections.NoClip then
                State.Connections.NoClip:Disconnect()
                State.Connections.NoClip = nil
            end
            
            if player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end
        
        -- Pulse animation
        local originalSize = noclipToggleBtn.Size
        AnimateElement(noclipToggleBtn, {Size = UDim2.new(0, 85, 0, 38)}, 0.1)
        wait(0.1)
        AnimateElement(noclipToggleBtn, {Size = originalSize}, 0.1)
    end
    
    noclipToggleBtn.MouseButton1Click:Connect(ToggleNoClip)
    
    -- Settings Panel Logic
    local settingsPanelVisible = false
    
    settingsBtn.MouseButton1Click:Connect(function()
        settingsPanelVisible = not settingsPanelVisible
        
        if settingsPanelVisible then
            settingsPanel.Visible = true
            AnimateElement(settingsPanel, {Position = UDim2.new(0, 15, 0, 320)}, 0.3)
            AnimateElement(mainFrame, {Size = UDim2.new(0, 350, 0, 400)}, 0.3)
        else
            AnimateElement(settingsPanel, {Position = UDim2.new(0, 15, 0, 380)}, 0.3)
            AnimateElement(mainFrame, {Size = UDim2.new(0, 350, 0, 350)}, 0.3)
            wait(0.3)
            settingsPanel.Visible = false
        end
        
        -- Rotate settings icon
        AnimateElement(settingsBtn, {Rotation = settingsBtn.Rotation + 180}, 0.3)
    end)
    
    -- Theme Toggle Logic
    themeBtn.MouseButton1Click:Connect(function()
        ThemeManager:SwitchTheme()
        themeBtn.Text = Config.CurrentTheme:upper()
        themeIcon.Image = Config.CurrentTheme == "Dark" and Icons.Moon or Icons.Sun
        
        -- Update all UI elements with new theme
        -- This would require rebuilding the GUI or updating each element individually
        AnimateElement(themeBtn, {BackgroundColor3 = ThemeManager:GetCurrentTheme().Accent}, 0.3)
    end)
    
    -- Entrance Animation
    mainFrame.Position = UDim2.new(-0.5, 0, 0.3, 0)
    AnimateElement(mainFrame, {Position = UDim2.new(0.02, 0, 0.3, 0)}, 0.8, Enum.EasingStyle.Back)
    
    -- Toggle GUI Visibility
    UserInputService.InputBegan:Connect(function(key)
        if key.KeyCode == Enum.KeyCode.Insert then
            State.UIVisible = not State.UIVisible
            
            if State.UIVisible then
                AnimateElement(mainFrame, {
                    Position = UDim2.new(0.02, 0, 0.3, 0),
                    Size = UDim2.new(0, 350, 0, 450)
                }, 0.5, Enum.EasingStyle.Back)
            else
                AnimateElement(mainFrame, {
                    Position = UDim2.new(-0.5, 0, 0.3, 0),
                    Size = UDim2.new(0, 0, 0, 0)
                }, 0.5, Enum.EasingStyle.Back)
            end
        end
    end)
    
    return screenGui
end

-- Initialize
local gui = CreateGUI()

-- Character Respawn Handler
player.CharacterAdded:Connect(function(character)
    wait(1) -- Wait for character to fully load
    
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Apply current settings to new character
    humanoid.WalkSpeed = State.SpeedValue
    humanoid.JumpPower = State.JumpValue
    
    -- Reapply NoClip if it was enabled
    if State.NoClipEnabled then
        if State.Connections.NoClip then
            State.Connections.NoClip:Disconnect()
        end
        
        State.Connections.NoClip = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Advanced Visual Effects System
local EffectsManager = {}

function EffectsManager:CreateParticleEffect(parent, color)
    local attachment = Instance.new("Attachment")
    attachment.Parent = parent
    
    local particles = Instance.new("ParticleEmitter")
    particles.Parent = attachment
    particles.Color = ColorSequence.new(color or ThemeManager:GetCurrentTheme().Accent)
    particles.Size = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(0.5, 0.3),
        NumberSequenceKeypoint.new(1, 0)
    }
    particles.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.7, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    }
    particles.Lifetime = NumberRange.new(0.5, 1.2)
    particles.Rate = 50
    particles.VelocityInheritance = 0.5
    particles.Speed = NumberRange.new(2)
    particles.SpreadAngle = Vector2.new(45, 45)
    
    return particles
end

function EffectsManager:CreateRippleEffect(position, color)
    local ripple = Instance.new("SelectionBox")
    ripple.Adornee = workspace
    ripple.Color3 = color or ThemeManager:GetCurrentTheme().Accent
    ripple.LineThickness = 0.2
    ripple.Transparency = 0.5
    
    -- Animate ripple expansion
    local startSize = Vector3.new(0, 0, 0)
    local endSize = Vector3.new(20, 20, 20)
    
    spawn(function()
        for i = 0, 1, 0.05 do
            local currentSize = startSize:Lerp(endSize, i)
            ripple.Size = currentSize
            ripple.Transparency = 0.5 + (i * 0.5)
            wait(0.02)
        end
        ripple:Destroy()
    end)
end

-- Sound Effects System
local SoundManager = {}

function SoundManager:PlaySound(soundId, volume, pitch)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(soundId)
    sound.Volume = volume or 0.5
    sound.Pitch = pitch or 1
    sound.Parent = SoundService
    
    sound:Play()
    
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
    
    return sound
end

-- Enhanced Notification System
local NotificationManager = {}

function NotificationManager:ShowNotification(message, type, duration)
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "NotificationGui"
    notificationGui.Parent = playerGui
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Parent = notificationGui
    notification.BackgroundColor3 = type == "success" and ThemeManager:GetCurrentTheme().Success or 
                                   type == "error" and ThemeManager:GetCurrentTheme().Error or 
                                   ThemeManager:GetCurrentTheme().Accent
    notification.BorderSizePixel = 0
    notification.Position = UDim2.new(0.5, -150, 0, -60)
    notification.Size = UDim2.new(0, 300, 0, 50)
    
    CreateCorner(8).Parent = notification
    CreateShadow(notification, 5, 15)
    
    local notificationText = Instance.new("TextLabel")
    notificationText.Name = "NotificationText"
    notificationText.Parent = notification
    notificationText.BackgroundTransparency = 1
    notificationText.Font = Enum.Font.GothamSemibold
    notificationText.Text = message
    notificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notificationText.TextSize = 14
    notificationText.Size = UDim2.new(1, -20, 1, 0)
    notificationText.Position = UDim2.new(0, 10, 0, 0)
    
    -- Animate notification
    AnimateElement(notification, {Position = UDim2.new(0.5, -150, 0, 20)}, 0.5, Enum.EasingStyle.Back)
    
    -- Auto-hide notification
    spawn(function()
        wait(duration or 3)
        AnimateElement(notification, {
            Position = UDim2.new(0.5, -150, 0, -60),
            Transparency = 1
        }, 0.3)
        AnimateElement(notificationText, {TextTransparency = 1}, 0.3)
        wait(0.3)
        notificationGui:Destroy()
    end)
end

-- Performance Monitor
local PerformanceMonitor = {}

function PerformanceMonitor:CreateFPSCounter(parent)
    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Name = "FPSCounter"
    fpsLabel.Parent = parent
    fpsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    fpsLabel.BackgroundTransparency = 0.5
    fpsLabel.BorderSizePixel = 0
    fpsLabel.Font = Enum.Font.Code
    fpsLabel.Text = "FPS: 60"
    fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    fpsLabel.TextSize = 12
    fpsLabel.Size = UDim2.new(0, 80, 0, 25)
    fpsLabel.Position = UDim2.new(1, -90, 0, 10)
    
    CreateCorner(4).Parent = fpsLabel
    
    local lastTime = tick()
    local frameCount = 0
    
    RunService.Heartbeat:Connect(function()
        frameCount = frameCount + 1
        local currentTime = tick()
        
        if currentTime - lastTime >= 1 then
            local fps = math.floor(frameCount / (currentTime - lastTime))
            fpsLabel.Text = "FPS: " .. fps
            
            -- Color coding for FPS
            if fps >= 45 then
                fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- Green
            elseif fps >= 25 then
                fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 0) -- Yellow
            else
                fpsLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red
            end
            
            frameCount = 0
            lastTime = currentTime
        end
    end)
    
    return fpsLabel
end

-- Advanced Keybind System
local KeybindManager = {}
KeybindManager.Keybinds = {
    ToggleGUI = Enum.KeyCode.Insert,
    SpeedBoost = Enum.KeyCode.LeftShift,
    NoClipToggle = Enum.KeyCode.N,
    ResetCharacter = Enum.KeyCode.R
}

function KeybindManager:SetupKeybinds()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == self.Keybinds.SpeedBoost then
            -- Temporary speed boost
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                local originalSpeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = math.min(originalSpeed * 2, Config.MaxSpeed)
                
                NotificationManager:ShowNotification("Speed Boost Activated!", "success", 1)
                SoundManager:PlaySound(131961136, 0.3, 1.5)
                EffectsManager:CreateRippleEffect(player.Character.HumanoidRootPart.Position, Color3.fromRGB(255, 255, 0))
            end
        elseif input.KeyCode == self.Keybinds.NoClipToggle then
            -- Quick NoClip toggle
            State.NoClipEnabled = not State.NoClipEnabled
            NotificationManager:ShowNotification(
                "NoClip " .. (State.NoClipEnabled and "Enabled" or "Disabled"),
                State.NoClipEnabled and "success" or "error",
                2
            )
        elseif input.KeyCode == self.Keybinds.ResetCharacter then
            -- Reset character stats
            State.SpeedValue = Config.DefaultSpeed
            State.JumpValue = Config.DefaultJump
            State.NoClipEnabled = false
            
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                humanoid.WalkSpeed = Config.DefaultSpeed
                humanoid.JumpPower = Config.DefaultJump
            end
            
            NotificationManager:ShowNotification("Character Stats Reset!", "success", 2)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == self.Keybinds.SpeedBoost then
            -- Return to normal speed
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = State.SpeedValue
            end
        end
    end)
end

-- Initialize Advanced Systems
KeybindManager:SetupKeybinds()

-- Add FPS Counter to main GUI
if gui then
    local mainFrame = gui:FindFirstChild("MainFrame")
    if mainFrame then
        PerformanceMonitor:CreateFPSCounter(mainFrame)
    end
end

-- Welcome Message
spawn(function()
    wait(1)
    NotificationManager:ShowNotification("Advanced Character Control Loaded!", "success", 4)
    SoundManager:PlaySound(131961136, 0.4, 1.2)
end)

-- Cleanup function
local function Cleanup()
    for _, connection in pairs(State.Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    
    if gui then
        gui:Destroy()
    end
end

-- Connect cleanup to player leaving
Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        Cleanup()
    end
end)

print("Advanced Character Control GUI v2.0 - Created with Enhanced Effects & Features")
print("Controls:")
print("- INSERT: Toggle GUI")
print("- LEFT SHIFT (Hold): Speed Boost")
print("- N: Quick NoClip Toggle") 
print("- R: Reset Character Stats")
print("Enjoy the enhanced experience!")
