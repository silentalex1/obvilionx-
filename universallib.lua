local ObvilionX = {}
ObvilionX.Version = "1.0.0"
ObvilionX.GameSupport = {
    ["Da Hood"] = 2788229376,
    ["Flee the Facility"] = 893973440,
    ["Prison Life"] = 155615604,
    ["Jailbreak"] = 606849621,
    ["Murder Mystery 2"] = 142823291
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Colors = {
    Primary = Color3.fromRGB(30, 30, 30),
    Secondary = Color3.fromRGB(45, 45, 45),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180)
}

local Library = {}

function Library:Create(class, properties)
    local instance = Instance.new(class)
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    return instance
end

function Library:CreateUI()
    local ObvilionXGUI = Library:Create("ScreenGui", {
        Name = "ObvilionX",
        Parent = game.CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local MainFrame = Library:Create("Frame", {
        Name = "MainFrame",
        Parent = ObvilionXGUI,
        BackgroundColor3 = Colors.Primary,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -250, 0.5, -175),
        Size = UDim2.new(0, 500, 0, 350),
        ClipsDescendants = true
    })
    
    Library:Create("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    Library:Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Colors.Primary),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
        }),
        Rotation = 90,
        Parent = MainFrame
    })
    
    local TopBar = Library:Create("Frame", {
        Name = "TopBar",
        Parent = MainFrame,
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30)
    })
    
    Library:Create("UICorner", {
        Parent = TopBar,
        CornerRadius = UDim.new(0, 8)
    })
    
    local Title = Library:Create("TextLabel", {
        Name = "Title",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "ObvilionX",
        TextColor3 = Colors.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local GameIndicator = Library:Create("TextLabel", {
        Name = "GameIndicator",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 100, 0, 0),
        Size = UDim2.new(0, 300, 1, 0),
        Font = Enum.Font.Gotham,
        Text = "Game: " .. (ObvilionX.GameSupport[game.Name] and game.Name or "Unsupported"),
        TextColor3 = Colors.TextSecondary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    local CloseButton = Library:Create("TextButton", {
        Name = "CloseButton",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0, 0),
        Size = UDim2.new(0, 30, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "X",
        TextColor3 = Colors.Text,
        TextSize = 16
    })
    
    CloseButton.MouseEnter:Connect(function()
        CloseButton.TextColor3 = Colors.Accent
    end)
    
    CloseButton.MouseLeave:Connect(function()
        CloseButton.TextColor3 = Colors.Text
    end)
    
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    local Sidebar = Library:Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(0, 120, 1, -30)
    })
    
    Library:Create("UICorner", {
        Parent = Sidebar,
        CornerRadius = UDim.new(0, 8)
    })
    
    local ContentFrame = Library:Create("Frame", {
        Name = "ContentFrame",
        Parent = MainFrame,
        BackgroundColor3 = Colors.Primary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 120, 0, 30),
        Size = UDim2.new(1, -120, 1, -30),
        ClipsDescendants = true
    })
    
    Library:Create("UICorner", {
        Parent = ContentFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    local TabButtons = {}
    local Tabs = {}
    
    function Library:CreateTab(name)
        local tabButton = Library:Create("TextButton", {
            Name = name .. "Button",
            Parent = Sidebar,
            BackgroundColor3 = Colors.Secondary,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 30 * (#TabButtons)),
            Size = UDim2.new(1, 0, 0, 30),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Colors.TextSecondary,
            TextSize = 14
        })
        
        Library:Create("UICorner", {
            Parent = tabButton,
            CornerRadius = UDim.new(0, 4)
        })
        
        tabButton.MouseEnter:Connect(function()
            if tabButton.TextColor3 ~= Colors.Text then
                tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if tabButton.TextColor3 ~= Colors.Text then
                tabButton.BackgroundColor3 = Colors.Secondary
            end
        end)
        
        local tabContent = Library:Create("ScrollingFrame", {
            Name = name .. "Tab",
            Parent = ContentFrame,
            Active = true,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Colors.Accent,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
        
        local UIListLayout = Library:Create("UIListLayout", {
            Parent = tabContent,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
        
        local UIPadding = Library:Create("UIPadding", {
            Parent = tabContent,
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })
        
        UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
        end)
        
        table.insert(TabButtons, tabButton)
        table.insert(Tabs, tabContent)
        
        tabButton.MouseButton1Click:Connect(function()
            Library:SelectTab(name)
        end)
        
        if #TabButtons == 1 then
            Library:SelectTab(name)
        end
        
        local tabFunctions = {}
        
        function tabFunctions:CreateSection(sectionName)
            local section = Library:Create("Frame", {
                Name = sectionName .. "Section",
                Parent = tabContent,
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 35),
                LayoutOrder = #tabContent:GetChildren()
            })
            
            Library:Create("UICorner", {
                Parent = section,
                CornerRadius = UDim.new(0, 4)
            })
            
            local sectionTitle = Library:Create("TextLabel", {
                Name = "SectionTitle",
                Parent = section,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -20, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = sectionName,
                TextColor3 = Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            return section
        end
        
        function tabFunctions:CreateButton(text, callback)
            local button = Library:Create("TextButton", {
                Name = text .. "Button",
                Parent = tabContent,
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 30),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Colors.Text,
                TextSize = 14,
                LayoutOrder = #tabContent:GetChildren()
            })
            
            Library:Create("UICorner", {
                Parent = button,
                CornerRadius = UDim.new(0, 4)
            })
            
            button.MouseEnter:Connect(function()
                button.BackgroundColor3 = Colors.Accent
            end)
            
            button.MouseLeave:Connect(function()
                button.BackgroundColor3 = Colors.Secondary
            end)
            
            button.MouseButton1Click:Connect(callback)
            
            return button
        end
        
        function tabFunctions:CreateToggle(text, default, callback)
            local toggle = Library:Create("Frame", {
                Name = text .. "Toggle",
                Parent = tabContent,
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 30),
                LayoutOrder = #tabContent:GetChildren()
            })
            
            Library:Create("UICorner", {
                Parent = toggle,
                CornerRadius = UDim.new(0, 4)
            })
            
            local toggleText = Library:Create("TextLabel", {
                Name = "Text",
                Parent = toggle,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -50, 1, 0),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local toggleButton = Library:Create("Frame", {
                Name = "ToggleButton",
                Parent = toggle,
                BackgroundColor3 = default and Colors.Accent or Color3.fromRGB(80, 80, 80),
                Position = UDim2.new(1, -40, 0.5, -9),
                Size = UDim2.new(0, 30, 0, 18)
            })
            
            Library:Create("UICorner", {
                Parent = toggleButton,
                CornerRadius = UDim.new(0, 9)
            })
            
            local toggleCircle = Library:Create("Frame", {
                Name = "Circle",
                Parent = toggleButton,
                BackgroundColor3 = Colors.Text,
                Position = default and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
                Size = UDim2.new(0, 12, 0, 12)
            })
            
            Library:Create("UICorner", {
                Parent = toggleCircle,
                CornerRadius = UDim.new(1, 0)
            })
            
            local enabled = default
            
            toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    enabled = not enabled
                    
                    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = enabled and Colors.Accent or Color3.fromRGB(80, 80, 80)}):Play()
                    TweenService:Create(toggleCircle, tweenInfo, {Position = enabled and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
                    
                    callback(enabled)
                end
            end)
            
            return toggle
        end
        
        function tabFunctions:CreateSlider(text, min, max, default, callback)
            local slider = Library:Create("Frame", {
                Name = text .. "Slider",
                Parent = tabContent,
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 50),
                LayoutOrder = #tabContent:GetChildren()
            })
            
            Library:Create("UICorner", {
                Parent = slider,
                CornerRadius = UDim.new(0, 4)
            })
            
            local sliderText = Library:Create("TextLabel", {
                Name = "Text",
                Parent = slider,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 5),
                Size = UDim2.new(1, -20, 0, 20),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local valueText = Library:Create("TextLabel", {
                Name = "Value",
                Parent = slider,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -50, 0, 5),
                Size = UDim2.new(0, 40, 0, 20),
                Font = Enum.Font.Gotham,
                Text = tostring(default),
                TextColor3 = Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local sliderBackground = Library:Create("Frame", {
                Name = "Background",
                Parent = slider,
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, 30),
                Size = UDim2.new(1, -20, 0, 5)
            })
            
            Library:Create("UICorner", {
                Parent = sliderBackground,
                CornerRadius = UDim.new(0, 2)
            })
            
            local sliderFill = Library:Create("Frame", {
                Name = "Fill",
                Parent = sliderBackground,
                BackgroundColor3 = Colors.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            })
            
            Library:Create("UICorner", {
                Parent = sliderFill,
                CornerRadius = UDim.new(0, 2)
            })
            
            local sliderKnob = Library:Create("Frame", {
                Name = "Knob",
                Parent = sliderFill,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Colors.Text,
                Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.new(0, 12, 0, 12)
            })
            
            Library:Create("UICorner", {
                Parent = sliderKnob,
                CornerRadius = UDim.new(1, 0)
            })
            
            local function updateSlider(value)
                value = math.clamp(value, min, max)
                value = math.floor(value * 10) / 10
                valueText.Text = tostring(value)
                sliderFill:TweenSize(UDim2.new((value - min) / (max - min), 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
                callback(value)
            end
            
            local dragging = false
            
            sliderBackground.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local mousePos = input.Position.X
                    local framePos = sliderBackground.AbsolutePosition.X
                    local frameSize = sliderBackground.AbsoluteSize.X
                    local value = min + ((mousePos - framePos) / frameSize) * (max - min)
                    updateSlider(value)
                end
            end)
            
            sliderBackground.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = input.Position.X
                    local framePos = sliderBackground.AbsolutePosition.X
                    local frameSize = sliderBackground.AbsoluteSize.X
                    local value = min + ((mousePos - framePos) / frameSize) * (max - min)
                    updateSlider(value)
                end
            end)
            
            updateSlider(default)
            
            return slider
        end
        
        function tabFunctions:CreateDropdown(text, options, default, callback)
            local dropdown = Library:Create("Frame", {
                Name = text .. "Dropdown",
                Parent = tabContent,
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 30),
                ClipsDescendants = true,
                LayoutOrder = #tabContent:GetChildren()
            })
            
            Library:Create("UICorner", {
                Parent = dropdown,
                CornerRadius = UDim.new(0, 4)
            })
            
            local dropdownText = Library:Create("TextLabel", {
                Name = "Text",
                Parent = dropdown,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -50, 0, 30),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local selectedText = Library:Create("TextLabel", {
                Name = "Selected",
                Parent = dropdown,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -150, 0, 0),
                Size = UDim2.new(0, 130, 0, 30),
                Font = Enum.Font.Gotham,
                Text = default,
                TextColor3 = Colors.TextSecondary,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local dropdownArrow = Library:Create("TextButton", {
                Name = "Arrow",
                Parent = dropdown,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -20, 0, 0),
                Size = UDim2.new(0, 20, 0, 30),
                Font = Enum.Font.GothamBold,
                Text = "▼",
                TextColor3 = Colors.TextSecondary,
                TextSize = 14
            })
            
            local dropdownContainer = Library:Create("Frame", {
                Name = "Container",
                Parent = dropdown,
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 30),
                Size = UDim2.new(1, 0, 0, #options * 25)
            })
            
            local containerLayout = Library:Create("UIListLayout", {
                Parent = dropdownContainer,
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            local open = false
            
            dropdownArrow.MouseButton1Click:Connect(function()
                open = not open
                dropdownArrow.Text = open and "▲" or "▼"
                local newSize = open and UDim2.new(1, 0, 0, 30 + dropdownContainer.Size.Y.Offset) or UDim2.new(1, 0, 0, 30)
                TweenService:Create(dropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = newSize}):Play()
            end)
            
            for i, option in ipairs(options) do
                local optionButton = Library:Create("TextButton", {
                    Name = option,
                    Parent = dropdownContainer,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    Font = Enum.Font.Gotham,
                    Text = option,
                    TextColor3 = Colors.Text,
                    TextSize = 14
                })
                
                optionButton.MouseButton1Click:Connect(function()
                    selectedText.Text = option
                    dropdownArrow.Text = "▼"
                    open = false
                    TweenService:Create(dropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 30)}):Play()
                    callback(option)
                end)
                
                optionButton.MouseEnter:Connect(function()
                    optionButton.BackgroundTransparency = 0.9
                end)
                
                optionButton.MouseLeave:Connect(function()
                    optionButton.BackgroundTransparency = 1
                end)
            end
            
            callback(default)
            
            return dropdown
        end
        
        function tabFunctions:CreateColorPicker(text, default, callback)
            local colorPicker = Library:Create("Frame", {
                Name = text .. "ColorPicker",
                Parent = tabContent,
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 30),
                LayoutOrder = #tabContent:GetChildren()
            })
            
            Library:Create("UICorner", {
                Parent = colorPicker,
                CornerRadius = UDim.new(0, 4)
            })
            
            local colorText = Library:Create("TextLabel", {
                Name = "Text",
                Parent = colorPicker,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local colorDisplay = Library:Create("Frame", {
                Name = "Display",
                Parent = colorPicker,
                BackgroundColor3 = default,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -40, 0.5, -10),
                Size = UDim2.new(0, 30, 0, 20)
            })
            
            Library:Create("UICorner", {
                Parent = colorDisplay,
                CornerRadius = UDim.new(0, 4)
            })
            
            colorDisplay.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local colors = {
                        Color3.fromRGB(255, 0, 0),
                        Color3.fromRGB(255, 165, 0),
                        Color3.fromRGB(255, 255, 0),
                        Color3.fromRGB(0, 255, 0),
                        Color3.fromRGB(0, 0, 255),
                        Color3.fromRGB(128, 0, 128),
                        Color3.fromRGB(255, 0, 255),
                        Color3.fromRGB(0, 0, 0),
                        Color3.fromRGB(255, 255, 255)
                    }
                    
                    local colorMenu = Library:Create("Frame", {
                        Name = "ColorMenu",
                        Parent = colorPicker,
                        BackgroundColor3 = Colors.Secondary,
                        BorderSizePixel = 0,
                        Position = UDim2.new(1, -160, 0, 30),
                        Size = UDim2.new(0, 150, 0, 150),
                        ZIndex = 10
                    })
                    
                    Library:Create("UICorner", {
                        Parent = colorMenu,
                        CornerRadius = UDim.new(0, 4)
                    })
                    
                    local colorGrid = Library:Create("Frame", {
                        Name = "Grid",
                        Parent = colorMenu,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 5, 0, 5),
                        Size = UDim2.new(1, -10, 1, -10),
                        ZIndex = 10
                    })
                    
                    local gridLayout = Library:Create("UIGridLayout", {
                        Parent = colorGrid,
                        CellPadding = UDim2.new(0, 5, 0, 5),
                        CellSize = UDim2.new(0, 40, 0, 40),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })
                    
                    for _, color in ipairs(colors) do
                        local colorButton = Library:Create("TextButton", {
                            Name = "ColorButton",
                            Parent = colorGrid,
                            BackgroundColor3 = color,
                            BorderSizePixel = 0,
                            Size = UDim2.new(0, 40, 0, 40),
                            Text = "",
                            ZIndex = 10
                        })
                        
                        Library:Create("UICorner", {
                            Parent = colorButton,
                            CornerRadius = UDim.new(0, 4)
                        })
                        
                        colorButton.MouseButton1Click:Connect(function()
                            colorDisplay.BackgroundColor3 = color
                            colorMenu:Destroy()
                            callback(color)
                        end)
                    end
                    
                    local closeDetection
                    closeDetection = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            local position = input.Position
                            local x = position.X
                            local y = position.Y
                            local menuPos = colorMenu.AbsolutePosition
                            local menuSize = colorMenu.AbsoluteSize
                            if not (x >= menuPos.X and x <= menuPos.X + menuSize.X and y >= menuPos.Y and y <= menuPos.Y + menuSize.Y) then
                                closeDetection:Disconnect()
                            end
                        end
                    end)
                end
            end)
            
            callback(default)
            
            return colorPicker
        end
        
        function tabFunctions:CreateTextbox(text, placeholder, callback)
            local textbox = Library:Create("Frame", {
                Name = text .. "Textbox",
                Parent = tabContent,
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 30),
                LayoutOrder = #tabContent:GetChildren()
            })
            
            Library:Create("UICorner", {
                Parent = textbox,
                CornerRadius = UDim.new(0, 4)
            })
            
            local textboxLabel = Library:Create("TextLabel", {
                Name = "Text",
                Parent = textbox,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(0, 100, 1, 0),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local inputBox = Library:Create("TextBox", {
                Name = "Input",
                Parent = textbox,
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                BorderSizePixel = 0,
                Position = UDim2.new(1, -180, 0.5, -10),
                Size = UDim2.new(0, 170, 0, 20),
                Font = Enum.Font.Gotham,
                PlaceholderText = placeholder,
                Text = "",
                TextColor3 = Colors.Text,
                TextSize = 14,
                ClearTextOnFocus = false
            })
            
            Library:Create("UICorner", {
                Parent = inputBox,
                CornerRadius = UDim.new(0, 4)
            })
            
            inputBox.FocusLost:Connect(function(enterPressed)
                callback(inputBox.Text)
            end)
            
            return textbox
        end
        
        function tabFunctions:CreateKeybind(text, default, callback)
            local keybind = Library:Create("Frame", {
                Name = text .. "Keybind",
                Parent = tabContent,
                BackgroundColor3 = Colors.Secondary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 30),
                LayoutOrder = #tabContent:GetChildren()
            })
            
            Library:Create("UICorner", {
                Parent = keybind,
                CornerRadius = UDim.new(0, 4)
            })
            
            local keybindText = Library:Create("TextLabel", {
                Name = "Text",
                Parent = keybind,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -110, 1, 0),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local keyButton = Library:Create("TextButton", {
                Name = "KeyButton",
                Parent = keybind,
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                BorderSizePixel = 0,
                Position = UDim2.new(1, -100, 0.5, -10),
                Size = UDim2.new(0, 90, 0, 20),
                Font = Enum.Font.Gotham,
                Text = default.Name,
                TextColor3 = Colors.Text,
                TextSize = 14
            })
            
            Library:Create("UICorner", {
                Parent = keyButton,
                CornerRadius = UDim.new(0, 4)
            })
            
            local listening = false
            local currentKey = default
            
            keyButton.MouseButton1Click:Connect(function()
                listening = true
                keyButton.Text = "..."
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed then
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        listening = false
                        currentKey = input.KeyCode
                        keyButton.Text = input.KeyCode.Name
                        callback(input.KeyCode)
                    elseif not listening and input.KeyCode == currentKey then
                        callback(currentKey)
                    end
                end
            end)
            
            return keybind
        end
        
        return tabFunctions
    end
    
    function Library:SelectTab(name)
        for i, button in ipairs(TabButtons) do
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            if button.Text == name then
                TweenService:Create(button, tweenInfo, {BackgroundColor3 = Colors.Accent, TextColor3 = Colors.Text}):Play()
            else
                TweenService:Create(button, tweenInfo, {BackgroundColor3 = Colors.Secondary, TextColor3 = Colors.TextSecondary}):Play()
            end
        end
        
        for i, tab in ipairs(Tabs) do
            tab.Visible = tab.Name == name .. "Tab"
        end
    end
    
    CloseButton.MouseButton1Click:Connect(function()
        ObvilionXGUI:Destroy()
    end)
    
    return Library
end

ObvilionX.Features = {}

function ObvilionX.Features:LoadDaHood()
    function ObvilionX.Features.DaHood:CreateESP()
        local ESP = {}
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local Camera = workspace.CurrentCamera
        local LocalPlayer = Players.LocalPlayer
        
        function ESP:CreateBox(player)
            local box = Drawing.new("Square")
            box.Visible = false
            box.Color = Color3.fromRGB(255, 0, 0)
            box.Thickness = 1
            box.Transparency = 1
            box.Filled = false
            
            local name = Drawing.new("Text")
            name.Visible = false
            name.Color = Color3.fromRGB(255, 255, 255)
            name.Size = 14
            name.Center = true
            name.Outline = true
            
            local distance = Drawing.new("Text")
            distance.Visible = false
            distance.Color = Color3.fromRGB(255, 255, 255)
            distance.Size = 12
            distance.Center = true
            distance.Outline = true
            
            local healthBar = Drawing.new("Square")
            healthBar.Visible = false
            healthBar.Color = Color3.fromRGB(0, 255, 0)
            healthBar.Thickness = 1
            healthBar.Filled = true
            
            local healthBarOutline = Drawing.new("Square")
            healthBarOutline.Visible = false
            healthBarOutline.Color = Color3.fromRGB(0, 0, 0)
            healthBarOutline.Thickness = 1
            healthBarOutline.Filled = false
            
            RunService:BindToRenderStep("ESP_" .. player.Name, 1, function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player ~= LocalPlayer and player.Character:FindFirstChild("Head") then
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    local head = player.Character:FindFirstChild("Head")
                    local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    local hrpPos = Camera:WorldToViewportPoint(hrp.Position)
                    local dist = (hrp.Position - Camera.CFrame.Position).Magnitude
                    
                    if onScreen then
                        local size = 1 / (dist / 10) * 100
                        local boxSize = Vector2.new(size, size * 1.5)
                        box.Size = boxSize
                        box.Position = Vector2.new(hrpPos.X - boxSize.X / 2, hrpPos.Y - boxSize.Y / 2)
                        box.Visible = true
                        name.Position = Vector2.new(hrpPos.X, hrpPos.Y - boxSize.Y / 2 - 15)
                        name.Text = player.Name
                        name.Visible = true
                        distance.Position = Vector2.new(hrpPos.X, hrpPos.Y + boxSize.Y / 2 + 5)
                        distance.Text = math.floor(dist) .. " studs"
                        distance.Visible = true
                        healthBarOutline.Size = Vector2.new(3, boxSize.Y)
                        healthBarOutline.Position = Vector2.new(box.Position.X - 6, box.Position.Y)
                        healthBarOutline.Visible = true
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        healthBar.Size = Vector2.new(2, boxSize.Y * healthPercent)
                        healthBar.Position = Vector2.new(box.Position.X - 5.5, box.Position.Y + boxSize.Y * (1 - healthPercent))
                        healthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                        healthBar.Visible = true
                    else
                        box.Visible = false
                        name.Visible = false
                        distance.Visible = false
                        healthBar.Visible = false
                        healthBarOutline.Visible = false
                    end
                else
                    box.Visible = false
                    name.Visible = false
                    distance.Visible = false
                    healthBar.Visible = false
                    healthBarOutline.Visible = false
                end
            end)
            
            return {
                box = box,
                name = name,
                distance = distance,
                healthBar = healthBar,
                healthBarOutline = healthBarOutline,
                remove = function()
                    RunService:UnbindFromRenderStep("ESP_" .. player.Name)
                    box:Remove()
                    name:Remove()
                    distance:Remove()
                    healthBar:Remove()
                    healthBarOutline:Remove()
                end
            }
        end
        
        local playerESP = {}
        
        function ESP:Toggle(enabled)
            ESP.Enabled = enabled
            if enabled then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and not playerESP[player] then
                        playerESP[player] = ESP:CreateBox(player)
                    end
                end
                ESP.PlayerAddedConnection = Players.PlayerAdded:Connect(function(player)
                    playerESP[player] = ESP:CreateBox(player)
                end)
                ESP.PlayerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
                    if playerESP[player] then
                        playerESP[player].remove()
                        playerESP[player] = nil
                    end
                end)
            else
                if ESP.PlayerAddedConnection then
                    ESP.PlayerAddedConnection:Disconnect()
                end
                if ESP.PlayerRemovingConnection then
                    ESP.PlayerRemovingConnection:Disconnect()
                end
                for player, esp in pairs(playerESP) do
                    esp.remove()
                    playerESP[player] = nil
                end
            end
        end
        
        return ESP
    end
    
    function ObvilionX.Features.DaHood:CreateAimbot()
        local Aimbot = {}
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local Camera = workspace.CurrentCamera
        local LocalPlayer = Players.LocalPlayer
        
        Aimbot.Enabled = false
        Aimbot.TeamCheck = true
        Aimbot.VisibilityCheck = true
        Aimbot.TargetPart = "Head"
        Aimbot.FOV = 100
        Aimbot.Smoothness = 2
        Aimbot.Key = Enum.KeyCode.Q
        
        local fovCircle = Drawing.new("Circle")
        fovCircle.Visible = false
        fovCircle.Radius = Aimbot.FOV
        fovCircle.Color = Colors.Accent
        fovCircle.Thickness = 1
        fovCircle.Filled = false
        fovCircle.Transparency = 1
        
        function Aimbot:GetClosestPlayer()
            local target = nil
            local maxDistance = Aimbot.FOV
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    if Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
                        continue
                    end
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild(Aimbot.TargetPart) then
                        if player.Character.Humanoid.Health <= 0 then
                            continue
                        end
                        local part = player.Character[Aimbot.TargetPart]
                        local partPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if not onScreen then
                            continue
                        end
                        if Aimbot.VisibilityCheck then
                            local ray = Ray.new(Camera.CFrame.Position, part.Position - Camera.CFrame.Position)
                            local hit, _ = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, player.Character})
                            if hit then
                                continue
                            end
                        end
                        local distance = (Vector2.new(partPos.X, partPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                        if distance < maxDistance then
                            maxDistance = distance
                            target = player
                        end
                    end
                end
            end
            return target
        end
        
        RunService:BindToRenderStep("Aimbot", 1, function()
            fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            fovCircle.Radius = Aimbot.FOV
            fovCircle.Visible = Aimbot.Enabled
            if Aimbot.Enabled and UserInputService:IsKeyDown(Aimbot.Key) then
                local target = Aimbot:GetClosestPlayer()
                if target then
                    local targetPart = target.Character[Aimbot.TargetPart]
                    local targetPos = Camera:WorldToViewportPoint(targetPart.Position)
                    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local aimPos = Vector2.new(targetPos.X, targetPos.Y)
                    local distance = (aimPos - mousePos) / Aimbot.Smoothness
                    mousemoverel(distance.X, distance.Y)
                end
            end
        end)
        
        return Aimbot
    end
end

function ObvilionX:Initialize()
    local gameId = game.PlaceId
    local supportedGame = nil
    for name, id in pairs(ObvilionX.GameSupport) do
        if id == gameId then
            supportedGame = name
            break
        end
    end
    ObvilionX.UI = Library:CreateUI()
    if supportedGame then
        if supportedGame == "Da Hood" then
            ObvilionX.Features.DaHood = {}
            ObvilionX.Features:LoadDaHood()
            local mainTab = ObvilionX.UI:CreateTab("Main")
            local combatTab = ObvilionX.UI:CreateTab("Combat")
            local visualsTab = ObvilionX.UI:CreateTab("Visuals")
            local miscTab = ObvilionX.UI:CreateTab("Misc")
            local espSection = visualsTab:CreateSection("ESP")
            local espEnabled = visualsTab:CreateToggle("Player ESP", false, function(value)
                ObvilionX.Features.DaHood:CreateESP():Toggle(value)
            end)
            local aimbotSection = combatTab:CreateSection("Aimbot")
            local aimbotEnabled = combatTab:CreateToggle("Aimbot", false, function(value)
                local aimbot = ObvilionX.Features.DaHood:CreateAimbot()
                aimbot.Enabled = value
            end)
            local aimbotFov = combatTab:CreateSlider("FOV", 10, 400, 100, function(value)
                local aimbot = ObvilionX.Features.DaHood:CreateAimbot()
                aimbot.FOV = value
            end)
            local aimbotSmoothness = combatTab:CreateSlider("Smoothness", 1, 10, 2, function(value)
                local aimbot = ObvilionX.Features.DaHood:CreateAimbot()
                aimbot.Smoothness = value
            end)
            local aimbotTargetPart = combatTab:CreateDropdown("Target Part", {"Head", "HumanoidRootPart", "Torso"}, "Head", function(value)
                local aimbot = ObvilionX.Features.DaHood:CreateAimbot()
                aimbot.TargetPart = value
            end)
            local miscSection = miscTab:CreateSection("Miscellaneous")
            local walkspeedEnabled = miscTab:CreateToggle("WalkSpeed", false, function(value)
                if value then
                    LocalPlayer.Character.Humanoid.WalkSpeed = 32
                else
                    LocalPlayer.Character.Humanoid.WalkSpeed = 16
                end
            end)
            local jumpPowerEnabled = miscTab:CreateToggle("JumpPower", false, function(value)
                if value then
                    LocalPlayer.Character.Humanoid.JumpPower = 75
                else
                    LocalPlayer.Character.Humanoid.JumpPower = 50
                end
            end)
            local noClip = miscTab:CreateToggle("NoClip", false, function(value)
                if value then
                    local noclip = RunService.Stepped:Connect(function()
                        if LocalPlayer.Character then
                            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                        end
                    end)
                    miscTab._noclipConnection = noclip
                else
                    if miscTab._noclipConnection then
                        miscTab._noclipConnection:Disconnect()
                    end
                    if LocalPlayer.Character then
                        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = true
                            end
                        end
                    end
                end
            end)
        elseif supportedGame == "Flee the Facility" then
        elseif supportedGame == "Prison Life" then
        elseif supportedGame == "Jailbreak" then
        elseif supportedGame == "Murder Mystery 2" then
        end
    else
        local mainTab = ObvilionX.UI:CreateTab("Main")
        local infoSection = mainTab:CreateSection("Information")
        mainTab:CreateButton("Game Not Supported", function()
        end)
    end
end

ObvilionX:Initialize()

return ObvilionX
