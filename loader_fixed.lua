-- Stand loader: runs the main script via loadstring
-- Users run:
--   getgenv().Script = "discord.gg/standd"
--   getgenv().Owner = "YOUR_USERNAME_THERE"
--   getgenv().DisableRendering = true
--   getgenv().FPSCap = 60
--   loadstring(game:HttpGet("THIS_LOADER_RAW_URL"))()
local SCRIPT_URL = "https://raw.githubusercontent.com/MarasMwa/bvcfdgsdhsdfhs/refs/heads/main/fsdbvcgdf"
local DISCORD_URL = "https://discord.gg/A4VurQvZt"

--//------------------------------------------------------------------------------------------\\--

if not game:IsLoaded() then game.Loaded:Wait() end

-- Lock: getgenv().Script must contain "discord.gg/standd" or nothing happens (no window, no script)
do
    local s = getgenv().Script
    if type(s) ~= "string" or not s:find("discord.gg/standd", 1, true) then return end
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer

if getgenv().LinaLoader then pcall(function() getgenv().LinaLoader:Destroy() end) end

local WHITE = Color3.fromRGB(235, 235, 240)
local GREY = Color3.fromRGB(130, 130, 140)
local RED = Color3.fromRGB(235, 100, 110)
local GREEN = Color3.fromRGB(110, 230, 140)

local parent
pcall(function() if gethui then parent = gethui() end end)
if not parent then pcall(function() parent = game:GetService("CoreGui") end) end
if not parent then parent = LocalPlayer:WaitForChild("PlayerGui") end

local gui = Instance.new("ScreenGui")
gui.Name = "lina's loader"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
gui.Parent = parent
getgenv().LinaLoader = gui

local function corner(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = o
end

-- Window (CanvasGroup: fades in/out as one piece)
local frame = Instance.new("CanvasGroup")
frame.Size = UDim2.fromOffset(360, 232)
frame.Position = UDim2.new(0.5, -180, 0.5, -116)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
frame.BorderSizePixel = 0
frame.GroupTransparency = 1
frame.Parent = gui
corner(frame)

local scale = Instance.new("UIScale")
scale.Scale = 0.88
scale.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 32)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
title.BorderSizePixel = 0
title.Text = "lina's stand loader"
title.TextColor3 = WHITE
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(24, 24)
close.Position = UDim2.new(1, -30, 0, 4)
close.BackgroundTransparency = 1
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 13
close.Parent = title

-- Info rows (game id / player id)
local function infoLabel(y)
    local l = Instance.new("TextLabel")
    l.Position = UDim2.fromOffset(12, y)
    l.Size = UDim2.new(1, -24, 0, 16)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Code
    l.TextSize = 12
    l.RichText = true
    l.TextColor3 = WHITE
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.Text = ""
    l.Parent = frame
    return l
end
local gameLbl = infoLabel(40)
local placeLbl = infoLabel(58)
local playerLbl = infoLabel(76)
local userLbl = infoLabel(94)

local function fmt(key, val)
    return ('<font color="#8a8a94">%s</font>  %s'):format(key, val)
end

-- Typewriter animation
local function typeIn(label, text)
    label.Text = text
    label.MaxVisibleGraphemes = 0
    local n = utf8.len((text:gsub("<[^>]->", ""))) or #text
    for i = 1, n do
        if not label.Parent then return end
        label.MaxVisibleGraphemes = i
        task.wait(0.012)
    end
    label.MaxVisibleGraphemes = -1
end

-- Discord box: rotating typewriter messages, click = copy the link
local urlBox = Instance.new("TextBox")
urlBox.Position = UDim2.fromOffset(8, 120)
urlBox.Size = UDim2.new(1, -16, 0, 28)
urlBox.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
urlBox.BorderSizePixel = 0
urlBox.Text = ""
urlBox.TextEditable = false
urlBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
urlBox.TextColor3 = Color3.fromRGB(114, 137, 218)
urlBox.Font = Enum.Font.Code
urlBox.TextSize = 12
urlBox.TextXAlignment = Enum.TextXAlignment.Left
urlBox.ClearTextOnFocus = false
urlBox.MaxVisibleGraphemes = 0
urlBox.Parent = frame
corner(urlBox, 6)
local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0, 8)
pad.PaddingRight = UDim.new(0, 8)
pad.Parent = urlBox

-- seffaf buton: tiklayinca discord linkini panoya kopyalar
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.fromScale(1, 1)
copyBtn.BackgroundTransparency = 1
copyBtn.Text = ""
copyBtn.AutoButtonColor = false
copyBtn.ZIndex = 5
copyBtn.Parent = urlBox
copyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard(DISCORD_URL)
        elseif toclipboard then toclipboard(DISCORD_URL) end
    end)
end)

local URL_MESSAGES = {
    "dont forget to join discord .gg/A4VurQvZt",
    "click here to copy the discord link",
    "new updates drop in the discord",
    "celeste is madly in love with lina",
    "did you know? the dev is celeste",
}

task.spawn(function()
    local idx = 0
    while gui.Parent do
        idx = idx % #URL_MESSAGES + 1
        local msg = URL_MESSAGES[idx]
        urlBox.Text = msg
        local n = utf8.len(msg) or #msg
        for i = 0, n do
            if not gui.Parent then return end
            urlBox.MaxVisibleGraphemes = i
            task.wait(0.05)
        end
        task.wait(1.8)
        for i = n, 0, -1 do
            if not gui.Parent then return end
            urlBox.MaxVisibleGraphemes = i
            task.wait(0.03)
        end
        task.wait(0.4)
    end
end)

local loadBtn = Instance.new("TextButton")
loadBtn.Position = UDim2.fromOffset(8, 156)
loadBtn.Size = UDim2.new(1, -16, 0, 30)
loadBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
loadBtn.BorderSizePixel = 0
loadBtn.Text = "Load"
loadBtn.TextColor3 = WHITE
loadBtn.Font = Enum.Font.GothamBold
loadBtn.TextSize = 14
loadBtn.AutoButtonColor = false
loadBtn.Parent = frame
corner(loadBtn, 6)

loadBtn.MouseEnter:Connect(function()
    TweenService:Create(loadBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(58, 58, 72) }):Play()
end)
loadBtn.MouseLeave:Connect(function()
    TweenService:Create(loadBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(40, 40, 50) }):Play()
end)

-- Progress bar
local bar = Instance.new("Frame")
bar.Position = UDim2.fromOffset(8, 194)
bar.Size = UDim2.new(1, -16, 0, 4)
bar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
bar.BorderSizePixel = 0
bar.ClipsDescendants = true
bar.Parent = frame
corner(bar, 2)

local fill = Instance.new("Frame")
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = WHITE
fill.BorderSizePixel = 0
fill.Parent = bar
corner(fill, 2)

local status = Instance.new("TextLabel")
status.Position = UDim2.fromOffset(8, 202)
status.Size = UDim2.new(1, -16, 0, 26)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.TextWrapped = true
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextYAlignment = Enum.TextYAlignment.Top
status.TextColor3 = GREY
status.Text = "Ready."
status.Parent = frame

local function setStatus(text, color)
    status.Text = text
    status.TextColor3 = color or GREY
    status.TextTransparency = 1
    TweenService:Create(status, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
end

-- Open / close animations
local function openAnim()
    TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { GroupTransparency = 0 }):Play()
    TweenService:Create(scale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
end
local closing = false
local function closeAnim()
    if closing then return end
    closing = true
    local t = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { GroupTransparency = 1 })
    TweenService:Create(scale, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.88 }):Play()
    t:Play()
    t.Completed:Wait()
    gui:Destroy()
end
close.MouseButton1Click:Connect(function() task.spawn(closeAnim) end)

-- Loading animation (sliding bar)
local busy = false
local function startBarAnim()
    task.spawn(function()
        fill.Size = UDim2.new(0.3, 0, 1, 0)
        while busy and gui.Parent do
            fill.Position = UDim2.new(-0.3, 0, 0, 0)
            local t = TweenService:Create(fill, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Position = UDim2.new(1, 0, 0, 0) })
            t:Play()
            t.Completed:Wait()
        end
    end)
end
local function finishBar(color)
    fill.BackgroundColor3 = color
    fill.Position = UDim2.new(0, 0, 0, 0)
    TweenService:Create(fill, TweenInfo.new(0.25), { Size = UDim2.new(1, 0, 1, 0) }):Play()
end
local function resetBar()
    fill.BackgroundColor3 = WHITE
    TweenService:Create(fill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
end

local function fail(msg)
    busy = false
    finishBar(RED)
    setStatus(msg, RED)
    loadBtn.Text = "Load"
    task.delay(1.2, function() if gui.Parent then resetBar() end end)
end

local function run()
    if busy then return end
    local url = SCRIPT_URL:gsub("%s", "")
    if url == "" or url:find("USER/REPO", 1, true) then
        setStatus("Script link not set.", RED)
        return
    end
    busy = true
    loadBtn.Text = "Loading..."
    setStatus("Downloading...", GREY)
    startBarAnim()
    -- cache atlatmak icin her seferinde farkli bir ?v= ekler
    local bust = url .. (url:find("?", 1, true) and "&" or "?") .. "v=" .. tostring(os.time()) .. tostring(math.random(1000, 9999))
    local ok, src = pcall(function() return game:HttpGet(bust) end)
    if not ok or type(src) ~= "string" or src == "" then
        return fail("Download failed: " .. tostring(src))
    end
    local fn, err = loadstring(src)
    if not fn then
        return fail("Script error: " .. tostring(err))
    end
    setStatus("Running...", GREEN)
    local ok2, err2 = pcall(fn)
    if not ok2 then
        return fail("Runtime error: " .. tostring(err2))
    end
    busy = false
    finishBar(GREEN)
    loadBtn.Text = "Loaded"
    setStatus("Loaded.", GREEN)
    task.wait(0.7)
    closeAnim()
end
loadBtn.MouseButton1Click:Connect(run)

-- Dragging
local dragging, dragStart, startPos
title.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, i.Position, frame.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Start: open, find the info and type it in, then load the stand script by itself
openAnim()
task.spawn(function()
    task.wait(0.3)
    local gameName = "..."
    local ok, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
    if ok and type(info) == "table" and info.Name then gameName = info.Name end
    typeIn(gameLbl, fmt("Game", gameName))
    typeIn(placeLbl, fmt("Place ID", tostring(game.PlaceId) .. "   Universe " .. tostring(game.GameId)))
    typeIn(playerLbl, fmt("Player", LocalPlayer.Name))
    typeIn(userLbl, fmt("User ID", tostring(LocalPlayer.UserId)))
    task.wait(0.6)
    if gui.Parent then run() end
end)
