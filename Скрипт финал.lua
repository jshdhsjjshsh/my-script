local function ShowPasswordMenu()
    local player = game.Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Затемнение
    local blur = Instance.new("BlurEffect")
    blur.Parent = game:GetService("Lighting")
    blur.Size = 0
    
    spawn(function()
        for i = 0, 1, 0.05 do
            blur.Size = i * 12
            wait(0.02)
        end
    end)
    
    -- Окно пароля 500x300
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 500, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 15, 40)
    mainFrame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 25)
    corner.Parent = mainFrame
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 150))
    })
    gradient.Rotation = 45
    gradient.Parent = mainFrame
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Parent = mainFrame
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0.05, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ AUTHENTICATION ⚡"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    
    -- Надпись
    local label = Instance.new("TextLabel")
    label.Parent = mainFrame
    label.Size = UDim2.new(1, 0, 0, 30)
    label.Position = UDim2.new(0, 0, 0.25, 0)
    label.BackgroundTransparency = 1
    label.Text = "ENTER PASSWORD"
    label.TextColor3 = Color3.fromRGB(150, 150, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    
    -- Поле ввода
    local passBox = Instance.new("TextBox")
    passBox.Parent = mainFrame
    passBox.Size = UDim2.new(0.7, 0, 0, 45)
    passBox.Position = UDim2.new(0.15, 0, 0.38, 0)
    passBox.BackgroundColor3 = Color3.fromRGB(30, 25, 55)
    passBox.BorderColor3 = Color3.fromRGB(0, 255, 150)
    passBox.BorderSizePixel = 2
    passBox.Font = Enum.Font.Gotham
    passBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    passBox.TextSize = 16
    passBox.PlaceholderText = "••••••••"
    
    local passCorner = Instance.new("UICorner")
    passCorner.CornerRadius = UDim.new(0, 15)
    passCorner.Parent = passBox
    
    -- Кнопка
    local button = Instance.new("TextButton")
    button.Parent = mainFrame
    button.Size = UDim2.new(0.4, 0, 0, 45)
    button.Position = UDim2.new(0.3, 0, 0.58, 0)
    button.Text = "UNLOCK"
    button.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    button.Font = Enum.Font.GothamBold
    button.TextColor3 = Color3.fromRGB(0
