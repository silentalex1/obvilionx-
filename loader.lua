local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ObvilionX_Loader = {}
ObvilionX_Loader.Version = "1.0.0"

local NotificationLibrary = {}

function NotificationLibrary:Create(title, text, duration)
    duration = duration or 3
    title = title or "Notification"
    text = text or "No text provided"
    
    if not game.CoreGui:FindFirstChild("ObvilionX_Notifications") then
        local notifContainer = Instance.new("ScreenGui")
        notifContainer.Name = "ObvilionX_Notifications"
        notifContainer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        notifContainer.Parent = game.CoreGui
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 10)
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        listLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = notifContainer
        
        local padding = Instance.new("UIPadding")
        padding.PaddingRight = UDim.new(0, 20)
        padding.PaddingBottom = UDim.new(0, 20)
        padding.Parent = notifContainer
    end
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 250, 0, 80)
    notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notification.BorderSizePixel = 0
    notification.AnchorPoint = Vector2.new(0, 1)
    notification.Position = UDim2.new(1, 300, 1, 0)
    notification.Parent = game.CoreGui:FindFirstChild("ObvilionX_Notifications")
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = notification
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = notification
    
    local accentLine = Instance.new("Frame")
    accentLine.Name = "AccentLine"
    accentLine.Size = UDim2.new(0, 5, 1, 0)
    accentLine.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    accentLine.BorderSizePixel = 0
    accentLine.Parent = notification
    
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 6)
    accentCorner.Parent = accentLine
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 15, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = title
    titleLabel.Parent = notification
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.Size = UDim2.new(1, -20, 0, 40)
    textLabel.Position = UDim2.new(0, 15, 0, 30)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.TextWrapped = true
    textLabel.Text = text
    textLabel.Parent = notification
    
    notification:TweenPosition(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
    
    spawn(function()
        wait(duration - 0.5)
        notification:TweenPosition(UDim2.new(1, 300, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
        wait(0.5)
        notification:Destroy()
    end)
    
    return notification
end

function ObvilionX_Loader:CreateUI()
    if game.CoreGui:FindFirstChild("ObvilionX_Loader") then
        game.CoreGui.ObvilionX_Loader:Destroy()
    end
    
    local loaderGui = Instance.new("ScreenGui")
    loaderGui.Name = "ObvilionX_Loader"
    loaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    loaderGui.Parent = game.CoreGui
    
    local backgroundBlur = Instance.new("Frame")
    backgroundBlur.Name = "BackgroundBlur"
    backgroundBlur.Size = UDim2.new(1, 0, 1, 0)
    backgroundBlur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backgroundBlur.BackgroundTransparency = 1
    backgroundBlur.BorderSizePixel = 0
    backgroundBlur.Parent = loaderGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 270)
    mainFrame.Position = UDim2.new(0.5, 0, 0, -300)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Parent = loaderGui
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
    }
    gradient.Rotation = 90
    gradient.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = mainFrame
    
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 10)
    topCorner.Parent = topBar
    
    local topOnlyFix = Instance.new("Frame")
    topOnlyFix.Name = "TopOnlyFix"
    topOnlyFix.Size = UDim2.new(1, 0, 0, 20)
    topOnlyFix.Position = UDim2.new(0, 0, 1, -20)
    topOnlyFix.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    topOnlyFix.BorderSizePixel = 0
    topOnlyFix.Parent = topBar
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = "ObvilionX - Loader"
    title.Parent = topBar
    
    local logo = Instance.new("ImageLabel")
    logo.Name = "Logo"
    logo.Size = UDim2.new(0, 80, 0, 80)
    logo.Position = UDim2.new(0.5, -40, 0, 50)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://10734924544"
    logo.Parent = mainFrame
    
    local keyInput = Instance.new("TextBox")
    keyInput.Name = "KeyInput"
    keyInput.Size = UDim2.new(0, 320, 0, 40)
    keyInput.Position = UDim2.new(0.5, -160, 0, 140)
    keyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    keyInput.BorderSizePixel = 0
    keyInput.Font = Enum.Font.Gotham
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.TextSize = 16
    keyInput.PlaceholderText = "Enter Key..."
    keyInput.Text = ""
    keyInput.ClearTextOnFocus = false
    keyInput.Parent = mainFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = keyInput
    
    local getKeyButton = Instance.new("TextButton")
    getKeyButton.Name = "GetKeyButton"
    getKeyButton.Size = UDim2.new(0, 150, 0, 45)
    getKeyButton.Position = UDim2.new(0.5, -160, 0, 190)
    getKeyButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    getKeyButton.BorderSizePixel = 0
    getKeyButton.Font = Enum.Font.GothamBold
    getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    getKeyButton.TextSize = 14
    getKeyButton.Text = "Get Key"
    getKeyButton.Parent = mainFrame
    
    local getKeyCorner = Instance.new("UICorner")
    getKeyCorner.CornerRadius = UDim.new(0, 6)
    getKeyCorner.Parent = getKeyButton
    
    local submitButton = Instance.new("TextButton")
    submitButton.Name = "SubmitButton"
    submitButton.Size = UDim2.new(0, 150, 0, 45)
    submitButton.Position = UDim2.new(0.5, 10, 0, 190)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    submitButton.BorderSizePixel = 0
    submitButton.Font = Enum.Font.GothamBold
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.TextSize = 14
    submitButton.Text = "Submit"
    submitButton.Parent = mainFrame
    
    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 6)
    submitCorner.Parent = submitButton
    
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, -40, 0, 20)
    statusText.Position = UDim2.new(0, 20, 0, 240)
    statusText.BackgroundTransparency = 1
    statusText.Font = Enum.Font.Gotham
    statusText.TextColor3 = Color3.fromRGB(180, 180, 180)
    statusText.TextSize = 14
    statusText.TextXAlignment = Enum.TextXAlignment.Center
    statusText.Text = "Enter your key to access ObvilionX"
    statusText.Visible = false
    statusText.Parent = mainFrame
    
    local loadingText = Instance.new("TextLabel")
    loadingText.Name = "LoadingText"
    loadingText.Size = UDim2.new(1, -40, 0, 20)
    loadingText.Position = UDim2.new(0, 20, 0, 220)
    loadingText.BackgroundTransparency = 1
    loadingText.Font = Enum.Font.Gotham
    loadingText.TextColor3 = Color3.fromRGB(180, 180, 180)
    loadingText.TextSize = 14
    loadingText.TextXAlignment = Enum.TextXAlignment.Center
    loadingText.Text = "Loading..."
    loadingText.Visible = false
    loadingText.Parent = mainFrame
    
    getKeyButton.MouseButton1Click:Connect(function()
        setclipboard("https://exploitnews.pro")
        NotificationLibrary:Create("ObvilionX", "Website link copied onto your clipboard", 3)
    end)
    
    submitButton.MouseButton1Click:Connect(function()
        local key = keyInput.Text
        local storedKey = localStorage.getItem('mainKey') or 'obvilionx_890ffx1'
        if key == storedKey then
            loadingText.Visible = true
            statusText.Visible = false
            local success, errorMessage = pcall(function()
                loadstring(game:HttpGet("https://github.com/silentalex1/obvilionx-/blob/main/universallib.lua"))()
            end)
            if success then
                local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                local tween = TweenService:Create(mainFrame, tweenInfo, {Position = UDim2.new(0.5, 0, 0, -300)})
                local blurOutTween = TweenService:Create(backgroundBlur, tweenInfo, {BackgroundTransparency = 1})
                tween:Play()
                blurOutTween:Play()
                tween.Completed:Connect(function()
                    loaderGui:Destroy()
                    NotificationLibrary:Create("ObvilionX", "Successfully loaded! Enjoy!", 3)
                end)
            else
                loadingText.Visible = false
                statusText.Visible = true
                statusText.Text = "Error loading script!"
                statusText.TextColor3 = Color3.fromRGB(255, 0, 0)
                NotificationLibrary:Create("ObvilionX", "Error: " .. errorMessage, 5)
            end
        else
            statusText.Visible = true
            statusText.Text = "Invalid key! Please try again."
            statusText.TextColor3 = Color3.fromRGB(255, 0, 0)
            local originalPosition = mainFrame.Position
            for i = 1, 5 do
                local shakeOffset = i % 2 == 0 and 10 or -10
                mainFrame.Position = UDim2.new(0.5, shakeOffset, 0.5, 0)
                wait(0.05)
            end
            mainFrame.Position = originalPosition
        end
    end)
    
    local function applyButtonHoverEffect(button, defaultColor, hoverColor)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
        end)
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = defaultColor}):Play()
        end)
    end
    
    applyButtonHoverEffect(getKeyButton, Color3.fromRGB(35, 35, 35), Color3.fromRGB(50, 50, 50))
    applyButtonHoverEffect(submitButton, Color3.fromRGB(0, 170, 255), Color3.fromRGB(0, 150, 235))
    
    wait(3)
    
    local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local positionTween = TweenService:Create(mainFrame, tweenInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)})
    local blurTween = TweenService:Create(backgroundBlur, tweenInfo, {BackgroundTransparency = 0.5})
    positionTween:Play()
    blurTween:Play()
end

ObvilionX_Loader:CreateUI()

return ObvilionX_Loader
