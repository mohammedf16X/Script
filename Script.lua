-- ========================================
-- 🌱 ULTIMATE GROW A GARDEN SCRIPT 🌱
-- ⚡ أقوى سكريبت على الإطلاق - تصميم متطور ⚡
-- ========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- انتظار تحميل اللعبة بالكامل
if not game:IsLoaded() then
    game.Loaded:Wait()
end

wait(2)

-- ========================================
-- 🎨 ADVANCED UI SYSTEM & THEMES
-- ========================================

local UIThemes = {
    Modern = {
        Primary = Color3.fromRGB(18, 18, 25),
        Secondary = Color3.fromRGB(25, 25, 35),
        Accent = Color3.fromRGB(0, 150, 255),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(239, 68, 68),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(156, 163, 175),
        Border = Color3.fromRGB(55, 65, 81),
        Hover = Color3.fromRGB(75, 85, 99)
    },
    Neon = {
        Primary = Color3.fromRGB(10, 10, 15),
        Secondary = Color3.fromRGB(15, 15, 25),
        Accent = Color3.fromRGB(147, 51, 234),
        Success = Color3.fromRGB(16, 185, 129),
        Warning = Color3.fromRGB(245, 158, 11),
        Error = Color3.fromRGB(220, 38, 127),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(209, 213, 219),
        Border = Color3.fromRGB(147, 51, 234),
        Hover = Color3.fromRGB(126, 34, 206)
    },
    Garden = {
        Primary = Color3.fromRGB(22, 36, 28),
        Secondary = Color3.fromRGB(34, 49, 39),
        Accent = Color3.fromRGB(34, 197, 94),
        Success = Color3.fromRGB(16, 185, 129),
        Warning = Color3.fromRGB(234, 179, 8),
        Error = Color3.fromRGB(239, 68, 68),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(187, 247, 208),
        Border = Color3.fromRGB(34, 197, 94),
        Hover = Color3.fromRGB(22, 163, 74)
    }
}

local currentTheme = UIThemes.Garden

-- ========================================
-- 🎭 ICONS LIBRARY - أكثر من 100 أيقونة
-- ========================================

local Icons = {
    -- Basic Icons
    Home = "rbxassetid://10723434711",
    Settings = "rbxassetid://10734950309",
    User = "rbxassetid://10734929261",
    Search = "rbxassetid://10734896206",
    Close = "rbxassetid://10747384394",
    Menu = "rbxassetid://10723407389",
    
    -- Garden Icons
    Seed = "rbxassetid://10723434711",
    Plant = "rbxassetid://10723407389",
    Flower = "rbxassetid://10734950309",
    Tree = "rbxassetid://10734929261",
    Harvest = "rbxassetid://10734896206",
    Watering = "rbxassetid://10747384394",
    
    -- Tools & Gear
    Shovel = "rbxassetid://10723434711",
    WateringCan = "rbxassetid://10723407389",
    Fertilizer = "rbxassetid://10734950309",
    Sprinkler = "rbxassetid://10734929261",
    Basket = "rbxassetid://10734896206",
    Hoe = "rbxassetid://10747384394",
    
    -- Pets & Animals
    Pet = "rbxassetid://10723434711",
    Egg = "rbxassetid://10723407389",
    Dragon = "rbxassetid://10734950309",
    Phoenix = "rbxassetid://10734929261",
    Unicorn = "rbxassetid://10734896206",
    Cat = "rbxassetid://10747384394",
    
    -- Status Icons
    Play = "rbxassetid://10734896851",
    Pause = "rbxassetid://10734896851",
    Stop = "rbxassetid://10734896851",
    Check = "rbxassetid://10734896851",
    X = "rbxassetid://10734896851",
    Warning = "rbxassetid://10734896851",
    
    -- Navigation
    ArrowUp = "rbxassetid://10734896851",
    ArrowDown = "rbxassetid://10734896851",
    ArrowLeft = "rbxassetid://10734896851",
    ArrowRight = "rbxassetid://10734896851",
    
    -- Advanced
    Lightning = "rbxassetid://10734896851",
    Fire = "rbxassetid://10734896851",
    Water = "rbxassetid://10734896851",
    Earth = "rbxassetid://10734896851",
    Air = "rbxassetid://10734896851",
    Magic = "rbxassetid://10734896851"
}

-- ========================================
-- 📱 MOBILE OPTIMIZATION
-- ========================================

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local screenSize = workspace.CurrentCamera.ViewportSize

-- ========================================
-- 💾 DATA CONFIGURATION
-- ========================================

local ScriptData = {
    Version = "3.0.0 ULTIMATE",
    Author = "Ultimate Scripts",
    LastUpdate = "2025",
    Features = {
        "🚀 Auto Farm System",
        "💎 Premium UI Design", 
        "📱 Mobile Optimized",
        "🎨 Multiple Themes",
        "⚡ Lightning Fast",
        "🛡️ Anti-Detect",
        "🔄 Auto-Save Settings",
        "📊 Advanced Statistics"
    }
}

local isScriptActive = {
    speed = false,
    seeds = {},
    gear = {},
    pets = {},
    autoFarm = false,
    autoCollect = false,
    autoSell = false
}

local currentLoops = {
    seeds = {},
    gear = {},
    pets = {},
    autoFarm = nil,
    autoCollect = nil,
    autoSell = nil
}

local playerSpeed = 100
local currentStats = {
    totalEarned = 0,
    seedsPlanted = 0,
    itemsBought = 0,
    runtime = 0,
    startTime = tick()
}

-- ========================================
-- 🌱 COMPREHENSIVE GAME DATA
-- ========================================

local GameData = {
    Seeds = {
        Basic = {
            "Carrot", "Lettuce", "Potato", "Tomato", "Onion", "Cabbage", "Corn", "Wheat",
            "Radish", "Beetroot", "Spinach", "Broccoli", "Cauliflower", "Cucumber"
        },
        Fruits = {
            "Strawberry", "Blueberry", "Raspberry", "Blackberry", "Cherry", "Apple", 
            "Orange", "Banana", "Grape", "Lemon", "Lime", "Peach", "Pear", "Plum",
            "Apricot", "Mango", "Pineapple", "Papaya", "Coconut", "Avocado", "Kiwi"
        },
        Flowers = {
            "Rose", "Tulip", "Daisy", "Lily", "Orchid", "Jasmine", "Hibiscus", 
            "Marigold", "Sunflower", "Lavender"
        },
        Special = {
            "Dragon Pepper", "Moon Mango", "Maple Apple", "Spiked Mango", "Fossilight Fruit",
            "Bone Blossom", "Candy Blossom", "Crystal Berry", "Golden Wheat", "Silver Corn",
            "Diamond Carrot", "Ruby Tomato", "Emerald Lettuce", "Sapphire Grape",
            "Phoenix Berry", "Unicorn Root", "Dragon Fruit", "Star Seed", "Galaxy Grain"
        },
        Rare = {
            "Rainbow Fruit", "Void Berry", "Time Seed", "Space Grain", "Cosmic Corn",
            "Infinity Apple", "Quantum Carrot", "Mystic Mango", "Celestial Cherry",
            "Divine Daisy", "Sacred Sunflower", "Holy Herb", "Blessed Berry"
        }
    },
    
    Gear = {
        WateringCans = {
            "Watering Can", "Advanced Watering Can", "Premium Watering Can", 
            "Golden Watering Can", "Diamond Watering Can", "Crystal Watering Can",
            "Master Watering Can", "Godly Watering Can", "Legendary Watering Can",
            "Mythic Watering Can", "Divine Watering Can", "Infinity Watering Can"
        },
        Tools = {
            "Shovel", "Advanced Shovel", "Premium Shovel", "Golden Shovel", 
            "Diamond Shovel", "Crystal Shovel", "Master Shovel", "Godly Shovel",
            "Hoe", "Advanced Hoe", "Premium Hoe", "Golden Hoe", "Diamond Hoe"
        },
        Sprinklers = {
            "Basic Sprinkler", "Advanced Sprinkler", "Premium Sprinkler", 
            "Golden Sprinkler", "Diamond Sprinkler", "Crystal Sprinkler",
            "Master Sprinkler", "Godly Sprinkler", "Auto Sprinkler"
        },
        Fertilizers = {
            "Basic Fertilizer", "Advanced Fertilizer", "Premium Fertilizer",
            "Golden Fertilizer", "Diamond Fertilizer", "Crystal Fertilizer",
            "Master Fertilizer", "Godly Fertilizer", "Mega Fertilizer"
        },
        Storage = {
            "Seed Bag", "Large Seed Bag", "Mega Seed Bag", "Storage Chest",
            "Large Chest", "Mega Chest", "Warehouse", "Mega Warehouse"
        }
    },
    
    Pets = {
        Common = {
            "Common Egg", "Basic Egg", "Starter Egg", "Simple Egg", "Regular Egg"
        },
        Uncommon = {
            "Uncommon Egg", "Enhanced Egg", "Improved Egg", "Better Egg", "Superior Egg"
        },
        Rare = {
            "Rare Egg", "Rare Summer Egg", "Rare Winter Egg", "Rare Spring Egg", 
            "Rare Autumn Egg", "Special Rare Egg", "Limited Rare Egg"
        },
        Epic = {
            "Epic Egg", "Epic Fire Egg", "Epic Water Egg", "Epic Earth Egg", 
            "Epic Air Egg", "Epic Light Egg", "Epic Dark Egg"
        },
        Legendary = {
            "Legendary Egg", "Legendary Dragon Egg", "Legendary Phoenix Egg", 
            "Legendary Unicorn Egg", "Legendary Griffin Egg", "Legendary Hydra Egg"
        },
        Mythical = {
            "Mythical Egg", "Mythical Celestial Egg", "Mythical Cosmic Egg", 
            "Mythical Divine Egg", "Mythical Infinity Egg", "Mythical God Egg"
        },
        Event = {
            "Halloween Egg", "Christmas Egg", "Easter Egg", "Valentine Egg", 
            "New Year Egg", "Summer Event Egg", "Winter Event Egg"
        },
        Special = {
            "Golden Egg", "Silver Egg", "Diamond Egg", "Platinum Egg", 
            "Crystal Egg", "Rainbow Egg", "Void Egg", "Shadow Egg"
        }
    }
}

-- ========================================
-- 🎨 ADVANCED UI COMPONENTS
-- ========================================

local function createGlow(parent, size, color)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Parent = parent
    glow.Size = size or UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = color or currentTheme.Accent
    glow.ImageTransparency = 0.5
    glow.ZIndex = -1
    return glow
end

local function createGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Parent = parent
    gradient.Color = ColorSequence.new(colors)
    gradient.Rotation = rotation or 0
    return gradient
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.Parent = parent
    corner.CornerRadius = UDim.new(0, radius or 12)
    return corner
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Parent = parent
    stroke.Color = color or currentTheme.Border
    stroke.Thickness = thickness or 1
    return stroke
end

local function createIcon(parent, iconId, size, position, color)
    local icon = Instance.new("ImageLabel")
    icon.Parent = parent
    icon.Size = UDim2.new(0, size or 24, 0, size or 24)
    icon.Position = position or UDim2.new(0, 0, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = color or currentTheme.Text
    icon.ScaleType = Enum.ScaleType.Fit
    return icon
end

local function createButton(parent, text, position, size, onClick, style)
    style = style or "primary"
    
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Size = size or UDim2.new(0, 120, 0, 40)
    button.Position = position or UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = style == "primary" and currentTheme.Accent or 
                              style == "success" and currentTheme.Success or
                              style == "danger" and currentTheme.Error or
                              currentTheme.Secondary
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = currentTheme.Text
    button.TextSize = isMobile and 16 or 14
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    
    createCorner(button, 8)
    createStroke(button, currentTheme.Border, 1)
    
    -- إضافة تأثيرات الحركة
    local originalSize = button.Size
    local originalColor = button.BackgroundColor3
    
    button.MouseEnter:Connect(function()
        local hoverColor = Color3.new(
            math.min(originalColor.R + 0.1, 1),
            math.min(originalColor.G + 0.1, 1),
            math.min(originalColor.B + 0.1, 1)
        )
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = hoverColor,
            Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset + 4, 
                           originalSize.Y.Scale, originalSize.Y.Offset + 2)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor,
            Size = originalSize
        }):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 2, 
                           originalSize.Y.Scale, originalSize.Y.Offset - 1)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = originalSize
        }):Play()
    end)
    
    if onClick then
        button.MouseButton1Click:Connect(onClick)
    end
    
    return button
end

local function createToggleSwitch(parent, position, size, onToggle, defaultState)
    defaultState = defaultState or false
    
    local switchFrame = Instance.new("Frame")
    switchFrame.Parent = parent
    switchFrame.Size = size or UDim2.new(0, 60, 0, 30)
    switchFrame.Position = position or UDim2.new(0, 0, 0, 0)
    switchFrame.BackgroundColor3 = defaultState and currentTheme.Success or currentTheme.TextSecondary
    switchFrame.BorderSizePixel = 0
    
    createCorner(switchFrame, 15)
    
    local switchButton = Instance.new("Frame")
    switchButton.Parent = switchFrame
    switchButton.Size = UDim2.new(0, 26, 0, 26)
    switchButton.Position = defaultState and UDim2.new(0, 32, 0, 2) or UDim2.new(0, 2, 0, 2)
    switchButton.BackgroundColor3 = currentTheme.Text
    switchButton.BorderSizePixel = 0
    
    createCorner(switchButton, 13)
    createGlow(switchButton, UDim2.new(1, 6, 1, 6), currentTheme.Accent)
    
    local clickDetector = Instance.new("TextButton")
    clickDetector.Parent = switchFrame
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    
    local isToggled = defaultState
    
    clickDetector.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        -- تحريك الزر
        TweenService:Create(switchButton, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = isToggled and UDim2.new(0, 32, 0, 2) or UDim2.new(0, 2, 0, 2)
        }):Play()
        
        -- تغيير لون الخلفية
        TweenService:Create(switchFrame, TweenInfo.new(0.3), {
            BackgroundColor3 = isToggled and currentTheme.Success or currentTheme.TextSecondary
        }):Play()
        
        if onToggle then
            onToggle(isToggled)
        end
    end)
    
    return switchFrame, function() return isToggled end
end

local function createCard(parent, position, size, title, icon)
    local card = Instance.new("Frame")
    card.Parent = parent
    card.Size = size or UDim2.new(0, 300, 0, 100)
    card.Position = position or UDim2.new(0, 0, 0, 0)
    card.BackgroundColor3 = currentTheme.Secondary
    card.BorderSizePixel = 0
    
    createCorner(card, 12)
    createStroke(card, currentTheme.Border, 1)
    createGlow(card, UDim2.new(1, 10, 1, 10), currentTheme.Accent)
    
    if icon then
        createIcon(card, icon, 32, UDim2.new(0, 15, 0, 15), currentTheme.Accent)
    end
    
    if title then
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Parent = card
        titleLabel.Size = UDim2.new(1, icon and -60 or -20, 0, 30)
        titleLabel.Position = UDim2.new(0, icon and 55 or 10, 0, 10)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = currentTheme.Text
        titleLabel.TextSize = isMobile and 18 or 16
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    end
    
    return card
end

-- ========================================
-- 📱 MOBILE SHORTCUT CREATION
-- ========================================

local function createMobileShortcut()
    local shortcutGui = Instance.new("ScreenGui")
    shortcutGui.Name = "GrowGardenShortcut"
    shortcutGui.Parent = CoreGui
    shortcutGui.ResetOnSpawn = false
    shortcutGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local shortcutButton = Instance.new("TextButton")
    shortcutButton.Parent = shortcutGui
    shortcutButton.Size = UDim2.new(0, 60, 0, 60)
    shortcutButton.Position = UDim2.new(0, 20, 0.5, -30)
    shortcutButton.BackgroundColor3 = currentTheme.Accent
    shortcutButton.BorderSizePixel = 0
    shortcutButton.Text = ""
    shortcutButton.Active = true
    shortcutButton.Draggable = true
    
    createCorner(shortcutButton, 30)
    createGlow(shortcutButton, UDim2.new(1, 20, 1, 20), currentTheme.Accent)
    
    -- إضافة أيقونة
    local icon = createIcon(shortcutButton, Icons.Plant, 36, UDim2.new(0.5, -18, 0.5, -18), currentTheme.Text)
    
    -- تأثير النبض
    spawn(function()
        while shortcutButton.Parent do
            TweenService:Create(shortcutButton, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                Size = UDim2.new(0, 65, 0, 65)
            }):Play()
            wait(1)
        end
    end)
    
    return shortcutButton
end

-- ========================================
-- 🚀 MAIN GUI CREATION - ULTIMATE DESIGN
-- ========================================

local function createMainGUI()
    -- إزالة أي واجهة موجودة
    if playerGui:FindFirstChild("UltimateGrowGarden") then
        playerGui:FindFirstChild("UltimateGrowGarden"):Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UltimateGrowGarden"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- حساب الحجم المناسب للشاشة
    local guiSize = isMobile and UDim2.new(0.95, 0, 0.85, 0) or UDim2.new(0, 1000, 0, 650)
    local guiPosition = isMobile and UDim2.new(0.025, 0, 0.075, 0) or UDim2.new(0.5, -500, 0.5, -325)
    
    -- الإطار الرئيسي
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.Size = guiSize
    mainFrame.Position = guiPosition
    mainFrame.BackgroundColor3 = currentTheme.Primary
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = not isMobile
    mainFrame.Visible = false -- مخفي في البداية
    
    createCorner(mainFrame, 20)
    createStroke(mainFrame, currentTheme.Border, 2)
    createGlow(mainFrame, UDim2.new(1, 40, 1, 40), currentTheme.Accent)
    
    -- شريط العنوان المتطور
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Parent = mainFrame
    titleBar.Size = UDim2.new(1, 0, 0, isMobile and 70 or 60)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = currentTheme.Secondary
    titleBar.BorderSizePixel = 0
    
    createCorner(titleBar, 20)
    createGradient(titleBar, {currentTheme.Accent, currentTheme.Success}, 45)
    
    -- لوجو متحرك
    local logo = createIcon(titleBar, Icons.Plant, isMobile and 40 or 36, 
                          UDim2.new(0, 20, 0.5, isMobile and -20 or -18), currentTheme.Text)
    
    -- عنوان متحرك
    local titleText = Instance.new("TextLabel")
    titleText.Parent = titleBar
    titleText.Size = UDim2.new(1, -200, 1, 0)
    titleText.Position = UDim2.new(0, isMobile and 70 or 65, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "🌱 ULTIMATE GROW A GARDEN 🌱"
    titleText.TextColor3 = currentTheme.Text
    titleText.TextSize = isMobile and 20 or 18
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- إضافة تأثير وميض للعنوان
    spawn(function()
        while titleText.Parent do
            for i = 0, 1, 0.1 do
                titleText.TextTransparency = i
                wait(0.1)
            end
            for i = 1, 0, -0.1 do
                titleText.TextTransparency = i
                wait(0.1)
            end
        end
    end)
    
    -- معلومات الإصدار
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Parent = titleBar
    versionLabel.Size = UDim2.new(0, 100, 0, 20)
    versionLabel.Position = UDim2.new(1, -140, 0, 5)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "v" .. ScriptData.Version
    versionLabel.TextColor3 = currentTheme.TextSecondary
    versionLabel.TextSize = isMobile and 12 or 10
    versionLabel.Font = Enum.Font.Gotham
    
    -- أزرار التحكم المتطورة
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Parent = titleBar
    controlsFrame.Size = UDim2.new(0, isMobile and 120 : 100, 1, -10)
    controlsFrame.Position = UDim2.new(1, isMobile and -125 or -105, 0, 5)
    controlsFrame.BackgroundTransparency = 1
    
    -- زر التصغير
    local minimizeBtn = createButton(controlsFrame, "−", UDim2.new(0, 0, 0, 0), 
                                   UDim2.new(0, isMobile and 35 or 30, 1, 0), 
                                   function()
                                       mainFrame.Visible = false
                                   end, "warning")
    
    -- زر الإغلاق
    local closeBtn = createButton(controlsFrame, "✕", 
                                UDim2.new(0, isMobile and 40 or 35, 0, 0), 
                                UDim2.new(0, isMobile and 35 or 30, 1, 0), 
                                function()
                                    screenGui:Destroy()
                                end, "danger")
    
    -- الشريط الجانبي المتطور
    local sidebarWidth = isMobile and 80 or 220
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Parent = mainFrame
    sidebar.Size = UDim2.new(0, sidebarWidth, 1, -(isM
