local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local sprintSpeed = 24
local walkSpeed = 16
local sprinting = false
local buttonLocked = false

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

-- MAIN PANEL
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 220, 0, 160)
main.Position = UDim2.new(0, 16, 1, -176)
main.BackgroundColor3 = Color3.fromRGB(17, 19, 24)
main.BorderSizePixel = 0
main.Parent = screenGui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 36)
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
body.Size = UDim2.new(1, 0, 0, 124)
body.Position = UDim2.new(0, 0, 0, 36)
body.BackgroundTransparency = 1
body.ClipsDescendants = true
body.Parent = main

-- Status
local statusBg = Instance.new("Frame")
statusBg.Size = UDim2.new(1, -24, 0, 28)
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
statusText.TextSize = 12
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusBg

-- Speed slider
local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(0.6, 0, 0, 14)
sliderLabel.Position = UDim2.new(0, 12, 0, 44)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Sprint Speed"
sliderLabel.TextColor3 = Color3.fromRGB(130, 135, 160)
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 11
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.Parent = body

local sliderVal = Instance.new("TextLabel")
sliderVal.Size = UDim2.new(0.4, -12, 0, 14)
sliderVal.Position = UDim2.new(0.6, 0, 0, 44)
sliderVal.BackgroundTransparency = 1
sliderVal.Text = tostring(sprintSpeed)
sliderVal.TextColor3 = Color3.fromRGB(63, 216, 122)
sliderVal.Font = Enum.Font.GothamBold
sliderVal.TextSize = 11
sliderVal.TextXAlignment = Enum.TextXAlignment.Right
sliderVal.Parent = body

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(1, -24, 0, 8)
barBg.Position = UDim2.new(0, 12, 0, 62)
barBg.BackgroundColor3 = Color3.fromRGB(30, 33, 48)
barBg.BorderSizePixel = 0
barBg.Parent = body
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new((sprintSpeed - 16) / 84, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(63, 216, 122)
barFill.BorderSizePixel = 0
barFill.Parent = barBg
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

local keyHint = Instance.new("TextLabel")
keyHint.Size = UDim2.new(1, -24, 0, 14)
keyHint.Position = UDim2.new(0, 12, 0, 78)
keyHint.BackgroundTransparency = 1
keyHint.Text = "Hold [L-Ctrl] or use sprint button"
keyHint.TextColor3 = Color3.fromRGB(80, 85, 110)
keyHint.Font = Enum.Font.Gotham
keyHint.TextSize = 10
keyHint.TextXAlignment = Enum.TextXAlignment.Left
keyHint.Parent = body

-- Lock button
local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.new(1, -24, 0, 28)
lockBtn.Position = UDim2.new(0, 12, 0, 94)
lockBtn.BackgroundColor3 = Color3.fromRGB(30, 33, 48)
lockBtn.BorderSizePixel = 0
lockBtn.Text = "🔓 Sprint Button: Unlocked (drag to move)"
lockBtn.TextColor3 = Color3.fromRGB(130, 135, 160)
lockBtn.Font = Enum.Font.Gotham
lockBtn.TextSize = 10
lockBtn.Parent = body
Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 6)

-- Slider drag
local draggingSlider = false
barBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local relX = math.clamp(input.Position.X - barBg.AbsolutePosition.X, 0, barBg.AbsoluteSize.X)
        local pct = relX / barBg.AbsoluteSize.X
        sprintSpeed = math.floor(16 + pct * 84)
        barFill.Size = UDim2.new(pct, 0, 1, 0)
        sliderVal.Text = tostring(sprintSpeed)
        if sprinting then setSpeed(sprintSpeed) end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)

-- Minimize
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
    if minimized then
        TweenService:Create(main, info, {Size = UDim2.new(0, 220, 0, 36)}):Play()
        TweenService:Create(body, info, {Size = UDim2.new(1, 0, 0, 0)}):Play()
        minBtn.Text = "+"
    else
        TweenService:Create(main, info, {Size = UDim2.new(0, 220, 0, 160)}):Play()
        TweenService:Create(body, info, {Size = UDim2.new(1, 0, 0, 124)}):Play()
        minBtn.Text = "—"
    end
end)

-- Panel drag
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- UPDATE GUI
local function updateGUI(isSprinting)
    if isSprinting then
        TweenService:Create(statusDot, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(63, 216, 122)}):Play()
        statusText.TextColor3 = Color3.fromRGB(63, 216, 122)
        statusText.Text = "Sprinting"
    else
        TweenService:Create(statusDot, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(224, 85, 85)}):Play()
        statusText.TextColor3 = Color3.fromRGB(224, 85, 85)
        statusText.Text = "Walking"
    end
end

-- MOVABLE SPRINT BUTTON
local sprintBtn = Instance.new("TextButton")
sprintBtn.Size = UDim2.new(0, 80, 0, 80)
sprintBtn.Position = UDim2.new(1, -100, 1, -100)
sprintBtn.AnchorPoint = Vector2.new(0.5, 0.5)
sprintBtn.BackgroundColor3 = Color3.fromRGB(26, 29, 38)
sprintBtn.BorderSizePixel = 0
sprintBtn.Text = "🏃"
sprintBtn.TextSize = 30
sprintBtn.Font = Enum.Font.GothamBold
sprintBtn.Parent = screenGui
Instance.new("UICorner", sprintBtn).CornerRadius = UDim.new(1, 0)

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(63, 216, 122)
btnStroke.Thickness = 2
btnStroke.Parent = sprintBtn

-- Sprint button drag
local btnDragging, btnDragStart, btnStartPos = false, nil, nil

sprintBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not buttonLocked then
            btnDragging = true
            btnDragStart = input.Position
            btnStartPos = sprintBtn.Position
        else
            -- Locked = sprint on hold
            sprinting = true
            setSpeed(sprintSpeed)
            updateGUI(true)
            TweenService:Create(sprintBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(26, 58, 40)}):Play()
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - btnDragStart
        sprintBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + d.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + d.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if btnDragging then
            btnDragging = false
        elseif buttonLocked and sprinting then
            sprinting = false
            setSpeed(walkSpeed)
            updateGUI(false)
            TweenService:Create(sprintBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(26, 29, 38)}):Play()
        end
    end
end)

-- Lock toggle
lockBtn.MouseButton1Click:Connect(function()
    buttonLocked = not buttonLocked
    if buttonLocked then
        lockBtn.Text = "🔒 Sprint Button: Locked (hold to sprint)"
        lockBtn.TextColor3 = Color3.fromRGB(63, 216, 122)
        btnStroke.Color = Color3.fromRGB(224, 85, 85)
    else
        lockBtn.Text = "🔓 Sprint Button: Unlocked (drag to move)"
        lockBtn.TextColor3 = Color3.fromRGB(130, 135, 160)
        btnStroke.Color = Color3.fromRGB(63, 216, 122)
    end
end)

-- Keyboard sprint
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

print("Sprint Pro loaded!")
