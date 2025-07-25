-- ========================================
-- GROW A GARDEN SCRIPT - FIXED VERSION
-- ========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for game to fully load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

wait(2) -- Additional safety wait

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

local playerSpeed = 50

-- ========================================
-- SEED DATA
-- ========================================

local seedData = {
    "Carrot", "Lettuce", "Potato", "Tomato", "Onion", "Cabbage", "Corn", "Wheat",
    "Radish", "Beetroot", "Spinach", "Broccoli", "Cauliflower", "Cucumber", "Pumpkin",
    "Watermelon", "Strawberry", "Blueberry", "Raspberry", "Blackberry", "Cherry",
    "Apple", "Orange", "Banana", "Grape", "Lemon", "Lime", "Peach", "Pear", "Plum",
    "Apricot", "Mango", "Pineapple", "Papaya", "Coconut", "Avocado", "Kiwi",
    "Bamboo", "Rice", "Sugarcane", "Cotton", "Sunflower", "Lavender", "Rose",
    "Tulip", "Daisy", "Lily", "Orchid", "Jasmine", "Hibiscus", "Marigold",
    "Dragon Pepper", "Moon Mango", "Maple Apple", "Spiked Mango", "Fossilight Fruit",
    "Bone Blossom", "Candy Blossom", "Crystal Berry", "Golden Wheat", "Silver Corn",
    "Diamond Carrot", "Ruby Tomato", "Emerald Lettuce", "Sapphire Grape"
}

-- ========================================
-- GEAR DATA
-- ========================================

local gearData = {
    "Watering Can", "Advanced Watering Can", "Premium Watering Can", "Golden Watering Can",
    "Diamond Watering Can", "Crystal Watering Can", "Master Watering Can", "Godly Watering Can",
    "Basic Sprinkler", "Advanced Sprinkler", "Premium Sprinkler", "Golden Sprinkler",
    "Diamond Sprinkler", "Crystal Sprinkler", "Master Sprinkler", "Godly Sprinkler",
    "Basic Fertilizer", "Advanced Fertilizer", "Premium Fertilizer", "Golden Fertilizer",
    "Diamond Fertilizer", "Crystal Fertilizer", "Master Fertilizer", "Godly Fertilizer",
    "Shovel", "Advanced Shovel", "Premium Shovel", "Golden Shovel", "Diamond Shovel",
    "Crystal Shovel", "Master Shovel", "Godly Shovel", "Hoe", "Advanced Hoe",
    "Premium Hoe", "Golden Hoe", "Diamond Hoe", "Crystal Hoe", "Master Hoe", "Godly Hoe"
}

-- ========================================
-- PET EGG DATA
-- ========================================

local petEggData = {
    "Common Egg", "Basic Egg", "Starter Egg", "Simple Egg", "Regular Egg",
    "Uncommon Egg", "Enhanced Egg", "Improved Egg", "Better Egg", "Superior Egg",
    "Rare Egg", "Rare Summer Egg", "Rare Winter Egg", "Rare Spring Egg", "Rare Autumn Egg",
    "Epic Egg", "Epic Fire Egg", "Epic Water Egg", "Epic Earth Egg", "Epic Air Egg",
    "Legendary Egg", "Legendary Dragon Egg", "Legendary Phoenix Egg", "Legendary Unicorn Egg",
    "Mythical Egg", "Mythical Celestial Egg", "Mythical Cosmic Egg", "Mythical Divine Egg",
    "Halloween Egg", "Christmas Egg", "Easter Egg", "Valentine Egg", "New Year Egg",
    "Golden Egg", "Silver Egg", "Diamond Egg", "Platinum Egg", "Crystal Egg"
}

-- ========================================
-- BUYING FUNCTIONS
-- ========================================

local function buySeed(seedName)
    pcall(function()
        local args = {[1] = seedName}
        ReplicatedStorage.GameEvents.BuySeedStock:FireServer(unpack(args))
    end)
end

local function buyGear(gearName)
    pcall(function()
        local args = {[1] = gearName}
        ReplicatedStorage.GameEvents.BuyGearStock:FireServer(unpack(args))
    end)
end

local function buyPetEgg(eggName)
    pcall(function()
        local args = {[1] = eggName}
        ReplicatedStorage.GameEvents.BuyPetEgg:FireServer(unpack(args))
    end)
end

-- ========================================
-- SIMPLE GUI CREATION
-- ========================================

local function createMainGUI()
    -- Remove any existing GUI
    if playerGui:FindFirstChild("GrowGardenScript") then
        playerGui:FindFirstChild("GrowGardenScript"):Destroy()
    end
    
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
    mainFrame.Size = UDim2.new(0, 800, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 100)
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Parent = mainFrame
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    titleBar.BorderSizePixel = 0
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Parent = titleBar
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "🌱 GROW A GARDEN SCRIPT 🌱"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 18
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = titleBar
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -45, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 16
    closeButton.Font = Enum.Font.GothamBold
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Menu Frame (Left Side)
    local menuFrame = Instance.new("Frame")
    menuFrame.Name = "MenuFrame"
    menuFrame.Parent = mainFrame
    menuFrame.Size = UDim2.new(0, 200, 1, -60)
    menuFrame.Position = UDim2.new(0, 10, 0, 55)
    menuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    menuFrame.BorderSizePixel = 1
    menuFrame.BorderColor3 = Color3.fromRGB(0, 255, 100)
    
    -- Content Frame (Right Side)
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Parent = mainFrame
    contentFrame.Size = UDim2.new(0, 570, 1, -60)
    contentFrame.Position = UDim2.new(0, 220, 0, 55)
    contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    contentFrame.BorderSizePixel = 1
    contentFrame.BorderColor3 = Color3.fromRGB(0, 255, 100)
    
    return screenGui, mainFrame, menuFrame, contentFrame
end

-- ========================================
-- MENU BUTTON CREATION
-- ========================================

local function createMenuButton(parent, text, position, onClick)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Size = UDim2.new(1, -10, 0, 40)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(0, 200, 80)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    end)
    
    button.MouseButton1Click:Connect(onClick)
    
    return button
end

-- ========================================
-- TOGGLE BUTTON CREATION
-- ========================================

local function createToggleButton(parent, position, itemName, itemType, buyFunction)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Size = UDim2.new(0, 60, 0, 25)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = "OFF"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.GothamBold
    
    local isActive = false
    
    button.MouseButton1Click:Connect(function()
        isActive = not isActive
        isScriptActive[itemType][itemName] = isActive
        
        if isActive then
            button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            button.Text = "ON"
            
            -- Start buying loop
            currentLoops[itemType][itemName] = true
            spawn(function()
                while currentLoops[itemType][itemName] and isScriptActive[itemType][itemName] do
                    buyFunction(itemName)
                    wait(0.1)
                end
            end)
        else
            button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            button.Text = "OFF"
            currentLoops[itemType][itemName] = false
        end
    end)
    
    return button
end

-- ========================================
-- CONTENT CREATION FUNCTIONS
-- ========================================

local function createCharacterContent(contentFrame)
    -- Clear existing content
    for _, child in pairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
    
    -- Speed Section
    local speedFrame = Instance.new("Frame")
    speedFrame.Parent = contentFrame
    speedFrame.Size = UDim2.new(1, -20, 0, 80)
    speedFrame.Position = UDim2.new(0, 10, 0, 10)
    speedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    speedFrame.BorderSizePixel = 1
    speedFrame.BorderColor3 = Color3.fromRGB(0, 200, 80)
    
    -- Speed Title
    local speedTitle = Instance.new("TextLabel")
    speedTitle.Parent = speedFrame
    speedTitle.Size = UDim2.new(1, 0, 0, 25)
    speedTitle.Position = UDim2.new(0, 0, 0, 5)
    speedTitle.BackgroundTransparency = 1
    speedTitle.Text = "🏃 PLAYER SPEED CONTROL"
    speedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedTitle.TextSize = 16
    speedTitle.Font = Enum.Font.GothamBold
    
    -- Speed Input
    local speedInput = Instance.new("TextBox")
    speedInput.Parent = speedFrame
    speedInput.Size = UDim2.new(0, 150, 0, 25)
    speedInput.Position = UDim2.new(0, 10, 0, 35)
    speedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    speedInput.BorderSizePixel = 1
    speedInput.BorderColor3 = Color3.fromRGB(255, 255, 255)
    speedInput.Text = tostring(playerSpeed)
    speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedInput.TextSize = 14
    speedInput.Font = Enum.Font.Gotham
    
    speedInput.FocusLost:Connect(function()
        local newSpeed = tonumber(speedInput.Text)
        if newSpeed and newSpeed > 0 then
            playerSpeed = newSpeed
        else
            speedInput.Text = tostring(playerSpeed)
        end
    end)
    
    -- Speed Toggle
    local speedToggle = Instance.new("TextButton")
    speedToggle.Parent = speedFrame
    speedToggle.Size = UDim2.new(0, 80, 0, 25)
    speedToggle.Position = UDim2.new(0, 170, 0, 35)
    speedToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    speedToggle.BorderSizePixel = 1
    speedToggle.BorderColor3 = Color3.fromRGB(255, 255, 255)
    speedToggle.Text = "DISABLED"
    speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedToggle.TextSize = 12
    speedToggle.Font = Enum.Font.GothamBold
    
    speedToggle.MouseButton1Click:Connect(function()
        isScriptActive.speed = not isScriptActive.speed
        
        if isScriptActive.speed then
            speedToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            speedToggle.Text = "ENABLED"
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = playerSpeed
            end
        else
            speedToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            speedToggle.Text = "DISABLED"
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 16
            end
        end
    end)
    
    -- Status Display
    local statusFrame = Instance.new("Frame")
    statusFrame.Parent = contentFrame
    statusFrame.Size = UDim2.new(1, -20, 0, 100)
    statusFrame.Position = UDim2.new(0, 10, 0, 100)
    statusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    statusFrame.BorderSizePixel = 1
    statusFrame.BorderColor3 = Color3.fromRGB(0, 200, 80)
    
    local statusTitle = Instance.new("TextLabel")
    statusTitle.Parent = statusFrame
    statusTitle.Size = UDim2.new(1, 0, 0, 25)
    statusTitle.Position = UDim2.new(0, 0, 0, 5)
    statusTitle.BackgroundTransparency = 1
    statusTitle.Text = "📊 FARMING STATUS"
    statusTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusTitle.TextSize = 16
    statusTitle.Font = Enum.Font.GothamBold
    
    local statusText = Instance.new("TextLabel")
    statusText.Parent = statusFrame
    statusText.Size = UDim2.new(1, -20, 1, -35)
    statusText.Position = UDim2.new(0, 10, 0, 30)
    statusText.BackgroundTransparency = 1
    statusText.Text = "🌱 Active Seeds: 0\n⚙️ Active Gear: 0\n🥚 Active Pets: 0"
    statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusText.TextSize = 14
    statusText.Font = Enum.Font.Gotham
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.TextYAlignment = Enum.TextYAlignment.Top
    
    -- Update status continuously
    spawn(function()
        while statusText.Parent do
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
            
            statusText.Text = string.format(
                "🌱 Active Seeds: %d/%d\n⚙️ Active Gear: %d/%d\n🥚 Active Pets: %d/%d",
                activeSeeds, #seedData,
                activeGear, #gearData,
                activePets, #petEggData
            )
            
            wait(1)
        end
    end)
end

local function createItemContent(contentFrame, itemData, itemType, buyFunction, title)
    -- Clear existing content
    for _, child in pairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = contentFrame
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 0, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    
    -- Scroll Frame
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Parent = contentFrame
    scrollFrame.Size = UDim2.new(1, -20, 1, -50)
    scrollFrame.Position = UDim2.new(0, 10, 0, 40)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    scrollFrame.BorderSizePixel = 1
    scrollFrame.BorderColor3 = Color3.fromRGB(0, 200, 80)
    scrollFrame.ScrollBarThickness = 10
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = scrollFrame
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)
    
    -- Create items
    for i, itemName in ipairs(itemData) do
        local itemFrame = Instance.new("Frame")
        itemFrame.Parent = scrollFrame
        itemFrame.Size = UDim2.new(1, -20, 0, 35)
        itemFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        itemFrame.BorderSizePixel = 1
        itemFrame.BorderColor3 = Color3.fromRGB(100, 100, 110)
        itemFrame.LayoutOrder = i
        
        -- Item Name
        local itemLabel = Instance.new("TextLabel")
        itemLabel.Parent = itemFrame
        itemLabel.Size = UDim2.new(1, -80, 1, 0)
        itemLabel.Position = UDim2.new(0, 10, 0, 0)
        itemLabel.BackgroundTransparency = 1
        itemLabel.Text = itemName
        itemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        itemLabel.TextSize = 12
        itemLabel.Font = Enum.Font.Gotham
        itemLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Toggle Button
        createToggleButton(itemFrame, UDim2.new(1, -70, 0.5, -12), itemName, itemType, buyFunction)
    end
    
    -- Update scroll canvas size
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
end

-- ========================================
-- MAIN INITIALIZATION
-- ========================================

local function initializeScript()
    -- Initialize active states
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
    
    -- Create GUI
    local screenGui, mainFrame, menuFrame, contentFrame = createMainGUI()
    
    -- Current content reference
    local currentContent = contentFrame
    
    -- Menu Buttons
    createMenuButton(menuFrame, "🏃 CHARACTER", UDim2.new(0, 5, 0, 10), function()
        createCharacterContent(currentContent)
    end)
    
    createMenuButton(menuFrame, "🌱 SEEDS", UDim2.new(0, 5, 0, 60), function()
        createItemContent(currentContent, seedData, "seeds", buySeed, "🌱 SEEDS - AUTO BUYER")
    end)
    
    createMenuButton(menuFrame, "⚙️ GEAR", UDim2.new(0, 5, 0, 110), function()
        createItemContent(currentContent, gearData, "gear", buyGear, "⚙️ GEAR - AUTO BUYER")
    end)
    
    createMenuButton(menuFrame, "🥚 PET EGGS", UDim2.new(0, 5, 0, 160), function()
        createItemContent(currentContent, petEggData, "pets", buyPetEgg, "🥚 PET EGGS - AUTO BUYER")
    end)
    
    -- Default to Character menu
    createCharacterContent(currentContent)
    
    -- Maintain speed when character respawns
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid")
        wait(1)
        if isScriptActive.speed then
            character.Humanoid.WalkSpeed = playerSpeed
        end
    end)
    
    print("🌱 GROW A GARDEN SCRIPT LOADED!")
    print("✅ GUI Created Successfully!")
    print("📊 Seeds: " .. #seedData)
    print("⚙️ Gear: " .. #gearData) 
    print("🥚 Pets: " .. #petEggData)
end

-- ========================================
-- START SCRIPT
-- ========================================

-- Initialize the script
initializeScript()
