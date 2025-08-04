-- Advanced Character Controller UI - Maximum Performance & Features
-- Created for Roblox using Luau with full optimization and error handling

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

-- Configuration
local CONFIG = {
    UI = {
        SIZE = Vector2.new(420, 650),
        MIN_SIZE = Vector2.new(350, 500),
        MAX_SIZE = Vector2.new(500, 800),
        ANIMATION_TIME = 0.6,
        CORNER_RADIUS = 20,
        BORDER_THICKNESS = 2
    },
    SPEED = {
        MIN = 1,
        MAX = 100,
        DEFAULT = 16,
        PRECISION = 1
    },
    COLORS = {
        PRIMARY = Color3.fromRGB(18, 18, 22),
        SECONDARY = Color3.fromRGB(25, 25, 35),
        ACCENT = Color3.fromRGB(100, 150, 255),
        SUCCESS = Color3.fromRGB(100, 200, 100),
        WARNING = Color3.fromRGB(255, 200, 100),
        DANGER = Color3.fromRGB(255, 100, 100),
        TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),
        TEXT_SECONDARY = Color3.fromRGB(200, 200, 200),
        DISABLED = Color3.fromRGB(100, 100, 100)
    }
}

-- Utility Functions
local Utils = {}

function Utils.createSound(soundId, volume, pitch)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxasset://sounds/" .. soundId
    sound.Volume = volume or 0.3
    sound.Pitch = pitch or 1
    sound.Parent = SoundService
    return sound
end

function Utils.safeDestroy(instance)
    if instance and instance.Parent then
        instance:Destroy()
    end
end

function Utils.validateNumber(value, min, max, default)
    local num = tonumber(value)
    if not num then return default end
    return math.clamp(num, min or -math.huge, max or math.huge)
end

function Utils.formatNumber(number, decimals)
    local multiplier = 10 ^ (decimals or 0)
    return math.floor(number * multiplier) / multiplier
end

function Utils.lerp(a, b, t)
    return a + (b - a) * t
end

function Utils.createTween(instance, info, properties, callback)
    local tween = TweenService:Create(instance, info, properties)
    if callback then
        tween.Completed:Once(callback)
    end
    tween:Play()
    return tween
end

-- Main UI Controller Class
local UIController = {}
UIController.__index = UIController

function UIController.new()
    local self = setmetatable({}, UIController)
    
    -- Core properties
    self.player = Players.LocalPlayer
    self.playerGui = self.player:WaitForChild("PlayerGui")
    self.currentSpeed = CONFIG.SPEED.DEFAULT
    self.previousSpeed = CONFIG.SPEED.DEFAULT
    self.isVisible = true
    self.isDragging = false
    self.isMinimized = false
    
    -- Connection storage for cleanup
    self.connections = {}
    self.tweens = {}
    
    -- UI Components storage
    self.components = {}
    
    -- Sound effects
    self.sounds = {
        click = Utils.createSound("button_activate_01.mp3", 0.2),
        hover = Utils.createSound("button_hover_01.mp3", 0.1),
        slide = Utils.createSound("slider_tick_01.mp3", 0.15),
        notification = Utils.createSound("notification_01.mp3", 0.25)
    }
    
    -- Initialize UI
    self:initialize()
    
    return self
end

function UIController:initialize()
    -- Safety check for existing UI
    local existingUI = self.playerGui:FindFirstChild("CharacterControllerUI")
    if existingUI then
        existingUI:Destroy()
        wait(0.1)
    end
    
    -- Create main UI
    self:createMainUI()
    self:setupEventHandlers()
    self:setupCharacterConnection()
    self:startUpdateLoop()
    
    -- Apply initial speed
    self:applySpeedToCharacter()
    
    -- Show entrance animation
    self:playEntranceAnimation()
    
    -- Auto-save/load settings
    self:loadSettings()
end

function UIController:createMainUI()
    -- Main ScreenGui with enhanced properties
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CharacterControllerUI"
    screenGui.Parent = self.playerGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 100
    
    -- Main container with responsive design
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, CONFIG.UI.SIZE.X, 0, CONFIG.UI.SIZE.Y)
    mainFrame.Position = UDim2.new(0, 50, 0.5, -CONFIG.UI.SIZE.Y/2)
    mainFrame.BackgroundColor3 = CONFIG.COLORS.PRIMARY
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Active = true
    mainFrame.Parent = screenGui
    
    -- Enhanced visual effects
    self:applyVisualEffects(mainFrame)
    
    -- Create sections
    self:createHeader(mainFrame)
    self:createContentArea(mainFrame)
    
    -- Store main references
    self.screenGui = screenGui
    self.mainFrame = mainFrame
    
    -- Setup dragging and resizing
    self:setupDragging()
    self:setupResizing()
end

function UIController:applyVisualEffects(frame)
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CONFIG.UI.CORNER_RADIUS)
    corner.Parent = frame
    
    -- Advanced gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, CONFIG.COLORS.SECONDARY),
        ColorSequenceKeypoint.new(0.5, CONFIG.COLORS.PRIMARY),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
    }
    gradient.Rotation = 135
    gradient.Parent = frame
    
    -- Animated border
    local stroke = Instance.new("UIStroke")
    stroke.Color = CONFIG.COLORS.ACCENT
    stroke.Thickness = CONFIG.UI.BORDER_THICKNESS
    stroke.Transparency = 0.3
    stroke.Parent = frame
    
    -- Pulsing border animation
    local borderTween = TweenService:Create(stroke,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, 0),
        {Transparency = 0.7}
    )
    borderTween:Play()
    table.insert(self.tweens, borderTween)
    
    -- Drop shadow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "DropShadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ZIndex = -1
    shadow.Parent = frame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, CONFIG.UI.CORNER_RADIUS + 5)
    shadowCorner.Parent = shadow
end

function UIController:createHeader(parent)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 80)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    header.BorderSizePixel = 0
    header.Parent = parent
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, CONFIG.UI.CORNER_RADIUS)
    headerCorner.Parent = header
    
    -- Header gradient
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
    }
    headerGradient.Rotation = 90
    headerGradient.Parent = header
    
    -- Title with icon
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ Character Controller Pro"
    title.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Version label
    local version = Instance.new("TextLabel")
    version.Name = "Version"
    version.Size = UDim2.new(0, 60, 0, 20)
    version.Position = UDim2.new(1, -180, 0, 50)
    version.BackgroundTransparency = 1
    version.Text = "v2.0"
    version.TextColor3 = CONFIG.COLORS.TEXT_SECONDARY
    version.TextScaled = true
    version.Font = Enum.Font.Gotham
    version.Parent = header
    
    -- Control buttons container
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Size = UDim2.new(0, 100, 0, 40)
    buttonContainer.Position = UDim2.new(1, -120, 0, 20)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = header
    
    -- Minimize button
    local minimizeBtn = self:createHeaderButton(buttonContainer, "−", CONFIG.COLORS.WARNING, UDim2.new(0, 0, 0, 0))
    minimizeBtn.MouseButton1Click:Connect(function()
        self:toggleMinimize()
        self.sounds.click:Play()
    end)
    
    -- Close button
    local closeBtn = self:createHeaderButton(buttonContainer, "✕", CONFIG.COLORS.DANGER, UDim2.new(0, 50, 0, 0))
    closeBtn.MouseButton1Click:Connect(function()
        self:close()
        self.sounds.click:Play()
    end)
    
    self.components.header = header
    self.components.minimizeBtn = minimizeBtn
    self.components.closeBtn = closeBtn
end

function UIController:createHeaderButton(parent, text, color, position)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 40, 0, 40)
    button.Position = position
    button.BackgroundColor3 = color
    button.Text = text
    button.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    button.Font = Enum.Font.GothamBold
    button.TextScaled = true
    button.BorderSizePixel = 0
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        self.sounds.hover:Play()
        Utils.createTween(button, TweenInfo.new(0.2), {BackgroundColor3 = color:lerp(CONFIG.COLORS.TEXT_PRIMARY, 0.2)})
    end)
    
    button.MouseLeave:Connect(function()
        Utils.createTween(button, TweenInfo.new(0.2), {BackgroundColor3 = color})
    end)
    
    return button
end

function UIController:createContentArea(parent)
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -30, 1, -100)
    contentFrame.Position = UDim2.new(0, 15, 0, 90)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 8
    contentFrame.ScrollBarImageColor3 = CONFIG.COLORS.ACCENT
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 900)
    contentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    contentFrame.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    contentFrame.Parent = parent
    
    -- Custom scrollbar styling
    contentFrame.ScrollBarImageTransparency = 0.3
    
    -- Create all sections
    self:createSpeedSection(contentFrame)
    self:createControlsSection(contentFrame)
    self:createPlayerSection(contentFrame)
    self:createAdvancedSection(contentFrame)
    self:createStatsSection(contentFrame)
    
    self.components.contentFrame = contentFrame
end

function UIController:createSpeedSection(parent)
    local section = self:createSection(parent, "⚡ Speed Control", 0, 280)
    
    -- Current speed display with real-time updates
    local speedDisplay = Instance.new("TextLabel")
    speedDisplay.Name = "SpeedDisplay"
    speedDisplay.Size = UDim2.new(1, -20, 0, 40)
    speedDisplay.Position = UDim2.new(0, 10, 0, 50)
    speedDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    speedDisplay.Text = "Current Speed: " .. self.currentSpeed
    speedDisplay.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    speedDisplay.Font = Enum.Font.GothamBold
    speedDisplay.TextScaled = true
    speedDisplay.BorderSizePixel = 0
    speedDisplay.Parent = section
    
    self:applyCorners(speedDisplay, 10)
    
    -- Advanced slider system
    self:createAdvancedSlider(section)
    
    -- Speed input with validation
    self:createSpeedInput(section)
    
    -- Preset buttons with categories
    self:createSpeedPresets(section)
    
    self.components.speedDisplay = speedDisplay
end

function UIController:createAdvancedSlider(parent)
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = "SliderContainer"
    sliderContainer.Size = UDim2.new(1, -20, 0, 80)
    sliderContainer.Position = UDim2.new(0, 10, 0, 100)
    sliderContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    sliderContainer.BorderSizePixel = 0
    sliderContainer.Parent = parent
    
    self:applyCorners(sliderContainer, 15)
    
    -- Slider labels
    local minLabel = self:createLabel(sliderContainer, tostring(CONFIG.SPEED.MIN), 
        UDim2.new(0, 10, 1, -25), UDim2.new(0, 30, 0, 20))
    local maxLabel = self:createLabel(sliderContainer, tostring(CONFIG.SPEED.MAX), 
        UDim2.new(1, -40, 1, -25), UDim2.new(0, 30, 0, 20))
    
    -- Slider track with gradient
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "SliderTrack"
    sliderTrack.Size = UDim2.new(1, -60, 0, 10)
    sliderTrack.Position = UDim2.new(0, 30, 0.5, -5)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderContainer
    
    self:applyCorners(sliderTrack, 5)
    
    -- Track gradient
    local trackGradient = Instance.new("UIGradient")
    trackGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 70, 80))
    }
    trackGradient.Parent = sliderTrack
    
    -- Slider fill with animation
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((self.currentSpeed - CONFIG.SPEED.MIN) / (CONFIG.SPEED.MAX - CONFIG.SPEED.MIN), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = CONFIG.COLORS.ACCENT
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    self:applyCorners(sliderFill, 5)
    
    -- Fill gradient
    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, CONFIG.COLORS.ACCENT),
        ColorSequenceKeypoint.new(1, CONFIG.COLORS.ACCENT:lerp(CONFIG.COLORS.TEXT_PRIMARY, 0.3))
    }
    fillGradient.Parent = sliderFill
    
    -- Enhanced slider handle
    local sliderHandle = Instance.new("TextButton")
    sliderHandle.Name = "SliderHandle"
    sliderHandle.Size = UDim2.new(0, 28, 0, 28)
    sliderHandle.Position = UDim2.new((self.currentSpeed - CONFIG.SPEED.MIN) / (CONFIG.SPEED.MAX - CONFIG.SPEED.MIN), -14, 0.5, -14)
    sliderHandle.BackgroundColor3 = CONFIG.COLORS.TEXT_PRIMARY
    sliderHandle.Text = ""
    sliderHandle.BorderSizePixel = 0
    sliderHandle.ZIndex = 2
    sliderHandle.Parent = sliderContainer
    
    self:applyCorners(sliderHandle, 14)
    
    -- Handle shadow
    local handleShadow = Instance.new("Frame")
    handleShadow.Size = UDim2.new(1, 4, 1, 4)
    handleShadow.Position = UDim2.new(0, -2, 0, -2)
    handleShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    handleShadow.BackgroundTransparency = 0.5
    handleShadow.ZIndex = 1
    handleShadow.Parent = sliderHandle
    
    self:applyCorners(handleShadow, 16)
    
    -- Store slider components
    self.components.sliderTrack = sliderTrack
    self.components.sliderFill = sliderFill
    self.components.sliderHandle = sliderHandle
    
    -- Setup slider interaction
    self:setupSliderInteraction()
end

function UIController:createSpeedInput(parent)
    local inputContainer = Instance.new("Frame")
    inputContainer.Name = "InputContainer"
    inputContainer.Size = UDim2.new(1, -20, 0, 50)
    inputContainer.Position = UDim2.new(0, 10, 0, 190)
    inputContainer.BackgroundTransparency = 1
    inputContainer.Parent = parent
    
    local inputLabel = self:createLabel(inputContainer, "Manual Input:", 
        UDim2.new(0, 0, 0, 0), UDim2.new(0.4, 0, 0, 25))
    
    local speedInput = Instance.new("TextBox")
    speedInput.Name = "SpeedInput"
    speedInput.Size = UDim2.new(0.55, 0, 1, 0)
    speedInput.Position = UDim2.new(0.43, 0, 0, 0)
    speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    speedInput.Text = tostring(self.currentSpeed)
    speedInput.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    speedInput.Font = Enum.Font.Gotham
    speedInput.TextScaled = true
    speedInput.PlaceholderText = "1-" .. CONFIG.SPEED.MAX
    speedInput.BorderSizePixel = 0
    speedInput.ClearTextOnFocus = false
    speedInput.Parent = inputContainer
    
    self:applyCorners(speedInput, 10)
    
    -- Input validation and formatting
    speedInput.FocusLost:Connect(function(enterPressed)
        local inputValue = Utils.validateNumber(speedInput.Text, CONFIG.SPEED.MIN, CONFIG.SPEED.MAX, self.currentSpeed)
        inputValue = Utils.formatNumber(inputValue, CONFIG.SPEED.PRECISION)
        self:setSpeed(inputValue)
        speedInput.Text = tostring(inputValue)
    end)
    
    -- Real-time input validation
    speedInput.Changed:Connect(function(property)
        if property == "Text" then
            local inputValue = Utils.validateNumber(speedInput.Text, CONFIG.SPEED.MIN, CONFIG.SPEED.MAX, nil)
            if inputValue and inputValue ~= self.currentSpeed then
                speedInput.TextColor3 = CONFIG.COLORS.WARNING
            else
                speedInput.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
            end
        end
    end)
    
    self.components.speedInput = speedInput
end

function UIController:createSpeedPresets(parent)
    local presetsContainer = Instance.new("Frame")
    presetsContainer.Name = "PresetsContainer"
    presetsContainer.Size = UDim2.new(1, -20, 0, 70)
    presetsContainer.Position = UDim2.new(0, 10, 0, 250)
    presetsContainer.BackgroundTransparency = 1
    presetsContainer.Parent = parent
    
    local presets = {
        {name = "Walk", speed = 16, color = CONFIG.COLORS.SUCCESS, icon = "🚶"},
        {name = "Jog", speed = 25, color = Color3.fromRGB(150, 200, 100), icon = "🏃"},
        {name = "Run", speed = 35, color = CONFIG.COLORS.WARNING, icon = "💨"},
        {name = "Sprint", speed = 50, color = CONFIG.COLORS.DANGER, icon = "⚡"},
        {name = "Flash", speed = 75, color = Color3.fromRGB(255, 100, 255), icon = "🌟"},
        {name = "Max", speed = 100, color = Color3.fromRGB(255, 50, 50), icon = "🚀"}
    }
    
    for i, preset in ipairs(presets) do
        local row = math.floor((i - 1) / 3)
        local col = (i - 1) % 3
        
        local btn = Instance.new("TextButton")
        btn.Name = preset.name .. "Button"
        btn.Size = UDim2.new(0.31, 0, 0, 30)
        btn.Position = UDim2.new(col * 0.34, 0, row * 35, 0)
        btn.BackgroundColor3 = preset.color
        btn.Text = preset.icon .. " " .. preset.name
        btn.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
        btn.Font = Enum.Font.GothamBold
        btn.TextScaled = true
        btn.BorderSizePixel = 0
        btn.Parent = presetsContainer
        
        self:applyCorners(btn, 8)
        
        -- Enhanced button effects
        self:setupButtonEffects(btn, preset.color)
        
        btn.MouseButton1Click:Connect(function()
            self:setSpeed(preset.speed)
            self:playButtonAnimation(btn)
            self.sounds.click:Play()
        end)
    end
end

function UIController:createControlsSection(parent)
    local section = self:createSection(parent, "🎮 Advanced Controls", 300, 180)
    
    -- Toggle buttons container
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = "ToggleContainer"
    toggleContainer.Size = UDim2.new(1, -20, 0, 120)
    toggleContainer.Position = UDim2.new(0, 10, 0, 50)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Parent = section
    
    local toggles = {
        {name = "Jump Power", property = "JumpPower", icon = "🦘", defaultValue = 50, maxValue = 200},
        {name = "Jump Height", property = "JumpHeight", icon = "📏", defaultValue = 7.2, maxValue = 50},
        {name = "Hip Height", property = "HipHeight", icon = "📐", defaultValue = 0, maxValue = 10}
    }
    
    for i, toggle in ipairs(toggles) do
        self:createToggleControl(toggleContainer, toggle, (i-1) * 40)
    end
end

function UIController:createToggleControl(parent, config, yPos)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 35)
    container.Position = UDim2.new(0, 0, 0, yPos)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local label = self:createLabel(container, config.icon .. " " .. config.name .. ":", 
        UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 1, 0))
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.45, 0, 0.8, 0)
    input.Position = UDim2.new(0.53, 0, 0.1, 0)
    input.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    input.Text = tostring(config.defaultValue)
    input.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    input.Font = Enum.Font.Gotham
    input.TextScaled = true
    input.BorderSizePixel = 0
    input.Parent = container
    
    self:applyCorners(input, 8)
    
    input.FocusLost:Connect(function()
        local value = Utils.validateNumber(input.Text, 0, config.maxValue, config.defaultValue)
        input.Text = tostring(value)
        self:applyCharacterProperty(config.property, value)
    end)
end

function UIController:createPlayerSection(parent)
    local section = self:createSection(parent, "👤 Player Information", 500, 200)
    
    -- Enhanced avatar display
    local avatarContainer = Instance.new("Frame")
    avatarContainer.Name = "AvatarContainer"
    avatarContainer.Size = UDim2.new(0, 140, 0, 140)
    avatarContainer.Position = UDim2.new(0.5, -70, 0, 50)
    avatarContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    avatarContainer.BorderSizePixel = 0
    avatarContainer.Parent = section
    
    self:applyCorners(avatarContainer, 20)
    
    -- Avatar border glow
    local avatarGlow = Instance.new("UIStroke")
    avatarGlow.Color = CONFIG.COLORS.ACCENT
    avatarGlow.Thickness = 3
    avatarGlow.Transparency = 0.5
    avatarGlow.Parent = avatarContainer
    
    -- Player image with error handling
    local playerImage = Instance.new("ImageLabel")
    playerImage.Name = "PlayerImage"
    playerImage.Size = UDim2.new(1, -10, 1, -10)
    playerImage.Position = UDim2.new(0, 5, 0, 5)
    playerImage.BackgroundTransparency = 1
    playerImage.BorderSizePixel = 0
    playerImage.Parent = avatarContainer
    
    self:applyCorners(playerImage, 15)
    
    -- Load avatar image safely
    local success, thumbnailUrl = pcall(function()
        return Players:GetUserThumbnailAsync(self.player.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size150x150)
    end)
    
    if success then
        playerImage.Image = thumbnailUrl
    else
        playerImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        playerImage.ImageColor3 = CONFIG.COLORS.ACCENT
    end
end

function UIController:createAdvancedSection(parent)
    local section = self:createSection(parent, "⚙️ Advanced Settings", 720, 120)
    
    -- Settings toggles
    local settingsContainer = Instance.new("Frame")
    settingsContainer.Name = "SettingsContainer"
    settingsContainer.Size = UDim2.new(1, -20, 0, 80)
    settingsContainer.Position = UDim2.new(0, 10, 0, 40)
    settingsContainer.BackgroundTransparency = 1
    settingsContainer.Parent = section
    
    local settings = {
        {name = "Auto-Save", key = "autoSave", default = true},
        {name = "Sound Effects", key = "soundEffects", default = true},
        {name = "Animations", key = "animations", default = true}
    }
    
    for i, setting in ipairs(settings) do
        self:createSettingToggle(settingsContainer, setting, (i-1) * 80, 0)
    end
end

function UIController:createStatsSection(parent)
    local section = self:createSection(parent, "📊 Performance Stats", 860, 150)
    
    -- Stats display
    local statsContainer = Instance.new("Frame")
    statsContainer.Name = "StatsContainer"
    statsContainer.Size = UDim2.new(1, -20, 0, 100)
    statsContainer.Position = UDim2.new(0, 10, 0, 40)
    statsContainer.BackgroundTransparency = 1
    statsContainer.Parent = section
    
    -- FPS Counter
    local fpsLabel = self:createStatLabel(statsContainer, "FPS: 60", UDim2.new(0, 0, 0, 0))
    
    -- Memory Usage
    local memoryLabel = self:createStatLabel(statsContainer, "Memory: 0 MB", UDim2.new(0, 0, 0, 25))
    
    -- Ping
    local pingLabel = self:createStatLabel(statsContainer, "Ping: 0 ms", UDim2.new(0, 0, 0, 50))
    
    -- Speed Changes Counter
    local changesLabel = self:createStatLabel(statsContainer, "Speed Changes: 0", UDim2.new(0, 0, 0, 75))
    
    self.components.statsLabels = {
        fps = fpsLabel,
        memory = memoryLabel,
        ping = pingLabel,
        changes = changesLabel
    }
    
    self.speedChanges = 0
end

function UIController:createStatLabel(parent, text, position)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = CONFIG.COLORS.TEXT_SECONDARY
    label.Font = Enum.Font.Gotham
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

function UIController:createSettingToggle(parent, config, xPos, yPos)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 70, 0, 70)
    container.Position = UDim2.new(0, xPos, 0, yPos)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, 0, 0, 40)
    toggle.Position = UDim2.new(0, 0, 0, 0)
    toggle.BackgroundColor3 = config.default and CONFIG.COLORS.SUCCESS or CONFIG.COLORS.DISABLED
    toggle.Text = config.default and "ON" or "OFF"
    toggle.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    toggle.Font = Enum.Font.GothamBold
    toggle.TextScaled = true
    toggle.BorderSizePixel = 0
    toggle.Parent = container
    
    self:applyCorners(toggle, 20)
    
    local label = self:createLabel(container, config.name, 
        UDim2.new(0, 0, 0, 45), UDim2.new(1, 0, 0, 20))
    label.TextScaled = true
    
    -- Toggle functionality
    local isEnabled = config.default
    toggle.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        toggle.BackgroundColor3 = isEnabled and CONFIG.COLORS.SUCCESS or CONFIG.COLORS.DISABLED
        toggle.Text = isEnabled and "ON" or "OFF"
        self:applySetting(config.key, isEnabled)
        self.sounds.click:Play()
    end)
    
    return toggle
end

-- Helper Functions
function UIController:createSection(parent, title, yPos, height)
    local section = Instance.new("Frame")
    section.Name = title:gsub("[^%w]", "")
    section.Size = UDim2.new(1, 0, 0, height or 120)
    section.Position = UDim2.new(0, 0, 0, yPos)
    section.BackgroundColor3 = CONFIG.COLORS.SECONDARY
    section.BorderSizePixel = 0
    section.Parent = parent
    
    self:applyCorners(section, 15)
    
    -- Section border
    local sectionStroke = Instance.new("UIStroke")
    sectionStroke.Color = Color3.fromRGB(60, 60, 80)
    sectionStroke.Thickness = 1
    sectionStroke.Transparency = 0.6
    sectionStroke.Parent = section
    
    -- Section title with background
    local titleBg = Instance.new("Frame")
    titleBg.Size = UDim2.new(1, 0, 0, 40)
    titleBg.Position = UDim2.new(0, 0, 0, 0)
    titleBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    titleBg.BorderSizePixel = 0
    titleBg.Parent = section
    
    self:applyCorners(titleBg, 15)
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "SectionTitle"
    sectionTitle.Size = UDim2.new(1, -20, 1, 0)
    sectionTitle.Position = UDim2.new(0, 10, 0, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = title
    sectionTitle.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextScaled = true
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Parent = titleBg
    
    return section
end

function UIController:createLabel(parent, text, position, size)
    local label = Instance.new("TextLabel")
    label.Size = size or UDim2.new(1, 0, 0, 25)
    label.Position = position or UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = CONFIG.COLORS.TEXT_SECONDARY
    label.Font = Enum.Font.Gotham
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

function UIController:applyCorners(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = instance
    return corner
end

-- Core Functionality
function UIController:setupSliderInteraction()
    local dragging = false
    local dragConnection
    
    self.components.sliderHandle.MouseButton1Down:Connect(function()
        dragging = true
        self.sounds.slide:Play()
        
        dragConnection = UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mouse = self.player:GetMouse()
                local trackPos = self.components.sliderTrack.AbsolutePosition.X
                local trackSize = self.components.sliderTrack.AbsoluteSize.X
                local relativePos = math.clamp((mouse.X - trackPos) / trackSize, 0, 1)
                
                local speed = CONFIG.SPEED.MIN + (relativePos * (CONFIG.SPEED.MAX - CONFIG.SPEED.MIN))
                speed = Utils.formatNumber(speed, CONFIG.SPEED.PRECISION)
                
                self:setSpeed(speed)
            end
        end)
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            if dragConnection then
                dragConnection:Disconnect()
                dragConnection = nil
            end
        end
    end)
end

function UIController:setSpeed(speed)
    if speed == self.currentSpeed then return end
    
    self.previousSpeed = self.currentSpeed
    self.currentSpeed = speed
    self.speedChanges = self.speedChanges + 1
    
    -- Update UI elements
    self:updateSpeedDisplay()
    self:updateSliderPosition()
    self:applySpeedToCharacter()
    
    -- Visual feedback
    self:playSpeedChangeAnimation()
    
    -- Save setting if auto-save is enabled
    if self.settings and self.settings.autoSave then
        self:saveSettings()
    end
end

function UIController:updateSpeedDisplay()
    if self.components.speedDisplay then
        self.components.speedDisplay.Text = "Current Speed: " .. self.currentSpeed
    end
    
    if self.components.speedInput then
        self.components.speedInput.Text = tostring(self.currentSpeed)
    end
end

function UIController:updateSliderPosition()
    if not self.components.sliderHandle or not self.components.sliderFill then return end
    
    local relativePos = (self.currentSpeed - CONFIG.SPEED.MIN) / (CONFIG.SPEED.MAX - CONFIG.SPEED.MIN)
    
    -- Smooth animation
    Utils.createTween(self.components.sliderHandle, 
        TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = UDim2.new(relativePos, -14, 0.5, -14)}
    )
    
    Utils.createTween(self.components.sliderFill,
        TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = UDim2.new(relativePos, 0, 1, 0)}
    )
end

function UIController:applySpeedToCharacter()
    if self.player.Character and self.player.Character:FindFirstChild("Humanoid") then
        self.player.Character.Humanoid.WalkSpeed = self.currentSpeed
    end
end

function UIController:applyCharacterProperty(property, value)
    if self.player.Character and self.player.Character:FindFirstChild("Humanoid") then
        local humanoid = self.player.Character.Humanoid
        if humanoid[property] then
            humanoid[property] = value
        end
    end
end

-- Event Handlers
function UIController:setupEventHandlers()
    -- Character spawning
    self.connections[#self.connections + 1] = self.player.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid")
        self:applySpeedToCharacter()
    end)
    
    -- GUI resize handling
    self.connections[#self.connections + 1] = GuiService:GetPropertyChangedSignal("ScreenOrientation"):Connect(function()
        self:handleScreenResize()
    end)
    
    -- Input handling for hotkeys
    self.connections[#self.connections + 1] = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F1 then
            self:toggleVisibility()
        elseif input.KeyCode == Enum.KeyCode.F2 then
            self:toggleMinimize()
        end
    end)
end

function UIController:setupCharacterConnection()
    -- Apply to current character
    if self.player.Character then
        self:applySpeedToCharacter()
    end
end

function UIController:startUpdateLoop()
    self.connections[#self.connections + 1] = RunService.Heartbeat:Connect(function()
        self:updateStats()
    end)
end

function UIController:updateStats()
    if not self.components.statsLabels then return end
    
    -- FPS calculation
    local fps = math.floor(1 / RunService.Heartbeat:Wait())
    self.components.statsLabels.fps.Text = "FPS: " .. fps
    
    -- Memory usage
    local memory = math.floor(gcinfo() / 1024 * 100) / 100
    self.components.statsLabels.memory.Text = "Memory: " .. memory .. " MB"
    
    -- Ping (approximation)
    local ping = self.player:GetNetworkPing() * 1000
    self.components.statsLabels.ping.Text = "Ping: " .. math.floor(ping) .. " ms"
    
    -- Speed changes
    self.components.statsLabels.changes.Text = "Speed Changes: " .. self.speedChanges
end

-- UI Controls
function UIController:toggleVisibility()
    self.isVisible = not self.isVisible
    
    local targetPos = self.isVisible and 
        UDim2.new(0, 50, 0.5, -CONFIG.UI.SIZE.Y/2) or
        UDim2.new(0, -CONFIG.UI.SIZE.X - 50, 0.5, -CONFIG.UI.SIZE.Y/2)
    
    Utils.createTween(self.mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = targetPos}
    )
end

function UIController:toggleMinimize()
    self.isMinimized = not self.isMinimized
    
    local targetSize = self.isMinimized and 
        UDim2.new(0, CONFIG.UI.SIZE.X, 0, 80) or
        UDim2.new(0, CONFIG.UI.SIZE.X, 0, CONFIG.UI.SIZE.Y)
    
    Utils.createTween(self.mainFrame,
        TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = targetSize}
    )
    
    if self.components.contentFrame then
        self.components.contentFrame.Visible = not self.isMinimized
    end
    
    self.components.minimizeBtn.Text = self.isMinimized and "+" or "−"
end

function UIController:close()
    -- Save settings before closing
    self:saveSettings()
    
    -- Play exit animation
    Utils.createTween(self.mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {
            Position = UDim2.new(0, -CONFIG.UI.SIZE.X - 50, 0.5, -CONFIG.UI.SIZE.Y/2),
            Rotation = -10,
            Size = UDim2.new(0, CONFIG.UI.SIZE.X * 0.8, 0, CONFIG.UI.SIZE.Y * 0.8)
        },
        function()
            self:cleanup()
        end
    )
end

-- Visual Effects
function UIController:setupButtonEffects(button, originalColor)
    button.MouseEnter:Connect(function()
        self.sounds.hover:Play()
        Utils.createTween(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor:lerp(CONFIG.COLORS.TEXT_PRIMARY, 0.2),
            Size = button.Size + UDim2.new(0, 2, 0, 2)
        })
    end)
    
    button.MouseLeave:Connect(function()
        Utils.createTween(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor,
            Size = button.Size - UDim2.new(0, 2, 0, 2)
        })
    end)
end

function UIController:playButtonAnimation(button)
    local originalSize = button.Size
    
    Utils.createTween(button, TweenInfo.new(0.1), {Size = originalSize * 0.9}, function()
        Utils.createTween(button, TweenInfo.new(0.1), {Size = originalSize})
    end)
end

function UIController:playSpeedChangeAnimation()
    if self.components.speedDisplay then
        Utils.createTween(self.components.speedDisplay, TweenInfo.new(0.2), 
            {BackgroundColor3 = CONFIG.COLORS.ACCENT}, function()
            Utils.createTween(self.components.speedDisplay, TweenInfo.new(0.3), 
                {BackgroundColor3 = Color3.fromRGB(40, 40, 50)})
        end)
    end
end

function UIController:playEntranceAnimation()
    self.mainFrame.Position = UDim2.new(0, -CONFIG.UI.SIZE.X - 50, 0.5, -CONFIG.UI.SIZE.Y/2)
    self.mainFrame.Rotation = -15
    self.mainFrame.Size = UDim2.new(0, CONFIG.UI.SIZE.X * 1.2, 0, CONFIG.UI.SIZE.Y * 1.2)
    
    Utils.createTween(self.mainFrame,
        TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Position = UDim2.new(0, 50, 0.5, -CONFIG.UI.SIZE.Y/2),
            Rotation = 0,
            Size = UDim2.new(0, CONFIG.UI.SIZE.X, 0, CONFIG.UI.SIZE.Y)
        }
    )
end

-- Settings Management
function UIController:saveSettings()
    -- In a real implementation, you would save to DataStore
    -- For now, we'll use a simple table
    self.savedSettings = {
        speed = self.currentSpeed,
        position = self.mainFrame.Position,
        isMinimized = self.isMinimized
    }
end

function UIController:loadSettings()
    -- Load from saved settings
    if self.savedSettings then
        self:setSpeed(self.savedSettings.speed or CONFIG.SPEED.DEFAULT)
        if self.savedSettings.position then
            self.mainFrame.Position = self.savedSettings.position
        end
        if self.savedSettings.isMinimized then
            self:toggleMinimize()
        end
    end
end

function UIController:applySetting(key, value)
    self.settings = self.settings or {}
    self.settings[key] = value
    
    -- Apply setting effects
    if key == "soundEffects" then
        for _, sound in pairs(self.sounds) do
            sound.Volume = value and sound.Volume or 0
        end
    end
end

-- Advanced Features
function UIController:setupDragging()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    if not self.components.header then return end
    
    self.components.header.MouseButton1Down:Connect(function(input)
        dragging = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        startPos = self.mainFrame.Position
    end)
    
    self.connections[#self.connections + 1] = UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
            self.mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    self.connections[#self.connections + 1] = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function UIController:setupResizing()
    -- Placeholder for resizing functionality
    -- Could be implemented with corner drag handles
end

function UIController:handleScreenResize()
    -- Adjust UI position and size based on screen size
    local screenSize = self.playerGui.AbsoluteSize
    
    -- Keep UI within screen bounds
    local currentPos = self.mainFrame.Position
    local maxX = screenSize.X - CONFIG.UI.SIZE.X
    local maxY = screenSize.Y - CONFIG.UI.SIZE.Y
    
    if currentPos.X.Offset > maxX then
        self.mainFrame.Position = UDim2.new(0, maxX, currentPos.Y.Scale, currentPos.Y.Offset)
    end
    
    if currentPos.Y.Offset > maxY then
        self.mainFrame.Position = UDim2.new(currentPos.X.Scale, currentPos.X.Offset, 0, maxY)
    end
end

-- Cleanup
function UIController:cleanup()
    -- Disconnect all connections
    for _, connection in ipairs(self.connections) do
        if connection then
            connection:Disconnect()
        end
    end
    self.connections = {}
    
    -- Stop all tweens
    for _, tween in ipairs(self.tweens) do
        if tween then
            tween:Cancel()
        end
    end
    self.tweens = {}
    
    -- Clean up sounds
    for _, sound in pairs(self.sounds) do
        Utils.safeDestroy(sound)
    end
    
    -- Destroy UI
    Utils.safeDestroy(self.screenGui)
end

-- Initialize the UI Controller
local controller = UIController.new()

-- Global access for external scripts
_G.CharacterControllerPro = controller

-- Export useful functions
_G.SetCharacterSpeed = function(speed)
    if controller then
        controller:setSpeed(speed)
    end
end

_G.ToggleCharacterUI = function()
    if controller then
        controller:toggleVisibility()
    end
end

-- Success message
print("✅ Character Controller Pro v2.0 loaded successfully!")
print("🎮 Press F1 to toggle visibility, F2 to minimize")
print("⚡ Enjoy enhanced character control!")
