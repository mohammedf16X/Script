-- NatHub Style Character Controller - Professional Edition
-- Advanced Roblox UI matching NatHub design with professional icons

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")

-- ═══════════════════════════════════════════════════════════════
-- CONFIGURATION SYSTEM
-- ═══════════════════════════════════════════════════════════════

local CONFIG = {
    UI = {
        MAIN_SIZE = Vector2.new(700, 450),
        SIDEBAR_WIDTH = 200,
        CORNER_RADIUS = 15,
        ANIMATION_SPEED = 0.5,
        SHADOW_SIZE = 12,
        TOGGLE_SIZE = 60
    },
    
    COLORS = {
        -- Main colors matching NatHub
        BACKGROUND = Color3.fromRGB(32, 34, 37),
        SIDEBAR = Color3.fromRGB(47, 49, 54),
        ACCENT = Color3.fromRGB(114, 137, 218),
        ACCENT_HOVER = Color3.fromRGB(129, 151, 230),
        
        -- Status colors
        SUCCESS = Color3.fromRGB(67, 181, 129),
        WARNING = Color3.fromRGB(250, 166, 26),
        DANGER = Color3.fromRGB(240, 71, 71),
        INFO = Color3.fromRGB(52, 152, 219),
        
        -- Text colors
        TEXT_PRIMARY = Color3.fromRGB(220, 221, 222),
        TEXT_SECONDARY = Color3.fromRGB(185, 187, 190),
        TEXT_MUTED = Color3.fromRGB(114, 118, 125),
        
        -- UI colors
        BORDER = Color3.fromRGB(64, 68, 75),
        HOVER = Color3.fromRGB(54, 57, 63),
        SELECTED = Color3.fromRGB(64, 68, 75),
        
        -- Gradient colors
        GRADIENT_START = Color3.fromRGB(88, 101, 242),
        GRADIENT_END = Color3.fromRGB(139, 69, 255)
    },
    
    SOUNDS = {
        ENABLED = true,
        CLICK = "rbxasset://sounds/electronicpingshort.wav",
        HOVER = "rbxasset://sounds/switch.wav",
        SLIDE = "rbxasset://sounds/impact_generic.mp3",
        OPEN = "rbxasset://sounds/bamf.mp3",
        CLOSE = "rbxasset://sounds/whoosh.wav",
        SUCCESS = "rbxasset://sounds/victory.wav"
    },
    
    SPEED = {
        MIN = 1,
        MAX = 100,
        DEFAULT = 16,
        PRECISION = 1
    },
    
    -- Professional SVG-style icons (using ImageLabel with custom images)
    ICONS = {
        SPEED = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        JUMP = "rbxasset://textures/ui/GuiImagePlaceholder.png", 
        SETTINGS = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        INFO = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        CLOSE = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        MENU = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        SOUND_ON = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        SOUND_OFF = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    }
}

-- ═══════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

local Utils = {}

function Utils.createSound(soundId, volume, pitch)
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = volume or 0.4
    sound.Pitch = pitch or 1
    sound.Parent = SoundService
    return sound
end

function Utils.createTween(instance, tweenInfo, properties, callback)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    if callback then
        tween.Completed:Once(callback)
    end
    tween:Play()
    return tween
end

function Utils.applyCorners(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or CONFIG.UI.CORNER_RADIUS)
    corner.Parent = instance
    return corner
end

function Utils.createGradient(instance, colorSequence, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colorSequence
    gradient.Rotation = rotation or 0
    gradient.Parent = instance
    return gradient
end

function Utils.createShadow(instance, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "DropShadow"
    shadow.Size = UDim2.new(1, size * 2, 1, size * 2)
    shadow.Position = UDim2.new(0, -size, 0, -size)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.7
    shadow.ZIndex = instance.ZIndex - 1
    shadow.Parent = instance.Parent
    
    Utils.applyCorners(shadow, CONFIG.UI.CORNER_RADIUS + 3)
    return shadow
end

function Utils.createIcon(parent, iconType, size, position, color)
    local iconFrame = Instance.new("Frame")
    iconFrame.Name = iconType .. "Icon"
    iconFrame.Size = size
    iconFrame.Position = position
    iconFrame.BackgroundTransparency = 1
    iconFrame.Parent = parent
    
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0.8, 0, 0.8, 0)
    icon.Position = UDim2.new(0.1, 0, 0.1, 0)
    icon.BackgroundTransparency = 1
    icon.Image = CONFIG.ICONS[iconType:upper()] or CONFIG.ICONS.MENU
    icon.ImageColor3 = color or CONFIG.COLORS.TEXT_SECONDARY
    icon.ScaleType = Enum.ScaleType.Fit
    icon.Parent = iconFrame
    
    return iconFrame, icon
end

function Utils.addDivider(parent, position)
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(1, -40, 0, 1)
    divider.Position = position
    divider.BackgroundColor3 = CONFIG.COLORS.BORDER
    divider.BorderSizePixel = 0
    divider.Parent = parent
    
    return divider
end

function Utils.formatNumber(number, decimals)
    local multiplier = 10 ^ (decimals or 0)
    return math.floor(number * multiplier) / multiplier
end

function Utils.validateNumber(value, min, max, default)
    local num = tonumber(value)
    if not num then return default end
    return math.clamp(num, min or -math.huge, max or math.huge)
end

-- ═══════════════════════════════════════════════════════════════
-- MAIN CONTROLLER CLASS
-- ═══════════════════════════════════════════════════════════════

local NatHubController = {}
NatHubController.__index = NatHubController

function NatHubController.new()
    local self = setmetatable({}, NatHubController)
    
    -- Core Properties
    self.player = Players.LocalPlayer
    self.playerGui = self.player:WaitForChild("PlayerGui")
    self.currentSpeed = CONFIG.SPEED.DEFAULT
    self.currentJumpPower = 50
    self.currentJumpHeight = 7.2
    self.isVisible = false
    self.currentPage = "Speed"
    self.isDragging = false
    
    -- Component Storage
    self.components = {}
    self.connections = {}
    self.tweens = {}
    self.pages = {}
    
    -- Settings System
    self.settings = {
        soundEnabled = true,
        autoApply = true,
        saveSettings = true,
        animations = true,
        theme = "dark"
    }
    
    -- Sound System
    self.sounds = {}
    self:initSounds()
    
    -- Performance Statistics
    self.stats = {
        frameCount = 0,
        lastFPSUpdate = tick(),
        speedChanges = 0,
        sessionStart = tick(),
        currentFPS = 60,
        ping = 0,
        memory = 0
    }
    
    -- Initialize UI
    self:initialize()
    
    return self
end

function NatHubController:initialize()
    -- Clean existing UI
    local existing = self.playerGui:FindFirstChild("NatHubCharacterUI")
    if existing then existing:Destroy() end
    
    -- Create main components
    self:createMainUI()
    self:createToggleButton()
    self:setupEventHandlers()
    self:setupCharacterHandling()
    self:startUpdateLoop()
    
    -- Load saved settings
    self:loadSettings()
    
    print("🚀 NatHub Character Controller v3.0 Loaded!")
    print("📋 Press the toggle button to open the interface")
end

function NatHubController:initSounds()
    if CONFIG.SOUNDS.ENABLED then
        for name, soundId in pairs(CONFIG.SOUNDS) do
            if name ~= "ENABLED" then
                self.sounds[name:lower()] = Utils.createSound(soundId, 0.3)
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════
-- UI CREATION METHODS
-- ═══════════════════════════════════════════════════════════════

function NatHubController:createMainUI()
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NatHubCharacterUI"
    screenGui.Parent = self.playerGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = false
    screenGui.DisplayOrder = 999
    
    -- Main Container Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame" 
    mainFrame.Size = UDim2.new(0, CONFIG.UI.MAIN_SIZE.X, 0, CONFIG.UI.MAIN_SIZE.Y)
    mainFrame.Position = UDim2.new(0.5, -CONFIG.UI.MAIN_SIZE.X/2, -1, -50) -- Start off-screen
    mainFrame.BackgroundColor3 = CONFIG.COLORS.BACKGROUND
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = false -- We'll handle dragging manually
    mainFrame.Parent = screenGui
    
    Utils.applyCorners(mainFrame, CONFIG.UI.CORNER_RADIUS)
    Utils.createShadow(mainFrame, CONFIG.UI.SHADOW_SIZE, 0.5)
    
    -- Animated border effect
    local borderStroke = Instance.new("UIStroke")
    borderStroke.Color = CONFIG.COLORS.GRADIENT_START
    borderStroke.Thickness = 2
    borderStroke.Transparency = 0.2
    borderStroke.Parent = mainFrame
    
    -- Border animation
    local borderTween = TweenService:Create(borderStroke,
        TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Color = CONFIG.COLORS.GRADIENT_END}
    )
    borderTween:Play()
    table.insert(self.tweens, borderTween)
    
    -- Background gradient
    Utils.createGradient(mainFrame, ColorSequence.new({
        ColorSequenceKeypoint.new(0, CONFIG.COLORS.BACKGROUND),
        ColorSequenceKeypoint.new(1, CONFIG.COLORS.BACKGROUND:lerp(Color3.new(0, 0, 0), 0.3))
    }), 135)
    
    -- Create UI sections
    self:createTopBar(mainFrame)
    self:createSidebar(mainFrame)
    self:createContentArea(mainFrame)
    
    -- Store main references
    self.components.screenGui = screenGui
    self.components.mainFrame = mainFrame
    
    -- Setup dragging system
    self:makeDraggable(mainFrame)
end

function NatHubController:createToggleButton()
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, CONFIG.UI.TOGGLE_SIZE, 0, CONFIG.UI.TOGGLE_SIZE)
    toggleButton.Position = UDim2.new(0, 30, 0, 120)
    toggleButton.BackgroundColor3 = CONFIG.COLORS.ACCENT
    toggleButton.Text = ""
    toggleButton.BorderSizePixel = 0
    toggleButton.ZIndex = 1000
    toggleButton.Parent = self.components.screenGui
    
    Utils.applyCorners(toggleButton, CONFIG.UI.TOGGLE_SIZE/2)
    Utils.createShadow(toggleButton, 6, 0.6)
    
    -- Toggle button gradient
    Utils.createGradient(toggleButton, ColorSequence.new({
        ColorSequenceKeypoint.new(0, CONFIG.COLORS.GRADIENT_START),
        ColorSequenceKeypoint.new(1, CONFIG.COLORS.GRADIENT_END)
    }), 45)
    
    -- Add icon to toggle button
    local iconFrame, icon = Utils.createIcon(toggleButton, "MENU", 
        UDim2.new(0.6, 0, 0.6, 0), UDim2.new(0.2, 0, 0.2, 0), CONFIG.COLORS.TEXT_PRIMARY)
    
    -- Pulsing animation
    local pulseInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local pulseTween = TweenService:Create(toggleButton, pulseInfo, {
        Size = UDim2.new(0, CONFIG.UI.TOGGLE_SIZE + 8, 0, CONFIG.UI.TOGGLE_SIZE + 8)
    })
    pulseTween:Play()
    table.insert(self.tweens, pulseTween)
    
    -- Event handlers
    toggleButton.MouseButton1Click:Connect(function()
        self:toggleUI()
        self:playSound("click")
    end)
    
    toggleButton.MouseEnter:Connect(function()
        self:playSound("hover")
        Utils.createTween(toggleButton, TweenInfo.new(0.2), {
            Size = UDim2.new(0, CONFIG.UI.TOGGLE_SIZE + 10, 0, CONFIG.UI.TOGGLE_SIZE + 10)
        })
    end)
    
    toggleButton.MouseLeave:Connect(function()
        Utils.createTween(toggleButton, TweenInfo.new(0.2), {
            Size = UDim2.new(0, CONFIG.UI.TOGGLE_SIZE, 0, CONFIG.UI.TOGGLE_SIZE)
        })
    end)
    
    self.components.toggleButton = toggleButton
end

function NatHubController:createTopBar(parent)
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 60)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = CONFIG.COLORS.SIDEBAR
    topBar.BorderSizePixel = 0
    topBar.Parent = parent
    
    Utils.applyCorners(topBar, CONFIG.UI.CORNER_RADIUS)
    
    -- Top bar gradient
    Utils.createGradient(topBar, ColorSequence.new({
        ColorSequenceKeypoint.new(0, CONFIG.COLORS.SIDEBAR),
        ColorSequenceKeypoint.new(1, CONFIG.COLORS.SIDEBAR:lerp(CONFIG.COLORS.ACCENT, 0.1))
    }), 90)
    
    -- Main title with icon
    local titleIcon, titleIconImage = Utils.createIcon(topBar, "SPEED", 
        UDim2.new(0, 40, 0, 40), UDim2.new(0, 15, 0, 10), CONFIG.COLORS.ACCENT)
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0, 350, 0, 40)
    title.Position = UDim2.new(0, 65, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "NatHub Character Controller"
    title.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar
    
    -- Version badge
    local versionBadge = Instance.new("Frame")
    versionBadge.Name = "VersionBadge"
    versionBadge.Size = UDim2.new(0, 50, 0, 25)
    versionBadge.Position = UDim2.new(0, 420, 0, 17.5)
    versionBadge.BackgroundColor3 = CONFIG.COLORS.SUCCESS
    versionBadge.BorderSizePixel = 0
    versionBadge.Parent = topBar
    
    Utils.applyCorners(versionBadge, 12)
    
    local versionText = Instance.new("TextLabel")
    versionText.Size = UDim2.new(1, 0, 1, 0)
    versionText.BackgroundTransparency = 1
    versionText.Text = "v3.0"
    versionText.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    versionText.TextSize = 12
    versionText.Font = Enum.Font.GothamBold
    versionText.Parent = versionBadge
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -50, 0, 10)
    closeBtn.BackgroundColor3 = CONFIG.COLORS.DANGER
    closeBtn.Text = ""
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = topBar
    
    Utils.applyCorners(closeBtn, 10)
    
    -- Close icon
    local closeIcon, closeIconImage = Utils.createIcon(closeBtn, "CLOSE",
        UDim2.new(0.6, 0, 0.6, 0), UDim2.new(0.2, 0, 0.2, 0), CONFIG.COLORS.TEXT_PRIMARY)
    
    -- Close button events
    closeBtn.MouseButton1Click:Connect(function()
        self:hideUI()
        self:playSound("close")
    end)
    
    closeBtn.MouseEnter:Connect(function()
        Utils.createTween(closeBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = CONFIG.COLORS.DANGER:lerp(Color3.new(1, 1, 1), 0.2)
        })
    end)
    
    closeBtn.MouseLeave:Connect(function()
        Utils.createTween(closeBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = CONFIG.COLORS.DANGER
        })
    end)
    
    self.components.topBar = topBar
    self.components.closeBtn = closeBtn
    self.components.title = title
end

function NatHubController:createSidebar(parent)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, CONFIG.UI.SIDEBAR_WIDTH, 1, -60)
    sidebar.Position = UDim2.new(0, 0, 0, 60)
    sidebar.BackgroundColor3 = CONFIG.COLORS.SIDEBAR
    sidebar.BorderSizePixel = 0
    sidebar.Parent = parent
    
    Utils.applyCorners(sidebar, CONFIG.UI.CORNER_RADIUS)
    
    -- Sidebar gradient
    Utils.createGradient(sidebar, ColorSequence.new({
        ColorSequenceKeypoint.new(0, CONFIG.COLORS.SIDEBAR),
        ColorSequenceKeypoint.new(1, CONFIG.COLORS.SIDEBAR:lerp(Color3.new(0, 0, 0), 0.4))
    }), 180)
    
    -- Menu items configuration
    local menuItems = {
        {name = "Speed Control", icon = "SPEED", page = "Speed"},
        {name = "Jump Settings", icon = "JUMP", page = "Jump"}, 
        {name = "Information", icon = "INFO", page = "Info"},
        {name = "Settings", icon = "SETTINGS", page = "Settings"}
    }
    
    -- Create menu items
    for i, item in ipairs(menuItems) do
        self:createMenuItem(sidebar, item, i)
        
        -- Add divider between items (except last)
        if i < #menuItems then
            Utils.addDivider(sidebar, UDim2.new(0, 20, 0, 15 + i * 70))
        end
    end
    
    self.components.sidebar = sidebar
end

function NatHubController:createMenuItem(parent, item, index) 
    local menuItem = Instance.new("TextButton")
    menuItem.Name = item.page .. "Button"
    menuItem.Size = UDim2.new(1, -20, 0, 55)
    menuItem.Position = UDim2.new(0, 10, 0, 15 + (index - 1) * 70)
    menuItem.BackgroundColor3 = self.currentPage == item.page and CONFIG.COLORS.SELECTED or Color3.fromRGB(0, 0, 0, 0)
    menuItem.BackgroundTransparency = self.currentPage == item.page and 0 or 1
    menuItem.Text = ""
    menuItem.BorderSizePixel = 0
    menuItem.Parent = parent
    
    Utils.applyCorners(menuItem, 12)
    
    -- Selection indicator
    local indicator = Instance.new("Frame")
    indicator.Name = "SelectionIndicator"
    indicator.Size = UDim2.new(0, 4, 0.8, 0)
    indicator.Position = UDim2.new(0, 0, 0.1, 0)
    indicator.BackgroundColor3 = CONFIG.COLORS.ACCENT
    indicator.BorderSizePixel = 0
    indicator.Visible = self.currentPage == item.page
    indicator.Parent = menuItem
    
    Utils.applyCorners(indicator, 2)
    
    -- Menu item icon
    local iconFrame, iconImage = Utils.createIcon(menuItem, item.icon,
        UDim2.new(0, 35, 0, 35), UDim2.new(0, 15, 0, 10),
        self.currentPage == item.page and CONFIG.COLORS.ACCENT or CONFIG.COLORS.TEXT_SECONDARY)
    
    -- Menu item text
    local text = Instance.new("TextLabel")
    text.Name = "MenuText"
    text.Size = UDim2.new(1, -65, 1, 0)
    text.Position = UDim2.new(0, 60, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = item.name
    text.TextColor3 = self.currentPage == item.page and CONFIG.COLORS.TEXT_PRIMARY or CONFIG.COLORS.TEXT_SECONDARY
    text.TextSize = 16
    text.Font = Enum.Font.Gotham
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = menuItem
    
    -- Click handler
    menuItem.MouseButton1Click:Connect(function()
        self:switchPage(item.page)
        self:playSound("click")
    end)
    
    -- Hover effects
    menuItem.MouseEnter:Connect(function()
        if self.currentPage ~= item.page then
            self:playSound("hover")
            Utils.createTween(menuItem, TweenInfo.new(0.3), {BackgroundTransparency = 0.7})
            Utils.createTween(iconImage, TweenInfo.new(0.3), {ImageColor3 = CONFIG.COLORS.TEXT_PRIMARY})
            Utils.createTween(text, TweenInfo.new(0.3), {TextColor3 = CONFIG.COLORS.TEXT_PRIMARY})
        end
    end)
    
    menuItem.MouseLeave:Connect(function()
        if self.currentPage ~= item.page then
            Utils.createTween(menuItem, TweenInfo.new(0.3), {BackgroundTransparency = 1})
            Utils.createTween(iconImage, TweenInfo.new(0.3), {ImageColor3 = CONFIG.COLORS.TEXT_SECONDARY})
            Utils.createTween(text, TweenInfo.new(0.3), {TextColor3 = CONFIG.COLORS.TEXT_SECONDARY})
        end
    end)
    
    -- Store references
    self.components[item.page .. "MenuItem"] = menuItem
    self.components[item.page .. "Icon"] = iconImage
    self.components[item.page .. "Text"] = text  
    self.components[item.page .. "Indicator"] = indicator
end

function NatHubController:createContentArea(parent)
    local contentArea = Instance.new("ScrollingFrame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -CONFIG.UI.SIDEBAR_WIDTH - 30, 1, -80)
    contentArea.Position = UDim2.new(0, CONFIG.UI.SIDEBAR_WIDTH + 15, 0, 70)
    contentArea.BackgroundTransparency = 1
    contentArea.BorderSizePixel = 0
    contentArea.ScrollBarThickness = 8
    contentArea.ScrollBarImageColor3 = CONFIG.COLORS.ACCENT
    contentArea.ScrollBarImageTransparency = 0.3
    contentArea.CanvasSize = UDim2.new(0, 0, 0, 800)
    contentArea.ScrollingDirection = Enum.ScrollingDirection.Y
    contentArea.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    contentArea.Parent = parent
    
    -- Create all page content
    self:createSpeedPage(contentArea)
    self:createJumpPage(contentArea)  
    self:createInfoPage(contentArea)
    self:createSettingsPage(contentArea)
    
    self.components.contentArea = contentArea
end

-- ═══════════════════════════════════════════════════════════════
-- PAGE CREATION METHODS
-- ═══════════════════════════════════════════════════════════════

function NatHubController:createSpeedPage(parent)
    local speedPage = Instance.new("Frame")
    speedPage.Name = "SpeedPage"
    speedPage.Size = UDim2.new(1, 0, 0, 800)
    speedPage.Position = UDim2.new(0, 0, 0, 0)
    speedPage.BackgroundTransparency = 1
    speedPage.Visible = true
    speedPage.Parent = parent
    
    -- Current Speed Display Card
    local speedCard = self:createCard(speedPage, "Current Speed: " .. self.currentSpeed, UDim2.new(1, 0, 0, 80), UDim2.new(0, 0, 0, 0))
    
    local speedValue = Instance.new("TextLabel")
    speedValue.Name = "SpeedValue"
    speedValue.Size = UDim2.new(1, -40, 0, 50)
    speedValue.Position = UDim2.new(0, 20, 0, 20)
    speedValue.BackgroundTransparency = 1
    speedValue.Text = tostring(self.currentSpeed)
    speedValue.TextColor3 = CONFIG.COLORS.ACCENT
    speedValue.TextSize = 36
    speedValue.Font = Enum.Font.GothamBold
    speedValue.Parent = speedCard
    
    -- Speed Slider Card
    local sliderCard = self:createCard(speedPage, "Speed Slider", UDim2.new(1, 0, 0, 120), UDim2.new(0, 0, 0, 90))
    self:createAdvancedSlider(sliderCard)
    
    -- Manual Input Card
    local inputCard = self:createCard(speedPage, "Manual Input", UDim2.new(1, 0, 0, 80), UDim2.new(0, 0, 0, 220))
    self:createSpeedInput(inputCard)
    
    -- Speed Presets Card
    local presetsCard = self:createCard(speedPage, "Speed Presets", UDim2.new(1, 0, 0, 140), UDim2.new(0, 0, 0, 310))
    self:createSpeedPresets(presetsCard)
    
    self.pages.Speed = speedPage
    self.components.speedValue = speedValue
end

function NatHubController:createJumpPage(parent)
    local jumpPage = Instance.new("Frame")
    jumpPage.Name = "JumpPage"
    jumpPage.Size = UDim2.new(1, 0, 0, 800)
    jumpPage.Position = UDim2.new(0, 0, 0, 0)
    jumpPage.BackgroundTransparency = 1
    jumpPage.Visible = false
    jumpPage.Parent = parent
    
    -- Jump Power Card
    local jumpPowerCard = self:createCard(jumpPage, "Jump Power: " .. self.currentJumpPower, UDim2.new(1, 0, 0, 100), UDim2.new(0, 0, 0, 0))
    self:createJumpPowerControls(jumpPowerCard)
    
    -- Jump Height Card
    local jumpHeightCard = self:createCard(jumpPage, "Jump Height: " .. self.currentJumpHeight, UDim2.new(1, 0, 0, 100), UDim2.new(0, 0, 0, 110))
    self:createJumpHeightControls(jumpHeightCard)
    
    -- Hip Height Card
    local hipHeightCard = self:createCard(jumpPage, "Hip Height: 0", UDim2.new(1, 0, 0, 100), UDim2.new(0, 0, 0, 220))
    self:createHipHeightControls(hipHeightCard)
    
    self.pages.Jump = jumpPage
end

function NatHubController:createInfoPage(parent)
    local infoPage = Instance.new("Frame")
    infoPage.Name = "InfoPage"
    infoPage.Size = UDim2.new(1, 0, 0, 800)
    infoPage.Position = UDim2.new(0, 0, 0, 0)
    infoPage.BackgroundTransparency = 1
    infoPage.Visible = false
    infoPage.Parent = parent
    
    -- Player Info Card (No title shown, direct content)
    local playerCard = self:createCard(infoPage, "", UDim2.new(1, 0, 0, 200), UDim2.new(0, 0, 0, 0))
    self:createPlayerInfo(playerCard)
    
    -- Performance Stats Card
    local statsCard = self:createCard(infoPage, "Performance Statistics", UDim2.new(1, 0, 0, 180), UDim2.new(0, 0, 0, 210))
    self:createPerformanceStats(statsCard)
    
    -- Session Info Card
    local sessionCard = self:createCard(infoPage, "Session Information", UDim2.new(1, 0, 0, 120), UDim2.new(0, 0, 0, 400))
    self:createSessionInfo(sessionCard)
    
    self.pages.Info = infoPage
end

function NatHubController:createSettingsPage(parent)
    local settingsPage = Instance.new("Frame")
    settingsPage.Name = "SettingsPage"
    settingsPage.Size = UDim2.new(1, 0, 0, 800)
    settingsPage.Position = UDim2.new(0, 0, 0, 0)
    settingsPage.BackgroundTransparency = 1
    settingsPage.Visible = false
    settingsPage.Parent = parent
    
    -- Audio Settings Card
    local audioCard = self:createCard(settingsPage, "Audio Settings", UDim2.new(1, 0, 0, 120), UDim2.new(0, 0, 0, 0))
    self:createAudioSettings(audioCard)
    
    -- Application Settings Card
    local appCard = self:createCard(settingsPage, "Application Settings", UDim2.new(1, 0, 0, 150), UDim2.new(0, 0, 0, 130))
    self:createApplicationSettings(appCard)
    
    -- Advanced Settings Card
    local advancedCard = self:createCard(settingsPage, "Advanced Settings", UDim2.new(1, 0, 0, 100), UDim2.new(0, 0, 0, 290))
    self:createAdvancedSettings(advancedCard)
    
    self.pages.Settings = settingsPage
end

-- ═══════════════════════════════════════════════════════════════
-- CARD CREATION METHOD
-- ═══════════════════════════════════════════════════════════════

function NatHubController:createCard(parent, title, size, position)
    local card = Instance.new("Frame")
    card.Name = title:gsub("%s+", "") .. "Card"
    card.Size = size
    card.Position = position
    card.BackgroundColor3 = CONFIG.COLORS.SIDEBAR
    card.BorderSizePixel = 0
    card.Parent = parent
    
    Utils.applyCorners(card, CONFIG.UI.CORNER_RADIUS)
    
    -- Card gradient effect
    Utils.createGradient(card, ColorSequence.new({
        ColorSequenceKeypoint.new(0, CONFIG.COLORS.SIDEBAR),
        ColorSequenceKeypoint.new(1, CONFIG.COLORS.SIDEBAR:lerp(Color3.new(0, 0, 0), 0.3))
    }), 145)
    
    -- Card border
    local border = Instance.new("UIStroke")
    border.Color = CONFIG.COLORS.BORDER
    border.Thickness = 1
    border.Transparency = 0.4
    border.Parent = card
    
    -- Card title (only if title is provided)
    if title and title ~= "" then
        local cardTitle = Instance.new("TextLabel")
        cardTitle.Name = "CardTitle"
        cardTitle.Size = UDim2.new(1, -40, 0, 35)
        cardTitle.Position = UDim2.new(0, 20, 0, 10)
        cardTitle.BackgroundTransparency = 1
        cardTitle.Text = title
        cardTitle.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
        cardTitle.TextSize = 18
        cardTitle.Font = Enum.Font.GothamBold
        cardTitle.TextXAlignment = Enum.TextXAlignment.Left
        cardTitle.Parent = card
        
        -- Add divider under title
        Utils.addDivider(card, UDim2.new(0, 20, 0, 45))
    end
    
    return card
end

-- ═══════════════════════════════════════════════════════════════
-- SPEED CONTROL COMPONENTS
-- ═══════════════════════════════════════════════════════════════

function NatHubController:createAdvancedSlider(parent)
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = "SliderContainer"
    sliderContainer.Size = UDim2.new(1, -40, 0, 70)
    sliderContainer.Position = UDim2.new(0, 20, 0, 50)
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.Parent = parent
    
    -- Speed range labels
    local minLabel = Instance.new("TextLabel")
    minLabel.Size = UDim2.new(0, 30, 0, 20)
    minLabel.Position = UDim2.new(0, 0, 0, 50)
    minLabel.BackgroundTransparency = 1
    minLabel.Text = tostring(CONFIG.SPEED.MIN)
    minLabel.TextColor3 = CONFIG.COLORS.TEXT_SECONDARY
    minLabel.TextSize = 14
    minLabel.Font = Enum.Font.Gotham
    minLabel.Parent = sliderContainer
    
    local maxLabel = Instance.new("TextLabel")
    maxLabel.Size = UDim2.new(0, 30, 0, 20)
    maxLabel.Position = UDim2.new(1, -30, 0, 50)
    maxLabel.BackgroundTransparency = 1
    maxLabel.Text = tostring(CONFIG.SPEED.MAX)
    maxLabel.TextColor3 = CONFIG.COLORS.TEXT_SECONDARY
    maxLabel.TextSize = 14
    maxLabel.Font = Enum.Font.Gotham
    maxLabel.Parent = sliderContainer
    
    -- Slider track
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "SliderTrack"  
    sliderTrack.Size = UDim2.new(1, -60, 0, 12)
    sliderTrack.Position = UDim2.new(0, 30, 0, 20)
    sliderTrack.BackgroundColor3 = CONFIG.COLORS.BORDER
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderContainer
    
    Utils.applyCorners(sliderTrack, 6)
    
    -- Slider fill
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((self.currentSpeed - CONFIG.SPEED.MIN) / (CONFIG.SPEED.MAX - CONFIG.SPEED.MIN), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = CONFIG.COLORS.ACCENT
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    Utils.applyCorners(sliderFill, 6)
    
    -- Fill gradient
    Utils.createGradient(sliderFill, ColorSequence.new({
        ColorSequenceKeypoint.new(0, CONFIG.COLORS.GRADIENT_START),
        ColorSequenceKeypoint.new(1, CONFIG.COLORS.GRADIENT_END)
    }), 0)
    
    -- Slider handle
    local sliderHandle = Instance.new("TextButton") 
    sliderHandle.Name = "SliderHandle"
    sliderHandle.Size = UDim2.new(0, 28, 0, 28)
    sliderHandle.Position = UDim2.new((self.currentSpeed - CONFIG.SPEED.MIN) / (CONFIG.SPEED.MAX - CONFIG.SPEED.MIN), -14, 0.5, -14)
    sliderHandle.BackgroundColor3 = CONFIG.COLORS.TEXT_PRIMARY
    sliderHandle.Text = ""
    sliderHandle.BorderSizePixel = 0
    sliderHandle.ZIndex = 2
    sliderHandle.Parent = sliderContainer
    
    Utils.applyCorners(sliderHandle, 14)
    
    -- Handle shadow
    Utils.createShadow(sliderHandle, 4, 0.8)
    
    -- Store slider references
    self.components.sliderTrack = sliderTrack
    self.components.sliderFill = sliderFill
    self.components.sliderHandle = sliderHandle
    
    -- Setup slider interaction
    self:setupSliderInteraction()
end

function NatHubController:createSpeedInput(parent)
    local inputContainer = Instance.new("Frame")
    inputContainer.Name = "InputContainer"
    inputContainer.Size = UDim2.new(1, -40, 0, 40)
    inputContainer.Position = UDim2.new(0, 20, 0, 30)
    inputContainer.BackgroundTransparency = 1
    inputContainer.Parent = parent
    
    local speedInput = Instance.new("TextBox")
    speedInput.Name = "SpeedInput"
    speedInput.Size = UDim2.new(0.6, 0, 1, 0)
    speedInput.Position = UDim2.new(0, 0, 0, 0)
    speedInput.BackgroundColor3 = CONFIG.COLORS.BACKGROUND
    speedInput.Text = tostring(self.currentSpeed)
    speedInput.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    speedInput.TextSize = 16
    speedInput.Font = Enum.Font.Gotham
    speedInput.PlaceholderText = "Enter speed (1-" .. CONFIG.SPEED.MAX .. ")"
    speedInput.PlaceholderColor3 = CONFIG.COLORS.TEXT_MUTED
    speedInput.BorderSizePixel = 0
    speedInput.ClearTextOnFocus = false
    speedInput.Parent = inputContainer
    
    Utils.applyCorners(speedInput, 8)
    
    -- Input border
    local inputBorder = Instance.new("UIStroke")
    inputBorder.Color = CONFIG.COLORS.BORDER
    inputBorder.Thickness = 2
    inputBorder.Transparency = 0.5
    inputBorder.Parent = speedInput
    
    -- Apply button
    local applyBtn = Instance.new("TextButton")
    applyBtn.Name = "ApplyButton"
    applyBtn.Size = UDim2.new(0.35, 0, 1, 0)
    applyBtn.Position = UDim2.new(0.63, 0, 0, 0)
    applyBtn.BackgroundColor3 = CONFIG.COLORS.SUCCESS
    applyBtn.Text = "Apply"
    applyBtn.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    applyBtn.TextSize = 16
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.BorderSizePixel = 0
    applyBtn.Parent = inputContainer
    
    Utils.applyCorners(applyBtn, 8)
    
    -- Input events
    speedInput.FocusLost:Connect(function(enterPressed)
        local inputValue = Utils.validateNumber(speedInput.Text, CONFIG.SPEED.MIN, CONFIG.SPEED.MAX, self.currentSpeed)
        inputValue = Utils.formatNumber(inputValue, CONFIG.SPEED.PRECISION)
        speedInput.Text = tostring(inputValue)
        
        if enterPressed then
            self:setSpeed(inputValue)
        end
    end)
    
    speedInput.Focused:Connect(function()
        Utils.createTween(inputBorder, TweenInfo.new(0.2), {Color = CONFIG.COLORS.ACCENT, Transparency = 0.2})
    end)
    
    speedInput.FocusLost:Connect(function()
        Utils.createTween(inputBorder, TweenInfo.new(0.2), {Color = CONFIG.COLORS.BORDER, Transparency = 0.5})
    end)
    
    applyBtn.MouseButton1Click:Connect(function()
        local inputValue = Utils.validateNumber(speedInput.Text, CONFIG.SPEED.MIN, CONFIG.SPEED.MAX, self.currentSpeed)
        self:setSpeed(inputValue)
        self:playSound("success")
    end)
    
    -- Apply button hover
    applyBtn.MouseEnter:Connect(function()
        Utils.createTween(applyBtn, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.SUCCESS:lerp(Color3.new(1, 1, 1), 0.2)})
    end)
    
    applyBtn.MouseLeave:Connect(function()
        Utils.createTween(applyBtn, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.SUCCESS})
    end)
    
    self.components.speedInput = speedInput
end

function NatHubController:createSpeedPresets(parent)
    local presetsContainer = Instance.new("Frame")
    presetsContainer.Name = "PresetsContainer"
    presetsContainer.Size = UDim2.new(1, -40, 0, 90)
    presetsContainer.Position = UDim2.new(0, 20, 0, 50)
    presetsContainer.BackgroundTransparency = 1
    presetsContainer.Parent = parent
    
    local presets = {
        {name = "Walk", speed = 16, color = CONFIG.COLORS.SUCCESS},
        {name = "Jog", speed = 25, color = CONFIG.COLORS.INFO},
        {name = "Run", speed = 35, color = CONFIG.COLORS.WARNING},
        {name = "Sprint", speed = 50, color = CONFIG.COLORS.DANGER},
        {name = "Flash", speed = 75, color = CONFIG.COLORS.GRADIENT_START},
        {name = "Max", speed = 100, color = CONFIG.COLORS.GRADIENT_END}
    }
    
    for i, preset in ipairs(presets) do
        local row = math.floor((i - 1) / 3)
        local col = (i - 1) % 3
        
        local btn = Instance.new("TextButton")
        btn.Name = preset.name .. "Button"
        btn.Size = UDim2.new(0.31, 0, 0, 35)
        btn.Position = UDim2.new(col * 0.34, 0, row * 45, 0)
        btn.BackgroundColor3 = preset.color
        btn.Text = preset.name .. " (" .. preset.speed .. ")"
        btn.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.Parent = presetsContainer
        
        Utils.applyCorners(btn, 8)
        
        -- Button gradient
        Utils.createGradient(btn, ColorSequence.new({
            ColorSequenceKeypoint.new(0, preset.color),
            ColorSequenceKeypoint.new(1, preset.color:lerp(Color3.new(0, 0, 0), 0.3))
        }), 45)
        
        -- Button events
        btn.MouseButton1Click:Connect(function()
            self:setSpeed(preset.speed)
            self:playButtonAnimation(btn)
            self:playSound("click")
        end)
        
        btn.MouseEnter:Connect(function()
            self:playSound("hover")
            Utils.createTween(btn, TweenInfo.new(0.2), {
                Size = UDim2.new(0.31, 0, 0, 38),
                BackgroundColor3 = preset.color:lerp(Color3.new(1, 1, 1), 0.2)
            })
        end)
        
        btn.MouseLeave:Connect(function()
            Utils.createTween(btn, TweenInfo.new(0.2), {
                Size = UDim2.new(0.31, 0, 0, 35),
                BackgroundColor3 = preset.color
            })
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- JUMP CONTROL COMPONENTS
-- ═══════════════════════════════════════════════════════════════

function NatHubController:createJumpPowerControls(parent)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -40, 0, 50)
    container.Position = UDim2.new(0, 20, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local jumpInput = Instance.new("TextBox")
    jumpInput.Size = UDim2.new(0.6, 0, 0, 40)
    jumpInput.Position = UDim2.new(0, 0, 0, 5)
    jumpInput.BackgroundColor3 = CONFIG.COLORS.BACKGROUND
    jumpInput.Text = tostring(self.currentJumpPower)
    jumpInput.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    jumpInput.TextSize = 16
    jumpInput.Font = Enum.Font.Gotham
    jumpInput.PlaceholderText = "Enter jump power (1-200)"
    jumpInput.BorderSizePixel = 0
    jumpInput.Parent = container
    
    Utils.applyCorners(jumpInput, 8)
    
    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(0.35, 0, 0, 40)
    applyBtn.Position = UDim2.new(0.63, 0, 0, 5)
    applyBtn.BackgroundColor3 = CONFIG.COLORS.SUCCESS
    applyBtn.Text = "Apply"
    applyBtn.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    applyBtn.TextSize = 16
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.BorderSizePixel = 0
    applyBtn.Parent = container
    
    Utils.applyCorners(applyBtn, 8)
    
    applyBtn.MouseButton1Click:Connect(function()
        local value = Utils.validateNumber(jumpInput.Text, 1, 200, self.currentJumpPower)
        self:setJumpPower(value)
        jumpInput.Text = tostring(value)
        self:playSound("success")
    end)
end

function NatHubController:createJumpHeightControls(parent)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -40, 0, 50)
    container.Position = UDim2.new(0, 20, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local heightInput = Instance.new("TextBox")
    heightInput.Size = UDim2.new(0.6, 0, 0, 40)
    heightInput.Position = UDim2.new(0, 0, 0, 5)
    heightInput.BackgroundColor3 = CONFIG.COLORS.BACKGROUND
    heightInput.Text = tostring(self.currentJumpHeight)
    heightInput.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    heightInput.TextSize = 16
    heightInput.Font = Enum.Font.Gotham
    heightInput.PlaceholderText = "Enter jump height (1-50)"
    heightInput.BorderSizePixel = 0
    heightInput.Parent = container
    
    Utils.applyCorners(heightInput, 8)
    
    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(0.35, 0, 0, 40)
    applyBtn.Position = UDim2.new(0.63, 0, 0, 5)
    applyBtn.BackgroundColor3 = CONFIG.COLORS.SUCCESS
    applyBtn.Text = "Apply"
    applyBtn.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    applyBtn.TextSize = 16
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.BorderSizePixel = 0
    applyBtn.Parent = container
    
    Utils.applyCorners(applyBtn, 8)
    
    applyBtn.MouseButton1Click:Connect(function()
        local value = Utils.validateNumber(heightInput.Text, 1, 50, self.currentJumpHeight)
        self:setJumpHeight(value)
        heightInput.Text = tostring(value)
        self:playSound("success")
    end)
end

function NatHubController:createHipHeightControls(parent)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -40, 0, 50)
    container.Position = UDim2.new(0, 20, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local hipInput = Instance.new("TextBox")
    hipInput.Size = UDim2.new(0.6, 0, 0, 40)
    hipInput.Position = UDim2.new(0, 0, 0, 5)
    hipInput.BackgroundColor3 = CONFIG.COLORS.BACKGROUND
    hipInput.Text = "0"
    hipInput.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    hipInput.TextSize = 16
    hipInput.Font = Enum.Font.Gotham
    hipInput.PlaceholderText = "Enter hip height (0-10)"
    hipInput.BorderSizePixel = 0
    hipInput.Parent = container
    
    Utils.applyCorners(hipInput, 8)
    
    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(0.35, 0, 0, 40)
    applyBtn.Position = UDim2.new(0.63, 0, 0, 5)
    applyBtn.BackgroundColor3 = CONFIG.COLORS.SUCCESS
    applyBtn.Text = "Apply"
    applyBtn.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    applyBtn.TextSize = 16
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.BorderSizePixel = 0
    applyBtn.Parent = container
    
    Utils.applyCorners(applyBtn, 8)
    
    applyBtn.MouseButton1Click:Connect(function()
        local value = Utils.validateNumber(hipInput.Text, 0, 10, 0)
        self:setHipHeight(value)
        hipInput.Text = tostring(value)
        self:playSound("success")
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- INFORMATION PAGE COMPONENTS
-- ═══════════════════════════════════════════════════════════════

function NatHubController:createPlayerInfo(parent)
    -- Player avatar section
    local avatarContainer = Instance.new("Frame")
    avatarContainer.Name = "AvatarContainer"
    avatarContainer.Size = UDim2.new(0, 120, 0, 120)
    avatarContainer.Position = UDim2.new(0, 30, 0, 20)
    avatarContainer.BackgroundColor3 = CONFIG.COLORS.BACKGROUND
    avatarContainer.BorderSizePixel = 0
    avatarContainer.Parent = parent
    
    Utils.applyCorners(avatarContainer, 15)
    
    -- Avatar border
    local avatarBorder = Instance.new("UIStroke")
    avatarBorder.Color = CONFIG.COLORS.ACCENT
    avatarBorder.Thickness = 3
    avatarBorder.Transparency = 0.3
    avatarBorder.Parent = avatarContainer
    
    local playerImage = Instance.new("ImageLabel")
    playerImage.Name = "PlayerImage"
    playerImage.Size = UDim2.new(1, -10, 1, -10)
    playerImage.Position = UDim2.new(0, 5, 0, 5)
    playerImage.BackgroundTransparency = 1
    playerImage.BorderSizePixel = 0
    playerImage.Parent = avatarContainer
    
    Utils.applyCorners(playerImage, 12)
    
    -- Load player avatar safely
    spawn(function()
        local success, avatarUrl = pcall(function()
            return Players:GetUserThumbnailAsync(self.player.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size150x150)
        end)
        
        if success and avatarUrl then
            playerImage.Image = avatarUrl
        else
            playerImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
            playerImage.ImageColor3 = CONFIG.COLORS.ACCENT
        end
    end)
    
    -- Player details
    local playerName = Instance.new("TextLabel")
    playerName.Size = UDim2.new(1, -180, 0, 30)
    playerName.Position = UDim2.new(0, 170, 0, 30)
    playerName.BackgroundTransparency = 1
    playerName.Text = "Player: " .. self.player.Name
    playerName.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    playerName.TextSize = 18
    playerName.Font = Enum.Font.GothamBold
    playerName.TextXAlignment = Enum.TextXAlignment.Left
    playerName.Parent = parent
    
    local playerId = Instance.new("TextLabel")
    playerId.Size = UDim2.new(1, -180, 0, 25)
    playerId.Position = UDim2.new(0, 170, 0, 65)
    playerId.BackgroundTransparency = 1
    playerId.Text = "User ID: " .. self.player.UserId
    playerId.TextColor3 = CONFIG.COLORS.TEXT_SECONDARY
    playerId.TextSize = 16
    playerId.Font = Enum.Font.Gotham
    playerId.TextXAlignment = Enum.TextXAlignment.Left
    playerId.Parent = parent
    
    local displayName = Instance.new("TextLabel")
    displayName.Size = UDim2.new(1, -180, 0, 25)
    displayName.Position = UDim2.new(0, 170, 0, 95)
    displayName.BackgroundTransparency = 1
    displayName.Text = "Display: @" .. (self.player.DisplayName or self.player.Name)
    displayName.TextColor3 = CONFIG.COLORS.TEXT_SECONDARY
    displayName.TextSize = 16
    displayName.Font = Enum.Font.Gotham
    displayName.TextXAlignment = Enum.TextXAlignment.Left
    displayName.Parent = parent
    
    local accountAge = Instance.new("TextLabel")
    accountAge.Size = UDim2.new(1, -180, 0, 25)
    accountAge.Position = UDim2.new(0, 170, 0, 125)
    accountAge.BackgroundTransparency = 1
    accountAge.Text = "Account Age: " .. self.player.AccountAge .. " days"
    accountAge.TextColor3 = CONFIG.COLORS.TEXT_SECONDARY
    accountAge.TextSize = 16
    accountAge.Font = Enum.Font.Gotham
    accountAge.TextXAlignment = Enum.TextXAlignment.Left
    accountAge.Parent = parent
end

function NatHubController:createPerformanceStats(parent)
    local statsContainer = Instance.new("Frame")
    statsContainer.Size = UDim2.new(1, -40, 0, 130)
    statsContainer.Position = UDim2.new(0, 20, 0, 50)
    statsContainer.BackgroundTransparency = 1
    statsContainer.Parent = parent
    
    -- FPS Display
    local fpsLabel = self:createStatItem(statsContainer, "FPS: 60", UDim2.new(0.48, 0, 0, 35), UDim2.new(0, 0, 0, 0))
    
    -- Ping Display
    local pingLabel = self:createStatItem(statsContainer, "Ping: 0ms", UDim2.new(0.48, 0, 0, 35), UDim2.new(0.52, 0, 0, 0))
    
    -- Memory Usage
    local memoryLabel = self:createStatItem(statsContainer, "Memory: 0MB", UDim2.new(0.48, 0, 0, 35), UDim2.new(0, 0, 0, 45))
    
    -- Speed Changes
    local speedChangesLabel = self:createStatItem(statsContainer, "Speed Changes: 0", UDim2.new(0.48, 0, 0, 35), UDim2.new(0.52, 0, 0, 45))
    
    -- Session Duration
    local sessionLabel = self:createStatItem(statsContainer, "Session: 0s", UDim2.new(1, 0, 0, 35), UDim2.new(0, 0, 0, 90))
    
    -- Store references for updates
    self.components.fpsLabel = fpsLabel
    self.components.pingLabel = pingLabel
    self.components.memoryLabel = memoryLabel
    self.components.speedChangesLabel = speedChangesLabel
    self.components.sessionLabel = sessionLabel
end

function NatHubController:createSessionInfo(parent)
    local sessionContainer = Instance.new("Frame")
    sessionContainer.Size = UDim2.new(1, -40, 0, 70)
    sessionContainer.Position = UDim2.new(0, 20, 0, 50)
    sessionContainer.BackgroundTransparency = 1
    sessionContainer.Parent = parent
    
    local sessionStart = Instance.new("TextLabel")
    sessionStart.Size = UDim2.new(1, 0, 0, 25)
    sessionStart.Position = UDim2.new(0, 0, 0, 0)
    sessionStart.BackgroundTransparency = 1
    sessionStart.Text = "Session Started: " .. os.date("%H:%M:%S", self.stats.sessionStart)
    sessionStart.TextColor3 = CONFIG.COLORS.TEXT_SECONDARY
    sessionStart.TextSize = 16
    sessionStart.Font = Enum.Font.Gotham
    sessionStart.TextXAlignment = Enum.TextXAlignment.Left
    sessionStart.Parent = sessionContainer
    
    local currentTime = Instance.new("TextLabel")
    currentTime.Size = UDim2.new(1, 0, 0, 25)
    currentTime.Position = UDim2.new(0, 0, 0, 30)
    currentTime.BackgroundTransparency = 1
    currentTime.Text = "Current Time: " .. os.date("%H:%M:%S")
    currentTime.TextColor3 = CONFIG.COLORS.TEXT_SECONDARY
    currentTime.TextSize = 16
    currentTime.Font = Enum.Font.Gotham
    currentTime.TextXAlignment = Enum.TextXAlignment.Left
    currentTime.Parent = sessionContainer
    
    self.components.currentTimeLabel = currentTime
end

function NatHubController:createStatItem(parent, text, size, position)
    local statItem = Instance.new("Frame")
    statItem.Size = size
    statItem.Position = position
    statItem.BackgroundColor3 = CONFIG.COLORS.BACKGROUND
    statItem.BorderSizePixel = 0
    statItem.Parent = parent
    
    Utils.applyCorners(statItem, 8)
    
    local statBorder = Instance.new("UIStroke")
    statBorder.Color = CONFIG.COLORS.BORDER
    statBorder.Thickness = 1
    statBorder.Transparency = 0.5
    statBorder.Parent = statItem
    
    local statLabel = Instance.new("TextLabel")
    statLabel.Size = UDim2.new(1, -20, 1, 0)
    statLabel.Position = UDim2.new(0, 10, 0, 0)
    statLabel.BackgroundTransparency = 1
    statLabel.Text = text
    statLabel.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    statLabel.TextSize = 14
    statLabel.Font = Enum.Font.Gotham
    statLabel.TextXAlignment = Enum.TextXAlignment.Left
    statLabel.Parent = statItem
    
    return statLabel
end

-- ═══════════════════════════════════════════════════════════════
-- SETTINGS PAGE COMPONENTS
-- ═══════════════════════════════════════════════════════════════

function NatHubController:createAudioSettings(parent)
    local audioContainer = Instance.new("Frame")
    audioContainer.Size = UDim2.new(1, -40, 0, 70)
    audioContainer.Position = UDim2.new(0, 20, 0, 50)
    audioContainer.BackgroundTransparency = 1
    audioContainer.Parent = parent
    
    -- Sound Effects Toggle
    self:createToggleSetting(audioContainer, "Sound Effects", "soundEnabled", UDim2.new(0, 0, 0, 0))
    
    -- Button Sounds Toggle  
    self:createToggleSetting(audioContainer, "Button Sounds", "buttonSounds", UDim2.new(0, 0, 0, 35))
end

function NatHubController:createApplicationSettings(parent)
    local appContainer = Instance.new("Frame")
    appContainer.Size = UDim2.new(1, -40, 0, 100)
    appContainer.Position = UDim2.new(0, 20, 0, 50)
    appContainer.BackgroundTransparency = 1
    appContainer.Parent = parent
    
    -- Auto Apply Toggle
    self:createToggleSetting(appContainer, "Auto Apply on Spawn", "autoApply", UDim2.new(0, 0, 0, 0))
    
    -- Save Settings Toggle
    self:createToggleSetting(appContainer, "Save Settings", "saveSettings", UDim2.new(0, 0, 0, 35))
    
    -- Animations Toggle
    self:createToggleSetting(appContainer, "UI Animations", "animations", UDim2.new(0, 0, 0, 70))
end

function NatHubController:createAdvancedSettings(parent)
    local advancedContainer = Instance.new("Frame")
    advancedContainer.Size = UDim2.new(1, -40, 0, 50)
    advancedContainer.Position = UDim2.new(0, 20, 0, 50)
    advancedContainer.BackgroundTransparency = 1
    advancedContainer.Parent = parent
    
    -- Reset Settings Button
    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(0.48, 0, 0, 40)
    resetBtn.Position = UDim2.new(0, 0, 0, 5)
    resetBtn.BackgroundColor3 = CONFIG.COLORS.WARNING
    resetBtn.Text = "Reset Settings"
    resetBtn.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    resetBtn.TextSize = 16
    resetBtn.Font = Enum.Font.GothamBold
    resetBtn.BorderSizePixel = 0
    resetBtn.Parent = advancedContainer
    
    Utils.applyCorners(resetBtn, 8)
    
    -- Export Settings Button
    local exportBtn = Instance.new("TextButton")
    exportBtn.Size = UDim2.new(0.48, 0, 0, 40)
    exportBtn.Position = UDim2.new(0.52, 0, 0, 5)
    exportBtn.BackgroundColor3 = CONFIG.COLORS.INFO
    exportBtn.Text = "Export Data"
    exportBtn.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    exportBtn.TextSize = 16
    exportBtn.Font = Enum.Font.GothamBold
    exportBtn.BorderSizePixel = 0
    exportBtn.Parent = advancedContainer
    
    Utils.applyCorners(exportBtn, 8)
    
    -- Button events
    resetBtn.MouseButton1Click:Connect(function()
        self:resetSettings()
        self:playSound("success")
    end)
    
    exportBtn.MouseButton1Click:Connect(function()
        self:exportSettings()
        self:playSound("success")
    end)
end

function NatHubController:createToggleSetting(parent, labelText, settingKey, position)
    local settingContainer = Instance.new("Frame")
    settingContainer.Size = UDim2.new(1, 0, 0, 30)
    settingContainer.Position = position
    settingContainer.BackgroundTransparency = 1
    settingContainer.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = CONFIG.COLORS.TEXT_SECONDARY
    label.TextSize = 16
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = settingContainer
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 60, 0, 25)
    toggleFrame.Position = UDim2.new(0.75, 0, 0, 2.5)
    toggleFrame.BackgroundColor3 = self.settings[settingKey] and CONFIG.COLORS.SUCCESS or CONFIG.COLORS.BORDER
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = settingContainer
    
    Utils.applyCorners(toggleFrame, 12)
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 21, 0, 21)
    toggleButton.Position = self.settings[settingKey] and UDim2.new(0, 37, 0, 2) or UDim2.new(0, 2, 0, 2)
    toggleButton.BackgroundColor3 = CONFIG.COLORS.TEXT_PRIMARY
    toggleButton.Text = ""
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    Utils.applyCorners(toggleButton, 10)
    
    local toggleText = Instance.new("TextLabel")
    toggleText.Size = UDim2.new(1, 0, 1, 0)
    toggleText.BackgroundTransparency = 1
    toggleText.Text = self.settings[settingKey] and "ON" or "OFF"
    toggleText.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    toggleText.TextSize = 12
    toggleText.Font = Enum.Font.GothamBold
    toggleText.Parent = toggleFrame
    
    toggleButton.MouseButton1Click:Connect(function()
        self.settings[settingKey] = not self.settings[settingKey] 
        local isEnabled = self.settings[settingKey]
        
        Utils.createTween(toggleFrame, TweenInfo.new(0.3), {
            BackgroundColor3 = isEnabled and CONFIG.COLORS.SUCCESS or CONFIG.COLORS.BORDER
        })
        
        Utils.createTween(toggleButton, TweenInfo.new(0.3), {
            Position = isEnabled and UDim2.new(0, 37, 0, 2) or UDim2.new(0, 2, 0, 2)
        })
        
        toggleText.Text = isEnabled and "ON" or "OFF"
        
        self:playSound("click")
        self:handleSettingChange(settingKey, isEnabled)
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- INTERACTION SYSTEMS
-- ═══════════════════════════════════════════════════════════════

function NatHubController:setupSliderInteraction()
    local dragging = false
    local handle = self.components.sliderHandle
    local track = self.components.sliderTrack
    local fill = self.components.sliderFill
    
    if not handle or not track or not fill then return end
    
    handle.MouseButton1Down:Connect(function()
        dragging = true
        self:playSound("slide")
        Utils.createTween(handle, TweenInfo.new(0.1), {Size = UDim2.new(0, 32, 0, 32)})
    end)
    
    local connection = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            Utils.createTween(handle, TweenInfo.new(0.1), {Size = UDim2.new(0, 28, 0, 28)})
        end
    end)
    table.insert(self.connections, connection)
    
    connection = UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = self.player:GetMouse()
            local trackPos = track.AbsolutePosition.X
            local trackSize = track.AbsoluteSize.X
            local relativePos = math.clamp((mouse.X - trackPos) / trackSize, 0, 1)
            
            local speed = Utils.formatNumber(
                CONFIG.SPEED.MIN + relativePos * (CONFIG.SPEED.MAX - CONFIG.SPEED.MIN),
                CONFIG.SPEED.PRECISION
            )
            
            self:setSpeed(speed, true)
        end
    end)
    table.insert(self.connections, connection)
    
    -- Click on track to jump
    track.InputBegan:Connect(function(input)
        if not dragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local relativePos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local speed = Utils.formatNumber(
                CONFIG.SPEED.MIN + relativePos * (CONFIG.SPEED.MAX - CONFIG.SPEED.MIN),
                CONFIG.SPEED.PRECISION
            )
            self:setSpeed(speed)
        end
    end)
end

function NatHubController:makeDraggable(frame)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    -- Use topbar for dragging
    local topBar = self.components.topBar
    if not topBar then return end
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            Utils.createTween(frame, TweenInfo.new(0.1), {Size = frame.Size * 0.98})
        end
    end)
    
    local connection = UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
            
            -- Constrain to screen bounds
            local viewport = workspace.CurrentCamera.ViewportSize
            local frameSize = frame.AbsoluteSize
            
            newPos = UDim2.new(
                0, math.clamp(newPos.X.Offset, 0, viewport.X - frameSize.X),
                0, math.clamp(newPos.Y.Offset, 0, viewport.Y - frameSize.Y)
            )
            
            frame.Position = newPos
        end
    end)
    table.insert(self.connections, connection)
    
    connection = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            Utils.createTween(frame, TweenInfo.new(0.1), {Size = frame.Size / 0.98})
        end
    end)
    table.insert(self.connections, connection)
end

function NatHubController:setupEventHandlers()
    -- Keyboard shortcuts
    local connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F1 then
            self:toggleUI()  
        elseif input.KeyCode == Enum.KeyCode.Escape and self.isVisible then
            self:hideUI()
        end
    end)
    table.insert(self.connections, connection)
    
    -- Handle GUI changes
    connection = GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(function()
        self:adjustForTopbar()
    end)
    table.insert(self.connections, connection)
    
    connection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        self:adjustForViewport()
    end)
    table.insert(self.connections, connection)
end

function NatHubController:setupCharacterHandling()
    local function onCharacterAdded(character)
        if not character then return end
        
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid and self.settings.autoApply then
            wait(0.2)
            self:applyAllValues()
        end
    end
    
    if self.player.Character then
        onCharacterAdded(self.player.Character)
    end
    
    local connection = self.player.CharacterAdded:Connect(onCharacterAdded)
    table.insert(self.connections, connection)
end

function NatHubController:startUpdateLoop()
    local connection = RunService.Heartbeat:Connect(function()
        self:updatePerformanceStats()
        self:updateUI()
    end)
    table.insert(self.connections, connection)
end

-- ═══════════════════════════════════════════════════════════════
-- CORE FUNCTIONALITY
-- ═══════════════════════════════════════════════════════════════

function NatHubController:setSpeed(speed, silent)
    local oldSpeed = self.currentSpeed
    self.currentSpeed = Utils.validateNumber(speed, CONFIG.SPEED.MIN, CONFIG.SPEED.MAX, CONFIG.SPEED.DEFAULT)
    
    if oldSpeed ~= self.currentSpeed then
        self.stats.speedChanges = self.stats.speedChanges + 1
        
        -- Apply to character
        self:applySpeedToCharacter()
        
        -- Update UI elements
        self:updateSpeedUI()
        
        -- Play feedback
        if not silent then
            self:playSound("slide")
            self:playSpeedChangeAnimation()
        end
    end
end

function NatHubController:setJumpPower(power)
    self.currentJumpPower = Utils.validateNumber(power, 1, 200, 50)
    self:applyJumpPowerToCharacter()
    self:updateJumpUI()
end

function NatHubController:setJumpHeight(height)
    self.currentJumpHeight = Utils.validateNumber(height, 1, 50, 7.2)
    self:applyJumpHeightToCharacter()
    self:updateJumpUI()
end

function NatHubController:setHipHeight(height)
    local hipHeight = Utils.validateNumber(height, 0, 10, 0)
    self:applyHipHeightToCharacter(hipHeight)
end

function NatHubController:applySpeedToCharacter()
    if self.player.Character and self.player.Character:FindFirstChild("Humanoid") then
        self.player.Character.Humanoid.WalkSpeed = self.currentSpeed
    end
end

function NatHubController:applyJumpPowerToCharacter()
    if self.player.Character and self.player.Character:FindFirstChild("Humanoid") then
        self.player.Character.Humanoid.JumpPower = self.currentJumpPower
    end
end

function NatHubController:applyJumpHeightToCharacter()
    if self.player.Character and self.player.Character:FindFirstChild("Humanoid") then
        self.player.Character.Humanoid.JumpHeight = self.currentJumpHeight
    end
end

function NatHubController:applyHipHeightToCharacter(height)
    if self.player.Character and self.player.Character:FindFirstChild("Humanoid") then
        self.player.Character.Humanoid.HipHeight = height
    end
end

function NatHubController:applyAllValues()
    self:applySpeedToCharacter()
    self:applyJumpPowerToCharacter()
    self:applyJumpHeightToCharacter()
end

function NatHubController:switchPage(pageName)
    if self.currentPage == pageName then return end
    
    -- Hide current page
    if self.pages[self.currentPage] then
        self.pages[self.currentPage].Visible = false
    end
    
    -- Update menu item states
    self:updateMenuItemState(self.currentPage, false)
    self:updateMenuItemState(pageName, true)
    
    -- Show new page
    self.currentPage = pageName
    if self.pages[pageName] then
        self.pages[pageName].Visible = true
    end
end

function NatHubController:updateMenuItemState(pageName, isSelected)
    local menuItem = self.components[pageName .. "MenuItem"]
    local icon = self.components[pageName .. "Icon"]
    local text = self.components[pageName .. "Text"]
    local indicator = self.components[pageName .. "Indicator"]
    
    if menuItem and icon and text and indicator then
        Utils.createTween(menuItem, TweenInfo.new(0.3), {
            BackgroundTransparency = isSelected and 0 or 1
        })
        
        Utils.createTween(icon, TweenInfo.new(0.3), {
            ImageColor3 = isSelected and CONFIG.COLORS.ACCENT or CONFIG.COLORS.TEXT_SECONDARY
        })
        
        Utils.createTween(text, TweenInfo.new(0.3), {
            TextColor3 = isSelected and CONFIG.COLORS.TEXT_PRIMARY or CONFIG.COLORS.TEXT_SECONDARY
        })
        
        indicator.Visible = isSelected
    end
end

function NatHubController:updateSpeedUI()
    if self.components.speedValue then
        self.components.speedValue.Text = tostring(self.currentSpeed)
    end
    
    if self.components.speedInput and not self.components.speedInput:IsFocused() then
        self.components.speedInput.Text = tostring(self.currentSpeed)
    end
    
    self:updateSliderPosition()
end

function NatHubController:updateJumpUI()
    -- Update jump card titles
    local jumpPowerCard = self.components.JumpPowerCard
    local jumpHeightCard = self.components.JumpHeightCard
    
    if jumpPowerCard then
        local title = jumpPowerCard:FindFirstChild("CardTitle")
        if title then
            title.Text = "Jump Power: " .. self.currentJumpPower
        end
    end
    
    if jumpHeightCard then
        local title = jumpHeightCard:FindFirstChild("CardTitle")
        if title then
            title.Text = "Jump Height: " .. self.currentJumpHeight
        end
    end
end

function NatHubController:updateSliderPosition()
    if not self.components.sliderHandle or not self.components.sliderFill then return end
    
    local relativePos = (self.currentSpeed - CONFIG.SPEED.MIN) / (CONFIG.SPEED.MAX - CONFIG.SPEED.MIN)
    
    Utils.createTween(self.components.sliderHandle, TweenInfo.new(0.2), {
        Position = UDim2.new(relativePos, -14, 0.5, -14)
    })
    
    Utils.createTween(self.components.sliderFill, TweenInfo.new(0.2), {
        Size = UDim2.new(relativePos, 0, 1, 0)
    })
end

function NatHubController:updatePerformanceStats()
    self.stats.frameCount = self.stats.frameCount + 1
    local currentTime = tick()
    
    if currentTime - self.stats.lastFPSUpdate >= 1 then
        self.stats.currentFPS = self.stats.frameCount
        self.stats.frameCount = 0
        self.stats.lastFPSUpdate = currentTime
        
        -- Update stat labels
        if self.components.fpsLabel then
            self.components.fpsLabel.Text = "FPS: " .. self.stats.currentFPS
        end
        
        if self.components.pingLabel then
            -- Approximate ping calculation
            self.stats.ping = math.random(10, 150)
            self.components.pingLabel.Text = "Ping: " .. self.stats.ping .. "ms"
        end
        
        if self.components.memoryLabel then
            self.stats.memory = math.floor(collectgarbage("count") / 1024)
            self.components.memoryLabel.Text = "Memory: " .. self.stats.memory .. "MB"
        end
        
        if self.components.speedChangesLabel then
            self.components.speedChangesLabel.Text = "Speed Changes: " .. self.stats.speedChanges
        end
        
        if self.components.sessionLabel then
            local sessionTime = math.floor(currentTime - self.stats.sessionStart)
            self.components.sessionLabel.Text = "Session: " .. sessionTime .. "s"
        end
        
        if self.components.currentTimeLabel then
            self.components.currentTimeLabel.Text = "Current Time: " .. os.date("%H:%M:%S")
        end
    end
end

function NatHubController:updateUI()
    -- Update current speed display
    if self.components.speedValue then
        self.components.speedValue.Text = tostring(self.currentSpeed)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- UI CONTROL METHODS
-- ═══════════════════════════════════════════════════════════════

function NatHubController:toggleUI()
    if self.isVisible then
        self:hideUI()
    else
        self:showUI()
    end
end

function NatHubController:showUI()
    if self.isVisible then return end
    
    self.isVisible = true
    
    Utils.createTween(self.components.mainFrame,
        TweenInfo.new(CONFIG.UI.ANIMATION_SPEED, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -CONFIG.UI.MAIN_SIZE.X/2, 0.5, -CONFIG.UI.MAIN_SIZE.Y/2)}
    )
    
    self:playSound("open")
end

function NatHubController:hideUI()
    if not self.isVisible then return end
    
    self.isVisible = false
    
    Utils.createTween(self.components.mainFrame,
        TweenInfo.new(CONFIG.UI.ANIMATION_SPEED, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Position = UDim2.new(0.5, -CONFIG.UI.MAIN_SIZE.X/2, -1, -50)}
    )
    
    self:playSound("close")
end

function NatHubController:adjustForTopbar()
    local topbarInset = GuiService:GetGuiInset()
    if self.isVisible then
        local currentPos = self.components.mainFrame.Position
        self.components.mainFrame.Position = UDim2.new(
            currentPos.X.Scale, currentPos.X.Offset,
            currentPos.Y.Scale, math.max(currentPos.Y.Offset, topbarInset.Y + 10)
        )
    end
end

function NatHubController:adjustForViewport()
    if not self.isVisible then return end
    
    local viewport = workspace.CurrentCamera.ViewportSize
    local framePos = self.components.mainFrame.Position
    local frameSize = self.components.mainFrame.AbsoluteSize
    
    local newPos = UDim2.new(
        0, math.clamp(framePos.X.Offset, 10, viewport.X - frameSize.X - 10),
        0, math.clamp(framePos.Y.Offset, 10, viewport.Y - frameSize.Y - 10)
    )
    
    if newPos ~= framePos then
        Utils.createTween(self.components.mainFrame, TweenInfo.new(0.3), {Position = newPos})
    end
end

-- ═══════════════════════════════════════════════════════════════
-- ANIMATION METHODS
-- ═══════════════════════════════════════════════════════════════

function NatHubController:playButtonAnimation(button)
    local originalSize = button.Size
    local shrinkTween = Utils.createTween(button,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = originalSize * 0.9}
    )
    
    shrinkTween.Completed:Connect(function()
        Utils.createTween(button,
            TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size = originalSize * 1.05},
            function()
                Utils.createTween(button,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = originalSize}
                )
            end
        )
    end)
end

function NatHubController:playSpeedChangeAnimation()
    if self.components.speedValue then
        local originalColor = self.components.speedValue.TextColor3
        
        Utils.createTween(self.components.speedValue,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {TextColor3 = CONFIG.COLORS.SUCCESS},
            function()
                Utils.createTween(self.components.speedValue,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out
