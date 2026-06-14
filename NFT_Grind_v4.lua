-- ╔══════════════════════════════════════════════════════╗
-- ║        NFT BATTLE · GRIND PANEL  v4.0               ║
-- ║  Виправлено: спини, авто-продаж, авто-фаворит        ║
-- ╚══════════════════════════════════════════════════════╝

local Players     = game:GetService("Players")
local RS          = game:GetService("ReplicatedStorage")
local UIS         = game:GetService("UserInputService")
local TweenSvc    = game:GetService("TweenService")

local Player      = Players.LocalPlayer
local Events      = RS:FindFirstChild("Events")

if not Events then warn("[NFT Grind] Events не знайдено!") return end

-- ════════════════════ СТАН ════════════════════
local state = {
    autoSell      = false,
    autoFavorite  = false,
    favoriteNFT   = "",
    selectedCase  = "Grind",
    caseAmount    = 10,
    grinding      = false,
    grindTask     = nil,
    spinning      = false,
    activeTab     = 1,
}

-- ════════════════════ ДАНІ НГ КЕЙСІВ ════════════════════
local NG_CASES = {
    { name = "Festive",    price = 50,   img = "rbxassetid://96220025786883"  },
    { name = "Santa",      price = 500,  img = "rbxassetid://76467479616057"  },
    { name = "Reindeer",   price = 2000, img = "rbxassetid://127222842721638" },
    { name = "XMAS Night", price = 5000, img = "rbxassetid://110966046941659" },
}

-- ════════════════════ КЕЙСИ З ГРИ ════════════════════
local function getAllCases()
    local cases = {}
    local info = RS:FindFirstChild("Info")
    if info then
        local ok, data = pcall(require, info)
        if ok and type(data) == "table" and data.Cases then
            for name, cd in pairs(data.Cases) do
                local cur = cd.TON and "TON" or (cd.GEMS and "Gems") or "Stars"
                table.insert(cases, { name = name, price = cd.Price or 0, img = cd.Image or "", currency = cur })
            end
        end
    end
    if #cases == 0 then
        cases = {
            { name = "Grind",        price = 0,      img = "rbxassetid://101776060157655", currency = "Free"  },
            { name = "Beggar",       price = 215,    img = "rbxassetid://119805709657909", currency = "Stars" },
            { name = "Rift",         price = 475,    img = "rbxassetid://127537031127164", currency = "Stars" },
            { name = "Office Clerk", price = 1105,   img = "rbxassetid://122325130255701", currency = "Stars" },
            { name = "Oligarch",     price = 2495,   img = "rbxassetid://138707786740365", currency = "Stars" },
            { name = "Palm",         price = 6450,   img = "rbxassetid://88410837782121",  currency = "Stars" },
            { name = "Marina",       price = 15885,  img = "rbxassetid://123586198915483", currency = "Stars" },
            { name = "Burj",         price = 38725,  img = "rbxassetid://100271668658472", currency = "Stars" },
            { name = "Radioactive",  price = 149999, img = "rbxassetid://92210039442526",  currency = "Stars" },
            { name = "Death Note",   price = 800,    img = "rbxassetid://133780991441928", currency = "TON"   },
            { name = "Pixel World",  price = 100,    img = "rbxassetid://103971302798182", currency = "TON"   },
        }
    end
    table.sort(cases, function(a, b) return a.price < b.price end)
    return cases
end

-- ════════════════════ ПАЛІТРА ════════════════════
local C = {
    bg        = Color3.fromRGB(12,  14,  26 ),  -- фон панелі
    surface   = Color3.fromRGB(22,  25,  45 ),  -- картки
    surfaceHi = Color3.fromRGB(32,  36,  62 ),  -- рядки списку
    accent    = Color3.fromRGB(94,  163, 255),  -- синій акцент
    accentDim = Color3.fromRGB(50,  90,  160),
    gold      = Color3.fromRGB(255, 195, 80 ),
    green     = Color3.fromRGB(60,  210, 110),
    greenDim  = Color3.fromRGB(30,  90,  50 ),
    red       = Color3.fromRGB(235, 70,  70 ),
    redDim    = Color3.fromRGB(90,  30,  30 ),
    amber     = Color3.fromRGB(255, 150, 40 ),
    text      = Color3.fromRGB(230, 235, 255),
    textDim   = Color3.fromRGB(140, 150, 180),
    snow      = Color3.fromRGB(160, 210, 255),
    border    = Color3.fromRGB(55,  65,  110),
    header    = Color3.fromRGB(16,  18,  36 ),
}

-- ════════════════════ ХЕЛПЕРИ ════════════════════
local function corner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, r or 10)
end
local function stroke(p, col, thick)
    local s = Instance.new("UIStroke", p)
    s.Color = col or C.border
    s.Thickness = thick or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end
local function label(parent, props)
    local l = Instance.new("TextLabel", parent)
    l.BackgroundTransparency = 1
    l.TextXAlignment = props.align or Enum.TextXAlignment.Left
    l.Font = props.bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.TextSize = props.size or 12
    l.TextColor3 = props.color or C.text
    l.Text = props.text or ""
    l.Size = props.sz or UDim2.new(1, 0, 1, 0)
    l.Position = props.pos or UDim2.new(0, 0, 0, 0)
    l.TextTruncate = Enum.TextTruncate.AtEnd
    return l
end
local function btn(parent, props)
    local b = Instance.new("TextButton", parent)
    b.BackgroundColor3 = props.bg or C.accent
    b.TextColor3 = props.fg or C.text
    b.Font = Enum.Font.GothamBold
    b.TextSize = props.size or 13
    b.Text = props.text or ""
    b.Size = props.sz or UDim2.new(1, 0, 0, 36)
    b.Position = props.pos or UDim2.new(0, 0, 0, 0)
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    corner(b, props.r or 8)
    return b
end
local function frame(parent, props)
    local f = Instance.new("Frame", parent)
    f.BackgroundColor3 = props.bg or C.surface
    f.BorderSizePixel = 0
    f.Size = props.sz or UDim2.new(1, 0, 0, 40)
    f.Position = props.pos or UDim2.new(0, 0, 0, 0)
    if props.corner ~= false then corner(f, props.r or 10) end
    return f
end
local function tween(obj, goal, t)
    TweenSvc:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad), goal):Play()
end
local function hoverBtn(b, normal, hi)
    b.MouseEnter:Connect(function() tween(b, { BackgroundColor3 = hi }) end)
    b.MouseLeave:Connect(function() tween(b, { BackgroundColor3 = normal }) end)
end

-- ════════════════════ ROOT GUI ════════════════════
local gui = Instance.new("ScreenGui")
gui.Name = "NFT_Grind_v4"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = Player:WaitForChild("PlayerGui")

-- Тінь під панеллю
local shadow = Instance.new("Frame", gui)
shadow.Size = UDim2.new(0, 360, 0, 540)
shadow.Position = UDim2.new(0.5, -176, 0.5, -264)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
corner(shadow, 16)

local main = frame(gui, {
    bg  = C.bg,
    sz  = UDim2.new(0, 360, 0, 540),
    pos = UDim2.new(0.5, -180, 0.5, -270),
    r   = 14,
})
stroke(main, C.border, 1.5)

-- ════════════════════ HEADER ════════════════════
local header = frame(main, {
    bg  = C.header,
    sz  = UDim2.new(1, 0, 0, 52),
    pos = UDim2.new(0, 0, 0, 0),
    r   = 14,
})
-- Закрити нижні кути хедера
local headerFix = frame(header, { bg = C.header, sz = UDim2.new(1, 0, 0, 14), pos = UDim2.new(0, 0, 1, -14), corner = false })

-- Логотип / назва
local dot = frame(header, { bg = C.accent, sz = UDim2.new(0, 4, 0, 28), pos = UDim2.new(0, 16, 0, 12), r = 2 })
label(header, {
    text  = "NFT BATTLE",
    bold  = true,
    size  = 15,
    color = C.text,
    sz    = UDim2.new(0, 200, 0, 26),
    pos   = UDim2.new(0, 28, 0, 13),
})
label(header, {
    text  = "GRIND PANEL v4.0",
    size  = 10,
    color = C.accent,
    sz    = UDim2.new(0, 200, 0, 16),
    pos   = UDim2.new(0, 28, 0, 33),
})

local closeB = btn(header, {
    text = "✕",
    bg   = C.redDim,
    sz   = UDim2.new(0, 28, 0, 28),
    pos  = UDim2.new(1, -40, 0, 12),
    size = 14,
    r    = 7,
})
hoverBtn(closeB, C.redDim, C.red)
closeB.MouseButton1Click:Connect(function() gui:Destroy() end)

-- ════════════════════ TAB BAR ════════════════════
local tabBar = frame(main, {
    bg  = C.header,
    sz  = UDim2.new(1, 0, 0, 38),
    pos = UDim2.new(0, 0, 0, 52),
    corner = false,
})

local function makeTab(text, xPos)
    local t = btn(tabBar, {
        text = text,
        bg   = Color3.fromRGB(0,0,0,0),
        fg   = C.textDim,
        sz   = UDim2.new(0.5, 0, 1, 0),
        pos  = UDim2.new(xPos, 0, 0, 0),
        size = 12,
        r    = 0,
    })
    t.BackgroundTransparency = 1
    return t
end
local tab1Btn = makeTab("🎄  НГ КЕЙСИ", 0)
local tab2Btn = makeTab("📦  ВСІ КЕЙСИ", 0.5)

-- Індикаторна смужка під активним табом
local tabLine = frame(tabBar, { bg = C.accent, sz = UDim2.new(0.5, -20, 0, 2), pos = UDim2.new(0, 10, 1, -2), corner = false })

-- Роздільник між хедером і контентом
local divider = frame(main, { bg = C.border, sz = UDim2.new(1, 0, 0, 1), pos = UDim2.new(0, 0, 0, 90), corner = false })

-- ════════════════════ SCROLL CONTAINER ════════════════════
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, 0, 1, -92)
scroll.Position = UDim2.new(0, 0, 0, 92)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = C.accent
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

-- ══════════════════════════════════════
-- ████  ВКЛ. 1: НГ КЕЙСИ  ████
-- ══════════════════════════════════════
local ngPage = Instance.new("Frame", scroll)
ngPage.Size = UDim2.new(1, 0, 0, 440)
ngPage.BackgroundTransparency = 1

-- Блок балансів
local balanceRow = frame(ngPage, {
    bg  = C.surface,
    sz  = UDim2.new(1, -24, 0, 52),
    pos = UDim2.new(0, 12, 0, 12),
})
stroke(balanceRow, C.border)

-- Сніжинки
local snowBox = frame(balanceRow, {
    bg  = Color3.fromRGB(20, 35, 60),
    sz  = UDim2.new(0.5, -8, 1, -12),
    pos = UDim2.new(0, 6, 0, 6),
    r   = 8,
})
label(snowBox, { text = "❄️", size = 20, align = Enum.TextXAlignment.Center, sz = UDim2.new(0, 36, 1, 0), pos = UDim2.new(0, 2, 0, 0) })
local snowLbl = label(snowBox, {
    text  = "0  сніжинок",
    bold  = true,
    size  = 11,
    color = C.snow,
    sz    = UDim2.new(1, -42, 1, 0),
    pos   = UDim2.new(0, 40, 0, 0),
})

-- Спини
local spinBox = frame(balanceRow, {
    bg  = Color3.fromRGB(40, 28, 14),
    sz  = UDim2.new(0.5, -8, 1, -12),
    pos = UDim2.new(0.5, 2, 0, 6),
    r   = 8,
})
label(spinBox, { text = "🎰", size = 20, align = Enum.TextXAlignment.Center, sz = UDim2.new(0, 36, 1, 0), pos = UDim2.new(0, 2, 0, 0) })
local spinLbl = label(spinBox, {
    text  = "0  спинів",
    bold  = true,
    size  = 11,
    color = C.gold,
    sz    = UDim2.new(1, -42, 1, 0),
    pos   = UDim2.new(0, 40, 0, 0),
})

-- Кнопка крутити спини
local spinBtn = btn(ngPage, {
    text = "🎰  ПРОКРУТИТИ ВСІ СПИНИ",
    bg   = C.amber,
    fg   = Color3.fromRGB(20, 10, 0),
    sz   = UDim2.new(1, -24, 0, 40),
    pos  = UDim2.new(0, 12, 0, 72),
    size = 13,
    r    = 10,
})
hoverBtn(spinBtn, C.amber, Color3.fromRGB(255, 170, 60))

-- Секція «Новорічні кейси»
label(ngPage, {
    text  = "НОВОРІЧНІ КЕЙСИ",
    bold  = true,
    size  = 10,
    color = C.textDim,
    sz    = UDim2.new(1, -24, 0, 18),
    pos   = UDim2.new(0, 12, 0, 124),
    align = Enum.TextXAlignment.Left,
})

local NG_START_Y = 146
local caseCheckboxes = {}

for i, cd in ipairs(NG_CASES) do
    local col = (i - 1) % 2
    local row = math.floor((i - 1) / 2)
    local card = btn(ngPage, {
        text = "",
        bg   = C.surface,
        sz   = UDim2.new(0.5, -18, 0, 80),
        pos  = UDim2.new(col * 0.5, col == 0 and 12 or 6, 0, NG_START_Y + row * 90),
        r    = 10,
    })
    stroke(card, C.border)

    -- Зображення
    local img = Instance.new("ImageLabel", card)
    img.Size = UDim2.new(0, 56, 0, 56)
    img.Position = UDim2.new(0, 8, 0, 12)
    img.Image = cd.img
    img.BackgroundColor3 = Color3.fromRGB(18, 18, 35)
    img.BorderSizePixel = 0
    corner(img, 8)

    label(card, { text = cd.name, bold = true, size = 11, color = C.text,
        sz = UDim2.new(1, -74, 0, 18), pos = UDim2.new(0, 70, 0, 14) })
    label(card, { text = "❄️ " .. cd.price, size = 10, color = C.gold,
        sz = UDim2.new(1, -74, 0, 16), pos = UDim2.new(0, 70, 0, 34) })

    local openB = btn(card, {
        text = "ВІДКРИТИ",
        bg   = C.accentDim,
        sz   = UDim2.new(1, -74, 0, 22),
        pos  = UDim2.new(0, 70, 0, 52),
        size = 10,
        r    = 6,
    })
    hoverBtn(openB, C.accentDim, C.accent)
    openB.MouseButton1Click:Connect(function()
        pcall(function()
            if Events:FindFirstChild("GUI") then
                Events.GUI:Fire("CasePage", cd.name)
            end
        end)
    end)
end

-- ══════════════════════════════════════
-- ████  ВКЛ. 2: ВСІ КЕЙСИ  ████
-- ══════════════════════════════════════
local allCasesData = getAllCases()

local casePage = Instance.new("Frame", scroll)
casePage.Size = UDim2.new(1, 0, 0, 550)
casePage.BackgroundTransparency = 1
casePage.Visible = false

-- Виділений кейс
local selBlock = frame(casePage, {
    bg  = C.surface,
    sz  = UDim2.new(1, -24, 0, 44),
    pos = UDim2.new(0, 12, 0, 12),
})
stroke(selBlock, C.border)
label(selBlock, { text = "Обраний кейс", size = 10, color = C.textDim,
    sz = UDim2.new(0, 110, 1, 0), pos = UDim2.new(0, 12, 0, 0) })
local selNameLbl = label(selBlock, {
    text = state.selectedCase, bold = true, size = 13, color = C.accent,
    sz = UDim2.new(1, -130, 1, 0), pos = UDim2.new(0, 120, 0, 0),
})

-- Кількість
local amtBlock = frame(casePage, {
    bg  = C.surface,
    sz  = UDim2.new(1, -24, 0, 44),
    pos = UDim2.new(0, 12, 0, 64),
})
stroke(amtBlock, C.border)
label(amtBlock, { text = "Кількість за раз", size = 10, color = C.textDim,
    sz = UDim2.new(0, 140, 1, 0), pos = UDim2.new(0, 12, 0, 0) })

local amtBox = Instance.new("TextBox", amtBlock)
amtBox.Size = UDim2.new(0, 70, 0, 28)
amtBox.Position = UDim2.new(1, -84, 0, 8)
amtBox.Text = "10"
amtBox.Font = Enum.Font.GothamBold
amtBox.TextSize = 13
amtBox.TextColor3 = C.text
amtBox.BackgroundColor3 = C.surfaceHi
amtBox.BorderSizePixel = 0
amtBox.TextXAlignment = Enum.TextXAlignment.Center
corner(amtBox, 7)
stroke(amtBox, C.border)
amtBox:GetPropertyChangedSignal("Text"):Connect(function()
    local n = tonumber(amtBox.Text)
    state.caseAmount = (n and n > 0) and math.floor(n) or 10
end)

-- Авто налаштування
local autoBlock = frame(casePage, {
    bg  = C.surface,
    sz  = UDim2.new(1, -24, 0, 100),
    pos = UDim2.new(0, 12, 0, 116),
})
stroke(autoBlock, C.border)

label(autoBlock, { text = "АВТО-РЕЖИМ", bold = true, size = 10, color = C.textDim,
    sz = UDim2.new(1, -20, 0, 22), pos = UDim2.new(0, 12, 0, 2) })

local function toggleBtn(parent, textOff, textOn, offBg, onBg, posX, posY)
    local b = btn(parent, {
        text = textOff,
        bg   = offBg,
        fg   = C.text,
        sz   = UDim2.new(0.5, -14, 0, 30),
        pos  = UDim2.new(posX, posX == 0 and 10 or 4, 0, posY),
        size = 10,
        r    = 8,
    })
    local on = false
    b.MouseButton1Click:Connect(function()
        on = not on
        tween(b, { BackgroundColor3 = on and onBg or offBg })
        b.Text = on and textOn or textOff
    end)
    return b, function() return on end
end

local autoSellBtn, getAutoSell = toggleBtn(autoBlock,
    "🛒 АВТО-ПРОДАЖ: ВИКЛ", "🛒 АВТО-ПРОДАЖ: ВКЛ",
    C.redDim, C.greenDim, 0, 26)
local autoFavBtn, getAutoFav = toggleBtn(autoBlock,
    "⭐ АВТО-ФАВОРИТ: ВИКЛ", "⭐ АВТО-ФАВОРИТ: ВКЛ",
    Color3.fromRGB(60, 45, 10), Color3.fromRGB(80, 60, 0), 0.5, 26)

-- Зв'язуємо з state
autoSellBtn.MouseButton1Click:Connect(function() state.autoSell = getAutoSell() end)
autoFavBtn.MouseButton1Click:Connect(function() state.autoFavorite = getAutoFav() end)

local favInput = Instance.new("TextBox", autoBlock)
favInput.Size = UDim2.new(1, -20, 0, 28)
favInput.Position = UDim2.new(0, 10, 0, 62)
favInput.PlaceholderText = "⭐  Назва NFT для авто-фавориту"
favInput.Text = ""
favInput.Font = Enum.Font.Gotham
favInput.TextSize = 11
favInput.TextColor3 = C.text
favInput.PlaceholderColor3 = C.textDim
favInput.BackgroundColor3 = C.surfaceHi
favInput.BorderSizePixel = 0
favInput.ClearTextOnFocus = false
corner(favInput, 7)
stroke(favInput, C.border)
favInput:GetPropertyChangedSignal("Text"):Connect(function() state.favoriteNFT = favInput.Text end)

-- Кнопка СТАРТ / СТОП
local startBtn = btn(casePage, {
    text = "▶  ПОЧАТИ ГРИНД",
    bg   = C.green,
    fg   = Color3.fromRGB(5, 20, 10),
    sz   = UDim2.new(1, -24, 0, 46),
    pos  = UDim2.new(0, 12, 0, 228),
    size = 15,
    r    = 12,
})
stroke(startBtn, Color3.fromRGB(40, 140, 70), 1.5)

-- Список кейсів
label(casePage, {
    text  = "ВИБРАТИ КЕЙС",
    bold  = true,
    size  = 10,
    color = C.textDim,
    sz    = UDim2.new(1, -24, 0, 18),
    pos   = UDim2.new(0, 12, 0, 286),
})

local caseScroll = Instance.new("ScrollingFrame", casePage)
caseScroll.Size = UDim2.new(1, -24, 0, 200)
caseScroll.Position = UDim2.new(0, 12, 0, 308)
caseScroll.BackgroundColor3 = C.surface
caseScroll.BorderSizePixel = 0
caseScroll.ScrollBarThickness = 3
caseScroll.ScrollBarImageColor3 = C.accent
caseScroll.CanvasSize = UDim2.new(0, 0, 0, #allCasesData * 46)
corner(caseScroll, 10)
stroke(caseScroll, C.border)

local currencyIcon = { TON = "💠", Gems = "💎", Free = "🎁", Stars = "⭐" }
local rowRefs = {}

for idx, cd in ipairs(allCasesData) do
    local row = frame(caseScroll, {
        bg  = C.surfaceHi,
        sz  = UDim2.new(1, -10, 0, 40),
        pos = UDim2.new(0, 5, 0, (idx - 1) * 46 + 3),
        r   = 8,
    })

    -- Зображення
    local img = Instance.new("ImageLabel", row)
    img.Size = UDim2.new(0, 32, 0, 32)
    img.Position = UDim2.new(0, 6, 0, 4)
    img.Image = cd.img ~= "" and cd.img or "rbxassetid://0"
    img.BackgroundColor3 = C.bg
    img.BorderSizePixel = 0
    corner(img, 6)

    label(row, { text = cd.name, bold = true, size = 11, color = C.text,
        sz = UDim2.new(0, 120, 1, 0), pos = UDim2.new(0, 46, 0, 0) })
    label(row, { text = (currencyIcon[cd.currency] or "⭐") .. " " .. cd.price, size = 10, color = C.gold,
        sz = UDim2.new(0, 90, 1, 0), pos = UDim2.new(0, 170, 0, 0) })

    -- Маркер вибору
    local dot = frame(row, {
        bg  = Color3.fromRGB(50, 50, 80),
        sz  = UDim2.new(0, 14, 0, 14),
        pos = UDim2.new(1, -22, 0, 13),
        r   = 7,
    })
    if cd.name == state.selectedCase then
        dot.BackgroundColor3 = C.accent
    end

    table.insert(rowRefs, { row = row, dot = dot, name = cd.name })

    row.InputBegan:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        state.selectedCase = cd.name
        selNameLbl.Text = cd.name
        for _, r in ipairs(rowRefs) do
            tween(r.dot, { BackgroundColor3 = r.name == cd.name and C.accent or Color3.fromRGB(50, 50, 80) })
        end
    end)
end
casePage.Size = UDim2.new(1, 0, 0, 520)

-- ════════════════════ ГРИНД ЛОГІКА ════════════════════
local function doGrind()
    while state.grinding do
        -- Відкриваємо кейси
        pcall(function()
            if Events:FindFirstChild("OpenCase") then
                Events.OpenCase:InvokeServer(state.selectedCase, state.caseAmount)
            end
        end)
        -- Авто-фаворит
        if state.autoFavorite and state.favoriteNFT ~= "" then
            local inv = Player:FindFirstChild("_Inventory")
            if inv then
                for _, item in pairs(inv:GetChildren()) do
                    if item.Name == state.favoriteNFT then
                        pcall(function()
                            if Events:FindFirstChild("Favorite") then
                                Events.Favorite:InvokeServer(item, true)
                            end
                        end)
                    end
                end
            end
        end
        -- Авто-продаж
        if state.autoSell then
            local inv = Player:FindFirstChild("_Inventory")
            if inv then
                for _, item in pairs(inv:GetChildren()) do
                    local isFav    = state.autoFavorite and state.favoriteNFT ~= "" and item.Name == state.favoriteNFT
                    local isUnique = item:GetAttribute("Unique") == true
                    if not isFav and not isUnique then
                        pcall(function()
                            if Events:FindFirstChild("Inventory") then
                                Events.Inventory:FireServer("Sell", item)
                            end
                        end)
                    end
                end
            end
        end
        task.wait(0.15)
    end
end

local function startGrind()
    if state.grinding then return end
    state.grinding = true
    tween(startBtn, { BackgroundColor3 = C.red })
    startBtn.Text = "⏹  ЗУПИНИТИ ГРИНД"
    state.grindTask = task.spawn(doGrind)
end

local function stopGrind()
    state.grinding = false
    if state.grindTask then task.cancel(state.grindTask) state.grindTask = nil end
    tween(startBtn, { BackgroundColor3 = C.green })
    startBtn.Text = "▶  ПОЧАТИ ГРИНД"
end

startBtn.MouseButton1Click:Connect(function()
    if state.grinding then stopGrind() else startGrind() end
end)

-- ════════════════════ НГ СПИНИ ════════════════════
local spinVal = Player:FindFirstChild("_ChristmasSpins")
local snowVal = Player:FindFirstChild("_SnowflakesValue")

local function updateBalances()
    if snowVal then snowLbl.Text = snowVal.Value .. "  сніжинок" end
    if spinVal then spinLbl.Text = spinVal.Value .. "  спинів" end
end
updateBalances()
if snowVal then snowVal.Changed:Connect(updateBalances) end
if spinVal then spinVal.Changed:Connect(updateBalances) end

spinBtn.MouseButton1Click:Connect(function()
    if state.spinning then return end
    state.spinning = true
    local total = spinVal and spinVal.Value or 0
    spinBtn.Text = "🌀  КРУЧУ (" .. total .. ")..."
    tween(spinBtn, { BackgroundColor3 = Color3.fromRGB(180, 120, 30) })
    for _ = 1, total do
        pcall(function()
            if Events:FindFirstChild("Christmas") then
                Events.Christmas:InvokeServer("Spin")
            else
                warn("[NFT Grind] Christmas event не знайдено")
            end
        end)
        updateBalances()
        task.wait(0.15)
    end
    spinBtn.Text = "✅  ГОТОВО"
    task.wait(1.2)
    tween(spinBtn, { BackgroundColor3 = C.amber })
    spinBtn.Text = "🎰  ПРОКРУТИТИ ВСІ СПИНИ"
    state.spinning = false
end)

-- ════════════════════ ПЕРЕКЛЮЧЕННЯ ТАБІВ ════════════════════
local function switchTab(idx)
    state.activeTab = idx
    ngPage.Visible   = idx == 1
    casePage.Visible = idx == 2
    scroll.CanvasSize = idx == 1
        and UDim2.new(0, 0, 0, 440)
        or  UDim2.new(0, 0, 0, 530)

    tween(tabLine, {
        Position = UDim2.new((idx - 1) * 0.5, 10, 1, -2),
        Size     = UDim2.new(0.5, -20, 0, 2),
    })
    tab1Btn.TextColor3 = idx == 1 and C.accent  or C.textDim
    tab2Btn.TextColor3 = idx == 2 and C.accent  or C.textDim
    tab1Btn.Font = idx == 1 and Enum.Font.GothamBold or Enum.Font.Gotham
    tab2Btn.Font = idx == 2 and Enum.Font.GothamBold or Enum.Font.Gotham
end

tab1Btn.MouseButton1Click:Connect(function() switchTab(1) end)
tab2Btn.MouseButton1Click:Connect(function() switchTab(2) end)
switchTab(1)

-- ════════════════════ DRAG ════════════════════
local dragging, dragStart, startPos = false, nil, nil
main.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging  = true
        dragStart = UIS:GetMouseLocation()
        startPos  = main.Position
    end
end)
UIS.InputChanged:Connect(function(inp)
    if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local d = UIS:GetMouseLocation() - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,  startPos.X.Offset  + d.X,
            startPos.Y.Scale,  startPos.Y.Offset  + d.Y
        )
        shadow.Position = UDim2.new(
            main.Position.X.Scale, main.Position.X.Offset + 4,
            main.Position.Y.Scale, main.Position.Y.Offset + 4
        )
    end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

print("✅ [NFT BATTLE GRIND v4.0] Завантажено")
print("  🎄 НГ спіни → Events.Christmas:InvokeServer('Spin')")
print("  📦 Відкриття → Events.OpenCase:InvokeServer(case, amount)")
print("  🛒 Продаж   → Events.Inventory:FireServer('Sell', item)")
print("  ⭐ Фаворит  → Events.Favorite:InvokeServer(item, true)")
