--[[
    Simple Roblox UI Library for Executor
    Author: Claude
    Features: Window, Button, Slider, Toggle, Label
]]

local UILibrary = {}
UILibrary.__index = UILibrary

-- Colors and styling
local theme = {
    Background = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(0, 120, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Secondary = Color3.fromRGB(50, 50, 50),
    Tertiary = Color3.fromRGB(70, 70, 70),
    Success = Color3.fromRGB(0, 200, 0),
    Error = Color3.fromRGB(255, 0, 0)
}

function UILibrary:CreateWindow(title, position)
    local window = {}
    setmetatable(window, UILibrary)
    
    -- Create the main frame
    window.MainFrame = Instance.new("Frame")
    window.MainFrame.Name = "UILibraryWindow"
    window.MainFrame.Size = UDim2.new(0, 300, 0, 350)
    window.MainFrame.Position = position or UDim2.new(0.5, -150, 0.5, -175)
    window.MainFrame.BackgroundColor3 = theme.Background
    window.MainFrame.BorderSizePixel = 0
    window.MainFrame.Active = true
    window.MainFrame.Draggable = true
    window.MainFrame.Parent = game:GetService("CoreGui"):FindFirstChild("UILibrary") or (function()
        local folder = Instance.new("Folder")
        folder.Name = "UILibrary"
        folder.Parent = game:GetService("CoreGui")
        return folder
    end)()
    
    -- Create title bar
    window.TitleBar = Instance.new("Frame")
    window.TitleBar.Name = "TitleBar"
    window.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    window.TitleBar.BackgroundColor3 = theme.Accent
    window.TitleBar.BorderSizePixel = 0
    window.TitleBar.Parent = window.MainFrame
    
    -- Create title text
    window.TitleText = Instance.new("TextLabel")
    window.TitleText.Name = "TitleText"
    window.TitleText.Size = UDim2.new(1, -30, 1, 0)
    window.TitleText.Position = UDim2.new(0, 10, 0, 0)
    window.TitleText.BackgroundTransparency = 1
    window.TitleText.TextColor3 = theme.Text
    window.TitleText.TextSize = 18
    window.TitleText.Font = Enum.Font.SourceSansBold
    window.TitleText.Text = title or "UI Library"
    window.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    window.TitleText.Parent = window.TitleBar
    
    -- Create close button
    window.CloseButton = Instance.new("TextButton")
    window.CloseButton.Name = "CloseButton"
    window.CloseButton.Size = UDim2.new(0, 20, 0, 20)
    window.CloseButton.Position = UDim2.new(1, -25, 0, 5)
    window.CloseButton.BackgroundColor3 = theme.Error
    window.CloseButton.BorderSizePixel = 0
    window.CloseButton.Text = "X"
    window.CloseButton.TextColor3 = theme.Text
    window.CloseButton.Font = Enum.Font.SourceSansBold
    window.CloseButton.TextSize = 14
    window.CloseButton.Parent = window.TitleBar
    
    window.CloseButton.MouseButton1Click:Connect(function()
        window.MainFrame:Destroy()
    end)
    
    -- Create content container
    window.ContentFrame = Instance.new("ScrollingFrame")
    window.ContentFrame.Name = "ContentFrame"
    window.ContentFrame.Size = UDim2.new(1, -20, 1, -40)
    window.ContentFrame.Position = UDim2.new(0, 10, 0, 35)
    window.ContentFrame.BackgroundTransparency = 1
    window.ContentFrame.ScrollBarThickness = 5
    window.ContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    window.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    window.ContentFrame.Parent = window.MainFrame
    
    window.ElementCount = 0
    window.ElementHeight = 35
    window.ElementPadding = 5
    
    -- Function to update canvas size
    window.UpdateCanvasSize = function()
        window.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, window.ElementCount * (window.ElementHeight + window.ElementPadding))
    end
    
    return window
end

function UILibrary:AddButton(text, callback)
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. text
    button.Size = UDim2.new(1, 0, 0, self.ElementHeight)
    button.Position = UDim2.new(0, 0, 0, self.ElementCount * (self.ElementHeight + self.ElementPadding))
    button.BackgroundColor3 = theme.Secondary
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = theme.Text
    button.Font = Enum.Font.SourceSans
    button.TextSize = 16
    button.Parent = self.ContentFrame
    
    button.MouseButton1Click:Connect(function()
        button.BackgroundColor3 = theme.Accent
        callback()
        wait(0.2)
        button.BackgroundColor3 = theme.Secondary
    end)
    
    self.ElementCount = self.ElementCount + 1
    self:UpdateCanvasSize()
    
    return button
end

function UILibrary:AddToggle(text, default, callback)
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = "ToggleContainer_" .. text
    toggleContainer.Size = UDim2.new(1, 0, 0, self.ElementHeight)
    toggleContainer.Position = UDim2.new(0, 0, 0, self.ElementCount * (self.ElementHeight + self.ElementPadding))
    toggleContainer.BackgroundColor3 = theme.Secondary
    toggleContainer.BorderSizePixel = 0
    toggleContainer.Parent = self.ContentFrame
    
    local toggleText = Instance.new("TextLabel")
    toggleText.Name = "ToggleText"
    toggleText.Size = UDim2.new(0.7, 0, 1, 0)
    toggleText.Position = UDim2.new(0, 10, 0, 0)
    toggleText.BackgroundTransparency = 1
    toggleText.TextColor3 = theme.Text
    toggleText.Font = Enum.Font.SourceSans
    toggleText.TextSize = 16
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    toggleText.Text = text
    toggleText.Parent = toggleContainer
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 40, 0, 20)
    toggleButton.Position = UDim2.new(1, -50, 0.5, -10)
    toggleButton.BackgroundColor3 = default and theme.Success or theme.Error
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleContainer
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "ToggleCircle"
    toggleCircle.Size = UDim2.new(0, 16, 0, 16)
    toggleCircle.Position = UDim2.new(default and 0.6 or 0, 2, 0, 2)
    toggleCircle.BackgroundColor3 = theme.Text
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleButton
    
    local toggled = default or false
    
    local toggle = {}
    toggle.Value = toggled
    
    toggleContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggled = not toggled
            toggle.Value = toggled
            toggleButton.BackgroundColor3 = toggled and theme.Success or theme.Error
            toggleCircle:TweenPosition(
                UDim2.new(toggled and 0.6 or 0, 2, 0, 2),
                Enum.EasingDirection.InOut,
                Enum.EasingStyle.Quad,
                0.2,
                true
            )
            callback(toggled)
        end
    end)
    
    self.ElementCount = self.ElementCount + 1
    self:UpdateCanvasSize()
    
    return toggle
end

function UILibrary:AddSlider(text, min, max, default, precision, callback)
    min = min or 0
    max = max or 100
    default = default or min
    precision = precision or 1
    
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = "SliderContainer_" .. text
    sliderContainer.Size = UDim2.new(1, 0, 0, self.ElementHeight * 1.5)
    sliderContainer.Position = UDim2.new(0, 0, 0, self.ElementCount * (self.ElementHeight + self.ElementPadding))
    sliderContainer.BackgroundColor3 = theme.Secondary
    sliderContainer.BorderSizePixel = 0
    sliderContainer.Parent = self.ContentFrame
    
    local sliderText = Instance.new("TextLabel")
    sliderText.Name = "SliderText"
    sliderText.Size = UDim2.new(1, -110, 0, 20)
    sliderText.Position = UDim2.new(0, 10, 0, 5)
    sliderText.BackgroundTransparency = 1
    sliderText.TextColor3 = theme.Text
    sliderText.Font = Enum.Font.SourceSans
    sliderText.TextSize = 16
    sliderText.TextXAlignment = Enum.TextXAlignment.Left
    sliderText.Text = text
    sliderText.Parent = sliderContainer
    
    local valueText = Instance.new("TextLabel")
    valueText.Name = "ValueText"
    valueText.Size = UDim2.new(0, 100, 0, 20)
    valueText.Position = UDim2.new(1, -110, 0, 5)
    valueText.BackgroundTransparency = 1
    valueText.TextColor3 = theme.Text
    valueText.Font = Enum.Font.SourceSans
    valueText.TextSize = 16
    valueText.Text = tostring(default)
    valueText.Parent = sliderContainer
    
    local sliderBackground = Instance.new("Frame")
    sliderBackground.Name = "SliderBackground"
    sliderBackground.Size = UDim2.new(1, -20, 0, 5)
    sliderBackground.Position = UDim2.new(0, 10, 0, 30)
    sliderBackground.BackgroundColor3 = theme.Tertiary
    sliderBackground.BorderSizePixel = 0
    sliderBackground.Parent = sliderContainer
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = theme.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBackground
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 10, 0, 15)
    sliderButton.Position = UDim2.new((default - min) / (max - min), -5, 0, -5)
    sliderButton.BackgroundColor3 = theme.Text
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderBackground
    
    local value = default
    local slider = {}
    slider.Value = value
    
    local function updateSlider(input)
        local relativePos = math.clamp((input.Position.X - sliderBackground.AbsolutePosition.X) / sliderBackground.AbsoluteSize.X, 0, 1)
        local newValue = min + ((max - min) * relativePos)
        
        -- Apply precision (rounding)
        newValue = math.floor(newValue / precision + 0.5) * precision
        
        if newValue ~= value then
            value = newValue
            slider.Value = value
            valueText.Text = tostring(value)
            sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativePos, -5, 0, -5)
            callback(value)
        end
    end
    
    local dragging = false
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    sliderBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateSlider(input)
            dragging = true
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    self.ElementCount = self.ElementCount + 1.5
    self:UpdateCanvasSize()
    
    return slider
end

function UILibrary:AddLabel(text)
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, self.ElementHeight * 0.8)
    label.Position = UDim2.new(0, 0, 0, self.ElementCount * (self.ElementHeight + self.ElementPadding))
    label.BackgroundColor3 = theme.Secondary
    label.BorderSizePixel = 0
    label.TextColor3 = theme.Text
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.Text = text
    label.Parent = self.ContentFrame
    
    self.ElementCount = self.ElementCount + 0.8
    self:UpdateCanvasSize()
    
    return label
end

function UILibrary:AddDropdown(text, options, default, callback)
    local dropdownContainer = Instance.new("Frame")
    dropdownContainer.Name = "DropdownContainer_" .. text
    dropdownContainer.Size = UDim2.new(1, 0, 0, self.ElementHeight)
    dropdownContainer.Position = UDim2.new(0, 0, 0, self.ElementCount * (self.ElementHeight + self.ElementPadding))
    dropdownContainer.BackgroundColor3 = theme.Secondary
    dropdownContainer.BorderSizePixel = 0
    dropdownContainer.Parent = self.ContentFrame
    
    local dropdownText = Instance.new("TextLabel")
    dropdownText.Name = "DropdownText"
    dropdownText.Size = UDim2.new(0.5, 0, 1, 0)
    dropdownText.Position = UDim2.new(0, 10, 0, 0)
    dropdownText.BackgroundTransparency = 1
    dropdownText.TextColor3 = theme.Text
    dropdownText.Font = Enum.Font.SourceSans
    dropdownText.TextSize = 16
    dropdownText.TextXAlignment = Enum.TextXAlignment.Left
    dropdownText.Text = text
    dropdownText.Parent = dropdownContainer
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(0.4, 0, 0.8, 0)
    dropdownButton.Position = UDim2.new(0.58, 0, 0.1, 0)
    dropdownButton.BackgroundColor3 = theme.Tertiary
    dropdownButton.BorderSizePixel = 0
    dropdownButton.TextColor3 = theme.Text
    dropdownButton.Font = Enum.Font.SourceSans
    dropdownButton.TextSize = 14
    dropdownButton.Text = default or options[1] or "Select"
    dropdownButton.Parent = dropdownContainer
    
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Name = "OptionsFrame"
    optionsFrame.Size = UDim2.new(0.4, 0, 0, 0)
    optionsFrame.Position = UDim2.new(0.58, 0, 1, 0)
    optionsFrame.BackgroundColor3 = theme.Tertiary
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Visible = false
    optionsFrame.ZIndex = 10
    optionsFrame.Parent = dropdownContainer
    
    local currentValue = default or options[1] or "Select"
    local dropdown = {}
    dropdown.Value = currentValue
    
    local isOpen = false
    
    local function closeDropdown()
        isOpen = false
        optionsFrame:TweenSize(
            UDim2.new(0.4, 0, 0, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.2,
            true,
            function()
                optionsFrame.Visible = false
            end
        )
    end
    
    local function openDropdown()
        isOpen = true
        optionsFrame.Visible = true
        optionsFrame:TweenSize(
            UDim2.new(0.4, 0, 0, #options * 25),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.2,
            true
        )
    end
    
    dropdownButton.MouseButton1Click:Connect(function()
        if isOpen then
            closeDropdown()
        else
            openDropdown()
        end
    end)
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option_" .. option
        optionButton.Size = UDim2.new(1, 0, 0, 25)
        optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 25)
        optionButton.BackgroundColor3 = theme.Tertiary
        optionButton.BorderSizePixel = 0
        optionButton.TextColor3 = theme.Text
        optionButton.Font = Enum.Font.SourceSans
        optionButton.TextSize = 14
        optionButton.Text = option
        optionButton.ZIndex = 10
        optionButton.Parent = optionsFrame
        
        optionButton.MouseButton1Click:Connect(function()
            currentValue = option
            dropdown.Value = currentValue
            dropdownButton.Text = option
            closeDropdown()
            callback(option)
        end)
    end
    
    -- Close dropdown when clicking outside
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local isInFrame = mousePos.X >= optionsFrame.AbsolutePosition.X and
                              mousePos.X <= optionsFrame.AbsolutePosition.X + optionsFrame.AbsoluteSize.X and
                              mousePos.Y >= optionsFrame.AbsolutePosition.Y and
                              mousePos.Y <= optionsFrame.AbsolutePosition.Y + optionsFrame.AbsoluteSize.Y
            
            if isOpen and not isInFrame and not (mousePos.X >= dropdownButton.AbsolutePosition.X and
                              mousePos.X <= dropdownButton.AbsolutePosition.X + dropdownButton.AbsoluteSize.X and
                              mousePos.Y >= dropdownButton.AbsolutePosition.Y and
                              mousePos.Y <= dropdownButton.AbsolutePosition.Y + dropdownButton.AbsoluteSize.Y) then
                closeDropdown()
            end
        end
    end)
    
    self.ElementCount = self.ElementCount + 1
    self:UpdateCanvasSize()
    
    return dropdown
end

function UILibrary:AddSeparator()
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(1, -20, 0, 1)
    separator.Position = UDim2.new(0, 10, 0, self.ElementCount * (self.ElementHeight + self.ElementPadding) + self.ElementPadding/2)
    separator.BackgroundColor3 = theme.Accent
    separator.BorderSizePixel = 0
    separator.Parent = self.ContentFrame
    
    self.ElementCount = self.ElementCount + 0.3
    self:UpdateCanvasSize()
    
    return separator
end

-- Return the library
return UILibrary
