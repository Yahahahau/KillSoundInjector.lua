--[[
    Script Name: KillSoundInjector.lua
    Description: ระบบควบคุมเสียงตอนผู้เล่นตาย
    - เปิด/ปิดเสียงตายแบบกำหนดเอง
    - ใส่ Sound ID ที่ต้องการได้
    - UI มินิมัลพร้อมเสียงคลิกและอนิเมชั่นเล็กๆ
    - ปุ่ม Toggle GUI ลอยมุมจอ เปิด/ปิดหน้าต่างควบคุมเสียงตาย
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

-- ตัวแปรสถานะ
local deathSoundEnabled = false
local customDeathSoundId = ""
local guiVisible = true

-- ฟังก์ชันสร้างเสียงคลิก
local function playClickSound(parent)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://452267918" -- เสียงคลิก
    sound.Volume = 0.6
    sound.Parent = parent
    sound:Play()
    game.Debris:AddItem(sound, 2)
end

-- สร้าง GUI หลัก
local function createMainGUI()
    if PlayerGui:FindFirstChild("DeathSoundGUI") then
        PlayerGui.DeathSoundGUI:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DeathSoundGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 240, 0, 120)
    frame.Position = UDim2.new(0, 20, 0, 200)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(0, 0)
    frame.Parent = screenGui
    frame.Name = "MainFrame"
    frame.BackgroundTransparency = 0.1
    frame.ClipsDescendants = true

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 12)
    uiCorner.Parent = frame

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "🔊 KillSoundInjector ☠️"
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = frame

    -- Toggle Button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.5, -10, 0, 30)
    toggleBtn.Position = UDim2.new(0, 10, 0, 45)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    toggleBtn.Font = Enum.Font.Gotham
    toggleBtn.TextSize = 14
    toggleBtn.Text = "🔇 Off"
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = frame

    local cornerToggle = Instance.new("UICorner")
    cornerToggle.CornerRadius = UDim.new(0, 8)
    cornerToggle.Parent = toggleBtn

    -- TextBox ใส่ Sound ID
    local soundInput = Instance.new("TextBox")
    soundInput.Size = UDim2.new(1, -20, 0, 30)
    soundInput.Position = UDim2.new(0, 10, 0, 85)
    soundInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    soundInput.TextColor3 = Color3.new(1,1,1)
    soundInput.Font = Enum.Font.Gotham
    soundInput.TextSize = 14
    soundInput.PlaceholderText = "Enter Sound ID..."
    soundInput.ClearTextOnFocus = false
    soundInput.Parent = frame

    local cornerInput = Instance.new("UICorner")
    cornerInput.CornerRadius = UDim.new(0, 8)
    cornerInput.Parent = soundInput

    -- ฟังก์ชันอัปเดตปุ่ม Toggle สี + ข้อความ พร้อมแอนิเมชั่น
    local function updateToggleButton()
        if deathSoundEnabled then
            toggleBtn.Text = "🔊 On"
            local tween = TweenService:Create(toggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 180, 50)})
            tween:Play()
        else
            toggleBtn.Text = "🔇 Off"
            local tween = TweenService:Create(toggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)})
            tween:Play()
        end
    end

    -- เชื่อมปุ่ม Toggle
    toggleBtn.MouseButton1Click:Connect(function()
        deathSoundEnabled = not deathSoundEnabled
        updateToggleButton()
        playClickSound(toggleBtn)
    end)

    -- ใส่ Sound ID เมื่อกด Enter
    soundInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local id = tonumber(soundInput.Text)
            if id then
                customDeathSoundId = "rbxassetid://" .. tostring(id)
                playClickSound(soundInput)
            else
                customDeathSoundId = ""
            end
        end
    end)

    updateToggleButton()

    return screenGui, frame
end

-- สร้างปุ่ม Toggle GUI ลอยมุมซ้ายบน
local function createToggleGUIButton(mainFrame)
    if PlayerGui:FindFirstChild("ToggleDeathSoundGUIBtn") then
        PlayerGui.ToggleDeathSoundGUIBtn:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ToggleDeathSoundGUIBtn"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 10)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = "🎵"
    btn.AutoButtonColor = false
    btn.Parent = screenGui

    local cornerBtn = Instance.new("UICorner")
    cornerBtn.CornerRadius = UDim.new(0, 10)
    cornerBtn.Parent = btn

    -- ฟังก์ชันแสดง/ซ่อน UI พร้อมอนิเมชั่น Fade
    local function fadeUI(show)
        local goal = {BackgroundTransparency = show and 0.1 or 1, TextTransparency = show and 0 or 1}
        -- Tween ทั้ง Main Frame + children ที่เป็น TextLabel/TextButton/TextBox
        local tweenInfo = TweenInfo.new(0.3)
        TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = goal.BackgroundTransparency}):Play()

        for _, obj in ipairs(mainFrame:GetChildren()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                TweenService:Create(obj, tweenInfo, {TextTransparency = goal.TextTransparency}):Play()
            end
        end
    end

    btn.MouseButton1Click:Connect(function()
        guiVisible = not guiVisible
        if guiVisible then
            mainFrame.Visible = true
            fadeUI(true)
        else
            fadeUI(false)
            wait(0.35)
            mainFrame.Visible = false
        end
        playClickSound(btn)
    end)

    return btn
end

-- ระบบเสียงตาย
local function setupDeathSoundForPlayer(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            if deathSoundEnabled and customDeathSoundId ~= "" and character.PrimaryPart then
                local sound = Instance.new("Sound")
                sound.SoundId = customDeathSoundId
                sound.Volume = 1
                sound.Parent = character.PrimaryPart
                sound:Play()
                game.Debris:AddItem(sound, 5)
            end
        end)
    end)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        humanoid.Died:Connect(function()
            if deathSoundEnabled and customDeathSoundId ~= "" and player.Character.PrimaryPart then
                local sound = Instance.new("Sound")
                sound.SoundId = customDeathSoundId
                sound.Volume = 1
                sound.Parent = player.Character.PrimaryPart
                sound:Play()
                game.Debris:AddItem(sound, 5)
            end
        end)
    end
end

-- ติดตั้งระบบให้ผู้เล่นทุกคน
for _, player in pairs(Players:GetPlayers()) do
    setupDeathSoundForPlayer(player)
end

Players.PlayerAdded:Connect(setupDeathSoundForPlayer)

-- เริ่มต้น
local gui, mainFrame = createMainGUI()
local toggleBtn = createToggleGUIButton(mainFrame)
