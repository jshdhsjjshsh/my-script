local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local caseList = {
    "Trash", "Daily", "Photon Core", "Divine", "Beggar",
    "Plodder", "Office Clerk", "Manager", "Director", "Oligarch",
    "Frozen Heart", "Bubble Gum", "Cats", "Glitch", "Dream",
    "Bloody Night", "Heavenfall", "M5 F90", "G63", "Porsche 911",
    "URUS", "Gold", "Dark", "Palm", "Burj", "Luxury", "Marina", "Cursed Demon"
}

local state = {
    loggedIn = false,
    autoOpen = false,
    autoSell = false,
    selectedCase = "Trash",
    customCase = "",
    openAmount = 1
}

local function createNeonButton(parent, text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    button.BorderSizePixel = 0
    button.Position = position
    button.Size = size
    button.Font = Enum.Font.GothamBold
    button.TextSize = 18
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = button
    
    local glow = Instance.new("UICorner")
    glow.CornerRadius = UDim.new(0, 12)
    
    local function animateGlow()
        for i = 0, 100, 5 do
            task.wait(0.02)
            button.BackgroundColor3 = Color3.fromRGB(25 + i, 25 + i/2, 35 + i)
        end
        task.wait(0.1)
        for i = 100, 0, -5 do
            task.wait(0.02)
            button.BackgroundColor3 = Color3.fromRGB(25 + i, 25 + i/2, 35 + i)
        end
    end
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(80, 50, 150)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
    end)
    button.MouseButton1Click:Connect(function()
        animateGlow()
        if callback then callback() end
    end)
    
    return button
end

local function createCaseButton(parent, caseName, yPos, callback)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Text = caseName
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    button.BorderSizePixel = 0
    button.Position = UDim2.new(0.05, 0, yPos, 0)
    button.Size = UDim2.new(0, 200, 0, 35)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(200, 200, 255)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        if callback then callback(caseName) end
    end)
    
    return button
end

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Visible = false

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 20)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Parent = mainFrame
mainStroke.Color = Color3.fromRGB(100, 50, 200)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.5

local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Text = "NFT BATTLES | @Vezqx"
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 0, 0, 15)
title.Size = UDim2.new(1, 0, 0, 30)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(150, 100, 255)

local autoOpenBtn = createNeonButton(mainFrame, "🔓 AUTO OPEN: OFF", UDim2.new(0.1, 0, 0.2, 0), UDim2.new(0, 150, 0, 45), nil)
local autoSellBtn = createNeonButton(mainFrame, "💰 AUTO SELL: OFF", UDim2.new(0.55, 0, 0.2, 0), UDim2.new(0, 150, 0, 45), nil)

local caseLabel = Instance.new("TextLabel")
caseLabel.Parent = mainFrame
caseLabel.Text = "Selected: Trash"
caseLabel.BackgroundTransparency = 1
caseLabel.Position = UDim2.new(0.1, 0, 0.35, 0)
caseLabel.Size = UDim2.new(0, 300, 0, 25)
caseLabel.Font = Enum.Font.Gotham
caseLabel.TextSize = 14
caseLabel.TextColor3 = Color3.fromRGB(200, 200, 200)

local openAmountBox = Instance.new("TextBox")
openAmountBox.Parent = mainFrame
openAmountBox.Text = "1"
openAmountBox.PlaceholderText = "Cases per click"
openAmountBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
openAmountBox.BorderSizePixel = 0
openAmountBox.Position = UDim2.new(0.1, 0, 0.45, 0)
openAmountBox.Size = UDim2.new(0, 150, 0, 35)
openAmountBox.Font = Enum.Font.Gotham
openAmountBox.TextSize = 14
openAmountBox.TextColor3 = Color3.fromRGB(255, 255, 255)

local amountCorner = Instance.new("UICorner")
amountCorner.CornerRadius = UDim.new(0, 10)
amountCorner.Parent = openAmountBox

local customCaseBox = Instance.new("TextBox")
customCaseBox.Parent = mainFrame
customCaseBox.Text = ""
customCaseBox.PlaceholderText = "Custom case name"
customCaseBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
customCaseBox.BorderSizePixel = 0
customCaseBox.Position = UDim2.new(0.1, 0, 0.58, 0)
customCaseBox.Size = UDim2.new(0, 150, 0, 35)
customCaseBox.Font = Enum.Font.Gotham
customCaseBox.TextSize = 14
customCaseBox.TextColor3 = Color3.fromRGB(255, 255, 255)

local customCorner = Instance.new("UICorner")
customCorner.CornerRadius = UDim.new(0, 10)
customCorner.Parent = customCaseBox

local settingsBtn = createNeonButton(mainFrame, "⚙ SETTINGS", UDim2.new(0.1, 0, 0.72, 0), UDim2.new(0, 150, 0, 40), nil)
local casesBtn = createNeonButton(mainFrame, "📦 CASES", UDim2.new(0.55, 0, 0.72, 0), UDim2.new(0, 150, 0, 40), nil)

local casesFrame = Instance.new("ScrollingFrame")
casesFrame.Parent = screenGui
casesFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
casesFrame.BackgroundTransparency = 0.05
casesFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
casesFrame.Size = UDim2.new(0, 300, 0, 400)
casesFrame.Visible = false
casesFrame.ScrollBarThickness = 5
casesFrame.CanvasSize = UDim2.new(0, 0, 0, #caseList * 45 + 50)

local casesCorner = Instance.new("UICorner")
casesCorner.CornerRadius = UDim.new(0, 20)
casesCorner.Parent = casesFrame

local casesStroke = Instance.new("UIStroke")
casesStroke.Parent = casesFrame
casesStroke.Color = Color3.fromRGB(100, 50, 200)
casesStroke.Thickness = 2

local casesTitle = Instance.new("TextLabel")
casesTitle.Parent = casesFrame
casesTitle.Text = "SELECT CASE"
casesTitle.BackgroundTransparency = 1
casesTitle.Position = UDim2.new(0, 0, 0, 10)
casesTitle.Size = UDim2.new(1, 0, 0, 30)
casesTitle.Font = Enum.Font.GothamBold
casesTitle.TextSize = 18
casesTitle.TextColor3 = Color3.fromRGB(150, 100, 255)

local closeCasesBtn = createNeonButton(casesFrame, "✖ CLOSE", UDim2.new(0.65, 0, 0, 10), UDim2.new(0, 90, 0, 30), function()
    casesFrame.Visible = false
end)

for i, caseName in ipairs(caseList) do
    local yPos = 0.1 + (i-1) * 0.08
    createCaseButton(casesFrame, caseName, yPos, function(selected)
        state.selectedCase = selected
        caseLabel.Text = "Selected: " .. selected
        casesFrame.Visible = false
    end)
end

local settingsFrame = Instance.new("Frame")
settingsFrame.Parent = screenGui
settingsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
settingsFrame.BackgroundTransparency = 0.05
settingsFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
settingsFrame.Size = UDim2.new(0, 300, 0, 300)
settingsFrame.Visible = false

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 20)
settingsCorner.Parent = settingsFrame

local settingsStroke = Instance.new("UIStroke")
settingsStroke.Parent = settingsFrame
settingsStroke.Color = Color3.fromRGB(100, 50, 200)
settingsStroke.Thickness = 2

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Parent = settingsFrame
settingsTitle.Text = "SETTINGS"
settingsTitle.BackgroundTransparency = 1
settingsTitle.Position = UDim2.new(0, 0, 0, 10)
settingsTitle.Size = UDim2.new(1, 0, 0, 30)
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextSize = 18
settingsTitle.TextColor3 = Color3.fromRGB(150, 100, 255)

local amountLabel = Instance.new("TextLabel")
amountLabel.Parent = settingsFrame
amountLabel.Text = "Cases per open:"
amountLabel.BackgroundTransparency = 1
amountLabel.Position = UDim2.new(0.1, 0, 0.2, 0)
amountLabel.Size = UDim2.new(0, 200, 0, 25)
amountLabel.Font = Enum.Font.Gotham
amountLabel.TextSize = 14
amountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)

local amountSlider = Instance.new("TextBox")
amountSlider.Parent = settingsFrame
amountSlider.Text = "1"
amountSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
amountSlider.BorderSizePixel = 0
amountSlider.Position = UDim2.new(0.1, 0, 0.32, 0)
amountSlider.Size = UDim2.new(0, 80, 0, 35)
amountSlider.Font = Enum.Font.Gotham
amountSlider.TextSize = 14
amountSlider.TextColor3 = Color3.fromRGB(255, 255, 255)

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 10)
sliderCorner.Parent = amountSlider

local customLabel = Instance.new("TextLabel")
customLabel.Parent = settingsFrame
customLabel.Text = "Custom case name:"
customLabel.BackgroundTransparency = 1
customLabel.Position = UDim2.new(0.1, 0, 0.5, 0)
customLabel.Size = UDim2.new(0, 200, 0, 25)
customLabel.Font = Enum.Font.Gotham
customLabel.TextSize = 14
customLabel.TextColor3 = Color3.fromRGB(200, 200, 200)

local customSettingBox = Instance.new("TextBox")
customSettingBox.Parent = settingsFrame
customSettingBox.Text = ""
customSettingBox.PlaceholderText = "Enter custom case"
customSettingBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
customSettingBox.BorderSizePixel = 0
customSettingBox.Position = UDim2.new(0.1, 0, 0.62, 0)
customSettingBox.Size = UDim2.new(0, 240, 0, 35)
customSettingBox.Font = Enum.Font.Gotham
customSettingBox.TextSize = 14
customSettingBox.TextColor3 = Color3.fromRGB(255, 255, 255)

local customSettingCorner = Instance.new("UICorner")
customSettingCorner.CornerRadius = UDim.new(0, 10)
customSettingCorner.Parent = customSettingBox

local closeSettingsBtn = createNeonButton(settingsFrame, "SAVE & CLOSE", UDim2.new(0.2, 0, 0.82, 0), UDim2.new(0, 180, 0, 40), function()
    state.openAmount = tonumber(amountSlider.Text) or 1
    if state.openAmount < 1 then state.openAmount = 1 end
    if state.openAmount > 100 then state.openAmount = 100 end
    openAmountBox.Text = tostring(state.openAmount)
    state.customCase = customSettingBox.Text
    settingsFrame.Visible = false
end)

local loginFrame = Instance.new("Frame")
loginFrame.Parent = screenGui
loginFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
loginFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
loginFrame.Size = UDim2.new(0, 300, 0, 200)

local loginCorner = Instance.new("UICorner")
loginCorner.CornerRadius = UDim.new(0, 20)
loginCorner.Parent = loginFrame

local loginStroke = Instance.new("UIStroke")
loginStroke.Parent = loginFrame
loginStroke.Color = Color3.fromRGB(100, 50, 200)
loginStroke.Thickness = 2

local loginTitle = Instance.new("TextLabel")
loginTitle.Parent = loginFrame
loginTitle.Text = "🔐 LOGIN"
loginTitle.BackgroundTransparency = 1
loginTitle.Position = UDim2.new(0, 0, 0, 15)
loginTitle.Size = UDim2.new(1, 0, 0, 30)
loginTitle.Font = Enum.Font.GothamBold
loginTitle.TextSize = 22
loginTitle.TextColor3 = Color3.fromRGB(150, 100, 255)

local passwordBox = Instance.new("TextBox")
passwordBox.Parent = loginFrame
passwordBox.PlaceholderText = "Enter password"
passwordBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
passwordBox.BorderSizePixel = 0
passwordBox.Position = UDim2.new(0.1, 0, 0.35, 0)
passwordBox.Size = UDim2.new(0, 240, 0, 45)
passwordBox.Font = Enum.Font.Gotham
passwordBox.TextSize = 16
passwordBox.TextColor3 = Color3.fromRGB(255, 255, 255)
passwordBox.Text = ""

local passCorner = Instance.new("UICorner")
passCorner.CornerRadius = UDim.new(0, 12)
passCorner.Parent = passwordBox

local loginBtn = createNeonButton(loginFrame, "LOGIN", UDim2.new(0.25, 0, 0.7, 0), UDim2.new(0, 150, 0, 45), function()
    if passwordBox.Text == "mr.comcom" then
        state.loggedIn = true
        loginFrame.Visible = false
        mainFrame.Visible = true
    else
        passwordBox.Text = ""
        passwordBox.PlaceholderText = "Wrong password!"
        task.wait(1)
        passwordBox.PlaceholderText = "Enter password"
    end
end)

local dragDetector = Instance.new("UIDragDetector")
dragDetector.Parent = mainFrame

local dragDetectorCases = Instance.new("UIDragDetector")
dragDetectorCases.Parent = casesFrame

local dragDetectorSettings = Instance.new("UIDragDetector")
dragDetectorSettings.Parent = settingsFrame

autoOpenBtn.MouseButton1Click:Connect(function()
    state.autoOpen = not state.autoOpen
    autoOpenBtn.Text = state.autoOpen and "🔓 AUTO OPEN: ON" or "🔓 AUTO OPEN: OFF"
    autoOpenBtn.BackgroundColor3 = state.autoOpen and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(25, 25, 35)
end)

autoSellBtn.MouseButton1Click:Connect(function()
    state.autoSell = not state.autoSell
    autoSellBtn.Text = state.autoSell and "💰 AUTO SELL: ON" or "💰 AUTO SELL: OFF"
    autoSellBtn.BackgroundColor3 = state.autoSell and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(25, 25, 35)
end)

settingsBtn.MouseButton1Click:Connect(function()
    amountSlider.Text = tostring(state.openAmount)
    customSettingBox.Text = state.customCase
    settingsFrame.Visible = true
end)

casesBtn.MouseButton1Click:Connect(function()
    casesFrame.Visible = true
end)

openAmountBox:GetPropertyChangedSignal("Text"):Connect(function()
    local num = tonumber(openAmountBox.Text)
    if num then
        state.openAmount = math.clamp(num, 1, 100)
        openAmountBox.Text = tostring(state.openAmount)
    end
end)

task.spawn(function()
    while true do
        if state.loggedIn and (state.autoOpen or state.autoSell) then
            local caseToOpen = state.selectedCase
            if state.customCase ~= "" then
                caseToOpen = state.customCase
            end
            
            if state.autoOpen then
                for i = 1, state.openAmount do
                    local args = {caseToOpen, 1}
                    pcall(function()
                        ReplicatedStorage:WaitForChild("Events"):WaitForChild("OpenCase"):InvokeServer(unpack(args))
                    end)
                    task.wait(0.2)
                end
            end
            
            if state.autoSell then
                pcall(function()
                    ReplicatedStorage:WaitForChild("Events"):WaitForChild("Inventory"):FireServer("Sell", "ALL")
                end)
            end
            
            task.wait(1.5)
        else
            task.wait(0.5)
        end
    end
end)
