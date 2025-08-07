-- ╔══════════════════════════════════════════════════════════════╗
-- ║          NATHUB CHARACTER CONTROLLER - ULTIMATE EDITION      ║
-- ║        Advanced Professional Roblox UI System v4.0          ║
-- ║      Maximum Intelligence & Performance Implementation       ║
-- ╚══════════════════════════════════════════════════════════════╝

-- ═══════════════════════════════════════════════════════════════
-- SERVICE IMPORTS & PERFORMANCE OPTIMIZATION
-- ═══════════════════════════════════════════════════════════════

local Services = {
    Players = game:GetService("Players"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    RunService = game:GetService("RunService"),
    GuiService = game:GetService("GuiService"),
    SoundService = game:GetService("SoundService"),
    HttpService = game:GetService("HttpService"),
    StarterGui = game:GetService("StarterGui"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    Lighting = game:GetService("Lighting"),
    Workspace = game:GetService("Workspace"),
    TextService = game:GetService("TextService"),
    TeleportService = game:GetService("TeleportService")
}

-- ═══════════════════════════════════════════════════════════════
-- ADVANCED CONFIGURATION SYSTEM WITH THEME MANAGEMENT
-- ═══════════════════════════════════════════════════════════════

local CONFIG = {
    META = {
        VERSION = "4.0.0",
        BUILD = "ULTIMATE",
        AUTHOR = "AI Assistant",
        BUILD_DATE = os.date("%Y-%m-%d"),
        API_VERSION = 4
    },
    
    UI = {
        MAIN_SIZE = Vector2.new(850, 550),
        SIDEBAR_WIDTH = 220,
        HEADER_HEIGHT = 70,
        CORNER_RADIUS = 16,
        ANIMATION_SPEED = 0.6,
        TOGGLE_SIZE = 65,
        SHADOW_INTENSITY = 0.4,
        BLUR_INTENSITY = 5,
        MIN_SIZE = Vector2.new(600, 400),
        MAX_SIZE = Vector2.new(1200, 800)
    },
    
    THEMES = {
        DARK = {
            NAME = "NatHub Dark",
            BACKGROUND = Color3.fromRGB(30, 32, 36),
            SIDEBAR = Color3.fromRGB(42, 45, 50),
            SURFACE = Color3.fromRGB(54, 57, 63),
            ACCENT = Color3.fromRGB(114, 137, 218),
            ACCENT_HOVER = Color3.fromRGB(129, 151, 230),
            SUCCESS = Color3.fromRGB(67, 181, 129),
            WARNING = Color3.fromRGB(250, 166, 26),
            DANGER = Color3.fromRGB(240, 71, 71),
            INFO = Color3.fromRGB(52, 152, 219),
            TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),
            TEXT_SECONDARY = Color3.fromRGB(185, 187, 190),
            TEXT_MUTED = Color3.fromRGB(114, 118, 125),
            BORDER = Color3.fromRGB(64, 68, 75),
            HOVER = Color3.fromRGB(54, 57, 63),
            SELECTED = Color3.fromRGB(64, 68, 75)
        },
        
        LIGHT = {
            NAME = "NatHub Light",
            BACKGROUND = Color3.fromRGB(248, 249, 250),
            SIDEBAR = Color3.fromRGB(255, 255, 255),
            SURFACE = Color3.fromRGB(245, 246, 247),
            ACCENT = Color3.fromRGB(88, 101, 242),
            ACCENT_HOVER = Color3.fromRGB(104, 116, 255),
            SUCCESS = Color3.fromRGB(40, 167, 69),
            WARNING = Color3.fromRGB(255, 193, 7),
            DANGER = Color3.fromRGB(220, 53, 69),
            INFO = Color3.fromRGB(23, 162, 184),
            TEXT_PRIMARY = Color3.fromRGB(33, 37, 41),
            TEXT_SECONDARY = Color3.fromRGB(108, 117, 125),
            TEXT_MUTED = Color3.fromRGB(134, 142, 150),
            BORDER = Color3.fromRGB(222, 226, 230),
            HOVER = Color3.fromRGB(248, 249, 250),
            SELECTED = Color3.fromRGB(233, 236, 239)
        }
    },
    
    PHYSICS = {
        SPEED = { MIN = 0, MAX = 200, DEFAULT = 16, STEP = 0.5 },
        JUMP_POWER = { MIN = 0, MAX = 500, DEFAULT = 50, STEP = 1 },
        JUMP_HEIGHT = { MIN = 0, MAX = 100, DEFAULT = 7.2, STEP = 0.1 },
        HIP_HEIGHT = { MIN = -10, MAX = 20, DEFAULT = 0, STEP = 0.1 },
        GRAVITY = { MIN = 0, MAX = 500, DEFAULT = 196.2, STEP = 1 }
    },
    
    AUDIO = {
        ENABLED = true,
        MASTER_VOLUME = 0.5,
        SOUNDS = {
            CLICK = { ID = "rbxasset://sounds/electronicpingshort.wav", VOLUME = 0.3 },
            HOVER = { ID = "rbxasset://sounds/switch.wav", VOLUME = 0.2 },
            SLIDE = { ID = "rbxasset://sounds/impact_generic.mp3", VOLUME = 0.25 },
            OPEN = { ID = "rbxasset://sounds/bamf.mp3", VOLUME = 0.4 },
            CLOSE = { ID = "rbxasset://sounds/whoosh.wav", VOLUME = 0.35 },
            SUCCESS = { ID = "rbxasset://sounds/victory.wav", VOLUME = 0.45 },
            ERROR = { ID = "rbxasset://sounds/impact_generic.mp3", VOLUME = 0.3 },
            NOTIFICATION = { ID = "rbxasset://sounds/notification.wav", VOLUME = 0.25 }
        }
    },
    
    ICONS = {
        SPEED = "⚡", JUMP = "🚀", SETTINGS = "⚙️", INFO = "📊",
        CLOSE = "✕", MENU = "☰", HOME = "🏠", TOOLS = "🔧",
        USER = "👤", STATS = "📈", THEME = "🎨", AUDIO = "🔊",
        SAVE = "💾", RESET = "🔄", EXPORT = "📤", IMPORT = "📥",
        MINIMIZE = "−", MAXIMIZE = "□", LOCK = "🔒", UNLOCK = "🔓"
    },
    
    PERFORMANCE = {
        FPS_TARGET = 60,
        UPDATE_INTERVAL = 1/60,
        STATS_INTERVAL = 1,
        AUTOSAVE_INTERVAL = 30,
        MAX_HISTORY_SIZE = 100,
        MEMORY_THRESHOLD = 100 * 1024 * 1024 -- 100MB
    },
    
    SECURITY = {
        ENCRYPTION_KEY = "NatHub_SecureKey_2024",
        ALLOWED_DOMAINS = {"roblox.com", "rbxasset"},
        MAX_INPUT_LENGTH = 1000,
        RATE_LIMIT_WINDOW = 60,
        MAX_ACTIONS_PER_MINUTE = 120
    }
}

-- ═══════════════════════════════════════════════════════════════
-- ADVANCED UTILITY FRAMEWORK WITH ERROR HANDLING
-- ═══════════════════════════════════════════════════════════════

local Utils = {
    Cache = {},
    Performance = {},
    Security = {},
    Animation = {},
    Math = {}
}

-- Security & Validation Utils
function Utils.Security.sanitizeInput(input, maxLength)
    if type(input) ~= "string" then return "" end
    input = string.sub(input, 1, maxLength or CONFIG.SECURITY.MAX_INPUT_LENGTH)
    return string.gsub(input, "[<>\""]", "")
end

function Utils.Security.validateNumber(value, min, max, default)
    local num = tonumber(value)
    if not num or num ~= num then return default end -- NaN check
    return math.clamp(num, min or -math.huge, max or math.huge)
end

function Utils.Security.rateLimit(key, limit, window)
    local now = tick()
    if not Utils.Cache[key] then Utils.Cache[key] = {} end
    
    local actions = Utils.Cache[key]
    -- Clean old actions
    for i = #actions, 1, -1 do
        if now - actions[i] > window then
            table.remove(actions, i)
        end
    end
    
    if #actions >= limit then return false end
    table.insert(actions, now)
    return true
end

-- Performance Utils
function Utils.Performance.createOptimizedTween(instance, info, properties, callback)
    if not instance or not instance.Parent then return nil end
    
    local tween = Services.TweenService:Create(instance, info, properties)
    if callback then
        tween.Completed:Once(callback)
    end
    
    -- Add to cleanup queue
    if not Utils.Cache.ActiveTweens then Utils.Cache.ActiveTweens = {} end
    table.insert(Utils.Cache.ActiveTweens, tween)
    
    tween.Completed:Connect(function()
        for i, t in ipairs(Utils.Cache.ActiveTweens) do
            if t == tween then
                table.remove(Utils.Cache.ActiveTweens, i)
                break
            end
        end
    end)
    
    tween:Play()
    return tween
end

function Utils.Performance.debounce(func, delay)
    local lastCall = 0
    return function(...)
        local now = tick()
        if now - lastCall >= delay then
            lastCall = now
            return func(...)
        end
    end
end

function Utils.Performance.memoize(func)
    local cache = {}
    return function(...)
        local key = table.concat({...}, "_")
        if cache[key] == nil then
            cache[key] = func(...)
        end
        return cache[key]
    end
end

-- Math Utils
function Utils.Math.lerp(a, b, t)
    return a + (b - a) * math.clamp(t, 0, 1)
end

function Utils.Math.bezier(t, p0, p1, p2, p3)
    local u = 1 - t
    return u^3 * p0 + 3 * u^2 * t * p1 + 3 * u * t^2 * p2 + t^3 * p3
end

function Utils.Math.spring(current, target, velocity, damping, stiffness, dt)
    local force = stiffness * (target - current)
    local dampingForce = damping * velocity
    local acceleration = force - dampingForce
    velocity = velocity + acceleration * dt
    current = current + velocity * dt
    return current, velocity
end

-- Animation Utils
function Utils.Animation.createSpringTween(instance, property, target, config)
    config = config or { damping = 0.8, stiffness = 0.3 }
    
    local current = instance[property]
    local velocity = 0
    local connection
    
    connection = Services.RunService.Heartbeat:Connect(function(dt)
        current, velocity = Utils.Math.spring(current, target, velocity, 
            config.damping, config.stiffness, dt)
        
        instance[property] = current
        
        if math.abs(current - target) < 0.001 and math.abs(velocity) < 0.001 then
            instance[property] = target
            connection:Disconnect()
            if config.callback then config.callback() end
        end
    end)
    
    return connection
end

-- UI Creation Utils
function Utils.createInstance(className, properties)
    local instance = Instance.new(className)
    
    for property, value in pairs(properties or {}) do
        if property == "Parent" then
            -- Set parent last to avoid unnecessary calculations
        else
            pcall(function() instance[property] = value end)
        end
    end
    
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    
    return instance
end

function Utils.applyCorners(instance, radius)
    if not instance then return end
    return Utils.createInstance("UICorner", {
        CornerRadius = UDim.new(0, radius or CONFIG.UI.CORNER_RADIUS),
        Parent = instance
    })
end

function Utils.createGradient(instance, colorSequence, rotation)
    if not instance then return end
    return Utils.createInstance("UIGradient", {
        Color = colorSequence,
        Rotation = rotation or 0,
        Parent = instance
    })
end

function Utils.createStroke(instance, color, thickness, transparency)
    if not instance then return end
    return Utils.createInstance("UIStroke", {
        Color = color or Color3.new(1, 1, 1),
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        Parent = instance
    })
end

function Utils.createShadow(instance, size, color, transparency)
    if not instance or not instance.Parent then return end
    
    local shadow = Utils.createInstance("ImageLabel", {
        Name = "DropShadow",
        Size = UDim2.new(1, size * 2, 1, size * 2),
        Position = UDim2.new(0, -size, 0, -size),
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3 = color or Color3.new(0, 0, 0),
        ImageTransparency = transparency or 0.8,
        ZIndex = math.max(1, (instance.ZIndex or 1) - 1),
        Parent = instance.Parent
    })
    
    Utils.applyCorners(shadow, CONFIG.UI.CORNER_RADIUS + 3)
    return shadow
end

-- ═══════════════════════════════════════════════════════════════
-- ADVANCED LOGGING & DEBUG SYSTEM
-- ═══════════════════════════════════════════════════════════════

local Logger = {
    Level = {
        DEBUG = 0,
        INFO = 1,
        WARN = 2,
        ERROR = 3,
        CRITICAL = 4
    },
    
    currentLevel = 1,
    logs = {},
    maxLogs = 1000
}

function Logger:log(level, message, data)
    if level < self.currentLevel then return end
    
    local logEntry = {
        timestamp = os.time(),
        level = level,
        message = message,
        data = data,
        stack = debug.traceback()
    }
    
    table.insert(self.logs, logEntry)
    
    if #self.logs > self.maxLogs then
        table.remove(self.logs, 1)
    end
    
    local levelNames = {"DEBUG", "INFO", "WARN", "ERROR", "CRITICAL"}
    local prefix = string.format("[%s][%s]", 
        os.date("%H:%M:%S", logEntry.timestamp), 
        levelNames[level + 1])
    
    if level >= self.Level.ERROR then
        warn(prefix, message, data or "")
    else
        print(prefix, message, data or "")
    end
end

function Logger:debug(message, data) self:log(self.Level.DEBUG, message, data) end
function Logger:info(message, data) self:log(self.Level.INFO, message, data) end
function Logger:warn(message, data) self:log(self.Level.WARN, message, data) end
function Logger:error(message, data) self:log(self.Level.ERROR, message, data) end
function Logger:critical(message, data) self:log(self.Level.CRITICAL, message, data) end

-- ═══════════════════════════════════════════════════════════════
-- ADVANCED DATA MANAGEMENT SYSTEM
-- ═══════════════════════════════════════════════════════════════

local DataManager = {
    settings = {},
    cache = {},
    history = {},
    watchers = {}
}

function DataManager:initialize()
    self.settings = {
        theme = "DARK",
        soundEnabled = true,
        masterVolume = 0.5,
        autoApply = true,
        saveSettings = true,
        animations = true,
        showFPS = true,
        showMemory = true,
        autoSave = true,
        notifications = true,
        keybinds = {
            toggleUI = Enum.KeyCode.F1,
            closeUI = Enum.KeyCode.Escape,
            speedUp = Enum.KeyCode.Plus,
            speedDown = Enum.KeyCode.Minus
        },
        physics = {
            speed = CONFIG.PHYSICS.SPEED.DEFAULT,
            jumpPower = CONFIG.PHYSICS.JUMP_POWER.DEFAULT,
            jumpHeight = CONFIG.PHYSICS.JUMP_HEIGHT.DEFAULT,
            hipHeight = CONFIG.PHYSICS.HIP_HEIGHT.DEFAULT,
            gravity = CONFIG.PHYSICS.GRAVITY.DEFAULT
        }
    }
    
    Logger:info("DataManager initialized")
end

function DataManager:get(key, defaultValue)
    local keys = string.split(key, ".")
    local current = self.settings
    
    for _, k in ipairs(keys) do
        if type(current) ~= "table" or current[k] == nil then
            return defaultValue
        end
        current = current[k]
    end
    
    return current
end

function DataManager:set(key, value, silent)
    local keys = string.split(key, ".")
    local current = self.settings
    
    -- Navigate to parent
    for i = 1, #keys - 1 do
        local k = keys[i]
        if type(current[k]) ~= "table" then
            current[k] = {}
        end
        current = current[k]
    end
    
    local lastKey = keys[#keys]
    local oldValue = current[lastKey]
    current[lastKey] = value
    
    -- Add to history
    table.insert(self.history, {
        timestamp = tick(),
        key = key,
        oldValue = oldValue,
        newValue = value
    })
    
    -- Trigger watchers
    if not silent then
        self:_triggerWatchers(key, value, oldValue)
    end
    
    Logger:debug("Setting updated", {key = key, value = value})
end

function DataManager:watch(key, callback)
    if not self.watchers[key] then
        self.watchers[key] = {}
    end
    table.insert(self.watchers[key], callback)
end

function DataManager:_triggerWatchers(key, newValue, oldValue)
    if self.watchers[key] then
        for _, callback in ipairs(self.watchers[key]) do
            pcall(callback, newValue, oldValue, key)
        end
    end
end

function DataManager:export()
    return Services.HttpService:JSONEncode({
        settings = self.settings,
        metadata = {
            version = CONFIG.META.VERSION,
            exported = os.time(),
            build = CONFIG.META.BUILD
        }
    })
end

function DataManager:import(jsonData)
    local success, data = pcall(Services.HttpService.JSONDecode, Services.HttpService, jsonData)
    if not success then
        Logger:error("Failed to import data", data)
        return false
    end
    
    if data.settings then
        self.settings = data.settings
        Logger:info("Data imported successfully")
        return true
    end
    
    return false
end

-- ═══════════════════════════════════════════════════════════════
-- ADVANCED THEME SYSTEM WITH LIVE SWITCHING
-- ═══════════════════════════════════════════════════════════════

local ThemeManager = {
    currentTheme = "DARK",
    appliedElements = {},
    transitions = {}
}

function ThemeManager:initialize()
    self.currentTheme = DataManager:get("theme", "DARK")
    DataManager:watch("theme", function(newTheme)
        self:applyTheme(newTheme)
    end)
end

function ThemeManager:getColor(colorName)
    local theme = CONFIG.THEMES[self.currentTheme]
    return theme and theme[colorName] or Color3.new(1, 0, 1) -- Fallback magenta
end

function ThemeManager:applyTheme(themeName, animated)
    if not CONFIG.THEMES[themeName] then
        Logger:warn("Unknown theme", themeName)
        return
    end
    
    local oldTheme = self.currentTheme
    self.currentTheme = themeName
    
    Logger:info("Applying theme", themeName)
    
    -- Apply to all registered elements
    for element, properties in pairs(self.appliedElements) do
        if element and element.Parent then
            for property, colorName in pairs(properties) do
                local newColor = self:getColor(colorName)
                
                if animated and DataManager:get("animations", true) then
                    Utils.Performance.createOptimizedTween(element, 
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                        {[property] = newColor}
                    )
                else
                    element[property] = newColor
                end
            end
        end
    end
    
    DataManager:set("theme", themeName, true)
end

function ThemeManager:registerElement(element, colorMappings)
    if not element then return end
    self.appliedElements[element] = colorMappings
    
    -- Apply current theme immediately
    for property, colorName in pairs(colorMappings) do
        element[property] = self:getColor(colorName)
    end
end

function ThemeManager:unregisterElement(element)
    self.appliedElements[element] = nil
end

-- ═══════════════════════════════════════════════════════════════
-- ADVANCED SOUND SYSTEM WITH SPATIAL AUDIO
-- ═══════════════════════════════════════════════════════════════

local SoundManager = {
    sounds = {},
    activeChannels = {},
    masterVolume = 1,
    categories = {
        UI = 0.8,
        FEEDBACK = 0.6,
        AMBIENT = 0.4,
        NOTIFICATION = 0.9
    }
}

function SoundManager:initialize()
    self.masterVolume = DataManager:get("masterVolume", 0.5)
    
    -- Create sound instances
    for name, config in pairs(CONFIG.AUDIO.SOUNDS) do
        self.sounds[name] = Utils.createInstance("Sound", {
            SoundId = config.ID,
            Volume = config.VOLUME * self.masterVolume,
            Parent = Services.SoundService
        })
    end
    
    -- Watch for volume changes
    DataManager:watch("masterVolume", function(newVolume)
        self:setMasterVolume(newVolume)
    end)
    
    DataManager:watch("soundEnabled", function(enabled)
        self:setEnabled(enabled)
    end)
end

function SoundManager:play(soundName, properties)
    if not DataManager:get("soundEnabled", true) then return end
    
    local sound = self.sounds[soundName]
    if not sound then
        Logger:warn("Sound not found", soundName)
        return
    end
    
    -- Apply temporary properties
    if properties then
        for prop, value in pairs(properties) do
            sound[prop] = value
        end
    end
    
    sound:Stop()
    sound:Play()
    
    Logger:debug("Playing sound", soundName)
end

function SoundManager:setMasterVolume(volume)
    self.masterVolume = math.clamp(volume, 0, 1)
    
    for name, sound in pairs(self.sounds) do
        local config = CONFIG.AUDIO.SOUNDS[name]
        if config then
            sound.Volume = config.VOLUME * self.masterVolume
        end
    end
end

function SoundManager:setEnabled(enabled)
    for _, sound in pairs(self.sounds) do
        sound.Volume = enabled and sound.Volume or 0
    end
end

-- ═══════════════════════════════════════════════════════════════
-- MAIN CONTROLLER CLASS WITH ADVANCED ARCHITECTURE
-- ═══════════════════════════════════════════════════════════════

local NatHubController = {
    -- Core Properties
    player = Services.Players.LocalPlayer,
    playerGui = nil,
    
    -- State Management
    state = {
        isVisible = false,
        isMinimized = false,
        isLocked = false,
        isDragging = false,
        isResizing = false,
        currentPage = "Speed",
        lastUpdate = 0,
        frameCount = 0
    },
    
    -- Component Registry
    components = {},
    pages = {},
    connections = {},
    
    -- Performance Monitoring
    performance = {
        fps = 60,
        memory = 0,
        ping = 0,
        frameTime = 0,
        drawCalls = 0
    },
    
    -- Statistics
    stats = {
        sessionStart = tick(),
        totalActions = 0,
        speedChanges = 0,
        uiToggles = 0,
        errors = 0
    }
}

function NatHubController:initialize()
    Logger:info("Initializing NatHub Controller v" .. CONFIG.META.VERSION)
    
    self.playerGui = self.player:WaitForChild("PlayerGui")
    
    -- Initialize subsystems
    DataManager:initialize()
    ThemeManager:initialize()
    SoundManager:initialize()
    
    -- Clean existing UI
    local existing = self.playerGui:FindFirstChild("NatHubUI")
    if existing then
        existing:Destroy()
        wait(0.1)
    end
    
    -- Create main UI
    self:createMainInterface()
    self:createToggleButton()
    
    -- Setup systems
    self:setupEventHandlers()
    self:setupCharacterHandling()
    self:setupPerformanceMonitoring()
    self:setupKeybinds()
    
    -- Apply saved settings
    self:applySavedSettings()
    
    -- Start main update loop
    self:startUpdateLoop()
    
    Logger:info("NatHub Controller initialized successfully")
    self:showWelcomeMessage()
end

function NatHubController:createMainInterface()
    -- Main ScreenGui with advanced properties
    local screenGui = Utils.createInstance("ScreenGui", {
        Name = "NatHubUI",
        Parent = self.playerGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
        IgnoreGuiInset = false
    })
    
    -- Background blur effect
    local blur = Utils.createInstance("BlurEffect", {
        Size = 0,
        Parent = Services.Lighting
    })
    
    -- Main container with responsive design
    local mainFrame = Utils.createInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0.5, 0, 0.5, 0), -- Start with relative size for responsiveness
        Position = UDim2.new(0.5, 0, 0.5, 0), -- Center it
        AnchorPoint = Vector2.new(0.5, 0.5), -- Anchor to center for proper positioning
        BackgroundColor3 = ThemeManager:getColor("BACKGROUND"),
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Active = true,
        Parent = screenGui
    })
    
    -- Enhanced visual effects
    Utils.applyCorners(mainFrame, CONFIG.UI.CORNER_RADIUS)
    Utils.createShadow(mainFrame, 15, Color3.new(0, 0, 0), 0.3)
    
    -- Animated border with rainbow effect (can be improved with UIGradient animation)
    local borderStroke = Utils.createStroke(mainFrame, ThemeManager:getColor("ACCENT"), 2, 0.2)
    
    -- Background gradient with theme colors
    Utils.createGradient(mainFrame, ColorSequence.new({
        ColorSequenceKeypoint.new(0, ThemeManager:getColor("BACKGROUND")),
        ColorSequenceKeypoint.new(1, ThemeManager:getColor("SURFACE"))
    }), 135)
    
    -- Register for theme updates
    ThemeManager:registerElement(mainFrame, {
        BackgroundColor3 = "BACKGROUND"
    })
    
    -- Create interface sections
    self:createHeader(mainFrame)
    self:createSidebar(mainFrame)
    self:createContentArea(mainFrame)
    self:createStatusBar(mainFrame)
    
    -- Store references
    self.components.screenGui = screenGui
    self.components.mainFrame = mainFrame
    self.components.blur = blur
    
    -- Setup advanced interactions
    self:setupDragAndResize(mainFrame)

    -- Initial animation for main frame
    Utils.Performance.createOptimizedTween(mainFrame,
        TweenInfo.new(CONFIG.UI.ANIMATION_SPEED, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, CONFIG.UI.MAIN_SIZE.X, 0, CONFIG.UI.MAIN_SIZE.Y), Position = UDim2.new(0.5, -CONFIG.UI.MAIN_SIZE.X/2, 0.5, -CONFIG.UI.MAIN_SIZE.Y/2)}
    )
end

function NatHubController:createToggleButton()
    local toggleButton = Utils.createInstance("TextButton", {
        Name = "ToggleButton",
        Size = UDim2.new(0, CONFIG.UI.TOGGLE_SIZE, 0, CONFIG.UI.TOGGLE_SIZE),
        Position = UDim2.new(0, 25, 0, 100),
        BackgroundColor3 = ThemeManager:getColor("ACCENT"),
        Text = CONFIG.ICONS.MENU,
        TextColor3 = ThemeManager:getColor("TEXT_PRIMARY"),
        TextSize = 28,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        ZIndex = 1000,
        Parent = self.components.screenGui
    })
    
    Utils.applyCorners(toggleButton, CONFIG.UI.TOGGLE_SIZE/2)
    Utils.createShadow(toggleButton, 8, Color3.new(0, 0, 0), 0.4)
    
    -- Advanced gradient effect
    Utils.createGradient(toggleButton, ColorSequence.new({
        ColorSequenceKeypoint.new(0, ThemeManager:getColor("ACCENT")),
        ColorSequenceKeypoint.new(1, ThemeManager:getColor("ACCENT"):lerp(Color3.new(0, 0, 0), 0.3))
    }), 45)
    
    -- Pulsing animation with spring physics
    local pulseTween = Utils.Performance.createOptimizedTween(toggleButton,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Size = UDim2.new(0, CONFIG.UI.TOGGLE_SIZE * 1.1, 0, CONFIG.UI.TOGGLE_SIZE * 1.1), 
         Position = UDim2.new(0, 25 - (CONFIG.UI.TOGGLE_SIZE * 0.05), 0, 100 - (CONFIG.UI.TOGGLE_SIZE * 0.05))}
    )

    -- Store reference
    self.components.toggleButton = toggleButton

    -- Connect event handler
    toggleButton.MouseButton1Click:Connect(function()
        SoundManager:play("CLICK")
        self:toggleUI()
    end)

    -- Register for theme updates
    ThemeManager:registerElement(toggleButton, {
        BackgroundColor3 = "ACCENT",
        TextColor3 = "TEXT_PRIMARY"
    })
end

function NatHubController:createHeader(parentFrame)
    local headerFrame = Utils.createInstance("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, CONFIG.UI.HEADER_HEIGHT),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = ThemeManager:getColor("SURFACE"),
        BorderSizePixel = 0,
        Parent = parentFrame
    })

    Utils.applyCorners(headerFrame, CONFIG.UI.CORNER_RADIUS)
    ThemeManager:registerElement(headerFrame, {
        BackgroundColor3 = "SURFACE"
    })

    local titleLabel = Utils.createInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -150, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        Text = "NatHub Controller",
        TextColor3 = ThemeManager:getColor("TEXT_PRIMARY"),
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = headerFrame
    })
    ThemeManager:registerElement(titleLabel, {
        TextColor3 = "TEXT_PRIMARY"
    })

    local closeButton = Utils.createInstance("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -50, 0.5, -20),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = ThemeManager:getColor("DANGER"),
        Text = CONFIG.ICONS.CLOSE,
        TextColor3 = ThemeManager:getColor("TEXT_PRIMARY"),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = headerFrame
    })
    Utils.applyCorners(closeButton, 8)
    ThemeManager:registerElement(closeButton, {
        BackgroundColor3 = "DANGER",
        TextColor3 = "TEXT_PRIMARY"
    })
    closeButton.MouseButton1Click:Connect(function()
        SoundManager:play("CLOSE")
        self:hideUI()
    end)

    local minimizeButton = Utils.createInstance("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -100, 0.5, -20),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = ThemeManager:getColor("INFO"),
        Text = CONFIG.ICONS.MINIMIZE,
        TextColor3 = ThemeManager:getColor("TEXT_PRIMARY"),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = headerFrame
    })
    Utils.applyCorners(minimizeButton, 8)
    ThemeManager:registerElement(minimizeButton, {
        BackgroundColor3 = "INFO",
        TextColor3 = "TEXT_PRIMARY"
    })
    minimizeButton.MouseButton1Click:Connect(function()
        SoundManager:play("CLICK")
        self:toggleMinimize()
    end)

    self.components.headerFrame = headerFrame
    self.components.closeButton = closeButton
    self.components.minimizeButton = minimizeButton
end

function NatHubController:createSidebar(parentFrame)
    local sidebarFrame = Utils.createInstance("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, CONFIG.UI.SIDEBAR_WIDTH, 1, -CONFIG.UI.HEADER_HEIGHT),
        Position = UDim2.new(0, 0, 0, CONFIG.UI.HEADER_HEIGHT),
        BackgroundColor3 = ThemeManager:getColor("SIDEBAR"),
        BorderSizePixel = 0,
        Parent = parentFrame
    })

    Utils.applyCorners(sidebarFrame, CONFIG.UI.CORNER_RADIUS)
    ThemeManager:registerElement(sidebarFrame, {
        BackgroundColor3 = "SIDEBAR"
    })

    local layout = Utils.createInstance("UIListLayout", {
        Name = "SidebarLayout",
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        Parent = sidebarFrame
    })

    local padding = Utils.createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 15),
        PaddingBottom = UDim.new(0, 15),
        Parent = sidebarFrame
    })

    local function createSidebarButton(name, icon, pageName)
        local button = Utils.createInstance("TextButton", {
            Name = name .. "Button",
            Size = UDim2.new(0.9, 0, 0, 50),
            BackgroundColor3 = ThemeManager:getColor("SURFACE"),
            Text = icon .. "  " .. name,
            TextColor3 = ThemeManager:getColor("TEXT_SECONDARY"),
            TextSize = 18,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextScaled = false,
            BorderSizePixel = 0,
            Parent = sidebarFrame
        })
        Utils.applyCorners(button, 10)
        ThemeManager:registerElement(button, {
            BackgroundColor3 = "SURFACE",
            TextColor3 = "TEXT_SECONDARY"
        })

        button.MouseEnter:Connect(function()
            SoundManager:play("HOVER")
            Utils.Performance.createOptimizedTween(button,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad),
                {BackgroundColor3 = ThemeManager:getColor("HOVER")}
            )
        end)
        button.MouseLeave:Connect(function()
            Utils.Performance.createOptimizedTween(button,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad),
                {BackgroundColor3 = ThemeManager:getColor("SURFACE")}
            )
        end)
        button.MouseButton1Click:Connect(function()
            SoundManager:play("CLICK")
            self:navigateToPage(pageName)
        end)
        return button
    end

    self.components.sidebarFrame = sidebarFrame
    self.components.sidebarButtons = {
        createSidebarButton("Home", CONFIG.ICONS.HOME, "Home"),
        createSidebarButton("Speed", CONFIG.ICONS.SPEED, "Speed"),
        createSidebarButton("Jump", CONFIG.ICONS.JUMP, "Jump"),
        createSidebarButton("Settings", CONFIG.ICONS.SETTINGS, "Settings"),
        createSidebarButton("Info", CONFIG.ICONS.INFO, "Info")
    }
end

function NatHubController:createContentArea(parentFrame)
    local contentFrame = Utils.createInstance("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -CONFIG.UI.SIDEBAR_WIDTH, 1, -CONFIG.UI.HEADER_HEIGHT),
        Position = UDim2.new(0, CONFIG.UI.SIDEBAR_WIDTH, 0, CONFIG.UI.HEADER_HEIGHT),
        BackgroundColor3 = ThemeManager:getColor("BACKGROUND"),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = parentFrame
    })

    ThemeManager:registerElement(contentFrame, {
        BackgroundColor3 = "BACKGROUND"
    })

    self.components.contentFrame = contentFrame

    -- Create individual pages
    self:createHomePage(contentFrame)
    self:createSpeedPage(contentFrame)
    self:createJumpPage(contentFrame)
    self:createSettingsPage(contentFrame)
    self:createInfoPage(contentFrame)

    -- Set initial page
    self:navigateToPage(self.state.currentPage)
end

function NatHubController:createStatusBar(parentFrame)
    local statusBar = Utils.createInstance("Frame", {
        Name = "StatusBar",
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 1, -25),
        BackgroundColor3 = ThemeManager:getColor("SURFACE"),
        BorderSizePixel = 0,
        Parent = parentFrame
    })

    ThemeManager:registerElement(statusBar, {
        BackgroundColor3 = "SURFACE"
    })

    local statusLabel = Utils.createInstance("TextLabel", {
        Name = "StatusLabel",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        Text = "Ready",
        TextColor3 = ThemeManager:getColor("TEXT_SECONDARY"),
        TextSize = 14,
        Font = Enum.Font.SourceSansPro,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextScaled = false,
        Parent = statusBar
    })
    ThemeManager:registerElement(statusLabel, {
        TextColor3 = "TEXT_SECONDARY"
    })

    self.components.statusBar = statusBar
    self.components.statusLabel = statusLabel
end

function NatHubController:createHomePage(parentFrame)
    local homePage = Utils.createInstance("Frame", {
        Name = "HomePage",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = ThemeManager:getColor("BACKGROUND"),
        BorderSizePixel = 0,
        Parent = parentFrame,
        Visible = false
    })
    ThemeManager:registerElement(homePage, {
        BackgroundColor3 = "BACKGROUND"
    })

    local welcomeText = Utils.createInstance("TextLabel", {
        Name = "WelcomeText",
        Size = UDim2.new(0.8, 0, 0.2, 0),
        Position = UDim2.new(0.5, 0, 0.3, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        Text = "Welcome to NatHub Controller!",
        TextColor3 = ThemeManager:getColor("ACCENT"),
        TextSize = 32,
        Font = Enum.Font.GothamBold,
        TextWrapped = true,
        TextScaled = true,
        Parent = homePage
    })
    ThemeManager:registerElement(welcomeText, {
        TextColor3 = "ACCENT"
    })

    local versionText = Utils.createInstance("TextLabel", {
        Name = "VersionText",
        Size = UDim2.new(0.6, 0, 0.1, 0),
        Position = UDim2.new(0.5, 0, 0.6, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        Text = "Version: " .. CONFIG.META.VERSION .. " (" .. CONFIG.META.BUILD .. ")",
        TextColor3 = ThemeManager:getColor("TEXT_MUTED"),
        TextSize = 18,
        Font = Enum.Font.SourceSansPro,
        TextWrapped = true,
        TextScaled = true,
        Parent = homePage
    })
    ThemeManager:registerElement(versionText, {
        TextColor3 = "TEXT_MUTED"
    })

    self.pages.Home = homePage
end

function NatHubController:createSpeedPage(parentFrame)
    local speedPage = Utils.createInstance("Frame", {
        Name = "SpeedPage",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = ThemeManager:getColor("BACKGROUND"),
        BorderSizePixel = 0,
        Parent = parentFrame,
        Visible = false
    })
    ThemeManager:registerElement(speedPage, {
        BackgroundColor3 = "BACKGROUND"
    })

    local title = Utils.createInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        Text = "Speed Settings",
        TextColor3 = ThemeManager:getColor("TEXT_PRIMARY"),
        TextSize = 28,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = speedPage
    })
    ThemeManager:registerElement(title, {
        TextColor3 = "TEXT_PRIMARY"
    })

    local speedSlider = Utils.createInstance("Slider", {
        Name = "SpeedSlider",
        Size = UDim2.new(0.8, 0, 0, 30),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = speedPage
    })
    -- This is a placeholder. A real slider implementation would be more complex.
    -- For now, let's just add a text label to display the value.
    local speedValueLabel = Utils.createInstance("TextLabel", {
        Name = "SpeedValueLabel",
        Size = UDim2.new(0.2, 0, 0, 20),
        Position = UDim2.new(0.5, 0, 0.6, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        Text = "Current Speed: " .. DataManager:get("physics.speed"),
        TextColor3 = ThemeManager:getColor("TEXT_SECONDARY"),
        TextSize = 16,
        Font = Enum.Font.SourceSansPro,
        Parent = speedPage
    })
    ThemeManager:registerElement(speedValueLabel, {
        TextColor3 = "TEXT_SECONDARY"
    })

    -- Connect slider to DataManager (simplified for now)
    DataManager:watch("physics.speed", function(newSpeed)
        speedValueLabel.Text = "Current Speed: " .. string.format("%.1f", newSpeed)
        -- Update actual character speed here
        if self.player.Character and self.player.Character:FindFirstChildOfClass("Humanoid") then
            self.player.Character.Humanoid.WalkSpeed = newSpeed
        end
    end)

    -- Simulate slider interaction (for demonstration)
    speedSlider.Changed:Connect(function()
        -- In a real scenario, you'd get the slider's value
        local simulatedValue = math.round(speedSlider.AbsoluteSize.X / 10) -- Placeholder
        DataManager:set("physics.speed", simulatedValue)
    end)

    self.pages.Speed = speedPage
end

function NatHubController:createJumpPage(parentFrame)
    local jumpPage = Utils.createInstance("Frame", {
        Name = "JumpPage",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = ThemeManager:getColor("BACKGROUND"),
        BorderSizePixel = 0,
        Parent = parentFrame,
        Visible = false
    })
    ThemeManager:registerElement(jumpPage, {
        BackgroundColor3 = "BACKGROUND"
    })

    local title = Utils.createInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        Text = "Jump Settings",
        TextColor3 = ThemeManager:getColor("TEXT_PRIMARY"),
        TextSize = 28,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = jumpPage
    })
    ThemeManager:registerElement(title, {
        TextColor3 = "TEXT_PRIMARY"
    })

    local jumpPowerSlider = Utils.createInstance("Slider", {
        Name = "JumpPowerSlider",
        Size = UDim2.new(0.8, 0, 0, 30),
        Position = UDim2.new(0.5, 0, 0.4, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = jumpPage
    })
    local jumpPowerValueLabel = Utils.createInstance("TextLabel", {
        Name = "JumpPowerValueLabel",
        Size = UDim2.new(0.2, 0, 0, 20),
        Position = UDim2.new(0.5, 0, 0.45, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        Text = "Jump Power: " .. DataManager:get("physics.jumpPower"),
        TextColor3 = ThemeManager:getColor("TEXT_SECONDARY"),
        TextSize = 16,
        Font = Enum.Font.SourceSansPro,
        Parent = jumpPage
    })
    ThemeManager:registerElement(jumpPowerValueLabel, {
        TextColor3 = "TEXT_SECONDARY"
    })

    DataManager:watch("physics.jumpPower", function(newJumpPower)
        jumpPowerValueLabel.Text = "Jump Power: " .. string.format("%.1f", newJumpPower)
        if self.player.Character and self.player.Character:FindFirstChildOfClass("Humanoid") then
            self.player.Character.Humanoid.JumpPower = newJumpPower
        end
    end)

    local jumpHeightSlider = Utils.createInstance("Slider", {
        Name = "JumpHeightSlider",
        Size = UDim2.new(0.8, 0, 0, 30),
        Position = UDim2.new(0.5, 0, 0.6, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = jumpPage
    })
    local jumpHeightValueLabel = Utils.createInstance("TextLabel", {
        Name = "JumpHeightValueLabel",
        Size = UDim2.new(0.2, 0, 0, 20),
        Position = UDim2.new(0.5, 0, 0.65, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        Text = "Jump Height: " .. DataManager:get("physics.jumpHeight"),
        TextColor3 = ThemeManager:getColor("TEXT_SECONDARY"),
        TextSize = 16,
        Font = Enum.Font.SourceSansPro,
        Parent = jumpPage
    })
    ThemeManager:registerElement(jumpHeightValueLabel, {
        TextColor3 = "TEXT_SECONDARY"
    })

    DataManager:watch("physics.jumpHeight", function(newJumpHeight)
        jumpHeightValueLabel.Text = "Jump Height: " .. string.format("%.1f", newJumpHeight)
        -- Note: JumpHeight is usually derived from JumpPower and Gravity, direct setting might not be desired.
        -- For demonstration, we'll assume it's a direct setting.
        -- if self.player.Character and self.player.Character:FindFirstChildOfClass("Humanoid") then
        --     self.player.Character.Humanoid.JumpHeight = newJumpHeight
        -- end
    end)

    self.pages.Jump = jumpPage
end

function NatHubController:createSettingsPage(parentFrame)
    local settingsPage = Utils.createInstance("Frame", {
        Name = "SettingsPage",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = ThemeManager:getColor("BACKGROUND"),
        BorderSizePixel = 0,
        Parent = parentFrame,
        Visible = false
    })
    ThemeManager:registerElement(settingsPage, {
        BackgroundColor3 = "BACKGROUND"
    })

    local title = Utils.createInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        Text = "General Settings",
        TextColor3 = ThemeManager:getColor("TEXT_PRIMARY"),
        TextSize = 28,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = settingsPage
    })
    ThemeManager:registerElement(title, {
        TextColor3 = "TEXT_PRIMARY"
    })

    local themeToggle = Utils.createInstance("TextButton", {
        Name = "ThemeToggle",
        Size = UDim2.new(0.8, 0, 0, 50),
        Position = UDim2.new(0.5, 0, 0.2, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = ThemeManager:getColor("SURFACE"),
        Text = "Toggle Theme (Current: " .. DataManager:get("theme") .. ")",
        TextColor3 = ThemeManager:getColor("TEXT_PRIMARY"),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = settingsPage
    })
    Utils.applyCorners(themeToggle, 10)
    ThemeManager:registerElement(themeToggle, {
        BackgroundColor3 = "SURFACE",
        TextColor3 = "TEXT_PRIMARY"
    })
    themeToggle.MouseButton1Click:Connect(function()
        SoundManager:play("CLICK")
        local currentTheme = DataManager:get("theme")
        local newTheme = (currentTheme == "DARK") and "LIGHT" or "DARK"
        DataManager:set("theme", newTheme)
        themeToggle.Text = "Toggle Theme (Current: " .. newTheme .. ")"
    end)

    local soundToggle = Utils.createInstance("TextButton", {
        Name = "SoundToggle",
        Size = UDim2.new(0.8, 0, 0, 50),
        Position = UDim2.new(0.5, 0, 0.35, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = ThemeManager:getColor("SURFACE"),
        Text = "Toggle Sound (Current: " .. tostring(DataManager:get("soundEnabled")) .. ")",
        TextColor3 = ThemeManager:getColor("TEXT_PRIMARY"),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = settingsPage
    })
    Utils.applyCorners(soundToggle, 10)
    ThemeManager:registerElement(soundToggle, {
        BackgroundColor3 = "SURFACE",
        TextColor3 = "TEXT_PRIMARY"
    })
    soundToggle.MouseButton1Click:Connect(function()
        SoundManager:play("CLICK")
        local currentSound = DataManager:get("soundEnabled")
        DataManager:set("soundEnabled", not currentSound)
        soundToggle.Text = "Toggle Sound (Current: " .. tostring(not currentSound) .. ")"
    end)

    self.pages.Settings = settingsPage
end

function NatHubController:createInfoPage(parentFrame)
    local infoPage = Utils.createInstance("Frame", {
        Name = "InfoPage",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = ThemeManager:getColor("BACKGROUND"),
        BorderSizePixel = 0,
        Parent = parentFrame,
        Visible = false
    })
    ThemeManager:registerElement(infoPage, {
        BackgroundColor3 = "BACKGROUND"
    })

    local title = Utils.createInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        Text = "System Information",
        TextColor3 = ThemeManager:getColor("TEXT_PRIMARY"),
        TextSize = 28,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = infoPage
    })
    ThemeManager:registerElement(title, {
        TextColor3 = "TEXT_PRIMARY"
    })

    local infoText = Utils.createInstance("TextLabel", {
        Name = "InfoText",
        Size = UDim2.new(0.9, 0, 0.7, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        Text = "Loading system information...",
        TextColor3 = ThemeManager:getColor("TEXT_SECONDARY"),
        TextSize = 16,
        Font = Enum.Font.SourceSansPro,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = infoPage
    })
    ThemeManager:registerElement(infoText, {
        TextColor3 = "TEXT_SECONDARY"
    })

    self.components.infoText = infoText
    self.pages.Info = infoPage
end

function NatHubController:navigateToPage(pageName)
    if self.pages[pageName] then
        for _, page in pairs(self.pages) do
            page.Visible = false
        end
        self.pages[pageName].Visible = true
        self.state.currentPage = pageName
        Logger:info("Navigated to page", pageName)

        -- Update sidebar button highlight
        for _, button in ipairs(self.components.sidebarButtons) do
            if button.Name:match(pageName) then
                Utils.Performance.createOptimizedTween(button,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                    {BackgroundColor3 = ThemeManager:getColor("SELECTED")}
                )
            else
                Utils.Performance.createOptimizedTween(button,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                    {BackgroundColor3 = ThemeManager:getColor("SURFACE")}
                )
            end
        end

        -- Update status bar
        self.components.statusLabel.Text = "Viewing: " .. pageName .. " Page"
    else
        Logger:warn("Attempted to navigate to unknown page", pageName)
    end
end

function NatHubController:toggleUI()
    self.state.isVisible = not self.state.isVisible
    local mainFrame = self.components.mainFrame
    local toggleButton = self.components.toggleButton
    local blur = self.components.blur

    if self.state.isVisible then
        -- Show UI
        mainFrame.Visible = true
        Utils.Performance.createOptimizedTween(mainFrame,
            TweenInfo.new(CONFIG.UI.ANIMATION_SPEED, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, -mainFrame.AbsoluteSize.X/2, 0.5, -mainFrame.AbsoluteSize.Y/2)}
        )
        Utils.Performance.createOptimizedTween(blur,
            TweenInfo.new(CONFIG.UI.ANIMATION_SPEED, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
            {Size = CONFIG.UI.BLUR_INTENSITY}
        )
        Utils.Performance.createOptimizedTween(toggleButton,
            TweenInfo.new(CONFIG.UI.ANIMATION_SPEED, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
            {Position = UDim2.new(0, 25, 0, 25), Text = CONFIG.ICONS.CLOSE}
        )
        SoundManager:play("OPEN")
        self.components.statusLabel.Text = "UI Opened"
    else
        -- Hide UI
        Utils.Performance.createOptimizedTween(mainFrame,
            TweenInfo.new(CONFIG.UI.ANIMATION_SPEED, Enum.EasingStyle.Exponential, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, -mainFrame.AbsoluteSize.X/2, -1, 0)}, function()
                mainFrame.Visible = false
            end
        )
        Utils.Performance.createOptimizedTween(blur,
            TweenInfo.new(CONFIG.UI.ANIMATION_SPEED, Enum.EasingStyle.Exponential, Enum.EasingDirection.In),
            {Size = 0}
        )
        Utils.Performance.createOptimizedTween(toggleButton,
            TweenInfo.new(CONFIG.UI.ANIMATION_SPEED, Enum.EasingStyle.Exponential, Enum.EasingDirection.In),
            {Position = UDim2.new(0, 25, 0, 100), Text = CONFIG.ICONS.MENU}
        )
        SoundManager:play("CLOSE")
        self.components.statusLabel.Text = "UI Closed"
    end
    self.stats.uiToggles = self.stats.uiToggles + 1
    Logger:info("UI visibility toggled to", self.state.isVisible)
end

function NatHubController:hideUI()
    if self.state.isVisible then
        self:toggleUI()
    end
end

function NatHubController:toggleMinimize()
    self.state.isMinimized = not self.state.isMinimized
    local mainFrame = self.components.mainFrame
    local minimizeButton = self.components.minimizeButton

    if self.state.isMinimized then
        -- Minimize UI
        Utils.Performance.createOptimizedTween(mainFrame,
            TweenInfo.new(CONFIG.UI.ANIMATION_SPEED, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, CONFIG.UI.MIN_SIZE.X, 0, CONFIG.UI.HEADER_HEIGHT)}
        )
        minimizeButton.Text = CONFIG.ICONS.MAXIMIZE
        self.components.statusLabel.Text = "UI Minimized"
    else
        -- Maximize UI
        Utils.Performance.createOptimizedTween(mainFrame,
            TweenInfo.new(CONFIG.UI.ANIMATION_SPEED, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, CONFIG.UI.MAIN_SIZE.X, 0, CONFIG.UI.MAIN_SIZE.Y)}
        )
        minimizeButton.Text = CONFIG.ICONS.MINIMIZE
        self.components.statusLabel.Text = "UI Maximized"
    end
    Logger:info("UI minimized state toggled to", self.state.isMinimized)
end

function NatHubController:setupEventHandlers()
    -- Handle UI visibility based on game focus
    Services.GuiService.MenuOpened:Connect(function()
        if self.state.isVisible then
            self:hideUI()
        end
    end)

    -- Handle keybinds
    Services.UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end

        if input.KeyCode == DataManager:get("keybinds.toggleUI") then
            self:toggleUI()
        elseif input.KeyCode == DataManager:get("keybinds.closeUI") then
            self:hideUI()
        elseif input.KeyCode == DataManager:get("keybinds.speedUp") then
            local currentSpeed = DataManager:get("physics.speed")
            DataManager:set("physics.speed", math.min(CONFIG.PHYSICS.SPEED.MAX, currentSpeed + CONFIG.PHYSICS.SPEED.STEP))
            self.stats.speedChanges = self.stats.speedChanges + 1
        elseif input.KeyCode == DataManager:get("keybinds.speedDown") then
            local currentSpeed = DataManager:get("physics.speed")
            DataManager:set("physics.speed", math.max(CONFIG.PHYSICS.SPEED.MIN, currentSpeed - CONFIG.PHYSICS.SPEED.STEP))
            self.stats.speedChanges = self.stats.speedChanges + 1
        end
    end)

    -- Handle window resizing for responsive UI
    self.components.screenGui.AbsoluteSizeChanged:Connect(function()
        self:updateUIPositions()
    end)

    Logger:info("Event handlers set up")
end

function NatHubController:updateUIPositions()
    local screenGui = self.components.screenGui
    local mainFrame = self.components.mainFrame
    local toggleButton = self.components.toggleButton

    -- Adjust mainFrame position based on current state
    if self.state.isVisible then
        mainFrame.Position = UDim2.new(0.5, -mainFrame.AbsoluteSize.X/2, 0.5, -mainFrame.AbsoluteSize.Y/2)
    else
        mainFrame.Position = UDim2.new(0.5, -mainFrame.AbsoluteSize.X/2, -1, 0)
    end

    -- Adjust toggleButton position
    if self.state.isVisible then
        toggleButton.Position = UDim2.new(0, 25, 0, 25)
    else
        toggleButton.Position = UDim2.new(0, 25, 0, 100)
    end

    Logger:debug("UI positions updated due to screen resize")
end

function NatHubController:setupCharacterHandling()
    self.player.CharacterAdded:Connect(function(character)
        Logger:info("Character added", character.Name)
        -- Apply current physics settings to new character
        self:applyPhysicsSettings()
    end)

    -- Apply initial physics settings
    if self.player.Character then
        self:applyPhysicsSettings()
    end

    Logger:info("Character handling set up")
end

function NatHubController:applyPhysicsSettings()
    local humanoid = self.player.Character and self.player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = DataManager:get("physics.speed")
        humanoid.JumpPower = DataManager:get("physics.jumpPower")
        Services.Workspace.Gravity = DataManager:get("physics.gravity")
        -- HipHeight is usually set on the Humanoid.HipHeight property
        humanoid.HipHeight = DataManager:get("physics.hipHeight")
        Logger:debug("Applied physics settings to humanoid")
    else
        Logger:warn("Humanoid not found for applying physics settings")
    end
end

function NatHubController:setupPerformanceMonitoring()
    Services.RunService.Heartbeat:Connect(function(dt)
        self.state.frameCount = self.state.frameCount + 1
        self.state.lastUpdate = self.state.lastUpdate + dt

        if self.state.lastUpdate >= CONFIG.PERFORMANCE.STATS_INTERVAL then
            self.performance.fps = math.round(self.state.frameCount / self.state.lastUpdate)
            self.performance.memory = collectgarbage("count") / 1024 -- Memory in MB
            self.performance.ping = Services.Players.LocalPlayer:GetNetworkPing() * 1000 -- Ping in ms
            self.performance.frameTime = (self.state.lastUpdate / self.state.frameCount) * 1000 -- Frame time in ms
            self.performance.drawCalls = Services.Lighting.CurrentCamera.ViewportSize.X * Services.Lighting.CurrentCamera.ViewportSize.Y / 1000000 -- Placeholder for draw calls

            -- Update info page if visible
            if self.pages.Info and self.pages.Info.Visible then
                self.components.infoText.Text = string.format(
                    "FPS: %d\nMemory: %.2f MB\nPing: %d ms\nFrame Time: %.2f ms\nDraw Calls: %.2fM\nTotal Actions: %d\nErrors: %d",
                    self.performance.fps,
                    self.performance.memory,
                    self.performance.ping,
                    self.performance.frameTime,
                    self.performance.drawCalls,
                    self.stats.totalActions,
                    self.stats.errors
                )
            end

            -- Check memory threshold
            if self.performance.memory > CONFIG.PERFORMANCE.MEMORY_THRESHOLD / (1024 * 1024) then
                Logger:warn("Memory usage is high!", self.performance.memory .. " MB")
            end

            self.state.frameCount = 0
            self.state.lastUpdate = 0
        end
    end)

    Logger:info("Performance monitoring set up")
end

function NatHubController:setupKeybinds()
    -- Keybinds are handled in setupEventHandlers, this function can be used for more complex keybind management if needed.
    Logger:info("Keybind setup complete")
end

function NatHubController:applySavedSettings()
    local savedData = DataManager:import(Services.HttpService:JSONEncode(DataManager.settings)) -- Simulate loading from DataStore
    if savedData then
        Logger:info("Applied saved settings")
        -- Re-apply theme and sound settings after loading
        ThemeManager:applyTheme(DataManager:get("theme"), false)
        SoundManager:setMasterVolume(DataManager:get("masterVolume"))
        SoundManager:setEnabled(DataManager:get("soundEnabled"))
        self:applyPhysicsSettings()
    else
        Logger:info("No saved settings found or failed to load")
    end
end

function NatHubController:startUpdateLoop()
    -- This can be used for any continuous updates or checks
    Services.RunService.Heartbeat:Connect(function(dt)
        -- Example: Auto-save settings
        if DataManager:get("autoSave") and tick() - (DataManager.cache.lastAutoSave or 0) > CONFIG.PERFORMANCE.AUTOSAVE_INTERVAL then
            self:saveSettings()
            DataManager.cache.lastAutoSave = tick()
        end
    end)
    Logger:info("Main update loop started")
end

function NatHubController:saveSettings()
    local jsonData = DataManager:export()
    -- In a real Roblox game, you would save this `jsonData` to a DataStore.
    -- For this local script, we'll just log it.
    Logger:info("Settings saved", jsonData)
    self.components.statusLabel.Text = "Settings Saved!"
    SoundManager:play("SUCCESS")
end

function NatHubController:showWelcomeMessage()
    self.components.statusLabel.Text = "Welcome, " .. self.player.Name .. "!"
    SoundManager:play("NOTIFICATION")
    -- Optionally show the UI automatically on first run
    if not DataManager:get("hasSeenWelcome", false) then
        task.delay(2, function()
            self:toggleUI()
            DataManager:set("hasSeenWelcome", true)
        end)
    end
end

function NatHubController:setupDragAndResize(frame)
    local isDragging = false
    local dragStart = Vector2.new(0,0)
    local startPosition = UDim2.new(0,0,0,0)

    local isResizing = false
    local resizeStart = Vector2.new(0,0)
    local startSize = UDim2.new(0,0,0,0)

    local minSize = CONFIG.UI.MIN_SIZE
    local maxSize = CONFIG.UI.MAX_SIZE

    -- Dragging
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if not self.state.isLocked and not self.state.isMinimized then
                isDragging = true
                dragStart = Services.UserInputService:GetMouseLocation()
                startPosition = frame.Position
                Services.UserInputService.InputChanged:Connect(function(inputChanged)
                    if isDragging and (inputChanged.UserInputType == Enum.UserInputType.MouseMovement or inputChanged.UserInputType == Enum.UserInputType.Touch) then
                        local delta = Services.UserInputService:GetMouseLocation() - dragStart
                        frame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
                    end
                end)
            end
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    -- Resizing (simplified - typically involves specific resize handles)
    -- For a full implementation, you'd add transparent frames at edges/corners for resizing.
    -- Here, we'll just allow resizing from the bottom-right corner for demonstration.
    local resizeHandle = Utils.createInstance("Frame", {
        Name = "ResizeHandle",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -20, 1, -20),
        BackgroundColor3 = ThemeManager:getColor("ACCENT"),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = frame,
        ZIndex = 10
    })
    Utils.applyCorners(resizeHandle, 5)
    ThemeManager:registerElement(resizeHandle, {
        BackgroundColor3 = "ACCENT"
    })

    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if not self.state.isLocked and not self.state.isMinimized then
                isResizing = true
                resizeStart = Services.UserInputService:GetMouseLocation()
                startSize = frame.Size
                Services.UserInputService.InputChanged:Connect(function(inputChanged)
                    if isResizing and (inputChanged.UserInputType == Enum.UserInputType.MouseMovement or inputChanged.UserInputType == Enum.UserInputType.Touch) then
                        local delta = Services.UserInputService:GetMouseLocation() - resizeStart
                        local newX = math.clamp(startSize.X.Offset + delta.X, minSize.X, maxSize.X)
                        local newY = math.clamp(startSize.Y.Offset + delta.Y, minSize.Y, maxSize.Y)
                        frame.Size = UDim2.new(0, newX, 0, newY)
                    end
                end)
            end
        end
    end)

    resizeHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isResizing = false
        end
    end)

    Logger:info("Drag and resize setup complete")
end

-- Initialize the controller
NatHubController:initialize()

-- Keep the script running
Services.RunService.Heartbeat:Wait()


