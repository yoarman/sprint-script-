local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local sprintSpeed = 24
local walkSpeed = 16
local sprinting = false

local function setSpeed(speed)
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = speed end
    end
end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SprintGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player.PlayerGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 200, 0, 110)
main.Position = UDim2.new(0, 16, 1, -126)
main.BackgroundColor3 = Color3.fromRGB(17, 19, 24)
main.BorderSizePixel = 0
main.Parent = screenGui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 34)
header.BackgroundColor3 = Color3.fromRGB(26, 29, 38)
header.BorderSizePixel = 0
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.BackgroundColor3 = Color3.fromRGB(26, 29, 38)
headerFix.BorderSizePixel = 0
headerFix.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -44, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🏃 Sprint Pro"
title.TextColor3 = Color3.fromRGB(200, 202, 216)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -32, 0.5, -12)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 43, 56)
minBtn.BorderSizePixel = 0
minBtn.Text = "—"
minBtn.TextColor3 = Color3.fromRGB(160, 163, 180)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 13
minBtn.Parent = header
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local body = Instance.new("Frame")
body.Size = UDim2.new(1, 0, 0, 76)
body.Position = UDim2.new(0, 0, 0, 34)
body.BackgroundTransparency = 1
body.ClipsDescendants = true
body.Parent = main

-- Status indicator
local statusBg = Instance.new("Frame")
statusBg.Size = UDim2.new(1, -24, 0, 30)
statusBg.Position = UDim2.new(0, 12, 0, 8)
statusBg.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
statusBg.BorderSizePixel = 0
statusBg.Parent = body
Instance.new("UICorner", statusBg).CornerRadius = UDim.new(0, 8)

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.AnchorPoint = Vector2.new(0, 0.5)
statusDot.Position = UDim2.new(0, 10, 0.5, 0)
statusDot.BackgroundColor3 = Color3.fromRGB(224, 85, 85)
statusDot.BorderSizePixel = 0
statusDot.Parent = statusBg
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -30, 1, 0)
statusText.Position = UDim2.new(0, 26, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Walking"
statusText.TextColor3 = Color3.fromRGB(224, 85, 85)
statusText.Font = Enum.Font.GothamBold
statusText.TextSize = 13
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusBg

-- Speed bar
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(1, -24, 0, 8)
barBg.Position = UDim2.new(0, 12, 0, 46)
barBg.BackgroundColor3 = Color3.fromRGB(30, 33, 48)
barBg.BorderSizePixel = 0
barBg.Parent = body
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(walkSpeed / sprintSpeed, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(224, 85, 85)
barFill.BorderSizePixel = 0
barFill.Parent = barBg
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -24, 0, 14)
speedLabel.Position = UDim2.new(0, 12, 0, 58)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: "..walkSpeed.."  |  Hold [L-Ctrl] to sprint"
speedLabel.TextColor3 = Color3.fromRGB(80, 85, 110)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 11
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = body

-- Minimize
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
    if minimized then
        TweenService:Create(main, info, {Size = UDim2.new(0, 200, 0, 34)}):Play()
        TweenService:Create(body, info, {Size = UDim2.new(1, 0, 0, 0)}):Play()
        minBtn.Text = "+"
    else
        TweenService:Create(main, info, {Size = UDim2.new(0, 200, 0, 110)}):Play()
        TweenService:Create(body, info, {Size = UDim2.new(1, 0, 0, 76)}):Play()
        minBtn.Text = "—"
    end
end)

-- Dragging
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Update GUI
local function tweenProp(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quad), props):Play()
end

local function updateGUI(isSprinting)
    if isSprinting then
        tweenProp(statusDot, {BackgroundColor3 = Color3.fromRGB(63, 216, 122)})
        tweenProp(statusText, {TextColor3 = Color3.fromRGB(63, 216, 122)})
        tweenProp(barFill, {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(63, 216, 122)})
        statusText.Text = "Sprinting"
        speedLabel.Text = "Speed: "..sprintSpeed.."  |  Hold [L-Ctrl] to sprint"
    else
        tweenProp(statusDot, {BackgroundColor3 = Color3.fromRGB(224, 85, 85)})
        tweenProp(statusText, {TextColor3 = Color3.fromRGB(224, 85, 85)})
        tweenProp(barFill, {Size = UDim2.new(walkSpeed/sprintSpeed, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(224, 85, 85)})
        statusText.Text = "Walking"
        speedLabel.Text = "Speed: "..walkSpeed.."  |  Hold [L-Ctrl] to sprint"
    end
end

-- Sprint logic
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        sprinting = true
        setSpeed(sprintSpeed)
        updateGUI(true)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        sprinting = false
        setSpeed(walkSpeed)
        updateGUI(false)
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(0.1)
    if sprinting then setSpeed(sprintSpeed) end
end)

print("Sprint Pro loaded! Hold Left Ctrl to sprint.")
