local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
 
-- Настройки
local settings = {
    ["Aspect Ratio"] = false,
    ["Ratio Value"] = 0.6,
    ["Auto Farm"] = false,
    ["Fullbright"] = false,
    ["XRay"] = false,
    ["Infinite Jump"] = false,
    ["ESP"] = false,
    ["No Recoil"] = false,
    ["Auto Sprint"] = false,
    ["Field of View"] = 70
}
 
-- Сохраняем оригинальные настройки
local defaultSettings = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    FieldOfView = camera.FieldOfView
}
 
-- Хук для Aspect Ratio
local oldNewindex
oldNewindex = hookmetamethod(game, "__newindex", function(object, propertyName, propertyValue)
    if object == camera and propertyName == "CFrame" then
        if settings["Aspect Ratio"] then
            propertyValue = propertyValue * CFrame.new(0, 0, 0, 1, 0, 0, 0, settings["Ratio Value"], 0, 0, 0, 1)
        end
    end
    return oldNewindex(object, propertyName, propertyValue)
end)
 
-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeadRailsProV2"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
 
local MenuButton = Instance.new("TextButton")
MenuButton.Size = UDim2.new(0, 35, 0, 35)
MenuButton.Position = UDim2.new(0, 13, 0.5, -25)
MenuButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MenuButton.Text = ">"
MenuButton.TextColor3 = Color3.fromRGB(255, 100, 100)
MenuButton.TextSize = 24
MenuButton.Font = Enum.Font.GothamBold
MenuButton.Parent = ScreenGui
MenuButton.ZIndex = 10
 
local UICornerMenu = Instance.new("UICorner")
UICornerMenu.CornerRadius = UDim.new(1, 0)
UICornerMenu.Parent = MenuButton
 
local MainFrame = Instance.new("Frame")
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(-0.3, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true
 
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame
 
local Title = Instance.new("TextLabel")
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Dead Rails Pro V2"
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame
 
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 100)
ScrollFrame.Parent = MainFrame
 
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollFrame
 
-- Функции создания элементов
local function CreateButton(name, description)
    local Button = Instance.new("TextButton")
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Button.Size = UDim2.new(1, 0, 0, 60)
    Button.Text = ""
    Button.AutoButtonColor = false
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Button
    
    local Title = Instance.new("TextLabel")
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.Size = UDim2.new(1, -80, 0, 25)
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Button
    
    local Description = Instance.new("TextLabel")
    Description.BackgroundTransparency = 1
    Description.Position = UDim2.new(0, 10, 0, 30)
    Description.Size = UDim2.new(1, -80, 0, 20)
    Description.Text = description
    Description.TextColor3 = Color3.fromRGB(200, 200, 200)
    Description.TextSize = 14
    Description.Font = Enum.Font.Gotham
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.Parent = Button
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0, 50, 0, 24)
    ToggleFrame.Position = UDim2.new(1, -60, 0.5, -12)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    ToggleFrame.Parent = Button
    
    local UICornerToggle = Instance.new("UICorner")
    UICornerToggle.CornerRadius = UDim.new(1, 0)
    UICornerToggle.Parent = ToggleFrame
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleCircle.Parent = ToggleFrame
    
    local UICornerCircle = Instance.new("UICorner")
    UICornerCircle.CornerRadius = UDim.new(1, 0)
    UICornerCircle.Parent = ToggleCircle
    
    Button.Parent = ScrollFrame
    return Button, ToggleFrame, ToggleCircle
end
 
-- Создание слайдера
local function CreateSlider(parent, defaultValue)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(0.8, 0, 0, 30)
    SliderFrame.Position = UDim2.new(0.1, 0, 1.1, 0)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SliderFrame.Parent = parent
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(defaultValue, 0, 1, 0)
    SliderBar.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    SliderBar.Parent = SliderFrame
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 6)
    UICorner2.Parent = SliderBar
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(1, 0, 1, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(defaultValue)
    ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 14
    ValueLabel.Parent = SliderFrame
    
    return SliderFrame, SliderBar, ValueLabel
end
 
-- Функции создания модулей
local function CreateSpeedHack()
    local enabled = false
    local button, toggleFrame, toggleCircle = CreateButton("Speed Hack", "Увеличение скорости")
    
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 28
            end
            TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(100, 255, 100)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
            TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
        end
    end)
end
 
local function CreateJumpHack()
    local enabled = false
    local button, toggleFrame, toggleCircle = CreateButton("Jump Hack", "Увеличение высоты прыжка")
    
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.JumpPower = 45
            end
            TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(100, 255, 100)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.JumpPower = 50
            end
            TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
        end
    end)
end
 
local function CreateNoclip()
    local enabled = false
    local button, toggleFrame, toggleCircle = CreateButton("Noclip", "Проход сквозь стены")
    local connection
    
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            connection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(100, 255, 100)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
        else
            if connection then
                connection:Disconnect()
            end
            TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
        end
    end)
end
 
local function CreateAimbot()
    local enabled = false
    local button, toggleFrame, toggleCircle = CreateButton("Aimbot", "Автонаведение на NPC")
    local connection
    
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            connection = RunService.RenderStepped:Connect(function()
                if LocalPlayer.Character then
                    local closestNPC = nil
                    local minDistance = math.huge
                    
                    for _, npc in pairs(workspace:GetDescendants()) do
                        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(npc) then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                            if distance < minDistance then
                                minDistance = distance
                                closestNPC = npc
                            end
                        end
                    end
                    
                    if closestNPC and closestNPC:FindFirstChild("Head") then
                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestNPC.Head.Position)
                    end
                end
            end)
            TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(100, 255, 100)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
        else
            if connection then
                connection:Disconnect()
            end
            TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
        end
    end)
end
 
local function CreateAspectRatio()
    local enabled = false
    local button, toggleFrame, toggleCircle = CreateButton("Aspect Ratio", "Изменение соотношения сторон")
    local sliderFrame, sliderBar, valueLabel = CreateSlider(button, settings["Ratio Value"])
    
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        settings["Aspect Ratio"] = enabled
        
        if enabled then
            TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(100, 255, 100)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
        else
            TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
        end
    end)
    
    -- Слайдер
    local isDragging = false
    
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local framePos = sliderFrame.AbsolutePosition
            local frameSize = sliderFrame.AbsoluteSize
            
            local ratio = math.clamp((mousePos.X - framePos.X) / frameSize.X, 0, 1)
            settings["Ratio Value"] = ratio
            
            sliderBar.Size = UDim2.new(ratio, 0, 1, 0)
            valueLabel.Text = string.format("%.2f", ratio)
        end
    end)
end
 
local function CreateFullbright()
    local enabled = false
    local button, toggleFrame, toggleCircle = CreateButton("Fullbright", "Максимальная яркость")
    
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        settings["Fullbright"] = enabled
        
        if enabled then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            
            TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(100, 255, 100)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
        else
            Lighting.Brightness = defaultSettings.Brightness
            Lighting.ClockTime = defaultSettings.ClockTime
            Lighting.FogEnd = defaultSettings.FogEnd
            Lighting.GlobalShadows = defaultSettings.GlobalShadows
            Lighting.Ambient = defaultSettings.Ambient
            
            TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
        end
    end)
end
 
local function CreateAutoFarm()
    local enabled = false
    local button, toggleFrame, toggleCircle = CreateButton("Auto Farm", "Автоматический сбор ресурсов")
    local farmConnection
    
    local function collectResources()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = LocalPlayer.Character.HumanoidRootPart
            
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name:find("Collect") or v.Name:find("Resource") or v.Name:find("Pickup")) then
                    local distance = (rootPart.Position - v.Position).magnitude
                    
                    if distance < 50 then
                        -- Телепортация к ресурсу
                        local tweenInfo = TweenInfo.new(
                            distance/100,
                            Enum.EasingStyle.Linear,
                            Enum.EasingDirection.Out,
                            0,
                            false,
                            0
                        )
                        
                        local tween = TweenService:Create(rootPart, tweenInfo, {
                            CFrame = CFrame.new(v.Position + Vector3.new(0, 3, 0))
                        })
                        
                        tween:Play()
                        tween.Completed:Wait()
                        wait(0.5)
                    end
                end
            end
        end
    end
    
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        settings["Auto Farm"] = enabled
        
        if enabled then
            farmConnection = RunService.Heartbeat:Connect(collectResources)
            TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(100, 255, 100)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
        else
            if farmConnection then
                farmConnection:Disconnect()
            end
            TweenService:Create(toggleFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
        end
    end)
end
 
-- Создание всех модулей
CreateSpeedHack()
CreateJumpHack()
CreateNoclip()
CreateAimbot()
CreateAspectRatio()
CreateFullbright()
CreateAutoFarm()
 
-- Анимация меню
local menuOpen = false
MenuButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    TweenService:Create(MenuButton, TweenInfo.new(0.3), {
        Rotation = menuOpen and 180 or 0,
        TextColor3 = menuOpen and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    }):Play()
    
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
        Position = menuOpen and UDim2.new(0.1, 0, 0.1, 0) or UDim2.new(-0.3, 0, 0.1, 0)
    }):Play()
end)
 
-- Перетаскивание окна
local dragging = false
local dragStart = nil
local startPos = nil
 
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
 
Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
 
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
 
-- Обновление размера скролла
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
