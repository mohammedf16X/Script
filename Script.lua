--TERAB PROGRAMING
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService") -- For potential future use with external data/APIs
local DataStoreService = game:GetService("DataStoreService") -- For saving settings

-- ═══════════════════════════════════════════════════════════════
-- CONFIGURATION SYSTEM (ENHANCED)
-- ═══════════════════════════════════════════════════════════════

local CONFIG = {
    UI = {
        MAIN_SIZE = Vector2.new(700, 450),
        SIDEBAR_WIDTH = 200,
        CORNER_RADIUS = 15,
        ANIMATION_SPEED = 0.4, -- Slightly faster animation
        TOGGLE_SIZE = 60,
        FONT = Enum.Font.GothamSemibold, -- A clean, modern font
        FONT_BOLD = Enum.Font.GothamBold,
        FONT_CUSTOM_ID = "rbxassetid://6063708899", -- Example: A custom font asset ID (replace with actual if found)
        FONT_ICONS_ID = "rbxassetid://0000000000" -- Placeholder for a potential icon font asset ID
    },
    
    COLORS = {
        BACKGROUND = Color3.fromRGB(32, 34, 37),
        SIDEBAR = Color3.fromRGB(40, 42, 47), -- Slightly adjusted for better contrast
        ACCENT = Color3.fromRGB(114, 137, 218),
        ACCENT_HOVER = Color3.fromRGB(129, 151, 230),
        SUCCESS = Color3.fromRGB(67, 181, 129),
        WARNING = Color3.fromRGB(250, 166, 26),
        DANGER = Color3.fromRGB(240, 71, 71),
        INFO = Color3.fromRGB(52, 152, 219),
        TEXT_PRIMARY = Color3.fromRGB(240, 241, 242), -- Brighter text
        TEXT_SECONDARY = Color3.fromRGB(185, 187, 190),
        TEXT_MUTED = Color3.fromRGB(114, 118, 125),
        BORDER = Color3.fromRGB(64, 68, 75),
        HOVER = Color3.fromRGB(54, 57, 63),
        SELECTED = Color3.fromRGB(64, 68, 75)
    },
    
    SPEED = {
        MIN = 1,
        MAX = 250, -- Increased max speed
        DEFAULT = 16,
        PRESETS = {50, 100, 150, 200}
    },
    
    JUMP = {
        POWER_MIN = 0,
        POWER_MAX = 200,
        POWER_DEFAULT = 50,
        HEIGHT_MIN = 0,
        HEIGHT_MAX = 200,
        HEIGHT_DEFAULT = 7.2,
        HIP_HEIGHT_MIN = 0,
        HIP_HEIGHT_MAX = 5,
        HIP_HEIGHT_DEFAULT = 0.5 -- Default for R6/R15 is usually around 0.5-0.6
    },
    
    ICONS = { -- Using Image IDs for better visual quality and potential SVG conversion
        SPEED = "rbxassetid://5009915812", -- Placeholder, replace with actual Image ID
        JUMP = "rbxassetid://9180622670", -- Placeholder
        SETTINGS = "rbxassetid://11818627075", -- Placeholder
        INFO = "rbxassetid://10590477450", -- Placeholder
        CLOSE = "rbxassetid://8425069728", -- Placeholder
        MENU = "rbxassetid://9142678957", -- Placeholder
        CHECK = "rbxassetid://1234567896", -- Placeholder for toggle on
        UNCHECK = "rbxassetid://1234567897" -- Placeholder for toggle off
    },

    SOUNDS = { -- Using common, free-to-use sound assets
        CLICK = "rbxassetid://913363246", -- UI Click
        HOVER = "rbxassetid://6421943844", -- UI Hover
        OPEN = "rbxassetid://130992943", -- Swoosh
        CLOSE = "rbxassetid://130992919", -- Swoosh reverse
        TOGGLE_ON = "rbxassetid://130992943", -- Example, same as open
        TOGGLE_OFF = "rbxassetid://130992919" -- Example, same as close
    }
}

-- ═══════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

local Utils = {}

function Utils.createTween(instance, tweenInfo, properties, callback)
    if not instance or not pcall(function() return instance.Parent end) then return end
    local tween = TweenService:Create(instance, tweenInfo, properties)
    if callback then
        local connection
        connection = tween.Completed:Connect(function(state)
            pcall(callback, state)
            if connection then connection:Disconnect() end
        end)
    end
    tween:Play()
    return tween
end

function Utils.applyCorners(instance, radius)
    if not instance then return end
    local corner = instance:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or CONFIG.UI.CORNER_RADIUS)
    corner.Parent = instance
    return corner
end

function Utils.createGradient(instance, colors, rotation)
    if not instance then return end
    local gradient = instance:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colors)
    gradient.Rotation = rotation or 0
    gradient.Parent = instance
    return gradient
end

function Utils.validateNumber(value, min, max, default)
    local num = tonumber(value)
    if not num or num ~= num then return default end -- Check for NaN
    return math.clamp(num, min, max)
end

function Utils.createSound(soundId, volume)
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = volume or 0.5
    sound.Parent = SoundService
    return sound
end

function Utils.createIcon(parent, iconId, size, position, color)
    local icon = Instance.new("ImageLabel")
    icon.Image = iconId
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(0, size, 0, size)
    icon.Position = UDim2.new(0, position.X, 0, position.Y)
    icon.ImageColor3 = color or CONFIG.COLORS.TEXT_PRIMARY
    icon.Parent = parent
    return icon
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
    self.currentJumpPower = CONFIG.JUMP.POWER_DEFAULT
    self.currentJumpHeight = CONFIG.JUMP.HEIGHT_DEFAULT
    self.currentHipHeight = CONFIG.JUMP.HIP_HEIGHT_DEFAULT -- Default value, will be updated from Humanoid
    self.isVisible = false
    self.currentPage = "Speed"
    self.isDragging = false
    self.dragOffset = Vector2.new(0,0)
    
    -- Storage
    self.components = {}
    self.connections = {}
    self.tweens = {}
    self.pages = {}
    
    -- Settings (Loaded from DataStore)
    self.settings = {
        soundEnabled = true,
        autoApply = true,
        saveSettings = true,
        animations = true,
        keybind = Enum.KeyCode.RightControl -- Default keybind
    }
    
    -- Sounds
    self.sounds = {
        click = Utils.createSound(CONFIG.SOUNDS.CLICK, 0.7),
        hover = Utils.createSound(CONFIG.SOUNDS.HOVER, 0.2),
        open = Utils.createSound(CONFIG.SOUNDS.OPEN, 0.6),
        close = Utils.createSound(CONFIG.SOUNDS.CLOSE, 0.6),
        toggleOn = Utils.createSound(CONFIG.SOUNDS.TOGGLE_ON, 0.5),
        toggleOff = Utils.createSound(CONFIG.SOUNDS.TOGGLE_OFF, 0.5)
    }
    
    -- Stats
    self.stats = {
        frameCount = 0,
        lastFPSUpdate = tick(),
        speedChanges = 0,
        jumpChanges = 0,
        sessionStart = tick(),
        currentFPS = 60
    }
    
    -- Initialize
    self:init()
    
    return self
end

function NatHubController:init()
    -- Clean existing UI
    local existing = self.playerGui:FindFirstChild("NatHubCharacterUI")
    if existing then 
        existing:Destroy() 
        task.wait(0.1)
    end
    
    -- Load settings
    self:loadSettings()

    -- Create UI
    self:createMainUI()
    self:createToggleButton()
    self:setupEvents()
    self:setupCharacterHandling()
    self:startUpdateLoop()
    
    print("✅ NatHub Character Controller Loaded! (Enhanced by Manus)")
    print("🎮 Press " .. self.settings.keybind.Name .. " to open/close the menu.")
end

-- ═══════════════════════════════════════════════════════════════
-- UI CREATION
-- ═══════════════════════════════════════════════════════════════

function NatHubController:createMainUI()
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NatHubCharacterUI"
    screenGui.Parent = self.playerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 100
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, CONFIG.UI.MAIN_SIZE.X, 0, CONFIG.UI.MAIN_SIZE.Y)
    mainFrame.Position = UDim2.new(0.5, -CONFIG.UI.MAIN_SIZE.X/2, -1, 0) -- Start off-screen
    mainFrame.BackgroundColor3 = CONFIG.COLORS.BACKGROUND
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = false -- Custom draggable implementation
    mainFrame.Parent = screenGui
    
    Utils.applyCorners(mainFrame, CONFIG.UI.CORNER_RADIUS)
    
    -- Border
    local border = Instance.new("UIStroke")
    border.Color = CONFIG.COLORS.ACCENT
    border.Thickness = 2
    border.Transparency = 0.3
    border.Parent = mainFrame
    
    -- Background gradient
    Utils.createGradient(mainFrame, {
        ColorSequenceKeypoint.new(0, CONFIG.COLORS.BACKGROUND),
        ColorSequenceKeypoint.new(1, CONFIG.COLORS.BACKGROUND:lerp(Color3.new(0, 0, 0), 0.3))
    }, 135)
    
    -- Create sections
    self:createTopBar(mainFrame)
    self:createSidebar(mainFrame)
    self:createContentArea(mainFrame)
    
    -- Store references
    self.components.screenGui = screenGui
    self.components.mainFrame = mainFrame
    
    -- Make draggable
    self:makeDraggable(mainFrame)
end

function NatHubController:createToggleButton()
    local toggleButton = Instance.new("ImageButton") -- Changed to ImageButton for icon support
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, CONFIG.UI.TOGGLE_SIZE, 0, CONFIG.UI.TOGGLE_SIZE)
    toggleButton.Position = UDim2.new(0, 30, 0, 120)
    toggleButton.BackgroundColor3 = CONFIG.COLORS.ACCENT
    toggleButton.Image = CONFIG.ICONS.MENU -- Use Image ID for the icon
    toggleButton.ImageColor3 = CONFIG.COLORS.TEXT_PRIMARY
    toggleButton.BackgroundTransparency = 0
    toggleButton.BorderSizePixel = 0
    toggleButton.ZIndex = 1000
    toggleButton.Parent = self.components.screenGui
    
    Utils.applyCorners(toggleButton, CONFIG.UI.TOGGLE_SIZE/2)
    
    -- Gradient
    Utils.createGradient(toggleButton, {
        ColorSequenceKeypoint.new(0, CONFIG.COLORS.ACCENT),
        ColorSequenceKeypoint.new(1, CONFIG.COLORS.ACCENT:lerp(Color3.new(0, 0, 0), 0.2))
    }, 45)
    
    -- Events
    self.connections.toggleButton_Click = toggleButton.MouseButton1Click:Connect(function()
        self:toggleUI()
        self:playSound("click")
    end)
    
    self.connections.toggleButton_MouseEnter = toggleButton.MouseEnter:Connect(function()
        self:playSound("hover")
        if self.settings.animations then
            Utils.createTween(toggleButton, TweenInfo.new(0.2), {
                Size = UDim2.new(0, CONFIG.UI.TOGGLE_SIZE + 10, 0, CONFIG.UI.TOGGLE_SIZE + 10),
                BackgroundColor3 = CONFIG.COLORS.ACCENT_HOVER
            })
        end
    end)
    
    self.connections.toggleButton_MouseLeave = toggleButton.MouseLeave:Connect(function()
        if self.settings.animations then
            Utils.createTween(toggleButton, TweenInfo.new(0.2), {
                Size = UDim2.new(0, CONFIG.UI.TOGGLE_SIZE, 0, CONFIG.UI.TOGGLE_SIZE),
                BackgroundColor3 = CONFIG.COLORS.ACCENT
            })
        end
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
    
    -- Title
    local titleFrame = Instance.new("Frame")
    titleFrame.Name = "TitleFrame"
    titleFrame.Size = UDim2.new(0, 400, 0, 40)
    titleFrame.Position = UDim2.new(0, 20, 0, 10)
    titleFrame.BackgroundTransparency = 1
    titleFrame.Parent = topBar

    local titleIcon = Utils.createIcon(titleFrame, CONFIG.ICONS.SPEED, 30, Vector2.new(0, 5), CONFIG.COLORS.TEXT_PRIMARY)
    titleIcon.Name = "TitleIcon"

    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 40, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "NatHub Character Controller"
    titleText.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    titleText.TextSize = 20
    titleText.Font = CONFIG.UI.FONT_BOLD
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleFrame
    
    -- Version
    local version = Instance.new("Frame")
    version.Size = UDim2.new(0, 50, 0, 25)
    version.Position = UDim2.new(0, 420, 0, 17.5)
    version.BackgroundColor3 = CONFIG.COLORS.SUCCESS
    version.BorderSizePixel = 0
    version.Parent = topBar
    
    Utils.applyCorners(version, 12)
    
    local versionText = Instance.new("TextLabel")
    versionText.Size = UDim2.new(1, 0, 1, 0)
    versionText.BackgroundTransparency = 1
    versionText.Text = "v3.1"
    versionText.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    versionText.TextSize = 12
    versionText.Font = CONFIG.UI.FONT_BOLD
    versionText.Parent = version
    
    -- Close button
    local closeBtn = Instance.new("ImageButton") -- Changed to ImageButton for icon support
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -50, 0, 10)
    closeBtn.BackgroundColor3 = CONFIG.COLORS.DANGER
    closeBtn.Image = CONFIG.ICONS.CLOSE -- Use Image ID for the icon
    closeBtn.ImageColor3 = CONFIG.COLORS.TEXT_PRIMARY
    closeBtn.BackgroundTransparency = 0
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = topBar
    
    Utils.applyCorners(closeBtn, 10)
    
    self.connections.closeBtn_Click = closeBtn.MouseButton1Click:Connect(function()
        self:hideUI()
        self:playSound("close")
    end)
    
    self.connections.closeBtn_MouseEnter = closeBtn.MouseEnter:Connect(function()
        if self.settings.animations then
            Utils.createTween(closeBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = CONFIG.COLORS.DANGER:lerp(Color3.new(1, 1, 1), 0.2)
            })
        end
    end)
    
    self.connections.closeBtn_MouseLeave = closeBtn.MouseLeave:Connect(function()
        if self.settings.animations then
            Utils.createTween(closeBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = CONFIG.COLORS.DANGER
            })
        end
    end)
    
    self.components.topBar = topBar
    self.components.closeBtn = closeBtn
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
    
    -- Menu items
    local menuItems = {
        {name = "Speed Control", icon = CONFIG.ICONS.SPEED, page = "Speed"},
        {name = "Jump Settings", icon = CONFIG.ICONS.JUMP, page = "Jump"}, 
        {name = "Information", icon = CONFIG.ICONS.INFO, page = "Info"},
        {name = "Settings", icon = CONFIG.ICONS.SETTINGS, page = "Settings"}
    }
    
    for i, item in ipairs(menuItems) do
        self:createMenuItem(sidebar, item, i)
        
        -- Add divider
        if i < #menuItems then
            local divider = Instance.new("Frame")
            divider.Size = UDim2.new(1, -40, 0, 1)
            divider.Position = UDim2.new(0, 20, 0, 15 + i * 70)
            divider.BackgroundColor3 = CONFIG.COLORS.BORDER
            divider.BorderSizePixel = 0
            divider.Parent = sidebar
        end
    end
    
    self.components.sidebar = sidebar
end

function NatHubController:createMenuItem(parent, item, index)
    local menuItem = Instance.new("TextButton")
    menuItem.Name = item.page .. "Button"
    menuItem.Size = UDim2.new(1, -20, 0, 55)
    menuItem.Position = UDim2.new(0, 10, 0, 15 + (index - 1) * 70)
    menuItem.BackgroundColor3 = self.currentPage == item.page and CONFIG.COLORS.SELECTED or Color3.fromRGB(0, 0, 0)
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
    
    -- Icon (using ImageLabel for better control over Image ID)
    local icon = Utils.createIcon(menuItem, item.icon, 35, Vector2.new(15, 10), self.currentPage == item.page and CONFIG.COLORS.ACCENT or CONFIG.COLORS.TEXT_SECONDARY)
    icon.Name = "Icon"
    
    -- Text
    local text = Instance.new("TextLabel")
    text.Name = "MenuText"
    text.Size = UDim2.new(1, -65, 1, 0)
    text.Position = UDim2.new(0, 60, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = item.name
    text.TextColor3 = self.currentPage == item.page and CONFIG.COLORS.TEXT_PRIMARY or CONFIG.COLORS.TEXT_SECONDARY
    text.TextSize = 16
    text.Font = CONFIG.UI.FONT -- Use the configured font
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = menuItem
    
    -- Events
    self.connections["menuItem_Click_" .. item.page] = menuItem.MouseButton1Click:Connect(function()
        self:switchPage(item.page)
        self:playSound("click")
    end)
    
    self.connections["menuItem_MouseEnter_" .. item.page] = menuItem.MouseEnter:Connect(function()
        if self.currentPage ~= item.page then
            self:playSound("hover")
            if self.settings.animations then
                Utils.createTween(menuItem, TweenInfo.new(0.3), {BackgroundTransparency = 0.7})
                Utils.createTween(icon, TweenInfo.new(0.3), {ImageColor3 = CONFIG.COLORS.TEXT_PRIMARY})
                Utils.createTween(text, TweenInfo.new(0.3), {TextColor3 = CONFIG.COLORS.TEXT_PRIMARY})
            end
        end
    end)
    
    self.connections["menuItem_MouseLeave_" .. item.page] = menuItem.MouseLeave:Connect(function()
        if self.currentPage ~= item.page then
            if self.settings.animations then
                Utils.createTween(menuItem, TweenInfo.new(0.3), {BackgroundTransparency = 1})
                Utils.createTween(icon, TweenInfo.new(0.3), {ImageColor3 = CONFIG.COLORS.TEXT_SECONDARY})
                Utils.createTween(text, TweenInfo.new(0.3), {TextColor3 = CONFIG.COLORS.TEXT_SECONDARY})
            end
        end
    end)
    
    -- Store references
    self.components[item.page .. "MenuItem"] = menuItem
    self.components[item.page .. "Icon"] = icon
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
    contentArea.CanvasSize = UDim2.new(0, 0, 0, 1000) -- Will be adjusted dynamically
    contentArea.ScrollingDirection = Enum.ScrollingDirection.Y
    contentArea.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    contentArea.Parent = parent
    
    -- Create pages
    self:createSpeedPage(contentArea)
    self:createJumpPage(contentArea)
    self:createInfoPage(contentArea)
    self:createSettingsPage(contentArea)

    self.components.contentArea = contentArea
    self:switchPage(self.currentPage) -- Initialize with the default page
end

-- ═══════════════════════════════════════════════════════════════
-- PAGE SPECIFIC UI CREATION
-- ═══════════════════════════════════════════════════════════════

function NatHubController:createPageFrame(parent, pageName)
    local pageFrame = Instance.new("Frame")
    pageFrame.Name = pageName .. "Page"
    pageFrame.Size = UDim2.new(1, 0, 1, 0)
    pageFrame.Position = UDim2.new(0, 0, 0, 0)
    pageFrame.BackgroundTransparency = 1
    pageFrame.BorderSizePixel = 0
    pageFrame.Visible = false -- Hidden by default
    pageFrame.Parent = parent
    self.pages[pageName] = pageFrame
    return pageFrame
end

function NatHubController:createSpeedPage(parent)
    local page = self:createPageFrame(parent, "Speed")
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, 20)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = page

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "Speed Control"
    title.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    title.TextSize = 24
    title.Font = CONFIG.UI.FONT_BOLD
    title.Parent = page

    -- Current Speed Display
    local currentSpeedDisplay = Instance.new("TextLabel")
    currentSpeedDisplay.Name = "CurrentSpeedDisplay"
    currentSpeedDisplay.Size = UDim2.new(1, 0, 0, 30)
    currentSpeedDisplay.BackgroundTransparency = 1
    currentSpeedDisplay.Text = "Current Speed: " .. self.currentSpeed
    currentSpeedDisplay.TextColor3 = CONFIG.COLORS.ACCENT
    currentSpeedDisplay.TextSize = 20
    currentSpeedDisplay.Font = CONFIG.UI.FONT
    currentSpeedDisplay.Parent = page
    self.components.currentSpeedDisplay = currentSpeedDisplay

    -- Speed Slider
    self:createAdvancedSlider(page, "WalkSpeed", CONFIG.SPEED.MIN, CONFIG.SPEED.MAX, self.currentSpeed, function(value)
        self.currentSpeed = value
        currentSpeedDisplay.Text = "Current Speed: " .. math.floor(value)
        if self.settings.autoApply then
            self:applySpeed(value)
        end
    end)

    -- Speed Input
    self:createSpeedInput(page, function(value)
        self.currentSpeed = value
        currentSpeedDisplay.Text = "Current Speed: " .. math.floor(value)
        self:applySpeed(value)
    end)

    -- Speed Presets
    self:createSpeedPresets(page, function(value)
        self.currentSpeed = value
        currentSpeedDisplay.Text = "Current Speed: " .. math.floor(value)
        self:applySpeed(value)
    end)

    -- Apply Button
    local applyBtn = Instance.new("TextButton")
    applyBtn.Name = "ApplySpeedButton"
    applyBtn.Size = UDim2.new(0.8, 0, 0, 45)
    applyBtn.BackgroundColor3 = CONFIG.COLORS.SUCCESS
    applyBtn.Text = "Apply Speed"
    applyBtn.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    applyBtn.TextSize = 18
    applyBtn.Font = CONFIG.UI.FONT_BOLD
    applyBtn.BorderSizePixel = 0
    applyBtn.Parent = page
    Utils.applyCorners(applyBtn, 10)

    self.connections.applySpeedBtn_Click = applyBtn.MouseButton1Click:Connect(function()
        self:applySpeed(self.currentSpeed)
        self:playSound("click")
        Utils.createTween(applyBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = CONFIG.COLORS.SUCCESS:lerp(Color3.new(1,1,1), 0.3)}, function()
            Utils.createTween(applyBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = CONFIG.COLORS.SUCCESS})
        end)
    end)

    self.connections.applySpeedBtn_MouseEnter = applyBtn.MouseEnter:Connect(function()
        self:playSound("hover")
        if self.settings.animations then
            Utils.createTween(applyBtn, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.SUCCESS:lerp(Color3.new(1,1,1), 0.1)})
        end
    end)

    self.connections.applySpeedBtn_MouseLeave = applyBtn.MouseLeave:Connect(function()
        if self.settings.animations then
            Utils.createTween(applyBtn, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.SUCCESS})
        end
    end)
end

function NatHubController:createJumpPage(parent)
    local page = self:createPageFrame(parent, "Jump")
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, 20)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = page

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "Jump Settings"
    title.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    title.TextSize = 24
    title.Font = CONFIG.UI.FONT_BOLD
    title.Parent = page

    -- Jump Power Display
    local currentJumpPowerDisplay = Instance.new("TextLabel")
    currentJumpPowerDisplay.Name = "CurrentJumpPowerDisplay"
    currentJumpPowerDisplay.Size = UDim2.new(1, 0, 0, 30)
    currentJumpPowerDisplay.BackgroundTransparency = 1
    currentJumpPowerDisplay.Text = "Jump Power: " .. self.currentJumpPower
    currentJumpPowerDisplay.TextColor3 = CONFIG.COLORS.ACCENT
    currentJumpPowerDisplay.TextSize = 20
    currentJumpPowerDisplay.Font = CONFIG.UI.FONT
    currentJumpPowerDisplay.Parent = page
    self.components.currentJumpPowerDisplay = currentJumpPowerDisplay

    -- Jump Power Slider
    self:createAdvancedSlider(page, "JumpPower", CONFIG.JUMP.POWER_MIN, CONFIG.JUMP.POWER_MAX, self.currentJumpPower, function(value)
        self.currentJumpPower = value
        currentJumpPowerDisplay.Text = "Jump Power: " .. math.floor(value)
        if self.settings.autoApply then
            self:applyJumpSettings()
        end
    end)

    -- Jump Height Display
    local currentJumpHeightDisplay = Instance.new("TextLabel")
    currentJumpHeightDisplay.Name = "CurrentJumpHeightDisplay"
    currentJumpHeightDisplay.Size = UDim2.new(1, 0, 0, 30)
    currentJumpHeightDisplay.BackgroundTransparency = 1
    currentJumpHeightDisplay.Text = "Jump Height: " .. string.format("%.1f", self.currentJumpHeight)
    currentJumpHeightDisplay.TextColor3 = CONFIG.COLORS.ACCENT
    currentJumpHeightDisplay.TextSize = 20
    currentJumpHeightDisplay.Font = CONFIG.UI.FONT
    currentJumpHeightDisplay.Parent = page
    self.components.currentJumpHeightDisplay = currentJumpHeightDisplay

    -- Jump Height Slider
    self:createAdvancedSlider(page, "JumpHeight", CONFIG.JUMP.HEIGHT_MIN, CONFIG.JUMP.HEIGHT_MAX, self.currentJumpHeight, function(value)
        self.currentJumpHeight = value
        currentJumpHeightDisplay.Text = "Jump Height: " .. string.format("%.1f", value)
        if self.settings.autoApply then
            self:applyJumpSettings()
        end
    end)

    -- Hip Height Display
    local currentHipHeightDisplay = Instance.new("TextLabel")
    currentHipHeightDisplay.Name = "CurrentHipHeightDisplay"
    currentHipHeightDisplay.Size = UDim2.new(1, 0, 0, 30)
    currentHipHeightDisplay.BackgroundTransparency = 1
    currentHipHeightDisplay.Text = "Hip Height: " .. string.format("%.1f", self.currentHipHeight)
    currentHipHeightDisplay.TextColor3 = CONFIG.COLORS.ACCENT
    currentHipHeightDisplay.TextSize = 20
    currentHipHeightDisplay.Font = CONFIG.UI.FONT
    currentHipHeightDisplay.Parent = page
    self.components.currentHipHeightDisplay = currentHipHeightDisplay

    -- Hip Height Slider
    self:createAdvancedSlider(page, "HipHeight", CONFIG.JUMP.HIP_HEIGHT_MIN, CONFIG.JUMP.HIP_HEIGHT_MAX, self.currentHipHeight, function(value)
        self.currentHipHeight = value
        currentHipHeightDisplay.Text = "Hip Height: " .. string.format("%.1f", value)
        if self.settings.autoApply then
            self:applyJumpSettings()
        end
    end)

    -- Apply Button
    local applyBtn = Instance.new("TextButton")
    applyBtn.Name = "ApplyJumpButton"
    applyBtn.Size = UDim2.new(0.8, 0, 0, 45)
    applyBtn.BackgroundColor3 = CONFIG.COLORS.SUCCESS
    applyBtn.Text = "Apply Jump Settings"
    applyBtn.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    applyBtn.TextSize = 18
    applyBtn.Font = CONFIG.UI.FONT_BOLD
    applyBtn.BorderSizePixel = 0
    applyBtn.Parent = page
    Utils.applyCorners(applyBtn, 10)

    self.connections.applyJumpBtn_Click = applyBtn.MouseButton1Click:Connect(function()
        self:applyJumpSettings()
        self:playSound("click")
        Utils.createTween(applyBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = CONFIG.COLORS.SUCCESS:lerp(Color3.new(1,1,1), 0.3)}, function()
            Utils.createTween(applyBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = CONFIG.COLORS.SUCCESS})
        end)
    end)

    self.connections.applyJumpBtn_MouseEnter = applyBtn.MouseEnter:Connect(function()
        self:playSound("hover")
        if self.settings.animations then
            Utils.createTween(applyBtn, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.SUCCESS:lerp(Color3.new(1,1,1), 0.1)})
        end
    end)

    self.connections.applyJumpBtn_MouseLeave = applyBtn.MouseLeave:Connect(function()
        if self.settings.animations then
            Utils.createTween(applyBtn, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.SUCCESS})
        end
    end)
end

function NatHubController:createInfoPage(parent)
    local page = self:createPageFrame(parent, "Info")
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, 15)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = page

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "Information & Stats"
    title.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    title.TextSize = 24
    title.Font = CONFIG.UI.FONT_BOLD
    title.Parent = page

    -- Player Info
    local playerInfoFrame = Instance.new("Frame")
    playerInfoFrame.Size = UDim2.new(0.9, 0, 0, 100)
    playerInfoFrame.BackgroundColor3 = CONFIG.COLORS.BACKGROUND:lerp(Color3.new(1,1,1), 0.05)
    playerInfoFrame.BorderSizePixel = 0
    playerInfoFrame.Parent = page
    Utils.applyCorners(playerInfoFrame, 10)

    local playerInfoLayout = Instance.new("UIListLayout")
    playerInfoLayout.FillDirection = Enum.FillDirection.Vertical
    playerInfoLayout.Padding = UDim.new(0, 5)
    playerInfoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    playerInfoLayout.Parent = playerInfoFrame

    local function createInfoText(parentFrame, textPrefix, initialValue, name)
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = name
        textLabel.Size = UDim2.new(1, -20, 0, 20)
        textLabel.Position = UDim2.new(0, 10, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = textPrefix .. initialValue
        textLabel.TextColor3 = CONFIG.COLORS.TEXT_SECONDARY
        textLabel.TextSize = 16
        textLabel.Font = CONFIG.UI.FONT
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Parent = parentFrame
        return textLabel
    end

    self.components.playerUsername = createInfoText(playerInfoFrame, "Username: ", self.player.Name, "UsernameText")
    self.components.playerUserId = createInfoText(playerInfoFrame, "User ID: ", self.player.UserId, "UserIdText")
    self.components.playerMembership = createInfoText(playerInfoFrame, "Membership: ", self.player.MembershipType.Name, "MembershipText")

    -- Performance Stats
    local perfStatsFrame = Instance.new("Frame")
    perfStatsFrame.Size = UDim2.new(0.9, 0, 0, 70)
    perfStatsFrame.BackgroundColor3 = CONFIG.COLORS.BACKGROUND:lerp(Color3.new(1,1,1), 0.05)
    perfStatsFrame.BorderSizePixel = 0
    perfStatsFrame.Parent = page
    Utils.applyCorners(perfStatsFrame, 10)

    local perfStatsLayout = Instance.new("UIListLayout")
    perfStatsLayout.FillDirection = Enum.FillDirection.Vertical
    perfStatsLayout.Padding = UDim.new(0, 5)
    perfStatsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    perfStatsLayout.Parent = perfStatsFrame

    self.components.fpsDisplay = createInfoText(perfStatsFrame, "FPS: ", self.stats.currentFPS, "FPSText")
    self.components.pingDisplay = createInfoText(perfStatsFrame, "Ping: ", "N/A", "PingText") -- Ping is harder to get accurately client-side

    -- Session Stats
    local sessionStatsFrame = Instance.new("Frame")
    sessionStatsFrame.Size = UDim2.new(0.9, 0, 0, 100)
    sessionStatsFrame.BackgroundColor3 = CONFIG.COLORS.BACKGROUND:lerp(Color3.new(1,1,1), 0.05)
    sessionStatsFrame.BorderSizePixel = 0
    sessionStatsFrame.Parent = page
    Utils.applyCorners(sessionStatsFrame, 10)

    local sessionStatsLayout = Instance.new("UIListLayout")
    sessionStatsLayout.FillDirection = Enum.FillDirection.Vertical
    sessionStatsLayout.Padding = UDim.new(0, 5)
    sessionStatsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    sessionStatsLayout.Parent = sessionStatsFrame

    self.components.sessionTime = createInfoText(sessionStatsFrame, "Session Time: ", "0s", "SessionTimeText")
    self.components.speedChanges = createInfoText(sessionStatsFrame, "Speed Changes: ", self.stats.speedChanges, "SpeedChangesText")
    self.components.jumpChanges = createInfoText(sessionStatsFrame, "Jump Changes: ", self.stats.jumpChanges, "JumpChangesText")
end

function NatHubController:createSettingsPage(parent)
    local page = self:createPageFrame(parent, "Settings")
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, 20)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = page

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "Settings"
    title.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    title.TextSize = 24
    title.Font = CONFIG.UI.FONT_BOLD
    title.Parent = page

    -- Sound Toggle
    self:createToggle(page, "Sound Effects", self.settings.soundEnabled, function(value)
        self.settings.soundEnabled = value
        self:saveSettings()
    end, "soundToggle")

    -- Auto Apply Toggle
    self:createToggle(page, "Auto Apply Changes", self.settings.autoApply, function(value)
        self.settings.autoApply = value
        self:saveSettings()
    end, "autoApplyToggle")

    -- Save Settings Toggle
    self:createToggle(page, "Save Settings (Persistent)", self.settings.saveSettings, function(value)
        self.settings.saveSettings = value
        self:saveSettings()
    end, "saveSettingsToggle")

    -- Animations Toggle
    self:createToggle(page, "UI Animations", self.settings.animations, function(value)
        self.settings.animations = value
        self:saveSettings()
    end, "animationsToggle")

    -- Keybind Selector (Advanced Feature)
    self:createKeybindSelector(page, "Toggle Keybind", self.settings.keybind, function(newKeybind)
        self.settings.keybind = newKeybind
        self:saveSettings()
        print("Keybind updated to: " .. newKeybind.Name)
        self.components.toggleButton.Text = "Press " .. newKeybind.Name .. " to open"
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- UI COMPONENTS
-- ═══════════════════════════════════════════════════════════════

function NatHubController:createAdvancedSlider(parent, name, min, max, defaultValue, onChangeCallback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name .. "SliderFrame"
    sliderFrame.Size = UDim2.new(0.9, 0, 0, 70)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = name .. ": " .. math.floor(defaultValue)
    title.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    title.TextSize = 18
    title.Font = CONFIG.UI.FONT
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = sliderFrame
    self.components[name .. "SliderTitle"] = title

    local sliderBackground = Instance.new("Frame")
    sliderBackground.Name = "SliderBackground"
    sliderBackground.Size = UDim2.new(1, 0, 0, 10)
    sliderBackground.Position = UDim2.new(0, 0, 0, 30)
    sliderBackground.BackgroundColor3 = CONFIG.COLORS.BORDER
    sliderBackground.BorderSizePixel = 0
    sliderBackground.Parent = sliderFrame
    Utils.applyCorners(sliderBackground, 5)

    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = CONFIG.COLORS.ACCENT
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBackground
    Utils.applyCorners(sliderFill, 5)
    self.components[name .. "SliderFill"] = sliderFill

    local sliderHandle = Instance.new("ImageLabel") -- Changed to ImageLabel for better visual
    sliderHandle.Name = "SliderHandle"
    sliderHandle.Size = UDim2.new(0, 20, 0, 20)
    sliderHandle.Position = UDim2.new((defaultValue - min) / (max - min), -10, 0, 25)
    sliderHandle.BackgroundColor3 = CONFIG.COLORS.ACCENT_HOVER
    sliderHandle.Image = "rbxassetid://1234567898" -- Placeholder for a handle icon
    sliderHandle.ImageColor3 = CONFIG.COLORS.TEXT_PRIMARY
    sliderHandle.BackgroundTransparency = 0
    sliderHandle.BorderSizePixel = 0
    sliderHandle.ZIndex = 2
    sliderHandle.Parent = sliderFrame
    Utils.applyCorners(sliderHandle, 10)
    self.components[name .. "SliderHandle"] = sliderHandle

    local isDragging = false
    local currentConnection

    local function updateSlider(input)
        local mouseX = input.Position.X - sliderBackground.AbsolutePosition.X
        local percentage = math.clamp(mouseX / sliderBackground.AbsoluteSize.X, 0, 1)
        local value = min + (max - min) * percentage
        value = math.floor(value * 10 + 0.5) / 10 -- Round to one decimal place

        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderHandle.Position = UDim2.new(percentage, -10, 0, 25)
        title.Text = name .. ": " .. (name == "JumpHeight" or name == "HipHeight" and string.format("%.1f", value) or math.floor(value))
        onChangeCallback(value)
    end

    self.connections[name .. "SliderHandle_MouseDown"] = sliderHandle.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            self:playSound("click")
            currentConnection = UserInputService.InputChanged:Connect(function(inputChanged)
                if isDragging and inputChanged.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(inputChanged)
                end
            end)
        end
    end)

    self.connections[name .. "SliderHandle_MouseUp"] = UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
            if currentConnection then
                currentConnection:Disconnect()
                currentConnection = nil
            end
        end
    end)

    self.connections[name .. "SliderBackground_Click"] = sliderBackground.MouseButton1Click:Connect(function(x, y, input)
        updateSlider(input)
        self:playSound("click")
    end)

    -- Hover effects for handle
    self.connections[name .. "SliderHandle_MouseEnter"] = sliderHandle.MouseEnter:Connect(function()
        self:playSound("hover")
        if self.settings.animations then
            Utils.createTween(sliderHandle, TweenInfo.new(0.1), {Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(sliderHandle.Position.X.Scale, -12, 0, 23)})
        end
    end)

    self.connections[name .. "SliderHandle_MouseLeave"] = sliderHandle.MouseLeave:Connect(function()
        if self.settings.animations then
            Utils.createTween(sliderHandle, TweenInfo.new(0.1), {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(sliderHandle.Position.X.Scale, -10, 0, 25)})
        end
    end)
end

function NatHubController:createSpeedInput(parent, onChangeCallback)
    local inputFrame = Instance.new("Frame")
    inputFrame.Name = "SpeedInputFrame"
    inputFrame.Size = UDim2.new(0.9, 0, 0, 40)
    inputFrame.BackgroundTransparency = 1
    inputFrame.Parent = parent

    local inputTextBox = Instance.new("TextBox")
    inputTextBox.Name = "SpeedTextBox"
    inputTextBox.Size = UDim2.new(0.6, 0, 1, 0)
    inputTextBox.PlaceholderText = "Enter Speed"
    inputTextBox.Text = tostring(self.currentSpeed)
    inputTextBox.BackgroundColor3 = CONFIG.COLORS.BACKGROUND:lerp(Color3.new(1,1,1), 0.1)
    inputTextBox.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    inputTextBox.TextSize = 16
    inputTextBox.Font = CONFIG.UI.FONT
    inputTextBox.ClearTextOnFocus = true
    inputTextBox.BorderSizePixel = 0
    inputTextBox.Parent = inputFrame
    Utils.applyCorners(inputTextBox, 5)

    local applyButton = Instance.new("TextButton")
    applyButton.Name = "InputApplyButton"
    applyButton.Size = UDim2.new(0.35, 0, 1, 0)
    applyButton.Position = UDim2.new(0.65, 0, 0, 0)
    applyButton.BackgroundColor3 = CONFIG.COLORS.ACCENT
    applyButton.Text = "Set"
    applyButton.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    applyButton.TextSize = 16
    applyButton.Font = CONFIG.UI.FONT_BOLD
    applyButton.BorderSizePixel = 0
    applyButton.Parent = inputFrame
    Utils.applyCorners(applyButton, 5)

    local function applyInput()
        local value = Utils.validateNumber(inputTextBox.Text, CONFIG.SPEED.MIN, CONFIG.SPEED.MAX, self.currentSpeed)
        inputTextBox.Text = tostring(math.floor(value))
        onChangeCallback(value)
        self:playSound("click")
    end

    self.connections.speedInput_FocusLost = inputTextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            applyInput()
        end
    end)

    self.connections.speedInput_ApplyBtn = applyButton.MouseButton1Click:Connect(applyInput)

    self.connections.speedInput_MouseEnter = applyButton.MouseEnter:Connect(function()
        self:playSound("hover")
        if self.settings.animations then
            Utils.createTween(applyButton, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.ACCENT_HOVER})
        end
    end)

    self.connections.speedInput_MouseLeave = applyButton.MouseLeave:Connect(function()
        if self.settings.animations then
            Utils.createTween(applyButton, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.ACCENT})
        end
    end)
end

function NatHubController:createSpeedPresets(parent, onPresetSelectedCallback)
    local presetsFrame = Instance.new("Frame")
    presetsFrame.Name = "SpeedPresetsFrame"
    presetsFrame.Size = UDim2.new(0.9, 0, 0, 50)
    presetsFrame.BackgroundTransparency = 1
    presetsFrame.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = presetsFrame

    for _, presetValue in ipairs(CONFIG.SPEED.PRESETS) do
        local presetButton = Instance.new("TextButton")
        presetButton.Name = "Preset" .. presetValue
        presetButton.Size = UDim2.new(0.2, 0, 1, 0)
        presetButton.BackgroundColor3 = CONFIG.COLORS.HOVER
        presetButton.Text = tostring(presetValue)
        presetButton.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
        presetButton.TextSize = 16
        presetButton.Font = CONFIG.UI.FONT_BOLD
        presetButton.BorderSizePixel = 0
        presetButton.Parent = presetsFrame
        Utils.applyCorners(presetButton, 5)

        self.connections["presetBtn_Click_" .. presetValue] = presetButton.MouseButton1Click:Connect(function()
            onPresetSelectedCallback(presetValue)
            self:playSound("click")
            Utils.createTween(presetButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = CONFIG.COLORS.ACCENT}, function()
                Utils.createTween(presetButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = CONFIG.COLORS.HOVER})
            end)
        end)

        self.connections["presetBtn_MouseEnter_" .. presetValue] = presetButton.MouseEnter:Connect(function()
            self:playSound("hover")
            if self.settings.animations then
                Utils.createTween(presetButton, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.ACCENT_HOVER})
            end
        end)

        self.connections["presetBtn_MouseLeave_" .. presetValue] = presetButton.MouseLeave:Connect(function()
            if self.settings.animations then
                Utils.createTween(presetButton, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.HOVER})
            end
        end)
    end
end

function NatHubController:createToggle(parent, text, defaultValue, onChangeCallback, namePrefix)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = namePrefix .. "ToggleFrame"
    toggleFrame.Size = UDim2.new(0.9, 0, 0, 40)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent

    local toggleText = Instance.new("TextLabel")
    toggleText.Size = UDim2.new(0.7, 0, 1, 0)
    toggleText.BackgroundTransparency = 1
    toggleText.Text = text
    toggleText.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    toggleText.TextSize = 18
    toggleText.Font = CONFIG.UI.FONT
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    toggleText.Parent = toggleFrame

    local toggleButton = Instance.new("ImageButton") -- Changed to ImageButton for icon support
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 40, 0, 25)
    toggleButton.Position = UDim2.new(0.75, 0, 0, 7.5)
    toggleButton.BackgroundColor3 = defaultValue and CONFIG.COLORS.SUCCESS or CONFIG.COLORS.BORDER
    toggleButton.Image = defaultValue and CONFIG.ICONS.CHECK or CONFIG.ICONS.UNCHECK -- Use Image IDs for check/uncheck
    toggleButton.ImageColor3 = CONFIG.COLORS.TEXT_PRIMARY
    toggleButton.BackgroundTransparency = 0
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    Utils.applyCorners(toggleButton, 12)

    local currentValue = defaultValue

    local function updateToggleVisual(value)
        if self.settings.animations then
            Utils.createTween(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = value and CONFIG.COLORS.SUCCESS or CONFIG.COLORS.BORDER})
        else
            toggleButton.BackgroundColor3 = value and CONFIG.COLORS.SUCCESS or CONFIG.COLORS.BORDER
        end
        toggleButton.Image = value and CONFIG.ICONS.CHECK or CONFIG.ICONS.UNCHECK
    end

    self.connections[namePrefix .. "Toggle_Click"] = toggleButton.MouseButton1Click:Connect(function()
        currentValue = not currentValue
        updateToggleVisual(currentValue)
        onChangeCallback(currentValue)
        self:playSound(currentValue and "toggleOn" or "toggleOff")
    end)

    self.connections[namePrefix .. "Toggle_MouseEnter"] = toggleButton.MouseEnter:Connect(function()
        self:playSound("hover")
        if self.settings.animations then
            Utils.createTween(toggleButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.2})
        end
    end)

    self.connections[namePrefix .. "Toggle_MouseLeave"] = toggleButton.MouseLeave:Connect(function()
        if self.settings.animations then
            Utils.createTween(toggleButton, TweenInfo.new(0.2), {BackgroundTransparency = 0})
        end
    end)
end

function NatHubController:createKeybindSelector(parent, text, defaultValue, onChangeCallback)
    local keybindFrame = Instance.new("Frame")
    keybindFrame.Name = "KeybindSelectorFrame"
    keybindFrame.Size = UDim2.new(0.9, 0, 0, 40)
    keybindFrame.BackgroundTransparency = 1
    keybindFrame.Parent = parent

    local keybindText = Instance.new("TextLabel")
    keybindText.Size = UDim2.new(0.7, 0, 1, 0)
    keybindText.BackgroundTransparency = 1
    keybindText.Text = text
    keybindText.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    keybindText.TextSize = 18
    keybindText.Font = CONFIG.UI.FONT
    keybindText.TextXAlignment = Enum.TextXAlignment.Left
    keybindText.Parent = keybindFrame

    local keybindButton = Instance.new("TextButton")
    keybindButton.Name = "KeybindButton"
    keybindButton.Size = UDim2.new(0.35, 0, 1, 0)
    keybindButton.Position = UDim2.new(0.65, 0, 0, 0)
    keybindButton.BackgroundColor3 = CONFIG.COLORS.HOVER
    keybindButton.Text = defaultValue.Name
    keybindButton.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
    keybindButton.TextSize = 16
    keybindButton.Font = CONFIG.UI.FONT_BOLD
    keybindButton.BorderSizePixel = 0
    keybindButton.Parent = keybindFrame
    Utils.applyCorners(keybindButton, 5)

    local listeningForKey = false

    self.connections.keybindBtn_Click = keybindButton.MouseButton1Click:Connect(function()
        if not listeningForKey then
            listeningForKey = true
            keybindButton.Text = "Press a key..."
            keybindButton.BackgroundColor3 = CONFIG.COLORS.WARNING
            self:playSound("click")

            local inputConnection
            inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    listeningForKey = false
                    keybindButton.Text = input.KeyCode.Name
                    keybindButton.BackgroundColor3 = CONFIG.COLORS.HOVER
                    onChangeCallback(input.KeyCode)
                    self:playSound("click")
                    inputConnection:Disconnect()
                end
            end)
        end
    end)

    self.connections.keybindBtn_MouseEnter = keybindButton.MouseEnter:Connect(function()
        self:playSound("hover")
        if self.settings.animations and not listeningForKey then
            Utils.createTween(keybindButton, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.ACCENT_HOVER})
        end
    end)

    self.connections.keybindBtn_MouseLeave = keybindButton.MouseLeave:Connect(function()
        if self.settings.animations and not listeningForKey then
            Utils.createTween(keybindButton, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.HOVER})
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- EVENT HANDLING
-- ═══════════════════════════════════════════════════════════════

function NatHubController:setupEvents()
    self.connections.inputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == self.settings.keybind then
            self:toggleUI()
        end
    end)

    self.connections.playerAdded = Players.PlayerAdded:Connect(function(player)
        -- Handle new players if needed (e.g., load settings for them)
    end)

    self.connections.playerRemoving = Players.PlayerRemoving:Connect(function(player)
        if player == self.player then
            self:saveSettings() -- Save settings when player leaves
            self:cleanup()
        end
    end)
end

function NatHubController:startUpdateLoop()
    self.connections.renderStepped = RunService.RenderStepped:Connect(function()
        -- Update FPS
        self.stats.frameCount = self.stats.frameCount + 1
        local currentTime = tick()
        if currentTime - self.stats.lastFPSUpdate >= 1 then
            self.stats.currentFPS = self.stats.frameCount / (currentTime - self.stats.lastFPSUpdate)
            if self.components.fpsDisplay then
                self.components.fpsDisplay.Text = "FPS: " .. math.floor(self.stats.currentFPS)
            end
            self.stats.frameCount = 0
            self.stats.lastFPSUpdate = currentTime
        end

        -- Update Session Time
        if self.components.sessionTime then
            local elapsed = math.floor(currentTime - self.stats.sessionStart)
            local minutes = math.floor(elapsed / 60)
            local seconds = elapsed % 60
            self.components.sessionTime.Text = string.format("Session Time: %02d:%02d", minutes, seconds)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- CHARACTER HANDLING
-- ═══════════════════════════════════════════════════════════════

function NatHubController:setupCharacterHandling()
    local function onCharacterAdded(character)
        local humanoid = character:WaitForChild("Humanoid")
        self.connections.humanoidDied = humanoid.Died:Connect(function()
            -- Reset settings or handle death if needed
        end)
        -- Update initial HipHeight from the character's humanoid
        self.currentHipHeight = humanoid.HipHeight
        if self.components.currentHipHeightDisplay then
            self.components.currentHipHeightDisplay.Text = "Hip Height: " .. string.format("%.1f", self.currentHipHeight)
        end
        self:applySpeed(self.currentSpeed) -- Apply initial speed
        self:applyJumpSettings() -- Apply initial jump settings
    end

    if self.player.Character then
        onCharacterAdded(self.player.Character)
    end
    self.connections.characterAdded = self.player.CharacterAdded:Connect(onCharacterAdded)
end

function NatHubController:applySpeed(speed)
    local character = self.player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
            self.stats.speedChanges = self.stats.speedChanges + 1
            if self.components.speedChanges then
                self.components.speedChanges.Text = "Speed Changes: " .. self.stats.speedChanges
            end
        end
    end
end

function NatHubController:applyJumpSettings()
    local character = self.player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = self.currentJumpPower
            humanoid.JumpHeight = self.currentJumpHeight
            humanoid.HipHeight = self.currentHipHeight
            self.stats.jumpChanges = self.stats.jumpChanges + 1
            if self.components.jumpChanges then
                self.components.jumpChanges.Text = "Jump Changes: " .. self.stats.jumpChanges
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════
-- UI ANIMATIONS & VISIBILITY
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
    self:playSound("open")
    local mainFrame = self.components.mainFrame
    if self.settings.animations then
        Utils.createTween(mainFrame, TweenInfo.new(CONFIG.UI.ANIMATION_SPEED, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -CONFIG.UI.MAIN_SIZE.X/2, 0.5, -CONFIG.UI.MAIN_SIZE.Y/2)
        })
    else
        mainFrame.Position = UDim2.new(0.5, -CONFIG.UI.MAIN_SIZE.X/2, 0.5, -CONFIG.UI.MAIN_SIZE.Y/2)
    end
    self.components.toggleButton.Visible = false -- Hide toggle button when UI is open
end

function NatHubController:hideUI()
    if not self.isVisible then return end
    self.isVisible = false
    self:playSound("close")
    local mainFrame = self.components.mainFrame
    if self.settings.animations then
        Utils.createTween(mainFrame, TweenInfo.new(CONFIG.UI.ANIMATION_SPEED, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -CONFIG.UI.MAIN_SIZE.X/2, -1, 0)
        }, function()
            self.components.toggleButton.Visible = true -- Show toggle button when UI is closed
        end)
    else
        mainFrame.Position = UDim2.new(0.5, -CONFIG.UI.MAIN_SIZE.X/2, -1, 0)
        self.components.toggleButton.Visible = true
    end
end

function NatHubController:switchPage(pageName)
    if self.currentPage == pageName then return end

    -- Animate out current page
    local currentPageFrame = self.pages[self.currentPage]
    if currentPageFrame and self.settings.animations then
        Utils.createTween(currentPageFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1, Position = UDim2.new(-1, 0, 0, 0)}, function()
            currentPageFrame.Visible = false
            currentPageFrame.Position = UDim2.new(0,0,0,0) -- Reset position for next time
        end)
    elseif currentPageFrame then
        currentPageFrame.Visible = false
    end

    -- Update sidebar selection visuals
    if self.components[self.currentPage .. "MenuItem"] then
        local oldMenuItem = self.components[self.currentPage .. "MenuItem"]
        local oldIcon = self.components[self.currentPage .. "Icon"]
        local oldText = self.components[self.currentPage .. "Text"]
        local oldIndicator = self.components[self.currentPage .. "Indicator"]

        if self.settings.animations then
            Utils.createTween(oldMenuItem, TweenInfo.new(0.2), {BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(0,0,0)})
            Utils.createTween(oldIcon, TweenInfo.new(0.2), {ImageColor3 = CONFIG.COLORS.TEXT_SECONDARY})
            Utils.createTween(oldText, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.TEXT_SECONDARY})
            Utils.createTween(oldIndicator, TweenInfo.new(0.2), {Size = UDim2.new(0,0,0.8,0)})
        else
            oldMenuItem.BackgroundTransparency = 1
            oldMenuItem.BackgroundColor3 = Color3.fromRGB(0,0,0)
            oldIcon.ImageColor3 = CONFIG.COLORS.TEXT_SECONDARY
            oldText.TextColor3 = CONFIG.COLORS.TEXT_SECONDARY
            oldIndicator.Size = UDim2.new(0,0,0.8,0)
        end
        oldIndicator.Visible = false
    end

    self.currentPage = pageName

    -- Animate in new page
    local newPageFrame = self.pages[pageName]
    if newPageFrame then
        newPageFrame.Visible = true
        if self.settings.animations then
            newPageFrame.Position = UDim2.new(1, 0, 0, 0) -- Start off-screen to the right
            Utils.createTween(newPageFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 0)})
        else
            newPageFrame.Position = UDim2.new(0,0,0,0)
        end
    end

    -- Update new sidebar selection visuals
    if self.components[pageName .. "MenuItem"] then
        local newMenuItem = self.components[pageName .. "MenuItem"]
        local newIcon = self.components[pageName .. "Icon"]
        local newText = self.components[pageName .. "Text"]
        local newIndicator = self.components[pageName .. "Indicator"]

        if self.settings.animations then
            Utils.createTween(newMenuItem, TweenInfo.new(0.2), {BackgroundTransparency = 0, BackgroundColor3 = CONFIG.COLORS.SELECTED})
            Utils.createTween(newIcon, TweenInfo.new(0.2), {ImageColor3 = CONFIG.COLORS.ACCENT})
            Utils.createTween(newText, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.TEXT_PRIMARY})
            newIndicator.Visible = true
            Utils.createTween(newIndicator, TweenInfo.new(0.2), {Size = UDim2.new(0,4,0.8,0)})
        else
            newMenuItem.BackgroundTransparency = 0
            newMenuItem.BackgroundColor3 = CONFIG.COLORS.SELECTED
            newIcon.ImageColor3 = CONFIG.COLORS.ACCENT
            newText.TextColor3 = CONFIG.COLORS.TEXT_PRIMARY
            newIndicator.Visible = true
            newIndicator.Size = UDim2.new(0,4,0.8,0)
        end
    end

    -- Adjust content area canvas size based on current page content
    task.spawn(function()
        task.wait(0.1) -- Give UI a moment to render
        if newPageFrame then
            local contentHeight = newPageFrame.AbsoluteContentSize.Y
            self.components.contentArea.CanvasSize = UDim2.new(0, 0, 0, math.max(contentHeight + 50, self.components.contentArea.AbsoluteSize.Y))
        end
    end)
end

function NatHubController:playSound(soundName)
    if self.settings.soundEnabled and self.sounds[soundName] then
        self.sounds[soundName]:Play()
    end
end

function NatHubController:makeDraggable(frame)
    local dragStart
    local startPosition

    self.connections.dragInputBegan = frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.isDragging = true
            dragStart = input.Position
            startPosition = frame.Position

            self.connections.dragInputChanged = UserInputService.InputChanged:Connect(function(inputChanged)
                if self.isDragging and (inputChanged.UserInputType == Enum.UserInputType.MouseMovement or inputChanged.UserInputType == Enum.UserInputType.Touch) then
                    local delta = inputChanged.Position - dragStart
                    local newX = startPosition.X.Offset + delta.X
                    local newY = startPosition.Y.Offset + delta.Y

                    -- Clamp to screen bounds
                    local maxX = self.playerGui.AbsoluteSize.X - frame.AbsoluteSize.X
                    local maxY = self.playerGui.AbsoluteSize.Y - frame.AbsoluteSize.Y

                    newX = math.clamp(newX, 0, maxX)
                    newY = math.clamp(newY, 0, maxY)

                    frame.Position = UDim2.new(0, newX, 0, newY)
                end
            end)
        end
    end)

    self.connections.dragInputEnded = frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.isDragging = false
            if self.connections.dragInputChanged then
                self.connections.dragInputChanged:Disconnect()
                self.connections.dragInputChanged = nil
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- DATA PERSISTENCE (SETTINGS)
-- ═══════════════════════════════════════════════════════════════

function NatHubController:loadSettings()
    if not self.settings.saveSettings then return end
    local settingsStore = DataStoreService:GetDataStore("NatHubSettings_" .. self.player.UserId)
    local success, loadedData = pcall(function()
        return settingsStore:GetAsync("user_settings")
    end)

    if success and loadedData then
        for k, v in pairs(loadedData) do
            if self.settings[k] ~= nil then -- Only load known settings
                if k == "keybind" and type(v) == "string" then
                    -- Convert string back to Enum.KeyCode
                    local success, keyCode = pcall(function() return Enum.KeyCode[v] end)
                    if success and keyCode then
                        self.settings[k] = keyCode
                    else
                        warn("Failed to load keybind: " .. v)
                    end
                else
                    self.settings[k] = v
                end
            end
        end
        print("Settings loaded successfully!")
    else
        warn("Failed to load settings or no settings found: ", loadedData)
    end
end

function NatHubController:saveSettings()
    if not self.settings.saveSettings then return end
    local settingsStore = DataStoreService:GetDataStore("NatHubSettings_" .. self.player.UserId)
    local dataToSave = {}
    for k, v in pairs(self.settings) do
        if k == "keybind" then
            dataToSave[k] = v.Name -- Save KeyCode as string
        else
            dataToSave[k] = v
        end
    end

    local success, err = pcall(function()
        settingsStore:SetAsync("user_settings", dataToSave)
    end)

    if success then
        print("Settings saved successfully!")
    else
        warn("Failed to save settings: ", err)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- CLEANUP
-- ═══════════════════════════════════════════════════════════════

function NatHubController:cleanup()
    -- Disconnect all connections
    for _, connection in pairs(self.connections) do
        if connection and typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    self.connections = {}

    -- Stop all tweens
    for _, tween in pairs(self.tweens) do
        if tween and typeof(tween) == "Tween" then
            tween:Cancel()
        end
    end
    self.tweens = {}

    -- Destroy UI
    if self.components.screenGui then
        self.components.screenGui:Destroy()
    end
    self.components = {}

    -- Destroy sounds
    for _, sound in pairs(self.sounds) do
        if sound and typeof(sound) == "Sound" then
            sound:Destroy()
        end
    end
    self.sounds = {}

    print("NatHub Character Controller cleaned up.")
end

-- ═══════════════════════════════════════════════════════════════
-- INITIALIZATION
-- ═══════════════════════════════════════════════════════════════

local controller = NatHubController.new()

-- Optional: Add a game.Players.PlayerRemoving event to call controller:cleanup() if the script is not a LocalScript
-- For a LocalScript, the cleanup will happen automatically when the player leaves.

```

