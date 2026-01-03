-- Platin Presents
-- crusty hub
-- light hub instant tp source
-- discord: platinv
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local WhitelistedUserIds = {
    8606003741,
    1395397712,
    97551868,
    8843649052,
    3736412416,
    9933701053,
    9321672816,
    1325278327,
    8014232861,
    8062324551,
    9132208479,
    9321672815,
    5524540927,
    5077624573,
    8977619242,
    8062324551,
    7505357425,
    7166614582,
}

local WhitelistedNames = {
    "Not_happy300",
    "Ara1s777",
    "Sudbdjixhvjcdidisc",
    "Zayonthat_2",
    "Frauheinrich0",
    "enzo_24042",
}

local function isWhitelisted(plr)
    for _, id in ipairs(WhitelistedUserIds) do
        if plr.UserId == id then
            return true
        end
    end

    for _, name in ipairs(WhitelistedNames) do
        if plr.Name:lower() == name:lower() 
        or plr.DisplayName:lower() == name:lower() then
            return true
        end
    end

    return false
end

if not isWhitelisted(player) then
    player:Kick("Not whitelisted")
end

local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local savedCFrame = nil
local tpEnabled = false
local godModeEnabled = false
local guiCollapsed = true -- start collapsed

-- ================= ANTI KICK =================
local function antiKick()
    for _, v in pairs(getconnections(player.Idled)) do
        v:Disable()
    end

    game:GetService("ScriptContext").Error:Connect(function() return end)

    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then
            return nil
        end
        return old(self, ...)
    end)
end
antiKick()

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "InstaStealHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 60) -- collapsed height
frame.Position = UDim2.new(0, 20, 0, 50) -- top-left, 50px down
frame.AnchorPoint = Vector2.new(0, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BorderSizePixel = 0
frame.Active = true -- draggable
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(200, 200, 200)
stroke.Thickness = 2
stroke.Parent = frame

-- ================= HEADER =================
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -60, 0, 28)
header.Position = UDim2.new(0, 10, 0, 8)
header.BackgroundTransparency = 1
header.Text = "KAHUB INSTANT STEAL"
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.TextColor3 = Color3.fromRGB(0, 0, 0)
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = frame

-- ================= TOGGLE BUTTON =================
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 26, 0, 26)
toggleBtn.Position = UDim2.new(1, -32, 0, 8)
toggleBtn.Text = "+"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = frame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

-- ================= BUTTON CREATOR =================
local function createButton(text, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -30, 0, 38)
    btn.Position = UDim2.new(0, 15, 0, y)
    btn.Text = text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.BorderSizePixel = 0
    btn.Visible = false
    btn.Parent = frame

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    end)

    return btn
end

-- ================= MAIN BUTTONS =================
local tpBtn = createButton("TP: OFF", 60)
local desyncBtn = createButton("DESYNC", 105)

-- Discord text
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 22)
info.Position = UDim2.new(0, 10, 1, -26)
info.BackgroundTransparency = 1
info.Text = "https://discord.gg/88CXEChM6Z"
info.Font = Enum.Font.GothamMedium
info.TextSize = 12
info.TextColor3 = Color3.fromRGB(120, 120, 120)
info.Visible = false
info.Parent = frame

-- ================= TOGGLE FUNCTION =================
toggleBtn.MouseButton1Click:Connect(function()
    guiCollapsed = not guiCollapsed
    toggleBtn.Text = guiCollapsed and "+" or "-"
    tpBtn.Visible = not guiCollapsed
    desyncBtn.Visible = not guiCollapsed
    info.Visible = not guiCollapsed

    local newHeight = guiCollapsed and 60 or 190
    frame:TweenSize(UDim2.new(0, 280, 0, newHeight), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
end)

-- ================= GOD MODE =================
local function activateGodMode()
    local function apply(character)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        humanoid.BreakJointsOnDeath = false
        humanoid.RequiresNeck = false

        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            humanoid.Health = humanoid.MaxHealth
        end)

        RunService.Heartbeat:Connect(function()
            humanoid.Health = humanoid.MaxHealth
        end)
    end

    apply(player.Character or player.CharacterAdded:Wait())
    player.CharacterAdded:Connect(function(char)
        task.wait(0.3)
        apply(char)
    end)
end

-- ================= TP BUTTON (Original Source Logic) =================
tpBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedCFrame = char.HumanoidRootPart.CFrame
    end
    tpEnabled = not tpEnabled
    tpBtn.Text = tpEnabled and "TP: ON" or "TP: OFF"
end)

-- ================= DESYNC =================
desyncBtn.MouseButton1Click:Connect(function()
    local flags = {
        {"GameNetPVHeaderRotationalVelocityZeroCutoffExponent", "-5000"},
        {"LargeReplicatorWrite5", "true"},
        {"LargeReplicatorEnabled9", "true"},
        {"AngularVelociryLimit", "360"},
        {"TimestepArbiterVelocityCriteriaThresholdTwoDt", "2147483646"},
        {"S2PhysicsSenderRate", "15000"},
        {"DisableDPIScale", "true"},
        {"MaxDataPacketPerSend", "2147483647"},
        {"ServerMaxBandwith", "52"},
        {"PhysicsSenderMaxBandwidthBps", "20000"},
        {"MaxTimestepMultiplierBuoyancy", "2147483647"},
        {"SimOwnedNOUCountThresholdMillionth", "2147483647"},
        {"MaxMissedWorldStepsRemembered", "-2147483648"},
        {"CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth", "1"},
        {"StreamJobNOUVolumeLengthCap", "2147483647"},
        {"DebugSendDistInSteps", "-2147483648"},
        {"MaxTimestepMultiplierAcceleration", "2147483647"},
        {"LargeReplicatorRead5", "true"},
        {"SimExplicitlyCappedTimestepMultiplier", "2147483646"},
        {"GameNetDontSendRedundantNumTimes", "1"},
        {"CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent", "1"},
        {"CheckPVCachedRotVelThresholdPercent", "10"},
        {"LargeReplicatorSerializeRead3", "true"},
        {"ReplicationFocusNouExtentsSizeCutoffForPauseStuds", "2147483647"},
        {"NextGenReplicatorEnabledWrite4", "true"},
        {"CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth", "1"},
        {"GameNetDontSendRedundantDeltaPositionMillionth", "1"},
        {"InterpolationFrameVelocityThresholdMillionth", "5"},
        {"StreamJobNOUVolumeCap", "2147483647"},
        {"InterpolationFrameRotVelocityThresholdMillionth", "5"},
        {"WorldStepMax", "30"},
        {"TimestepArbiterHumanoidLinearVelThreshold", "1"},
        {"InterpolationFramePositionThresholdMillionth", "5"},
        {"TimestepArbiterHumanoidTurningVelThreshold", "1"},
        {"MaxTimestepMultiplierContstraint", "2147483647"},
        {"GameNetPVHeaderLinearVelocityZeroCutoffExponent", "-5000"},
        {"CheckPVCachedVelThresholdPercent", "10"},
        {"TimestepArbiterOmegaThou", "1073741823"},
        {"MaxAcceptableUpdateDelay", "1"},
        {"LargeReplicatorSerializeWrite4", "true"},
    }

    for _, data in ipairs(flags) do
        pcall(function()
            if setfflag then
                setfflag(data[1], data[2])
            end
        end)
    end

    local char = player.Character
    if not char then return end

    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Dead)
    end

    char:ClearAllChildren()
    local fakeModel = Instance.new("Model", workspace)
    player.Character = fakeModel
    task.wait()
    player.Character = char
    fakeModel:Destroy()
end)

-- ================= INSTANT STEAL TP =================
ProximityPromptService.PromptButtonHoldEnded:Connect(function(prompt, who)
    if who ~= player then return end
    if not tpEnabled or not savedCFrame then return end

    if prompt.Name == "Steal" or prompt.ActionText == "Steal" then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = savedCFrame
            if not godModeEnabled then
                godModeEnabled = true
                activateGodMode()
            end
        end
    end
end)

-- ================= DRAG =================
local dragging = false
local dragInput, mousePos, framePos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        frame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)
