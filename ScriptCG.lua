-- Admin Code Executor GUI Completo com Botão de Abertura
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Verificar se já existe
if playerGui:FindFirstChild("AdminExecutor") then
    playerGui.AdminExecutor:Destroy()
end

-- Configurações salvas
local savedScripts = {}
local toggleKey = Enum.KeyCode.RightShift
local isGUIVisible = true

-- Criar a GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminExecutor"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Botão de abertura no canto superior esquerdo
local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.new(0, 40, 0, 40)
openButton.Position = UDim2.new(0, 10, 0, 10)
openButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
openButton.Text = "🔧"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextScaled = true
openButton.Font = Enum.Font.GothamBold
openButton.BorderSizePixel = 0
openButton.Visible = false -- Inicialmente invisível
openButton.Parent = screenGui

-- Bordas arredondadas para o botão de abertura
local openButtonCorner = Instance.new("UICorner")
openButtonCorner.CornerRadius = UDim.new(0, 10)
openButtonCorner.Parent = openButton

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 580)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -290)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Bordas arredondadas para o frame principal
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -80, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleLabel.Text = "🔧 Admin Code Executor Pro"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.BorderSizePixel = 0
titleLabel.Parent = mainFrame

-- Bordas arredondadas para o título
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

-- Botão de ocultar
local hideButton = Instance.new("TextButton")
hideButton.Name = "HideButton"
hideButton.Size = UDim2.new(0, 35, 0, 35)
hideButton.Position = UDim2.new(1, -85, 0, 7.5)
hideButton.BackgroundColor3 = Color3.fromRGB(100, 150, 200)
hideButton.Text = "–"
hideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hideButton.TextScaled = true
hideButton.Font = Enum.Font.GothamBold
hideButton.BorderSizePixel = 0
hideButton.Parent = mainFrame

local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0, 8)
hideCorner.Parent = hideButton

-- Botão de fechar
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -45, 0, 7.5)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Frame para abas
local tabFrame = Instance.new("Frame")
tabFrame.Name = "TabFrame"
tabFrame.Size = UDim2.new(1, -20, 0, 35)
tabFrame.Position = UDim2.new(0, 10, 0, 55)
tabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = mainFrame

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 8)
tabCorner.Parent = tabFrame

-- Botões das abas
local tabs = {"Executor", "Scripts Hub", "Salvos", "Config"}
local tabButtons = {}
local tabContents = {}

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = tabName .. "Tab"
    tabBtn.Size = UDim2.new(0.25, -2, 1, 0)
    tabBtn.Position = UDim2.new((i-1) * 0.25, 0, 0, 0)
    tabBtn.BackgroundColor3 = i == 1 and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(35, 35, 35)
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.TextScaled = true
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = tabFrame
    
    local tabBtnCorner = Instance.new("UICorner")
    tabBtnCorner.CornerRadius = UDim.new(0, 6)
    tabBtnCorner.Parent = tabBtn
    
    tabButtons[i] = tabBtn
end

-- Frame de conteúdo principal
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -100)
contentFrame.Position = UDim2.new(0, 10, 0, 95)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- ABA 1: EXECUTOR
local executorFrame = Instance.new("Frame")
executorFrame.Name = "ExecutorFrame"
executorFrame.Size = UDim2.new(1, 0, 1, 0)
executorFrame.BackgroundTransparency = 1
executorFrame.Parent = contentFrame

-- ScrollingFrame para o código
local codeScrollFrame = Instance.new("ScrollingFrame")
codeScrollFrame.Name = "CodeScrollFrame"
codeScrollFrame.Size = UDim2.new(1, 0, 1, -325)
codeScrollFrame.Position = UDim2.new(0, 0, 0, 0)
codeScrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
codeScrollFrame.BorderSizePixel = 0
codeScrollFrame.ScrollBarThickness = 8
codeScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
codeScrollFrame.Parent = executorFrame

local codeScrollCorner = Instance.new("UICorner")
codeScrollCorner.CornerRadius = UDim.new(0, 8)
codeScrollCorner.Parent = codeScrollFrame

-- TextBox para o código
local codeBox = Instance.new("TextBox")
codeBox.Name = "CodeBox"
codeBox.Size = UDim2.new(1, -20, 1, 0)
codeBox.Position = UDim2.new(0, 10, 0, 0)
codeBox.BackgroundTransparency = 1
codeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
codeBox.Text = "-- Cole seu código aqui ou use os botões abaixo\n-- Clique nos scripts famosos para executar automaticamente\n\nprint('Hello World!')"
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 14
codeBox.MultiLine = true
codeBox.ClearTextOnFocus = false
codeBox.Parent = codeScrollFrame

-- Ajustar tamanho do scroll baseado no texto
codeBox:GetPropertyChangedSignal("Text"):Connect(function()
    spawn(function()
        wait(0.1) -- Pequena espera para garantir que os elementos estão carregados
        
        if codeBox and codeBox.Parent and codeScrollFrame then
            local success, textBounds = pcall(function()
                return game:GetService("TextService"):GetTextSize(
                    codeBox.Text or "",
                    codeBox.TextSize or 14,
                    codeBox.Font or Enum.Font.Code,
                    Vector2.new(math.max(codeBox.AbsoluteSize.X, 100), math.huge)
                )
            end)
            
            if success and textBounds then
                local minHeight = math.max(codeScrollFrame.AbsoluteSize.Y, 100)
                local newHeight = math.max(textBounds.Y + 40, minHeight)
                
                codeBox.Size = UDim2.new(1, -20, 0, newHeight)
                codeScrollFrame.CanvasSize = UDim2.new(0, 0, 0, newHeight)
            end
        end
    end)
end)

-- Frame para os botões do executor
local buttonFrame = Instance.new("Frame")
buttonFrame.Name = "ButtonFrame"
buttonFrame.Size = UDim2.new(1, 0, 0, 70)
buttonFrame.Position = UDim2.new(0, 0, 1, -315)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = executorFrame

-- Botões do executor (mesmo código anterior)
local executeButton = Instance.new("TextButton")
executeButton.Name = "ExecuteButton"
executeButton.Size = UDim2.new(0, 120, 0, 35)
executeButton.Position = UDim2.new(0, 0, 0, 0)
executeButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
executeButton.Text = "▶ Executar"
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.TextScaled = true
executeButton.Font = Enum.Font.GothamBold
executeButton.BorderSizePixel = 0
executeButton.Parent = buttonFrame

local executeCorner = Instance.new("UICorner")
executeCorner.CornerRadius = UDim.new(0, 8)
executeCorner.Parent = executeButton

local clearButton = Instance.new("TextButton")
clearButton.Name = "ClearButton"
clearButton.Size = UDim2.new(0, 120, 0, 35)
clearButton.Position = UDim2.new(0, 130, 0, 0)
clearButton.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
clearButton.Text = "🗑 Limpar"
clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
clearButton.TextScaled = true
clearButton.Font = Enum.Font.GothamBold
clearButton.BorderSizePixel = 0
clearButton.Parent = buttonFrame

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 8)
clearCorner.Parent = clearButton

local saveButton = Instance.new("TextButton")
saveButton.Name = "SaveButton"
saveButton.Size = UDim2.new(0, 120, 0, 35)
saveButton.Position = UDim2.new(0, 260, 0, 0)
saveButton.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
saveButton.Text = "💾 Salvar"
saveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveButton.TextScaled = true
saveButton.Font = Enum.Font.GothamBold
saveButton.BorderSizePixel = 0
saveButton.Parent = buttonFrame

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 8)
saveCorner.Parent = saveButton

local injectButton = Instance.new("TextButton")
injectButton.Name = "InjectButton"
injectButton.Size = UDim2.new(0, 120, 0, 35)
injectButton.Position = UDim2.new(0, 390, 0, 0)
injectButton.BackgroundColor3 = Color3.fromRGB(150, 100, 200)
injectButton.Text = "💉 Require"
injectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
injectButton.TextScaled = true
injectButton.Font = Enum.Font.GothamBold
injectButton.BorderSizePixel = 0
injectButton.Parent = buttonFrame

local injectCorner = Instance.new("UICorner")
injectCorner.CornerRadius = UDim.new(0, 8)
injectCorner.Parent = injectButton

local requireBox = Instance.new("TextBox")
requireBox.Name = "RequireBox"
requireBox.Size = UDim2.new(0, 110, 0, 35)
requireBox.Position = UDim2.new(0, 520, 0, 0)
requireBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
requireBox.TextColor3 = Color3.fromRGB(255, 255, 255)
requireBox.Text = "72342"
requireBox.PlaceholderText = "ID"
requireBox.Font = Enum.Font.Gotham
requireBox.TextSize = 14
requireBox.BorderSizePixel = 0
requireBox.Parent = buttonFrame

local requireCorner = Instance.new("UICorner")
requireCorner.CornerRadius = UDim.new(0, 8)
requireCorner.Parent = requireBox

-- Segunda linha de botões para loadstring
local buttonFrame2 = Instance.new("Frame")
buttonFrame2.Name = "ButtonFrame2"
buttonFrame2.Size = UDim2.new(1, 0, 0, 45)
buttonFrame2.Position = UDim2.new(0, 0, 1, -200)
buttonFrame2.BackgroundTransparency = 1
buttonFrame2.Parent = executorFrame

-- Botão LoadString
local loadstringButton = Instance.new("TextButton")
loadstringButton.Name = "LoadstringButton"
loadstringButton.Size = UDim2.new(0, 120, 0, 35)
loadstringButton.Position = UDim2.new(0, 0, 0, 0)
loadstringButton.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
loadstringButton.Text = "🌐 LoadString"
loadstringButton.TextColor3 = Color3.fromRGB(255, 255, 255)
loadstringButton.TextScaled = true
loadstringButton.Font = Enum.Font.GothamBold
loadstringButton.BorderSizePixel = 0
loadstringButton.Parent = buttonFrame2

local loadstringCorner = Instance.new("UICorner")
loadstringCorner.CornerRadius = UDim.new(0, 8)
loadstringCorner.Parent = loadstringButton

-- TextBox para URL
local urlBox = Instance.new("TextBox")
urlBox.Name = "UrlBox"
urlBox.Size = UDim2.new(1, -130, 0, 35)
urlBox.Position = UDim2.new(0, 130, 0, 0)
urlBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
urlBox.TextColor3 = Color3.fromRGB(255, 255, 255)
urlBox.Text = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
urlBox.PlaceholderText = "Cole a URL do script aqui..."
urlBox.Font = Enum.Font.Code
urlBox.TextSize = 12
urlBox.BorderSizePixel = 0
urlBox.Parent = buttonFrame2

local urlCorner = Instance.new("UICorner")
urlCorner.CornerRadius = UDim.new(0, 8)
urlCorner.Parent = urlBox

-- Frame para scripts famosos no executor
local scriptsFrame = Instance.new("Frame")
scriptsFrame.Name = "ScriptsFrame"
scriptsFrame.Size = UDim2.new(1, 0, 0, 145)
scriptsFrame.Position = UDim2.new(0, 0, 1, -145)
scriptsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
scriptsFrame.BorderSizePixel = 0
scriptsFrame.Parent = executorFrame

local scriptsCorner = Instance.new("UICorner")
scriptsCorner.CornerRadius = UDim.new(0, 8)
scriptsCorner.Parent = scriptsFrame

local scriptsTitle = Instance.new("TextLabel")
scriptsTitle.Name = "ScriptsTitle"
scriptsTitle.Size = UDim2.new(1, 0, 0, 25)
scriptsTitle.Position = UDim2.new(0, 0, 0, 5)
scriptsTitle.BackgroundTransparency = 1
scriptsTitle.Text = "📜 Scripts Rápidos"
scriptsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
scriptsTitle.Font = Enum.Font.GothamBold
scriptsTitle.TextSize = 14
scriptsTitle.Parent = scriptsFrame

-- Scripts famosos atualizados
local quickScripts = {
    {name = "Carlllosviera", code = "require(3465).carlllosviera", color = Color3.fromRGB(255, 100, 100)},
    {name = "SweetBaby", code = "require(4859311019).sweetbaby", color = Color3.fromRGB(255, 150, 200)},
    {name = "Infinite Yield", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()", color = Color3.fromRGB(100, 255, 100)}
}

for i, script in ipairs(quickScripts) do
    local col = (i - 1) % 3
    local scriptBtn = Instance.new("TextButton")
    scriptBtn.Name = "QuickScript" .. i
    scriptBtn.Size = UDim2.new(0, 200, 0, 35)
    scriptBtn.Position = UDim2.new(0, 10 + (col * 210), 0, 35)
    scriptBtn.BackgroundColor3 = script.color
    scriptBtn.Text = script.name
    scriptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    scriptBtn.TextScaled = true
    scriptBtn.Font = Enum.Font.GothamBold
    scriptBtn.BorderSizePixel = 0
    scriptBtn.Parent = scriptsFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = scriptBtn
    
    scriptBtn.MouseButton1Click:Connect(function()
        codeBox.Text = script.code
        wait(0.5)
        executeCode()
    end)
end

-- ABA 2: SCRIPTS HUB
local hubFrame = Instance.new("Frame")
hubFrame.Name = "HubFrame"
hubFrame.Size = UDim2.new(1, 0, 1, 0)
hubFrame.BackgroundTransparency = 1
hubFrame.Visible = false
hubFrame.Parent = contentFrame

-- Barra de pesquisa
local searchFrame = Instance.new("Frame")
searchFrame.Size = UDim2.new(1, 0, 0, 40)
searchFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
searchFrame.BorderSizePixel = 0
searchFrame.Parent = hubFrame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 8)
searchCorner.Parent = searchFrame

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -60, 1, -10)
searchBox.Position = UDim2.new(0, 10, 0, 5)
searchBox.BackgroundTransparency = 1
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.PlaceholderText = "🔍 Pesquisar scripts..."
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
searchBox.Parent = searchFrame

local searchButton = Instance.new("TextButton")
searchButton.Size = UDim2.new(0, 40, 0, 30)
searchButton.Position = UDim2.new(1, -45, 0, 5)
searchButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
searchButton.Text = "🔍"
searchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
searchButton.TextScaled = true
searchButton.Font = Enum.Font.GothamBold
searchButton.BorderSizePixel = 0
searchButton.Parent = searchFrame

local searchBtnCorner = Instance.new("UICorner")
searchBtnCorner.CornerRadius = UDim.new(0, 6)
searchBtnCorner.Parent = searchButton

-- Lista de scripts do hub
local hubScrollFrame = Instance.new("ScrollingFrame")
hubScrollFrame.Size = UDim2.new(1, 0, 1, -50)
hubScrollFrame.Position = UDim2.new(0, 0, 0, 45)
hubScrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
hubScrollFrame.BorderSizePixel = 0
hubScrollFrame.ScrollBarThickness = 8
hubScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
hubScrollFrame.Parent = hubFrame

local hubScrollCorner = Instance.new("UICorner")
hubScrollCorner.CornerRadius = UDim.new(0, 8)
hubScrollCorner.Parent = hubScrollFrame

-- Scripts do hub
local hubScripts = {
    {name = "99 Dias na Floresta", code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/BaconBossScript/BeeconHub/main/BeeconHub"))()', description = "Script completo para 99 Dias na Floresta", color = Color3.fromRGB(34, 139, 34)},
    {name = "Infinite Yield", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()", description = "Admin commands mais popular", color = Color3.fromRGB(100, 255, 100)},
    {name = "Dex Explorer", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/infyiff/backup/main/dex.lua'))()", description = "Explorer avançado do jogo", color = Color3.fromRGB(100, 150, 255)},
    {name = "Universal ESP", code = "loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua'))()", description = "ESP para visualizar jogadores", color = Color3.fromRGB(255, 255, 100)},
    {name = "Orca Hub", code = "loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua'))()", description = "Hub de ferramentas", color = Color3.fromRGB(150, 100, 255)},
    {name = "Carlllosviera", code = "require(3465).carlllosviera", description = "Script clássico require", color = Color3.fromRGB(255, 100, 100)},
    {name = "SweetBaby", code = "require(4859311019).sweetbaby", description = "Script SweetBaby", color = Color3.fromRGB(255, 150, 200)}
}

local function createHubScriptButton(script, index)
    local scriptFrame = Instance.new("Frame")
    scriptFrame.Name = "HubScript" .. index
    scriptFrame.Size = UDim2.new(1, -20, 0, 80)
    scriptFrame.Position = UDim2.new(0, 10, 0, (index - 1) * 90)
    scriptFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    scriptFrame.BorderSizePixel = 0
    scriptFrame.Parent = hubScrollFrame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = scriptFrame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.7, 0, 0, 25)
    nameLabel.Position = UDim2.new(0, 10, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = script.name
    nameLabel.TextColor3 = script.color
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 16
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = scriptFrame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.7, 0, 0, 20)
    descLabel.Position = UDim2.new(0, 10, 0, 30)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = script.description
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 12
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = scriptFrame
    
    local executeBtn = Instance.new("TextButton")
    executeBtn.Size = UDim2.new(0, 80, 0, 30)
    executeBtn.Position = UDim2.new(1, -90, 0, 10)
    executeBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    executeBtn.Text = "▶ Executar"
    executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeBtn.TextScaled = true
    executeBtn.Font = Enum.Font.GothamBold
    executeBtn.BorderSizePixel = 0
    executeBtn.Parent = scriptFrame
    
    local executeBtnCorner = Instance.new("UICorner")
    executeBtnCorner.CornerRadius = UDim.new(0, 6)
    executeBtnCorner.Parent = executeBtn
    
    local loadBtn = Instance.new("TextButton")
    loadBtn.Size = UDim2.new(0, 80, 0, 30)
    loadBtn.Position = UDim2.new(1, -90, 0, 45)
    loadBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
    loadBtn.Text = "📝 Carregar"
    loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadBtn.TextScaled = true
    loadBtn.Font = Enum.Font.GothamBold
    loadBtn.BorderSizePixel = 0
    loadBtn.Parent = scriptFrame
    
    local loadBtnCorner = Instance.new("UICorner")
    loadBtnCorner.CornerRadius = UDim.new(0, 6)
    loadBtnCorner.Parent = loadBtn
    
    executeBtn.MouseButton1Click:Connect(function()
        executeScript(script.code)
    end)
    
    loadBtn.MouseButton1Click:Connect(function()
        codeBox.Text = script.code
        -- Mudar para aba executor
        switchTab(1)
    end)
    
    return scriptFrame
end

-- Criar botões dos scripts do hub
for i, script in ipairs(hubScripts) do
    createHubScriptButton(script, i)
end

hubScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #hubScripts * 90)

-- ABA 3: SCRIPTS SALVOS
local savedFrame = Instance.new("Frame")
savedFrame.Name = "SavedFrame"
savedFrame.Size = UDim2.new(1, 0, 1, 0)
savedFrame.BackgroundTransparency = 1
savedFrame.Visible = false
savedFrame.Parent = contentFrame

local savedTitle = Instance.new("TextLabel")
savedTitle.Size = UDim2.new(1, 0, 0, 40)
savedTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
savedTitle.Text = "💾 Scripts Salvos - " .. player.Name
savedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
savedTitle.TextScaled = true
savedTitle.Font = Enum.Font.GothamBold
savedTitle.BorderSizePixel = 0
savedTitle.Parent = savedFrame

local savedTitleCorner = Instance.new("UICorner")
savedTitleCorner.CornerRadius = UDim.new(0, 8)
savedTitleCorner.Parent = savedTitle

local savedScrollFrame = Instance.new("ScrollingFrame")
savedScrollFrame.Size = UDim2.new(1, 0, 1, -50)
savedScrollFrame.Position = UDim2.new(0, 0, 0, 45)
savedScrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
savedScrollFrame.BorderSizePixel = 0
savedScrollFrame.ScrollBarThickness = 8
savedScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
savedScrollFrame.Parent = savedFrame

local savedScrollCorner = Instance.new("UICorner")
savedScrollCorner.CornerRadius = UDim.new(0, 8)
savedScrollCorner.Parent = savedScrollFrame

-- ABA 4: CONFIGURAÇÕES
local configFrame = Instance.new("Frame")
configFrame.Name = "ConfigFrame"
configFrame.Size = UDim2.new(1, 0, 1, 0)
configFrame.BackgroundTransparency = 1
configFrame.Visible = false
configFrame.Parent = contentFrame

local configTitle = Instance.new("TextLabel")
configTitle.Size = UDim2.new(1, 0, 0, 40)
configTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
configTitle.Text = "⚙️ Configurações"
configTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
configTitle.TextScaled = true
configTitle.Font = Enum.Font.GothamBold
configTitle.BorderSizePixel = 0
configTitle.Parent = configFrame

local configTitleCorner = Instance.new("UICorner")
configTitleCorner.CornerRadius = UDim.new(0, 8)
configTitleCorner.Parent = configTitle

-- Configuração de tecla
local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, -20, 0, 30)
keyLabel.Position = UDim2.new(0, 10, 0, 60)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "🔑 Tecla para mostrar/ocultar: " .. toggleKey.Name
keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextSize = 14
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = configFrame

local changeKeyBtn = Instance.new("TextButton")
changeKeyBtn.Size = UDim2.new(0, 150, 0, 35)
changeKeyBtn.Position = UDim2.new(0, 10, 0, 95)
changeKeyBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 200)
changeKeyBtn.Text = "🔄 Alterar Tecla"
changeKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
changeKeyBtn.TextScaled = true
changeKeyBtn.Font = Enum.Font.GothamBold
changeKeyBtn.BorderSizePixel = 0
changeKeyBtn.Parent = configFrame

local changeKeyCorner = Instance.new("UICorner")
changeKeyCorner.CornerRadius = UDim.new(0, 8)
changeKeyCorner.Parent = changeKeyBtn

-- Informações adicionais
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 120)
infoLabel.Position = UDim2.new(0, 10, 0, 150)
infoLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
infoLabel.Text = "ℹ️ INFORMAÇÕES:\n\n• Scripts são salvos por jogador\n• Use o botão '–' para ocultar a GUI\n• Pressione a tecla configurada para mostrar/ocultar\n• O scroll funciona no editor de código\n• Botão 🔧 no canto superior esquerdo abre a GUI"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 12
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.TextWrapped = true
infoLabel.BorderSizePixel = 0
infoLabel.Parent = configFrame

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoLabel

-- Label de status
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Pronto para executar código"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = buttonFrame

-- Função para executar loadstring
local function executeLoadstring()
    if not urlBox or not urlBox.Text then
        showStatus("❌ Erro: URL não encontrada!", Color3.fromRGB(200, 50, 50))
        return
    end
    
    local url = urlBox.Text
    if url and url ~= "" and url:match("^https?://") then
        local loadstringCode = 'loadstring(game:HttpGet("' .. url .. '"))()'
        
        -- Carregar no editor
        if codeBox then
            codeBox.Text = loadstringCode
        end
        
        -- Executar automaticamente
        local success, error = pcall(function()
            loadstring('loadstring(game:HttpGet("' .. url .. '"))()')()
        end)
        
        if success then
            showStatus("✅ LoadString executado com sucesso!", Color3.fromRGB(200, 150, 50))
        else
            showStatus("❌ Erro no LoadString: " .. tostring(error or "Erro desconhecido"), Color3.fromRGB(200, 50, 50))
        end
    else
        showStatus("❌ URL inválida! Use https:// ou http://", Color3.fromRGB(200, 50, 50))
    end
end

-- Função para mostrar status
local function showStatus(message, color)
    if not statusLabel then return end
    
    local success, _ = pcall(function()
        statusLabel.Text = message or "Status desconhecido"
        statusLabel.TextColor3 = color or Color3.fromRGB(150, 150, 150)
        
        spawn(function()
            wait(3)
            if statusLabel and statusLabel.Parent then
                local tween = TweenService:Create(statusLabel, TweenInfo.new(1), {TextTransparency = 1})
                tween:Play()
                tween.Completed:Connect(function()
                    if statusLabel and statusLabel.Parent then
                        statusLabel.Text = "Pronto para executar código"
                        statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                        statusLabel.TextTransparency = 0
                    end
                end)
            end
        end)
    end)
end

-- Função para executar código
function executeCode()
    if not codeBox or not codeBox.Text then 
        showStatus("❌ Erro: Código não encontrado!", Color3.fromRGB(200, 50, 50))
        return 
    end
    
    local success, error = pcall(function()
        local code = codeBox.Text
        if code and code ~= "" then
            if code:match("require%(%d+%)") then
                loadstring(code)()
            else
                loadstring(code)()
            end
        end
    end)
    
    if success then
        showStatus("✅ Código executado com sucesso!", Color3.fromRGB(50, 200, 50))
    else
        showStatus("❌ Erro: " .. tostring(error or "Erro desconhecido"), Color3.fromRGB(200, 50, 50))
    end
end

-- Função para executar script diretamente
function executeScript(code)
    if not code or code == "" then
        showStatus("❌ Erro: Script vazio!", Color3.fromRGB(200, 50, 50))
        return
    end
    
    local success, error = pcall(function()
        loadstring(code)()
    end)
    
    if success then
        showStatus("✅ Script executado com sucesso!", Color3.fromRGB(50, 200, 50))
    else
        showStatus("❌ Erro: " .. tostring(error or "Erro desconhecido"), Color3.fromRGB(200, 50, 50))
    end
end

-- Função para salvar script
local function saveScript()
    if not codeBox or not codeBox.Text then
        showStatus("❌ Erro: Nenhum código para salvar!", Color3.fromRGB(200, 50, 50))
        return
    end
    
    local scriptName = codeBox.Text:match("-- (.+)") or "Script " .. (#savedScripts + 1)
    if #codeBox.Text > 10 then
        local success, _ = pcall(function()
            table.insert(savedScripts, {
                name = scriptName,
                code = codeBox.Text,
                date = os.date and os.date("%d/%m/%Y %H:%M") or "Data indisponível"
            })
        end)
        
        if success then
            updateSavedScripts()
            showStatus("💾 Script salvo: " .. scriptName, Color3.fromRGB(100, 100, 200))
        else
            showStatus("❌ Erro ao salvar script!", Color3.fromRGB(200, 50, 50))
        end
    else
        showStatus("❌ Código muito pequeno para salvar!", Color3.fromRGB(200, 50, 50))
    end
end

-- Função para atualizar lista de scripts salvos
function updateSavedScripts()
    -- Limpar scripts existentes
    for _, child in pairs(savedScrollFrame:GetChildren()) do
        if child.Name:match("SavedScript") then
            child:Destroy()
        end
    end
    
    -- Criar novos botões
    for i, script in ipairs(savedScripts) do
        local scriptFrame = Instance.new("Frame")
        scriptFrame.Name = "SavedScript" .. i
        scriptFrame.Size = UDim2.new(1, -20, 0, 80)
        scriptFrame.Position = UDim2.new(0, 10, 0, (i - 1) * 90)
        scriptFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        scriptFrame.BorderSizePixel = 0
        scriptFrame.Parent = savedScrollFrame
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 8)
        frameCorner.Parent = scriptFrame
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0.6, 0, 0, 25)
        nameLabel.Position = UDim2.new(0, 10, 0, 5)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = script.name
        nameLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = scriptFrame
        
        local dateLabel = Instance.new("TextLabel")
        dateLabel.Size = UDim2.new(0.6, 0, 0, 20)
        dateLabel.Position = UDim2.new(0, 10, 0, 30)
        dateLabel.BackgroundTransparency = 1
        dateLabel.Text = "📅 " .. script.date
        dateLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        dateLabel.Font = Enum.Font.Gotham
        dateLabel.TextSize = 10
        dateLabel.TextXAlignment = Enum.TextXAlignment.Left
        dateLabel.Parent = scriptFrame
        
        local previewLabel = Instance.new("TextLabel")
        previewLabel.Size = UDim2.new(0.6, 0, 0, 20)
        previewLabel.Position = UDim2.new(0, 10, 0, 50)
        previewLabel.BackgroundTransparency = 1
        previewLabel.Text = string.sub(script.code:gsub("\n", " "), 1, 50) .. "..."
        previewLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        previewLabel.Font = Enum.Font.Code
        previewLabel.TextSize = 9
        previewLabel.TextXAlignment = Enum.TextXAlignment.Left
        previewLabel.Parent = scriptFrame
        
        -- Botões
        local loadBtn = Instance.new("TextButton")
        loadBtn.Size = UDim2.new(0, 70, 0, 25)
        loadBtn.Position = UDim2.new(1, -80, 0, 5)
        loadBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        loadBtn.Text = "📝 Carregar"
        loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        loadBtn.TextScaled = true
        loadBtn.Font = Enum.Font.GothamBold
        loadBtn.BorderSizePixel = 0
        loadBtn.Parent = scriptFrame
        
        local loadCorner = Instance.new("UICorner")
        loadCorner.CornerRadius = UDim.new(0, 4)
        loadCorner.Parent = loadBtn
        
        local executeBtn = Instance.new("TextButton")
        executeBtn.Size = UDim2.new(0, 70, 0, 25)
        executeBtn.Position = UDim2.new(1, -80, 0, 30)
        executeBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        executeBtn.Text = "▶ Executar"
        executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        executeBtn.TextScaled = true
        executeBtn.Font = Enum.Font.GothamBold
        executeBtn.BorderSizePixel = 0
        executeBtn.Parent = scriptFrame
        
        local executeCorner = Instance.new("UICorner")
        executeCorner.CornerRadius = UDim.new(0, 4)
        executeCorner.Parent = executeBtn
        
        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.new(0, 70, 0, 20)
        deleteBtn.Position = UDim2.new(1, -80, 0, 55)
        deleteBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        deleteBtn.Text = "🗑 Deletar"
        deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        deleteBtn.TextScaled = true
        deleteBtn.Font = Enum.Font.GothamBold
        deleteBtn.BorderSizePixel = 0
        deleteBtn.Parent = scriptFrame
        
        local deleteCorner = Instance.new("UICorner")
        deleteCorner.CornerRadius = UDim.new(0, 4)
        deleteCorner.Parent = deleteBtn
        
        -- Conectar eventos
        loadBtn.MouseButton1Click:Connect(function()
            codeBox.Text = script.code
            switchTab(1)
            showStatus("📝 Script carregado: " .. script.name, Color3.fromRGB(100, 200, 100))
        end)
        
        executeBtn.MouseButton1Click:Connect(function()
            executeScript(script.code)
        end)
        
        deleteBtn.MouseButton1Click:Connect(function()
            table.remove(savedScripts, i)
            updateSavedScripts()
            showStatus("🗑 Script deletado: " .. script.name, Color3.fromRGB(200, 50, 50))
        end)
    end
    
    savedScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #savedScripts * 90)
end

-- Função para trocar abas
function switchTab(tabIndex)
    -- Resetar cores dos botões
    for i, btn in ipairs(tabButtons) do
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end
    
    -- Ocultar todos os frames
    executorFrame.Visible = false
    hubFrame.Visible = false
    savedFrame.Visible = false
    configFrame.Visible = false
    
    -- Mostrar frame selecionado e destacar botão
    tabButtons[tabIndex].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    if tabIndex == 1 then
        executorFrame.Visible = true
    elseif tabIndex == 2 then
        hubFrame.Visible = true
    elseif tabIndex == 3 then
        savedFrame.Visible = true
        updateSavedScripts()
    elseif tabIndex == 4 then
        configFrame.Visible = true
    end
end

-- Função para pesquisar scripts
local function searchScripts()
    if not searchBox or not hubScrollFrame then return end
    
    local success, _ = pcall(function()
        local searchTerm = (searchBox.Text or ""):lower()
        
        for _, child in pairs(hubScrollFrame:GetChildren()) do
            if child.Name and child.Name:match("HubScript") then
                local nameLabel = child:FindFirstChild("TextLabel")
                if nameLabel and nameLabel.Text then
                    local scriptName = nameLabel.Text:lower()
                    child.Visible = scriptName:find(searchTerm) ~= nil or searchTerm == ""
                end
            end
        end
    end)
end

-- Função para alterar tecla de toggle
local changingKey = false
local function changeToggleKey()
    if changingKey then return end
    if not changeKeyBtn or not keyLabel then return end
    
    changingKey = true
    changeKeyBtn.Text = "Pressione uma tecla..."
    changeKeyBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        local success, _ = pcall(function()
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode then
                toggleKey = input.KeyCode
                keyLabel.Text = "🔑 Tecla para mostrar/ocultar: " .. (toggleKey.Name or "Desconhecida")
                changeKeyBtn.Text = "🔄 Alterar Tecla"
                changeKeyBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 200)
                changingKey = false
                connection:Disconnect()
                showStatus("🔑 Tecla alterada para: " .. (toggleKey.Name or "Desconhecida"), Color3.fromRGB(100, 150, 200))
            end
        end)
    end)
end

-- Função para toggle da GUI
local function toggleGUI()
    if not mainFrame or not openButton then return end
    
    isGUIVisible = not isGUIVisible
    mainFrame.Visible = isGUIVisible
    openButton.Visible = not isGUIVisible
    
    if isGUIVisible then
        spawn(function()
            local success, _ = pcall(function()
                local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                    Size = UDim2.new(0, 650, 0, 580)
                })
                tween:Play()
            end)
        end)
    else
        spawn(function()
            local success, _ = pcall(function()
                local tween = TweenService:Create(openButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0, 45, 0, 45)
                })
                tween:Play()
                
                wait(0.1)
                
                local tween2 = TweenService:Create(openButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0, 40, 0, 40)
                })
                tween2:Play()
            end)
        end)
    end
end

-- CONECTAR EVENTOS

-- Evento do botão de abertura
openButton.MouseButton1Click:Connect(function()
    spawn(toggleGUI)
end)

-- Eventos das abas
for i, btn in ipairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        switchTab(i)
    end)
end

-- Eventos dos botões principais
executeButton.MouseButton1Click:Connect(function()
    spawn(executeCode)
end)

clearButton.MouseButton1Click:Connect(function()
    if codeBox then
        codeBox.Text = ""
        showStatus("🗑 Código limpo!", Color3.fromRGB(200, 100, 50))
    end
end)

saveButton.MouseButton1Click:Connect(function()
    spawn(saveScript)
end)

injectButton.MouseButton1Click:Connect(function()
    if requireBox and requireBox.Text then
        local id = requireBox.Text
        if id and id ~= "" then
            if codeBox then
                codeBox.Text = "require(" .. id .. ")"
                showStatus("💉 Require injetado: " .. id, Color3.fromRGB(150, 100, 200))
            end
        else
            showStatus("❌ Digite um ID válido!", Color3.fromRGB(200, 50, 50))
        end
    end
end)

-- Evento do botão LoadString
loadstringButton.MouseButton1Click:Connect(function()
    spawn(executeLoadstring)
end)

-- Eventos da GUI
closeButton.MouseButton1Click:Connect(function()
    if screenGui then
        screenGui:Destroy()
    end
end)

hideButton.MouseButton1Click:Connect(function()
    spawn(toggleGUI)
end)

-- Eventos de pesquisa
searchButton.MouseButton1Click:Connect(function()
    spawn(searchScripts)
end)

if searchBox then
    searchBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            spawn(searchScripts)
        end
    end)
end

-- Evento de mudança de tecla
changeKeyBtn.MouseButton1Click:Connect(function()
    spawn(changeToggleKey)
end)

-- Evento de tecla global
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local success, _ = pcall(function()
        if input.KeyCode == toggleKey then
            spawn(toggleGUI)
        end
    end)
end)

-- Efeitos hover nos botões
local function addHoverEffect(button, originalColor, hoverColor)
    if not button then return end
    
    button.MouseEnter:Connect(function()
        local success, _ = pcall(function()
            local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor})
            tween:Play()
        end)
    end)
    
    button.MouseLeave:Connect(function()
        local success, _ = pcall(function()
            local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = originalColor})
            tween:Play()
        end)
    end)
end

-- Adicionar efeitos hover
addHoverEffect(executeButton, Color3.fromRGB(50, 200, 50), Color3.fromRGB(60, 220, 60))
addHoverEffect(clearButton, Color3.fromRGB(200, 100, 50), Color3.fromRGB(220, 120, 70))
addHoverEffect(saveButton, Color3.fromRGB(100, 100, 200), Color3.fromRGB(120, 120, 220))
addHoverEffect(injectButton, Color3.fromRGB(150, 100, 200), Color3.fromRGB(170, 120, 220))
addHoverEffect(loadstringButton, Color3.fromRGB(200, 150, 50), Color3.fromRGB(220, 170, 70))
addHoverEffect(closeButton, Color3.fromRGB(220, 50, 50), Color3.fromRGB(240, 70, 70))
addHoverEffect(hideButton, Color3.fromRGB(100, 150, 200), Color3.fromRGB(120, 170, 220))
addHoverEffect(changeKeyBtn, Color3.fromRGB(100, 150, 200), Color3.fromRGB(120, 170, 220))
addHoverEffect(searchButton, Color3.fromRGB(100, 150, 255), Color3.fromRGB(120, 170, 255))
addHoverEffect(openButton, Color3.fromRGB(30, 30, 30), Color3.fromRGB(50, 50, 50))

-- Inicializar na primeira aba
local success, _ = pcall(function()
    switchTab(1)
end)

-- Mensagens de inicialização
spawn(function()
    wait(1)
    print("🔧 Admin Code Executor Pro carregado com sucesso!")
    print("📋 Funcionalidades:")
    print("   • Editor com scroll")
    print("   • Sistema LoadString com URLs")
    print("   • Sistema de salvamento por jogador")
    print("   • Hub de scripts pesquisável")
    print("   • Script '99 Dias na Floresta' incluído")
    print("   • Botão de ocultar (tecla configurável)")
    print("   • Botão de abertura no canto superior esquerdo")
    print("   • Tecla atual: " .. (toggleKey and toggleKey.Name or "RightShift"))
    print("🌐 Use o campo LoadString para executar scripts de URLs!")
end)
