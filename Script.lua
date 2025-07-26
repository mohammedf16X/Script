-- ========================================
-- 🌱 ULTIMATE GROW A GARDEN SCRIPT 🌱
-- ⚡ Fixed and Working Version ⚡
-- ========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for game to load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

wait(2)

-- ========================================
-- 🎨 THEME COLORS
-- ========================================

local Colors = {
    Background = Color3.fromRGB(20, 20, 25),
    Secondary = Color3.fromRGB(30, 30, 40),
    Accent = Color3.fromRGB(0, 200, 100),
    Success = Color3.fromRGB(40, 200, 80),
    Warning = Color3.fromRGB(255, 200, 50),
    Error = Color3.fromRGB(255, 80, 80),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(60, 60, 80)
}

-- ========================================
-- 📱 DEVICE DETECTION
-- ========================================

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ========================================
-- 💾 SCRIPT VARIABLES
-- ========================================

local ScriptData = {
    version = "4.0.0",
    isVisible = false,
    playerSpeed = 100,
    stats = {
        itemsBought = 0,
        startTime = tick()
    }
}

local IsActive = {
    speed = false,
    seeds = {},
    gear = {},
    pets = {}
}

local Loops = {
    seeds = {},
    gear = {},
    pets = {}
}

-- ========================================
-- 🌱 GAME ITEMS DATA
-- ========================================

local Items = {
    seeds = {
        "Carrot", "Lettuce", "Potato", "Tomato", "Onion", "Cabbage", "Corn", "Wheat",
        "Radish", "Beetroot", "Spinach", "Broccoli", "Cauliflower", "Cucumber", "Pumpkin",
        "Watermelon", "Strawberry", "Blueberry", "Raspberry", "Blackberry", "Cherry",
        "Apple", "Orange", "Banana", "Grape", "Lemon", "Lime", "Peach", "Pear", "Plum",
        "Dragon Pepper", "Moon Mango", "Maple Apple", "Crystal Berry", "Golden Wheat",
        "Diamond Carrot", "Ruby Tomato", "Emerald Lettuce", "Sapphire Grape"
    },
    
    gear = {
        "Watering Can", "Advanced Watering Can", "Premium Watering Can", "Golden Watering Can",
        "Diamond Watering Can", "Crystal Watering Can", "Master Watering Can", "Godly Watering Can",
        "Basic Sprinkler", "Advanced Sprinkler", "Premium Sprinkler", "Golden Sprinkler",
        "Diamond Sprinkler", "Crystal Sprinkler", "Master Sprinkler", "Godly Sprinkler",
        "Shovel", "Advanced Shovel", "Premium Shovel", "Golden Shovel", "Diamond Shovel",
        "Crystal Shovel", "Master Shovel", "Godly Shovel", "Hoe", "Advanced Hoe",
        "Premium Hoe", "Golden Hoe", "Diamond Hoe", "Crystal Hoe", "Master Hoe", "Godly Hoe"
    },
    
    pets = {
        "Common Egg", "Basic Egg", "Starter Egg", "Simple Egg", "Regular Egg",
        "Uncommon Egg", "Enhanced Egg", "Improved Egg", "Better Egg", "Superior Egg",
        "Rare Egg", "Rare Summer Egg", "Rare Winter Egg", "Rare Spring Egg", "Rare Autumn Egg",
        "Epic Egg", "Epic Fire Egg", "Epic Water Egg", "Epic Earth Egg", "Epic Air Egg",
        "Legendary Egg", "Legendary Dragon Egg", "Legendary Phoenix Egg", "Legendary Unicorn Egg",
        "Mythical Egg", "Mythical Celestial Egg", "Mythical Cosmic Egg", "Mythical Divine Egg",
        "Golden Egg", "Silver Egg", "Diamond Egg", "Platinum Egg", "Crystal Egg"
    }
}

-- ========================================
-- 🛒 BUYING FUNCTIONS
-- ========================================

local function buySeed(seedName)
    pcall(function()
        local args = {[1] = seedName}
        ReplicatedStorage.GameEvents.BuySeedStock:FireServer(unpack(args))
        ScriptData.stats.itemsBought = ScriptData.stats.itemsBought + 1
    end)
end

local function buyGear(gearName)
    pcall(function()
        local args = {[1] = gearName}
        ReplicatedStorage.GameEvents.BuyGearStock:FireServer(unpack(args))
        ScriptData.stats.itemsBought = ScriptData.stats.itemsBought + 1
    end)
end

local function buyPetEgg(eggName)
    pcall(function()
        local args = {[1] = eggName}
        ReplicatedStorage.GameEvents.BuyPetEgg:FireServer(unpack(args))
        ScriptData.stats.itemsBought = ScriptData.stats.itemsBought + 1
    end)
end

-- ========================================
-- 🎨 UI HELPER FUNCTIONS
-- ========================================

local function addRoundCorners(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = obj
end

local function addBorder(obj, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Colors.Border
    stroke.Thickness = thickness or 1
    stroke.Parent = obj
end

local function addGradient(obj, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    }
    gradient.Rotation = rotation or 0
    gradient.Parent = obj
end

-- ========================================
-- 📱 MOBILE SHORTCUT BUTTON
-- ========================================

local function createShortcutButton()
    -- Remove existing shortcut
    if CoreGui:FindFirstChild("GrowGardenShortcut") then
        CoreGui:FindFirstChild("GrowGardenShortcut"):Destroy()
    end
    
    local shortcutGui = Instance.new("ScreenGui")
    shortcutGui.Name = "GrowGardenShortcut"
    shortcutGui.Parent = CoreGui
    shortcutGui.ResetOnSpawn = false
    
    local shortcutButton = Instance.new("TextButton")
    shortcutButton.Name = "ShortcutButton"
    shortcutButton.Parent = shortcutGui
    shortcutButton.Size = UDim2.new(0, 70, 0, 70)
    shortcutButton.Position = UDim2.new(0, 20, 0.3, 0)
    shortcutButton.BackgroundColor3 = Colors.Accent
    shortcutButton.BorderSizePixel = 0
    shortcutButton.Text = "🌱"
    shortcutButton.TextColor3 = Colors.Text
    shortcutButton.TextSize = 28
    shortcutButton.Font = Enum.Font.GothamBold
    shortcutButton.Active = true
    shortcutButton.Draggable = true
    
    addRoundCorners(shortcutButton, 35)
    addBorder(shortcutButton, Colors.Border, 2)
    
    -- Glow effect
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Parent = shortcutButton
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = Colors.Accent
    glow.ImageTransparency = 0.5
    glow.ZIndex = -1
    
    -- Pulse animation
    spawn(function()
        while shortcutButton.Parent do
            local tween = TweenService:Create(shortcutButton, 
                TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), 
                {Size = UDim2.new(0, 75, 0, 75)}
            )
            tween:Play()
            wait(1)
        end
    end)
    
    return shortcutButton
end

-- ========================================
-- 🖥️ MAIN GUI CREATION
-- ========================================

local function createMainGUI()
    -- Remove existing GUI
    if playerGui:FindFirstChild("UltimateGrowGarden") then
        playerGui:FindFirstChild("UltimateGrowGarden"):Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UltimateGrowGarden"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Calculate size based on device
    local guiSize = isMobile and UDim2.new(0.95, 0, 0.85, 0) or UDim2.new(0, 1000, 0, 650)
    local guiPosition = isMobile and UDim2.new(0.025, 0, 0.075, 0) or UDim2.new(0.5, -500, 0.5, -325)
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.Size = guiSize
    mainFrame.Position = guiPosition
    mainFrame.BackgroundColor3 = Colors.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = not isMobile
    mainFrame.Visible = false
    
    addRoundCorners(mainFrame, 20)
    addBorder(mainFrame, Colors.Border, 3)
    
    -- Glow effect for main frame
    local mainGlow = Instance.new("ImageLabel")
    mainGlow.Name = "MainGlow"
    mainGlow.Parent = mainFrame
    mainGlow.Size = UDim2.new(1, 40, 1, 40)
    mainGlow.Position = UDim2.new(0, -20, 0, -20)
    mainGlow.BackgroundTransparency = 1
    mainGlow.Image = "rbxassetid://5028857084"
    mainGlow.ImageColor3 = Colors.Accent
    mainGlow.ImageTransparency = 0.8
    mainGlow.ZIndex = -1
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Parent = mainFrame
    titleBar.Size = UDim2.new(1, 0, 0, isMobile and 70 or 60)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Colors.Secondary
    titleBar.BorderSizePixel = 0
    
    addRoundCorners(titleBar, 20)
    addGradient(titleBar, Colors.Accent, Colors.Success, 45)
    
    -- Title icon
    local titleIcon = Instance.new("TextLabel")
    titleIcon.Name = "TitleIcon"
    titleIcon.Parent = titleBar
    titleIcon.Size = UDim2.new(0, isMobile and 50 or 40, 1, 0)
    titleIcon.Position = UDim2.new(0, 15, 0, 0)
    titleIcon.BackgroundTransparency = 1
    titleIcon.Text = "🌱"
    titleIcon.TextColor3 = Colors.Text
    titleIcon.TextSize = isMobile and 32 or 28
    titleIcon.Font = Enum.Font.GothamBold
    
    -- Title text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Parent = titleBar
    titleText.Size = UDim2.new(1, -200, 1, 0)
    titleText.Position = UDim2.new(0, isMobile and 70 or 60, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "ULTIMATE GROW A GARDEN"
    titleText.TextColor3 = Colors.Text
    titleText.TextSize = isMobile and 20 or 18
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = titleBar
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -50, 0.5, -20)
    closeButton.BackgroundColor3 = Colors.Error
    closeButton.BorderSizePixel = 0
    closeButton.Text = "✕"
    closeButton.TextColor3 = Colors.Text
    closeButton.TextSize = 16
    closeButton.Font = Enum.Font.GothamBold
    
    addRoundCorners(closeButton, 20)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Minimize button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Parent = titleBar
    minimizeButton.Size = UDim2.new(0, 40, 0, 40)
    minimizeButton.Position = UDim2.new(1, -95, 0.5, -20)
    minimizeButton.BackgroundColor3 = Colors.Warning
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Text = "−"
    minimizeButton.TextColor3 = Colors.Text
    minimizeButton.TextSize = 16
    minimizeButton.Font = Enum.Font.GothamBold
    
    addRoundCorners(minimizeButton, 20)
    
    minimizeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        ScriptData.isVisible = false
    end)
    
    -- Sidebar
    local sidebarWidth = isMobile and 80 or 220
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Parent = mainFrame
    sidebar.Size = UDim2.new(0, sidebarWidth, 1, -(isMobile and 80 or 70))
    sidebar.Position = UDim2.new(0, 10, 0, isMobile and 75 or 65)
    sidebar.BackgroundColor3 = Colors.Secondary
    sidebar.BorderSizePixel = 0
    
    addRoundCorners(sidebar, 15)
    addBorder(sidebar, Colors.Border, 1)
    
    -- Content area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Parent = mainFrame
    contentArea.Size = UDim2.new(1, -(sidebarWidth + 30), 1, -(isMobile and 90 or 80))
    contentArea.Position = UDim2.new(0, sidebarWidth + 20, 0, isMobile and 75 or 65)
    contentArea.BackgroundColor3 = Colors.Background
    contentArea.BorderSizePixel = 0
    
    addRoundCorners(contentArea, 15)
    addBorder(contentArea, Colors.Border, 1)
    
    -- Status bar
    local statusBar = Instance.new("Frame")
    statusBar.Name = "StatusBar"
    statusBar.Parent = mainFrame
    statusBar.Size = UDim2.new(1, -20, 0, 25)
    statusBar.Position = UDim2.new(0, 10, 1, -30)
    statusBar.BackgroundColor3 = Colors.Secondary
    statusBar.BorderSizePixel = 0
    
    addRoundCorners(statusBar, 10)
    addGradient(statusBar, Colors.Success, Colors.Accent, 90)
    
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Parent = statusBar
    statusText.Size = UDim2.new(1, -20, 1, 0)
    statusText.Position = UDim2.new(0, 10, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "🟢 Ready | Items: 0 | Runtime: 00:00:00"
    statusText.TextColor3 = Colors.Text
    statusText.TextSize = isMobile and 12 or 10
    statusText.Font = Enum.Font.Gotham
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    
    return screenGui, mainFrame, sidebar, contentArea, statusText
end

-- ========================================
-- 📋 MENU SYSTEM
-- ========================================

local function createMenuButton(parent, text, emoji, index, onClick)
    local buttonHeight = isMobile and 60 or 50
    local buttonY = (index - 1) * (buttonHeight + 5) + 10
    
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.Parent = parent
    button.Size = UDim2.new(1, -10, 0, buttonHeight)
    button.Position = UDim2.new(0, 5, 0, buttonY)
    button.BackgroundColor3 = Colors.Secondary
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    
    addRoundCorners(button, 12)
    addBorder(button, Colors.Border, 1)
    
    -- Emoji icon
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Parent = button
    icon.Size = UDim2.new(0, isMobile and 40 or 35, 1, 0)
    icon.Position = UDim2.new(0, 10, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = emoji
    icon.TextColor3 = Colors.TextDim
    icon.TextSize = isMobile and 28 or 24
    icon.Font = Enum.Font.GothamBold
    
    -- Text label (only for desktop)
    local label
    if not isMobile then
        label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Parent = button
        label.Size = UDim2.new(1, -55, 1, 0)
        label.Position = UDim2.new(0, 50, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Colors.TextDim
        label.TextSize = 14
        label.Font = Enum.Font.GothamSemibold
        label.TextXAlignment = Enum.TextXAlignment.Left
    end
    
    -- Active indicator
    local indicator = Instance.new("Frame")
    indicator.Name = "ActiveIndicator"
    indicator.Parent = button
    indicator.Size = UDim2.new(0, 4, 0.8, 0)
    indicator.Position = UDim2.new(0, 0, 0.1, 0)
    indicator.BackgroundColor3 = Colors.Accent
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    
    addRoundCorners(indicator, 2)
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        }):Play()
        TweenService:Create(icon, TweenInfo.new(0.3), {
            TextColor3 = Colors.Accent
        }):Play()
        if label then
            TweenService:Create(label, TweenInfo.new(0.3), {
                TextColor3 = Colors.Text
            }):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not indicator.Visible then
            TweenService:Create(button, TweenInfo.new(0.3), {
                BackgroundColor3 = Colors.Secondary
            }):Play()
            TweenService:Create(icon, TweenInfo.new(0.3), {
                TextColor3 = Colors.TextDim
            }):Play()
            if label then
                TweenService:Create(label, TweenInfo.new(0.3), {
                    TextColor3 = Colors.TextDim
                }):Play()
            end
        end
    end)
    
    button.MouseButton1Click:Connect(function()
        -- Deselect all menu buttons
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("TextButton") and child:FindFirstChild("ActiveIndicator") then
                child.ActiveIndicator.Visible = false
                child.BackgroundColor3 = Colors.Secondary
                if child:FindFirstChild("Icon") then
                    child.Icon.TextColor3 = Colors.TextDim
                end
                if child:FindFirstChild("Label") then
                    child.Label.TextColor3 = Colors.TextDim
                end
            end
        end
        
        -- Select this button
        indicator.Visible = true
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        icon.TextColor3 = Colors.Accent
        if label then
            label.TextColor3 = Colors.Text
        end
        
        if onClick then
            onClick()
        end
    end)
    
    return button
end

-- ========================================
-- 📊 CONTENT PANELS
-- ========================================

local function clearContent(parent)
    for _, child in pairs(parent:GetChildren()) do
        child:Destroy()
    end
end

local function createToggleSwitch(parent, position, size, onToggle, defaultState)
    defaultState = defaultState or false
    
    local switchFrame = Instance.new("Frame")
    switchFrame.Parent = parent
    switchFrame.Size = size or UDim2.new(0, 60, 0, 30)
    switchFrame.Position = position
    switchFrame.BackgroundColor3 = defaultState and Colors.Success or Colors.TextDim
    switchFrame.BorderSizePixel = 0
    
    addRoundCorners(switchFrame, 15)
    
    local switchKnob = Instance.new("Frame")
    switchKnob.Parent = switchFrame
    switchKnob.Size = UDim2.new(0, 26, 0, 26)
    switchKnob.Position = defaultState and UDim2.new(0, 32, 0, 2) or UDim2.new(0, 2, 0, 2)
    switchKnob.BackgroundColor3 = Colors.Text
    switchKnob.BorderSizePixel = 0
    
    addRoundCorners(switchKnob, 13)
    
    local clickButton = Instance.new("TextButton")
    clickButton.Parent = switchFrame
    clickButton.Size = UDim2.new(1, 0, 1, 0)
    clickButton.BackgroundTransparency = 1
    clickButton.Text = ""
    
    local isActive = defaultState
    
    clickButton.MouseButton1Click:Connect(function()
        isActive = not isActive
        
        TweenService:Create(switchKnob, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = isActive and UDim2.new(0, 32, 0, 2) or UDim2.new(0, 2, 0, 2)
        }):Play()
        
        TweenService:Create(switchFrame, TweenInfo.new(0.3), {
            BackgroundColor3 = isActive and Colors.Success or Colors.TextDim
        }):Play()
        
        if onToggle then
            onToggle(isActive)
        end
    end)
    
    return switchFrame, function() return isActive end
end

local function createCharacterPanel(parent)
    clearContent(parent)
    
    -- Header
    local header = Instance.new("Frame")
    header.Parent = parent
    header.Size = UDim2.new(1, -20, 0, isMobile and 60 or 50)
    header.Position = UDim2.new(0, 10, 0, 10)
    header.BackgroundColor3 = Colors.Secondary
    header.BorderSizePixel = 0
    
    addRoundCorners(header, 12)
    addGradient(header, Colors.Accent, Colors.Success, 45)
    
    local headerText = Instance.new("TextLabel")
    headerText.Parent = header
    headerText.Size = UDim2.new(1, -20, 1, 0)
    headerText.Position = UDim2.new(0, 10, 0, 0)
    headerText.BackgroundTransparency = 1
    headerText.Text = "🏃 CHARACTER CONTROL"
    headerText.TextColor3 = Colors.Text
    headerText.TextSize = isMobile and 18 or 16
    headerText.Font = Enum.Font.GothamBold
    headerText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Speed control section
    local speedSection = Instance.new("Frame")
    speedSection.Parent = parent
    speedSection.Size = UDim2.new(1, -20, 0, isMobile and 100 or 80)
    speedSection.Position = UDim2.new(0, 10, 0, isMobile and 80 or 70)
    speedSection.BackgroundColor3 = Colors.Secondary
    speedSection.BorderSizePixel = 0
    
    addRoundCorners(speedSection, 12)
    addBorder(speedSection, Colors.Border, 1)
    
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Parent = speedSection
    speedLabel.Size = UDim2.new(1, 0, 0, 25)
    speedLabel.Position = UDim2.new(0, 0, 0, 5)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Player Speed"
    speedLabel.TextColor3 = Colors.Text
    speedLabel.TextSize = isMobile and 16 or 14
    speedLabel.Font = Enum.Font.GothamBold
    
    -- Speed input
    local speedInput = Instance.new("TextBox")
    speedInput.Parent = speedSection
    speedInput.Size = UDim2.new(0, isMobile and 140 or 120, 0, isMobile and 35 or 30)
    speedInput.Position = UDim2.new(0, 15, 0, isMobile and 35 or 30)
    speedInput.BackgroundColor3 = Colors.Background
    speedInput.BorderSizePixel = 0
    speedInput.Text = tostring(ScriptData.playerSpeed)
    speedInput.TextColor3 = Colors.Text
    speedInput.TextSize = isMobile and 16 or 14
    speedInput.Font = Enum.Font.Gotham
    speedInput.PlaceholderText = "Enter speed..."
    
    addRoundCorners(speedInput, 8)
    addBorder(speedInput, Colors.Border, 1)
    
    -- Speed toggle
    local speedToggle, getSpeedState = createToggleSwitch(speedSection, 
        UDim2.new(0, isMobile and 170 or 150, 0, isMobile and 35 or 30), 
        UDim2.new(0, isMobile and 70 or 60, 0, isMobile and 35 or 30), 
        function(state)
            IsActive.speed = state
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = state and ScriptData.playerSpeed or 16
            end
        end)
    
    speedInput.FocusLost:Connect(function()
        local newSpeed = tonumber(speedInput.Text)
        if newSpeed and newSpeed > 0 and newSpeed <= 500 then
            ScriptData.playerSpeed = newSpeed
            if IsActive.speed and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = ScriptData.playerSpeed
            end
        else
            speedInput.Text = tostring(ScriptData.playerSpeed)
        end
    end)
    
    -- Auto farm controls
    local autoSection = Instance.new("Frame")
    autoSection.Parent = parent
    autoSection.Size = UDim2.new(1, -20, 0, isMobile and 80 or 60)
    autoSection.Position = UDim2.new(0, 10, 0, isMobile and 190 or 160)
    autoSection.BackgroundColor3 = Colors.Secondary
    autoSection.BorderSizePixel = 0
    
    addRoundCorners(autoSection, 12)
    addBorder(autoSection, Colors.Border, 1)
    
    local autoLabel = Instance.new("TextLabel")
    autoLabel.Parent = autoSection
    autoLabel.Size = UDim2.new(1, 0, 0, 25)
    autoLabel.Position = UDim2.new(0, 0, 0, 5)
    autoLabel.BackgroundTransparency = 1
    autoLabel.Text = "🤖 Auto Farm Controls"
    autoLabel.TextColor3 = Colors.Text
    autoLabel.TextSize = isMobile and 16 or 14
    autoLabel.Font = Enum.Font.GothamBold
    
    -- Start all button
    local startAllButton = Instance.new("TextButton")
    startAllButton.Parent = autoSection
    startAllButton.Size = UDim2.new(0, isMobile and 140 or 120, 0, isMobile and 30 or 25)
    startAllButton.Position = UDim2.new(0, 15, 0, isMobile and 35 or 30)
    startAllButton.BackgroundColor3 = Colors.Success
    startAllButton.BorderSizePixel = 0
    startAllButton.Text = "🚀 START ALL"
    startAllButton.TextColor3 = Colors.Text
    startAllButton.TextSize = isMobile and 14 or 12
    startAllButton.Font = Enum.Font.GothamBold
    
    addRoundCorners(startAllButton, 8)
    
    startAllButton.MouseButton1Click:Connect(function()
        for category, items in pairs(IsActive) do
            if type(items) == "table" then
                for itemName, _ in pairs(items) do
                    if not items[itemName] then
                        items[itemName] = true
                        Loops[category][itemName] = true
                        
                        spawn(function()
                            local buyFunc = category == "seeds" and buySeed or
                                           category == "gear" and buyGear or
                                           category == "pets" and buyPetEgg
                            
                            while Loops[category][itemName] and items[itemName] do
                                buyFunc(itemName)
                                wait(0.1)
                            end
                        end)
                    end
                end
            end
        end
    end)
    
    -- Stop all button
    local stopAllButton = Instance.new("TextButton")
    stopAllButton.Parent = autoSection
    stopAllButton.Size = UDim2.new(0, isMobile and 140 or 120, 0, isMobile and 30 or 25)
    stopAllButton.Position = UDim2.new(0, isMobile and 170 or 150, 0, isMobile and 35 or 30)
    stopAllButton.BackgroundColor3 = Colors.Error
    stopAllButton.BorderSizePixel = 0
    stopAllButton.Text = "🛑 STOP ALL"
    stopAllButton.TextColor3 = Colors.Text
    stopAllButton.TextSize = isMobile and 14 or 12
    stopAllButton.Font = Enum.Font.GothamBold
    
    addRoundCorners(stopAllButton, 8)
    
    stopAllButton.MouseButton1Click:Connect(function()
        for category, items in pairs(IsActive) do
            if type(items) == "table" then
                for itemName, _ in pairs(items) do
                    items[itemName] = false
                    Loops[category][itemName] = false
                end
            end
        end
    end)
    
    -- Stats section
    local statsSection = Instance.new("Frame")
    statsSection.Parent = parent
    statsSection.Size = UDim2.new(1, -20, 0, isMobile and 120 or 100)
    statsSection.Position = UDim2.new(0, 10, 0, isMobile and 280 or 230)
    statsSection.BackgroundColor3 = Colors.Secondary
    statsSection.BorderSizePixel = 0
    
    addRoundCorners(statsSection, 12)
    addBorder(statsSection, Colors.Border, 1)
    
    local statsLabel = Instance.new("TextLabel")
    statsLabel.Parent = statsSection
    statsLabel.Size = UDim2.new(1, 0, 0, 25)
    statsLabel.Position = UDim2.new(0, 0, 0, 5)
    statsLabel.BackgroundTransparency = 1
    statsLabel.Text = "📊 Live Statistics"
    statsLabel.TextColor3 = Colors.Text
    statsLabel.TextSize = isMobile and 16 or 14
    statsLabel.Font = Enum.Font.GothamBold
    
    local statsText = Instance.new("TextLabel")
    statsText.Parent = statsSection
    statsText.Size = UDim2.new(1, -20, 1, -35)
    statsText.Position = UDim2.new(0, 10, 0, 30)
    statsText.BackgroundTransparency = 1
    statsText.Text = "Items Bought: 0\nActive Seeds: 0\nActive Gear: 0\nActive Pets: 0"
    statsText.TextColor3 = Colors.TextDim
    statsText.TextSize = isMobile and 14 or 12
    statsText.Font = Enum.Font.Gotham
    statsText.TextXAlignment = Enum.TextXAlignment.Left
    statsText.TextYAlignment = Enum.TextYAlignment.Top
    
    -- Update stats
    spawn(function()
        while statsText.Parent do
            local activeSeeds = 0
            local activeGear = 0
            local activePets = 0
            
            for _, active in pairs(IsActive.seeds) do
                if active then activeSeeds = activeSeeds + 1 end
            end
            for _, active in pairs(IsActive.gear) do
                if active then activeGear = activeGear + 1 end
            end
            for _, active in pairs(IsActive.pets) do
                if active then activePets = activePets + 1 end
            end
            
            statsText.Text = string.format(
                "Items Bought: %d\nActive Seeds: %d\nActive Gear: %d\nActive Pets: %d",
                ScriptData.stats.itemsBought, activeSeeds, activeGear, activePets
            )
            
            wait(1)
        end
    end)
end

local function createItemPanel(parent, items, itemType, buyFunction, title, emoji)
    clearContent(parent)
    
    -- Initialize item states
    for _, itemName in pairs(items) do
        IsActive[itemType][itemName] = false
        Loops[itemType][itemName] = false
    end
    
    -- Header
    local header = Instance.new("Frame")
    header.Parent = parent
    header.Size = UDim2.new(1, -20, 0, isMobile and 60 or 50)
    header.Position = UDim2.new(0, 10, 0, 10)
    header.BackgroundColor3 = Colors.Secondary
    header.BorderSizePixel = 0
    
    addRoundCorners(header, 12)
    addGradient(header, Colors.Accent, Colors.Success, 45)
    
    local headerText = Instance.new("TextLabel")
    headerText.Parent = header
    headerText.Size = UDim2.new(1, -20, 1, 0)
    headerText.Position = UDim2.new(0, 10, 0, 0)
    headerText.BackgroundTransparency = 1
    headerText.Text = emoji .. " " .. title
    headerText.TextColor3 = Colors.Text
    headerText.TextSize = isMobile and 18 or 16
    headerText.Font = Enum.Font.GothamBold
    headerText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Search and controls
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Parent = parent
    controlsFrame.Size = UDim2.new(1, -20, 0, isMobile and 50 or 40)
    controlsFrame.Position = UDim2.new(0, 10, 0, isMobile and 75 or 65)
    controlsFrame.BackgroundColor3 = Colors.Secondary
    controlsFrame.BorderSizePixel = 0
    
    addRoundCorners(controlsFrame, 10)
    addBorder(controlsFrame, Colors.Border, 1)
    
    -- Search input
    local searchInput = Instance.new("TextBox")
    searchInput.Parent = controlsFrame
    searchInput.Size = UDim2.new(1, -80, 1, -10)
    searchInput.Position = UDim2.new(0, 5, 0, 5)
    searchInput.BackgroundTransparency = 1
    searchInput.Text = ""
    searchInput.TextColor3 = Colors.Text
    searchInput.TextSize = isMobile and 16 or 14
    searchInput.Font = Enum.Font.Gotham
    searchInput.PlaceholderText = "🔍 Search items..."
    
    -- Select all button
    local selectAllButton = Instance.new("TextButton")
    selectAllButton.Parent = controlsFrame
    selectAllButton.Size = UDim2.new(0, 70, 1, -10)
    selectAllButton.Position = UDim2.new(1, -75, 0, 5)
    selectAllButton.BackgroundColor3 = Colors.Accent
    selectAllButton.BorderSizePixel = 0
    selectAllButton.Text = "ALL"
    selectAllButton.TextColor3 = Colors.Text
    selectAllButton.TextSize = isMobile and 14 or 12
    selectAllButton.Font = Enum.Font.GothamBold
    
    addRoundCorners(selectAllButton, 8)
    
    selectAllButton.MouseButton1Click:Connect(function()
        for _, itemName in pairs(items) do
            if not IsActive[itemType][itemName] then
                IsActive[itemType][itemName] = true
                Loops[itemType][itemName] = true
                
                spawn(function()
                    while Loops[itemType][itemName] and IsActive[itemType][itemName] do
                        buyFunction(itemName)
                        wait(0.1)
                    end
                end)
            end
        end
    end)
    
    -- Items scroll frame
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Parent = parent
    scrollFrame.Size = UDim2.new(1, -20, 1, -(isMobile and 140 or 120))
    scrollFrame.Position = UDim2.new(0, 10, 0, isMobile and 130 or 110)
    scrollFrame.BackgroundColor3 = Colors.Background
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = isMobile and 8 or 6
    scrollFrame.ScrollBarImageColor3 = Colors.Accent
    
    addRoundCorners(scrollFrame, 12)
    addBorder(scrollFrame, Colors.Border, 1)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = scrollFrame
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 5)
    
    local itemFrames = {}
    
    local function updateItemDisplay(searchTerm)
        searchTerm = searchTerm:lower()
        
        -- Hide all items first
        for _, frame in pairs(itemFrames) do
            frame.Visible = false
        end
        
        local layoutOrder = 0
        for i, itemName in pairs(items) do
            if searchTerm == "" or itemName:lower():find(searchTerm, 1, true) then
                if not itemFrames[itemName] then
                    -- Create item frame
                    local itemFrame = Instance.new("Frame")
                    itemFrame.Parent = scrollFrame
                    itemFrame.Size = UDim2.new(1, -10, 0, isMobile and 55 or 45)
                    itemFrame.BackgroundColor3 = Colors.Secondary
                    itemFrame.BorderSizePixel = 0
                    
                    addRoundCorners(itemFrame, 10)
                    addBorder(itemFrame, Colors.Border, 1)
                    
                    -- Item emoji
                    local itemEmoji = Instance.new("TextLabel")
                    itemEmoji.Parent = itemFrame
                    itemEmoji.Size = UDim2.new(0, isMobile and 35 or 30, 1, 0)
                    itemEmoji.Position = UDim2.new(0, 10, 0, 0)
                    itemEmoji.BackgroundTransparency = 1
                    itemEmoji.Text = emoji
                    itemEmoji.TextColor3 = Colors.Accent
                    itemEmoji.TextSize = isMobile and 20 or 16
                    itemEmoji.Font = Enum.Font.GothamBold
                    
                    -- Item name
                    local itemLabel = Instance.new("TextLabel")
                    itemLabel.Parent = itemFrame
                    itemLabel.Size = UDim2.new(1, -(isMobile and 110 or 100), 1, 0)
                    itemLabel.Position = UDim2.new(0, isMobile and 50 or 45, 0, 0)
                    itemLabel.BackgroundTransparency = 1
                    itemLabel.Text = itemName
                    itemLabel.TextColor3 = Colors.Text
                    itemLabel.TextSize = isMobile and 14 or 12
                    itemLabel.Font = Enum.Font.GothamSemibold
                    itemLabel.TextXAlignment = Enum.TextXAlignment.Left
                    
                    -- Toggle switch
                    local toggle, getToggleState = createToggleSwitch(itemFrame, 
                        UDim2.new(1, -(isMobile and 65 or 55), 0.5, -(isMobile and 15 or 12)), 
                        UDim2.new(0, isMobile and 60 or 50, 0, isMobile and 30 or 24), 
                        function(state)
                            IsActive[itemType][itemName] = state
                            
                            if state then
                                Loops[itemType][itemName] = true
                                spawn(function()
                                    while Loops[itemType][itemName] and IsActive[itemType][itemName] do
                                        buyFunction(itemName)
                                        wait(0.1)
                                    end
                                end)
                            else
                                Loops[itemType][itemName] = false
                            end
                        end)
                    
                    -- Hover effect
                    itemFrame.MouseEnter:Connect(function()
                        TweenService:Create(itemFrame, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(50, 50, 65)
                        }):Play()
                    end)
                    
                    itemFrame.MouseLeave:Connect(function()
                        TweenService:Create(itemFrame, TweenInfo.new(0.2), {
                            BackgroundColor3 = Colors.Secondary
                        }):Play()
                    end)
                    
                    itemFrames[itemName] = itemFrame
                end
                
                itemFrames[itemName].Visible = true
                itemFrames[itemName].LayoutOrder = layoutOrder
                layoutOrder = layoutOrder + 1
            end
        end
        
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end
    
    -- Search functionality
    searchInput:GetPropertyChangedSignal("Text"):Connect(function()
        updateItemDisplay(searchInput.Text)
    end)
    
    -- Initial display
    updateItemDisplay("")
    
    -- Update canvas size when content changes
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end)
end

-- ========================================
-- 🚀 MAIN INITIALIZATION
-- ========================================

local function initializeScript()
    print("🌱 Initializing Ultimate Grow Garden Script...")
    
    -- Create shortcut button
    local shortcutButton = createShortcutButton()
    print("✅ Shortcut button created")
    
    -- Create main GUI
    local screenGui, mainFrame, sidebar, contentArea, statusText = createMainGUI()
    print("✅ Main GUI created")
    
    -- Shortcut button click handler
    shortcutButton.MouseButton1Click:Connect(function()
        ScriptData.isVisible = not ScriptData.isVisible
        mainFrame.Visible = ScriptData.isVisible
        
        if ScriptData.isVisible then
            -- Animate GUI appearance
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
                Size = isMobile and UDim2.new(0.95, 0, 0.85, 0) or UDim2.new(0, 1000, 0, 650),
                Position = isMobile and UDim2.new(0.025, 0, 0.075, 0) or UDim2.new(0.5, -500, 0.5, -325)
            }):Play()
        end
    end)
    
    -- Create menu buttons
    local menuItems = {
        {text = "CHARACTER", emoji = "🏃", onClick = function()
            createCharacterPanel(contentArea)
        end},
        {text = "SEEDS", emoji = "🌱", onClick = function()
            createItemPanel(contentArea, Items.seeds, "seeds", buySeed, "AUTO SEED BUYER", "🌱")
        end},
        {text = "GEAR", emoji = "⚙️", onClick = function()
            createItemPanel(contentArea, Items.gear, "gear", buyGear, "AUTO GEAR BUYER", "⚙️")
        end},
        {text = "PETS", emoji = "🥚", onClick = function()
            createItemPanel(contentArea, Items.pets, "pets", buyPetEgg, "AUTO PET BUYER", "🥚")
        end}
    }
    
    for i, menu in pairs(menuItems) do
        createMenuButton(sidebar, menu.text, menu.emoji, i, menu.onClick)
    end
    
    -- Default to character panel
    createCharacterPanel(contentArea)
    print("✅ Menu system created")
    
    -- Status bar updates
    spawn(function()
        while screenGui.Parent do
            local activeCount = 0
            for category, items in pairs(IsActive) do
                if type(items) == "table" then
                    for _, active in pairs(items) do
                        if active then activeCount = activeCount + 1 end
                    end
                end
            end
            
            local runtime = tick() - ScriptData.stats.startTime
            local hours = math.floor(runtime / 3600)
            local minutes = math.floor((runtime % 3600) / 60)
            local seconds = math.floor(runtime % 60)
            
            statusText.Text = string.format("🟢 Active: %d | Items: %d | Runtime: %02d:%02d:%02d", 
                                           activeCount, ScriptData.stats.itemsBought, hours, minutes, seconds)
            
            wait(1)
        end
    end)
    
    -- Handle character respawn
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid")
        wait(1)
        if IsActive.speed then
            character.Humanoid.WalkSpeed = ScriptData.playerSpeed
        end
    end)
    
    -- Apply current speed if character exists
    if player.Character and player.Character:FindFirstChild("Humanoid") and IsActive.speed then
        player.Character.Humanoid.WalkSpeed = ScriptData.playerSpeed
    end
    
    print("✅ Script fully initialized!")
    print("🚀 Click the green 🌱 button to open the GUI!")
    
    -- Send notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🌱 Ultimate Grow Garden";
        Text = "Script loaded! Click the green button to open GUI";
        Duration = 5;
    })
end

-- ========================================
-- 🔄 ANTI-AFK SYSTEM
-- ========================================

spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
    while true do
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(300) -- 5 minutes
    end
end)

-- ========================================
-- 🚀 START THE SCRIPT
-- ========================================

initializeScript()
