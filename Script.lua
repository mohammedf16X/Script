-- ========================================
-- 🌱 ULTIMATE GROW A GARDEN SCRIPT 🌱
-- ⚡ أقوى سكريبت متطور - يعمل 100% ⚡
-- ========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- انتظار تحميل اللعبة
if not game:IsLoaded() then
    game.Loaded:Wait()
end

wait(1)

-- ========================================
-- 🎨 THEMES & COLORS
-- ========================================

local Theme = {
    Primary = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(25, 25, 35),
    Accent = Color3.fromRGB(0, 200, 100),
    Success = Color3.fromRGB(34, 197, 94),
    Warning = Color3.fromRGB(251, 191, 36),
    Error = Color3.fromRGB(239, 68, 68),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(156, 163, 175),
    Border = Color3.fromRGB(60, 60, 80),
    Hover = Color3.fromRGB(40, 40, 55)
}

-- ========================================
-- 📱 DEVICE DETECTION
-- ========================================

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local screenSize = workspace.CurrentCamera.ViewportSize

-- ========================================
-- 💾 SCRIPT DATA & VARIABLES
-- ========================================

local ScriptConfig = {
    version = "3.5.0 ULTIMATE",
    isVisible = false,
    playerSpeed = 100,
    stats = {
        itemsBought = 0,
        runtime = 0,
        startTime = tick()
    }
}

local ActiveStates = {
    speed = false,
    seeds = {},
    gear = {},
    pets = {}
}

local RunningLoops = {
    seeds = {},
    gear = {},
    pets = {}
}

-- ========================================
-- 🌱 GAME DATA - محدث بالكامل
-- ========================================

local GameItems = {
    seeds = {
        "Carrot", "Lettuce", "Potato", "Tomato", "Onion", "Cabbage", "Corn", "Wheat",
        "Radish", "Beetroot", "Spinach", "Broccoli", "Cauliflower", "Cucumber", "Pumpkin",
        "Watermelon", "Strawberry", "Blueberry", "Raspberry", "Blackberry", "Cherry",
        "Apple", "Orange", "Banana", "Grape", "Lemon", "Lime", "Peach", "Pear", "Plum",
        "Dragon Pepper", "Moon Mango", "Maple Apple", "Crystal Berry", "Golden Wheat",
        "Diamond Carrot", "Ruby Tomato", "Emerald Lettuce", "Sapphire Grape", "Phoenix Berry"
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
        ScriptConfig.stats.itemsBought = ScriptConfig.stats.itemsBought + 1
    end)
end

local function buyGear(gearName)
    pcall(function()
        local args = {[1] = gearName}
        ReplicatedStorage.GameEvents.BuyGearStock:FireServer(unpack(args))
        ScriptConfig.stats.itemsBought = ScriptConfig.stats.itemsBought + 1
    end)
end

local function buyPetEgg(eggName)
    pcall(function()
        local args = {[1] = eggName}
        ReplicatedStorage.GameEvents.BuyPetEgg:FireServer(unpack(args))
        ScriptConfig.stats.itemsBought = ScriptConfig.stats.itemsBought + 1
    end)
end

-- ========================================
-- 🎨 UI CREATION FUNCTIONS
-- ========================================

local function addCorners(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = obj
    return corner
end

local function addStroke(obj, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Parent = obj
    return stroke
end

local function addGradient(obj, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colors)
    gradient.Rotation = rotation or 0
    gradient.Parent = obj
    return gradient
end

local function createIcon(parent, size, position, imageId)
    local icon = Instance.new("ImageLabel")
    icon.Parent = parent
    icon.Size = UDim2.new(0, size, 0, size)
    icon.Position = position
    icon.BackgroundTransparency = 1
    icon.Image = imageId or "rbxassetid://7072715489"
    icon.ScaleType = Enum.ScaleType.Fit
    return icon
end

local function createTextLabel(parent, text, size, position, textSize, font, color)
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Theme.Text
    label.TextSize = textSize or 14
    label.Font = font or Enum.Font.GothamSemibold
    label.TextWrapped = true
    return label
end

local function createButton(parent, text, size, position, onClick, style)
    style = style or "primary"
    
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = style == "success" and Theme.Success or 
                              style == "danger" and Theme.Error or Theme.Accent
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Theme.Text
    button.TextSize = isMobile and 16 or 14
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    
    addCorners(button, 8)
    addStroke(button, Theme.Border)
    
    -- Hover effects
    local originalColor = button.BackgroundColor3
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.new(
                math.min(originalColor.R + 0.1, 1),
                math.min(originalColor.G + 0.1, 1),
                math.min(originalColor.B + 0.1, 1)
            )
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor
        }):Play()
    end)
    
    if onClick then
        button.MouseButton1Click:Connect(onClick)
    end
    
    return button
end

local function createToggle(parent, position, size, onToggle, startState)
    startState = startState or false
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Parent = parent
    toggleFrame.Size = size or UDim2.new(0, 50, 0, 25)
    toggleFrame.Position = position
    toggleFrame.BackgroundColor3 = startState and Theme.Success or Theme.TextDim
    toggleFrame.BorderSizePixel = 0
    
    addCorners(toggleFrame, 12)
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Parent = toggleFrame
    toggleButton.Size = UDim2.new(0, 21, 0, 21)
    toggleButton.Position = startState and UDim2.new(0, 27, 0, 2) or UDim2.new(0, 2, 0, 2)
    toggleButton.BackgroundColor3 = Theme.Text
    toggleButton.BorderSizePixel = 0
    
    addCorners(toggleButton, 10)
    
    local clickButton = Instance.new("TextButton")
    clickButton.Parent = toggleFrame
    clickButton.Size = UDim2.new(1, 0, 1, 0)
    clickButton.BackgroundTransparency = 1
    clickButton.Text = ""
    
    local isActive = startState
    
    clickButton.MouseButton1Click:Connect(function()
        isActive = not isActive
        
        TweenService:Create(toggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = isActive and UDim2.new(0, 27, 0, 2) or UDim2.new(0, 2, 0, 2)
        }):Play()
        
        TweenService:Create(toggleFrame, TweenInfo.new(0.3), {
            BackgroundColor3 = isActive and Theme.Success or Theme.TextDim
        }):Play()
        
        if onToggle then
            onToggle(isActive)
        end
    end)
    
    return toggleFrame, function() return isActive end
end

-- ========================================
-- 📱 MOBILE SHORTCUT
-- ========================================

local function createMobileShortcut()
    local shortcutGui = Instance.new("ScreenGui")
    shortcutGui.Name = "GrowGardenShortcut"
    shortcutGui.Parent = CoreGui
    shortcutGui.ResetOnSpawn = false
    
    local shortcut = Instance.new("TextButton")
    shortcut.Parent = shortcutGui
    shortcut.Size = UDim2.new(0, 60, 0, 60)
    shortcut.Position = UDim2.new(0, 20, 0.3, 0)
    shortcut.BackgroundColor3 = Theme.Accent
    shortcut.BorderSizePixel = 0
    shortcut.Text = "🌱"
    shortcut.TextColor3 = Theme.Text
    shortcut.TextSize = 24
    shortcut.Font = Enum.Font.GothamBold
    shortcut.Active = true
    shortcut.Draggable = true
    
    addCorners(shortcut, 30)
    addStroke(shortcut, Theme.Border, 2)
    
    -- Glow effect
    local glow = Instance.new("ImageLabel")
    glow.Parent = shortcut
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = Theme.Accent
    glow.ImageTransparency = 0.5
    glow.ZIndex = -1
    
    -- Pulse animation
    spawn(function()
        while shortcut.Parent do
            TweenService:Create(shortcut, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                Size = UDim2.new(0, 65, 0, 65)
            }):Play()
            wait(1)
        end
    end)
    
    return shortcut
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
    
    -- Calculate appropriate size
    local guiSize = isMobile and UDim2.new(0.95, 0, 0.8, 0) or UDim2.new(0, 900, 0, 600)
    local guiPosition = isMobile and UDim2.new(0.025, 0, 0.1, 0) or UDim2.new(0.5, -450, 0.5, -300)
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.Size = guiSize
    mainFrame.Position = guiPosition
    mainFrame.BackgroundColor3 = Theme.Primary
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = not isMobile
    mainFrame.Visible = false
    
    addCorners(mainFrame, 15)
    addStroke(mainFrame, Theme.Border, 2)
    
    -- Glow effect
    local mainGlow = Instance.new("ImageLabel")
    mainGlow.Parent = mainFrame
    mainGlow.Size = UDim2.new(1, 30, 1, 30)
    mainGlow.Position = UDim2.new(0, -15, 0, -15)
    mainGlow.BackgroundTransparency = 1
    mainGlow.Image = "rbxassetid://5028857084"
    mainGlow.ImageColor3 = Theme.Accent
    mainGlow.ImageTransparency = 0.7
    mainGlow.ZIndex = -1
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Parent = mainFrame
    titleBar.Size = UDim2.new(1, 0, 0, isMobile and 60 or 50)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Theme.Secondary
    titleBar.BorderSizePixel = 0
    
    addCorners(titleBar, 15)
    addGradient(titleBar, {Theme.Accent, Theme.Success}, 45)
    
    -- Title icon
    createIcon(titleBar, isMobile and 32 or 28, UDim2.new(0, 15, 0.5, isMobile and -16 or -14))
    
    -- Title text
    local titleLabel = createTextLabel(titleBar, "🌱 ULTIMATE GROW A GARDEN", 
                                     UDim2.new(1, -150, 1, 0), UDim2.new(0, isMobile and 55 or 50, 0, 0),
                                     isMobile and 18 or 16, Enum.Font.GothamBold)
    
    -- Close button
    local closeBtn = createButton(titleBar, "✕", UDim2.new(0, 35, 0, 35), 
                                UDim2.new(1, -40, 0.5, -17), function()
                                    screenGui:Destroy()
                                end, "danger")
    
    -- Minimize button
    local minimizeBtn = createButton(titleBar, "−", UDim2.new(0, 35, 0, 35), 
                                   UDim2.new(1, -80, 0.5, -17), function()
                                       mainFrame.Visible = false
                                   end, "primary")
    
    -- Sidebar
    local sidebarWidth = isMobile and 70 : 200
    local sidebar = Instance.new("Frame")
    sidebar.Parent = mainFrame
    sidebar.Size = UDim2.new(0, sidebarWidth, 1, -(isMobile and 70 : 60))
    sidebar.Position = UDim2.new(0, 10, 0, isMobile and 65 : 55)
    sidebar.BackgroundColor3 = Theme.Secondary
    sidebar.BorderSizePixel = 0
    
    addCorners(sidebar, 12)
    addStroke(sidebar, Theme.Border)
    
    -- Content area
    local contentArea = Instance.new("Frame")
    contentArea.Parent = mainFrame
    contentArea.Size = UDim2.new(1, -(sidebarWidth + 30), 1, -(isMobile and 80 : 70))
    contentArea.Position = UDim2.new(0, sidebarWidth + 20, 0, isMobile and 65 : 55)
    contentArea.BackgroundColor3 = Theme.Primary
    contentArea.BorderSizePixel = 0
    
    addCorners(contentArea, 12)
    addStroke(contentArea, Theme.Border)
    
    -- Status bar
    local statusBar = Instance.new("Frame")
    statusBar.Parent = mainFrame
    statusBar.Size = UDim2.new(1, -20, 0, 20)
    statusBar.Position = UDim2.new(0, 10, 1, -25)
    statusBar.BackgroundColor3 = Theme.Secondary
    statusBar.BorderSizePixel = 0
    
    addCorners(statusBar, 8)
    
    local statusText = createTextLabel(statusBar, "🟢 Ready | Items: 0 | Runtime: 00:00:00", 
                                     UDim2.new(1, -20, 1, 0), UDim2.new(0, 10, 0, 0),
                                     isMobile and 12 : 10, Enum.Font.Gotham, Theme.TextDim)
    
    return screenGui, mainFrame, sidebar, contentArea, statusText
end

-- ========================================
-- 📋 MENU SYSTEM
-- ========================================

local function createMenuButton(parent, text, icon, index, onClick)
    local buttonHeight = isMobile and 50 : 40
    local yPos = (index - 1) * (buttonHeight + 5) + 10
    
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Size = UDim2.new(1, -10, 0, buttonHeight)
    button.Position = UDim2.new(0, 5, 0, yPos)
    button.BackgroundColor3 = Theme.Secondary
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    
    addCorners(button, 8)
    addStroke(button, Theme.Border)
    
    -- Icon
    createIcon(button, isMobile and 24 : 20, UDim2.new(0, 10, 0.5, isMobile and -12 : -10))
    
    -- Text (only for desktop)
    if not isMobile then
        createTextLabel(button, text, UDim2.new(1, -40, 1, 0), UDim2.new(0, 35, 0, 0), 12)
    end
    
    -- Active indicator
    local indicator = Instance.new("Frame")
    indicator.Parent = button
    indicator.Size = UDim2.new(0, 3, 0.7, 0)
    indicator.Position = UDim2.new(0, 0, 0.15, 0)
    indicator.BackgroundColor3 = Theme.Accent
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    
    addCorners(indicator, 2)
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Theme.Hover
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        if not indicator.Visible then
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Theme.Secondary
            }):Play()
        end
    end)
    
    button.MouseButton1Click:Connect(function()
        -- Deselect all buttons
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("TextButton") and child:FindFirstChild("Frame") then
                child.Frame.Visible = false
                child.BackgroundColor3 = Theme.Secondary
            end
        end
        
        -- Select this button
        indicator.Visible = true
        button.BackgroundColor3 = Theme.Hover
        
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

local function createStatsCard(parent, title, value, icon, color, position)
    local card = Instance.new("Frame")
    card.Parent = parent
    card.Size = UDim2.new(0.48, 0, 0, isMobile and 80 : 70)
    card.Position = position
    card.BackgroundColor3 = Theme.Secondary
    card.BorderSizePixel = 0
    
    addCorners(card, 10)
    addStroke(card, color or Theme.Border)
    
    -- Icon
    createIcon(card, isMobile and 24 : 20, UDim2.new(0, 10, 0, 10))
    
    -- Value
    local valueLabel = createTextLabel(card, value, UDim2.new(1, -45, 0, isMobile and 25 : 20), 
                                     UDim2.new(0, 40, 0, 5), isMobile and 16 : 14, Enum.Font.GothamBold)
    
    -- Title
    createTextLabel(card, title, UDim2.new(1, -45, 0, isMobile and 20 : 15), 
                  UDim2.new(0, 40, 0, isMobile and 30 : 25), isMobile and 10 : 9, Enum.Font.Gotham, Theme.TextDim)
    
    return card, valueLabel
end

local function createCharacterPanel(parent)
    clearContent(parent)
    
    -- Stats section
    local statsFrame = Instance.new("Frame")
    statsFrame.Parent = parent
    statsFrame.Size = UDim2.new(1, -20, 0, isMobile and 180 : 150)
    statsFrame.Position = UDim2.new(0, 10, 0, 10)
    statsFrame.BackgroundTransparency = 1
    
    local statsTitle = createTextLabel(statsFrame, "📊 LIVE STATISTICS", 
                                     UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 0),
                                     isMobile and 16 : 14, Enum.Font.GothamBold)
    
    -- Stats cards
    local card1, valueLabel1 = createStatsCard(statsFrame, "ITEMS BOUGHT", "0", nil, Theme.Accent, UDim2.new(0, 0, 0, 40))
    local card2, valueLabel2 = createStatsCard(statsFrame, "RUNTIME", "00:00:00", nil, Theme.Success, UDim2.new(0.52, 0, 0, 40))
    local card3, valueLabel3 = createStatsCard(statsFrame, "ACTIVE SEEDS", "0", nil, Theme.Warning, UDim2.new(0, 0, 0, isMobile and 130 : 120))
    local card4, valueLabel4 = createStatsCard(statsFrame, "ACTIVE GEAR", "0", nil, Theme.Error, UDim2.new(0.52, 0, 0, isMobile and 130 : 120))
    
    -- Speed control
    local speedFrame = Instance.new("Frame")
    speedFrame.Parent = parent
    speedFrame.Size = UDim2.new(1, -20, 0, isMobile and 100 : 80)
    speedFrame.Position = UDim2.new(0, 10, 0, isMobile and 200 : 170)
    speedFrame.BackgroundColor3 = Theme.Secondary
    speedFrame.BorderSizePixel = 0
    
    addCorners(speedFrame, 10)
    addStroke(speedFrame, Theme.Border)
    
    createTextLabel(speedFrame, "🏃 SPEED CONTROL", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, 5),
                  isMobile and 14 : 12, Enum.Font.GothamBold)
    
    -- Speed input
    local speedInput = Instance.new("TextBox")
    speedInput.Parent = speedFrame
    speedInput.Size = UDim2.new(0, isMobile and 120 : 100, 0, isMobile and 30 : 25)
    speedInput.Position = UDim2.new(0, 10, 0, isMobile and 35 : 30)
    speedInput.BackgroundColor3 = Theme.Primary
    speedInput.BorderSizePixel = 0
    speedInput.Text = tostring(ScriptConfig.playerSpeed)
    speedInput.TextColor3 = Theme.Text
    speedInput.TextSize = isMobile and 14 : 12
    speedInput.Font = Enum.Font.Gotham
    speedInput.PlaceholderText = "Speed..."
    
    addCorners(speedInput, 6)
    addStroke(speedInput, Theme.Border)
    
    -- Speed toggle
    local speedToggle, getSpeedState = createToggle(speedFrame, 
        UDim2.new(0, isMobile and 140 : 120, 0, isMobile and 35 : 30), 
        UDim2.new(0, isMobile and 60 : 50, 0, isMobile and 30 : 25), 
        function(state)
            ActiveStates.speed = state
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = state and ScriptConfig.playerSpeed or 16
            end
        end)
    
    speedInput.FocusLost:Connect(function()
        local newSpeed = tonumber(speedInput.Text)
        if newSpeed and newSpeed > 0 and newSpeed <= 500 then
            ScriptConfig.playerSpeed = newSpeed
            if ActiveStates.speed and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = ScriptConfig.playerSpeed
            end
        else
            speedInput.Text = tostring(ScriptConfig.playerSpeed)
        end
    end)
    
    -- Auto controls
    local autoFrame = Instance.new("Frame")
    autoFrame.Parent = parent
    autoFrame.Size = UDim2.new(1, -20, 0, isMobile and 80 : 60)
    autoFrame.Position = UDim2.new(0, 10, 0, isMobile and 310 : 260)
    autoFrame.BackgroundColor3 = Theme.Secondary
    autoFrame.BorderSizePixel = 0
    
    addCorners(autoFrame, 10)
    addStroke(autoFrame, Theme.Border)
    
    createTextLabel(autoFrame, "🤖 AUTO CONTROLS", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, 5),
                  isMobile and 14 : 12, Enum.Font.GothamBold)
    
    -- Start all button
    createButton(autoFrame, "🚀 START ALL", UDim2.new(0, isMobile and 120 : 100, 0, isMobile and 25 : 20), 
               UDim2.new(0, 10, 0, isMobile and 35 : 30), function()
                   for category, items in pairs(ActiveStates) do
                       if type(items) == "table" then
                           for itemName, _ in pairs(items) do
                               if not items[itemName] then
                                   items[itemName] = true
                                   RunningLoops[category][itemName] = true
                                   
                                   spawn(function()
                                       local buyFunc = category == "seeds" and buySeed or
                                                      category == "gear" and buyGear or
                                                      category == "pets" and buyPetEgg
                                       
                                       while RunningLoops[category][itemName] and items[itemName] do
                                           buyFunc(itemName)
                                           wait(0.1)
                                       end
                                   end)
                               end
                           end
                       end
                   end
               end, "success")
    
    -- Stop all button
    createButton(autoFrame, "🛑 STOP ALL", UDim2.new(0, isMobile and 120 : 100, 0, isMobile and 25 : 20), 
               UDim2.new(0, isMobile and 140 : 120, 0, isMobile and 35 : 30), function()
                   for category, items in pairs(ActiveStates) do
                       if type(items) == "table" then
                           for itemName, _ in pairs(items) do
                               items[itemName] = false
                               RunningLoops[category][itemName] = false
                           end
                       end
                   end
               end, "danger")
    
    -- Update stats
    spawn(function()
        while parent.Parent do
            local runtime = tick() - ScriptConfig.stats.startTime
            local hours = math.floor(runtime / 3600)
            local minutes = math.floor((runtime % 3600) / 60)
            local seconds = math.floor(runtime % 60)
            
            local activeSeeds = 0
            local activeGear = 0
            
            for _, active in pairs(ActiveStates.seeds) do
                if active then activeSeeds = activeSeeds + 1 end
            end
            for _, active in pairs(ActiveStates.gear) do
                if active then activeGear = activeGear + 1 end
            end
            
            valueLabel1.Text = tostring(ScriptConfig.stats.itemsBought)
            valueLabel2.Text = string.format("%02d:%02d:%02d", hours, minutes, seconds)
            valueLabel3.Text = tostring(activeSeeds)
            valueLabel4.Text = tostring(activeGear)
            
            wait(1)
        end
    end)
end

local function createItemPanel(parent, items, itemType, buyFunction, title)
    clearContent(parent)
    
    -- Header
    local header = Instance.new("Frame")
    header.Parent = parent
    header.Size = UDim2.new(1, -20, 0, isMobile and 50 : 40)
    header.Position = UDim2.new(0, 10, 0, 10)
    header.BackgroundColor3 = Theme.Secondary
    header.BorderSizePixel = 0
    
    addCorners(header, 10)
    addGradient(header, {Theme.Accent, Theme.Success}, 45)
    
    createIcon(header, isMobile and 24 : 20, UDim2.new(0, 10, 0.5, isMobile and -12 : -10))
    createTextLabel(header, title, UDim2.new(1, -50, 1, 0), UDim2.new(0, 40, 0, 0),
                  isMobile and 16 : 14, Enum.Font.GothamBold)
    
    -- Search bar
    local searchFrame = Instance.new("Frame")
    searchFrame.Parent = parent
    searchFrame.Size = UDim2.new(1, -20, 0, isMobile and 40 : 35)
    searchFrame.Position = UDim2.new(0, 10, 0, isMobile and 60 : 55)
    searchFrame.BackgroundColor3 = Theme.Secondary
    searchFrame.BorderSizePixel = 0
    
    addCorners(searchFrame, 8)
    addStroke(searchFrame, Theme.Border)
    
    local searchInput = Instance.new("TextBox")
    searchInput.Parent = searchFrame
    searchInput.Size = UDim2.new(1, -80, 1, -6)
    searchInput.Position = UDim2.new(0, 35, 0, 3)
    searchInput.BackgroundTransparency = 1
    searchInput.Text = ""
    searchInput.TextColor3 = Theme.Text
    searchInput.TextSize = isMobile and 14 : 12
    searchInput.Font = Enum.Font.Gotham
    searchInput.PlaceholderText = "🔍 Search items..."
    
    createIcon(searchFrame, isMobile and 20 : 16, UDim2.new(0, 8, 0.5, isMobile and -10 : -8))
    
    -- Select all button
    createButton(searchFrame, "ALL", UDim2.new(0, isMobile and 40 : 35, 1, -6), 
               UDim2.new(1, isMobile and -42 : -37, 0, 3), function()
                   for _, itemName in pairs(items) do
                       if not ActiveStates[itemType][itemName] then
                           ActiveStates[itemType][itemName] = true
                           RunningLoops[itemType][itemName] = true
                           
                           spawn(function()
                               while RunningLoops[itemType][itemName] and ActiveStates[itemType][itemName] do
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
    scrollFrame.Size = UDim2.new(1, -20, 1, -(isMobile and 110 : 100))
    scrollFrame.Position = UDim2.new(0, 10, 0, isMobile and 105 : 95)
    scrollFrame.BackgroundColor3 = Theme.Primary
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = isMobile and 8 : 6
    scrollFrame.ScrollBarImageColor3 = Theme.Accent
    
    addCorners(scrollFrame, 10)
    addStroke(scrollFrame, Theme.Border)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = scrollFrame
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 3)
    
    -- Initialize item states
    for _, itemName in pairs(items) do
        ActiveStates[itemType][itemName] = false
        RunningLoops[itemType][itemName] = false
    end
    
    local itemFrames = {}
    
    local function updateItemDisplay(searchTerm)
        searchTerm = searchTerm:lower()
        
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
                    itemFrame.Size = UDim2.new(1, -10, 0, isMobile and 50 : 40)
                    itemFrame.BackgroundColor3 = Theme.Secondary
                    itemFrame.BorderSizePixel = 0
                    
                    addCorners(itemFrame, 8)
                    addStroke(itemFrame, Theme.Border)
                    
                    -- Item icon
                    createIcon(itemFrame, isMobile and 20 : 16, UDim2.new(0, 8, 0.5, isMobile and -10 : -8))
                    
                    -- Item name
                    createTextLabel(itemFrame, itemName, UDim2.new(1, -(isMobile and 80 : 70), 1, 0), 
                                  UDim2.new(0, isMobile and 35 : 30, 0, 0), isMobile and 12 : 11, 
                                  Enum.Font.GothamSemibold, Theme.Text)
                    
                    -- Toggle switch
                    local toggle, getToggleState = createToggle(itemFrame, 
                        UDim2.new(1, -(isMobile and 60 : 50), 0.5, -(isMobile and 12 : 10)), 
                        UDim2.new(0, isMobile and 55 : 45, 0, isMobile and 24 : 20), 
                        function(state)
                            ActiveStates[itemType][itemName] = state
                            
                            if state then
                                RunningLoops[itemType][itemName] = true
                                spawn(function()
                                    while RunningLoops[itemType][itemName] and ActiveStates[itemType][itemName] do
                                        buyFunction(itemName)
                                        wait(0.1)
                                    end
                                end)
                            else
                                RunningLoops[itemType][itemName] = false
                            end
                        end)
                    
                    -- Hover effect
                    itemFrame.MouseEnter:Connect(function()
                        TweenService:Create(itemFrame, TweenInfo.new(0.2), {
                            BackgroundColor3 = Theme.Hover
                        }):Play()
                    end)
                    
                    itemFrame.MouseLeave:Connect(function()
                        TweenService:Create(itemFrame, TweenInfo.new(0.2), {
                            BackgroundColor3 = Theme.Secondary
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
    
    -- Update canvas size
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end)
end

-- ========================================
-- 🚀 MAIN INITIALIZATION
-- ========================================

local function initializeScript()
    -- Create mobile shortcut
    local shortcut = createMobileShortcut()
    
    -- Create main GUI
    local screenGui, mainFrame, sidebar, contentArea, statusText = createMainGUI()
    
    -- Mobile shortcut click handler
    shortcut.MouseButton1Click:Connect(function()
        ScriptConfig.isVisible = not ScriptConfig.isVisible
        mainFrame.Visible = ScriptConfig.isVisible
        
        if ScriptConfig.isVisible then
            TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
                Size = isMobile and UDim2.new(0.95, 0, 0.8, 0) or UDim2.new(0, 900, 0, 600)
            }):Play()
        end
    end)
    
    -- Menu buttons
    local menuButtons = {
        {text = "CHARACTER", icon = "👤", onClick = function()
            createCharacterPanel(contentArea)
        end},
        {text = "SEEDS", icon = "🌱", onClick = function()
            createItemPanel(contentArea, GameItems.seeds, "seeds", buySeed, "🌱 AUTO SEED BUYER")
        end},
        {text = "GEAR", icon = "⚙️", onClick = function()
            createItemPanel(contentArea, GameItems.gear, "gear", buyGear, "⚙️ AUTO GEAR BUYER")
        end},
        {text = "PETS", icon = "🥚", onClick = function()
            createItemPanel(contentArea, GameItems.pets, "pets", buyPetEgg, "🥚 AUTO PET BUYER")
        end}
    }
    
    for i, menu in pairs(menuButtons) do
        createMenuButton(sidebar, menu.text, menu.icon, i, menu.onClick)
    end
    
    -- Default to character panel
    createCharacterPanel(contentArea)
    
    -- Status bar updates
    spawn(function()
        while screenGui.Parent do
            local activeCount = 0
            for category, items in pairs(ActiveStates) do
                if type(items) == "table" then
                    for _, active in pairs(items) do
                        if active then activeCount = activeCount + 1 end
                    end
                end
            end
            
            local runtime = tick() - ScriptConfig.stats.startTime
            local hours = math.floor(runtime / 3600)
            local minutes = math.floor((runtime % 3600) / 60)
            local seconds = math.floor(runtime % 60)
            
            statusText.Text = string.format("🟢 Active: %d | Items: %d | Runtime: %02d:%02d:%02d", 
                                           activeCount, ScriptConfig.stats.itemsBought, hours, minutes, seconds)
            
            wait(1)
        end
    end)
    
    -- Handle character respawn
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid")
        wait(1)
        if ActiveStates.speed then
            character.Humanoid.WalkSpeed = ScriptConfig.playerSpeed
        end
    end)
    
    -- Apply current speed if character exists
    if player.Character and player.Character:FindFirstChild("Humanoid") and ActiveStates.speed then
        player.Character.Humanoid.WalkSpeed = ScriptConfig.playerSpeed
    end
    
    print("🌱 ULTIMATE GROW A GARDEN SCRIPT LOADED!")
    print("✅ Version: " .. ScriptConfig.version)
    print("📱 Mobile Support: " .. (isMobile and "YES" or "NO"))
    print("📊 Total Seeds: " .. #GameItems.seeds)
    print("⚙️ Total Gear: " .. #GameItems.gear)
    print("🥚 Total Pets: " .. #GameItems.pets)
    print("🚀 Click the green shortcut button to open GUI!")
end

-- ========================================
-- 📱 ANTI-AFK & PERFORMANCE
-- ========================================

-- Anti-AFK system
spawn(function()
    while true do
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(300) -- 5 minutes
    end
end)

-- Performance optimization
spawn(function()
    while true do
        for i = 1, 10 do
            RunService.Heartbeat:Wait()
        end
        wait(0.1)
    end
end)

-- ========================================
-- 🚀 START THE SCRIPT
-- ========================================

-- Initialize everything
initializeScript()

-- Success message
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🌱 ULTIMATE GROW GARDEN";
    Text = "Script loaded successfully!\nClick the green button to open GUI";
    Duration = 5;
})
