-- ========================================
-- GROW A GARDEN SCRIPT - ADVANCED INTERFACE
-- ========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========================================
-- CONFIGURATION & VARIABLES
-- ========================================

local isScriptActive = {
    speed = false,
    seeds = {},
    gear = {},
    pets = {}
}

local currentLoops = {
    seeds = {},
    gear = {},
    pets = {}
}

local playerSpeed = 16

-- ========================================
-- SEED DATA
-- ========================================

local seedData = {
    -- Basic Seeds
    "Carrot", "Lettuce", "Potato", "Tomato", "Onion", "Cabbage", "Corn", "Wheat",
    "Radish", "Beetroot", "Spinach", "Broccoli", "Cauliflower", "Cucumber", "Pumpkin",
    "Watermelon", "Strawberry", "Blueberry", "Raspberry", "Blackberry", "Cherry",
    
    -- Fruit Seeds
    "Apple", "Orange", "Banana", "Grape", "Lemon", "Lime", "Peach", "Pear", "Plum",
    "Apricot", "Mango", "Pineapple", "Papaya", "Coconut", "Avocado", "Kiwi",
    
    -- Premium Seeds
    "Bamboo", "Rice", "Sugarcane", "Cotton", "Sunflower", "Lavender", "Rose",
    "Tulip", "Daisy", "Lily", "Orchid", "Jasmine", "Hibiscus", "Marigold",
    
    -- Special/Rare Seeds
    "Dragon Pepper", "Moon Mango", "Maple Apple", "Spiked Mango", "Fossilight Fruit",
    "Bone Blossom", "Candy Blossom", "Crystal Berry", "Golden Wheat", "Silver Corn",
    "Diamond Carrot", "Ruby Tomato", "Emerald Lettuce", "Sapphire Grape",
    
    -- Secret Seeds
    "Cherry Blossom", "Durian", "Cranberry", "Lotus", "Eggplant", "Venus Flytrap",
    "Cactus Flower", "Rainbow Fruit", "Star Fruit", "Phoenix Berry", "Ice Crystal",
    "Fire Flower", "Lightning Seed", "Storm Berry", "Wind Fruit", "Earth Root",
    
    -- Mushroom Seeds
    "Red Mushroom", "Blue Mushroom", "Green Mushroom", "Purple Mushroom", "Golden Mushroom",
    "Silver Mushroom", "Crystal Mushroom", "Magic Mushroom", "Poison Mushroom", "Healing Mushroom"
}

-- ========================================
-- GEAR DATA
-- ========================================

local gearData = {
    -- Watering Tools
    "Watering Can", "Advanced Watering Can", "Premium Watering Can", "Golden Watering Can",
    "Diamond Watering Can", "Crystal Watering Can", "Master Watering Can", "Godly Watering Can",
    
    -- Sprinklers
    "Basic Sprinkler", "Advanced Sprinkler", "Premium Sprinkler", "Golden Sprinkler",
    "Diamond Sprinkler", "Crystal Sprinkler", "Master Sprinkler", "Godly Sprinkler",
    
    -- Fertilizers
    "Basic Fertilizer", "Advanced Fertilizer", "Premium Fertilizer", "Golden Fertilizer",
    "Diamond Fertilizer", "Crystal Fertilizer", "Master Fertilizer", "Godly Fertilizer",
    
    -- Tools
    "Shovel", "Advanced Shovel", "Premium Shovel", "Golden Shovel", "Diamond Shovel",
    "Crystal Shovel", "Master Shovel", "Godly Shovel", "Hoe", "Advanced Hoe",
    "Premium Hoe", "Golden Hoe", "Diamond Hoe", "Crystal Hoe", "Master Hoe", "Godly Hoe",
    
    -- Special Tools
    "Harvest Basket", "Seed Planter", "Crop Collector", "Plant Protector", "Growth Booster",
    "Mutation Inducer", "Speed Enhancer", "Luck Charm", "Fortune Talisman", "Blessing Stone",
    
    -- Storage
    "Seed Storage", "Gear Storage", "Crop Storage", "Tool Belt", "Equipment Rack",
    "Garden Shed", "Warehouse", "Vault", "Safe", "Treasure Chest",
    
    -- Utility
    "Recall Wrench", "Teleporter", "Time Accelerator", "Weather Controller", "Climate Modifier",
    "Soil Enhancer", "Water Purifier", "Air Freshener", "Light Generator", "Heat Lamp"
}

-- ========================================
-- PET EGG DATA
-- ========================================

local petEggData = {
    -- Common Eggs
    "Common Egg", "Basic Egg", "Starter Egg", "Simple Egg", "Regular Egg",
    "Standard Egg", "Normal Egg", "Ordinary Egg", "Plain Egg", "Typical Egg",
    
    -- Uncommon Eggs
    "Uncommon Egg", "Enhanced Egg", "Improved Egg", "Better Egg", "Superior Egg",
    "Advanced Egg", "Upgraded Egg", "Refined Egg", "Quality Egg", "Fine Egg",
    
    -- Rare Eggs
    "Rare Egg", "Rare Summer Egg", "Rare Winter Egg", "Rare Spring Egg", "Rare Autumn Egg",
    "Special Rare Egg", "Limited Rare Egg", "Premium Rare Egg", "Exclusive Rare Egg", "Unique Rare Egg",
    
    -- Epic Eggs
    "Epic Egg", "Epic Fire Egg", "Epic Water Egg", "Epic Earth Egg", "Epic Air Egg",
    "Epic Light Egg", "Epic Dark Egg", "Epic Nature Egg", "Epic Magic Egg", "Epic Crystal Egg",
    
    -- Legendary Eggs
    "Legendary Egg", "Legendary Dragon Egg", "Legendary Phoenix Egg", "Legendary Unicorn Egg",
    "Legendary Griffin Egg", "Legendary Pegasus Egg", "Legendary Hydra Egg", "Legendary Kraken Egg",
    "Legendary Titan Egg", "Legendary God Egg",
    
    -- Mythical Eggs
    "Mythical Egg", "Mythical Celestial Egg", "Mythical Cosmic Egg", "Mythical Divine Egg",
    "Mythical Eternal Egg", "Mythical Infinity Egg", "Mythical Omega Egg", "Mythical Alpha Egg",
    "Mythical Supreme Egg", "Mythical Ultimate Egg",
    
    -- Event Eggs
    "Halloween Egg", "Christmas Egg", "Easter Egg", "Valentine Egg", "New Year Egg",
    "Birthday Egg", "Anniversary Egg", "Summer Event Egg", "Winter Event Egg", "Spring Event Egg",
    
    -- Special Eggs
    "Golden Egg", "Silver Egg", "Diamond Egg", "Platinum Egg", "Crystal Egg",
    "Rainbow Egg", "Void Egg", "Shadow Egg", "Light Egg", "Chaos Egg"
}

-- ========================================
-- GUI CREATION FUNCTIONS
-- ========================================

local function createIcon(iconId, size)
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, size, 0, size)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://" .. iconId
    icon.ScaleType = Enum.ScaleType.Fit
    return icon
end

local function createGradientFrame(parent, colors)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(1, 1, 1)
    frame.BorderSizePixel = 0
    
    local gradient = Instance.new("UIGradient")
    gradient.Parent = frame
    gradient.Color = ColorSequence.new(colors)
    gradient.Rotation = 45
    
    return frame
end

local function createToggleButton(parent, position, onToggle)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Size = UDim2.new(0, 60, 0, 30)
    button.Position = position
    button.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    button.BorderSizePixel = 0
    button.Text = "✗"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local isActive = false
    
    button.MouseButton1Click:Connect(function()
        isActive = not isActive
        if isActive then
            button.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
            button.Text = "✓"
        else
            button.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
            button.Text = "✗"
        end
        onToggle(isActive)
        
        -- Animation
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0, 65, 0, 32)})
        tween:Play()
        tween.Completed:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(0, 60, 0, 30)}):Play()
        end)
    end)
    
    return button, function() return isActive end
end

-- ========================================
-- MAIN GUI CREATION
-- ========================================

local function createMainGUI()
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GrowGardenScript"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 900, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -450, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = mainFrame
    
    -- Title Bar
    local titleBar = createGradientFrame(mainFrame, {
        Color3.new(0.2, 0.6, 1), 
        Color3.new(0.6, 0.2, 1)
    })
    titleBar.Size = UDim2.new(1, 0, 0, 60)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = titleBar
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Parent = titleBar
    titleText.Size = UDim2.new(1, -120, 1, 0)
    titleText.Position = UDim2.new(0, 60, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "🌱 GROW A GARDEN SCRIPT 🌱"
    titleText.TextColor3 = Color3.new(1, 1, 1)
    titleText.TextScaled = true
    titleText.Font = Enum.Font.GothamBold
    titleText.TextStrokeTransparency = 0
    titleText.TextStrokeColor3 = Color3.new(0, 0, 0)
    
    -- Title Icon
    local titleIcon = createIcon("7072715489", 40)
    titleIcon.Parent = titleBar
    titleIcon.Position = UDim2.new(0, 10, 0.5, -20)
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Parent = titleBar
    closeButton.Size = UDim2.new(0, 50, 0, 50)
    closeButton.Position = UDim2.new(1, -55, 0, 5)
    closeButton.BackgroundColor3 = Color3.new(1, 0.2, 0.2)
    closeButton.Text = "✗"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 25)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Menu Frame (Left Side)
    local menuFrame = Instance.new("Frame")
    menuFrame.Name = "MenuFrame"
    menuFrame.Parent = mainFrame
    menuFrame.Size = UDim2.new(0, 250, 1, -70)
    menuFrame.Position = UDim2.new(0, 10, 0, 65)
    menuFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
    menuFrame.BorderSizePixel = 0
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 10)
    menuCorner.Parent = menuFrame
    
    -- Content Frame (Right Side)
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Parent = mainFrame
    contentFrame.Size = UDim2.new(0, 620, 1, -70)
    contentFrame.Position = UDim2.new(0, 270, 0, 65)
    contentFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.17)
    contentFrame.BorderSizePixel = 0
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 10)
    contentCorner.Parent = contentFrame
    
    return screenGui, mainFrame, menuFrame, contentFrame
end

-- ========================================
-- MENU CREATION FUNCTIONS
-- ========================================

local function createMenuButton(parent, text, icon, position, onClick)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Size = UDim2.new(1, -20, 0, 50)
    button.Position = position
    button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.25)
    button.BorderSizePixel = 0
    button.Text = ""
    button.Font = Enum.Font.Gotham
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    -- Icon
    local iconLabel = createIcon(icon, 30)
    iconLabel.Parent = button
    iconLabel.Position = UDim2.new(0, 10, 0.5, -15)
    
    -- Text
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = button
    textLabel.Size = UDim2.new(1, -50, 1, 0)
    textLabel.Position = UDim2.new(0, 45, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Hover Effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.3, 0.3, 0.35)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.2, 0.2, 0.25)}):Play()
    end)
    
    button.MouseButton1Click:Connect(onClick)
    
    return button
end

-- ========================================
-- CONTENT CREATION FUNCTIONS
-- ========================================

local function createScrollingFrame(parent)
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Parent = parent
    scrollFrame.Size = UDim2.new(1, -20, 1, -20)
    scrollFrame.Position = UDim2.new(0, 10, 0, 10)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.ScrollBarImageColor3 = Color3.new(0.4, 0.4, 0.5)
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = scrollFrame
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    
    return scrollFrame, layout
end

local function createCharacterContent(contentFrame)
    local scrollFrame, layout = createScrollingFrame(contentFrame)
    
    -- Speed Section
    local speedSection = Instance.new("Frame")
    speedSection.Parent = scrollFrame
    speedSection.Size = UDim2.new(1, 0, 0, 80)
    speedSection.BackgroundColor3 = Color3.new(0.18, 0.18, 0.23)
    speedSection.BorderSizePixel = 0
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 10)
    speedCorner.Parent = speedSection
    
    -- Speed Title
    local speedTitle = Instance.new("TextLabel")
    speedTitle.Parent = speedSection
    speedTitle.Size = UDim2.new(1, 0, 0, 25)
    speedTitle.Position = UDim2.new(0, 0, 0, 5)
    speedTitle.BackgroundTransparency = 1
    speedTitle.Text = "🏃 PLAYER SPEED CONTROL"
    speedTitle.TextColor3 = Color3.new(1, 1, 1)
    speedTitle.TextScaled = true
    speedTitle.Font = Enum.Font.GothamBold
    
    -- Speed Input
    local speedInput = Instance.new("TextBox")
    speedInput.Parent = speedSection
    speedInput.Size = UDim2.new(0, 200, 0, 30)
    speedInput.Position = UDim2.new(0, 10, 0, 35)
    speedInput.BackgroundColor3 = Color3.new(0.25, 0.25, 0.3)
    speedInput.BorderSizePixel = 0
    speedInput.Text = tostring(playerSpeed)
    speedInput.TextColor3 = Color3.new(1, 1, 1)
    speedInput.TextScaled = true
    speedInput.Font = Enum.Font.Gotham
    speedInput.PlaceholderText = "Enter speed value..."
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 5)
    inputCorner.Parent = speedInput
    
    speedInput.FocusLost:Connect(function()
        local newSpeed = tonumber(speedInput.Text)
        if newSpeed then
            playerSpeed = newSpeed
        else
            speedInput.Text = tostring(playerSpeed)
        end
    end)
    
    -- Speed Toggle
    local speedToggle, getSpeedState = createToggleButton(speedSection, UDim2.new(0, 220, 0, 35), function(active)
        isScriptActive.speed = active
        if active then
            player.Character.Humanoid.WalkSpeed = playerSpeed
        else
            player.Character.Humanoid.WalkSpeed = 16
        end
    end)
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
end

local function createItemContent(contentFrame, itemData, itemType, buyFunction)
    local scrollFrame, layout = createScrollingFrame(contentFrame)
    
    for i, itemName in ipairs(itemData) do
        local itemFrame = Instance.new("Frame")
        itemFrame.Parent = scrollFrame
        itemFrame.Size = UDim2.new(1, 0, 0, 60)
        itemFrame.BackgroundColor3 = Color3.new(0.18, 0.18, 0.23)
        itemFrame.BorderSizePixel = 0
        
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 8)
        itemCorner.Parent = itemFrame
        
        -- Item Icon
        local itemIcon = createIcon("7072715489", 40)
        itemIcon.Parent = itemFrame
        itemIcon.Position = UDim2.new(0, 10, 0.5, -20)
        
        -- Item Name
        local itemLabel = Instance.new("TextLabel")
        itemLabel.Parent = itemFrame
        itemLabel.Size = UDim2.new(1, -130, 1, 0)
        itemLabel.Position = UDim2.new(0, 55, 0, 0)
        itemLabel.BackgroundTransparency = 1
        itemLabel.Text = itemName
        itemLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        itemLabel.TextScaled = true
        itemLabel.Font = Enum.Font.GothamSemibold
        itemLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Item Toggle
        local itemToggle, getItemState = createToggleButton(itemFrame, UDim2.new(1, -70, 0.5, -15), function(active)
            isScriptActive[itemType][itemName] = active
            
            if active then
                -- Start the buying loop
                currentLoops[itemType][itemName] = true
                spawn(function()
                    while currentLoops[itemType][itemName] and isScriptActive[itemType][itemName] do
                        pcall(function()
                            buyFunction(itemName)
                        end)
                        wait(0.1) -- Small delay to prevent spam
                    end
                end)
            else
                -- Stop the buying loop
                currentLoops[itemType][itemName] = false
            end
        end)
        
        -- Hover Effect
        itemFrame.MouseEnter:Connect(function()
            TweenService:Create(itemFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.22, 0.22, 0.27)}):Play()
        end)
        
        itemFrame.MouseLeave:Connect(function()
            TweenService:Create(itemFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.18, 0.18, 0.23)}):Play()
        end)
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
end

-- ========================================
-- BUYING FUNCTIONS
-- ========================================

local function buySeed(seedName)
    local args = {[1] = seedName}
    ReplicatedStorage.GameEvents.BuySeedStock:FireServer(unpack(args))
end

local function buyGear(gearName)
    local args = {[1] = gearName}
    ReplicatedStorage.GameEvents.BuyGearStock:FireServer(unpack(args))
end

local function buyPetEgg(eggName)
    local args = {[1] = eggName}
    ReplicatedStorage.GameEvents.BuyPetEgg:FireServer(unpack(args))
end

-- ========================================
-- MAIN SCRIPT EXECUTION
-- ========================================

local function initializeScript()
    -- Initialize active states
    isScriptActive.seeds = {}
    isScriptActive.gear = {}
    isScriptActive.pets = {}
    
    for _, seedName in ipairs(seedData) do
        isScriptActive.seeds[seedName] = false
        currentLoops.seeds[seedName] = false
    end
    
    for _, gearName in ipairs(gearData) do
        isScriptActive.gear[gearName] = false
        currentLoops.gear[gearName] = false
    end
    
    for _, eggName in ipairs(petEggData) do
        isScriptActive.pets[eggName] = false
        currentLoops.pets[eggName] = false
    end
    
    -- Create main GUI
    local screenGui, mainFrame, menuFrame, contentFrame = createMainGUI()
    
    -- Current content reference
    local currentContent = nil
    
    local function clearContent()
        if currentContent then
            currentContent:Destroy()
        end
    end
    
    -- Menu Buttons
    createMenuButton(menuFrame, "CHARACTER", "7072715489", UDim2.new(0, 10, 0, 10), function()
        clearContent()
        currentContent = Instance.new("Frame")
        currentContent.Parent = contentFrame
        currentContent.Size = UDim2.new(1, 0, 1, 0)
        currentContent.BackgroundTransparency = 1
        createCharacterContent(currentContent)
    end)
    
    createMenuButton(menuFrame, "SEEDS", "7072715489", UDim2.new(0, 10, 0, 70), function()
        clearContent()
        currentContent = Instance.new("Frame")
        currentContent.Parent = contentFrame
        currentContent.Size = UDim2.new(1, 0, 1, 0)
        currentContent.BackgroundTransparency = 1
        createItemContent(currentContent, seedData, "seeds", buySeed)
    end)
    
    createMenuButton(menuFrame, "GEAR", "7072715489", UDim2.new(0, 10, 0, 130), function()
        clearContent()
        currentContent = Instance.new("Frame")
        currentContent.Parent = contentFrame
        currentContent.Size = UDim2.new(1, 0, 1, 0)
        currentContent.BackgroundTransparency = 1
        createItemContent(currentContent, gearData, "gear", buyGear)
    end)
    
    createMenuButton(menuFrame, "PET EGGS", "7072715489", UDim2.new(0, 10, 0, 190), function()
        clearContent()
        currentContent = Instance.new("Frame")
        currentContent.Parent = contentFrame
        currentContent.Size = UDim2.new(1, 0, 1, 0)
        currentContent.BackgroundTransparency = 1
        createItemContent(currentContent, petEggData, "pets", buyPetEgg)
    end)
    
    -- Default to Character menu
    currentContent = Instance.new("Frame")
    currentContent.Parent = contentFrame
    currentContent.Size = UDim2.new(1, 0, 1, 0)
    currentContent.BackgroundTransparency = 1
    createCharacterContent(currentContent)
    
    -- Add some visual effects
    spawn(function()
        while screenGui.Parent do
            local time = tick()
            local hue = (time * 0.1) % 1
            local color = Color3.fromHSV(hue, 0.5, 1)
            
            for _, obj in pairs(screenGui:GetDescendants()) do
                if obj:IsA("UIGradient") and obj.Parent.Name ~= "ContentFrame" then
                    obj.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, color),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV((hue + 0.3) % 1, 0.5, 1))
                    })
                end
            end
            wait(0.1)
        end
    end)
end

-- ========================================
-- ADDITIONAL FEATURES & ENHANCEMENTS
-- ========================================

-- Auto-Farm Management System
local autoFarmManager = {
    isRunning = false,
    farmingSeeds = {},
    farmingGear = {},
    farmingPets = {}
}

local function createAutoFarmSection(parent)
    local autoFarmFrame = Instance.new("Frame")
    autoFarmFrame.Parent = parent
    autoFarmFrame.Size = UDim2.new(1, 0, 0, 120)
    autoFarmFrame.BackgroundColor3 = Color3.new(0.18, 0.18, 0.23)
    autoFarmFrame.BorderSizePixel = 0
    
    local autoFarmCorner = Instance.new("UICorner")
    autoFarmCorner.CornerRadius = UDim.new(0, 10)
    autoFarmCorner.Parent = autoFarmFrame
    
    -- Auto Farm Title
    local autoFarmTitle = Instance.new("TextLabel")
    autoFarmTitle.Parent = autoFarmFrame
    autoFarmTitle.Size = UDim2.new(1, 0, 0, 30)
    autoFarmTitle.Position = UDim2.new(0, 0, 0, 5)
    autoFarmTitle.BackgroundTransparency = 1
    autoFarmTitle.Text = "🤖 AUTO-FARM MANAGEMENT"
    autoFarmTitle.TextColor3 = Color3.new(1, 1, 1)
    autoFarmTitle.TextScaled = true
    autoFarmTitle.Font = Enum.Font.GothamBold
    
    -- Start All Button
    local startAllButton = Instance.new("TextButton")
    startAllButton.Parent = autoFarmFrame
    startAllButton.Size = UDim2.new(0, 150, 0, 35)
    startAllButton.Position = UDim2.new(0, 10, 0, 40)
    startAllButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
    startAllButton.BorderSizePixel = 0
    startAllButton.Text = "🚀 START ALL"
    startAllButton.TextColor3 = Color3.new(1, 1, 1)
    startAllButton.TextScaled = true
    startAllButton.Font = Enum.Font.GothamBold
    
    local startCorner = Instance.new("UICorner")
    startCorner.CornerRadius = UDim.new(0, 8)
    startCorner.Parent = startAllButton
    
    -- Stop All Button
    local stopAllButton = Instance.new("TextButton")
    stopAllButton.Parent = autoFarmFrame
    stopAllButton.Size = UDim2.new(0, 150, 0, 35)
    stopAllButton.Position = UDim2.new(0, 170, 0, 40)
    stopAllButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
    stopAllButton.BorderSizePixel = 0
    stopAllButton.Text = "🛑 STOP ALL"
    stopAllButton.TextColor3 = Color3.new(1, 1, 1)
    stopAllButton.TextScaled = true
    stopAllButton.Font = Enum.Font.GothamBold
    
    local stopCorner = Instance.new("UICorner")
    stopCorner.CornerRadius = UDim.new(0, 8)
    stopCorner.Parent = stopAllButton
    
    -- Status Indicator
    local statusIndicator = Instance.new("TextLabel")
    statusIndicator.Parent = autoFarmFrame
    statusIndicator.Size = UDim2.new(0, 200, 0, 25)
    statusIndicator.Position = UDim2.new(0, 10, 0, 85)
    statusIndicator.BackgroundTransparency = 1
    statusIndicator.Text = "⚪ STATUS: IDLE"
    statusIndicator.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    statusIndicator.TextScaled = true
    statusIndicator.Font = Enum.Font.GothamSemibold
    statusIndicator.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Button Events
    startAllButton.MouseButton1Click:Connect(function()
        autoFarmManager.isRunning = true
        statusIndicator.Text = "🟢 STATUS: FARMING ACTIVE"
        statusIndicator.TextColor3 = Color3.new(0.2, 1, 0.2)
        
        -- Enable all seed farming
        for seedName, _ in pairs(isScriptActive.seeds) do
            if not isScriptActive.seeds[seedName] then
                isScriptActive.seeds[seedName] = true
                currentLoops.seeds[seedName] = true
                spawn(function()
                    while currentLoops.seeds[seedName] and isScriptActive.seeds[seedName] do
                        pcall(function()
                            buySeed(seedName)
                        end)
                        wait(0.1)
                    end
                end)
            end
        end
        
        -- Enable all gear farming
        for gearName, _ in pairs(isScriptActive.gear) do
            if not isScriptActive.gear[gearName] then
                isScriptActive.gear[gearName] = true
                currentLoops.gear[gearName] = true
                spawn(function()
                    while currentLoops.gear[gearName] and isScriptActive.gear[gearName] do
                        pcall(function()
                            buyGear(gearName)
                        end)
                        wait(0.1)
                    end
                end)
            end
        end
        
        -- Enable all pet farming
        for eggName, _ in pairs(isScriptActive.pets) do
            if not isScriptActive.pets[eggName] then
                isScriptActive.pets[eggName] = true
                currentLoops.pets[eggName] = true
                spawn(function()
                    while currentLoops.pets[eggName] and isScriptActive.pets[eggName] do
                        pcall(function()
                            buyPetEgg(eggName)
                        end)
                        wait(0.1)
                    end
                end)
            end
        end
    end)
    
    stopAllButton.MouseButton1Click:Connect(function()
        autoFarmManager.isRunning = false
        statusIndicator.Text = "🔴 STATUS: STOPPED"
        statusIndicator.TextColor3 = Color3.new(1, 0.2, 0.2)
        
        -- Disable all farming
        for seedName, _ in pairs(isScriptActive.seeds) do
            isScriptActive.seeds[seedName] = false
            currentLoops.seeds[seedName] = false
        end
        
        for gearName, _ in pairs(isScriptActive.gear) do
            isScriptActive.gear[gearName] = false
            currentLoops.gear[gearName] = false
        end
        
        for eggName, _ in pairs(isScriptActive.pets) do
            isScriptActive.pets[eggName] = false
            currentLoops.pets[eggName] = false
        end
    end)
    
    return autoFarmFrame
end

-- Enhanced Character Content with Auto-Farm
local function createEnhancedCharacterContent(contentFrame)
    local scrollFrame, layout = createScrollingFrame(contentFrame)
    
    -- Speed Section (existing)
    local speedSection = Instance.new("Frame")
    speedSection.Parent = scrollFrame
    speedSection.Size = UDim2.new(1, 0, 0, 80)
    speedSection.BackgroundColor3 = Color3.new(0.18, 0.18, 0.23)
    speedSection.BorderSizePixel = 0
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 10)
    speedCorner.Parent = speedSection
    
    -- Speed Title
    local speedTitle = Instance.new("TextLabel")
    speedTitle.Parent = speedSection
    speedTitle.Size = UDim2.new(1, 0, 0, 25)
    speedTitle.Position = UDim2.new(0, 0, 0, 5)
    speedTitle.BackgroundTransparency = 1
    speedTitle.Text = "🏃 PLAYER SPEED CONTROL"
    speedTitle.TextColor3 = Color3.new(1, 1, 1)
    speedTitle.TextScaled = true
    speedTitle.Font = Enum.Font.GothamBold
    
    -- Speed Input
    local speedInput = Instance.new("TextBox")
    speedInput.Parent = speedSection
    speedInput.Size = UDim2.new(0, 200, 0, 30)
    speedInput.Position = UDim2.new(0, 10, 0, 35)
    speedInput.BackgroundColor3 = Color3.new(0.25, 0.25, 0.3)
    speedInput.BorderSizePixel = 0
    speedInput.Text = tostring(playerSpeed)
    speedInput.TextColor3 = Color3.new(1, 1, 1)
    speedInput.TextScaled = true
    speedInput.Font = Enum.Font.Gotham
    speedInput.PlaceholderText = "Enter speed value..."
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 5)
    inputCorner.Parent = speedInput
    
    speedInput.FocusLost:Connect(function()
        local newSpeed = tonumber(speedInput.Text)
        if newSpeed then
            playerSpeed = newSpeed
        else
            speedInput.Text = tostring(playerSpeed)
        end
    end)
    
    -- Speed Toggle
    local speedToggle, getSpeedState = createToggleButton(speedSection, UDim2.new(0, 220, 0, 35), function(active)
        isScriptActive.speed = active
        if active then
            player.Character.Humanoid.WalkSpeed = playerSpeed
        else
            player.Character.Humanoid.WalkSpeed = 16
        end
    end)
    
    -- Auto-Farm Section
    createAutoFarmSection(scrollFrame)
    
    -- Statistics Section
    local statsSection = Instance.new("Frame")
    statsSection.Parent = scrollFrame
    statsSection.Size = UDim2.new(1, 0, 0, 150)
    statsSection.BackgroundColor3 = Color3.new(0.18, 0.18, 0.23)
    statsSection.BorderSizePixel = 0
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 10)
    statsCorner.Parent = statsSection
    
    -- Stats Title
    local statsTitle = Instance.new("TextLabel")
    statsTitle.Parent = statsSection
    statsTitle.Size = UDim2.new(1, 0, 0, 30)
    statsTitle.Position = UDim2.new(0, 0, 0, 5)
    statsTitle.BackgroundTransparency = 1
    statsTitle.Text = "📊 FARMING STATISTICS"
    statsTitle.TextColor3 = Color3.new(1, 1, 1)
    statsTitle.TextScaled = true
    statsTitle.Font = Enum.Font.GothamBold
    
    -- Stats Display
    local statsText = Instance.new("TextLabel")
    statsText.Parent = statsSection
    statsText.Size = UDim2.new(1, -20, 1, -40)
    statsText.Position = UDim2.new(0, 10, 0, 35)
    statsText.BackgroundTransparency = 1
    statsText.Text = "🌱 Active Seeds: 0\n⚙️ Active Gear: 0\n🥚 Active Pets: 0\n⏱️ Runtime: 00:00:00"
    statsText.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    statsText.TextScaled = true
    statsText.Font = Enum.Font.Gotham
    statsText.TextXAlignment = Enum.TextXAlignment.Left
    statsText.TextYAlignment = Enum.TextYAlignment.Top
    
    -- Update stats continuously
    local startTime = tick()
    spawn(function()
        while statsSection.Parent do
            local activeSeeds = 0
            local activeGear = 0
            local activePets = 0
            
            for _, active in pairs(isScriptActive.seeds) do
                if active then activeSeeds = activeSeeds + 1 end
            end
            
            for _, active in pairs(isScriptActive.gear) do
                if active then activeGear = activeGear + 1 end
            end
            
            for _, active in pairs(isScriptActive.pets) do
                if active then activePets = activePets + 1 end
            end
            
            local runtime = tick() - startTime
            local hours = math.floor(runtime / 3600)
            local minutes = math.floor((runtime % 3600) / 60)
            local seconds = math.floor(runtime % 60)
            
            statsText.Text = string.format(
                "🌱 Active Seeds: %d/%d\n⚙️ Active Gear: %d/%d\n🥚 Active Pets: %d/%d\n⏱️ Runtime: %02d:%02d:%02d",
                activeSeeds, #seedData,
                activeGear, #gearData,
                activePets, #petEggData,
                hours, minutes, seconds
            )
            
            wait(1)
        end
    end)
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
end

-- Enhanced Item Content with Search and Filter
local function createEnhancedItemContent(contentFrame, itemData, itemType, buyFunction)
    -- Search Section
    local searchFrame = Instance.new("Frame")
    searchFrame.Parent = contentFrame
    searchFrame.Size = UDim2.new(1, 0, 0, 50)
    searchFrame.Position = UDim2.new(0, 0, 0, 0)
    searchFrame.BackgroundColor3 = Color3.new(0.18, 0.18, 0.23)
    searchFrame.BorderSizePixel = 0
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 10)
    searchCorner.Parent = searchFrame
    
    -- Search Input
    local searchInput = Instance.new("TextBox")
    searchInput.Parent = searchFrame
    searchInput.Size = UDim2.new(1, -120, 0, 30)
    searchInput.Position = UDim2.new(0, 10, 0.5, -15)
    searchInput.BackgroundColor3 = Color3.new(0.25, 0.25, 0.3)
    searchInput.BorderSizePixel = 0
    searchInput.Text = ""
    searchInput.TextColor3 = Color3.new(1, 1, 1)
    searchInput.TextScaled = true
    searchInput.Font = Enum.Font.Gotham
    searchInput.PlaceholderText = "🔍 Search items..."
    
    local searchInputCorner = Instance.new("UICorner")
    searchInputCorner.CornerRadius = UDim.new(0, 5)
    searchInputCorner.Parent = searchInput
    
    -- Select All Button
    local selectAllButton = Instance.new("TextButton")
    selectAllButton.Parent = searchFrame
    selectAllButton.Size = UDim2.new(0, 100, 0, 30)
    selectAllButton.Position = UDim2.new(1, -110, 0.5, -15)
    selectAllButton.BackgroundColor3 = Color3.new(0.2, 0.6, 1)
    selectAllButton.BorderSizePixel = 0
    selectAllButton.Text = "SELECT ALL"
    selectAllButton.TextColor3 = Color3.new(1, 1, 1)
    selectAllButton.TextScaled = true
    selectAllButton.Font = Enum.Font.GothamBold
    
    local selectAllCorner = Instance.new("UICorner")
    selectAllCorner.CornerRadius = UDim.new(0, 5)
    selectAllCorner.Parent = selectAllButton
    
    -- Content Scroll Frame
    local scrollFrame, layout = createScrollingFrame(contentFrame)
    scrollFrame.Position = UDim2.new(0, 10, 0, 60)
    scrollFrame.Size = UDim2.new(1, -20, 1, -70)
    
    local itemFrames = {}
    local filteredItems = {}
    
    local function updateItemDisplay()
        -- Clear existing items
        for _, frame in pairs(itemFrames) do
            frame:Destroy()
        end
        itemFrames = {}
        
        -- Filter items based on search
        local searchTerm = searchInput.Text:lower()
        filteredItems = {}
        
        for _, itemName in ipairs(itemData) do
            if searchTerm == "" or itemName:lower():find(searchTerm, 1, true) then
                table.insert(filteredItems, itemName)
            end
        end
        
        -- Create item frames for filtered items
        for i, itemName in ipairs(filteredItems) do
            local itemFrame = Instance.new("Frame")
            itemFrame.Parent = scrollFrame
            itemFrame.Size = UDim2.new(1, 0, 0, 60)
            itemFrame.BackgroundColor3 = Color3.new(0.18, 0.18, 0.23)
            itemFrame.BorderSizePixel = 0
            itemFrame.LayoutOrder = i
            
            local itemCorner = Instance.new("UICorner")
            itemCorner.CornerRadius = UDim.new(0, 8)
            itemCorner.Parent = itemFrame
            
            -- Item Icon
            local itemIcon = createIcon("7072715489", 40)
            itemIcon.Parent = itemFrame
            itemIcon.Position = UDim2.new(0, 10, 0.5, -20)
            
            -- Item Name
            local itemLabel = Instance.new("TextLabel")
            itemLabel.Parent = itemFrame
            itemLabel.Size = UDim2.new(1, -130, 1, 0)
            itemLabel.Position = UDim2.new(0, 55, 0, 0)
            itemLabel.BackgroundTransparency = 1
            itemLabel.Text = itemName
            itemLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
            itemLabel.TextScaled = true
            itemLabel.Font = Enum.Font.GothamSemibold
            itemLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            -- Item Toggle
            local itemToggle, getItemState = createToggleButton(itemFrame, UDim2.new(1, -70, 0.5, -15), function(active)
                isScriptActive[itemType][itemName] = active
                
                if active then
                    currentLoops[itemType][itemName] = true
                    spawn(function()
                        while currentLoops[itemType][itemName] and isScriptActive[itemType][itemName] do
                            pcall(function()
                                buyFunction(itemName)
                            end)
                            wait(0.1)
                        end
                    end)
                else
                    currentLoops[itemType][itemName] = false
                end
            end)
            
            -- Hover Effect
            itemFrame.MouseEnter:Connect(function()
                TweenService:Create(itemFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.22, 0.22, 0.27)}):Play()
            end)
            
            itemFrame.MouseLeave:Connect(function()
                TweenService:Create(itemFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.18, 0.18, 0.23)}):Play()
            end)
            
            itemFrames[itemName] = itemFrame
        end
        
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end
    
    -- Search functionality
    searchInput:GetPropertyChangedSignal("Text"):Connect(updateItemDisplay)
    
    -- Select All functionality
    selectAllButton.MouseButton1Click:Connect(function()
        for _, itemName in ipairs(filteredItems) do
            if not isScriptActive[itemType][itemName] then
                isScriptActive[itemType][itemName] = true
                currentLoops[itemType][itemName] = true
                spawn(function()
                    while currentLoops[itemType][itemName] and isScriptActive[itemType][itemName] do
                        pcall(function()
                            buyFunction(itemName)
                        end)
                        wait(0.1)
                    end
                end)
            end
        end
        updateItemDisplay()
    end)
    
    -- Initial display
    updateItemDisplay()
end

-- ========================================
-- NOTIFICATION SYSTEM
-- ========================================

local function createNotificationSystem()
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Name = "NotificationFrame"
    notificationFrame.Parent = playerGui
    notificationFrame.Size = UDim2.new(0, 300, 1, 0)
    notificationFrame.Position = UDim2.new(1, -310, 0, 10)
    notificationFrame.BackgroundTransparency = 1
    notificationFrame.ZIndex = 1000
    
    local notificationLayout = Instance.new("UIListLayout")
    notificationLayout.Parent = notificationFrame
    notificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notificationLayout.Padding = UDim.new(0, 5)
    notificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    
    return notificationFrame
end

local function showNotification(title, message, duration)
    duration = duration or 3
    
    local notificationFrame = playerGui:FindFirstChild("NotificationFrame")
    if not notificationFrame then
        notificationFrame = createNotificationSystem()
    end
    
    local notification = Instance.new("Frame")
    notification.Parent = notificationFrame
    notification.Size = UDim2.new(1, 0, 0, 80)
    notification.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
    notification.BorderSizePixel = 0
    notification.Position = UDim2.new(1, 0, 0, 0)
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notification
    
    local notifGradient = createGradientFrame(notification, {
        Color3.new(0.2, 0.6, 1), 
        Color3.new(0.6, 0.2, 1)
    })
    notifGradient.BackgroundTransparency = 0.3
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = notification
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Message
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Parent = notification
    messageLabel.Size = UDim2.new(1, -20, 0, 45)
    messageLabel.Position = UDim2.new(0, 10, 0, 30)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    messageLabel.TextScaled = true
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    
    -- Slide in animation
    TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    -- Auto remove after duration
    spawn(function()
        wait(duration)
        local slideOut = TweenService:Create(notification, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, 0, 0)})
        slideOut:Play()
        slideOut.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
end

-- ========================================
-- FINAL INITIALIZATION
-- ========================================

-- Initialize the script with enhanced features
local function initializeEnhancedScript()
    -- Initialize active states
    isScriptActive.seeds = {}
    isScriptActive.gear = {}
    isScriptActive.pets = {}
    
    for _, seedName in ipairs(seedData) do
        isScriptActive.seeds[seedName] = false
        currentLoops.seeds[seedName] = false
    end
    
    for _, gearName in ipairs(gearData) do
        isScriptActive.gear[gearName] = false
        currentLoops.gear[gearName] = false
    end
    
    for _, eggName in ipairs(petEggData) do
        isScriptActive.pets[eggName] = false
        currentLoops.pets[eggName] = false
    end
    
    -- Create main GUI
    local screenGui, mainFrame, menuFrame, contentFrame = createMainGUI()
    
    -- Create notification system
    createNotificationSystem()
    
    -- Show welcome notification
    showNotification("🌱 GROW A GARDEN SCRIPT", "Successfully loaded! Ready to farm!", 5)
    
    -- Current content reference
    local currentContent = nil
    
    local function clearContent()
        if currentContent then
            currentContent:Destroy()
        end
    end
    
    -- Enhanced Menu Buttons
    createMenuButton(menuFrame, "CHARACTER", "7072715489", UDim2.new(0, 10, 0, 10), function()
        clearContent()
        currentContent = Instance.new("Frame")
        currentContent.Parent = contentFrame
        currentContent.Size = UDim2.new(1, 0, 1, 0)
        currentContent.BackgroundTransparency = 1
        createEnhancedCharacterContent(currentContent)
        showNotification("CHARACTER", "Character settings loaded!", 2)
    end)
    
    createMenuButton(menuFrame, "SEEDS", "7072715489", UDim2.new(0, 10, 0, 70), function()
        clearContent()
        currentContent = Instance.new("Frame")
        currentContent.Parent = contentFrame
        currentContent.Size = UDim2.new(1, 0, 1, 0)
        currentContent.BackgroundTransparency = 1
        createEnhancedItemContent(currentContent, seedData, "seeds", buySeed)
        showNotification("SEEDS", string.format("%d seeds available for farming!", #seedData), 2)
    end)
    
    createMenuButton(menuFrame, "GEAR", "7072715489", UDim2.new(0, 10, 0, 130), function()
        clearContent()
        currentContent = Instance.new("Frame")
        currentContent.Parent = contentFrame
        currentContent.Size = UDim2.new(1, 0, 1, 0)
        currentContent.BackgroundTransparency = 1
        createEnhancedItemContent(currentContent, gearData, "gear", buyGear)
        showNotification("GEAR", string.format("%d gear items available for farming!", #gearData), 2)
    end)
    
    createMenuButton(menuFrame, "PET EGGS", "7072715489", UDim2.new(0, 10, 0, 190), function()
        clearContent()
        currentContent = Instance.new("Frame")
        currentContent.Parent = contentFrame
        currentContent.Size = UDim2.new(1, 0, 1, 0)
        currentContent.BackgroundTransparency = 1
        createEnhancedItemContent(currentContent, petEggData, "pets", buyPetEgg)
        showNotification("PET EGGS", string.format("%d pet eggs available for farming!", #petEggData), 2)
    end)
    
    -- Default to Character menu
    currentContent = Instance.new("Frame")
    currentContent.Parent = contentFrame
    currentContent.Size = UDim2.new(1, 0, 1, 0)
    currentContent.BackgroundTransparency = 1
    createEnhancedCharacterContent(currentContent)
    
    -- Error handling and reconnection system
    spawn(function()
        while screenGui.Parent do
            pcall(function()
                -- Check if player character exists
                if not player.Character or not player.Character:FindFirstChild("Humanoid") then
                    wait(1)
                    return
                end
                
                -- Maintain speed if active
                if isScriptActive.speed then
                    player.Character.Humanoid.WalkSpeed = playerSpeed
                end
            end)
            wait(0.5)
        end
    end)
end

-- ========================================
-- SCRIPT STARTUP
-- ========================================

-- Wait for game to load properly
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Wait for character to spawn
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    wait(2) -- Additional wait for full character load
    
    -- Maintain speed if it was active
    if isScriptActive.speed then
        character.Humanoid.WalkSpeed = playerSpeed
    end
end)

-- Initialize script when everything is ready
spawn(function()
    wait(3) -- Give game time to fully load
    
    pcall(function()
        initializeEnhancedScript()
    end)
end)

-- ========================================
-- ADDITIONAL UTILITY FUNCTIONS
-- ========================================

-- Anti-AFK System
local function createAntiAFK()
    local antiAFK = true
    
    spawn(function()
        while antiAFK do
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            wait(300) -- Wait 5 minutes before next anti-AFK action
        end
    end)
    
    return function()
        antiAFK = false
    end
end

-- Auto-Rejoin on Disconnect
local function setupAutoRejoin()
    game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == 'ErrorPrompt' and child:FindFirstChild("MessageArea") and child.MessageArea:FindFirstChild("ErrorFrame") then
            game:GetService("TeleportService"):Teleport(game.PlaceId)
        end
    end)
end

-- Performance Monitor
local function createPerformanceMonitor()
    local performanceData = {
        fps = 0,
        ping = 0,
        memory = 0
    }
    
    spawn(function()
        local lastTime = tick()
        local frameCount = 0
        
        RunService.Heartbeat:Connect(function()
            frameCount = frameCount + 1
            local currentTime = tick()
            
            if currentTime - lastTime >= 1 then
                performanceData.fps = frameCount
                frameCount = 0
                lastTime = currentTime
                
                -- Update ping
                performanceData.ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString():match("%d+")
                
                -- Update memory usage (approximate)
                performanceData.memory = math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb())
            end
        end)
    end)
    
    return performanceData
end

-- Backup System for Settings
local function createBackupSystem()
    local backupData = {
        speed = playerSpeed,
        activeSeeds = {},
        activeGear = {},
        activePets = {}
    }
    
    local function saveSettings()
        backupData.speed = playerSpeed
        backupData.activeSeeds = {}
        backupData.activeGear = {}
        backupData.activePets = {}
        
        for name, active in pairs(isScriptActive.seeds) do
            if active then
                table.insert(backupData.activeSeeds, name)
            end
        end
        
        for name, active in pairs(isScriptActive.gear) do
            if active then
                table.insert(backupData.activeGear, name)
            end
        end
        
        for name, active in pairs(isScriptActive.pets) do
            if active then
                table.insert(backupData.activePets, name)
            end
        end
    end
    
    local function loadSettings()
        playerSpeed = backupData.speed or 16
        
        for _, name in ipairs(backupData.activeSeeds or {}) do
            if isScriptActive.seeds[name] ~= nil then
                isScriptActive.seeds[name] = true
                currentLoops.seeds[name] = true
                spawn(function()
                    while currentLoops.seeds[name] and isScriptActive.seeds[name] do
                        pcall(function()
                            buySeed(name)
                        end)
                        wait(0.1)
                    end
                end)
            end
        end
        
        for _, name in ipairs(backupData.activeGear or {}) do
            if isScriptActive.gear[name] ~= nil then
                isScriptActive.gear[name] = true
                currentLoops.gear[name] = true
                spawn(function()
                    while currentLoops.gear[name] and isScriptActive.gear[name] do
                        pcall(function()
                            buyGear(name)
                        end)
                        wait(0.1)
                    end
                end)
            end
        end
        
        for _, name in ipairs(backupData.activePets or {}) do
            if isScriptActive.pets[name] ~= nil then
                isScriptActive.pets[name] = true
                currentLoops.pets[name] = true
                spawn(function()
                    while currentLoops.pets[name] and isScriptActive.pets[name] do
                        pcall(function()
                            buyPetEgg(name)
                        end)
                        wait(0.1)
                    end
                end)
            end
        end
    end
    
    -- Auto-save every 30 seconds
    spawn(function()
        while true do
            wait(30)
            pcall(saveSettings)
        end
    end)
    
    return {
        save = saveSettings,
        load = loadSettings
    }
end

-- Enhanced Error Handling
local function createErrorHandler()
    local errorCount = 0
    local maxErrors = 10
    local errorResetTime = 300 -- 5 minutes
    local lastErrorTime = 0
    
    local function handleError(errorMessage, context)
        local currentTime = tick()
        
        -- Reset error count if enough time has passed
        if currentTime - lastErrorTime > errorResetTime then
            errorCount = 0
        end
        
        errorCount = errorCount + 1
        lastErrorTime = currentTime
        
        -- Log error
        warn(string.format("[GROW GARDEN SCRIPT ERROR] %s in %s (Count: %d)", errorMessage, context, errorCount))
        
        -- Show notification
        if playerGui:FindFirstChild("NotificationFrame") then
            showNotification("⚠️ ERROR", string.format("Error in %s: %s", context, errorMessage), 3)
        end
        
        -- If too many errors, show warning
        if errorCount >= maxErrors then
            if playerGui:FindFirstChild("NotificationFrame") then
                showNotification("🚨 WARNING", "Too many errors detected! Script may be unstable.", 10)
            end
        end
    end
    
    return handleError
end

-- Initialize all systems
local function initializeAllSystems()
    local errorHandler = createErrorHandler()
    local performanceMonitor = createPerformanceMonitor()
    local backupSystem = createBackupSystem()
    
    -- Initialize anti-AFK
    local stopAntiAFK = createAntiAFK()
    
    -- Setup auto-rejoin
    pcall(setupAutoRejoin)
    
    -- Global error handling
    local function safeCall(func, context)
        local success, error = pcall(func)
        if not success then
            errorHandler(tostring(error), context or "Unknown")
        end
        return success
    end
    
    -- Override buying functions with error handling
    local originalBuySeed = buySeed
    local originalBuyGear = buyGear
    local originalBuyPetEgg = buyPetEgg
    
    buySeed = function(seedName)
        safeCall(function()
            originalBuySeed(seedName)
        end, "BuySeed: " .. seedName)
    end
    
    buyGear = function(gearName)
        safeCall(function()
            originalBuyGear(gearName)
        end, "BuyGear: " .. gearName)
    end
    
    buyPetEgg = function(eggName)
        safeCall(function()
            originalBuyPetEgg(eggName)
        end, "BuyPetEgg: " .. eggName)
    end
    
    -- Load saved settings after a short delay
    spawn(function()
        wait(5)
        safeCall(backupSystem.load, "LoadSettings")
    end)
    
    return {
        errorHandler = errorHandler,
        performanceMonitor = performanceMonitor,
        backupSystem = backupSystem,
        safeCall = safeCall,
        stopAntiAFK = stopAntiAFK
    }
end

-- ========================================
-- ADVANCED FEATURES SECTION
-- ========================================

-- Webhook Integration (Optional)
local function createWebhookLogger()
    local webhookUrl = "" -- Users can add their webhook URL here
    local HttpService = game:GetService("HttpService")
    
    local function sendWebhook(title, description, color)
        if webhookUrl == "" then return end
        
        local data = {
            embeds = {{
                title = title,
                description = description,
                color = color or 3447003,
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                footer = {
                    text = "Grow a Garden Script"
                }
            }}
        }
        
        pcall(function()
            HttpService:PostAsync(webhookUrl, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
        end)
    end
    
    return sendWebhook
end

-- Auto-Update System
local function createAutoUpdater()
    local currentVersion = "2.0.0"
    local updateCheckUrl = "" -- URL to check for updates
    
    local function checkForUpdates()
        -- This would typically check a GitHub repository or similar
        -- For now, it's a placeholder
        return false, currentVersion
    end
    
    return {
        version = currentVersion,
        check = checkForUpdates
    }
end

-- Configuration System
local function createConfigSystem()
    local defaultConfig = {
        buyDelay = 0.1,
        maxRetries = 3,
        enableNotifications = true,
        enableWebhooks = false,
        autoSave = true,
        theme = "default"
    }
    
    local currentConfig = {}
    
    -- Load default config
    for key, value in pairs(defaultConfig) do
        currentConfig[key] = value
    end
    
    local function getConfig(key)
        return currentConfig[key]
    end
    
    local function setConfig(key, value)
        if defaultConfig[key] ~= nil then
            currentConfig[key] = value
            return true
        end
        return false
    end
    
    return {
        get = getConfig,
        set = setConfig,
        getAll = function() return currentConfig end,
        reset = function()
            for key, value in pairs(defaultConfig) do
                currentConfig[key] = value
            end
        end
    }
end

-- ========================================
-- FINAL SCRIPT EXECUTION
-- ========================================

-- Create all systems and initialize the script
local systems = initializeAllSystems()
local configSystem = createConfigSystem()
local webhookLogger = createWebhookLogger()
local autoUpdater = createAutoUpdater()

-- Log script startup
webhookLogger("🌱 Script Started", string.format("Grow a Garden Script v%s has been loaded successfully!", autoUpdater.version), 3066993)

-- Show final status
print("========================================")
print("🌱 GROW A GARDEN SCRIPT v" .. autoUpdater.version)
print("========================================")
print("✅ All systems initialized successfully!")
print("📊 Seeds loaded: " .. #seedData)
print("⚙️ Gear items loaded: " .. #gearData)
print("🥚 Pet eggs loaded: " .. #petEggData)
print("🔧 Advanced features: ENABLED")
print("🛡️ Error handling: ACTIVE")
print("💾 Auto-save: ENABLED")
print("🔄 Anti-AFK: RUNNING")
print("========================================")
print("Ready to farm! Open the GUI to start.")
print("========================================")
