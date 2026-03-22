local HttpService = game:GetService("HttpService")

if not isfolder("Deltrehub") then
	makefolder("Deltrehub")
end
if not isfolder("Deltrehub/Config") then
	makefolder("Deltrehub/Config")
end

local gameName = tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
gameName = gameName:gsub("[^%w_ ]", "")
gameName = gameName:gsub("%s+", "_")

local ConfigFile = "Deltrehub/Config/Data_" .. gameName .. ".json"

ConfigData = {}
Elements = {}
CURRENT_VERSION = nil

local DeltreTheme = {
	Background = Color3.fromRGB(6, 3, 10),
	Surface = Color3.fromRGB(25, 15, 35),
	AccentPrimary = Color3.fromRGB(138, 43, 226),
	AccentSecondary = Color3.fromRGB(255, 0, 255),
	AccentTertiary = Color3.fromRGB(0, 150, 255),
	TextPrimary = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(180, 180, 200),
	NeonOutline = Color3.fromRGB(180, 0, 255),
	Transparency = 0.15,
	CornerRadius = UDim.new(0, 3),
	SmallCornerRadius = UDim.new(0, 1),
}

function SaveConfig()
	if writefile then
		ConfigData._version = CURRENT_VERSION
		writefile(ConfigFile, HttpService:JSONEncode(ConfigData))
	end
end

function LoadConfigFromFile()
	if not CURRENT_VERSION then
		return
	end
	if isfile and isfile(ConfigFile) then
		local success, result = pcall(function()
			return HttpService:JSONDecode(readfile(ConfigFile))
		end)
		if success and type(result) == "table" then
			if result._version == CURRENT_VERSION then
				ConfigData = result
			else
				ConfigData = { _version = CURRENT_VERSION }
			end
		else
			ConfigData = { _version = CURRENT_VERSION }
		end
	else
		ConfigData = { _version = CURRENT_VERSION }
	end
end

function LoadConfigElements()
	for key, element in pairs(Elements) do
		if ConfigData[key] ~= nil and element.Set then
			element:Set(ConfigData[key], true)
		end
	end
end

local Icons = {
	dashboard = "rbxassetid://7734110220", -- activity icon
	home = "rbxassetid://7733920117", -- clipboard-list
	user = "rbxassetid://7733771472", -- user/edit
	player = "rbxassetid://7733771472", -- user/edit
	settings = "rbxassetid://7733765045", -- cpu/settings-like
	menu = "rbxassetid://7734110220", -- activity

	web = "rbxassetid://7733771982", -- external-link
	bag = "rbxassetid://7733917120", -- box
	shop = "rbxassetid://7733674153", -- banknote
	cart = "rbxassetid://7733701715", -- briefcase
	plug = "rbxassetid://7733765045", -- cpu
	loop = "rbxassetid://7733749837", -- code
	gps = "rbxassetid://7733924216", -- compass
	compas = "rbxassetid://7733924216", -- compass
	gamepad = "rbxassetid://7733765307", -- crosshair
	boss = "rbxassetid://7733765398", -- crown
	scroll = "rbxassetid://7733935829", -- file-code
	crosshair = "rbxassetid://7733765307", -- crosshair
	stat = "rbxassetid://7733674319", -- bar-chart
	eyes = "rbxassetid://7733774602", -- eye
	sword = "rbxassetid://7733674079", -- axe/sword-like
	discord = "rbxassetid://7733770843", -- dribbble (closest to discord)
	star = "rbxassetid://7733673800", -- asterisk/star
	skeleton = "rbxassetid://7733765224", -- cross/skull-like
	payment = "rbxassetid://7733770599", -- dollar-sign
	scan = "rbxassetid://7733765307", -- crosshair
	alert = "rbxassetid://7733658504", -- alert-triangle
	question = "rbxassetid://7733658335", -- alert-octagon
	idea = "rbxassetid://7733777166", -- feather/lightbulb-like
	strom = "rbxassetid://7733741741", -- cloud-lightning
	water = "rbxassetid://7733770982", -- droplet
	dcs = "rbxassetid://7733770843", -- dribbble
	start = "rbxassetid://7733919881", -- circle/play
	next = "rbxassetid://7733919682", -- chevrons-right
	rod = "rbxassetid://7733674079", -- axe/rod-like
	fish = "rbxassetid://7733770982", -- droplet/water

	shield = "rbxassetid://7733765224", -- cross/shield-like
	zap = "rbxassetid://7733771628", -- electricity
	target = "rbxassetid://7733765307", -- crosshair
	anchor = "rbxassetid://7733911490", -- anchor
	award = "rbxassetid://7733673987", -- award
	bell = "rbxassetid://7733911828", -- bell
	book = "rbxassetid://7733914390", -- book
	calendar = "rbxassetid://7733919198", -- calendar
	camera = "rbxassetid://7733708692", -- camera
	check = "rbxassetid://7733715400", -- check
	clock = "rbxassetid://7733734848", -- clock
	cloud = "rbxassetid://7733746980", -- cloud
	code = "rbxassetid://7733749837", -- code
	copy = "rbxassetid://7733764083", -- copy
	database = "rbxassetid://7743866778", -- database
	download = "rbxassetid://7733770755", -- download
	file = "rbxassetid://7733793319", -- file
	flag = "rbxassetid://7733765398", -- crown/flag-like
	folder = "rbxassetid://7733917120", -- box/folder
	gift = "rbxassetid://7733765592", -- currency/gift
	globe = "rbxassetid://7733924216", -- compass/globe
	heart = "rbxassetid://7733747233", -- clover/heart-like
	image = "rbxassetid://7733708692", -- camera/image
	inbox = "rbxassetid://7733917120", -- box/inbox
	key = "rbxassetid://7733764536", -- corner-left-up/key-like
	layers = "rbxassetid://7733917120", -- box/layers
	link = "rbxassetid://7733771982", -- external-link
	lock = "rbxassetid://7733764680", -- corner-right-up/lock-like
	map = "rbxassetid://7733924216", -- compass/map
	mail = "rbxassetid://7743866666", -- contact/mail
	message = "rbxassetid://7743866666", -- contact/message
	music = "rbxassetid://7734110220", -- activity/music
	paperclip = "rbxassetid://7733777166", -- feather/paperclip
	phone = "rbxassetid://7733701715", -- car/phone
	power = "rbxassetid://7733771628", -- electricity/power
	radio = "rbxassetid://7733765307", -- crosshair/radio
	save = "rbxassetid://7733770755", -- download/save
	search = "rbxassetid://7733765307", -- crosshair/search
	send = "rbxassetid://7733919682", -- chevrons-right/send
	server = "rbxassetid://7733765045", -- cpu/server
	share = "rbxassetid://7733771982", -- external-link/share
	tag = "rbxassetid://7733673800", -- asterisk/tag
	trash = "rbxassetid://7733768142", -- delete/trash
	upload = "rbxassetid://7733771982", -- external-link/upload
	video = "rbxassetid://7733708692", -- camera/video
	wifi = "rbxassetid://7733687147", -- bluetooth/wifi
}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")
local viewport = workspace.CurrentCamera.ViewportSize

local function isMobileDevice()
	return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
end

local isMobile = isMobileDevice()

local function safeSize(pxWidth, pxHeight)
	local scaleX = pxWidth / viewport.X
	local scaleY = pxHeight / viewport.Y

	if isMobile then
		if scaleX > 0.5 then
			scaleX = 0.5
		end
		if scaleY > 0.3 then
			scaleY = 0.3
		end
	end

	return UDim2.new(scaleX, 0, scaleY, 0)
end

-- Utility function for creating neon gradient buttons
local function CreateNeonGradient(parent, rotation)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.0, DeltreTheme.AccentTertiary),
		ColorSequenceKeypoint.new(0.5, DeltreTheme.AccentPrimary),
		ColorSequenceKeypoint.new(1.0, DeltreTheme.AccentSecondary),
	})
	gradient.Rotation = rotation or 45
	gradient.Parent = parent
	return gradient
end

-- Utility function for neon outline stroke
local function CreateNeonStroke(parent, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = DeltreTheme.NeonOutline
	stroke.Thickness = thickness or 2
	stroke.Transparency = 0.3
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = parent
	return stroke
end

local function MakeDraggable(topbarobject, object)
	local function CustomPos(topbarobject, object)
		local Dragging, DragInput, DragStart, StartPosition

		local function UpdatePos(input)
			local Delta = input.Position - DragStart
			local pos = UDim2.new(
				StartPosition.X.Scale,
				StartPosition.X.Offset + Delta.X,
				StartPosition.Y.Scale,
				StartPosition.Y.Offset + Delta.Y
			)
			local Tween = TweenService:Create(object, TweenInfo.new(0.2, Enum.EasingStyle.Quart), { Position = pos })
			Tween:Play()
		end

		topbarobject.InputBegan:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				Dragging = true
				DragStart = input.Position
				StartPosition = object.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)

		topbarobject.InputChanged:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			then
				DragInput = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == DragInput and Dragging then
				UpdatePos(input)
			end
		end)
	end

	local function CustomSize(object)
		local Dragging, DragInput, DragStart, StartSize

		local minSizeX, minSizeY
		local defSizeX, defSizeY

		if isMobile then
			minSizeX, minSizeY = 100, 100
			defSizeX, defSizeY = 470, 270
		else
			minSizeX, minSizeY = 100, 100
			defSizeX, defSizeY = 640, 400
		end

		object.Size = UDim2.new(0, defSizeX, 0, defSizeY)

		local changesizeobject = Instance.new("Frame")
		changesizeobject.AnchorPoint = Vector2.new(1, 1)
		changesizeobject.BackgroundTransparency = 1
		changesizeobject.Size = UDim2.new(0, 40, 0, 40)
		changesizeobject.Position = UDim2.new(1, 20, 1, 20)
		changesizeobject.Name = "changesizeobject"
		changesizeobject.Parent = object

		local function UpdateSize(input)
			local Delta = input.Position - DragStart
			local newWidth = StartSize.X.Offset + Delta.X
			local newHeight = StartSize.Y.Offset + Delta.Y

			newWidth = math.max(newWidth, minSizeX)
			newHeight = math.max(newHeight, minSizeY)

			local Tween = TweenService:Create(
				object,
				TweenInfo.new(0.2, Enum.EasingStyle.Quart),
				{ Size = UDim2.new(0, newWidth, 0, newHeight) }
			)
			Tween:Play()
		end

		changesizeobject.InputBegan:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				Dragging = true
				DragStart = input.Position
				StartSize = object.Size
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)

		changesizeobject.InputChanged:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			then
				DragInput = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == DragInput and Dragging then
				UpdateSize(input)
			end
		end)
	end

	CustomSize(object)
	CustomPos(topbarobject, object)
end

function CircleClick(Button, X, Y)
	spawn(function()
		Button.ClipsDescendants = true
		local Circle = Instance.new("ImageLabel")
		Circle.Image = "rbxassetid://7734110220"
		Circle.ImageColor3 = DeltreTheme.AccentPrimary
		Circle.ImageTransparency = 0.8
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 1
		Circle.ZIndex = 10
		Circle.Name = "Circle"
		Circle.Parent = Button

		local NewX = X - Circle.AbsolutePosition.X
		local NewY = Y - Circle.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, NewX, 0, NewY)
		local Size = 0
		if Button.AbsoluteSize.X > Button.AbsoluteSize.Y then
			Size = Button.AbsoluteSize.X * 1.5
		elseif Button.AbsoluteSize.X < Button.AbsoluteSize.Y then
			Size = Button.AbsoluteSize.Y * 1.5
		elseif Button.AbsoluteSize.X == Button.AbsoluteSize.Y then
			Size = Button.AbsoluteSize.X * 1.5
		end

		local Time = 0.5
		Circle:TweenSizeAndPosition(
			UDim2.new(0, Size, 0, Size),
			UDim2.new(0.5, -Size / 2, 0.5, -Size / 2),
			"Out",
			"Quad",
			Time,
			false,
			nil
		)
		for i = 1, 10 do
			Circle.ImageTransparency = Circle.ImageTransparency + 0.02
			wait(Time / 10)
		end
		Circle:Destroy()
	end)
end

local Deltrehub = {}
function Deltrehub:MakeNotify(NotifyConfig)
	local NotifyConfig = NotifyConfig or {}
	NotifyConfig.Title = NotifyConfig.Title or "Deltrehub"
	NotifyConfig.Description = NotifyConfig.Description or "Notification"
	NotifyConfig.Content = NotifyConfig.Content or "Content"
	NotifyConfig.Color = NotifyConfig.Color or DeltreTheme.AccentSecondary
	NotifyConfig.Time = NotifyConfig.Time or 0.5
	NotifyConfig.Delay = NotifyConfig.Delay or 5
	local NotifyFunction = {}
	spawn(function()
		if not CoreGui:FindFirstChild("DeltreNotifyGui") then
			local NotifyGui = Instance.new("ScreenGui")
			NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			NotifyGui.Name = "DeltreNotifyGui"
			NotifyGui.Parent = CoreGui
		end
		if not CoreGui.DeltreNotifyGui:FindFirstChild("NotifyLayout") then
			local NotifyLayout = Instance.new("Frame")
			NotifyLayout.AnchorPoint = Vector2.new(1, 1)
			NotifyLayout.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NotifyLayout.BackgroundTransparency = 0.999
			NotifyLayout.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NotifyLayout.BorderSizePixel = 0
			NotifyLayout.Position = UDim2.new(1, -30, 1, -30)
			NotifyLayout.Size = UDim2.new(0, 320, 1, 0)
			NotifyLayout.Name = "NotifyLayout"
			NotifyLayout.Parent = CoreGui.DeltreNotifyGui
			local Count = 0
			CoreGui.DeltreNotifyGui.NotifyLayout.ChildRemoved:Connect(function()
				Count = 0
				for i, v in CoreGui.DeltreNotifyGui.NotifyLayout:GetChildren() do
					TweenService:Create(
						v,
						TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
						{ Position = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 12) * Count)) }
					):Play()
					Count = Count + 1
				end
			end)
		end
		local NotifyPosHeigh = 0
		for i, v in CoreGui.DeltreNotifyGui.NotifyLayout:GetChildren() do
			NotifyPosHeigh = -v.Position.Y.Offset + v.Size.Y.Offset + 12
		end
		local NotifyFrame = Instance.new("Frame")
		local NotifyFrameReal = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local NeonStroke = CreateNeonStroke(NotifyFrameReal, 2)
		local Top = Instance.new("Frame")
		local TextLabel = Instance.new("TextLabel")
		local UICorner1 = Instance.new("UICorner")
		local TextLabel1 = Instance.new("TextLabel")
		local Close = Instance.new("TextButton")
		local ImageLabel = Instance.new("ImageLabel")
		local TextLabel2 = Instance.new("TextLabel")

		NotifyFrame.BackgroundColor3 = DeltreTheme.Background
		NotifyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrame.BorderSizePixel = 0
		NotifyFrame.Size = UDim2.new(1, 0, 0, 150)
		NotifyFrame.Name = "NotifyFrame"
		NotifyFrame.BackgroundTransparency = 1
		NotifyFrame.Parent = CoreGui.DeltreNotifyGui.NotifyLayout
		NotifyFrame.AnchorPoint = Vector2.new(0, 1)
		NotifyFrame.Position = UDim2.new(0, 0, 1, -NotifyPosHeigh)

		NotifyFrameReal.BackgroundColor3 = DeltreTheme.Surface
		NotifyFrameReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrameReal.BorderSizePixel = 0
		NotifyFrameReal.Position = UDim2.new(0, 400, 0, 0)
		NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
		NotifyFrameReal.Name = "NotifyFrameReal"
		NotifyFrameReal.Parent = NotifyFrame

		UICorner.Parent = NotifyFrameReal
		UICorner.CornerRadius = DeltreTheme.CornerRadius

		Top.BackgroundColor3 = DeltreTheme.Background
		Top.BackgroundTransparency = 0.5
		Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Top.BorderSizePixel = 0
		Top.Size = UDim2.new(1, 0, 0, 36)
		Top.Name = "Top"
		Top.Parent = NotifyFrameReal

		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.Text = NotifyConfig.Title
		TextLabel.TextColor3 = DeltreTheme.TextPrimary
		TextLabel.TextSize = 14
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.BackgroundTransparency = 0.999
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Size = UDim2.new(1, 0, 1, 0)
		TextLabel.Parent = Top
		TextLabel.Position = UDim2.new(0, 10, 0, 0)

		UICorner1.Parent = Top
		UICorner1.CornerRadius = DeltreTheme.SmallCornerRadius

		TextLabel1.Font = Enum.Font.GothamBold
		TextLabel1.Text = NotifyConfig.Description
		TextLabel1.TextColor3 = NotifyConfig.Color
		TextLabel1.TextSize = 14
		TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel1.BackgroundTransparency = 0.999
		TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel1.BorderSizePixel = 0
		TextLabel1.Size = UDim2.new(1, 0, 1, 0)
		TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
		TextLabel1.Parent = Top

		Close.Font = Enum.Font.SourceSans
		Close.Text = ""
		Close.TextColor3 = Color3.fromRGB(0, 0, 0)
		Close.TextSize = 14
		Close.AnchorPoint = Vector2.new(1, 0.5)
		Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Close.BackgroundTransparency = 0.999
		Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Close.BorderSizePixel = 0
		Close.Position = UDim2.new(1, -5, 0.5, 0)
		Close.Size = UDim2.new(0, 25, 0, 25)
		Close.Name = "Close"
		Close.Parent = Top

		ImageLabel.Image = "rbxassetid://9886659671"
		ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 0.999
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(0.49000001, 0, 0.5, 0)
		ImageLabel.Size = UDim2.new(1, -8, 1, -8)
		ImageLabel.Parent = Close

		TextLabel2.Font = Enum.Font.GothamBold
		TextLabel2.TextColor3 = DeltreTheme.TextPrimary
		TextLabel2.TextSize = 13
		TextLabel2.Text = NotifyConfig.Content
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
		TextLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel2.BackgroundTransparency = 0.999
		TextLabel2.TextColor3 = DeltreTheme.TextSecondary
		TextLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel2.BorderSizePixel = 0
		TextLabel2.Position = UDim2.new(0, 10, 0, 27)
		TextLabel2.Parent = NotifyFrameReal
		TextLabel2.Size = UDim2.new(1, -20, 0, 13)
		TextLabel2.RichText = true

		TextLabel2.Size = UDim2.new(1, -20, 0, 13 + (13 * (TextLabel2.TextBounds.X // TextLabel2.AbsoluteSize.X)))
		TextLabel2.TextWrapped = true

		if TextLabel2.AbsoluteSize.Y < 27 then
			NotifyFrame.Size = UDim2.new(1, 0, 0, 65)
		else
			NotifyFrame.Size = UDim2.new(1, 0, 0, TextLabel2.AbsoluteSize.Y + 40)
		end
		local waitbruh = false
		function NotifyFunction:Close()
			if waitbruh then
				return false
			end
			waitbruh = true
			TweenService:Create(
				NotifyFrameReal,
				TweenInfo.new(tonumber(NotifyConfig.Time), Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
				{ Position = UDim2.new(0, 400, 0, 0) }
			):Play()
			task.wait(tonumber(NotifyConfig.Time) / 1.2)
			NotifyFrame:Destroy()
		end

		Close.Activated:Connect(function()
			NotifyFunction:Close()
		end)
		TweenService:Create(
			NotifyFrameReal,
			TweenInfo.new(tonumber(NotifyConfig.Time), Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
			{ Position = UDim2.new(0, 0, 0, 0) }
		):Play()
		task.wait(tonumber(NotifyConfig.Delay))
		NotifyFunction:Close()
	end)
	return NotifyFunction
end

function deltrehub_notify(msg, delay, color, title, desc)
	return Deltrehub:MakeNotify({
		Title = title or "Deltrehub",
		Description = desc or "Notification",
		Content = msg or "Content",
		Color = color or DeltreTheme.AccentSecondary,
		Delay = delay or 4,
	})
end
function Deltrehub:Window(GuiConfig)
	GuiConfig = GuiConfig or {}
	GuiConfig.Title = GuiConfig.Title or "Deltrehub"
	GuiConfig.Footer = GuiConfig.Footer or "Deltrehub <3"
	GuiConfig.Color = GuiConfig.Color or DeltreTheme.AccentPrimary
	GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or 120
	GuiConfig.Version = GuiConfig.Version or 1

	CURRENT_VERSION = GuiConfig.Version
	LoadConfigFromFile()

	local GuiFunc = {}

	local DeltreGui = Instance.new("ScreenGui")
	local MainHolder = Instance.new("Frame")
	local NeonBorder = Instance.new("Frame")
	local Main = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local Top = Instance.new("Frame")
	local TextLabel = Instance.new("TextLabel")
	local UICorner1 = Instance.new("UICorner")
	local TextLabel1 = Instance.new("TextLabel")
	local Close = Instance.new("TextButton")
	local ImageLabel1 = Instance.new("ImageLabel")
	local Min = Instance.new("TextButton")
	local ImageLabel2 = Instance.new("ImageLabel")
	local LayersTab = Instance.new("Frame")
	local UICorner2 = Instance.new("UICorner")
	local DecideFrame = Instance.new("Frame")
	local Layers = Instance.new("Frame")
	local UICorner6 = Instance.new("UICorner")
	local NameTab = Instance.new("TextLabel")
	local LayersReal = Instance.new("Frame")
	local LayersFolder = Instance.new("Folder")
	local LayersPageLayout = Instance.new("UIPageLayout")

	DeltreGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	DeltreGui.Name = "DeltreGui"
	DeltreGui.ResetOnSpawn = false
	DeltreGui.Parent = game:GetService("CoreGui")

	-- Neon Glow Effect Holder
	MainHolder.BackgroundTransparency = 1
	MainHolder.BorderSizePixel = 0
	MainHolder.AnchorPoint = Vector2.new(0.5, 0.5)
	MainHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
	if isMobile then
		MainHolder.Size = safeSize(470, 270)
	else
		MainHolder.Size = safeSize(640, 400)
	end
	MainHolder.ZIndex = 0
	MainHolder.Name = "MainHolder"
	MainHolder.Parent = DeltreGui

	MainHolder.Position = UDim2.new(
		0,
		(DeltreGui.AbsoluteSize.X // 2 - MainHolder.Size.X.Offset // 2),
		0,
		(DeltreGui.AbsoluteSize.Y // 2 - MainHolder.Size.Y.Offset // 2)
	)

	-- Neon Border Frame
	NeonBorder.BackgroundColor3 = DeltreTheme.NeonOutline
	NeonBorder.BackgroundTransparency = 0.7
	NeonBorder.BorderSizePixel = 0
	NeonBorder.Position = UDim2.new(0.5, 0, 0.5, 0)
	NeonBorder.AnchorPoint = Vector2.new(0.5, 0.5)
	NeonBorder.Size = UDim2.new(1, 6, 1, 6)
	NeonBorder.ZIndex = 0
	NeonBorder.Name = "NeonBorder"
	NeonBorder.Parent = MainHolder

	local NeonCorner = Instance.new("UICorner")
	NeonCorner.CornerRadius = UDim.new(0, 8)
	NeonCorner.Parent = NeonBorder

	-- Animated neon pulse
	spawn(function()
		while NeonBorder and NeonBorder.Parent do
			local tween =
				TweenService:Create(NeonBorder, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
					BackgroundTransparency = 0.4,
				})
			tween:Play()
			wait(2)
			if not NeonBorder or not NeonBorder.Parent then
				break
			end
			local tween2 =
				TweenService:Create(NeonBorder, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
					BackgroundTransparency = 0.7,
				})
			tween2:Play()
			wait(2)
		end
	end)

	if GuiConfig.Theme then
		Main:Destroy()
		Main = Instance.new("ImageLabel")
		Main.Image = "rbxassetid://" .. GuiConfig.Theme
		Main.ScaleType = Enum.ScaleType.Crop
		Main.BackgroundTransparency = 1
		Main.ImageTransparency = GuiConfig.ThemeTransparency or 0.15
	else
		Main.BackgroundColor3 = DeltreTheme.Background
		Main.BackgroundTransparency = DeltreTheme.Transparency
	end

	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = UDim2.new(1, -6, 1, -6)
	Main.Name = "Main"
	Main.Parent = NeonBorder

	UICorner.Parent = Main
	UICorner.CornerRadius = DeltreTheme.CornerRadius

	Top.BackgroundColor3 = DeltreTheme.Surface
	Top.BackgroundTransparency = 0.3
	Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Top.BorderSizePixel = 0
	Top.Size = UDim2.new(1, 0, 0, 38)
	Top.Name = "Top"
	Top.Parent = Main

	-- Gradient for Top bar
	local TopGradient = Instance.new("UIGradient")
	TopGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.0, DeltreTheme.AccentPrimary),
		ColorSequenceKeypoint.new(0.5, DeltreTheme.AccentTertiary),
		ColorSequenceKeypoint.new(1.0, DeltreTheme.AccentSecondary),
	})
	TopGradient.Rotation = 90
	TopGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0.0, 0.85),
		NumberSequenceKeypoint.new(0.5, 0.95),
		NumberSequenceKeypoint.new(1.0, 0.85),
	})
	TopGradient.Parent = Top

	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.Text = GuiConfig.Title
	TextLabel.TextColor3 = GuiConfig.Color
	TextLabel.TextSize = 14
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 0.999
	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Size = UDim2.new(1, -100, 1, 0)
	TextLabel.Position = UDim2.new(0, 10, 0, 0)
	TextLabel.Parent = Top
	TextLabel.RichText = true

	UICorner1.Parent = Top
	UICorner1.CornerRadius = DeltreTheme.SmallCornerRadius

	TextLabel1.Font = Enum.Font.GothamBold
	TextLabel1.Text = GuiConfig.Footer
	TextLabel1.TextColor3 = GuiConfig.Color
	TextLabel1.TextSize = 14
	TextLabel1.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel1.BackgroundTransparency = 0.999
	TextLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel1.BorderSizePixel = 0
	TextLabel1.Size = UDim2.new(1, -(TextLabel.TextBounds.X + 104), 1, 0)
	TextLabel1.Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0)
	TextLabel1.Parent = Top
	TextLabel1.RichText = true

	Close.Font = Enum.Font.SourceSans
	Close.Text = ""
	Close.TextColor3 = Color3.fromRGB(0, 0, 0)
	Close.TextSize = 14
	Close.AnchorPoint = Vector2.new(1, 0.5)
	Close.BackgroundColor3 = DeltreTheme.AccentSecondary
	Close.BackgroundTransparency = 0.8
	Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Close.BorderSizePixel = 0
	Close.Position = UDim2.new(1, -8, 0.5, 0)
	Close.Size = UDim2.new(0, 25, 0, 25)
	Close.Name = "Close"
	Close.Parent = Top

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 4)
	CloseCorner.Parent = Close

	local CloseStroke = CreateNeonStroke(Close, 1.5)

	ImageLabel1.Image = "rbxassetid://9886659671"
	ImageLabel1.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ImageLabel1.BackgroundTransparency = 0.999
	ImageLabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ImageLabel1.BorderSizePixel = 0
	ImageLabel1.Position = UDim2.new(0.49, 0, 0.5, 0)
	ImageLabel1.Size = UDim2.new(1, -8, 1, -8)
	ImageLabel1.Parent = Close

	Min.Font = Enum.Font.SourceSans
	Min.Text = ""
	Min.TextColor3 = Color3.fromRGB(0, 0, 0)
	Min.TextSize = 14
	Min.AnchorPoint = Vector2.new(1, 0.5)
	Min.BackgroundColor3 = DeltreTheme.AccentTertiary
	Min.BackgroundTransparency = 0.8
	Min.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Min.BorderSizePixel = 0
	Min.Position = UDim2.new(1, -38, 0.5, 0)
	Min.Size = UDim2.new(0, 25, 0, 25)
	Min.Name = "Min"
	Min.Parent = Top

	local MinCorner = Instance.new("UICorner")
	MinCorner.CornerRadius = UDim.new(0, 4)
	MinCorner.Parent = Min

	local MinStroke = CreateNeonStroke(Min, 1.5)

	ImageLabel2.Image = "rbxassetid://9886659276"
	ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ImageLabel2.BackgroundTransparency = 0.999
	ImageLabel2.ImageTransparency = 0.2
	ImageLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ImageLabel2.BorderSizePixel = 0
	ImageLabel2.Position = UDim2.new(0.5, 0, 0.5, 0)
	ImageLabel2.Size = UDim2.new(1, -9, 1, -9)
	ImageLabel2.Parent = Min

	LayersTab.BackgroundColor3 = DeltreTheme.Surface
	LayersTab.BackgroundTransparency = 0.5
	LayersTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LayersTab.BorderSizePixel = 0
	LayersTab.Position = UDim2.new(0, 9, 0, 50)
	LayersTab.Size = UDim2.new(0, GuiConfig["Tab Width"], 1, -59)
	LayersTab.Name = "LayersTab"
	LayersTab.Parent = Main

	UICorner2.CornerRadius = DeltreTheme.CornerRadius
	UICorner2.Parent = LayersTab

	-- Neon stroke for tab panel
	local TabStroke = CreateNeonStroke(LayersTab, 1.5)

	DecideFrame.AnchorPoint = Vector2.new(0.5, 0)
	DecideFrame.BackgroundColor3 = DeltreTheme.NeonOutline
	DecideFrame.BackgroundTransparency = 0.5
	DecideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DecideFrame.BorderSizePixel = 0
	DecideFrame.Position = UDim2.new(0.5, 0, 0, 38)
	DecideFrame.Size = UDim2.new(1, 0, 0, 1)
	DecideFrame.Name = "DecideFrame"
	DecideFrame.Parent = Main

	Layers.BackgroundColor3 = DeltreTheme.Surface
	Layers.BackgroundTransparency = 0.6
	Layers.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Layers.BorderSizePixel = 0
	Layers.Position = UDim2.new(0, GuiConfig["Tab Width"] + 18, 0, 50)
	Layers.Size = UDim2.new(1, -(GuiConfig["Tab Width"] + 9 + 18), 1, -59)
	Layers.Name = "Layers"
	Layers.Parent = Main

	UICorner6.CornerRadius = DeltreTheme.CornerRadius
	UICorner6.Parent = Layers

	-- Neon stroke for content panel
	local LayersStroke = CreateNeonStroke(Layers, 1.5)

	NameTab.Font = Enum.Font.GothamBold
	NameTab.Text = ""
	NameTab.TextColor3 = DeltreTheme.TextPrimary
	NameTab.TextSize = 24
	NameTab.TextWrapped = true
	NameTab.TextXAlignment = Enum.TextXAlignment.Left
	NameTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NameTab.BackgroundTransparency = 0.999
	NameTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NameTab.BorderSizePixel = 0
	NameTab.Size = UDim2.new(1, 0, 0, 30)
	NameTab.Name = "NameTab"
	NameTab.Parent = Layers

	-- Gradient text effect for tab name
	local NameGradient = Instance.new("UIGradient")
	NameGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.0, DeltreTheme.AccentTertiary),
		ColorSequenceKeypoint.new(0.5, DeltreTheme.AccentPrimary),
		ColorSequenceKeypoint.new(1.0, DeltreTheme.AccentSecondary),
	})
	NameGradient.Parent = NameTab

	LayersReal.AnchorPoint = Vector2.new(0, 1)
	LayersReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LayersReal.BackgroundTransparency = 0.999
	LayersReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LayersReal.BorderSizePixel = 0
	LayersReal.ClipsDescendants = true
	LayersReal.Position = UDim2.new(0, 0, 1, 0)
	LayersReal.Size = UDim2.new(1, 0, 1, -33)
	LayersReal.Name = "LayersReal"
	LayersReal.Parent = Layers

	LayersFolder.Name = "LayersFolder"
	LayersFolder.Parent = LayersReal

	LayersPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	LayersPageLayout.Name = "LayersPageLayout"
	LayersPageLayout.Parent = LayersFolder
	LayersPageLayout.TweenTime = 0.5
	LayersPageLayout.EasingDirection = Enum.EasingDirection.InOut
	LayersPageLayout.EasingStyle = Enum.EasingStyle.Quart

	local ScrollTab = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")

	ScrollTab.CanvasSize = UDim2.new(0, 0, 1.10000002, 0)
	ScrollTab.ScrollBarImageColor3 = DeltreTheme.AccentPrimary
	ScrollTab.ScrollBarThickness = 2
	ScrollTab.Active = true
	ScrollTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollTab.BackgroundTransparency = 0.999
	ScrollTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollTab.BorderSizePixel = 0
	ScrollTab.Size = UDim2.new(1, 0, 1, 0)
	ScrollTab.Name = "ScrollTab"
	ScrollTab.Parent = LayersTab

	UIListLayout.Padding = UDim.new(0, 4)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = ScrollTab

	local function UpdateSize1()
		local OffsetY = 0
		for _, child in ScrollTab:GetChildren() do
			if child.Name ~= "UIListLayout" then
				OffsetY = OffsetY + 4 + child.Size.Y.Offset
			end
		end
		ScrollTab.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
	end
	ScrollTab.ChildAdded:Connect(UpdateSize1)
	ScrollTab.ChildRemoved:Connect(UpdateSize1)

	function GuiFunc:DestroyGui()
		if CoreGui:FindFirstChild("DeltreGui") then
			DeltreGui:Destroy()
		end
	end

	Min.Activated:Connect(function()
		CircleClick(Min, Mouse.X, Mouse.Y)
		MainHolder.Visible = false
	end)
	Close.Activated:Connect(function()
		CircleClick(Close, Mouse.X, Mouse.Y)

		local Overlay = Instance.new("Frame")
		Overlay.Size = UDim2.new(1, 0, 1, 0)
		Overlay.BackgroundColor3 = DeltreTheme.Background
		Overlay.BackgroundTransparency = 0.2
		Overlay.ZIndex = 50
		Overlay.Parent = MainHolder

		local Dialog = Instance.new("Frame")
		Dialog.Size = UDim2.new(0, 300, 0, 150)
		Dialog.Position = UDim2.new(0.5, -150, 0.5, -75)
		Dialog.BackgroundColor3 = DeltreTheme.Surface
		Dialog.BorderSizePixel = 0
		Dialog.ZIndex = 51
		Dialog.Parent = Overlay

		local DialogCorner = Instance.new("UICorner", Dialog)
		DialogCorner.CornerRadius = DeltreTheme.CornerRadius

		local DialogStroke = CreateNeonStroke(Dialog, 2)

		local DialogGlow = Instance.new("Frame")
		DialogGlow.Size = UDim2.new(0, 310, 0, 160)
		DialogGlow.Position = UDim2.new(0.5, -155, 0.5, -80)
		DialogGlow.BackgroundColor3 = DeltreTheme.NeonOutline
		DialogGlow.BackgroundTransparency = 0.8
		DialogGlow.BorderSizePixel = 0
		DialogGlow.ZIndex = 50
		DialogGlow.Parent = Overlay

		local GlowCorner = Instance.new("UICorner", DialogGlow)
		GlowCorner.CornerRadius = UDim.new(0, 10)

		local Gradient = Instance.new("UIGradient")
		Gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.0, DeltreTheme.AccentTertiary),
			ColorSequenceKeypoint.new(0.25, DeltreTheme.AccentPrimary),
			ColorSequenceKeypoint.new(0.5, DeltreTheme.AccentSecondary),
			ColorSequenceKeypoint.new(0.75, DeltreTheme.AccentPrimary),
			ColorSequenceKeypoint.new(1.0, DeltreTheme.AccentTertiary),
		})
		Gradient.Rotation = 90
		Gradient.Parent = DialogGlow

		local Title = Instance.new("TextLabel")
		Title.Size = UDim2.new(1, 0, 0, 40)
		Title.Position = UDim2.new(0, 0, 0, 4)
		Title.BackgroundTransparency = 1
		Title.Font = Enum.Font.GothamBold
		Title.Text = "Confirm Window"
		Title.TextSize = 22
		Title.TextColor3 = DeltreTheme.TextPrimary
		Title.ZIndex = 52
		Title.Parent = Dialog

		local Message = Instance.new("TextLabel")
		Message.Size = UDim2.new(1, -20, 0, 60)
		Message.Position = UDim2.new(0, 10, 0, 30)
		Message.BackgroundTransparency = 1
		Message.Font = Enum.Font.Gotham
		Message.Text = "Do you want to close this window?\nYou will not be able to open it again"
		Message.TextSize = 14
		Message.TextColor3 = DeltreTheme.TextSecondary
		Message.TextWrapped = true
		Message.ZIndex = 52
		Message.Parent = Dialog

		local Yes = Instance.new("TextButton")
		Yes.Size = UDim2.new(0.45, -10, 0, 35)
		Yes.Position = UDim2.new(0.05, 0, 1, -55)
		Yes.BackgroundColor3 = DeltreTheme.AccentPrimary
		Yes.BackgroundTransparency = 0.7
		Yes.Text = "Yes"
		Yes.Font = Enum.Font.GothamBold
		Yes.TextSize = 15
		Yes.TextColor3 = DeltreTheme.TextPrimary
		Yes.ZIndex = 52
		Yes.Name = "Yes"
		Yes.Parent = Dialog

		local YesCorner = Instance.new("UICorner", Yes)
		YesCorner.CornerRadius = DeltreTheme.SmallCornerRadius

		local YesGradient = CreateNeonGradient(Yes, 45)

		local Cancel = Instance.new("TextButton")
		Cancel.Size = UDim2.new(0.45, -10, 0, 35)
		Cancel.Position = UDim2.new(0.5, 10, 1, -55)
		Cancel.BackgroundColor3 = DeltreTheme.Surface
		Cancel.BackgroundTransparency = 0.5
		Cancel.Text = "Cancel"
		Cancel.Font = Enum.Font.GothamBold
		Cancel.TextSize = 15
		Cancel.TextColor3 = DeltreTheme.TextPrimary
		Cancel.ZIndex = 52
		Cancel.Name = "Cancel"
		Cancel.Parent = Dialog

		local CancelCorner = Instance.new("UICorner", Cancel)
		CancelCorner.CornerRadius = DeltreTheme.SmallCornerRadius

		local CancelStroke = CreateNeonStroke(Cancel, 1)

		Yes.MouseButton1Click:Connect(function()
			if DeltreGui then
				DeltreGui:Destroy()
			end
			if game.CoreGui:FindFirstChild("DeltreToggleUI") then
				game.CoreGui.DeltreToggleUI:Destroy()
			end
		end)

		Cancel.MouseButton1Click:Connect(function()
			Overlay:Destroy()
		end)
	end)

	local ToggleKey = Enum.KeyCode.F3
	UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe then
			return
		end
		if input.KeyCode == ToggleKey then
			if MainHolder then
				MainHolder.Visible = not MainHolder.Visible
			end
		end
	end)

	function GuiFunc:ToggleUI()
		local ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Parent = game:GetService("CoreGui")
		ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		ScreenGui.Name = "DeltreToggleUI"

		local MainButton = Instance.new("ImageLabel")
		MainButton.Parent = ScreenGui
		MainButton.Size = UDim2.new(0, 45, 0, 45)
		MainButton.Position = UDim2.new(0, 20, 0, 100)
		MainButton.BackgroundColor3 = DeltreTheme.Surface
		MainButton.BackgroundTransparency = 0.3
		MainButton.Image = "rbxassetid://" .. (GuiConfig.Image or "108886429866687")
		MainButton.ScaleType = Enum.ScaleType.Fit

		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = DeltreTheme.CornerRadius
		UICorner.Parent = MainButton

		local ButtonStroke = CreateNeonStroke(MainButton, 2)

		-- Animated gradient for toggle button
		local ToggleGradient = CreateNeonGradient(MainButton, 45)

		spawn(function()
			while MainButton and MainButton.Parent do
				local tween = TweenService:Create(ToggleGradient, TweenInfo.new(3, Enum.EasingStyle.Linear), {
					Rotation = ToggleGradient.Rotation + 180,
				})
				tween:Play()
				wait(3)
			end
		end)

		local Button = Instance.new("TextButton")
		Button.Parent = MainButton
		Button.Size = UDim2.new(1, 0, 1, 0)
		Button.BackgroundTransparency = 1
		Button.Text = ""

		Button.MouseButton1Click:Connect(function()
			if MainHolder then
				MainHolder.Visible = not MainHolder.Visible
			end
		end)

		local dragging = false
		local dragStart, startPos

		local function update(input)
			local delta = input.Position - dragStart
			MainButton.Position =
				UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end

		Button.InputBegan:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				dragging = true
				dragStart = input.Position
				startPos = MainButton.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)

		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if
				dragging
				and (
					input.UserInputType == Enum.UserInputType.MouseMovement
					or input.UserInputType == Enum.UserInputType.Touch
				)
			then
				update(input)
			end
		end)
	end

	GuiFunc:ToggleUI()

	MainHolder.Size = UDim2.new(0, 115 + TextLabel.TextBounds.X + 1 + TextLabel1.TextBounds.X, 0, 350)
	MakeDraggable(Top, MainHolder)

	local MoreBlur = Instance.new("Frame")
	local DropShadowHolder1 = Instance.new("Frame")
	local DropShadow1 = Instance.new("ImageLabel")
	local UICorner28 = Instance.new("UICorner")
	local ConnectButton = Instance.new("TextButton")

	MoreBlur.AnchorPoint = Vector2.new(1, 1)
	MoreBlur.BackgroundColor3 = DeltreTheme.Background
	MoreBlur.BackgroundTransparency = 0.999
	MoreBlur.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MoreBlur.BorderSizePixel = 0
	MoreBlur.ClipsDescendants = true
	MoreBlur.Position = UDim2.new(1, 8, 1, 8)
	MoreBlur.Size = UDim2.new(1, 154, 1, 54)
	MoreBlur.Visible = false
	MoreBlur.Name = "MoreBlur"
	MoreBlur.Parent = Layers

	DropShadowHolder1.BackgroundTransparency = 1
	DropShadowHolder1.BorderSizePixel = 0
	DropShadowHolder1.Size = UDim2.new(1, 0, 1, 0)
	DropShadowHolder1.ZIndex = 0
	DropShadowHolder1.Name = "DropShadowHolder"
	DropShadowHolder1.Parent = MoreBlur

	DropShadow1.Image = "rbxassetid://6015897843"
	DropShadow1.ImageColor3 = DeltreTheme.NeonOutline
	DropShadow1.ImageTransparency = 1
	DropShadow1.ScaleType = Enum.ScaleType.Slice
	DropShadow1.SliceCenter = Rect.new(49, 49, 450, 450)
	DropShadow1.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow1.BackgroundTransparency = 1
	DropShadow1.BorderSizePixel = 0
	DropShadow1.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow1.Size = UDim2.new(1, 35, 1, 35)
	DropShadow1.ZIndex = 0
	DropShadow1.Name = "DropShadow"
	DropShadow1.Parent = DropShadowHolder1

	UICorner28.Parent = MoreBlur
	UICorner28.CornerRadius = DeltreTheme.CornerRadius

	ConnectButton.Font = Enum.Font.SourceSans
	ConnectButton.Text = ""
	ConnectButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	ConnectButton.TextSize = 14
	ConnectButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ConnectButton.BackgroundTransparency = 0.999
	ConnectButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConnectButton.BorderSizePixel = 0
	ConnectButton.Size = UDim2.new(1, 0, 1, 0)
	ConnectButton.Name = "ConnectButton"
	ConnectButton.Parent = MoreBlur

	local DropdownSelect = Instance.new("Frame")
	local UICorner36 = Instance.new("UICorner")
	local UIStroke14 = Instance.new("UIStroke")
	local DropdownSelectReal = Instance.new("Frame")
	local DropdownFolder = Instance.new("Folder")
	local DropPageLayout = Instance.new("UIPageLayout")

	DropdownSelect.AnchorPoint = Vector2.new(1, 0.5)
	DropdownSelect.BackgroundColor3 = DeltreTheme.Surface
	DropdownSelect.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DropdownSelect.BorderSizePixel = 0
	DropdownSelect.LayoutOrder = 1
	DropdownSelect.Position = UDim2.new(1, 172, 0.5, 0)
	DropdownSelect.Size = UDim2.new(0, 160, 1, -16)
	DropdownSelect.Name = "DropdownSelect"
	DropdownSelect.ClipsDescendants = true
	DropdownSelect.Parent = MoreBlur

	ConnectButton.Activated:Connect(function()
		if MoreBlur.Visible then
			TweenService:Create(MoreBlur, TweenInfo.new(0.3), { BackgroundTransparency = 0.999 }):Play()
			TweenService:Create(DropdownSelect, TweenInfo.new(0.3), { Position = UDim2.new(1, 172, 0.5, 0) }):Play()
			task.wait(0.3)
			MoreBlur.Visible = false
		end
	end)
	UICorner36.CornerRadius = DeltreTheme.SmallCornerRadius
	UICorner36.Parent = DropdownSelect

	UIStroke14.Color = DeltreTheme.NeonOutline
	UIStroke14.Thickness = 2
	UIStroke14.Transparency = 0.5
	UIStroke14.Parent = DropdownSelect

	DropdownSelectReal.AnchorPoint = Vector2.new(0.5, 0.5)
	DropdownSelectReal.BackgroundColor3 = DeltreTheme.Background
	DropdownSelectReal.BackgroundTransparency = 0.3
	DropdownSelectReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DropdownSelectReal.BorderSizePixel = 0
	DropdownSelectReal.LayoutOrder = 1
	DropdownSelectReal.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropdownSelectReal.Size = UDim2.new(1, 1, 1, 1)
	DropdownSelectReal.Name = "DropdownSelectReal"
	DropdownSelectReal.Parent = DropdownSelect

	DropdownFolder.Name = "DropdownFolder"
	DropdownFolder.Parent = DropdownSelectReal

	DropPageLayout.EasingDirection = Enum.EasingDirection.InOut
	DropPageLayout.EasingStyle = Enum.EasingStyle.Quart
	DropPageLayout.TweenTime = 0.01
	DropPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	DropPageLayout.FillDirection = Enum.FillDirection.Vertical
	DropPageLayout.Archivable = false
	DropPageLayout.Name = "DropPageLayout"
	DropPageLayout.Parent = DropdownFolder
	--// Tabs
	local Tabs = {}
	local CountTab = 0
	local CountDropdown = 0
	function Tabs:AddTab(TabConfig)
		local TabConfig = TabConfig or {}
		TabConfig.Name = TabConfig.Name or "Tab"
		TabConfig.Icon = TabConfig.Icon or ""

		local ScrolLayers = Instance.new("ScrollingFrame")
		local UIListLayout1 = Instance.new("UIListLayout")

		ScrolLayers.ScrollBarImageColor3 = DeltreTheme.AccentPrimary
		ScrolLayers.ScrollBarThickness = 2
		ScrolLayers.Active = true
		ScrolLayers.LayoutOrder = CountTab
		ScrolLayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ScrolLayers.BackgroundTransparency = 0.999
		ScrolLayers.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ScrolLayers.BorderSizePixel = 0
		ScrolLayers.Size = UDim2.new(1, 0, 1, 0)
		ScrolLayers.Name = "ScrolLayers"
		ScrolLayers.Parent = LayersFolder

		UIListLayout1.Padding = UDim.new(0, 4)
		UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout1.Parent = ScrolLayers

		local Tab = Instance.new("Frame")
		local UICorner3 = Instance.new("UICorner")
		local TabButton = Instance.new("TextButton")
		local TabName = Instance.new("TextLabel")
		local FeatureImg = Instance.new("ImageLabel")
		local UIStroke2 = Instance.new("UIStroke")
		local UICorner4 = Instance.new("UICorner")
		local TabGradient = Instance.new("UIGradient")

		Tab.BackgroundColor3 = DeltreTheme.Surface
		if CountTab == 0 then
			Tab.BackgroundTransparency = 0.7
		else
			Tab.BackgroundTransparency = 0.95
		end
		Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab.BorderSizePixel = 0
		Tab.LayoutOrder = CountTab
		Tab.Size = UDim2.new(1, 0, 0, 32)
		Tab.Name = "Tab"
		Tab.Parent = ScrollTab

		UICorner3.CornerRadius = DeltreTheme.SmallCornerRadius
		UICorner3.Parent = Tab

		-- Neon gradient for active tab
		TabGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.0, DeltreTheme.AccentPrimary),
			ColorSequenceKeypoint.new(1.0, DeltreTheme.AccentSecondary),
		})
		TabGradient.Rotation = 45
		TabGradient.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0.0, 0.9),
			NumberSequenceKeypoint.new(1.0, 0.9),
		})
		TabGradient.Parent = Tab

		TabButton.Font = Enum.Font.GothamBold
		TabButton.Text = ""
		TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabButton.TextSize = 13
		TabButton.TextXAlignment = Enum.TextXAlignment.Left
		TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabButton.BackgroundTransparency = 0.999
		TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, 0, 1, 0)
		TabButton.Name = "TabButton"
		TabButton.Parent = Tab

		TabName.Font = Enum.Font.GothamBold
		TabName.Text = "〢 " .. tostring(TabConfig.Name)
		TabName.TextColor3 = DeltreTheme.TextPrimary
		TabName.TextSize = 12
		TabName.TextXAlignment = Enum.TextXAlignment.Left
		TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabName.BackgroundTransparency = 0.999
		TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabName.BorderSizePixel = 0
		TabName.Size = UDim2.new(1, 0, 1, 0)
		TabName.Position = UDim2.new(0, 32, 0, 0)
		TabName.Name = "TabName"
		TabName.Parent = Tab

		FeatureImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		FeatureImg.BackgroundTransparency = 0.999
		FeatureImg.BorderColor3 = Color3.fromRGB(0, 0, 0)
		FeatureImg.BorderSizePixel = 0
		FeatureImg.Position = UDim2.new(0, 10, 0, 8)
		FeatureImg.Size = UDim2.new(0, 16, 0, 16)
		FeatureImg.Name = "FeatureImg"
		FeatureImg.Parent = Tab

		-- Icon color tint
		FeatureImg.ImageColor3 = DeltreTheme.AccentTertiary

		if CountTab == 0 then
			LayersPageLayout:JumpToIndex(0)
			NameTab.Text = TabConfig.Name
			local ChooseFrame = Instance.new("Frame")
			ChooseFrame.BackgroundColor3 = GuiConfig.Color
			ChooseFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ChooseFrame.BorderSizePixel = 0
			ChooseFrame.Position = UDim2.new(0, 2, 0, 10)
			ChooseFrame.Size = UDim2.new(0, 2, 0, 12)
			ChooseFrame.Name = "ChooseFrame"
			ChooseFrame.Parent = Tab

			UIStroke2.Color = GuiConfig.Color
			UIStroke2.Thickness = 2
			UIStroke2.Parent = ChooseFrame

			UICorner4.Parent = ChooseFrame
			UICorner4.CornerRadius = UDim.new(0, 1)
		end

		if TabConfig.Icon ~= "" then
			if Icons[TabConfig.Icon] then
				FeatureImg.Image = Icons[TabConfig.Icon]
			else
				FeatureImg.Image = TabConfig.Icon
			end
		end

		TabButton.Activated:Connect(function()
			CircleClick(TabButton, Mouse.X, Mouse.Y)
			local FrameChoose
			for a, s in ScrollTab:GetChildren() do
				for i, v in s:GetChildren() do
					if v.Name == "ChooseFrame" then
						FrameChoose = v
						break
					end
				end
			end
			if FrameChoose ~= nil and Tab.LayoutOrder ~= LayersPageLayout.CurrentPage.LayoutOrder then
				for _, TabFrame in ScrollTab:GetChildren() do
					if TabFrame.Name == "Tab" then
						TweenService:Create(
							TabFrame,
							TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
							{ BackgroundTransparency = 0.95 }
						):Play()

						local gradient = TabFrame:FindFirstChildOfClass("UIGradient")
						if gradient then
							gradient.Transparency = NumberSequence.new({
								NumberSequenceKeypoint.new(0.0, 0.9),
								NumberSequenceKeypoint.new(1.0, 0.9),
							})
						end
					end
				end
				TweenService:Create(
					Tab,
					TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
					{ BackgroundTransparency = 0.7 }
				):Play()

				-- Fixed: Set directly instead of tweening NumberSequence
				TabGradient.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0.0, 0.3),
					NumberSequenceKeypoint.new(1.0, 0.3),
				})

				TweenService:Create(
					FrameChoose,
					TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
					{ Position = UDim2.new(0, 2, 0, 10 + (36 * Tab.LayoutOrder)) }
				):Play()
				LayersPageLayout:JumpToIndex(Tab.LayoutOrder)
				task.wait(0.05)
				NameTab.Text = TabConfig.Name
				TweenService:Create(
					FrameChoose,
					TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
					{ Size = UDim2.new(0, 2, 0, 20) }
				):Play()
				task.wait(0.2)
				TweenService:Create(
					FrameChoose,
					TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
					{ Size = UDim2.new(0, 2, 0, 12) }
				):Play()
			end
		end)
		--// Section
		local Sections = {}
		local CountSection = 0
		function Sections:AddSection(Title, AlwaysOpen)
			local Title = Title or "Title"
			local Section = Instance.new("Frame")
			local SectionDecideFrame = Instance.new("Frame")
			local UICorner1 = Instance.new("UICorner")
			local UIGradient = Instance.new("UIGradient")

			Section.BackgroundColor3 = DeltreTheme.Surface
			Section.BackgroundTransparency = 0.95
			Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Section.BorderSizePixel = 0
			Section.LayoutOrder = CountSection
			Section.ClipsDescendants = true
			Section.LayoutOrder = 1
			Section.Size = UDim2.new(1, 0, 0, 32)
			Section.Name = "Section"
			Section.Parent = ScrolLayers

			local SectionReal = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			local SectionButton = Instance.new("TextButton")
			local FeatureFrame = Instance.new("Frame")
			local FeatureImg = Instance.new("ImageLabel")
			local SectionTitle = Instance.new("TextLabel")

			SectionReal.AnchorPoint = Vector2.new(0.5, 0)
			SectionReal.BackgroundColor3 = DeltreTheme.Surface
			SectionReal.BackgroundTransparency = 0.8
			SectionReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionReal.BorderSizePixel = 0
			SectionReal.LayoutOrder = 1
			SectionReal.Position = UDim2.new(0.5, 0, 0, 0)
			SectionReal.Size = UDim2.new(1, 1, 0, 32)
			SectionReal.Name = "SectionReal"
			SectionReal.Parent = Section

			UICorner.CornerRadius = DeltreTheme.SmallCornerRadius
			UICorner.Parent = SectionReal

			-- Neon stroke for section
			local SectionNeon = CreateNeonStroke(SectionReal, 1.5)

			SectionButton.Font = Enum.Font.SourceSans
			SectionButton.Text = ""
			SectionButton.TextColor3 = Color3.fromRGB(0, 0, 0)
			SectionButton.TextSize = 14
			SectionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionButton.BackgroundTransparency = 0.999
			SectionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionButton.BorderSizePixel = 0
			SectionButton.Size = UDim2.new(1, 0, 1, 0)
			SectionButton.Name = "SectionButton"
			SectionButton.Parent = SectionReal

			FeatureFrame.AnchorPoint = Vector2.new(1, 0.5)
			FeatureFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			FeatureFrame.BackgroundTransparency = 0.999
			FeatureFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FeatureFrame.BorderSizePixel = 0
			FeatureFrame.Position = UDim2.new(1, -5, 0.5, 0)
			FeatureFrame.Size = UDim2.new(0, 20, 0, 20)
			FeatureFrame.Name = "FeatureFrame"
			FeatureFrame.Parent = SectionReal

			FeatureImg.Image = "rbxassetid://16851841101"
			FeatureImg.AnchorPoint = Vector2.new(0.5, 0.5)
			FeatureImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			FeatureImg.BackgroundTransparency = 0.999
			FeatureImg.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FeatureImg.BorderSizePixel = 0
			FeatureImg.Position = UDim2.new(0.5, 0, 0.5, 0)
			FeatureImg.Rotation = -90
			FeatureImg.Size = UDim2.new(1, 6, 1, 6)
			FeatureImg.Name = "FeatureImg"
			FeatureImg.Parent = FeatureFrame
			FeatureImg.ImageColor3 = DeltreTheme.AccentPrimary

			SectionTitle.Font = Enum.Font.GothamBold
			SectionTitle.Text = Title
			SectionTitle.TextColor3 = DeltreTheme.TextPrimary
			SectionTitle.TextSize = 13
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			SectionTitle.TextYAlignment = Enum.TextYAlignment.Top
			SectionTitle.AnchorPoint = Vector2.new(0, 0.5)
			SectionTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionTitle.BackgroundTransparency = 0.999
			SectionTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionTitle.BorderSizePixel = 0
			SectionTitle.Position = UDim2.new(0, 10, 0.5, 0)
			SectionTitle.Size = UDim2.new(1, -50, 0, 13)
			SectionTitle.Name = "SectionTitle"
			SectionTitle.Parent = SectionReal

			SectionDecideFrame.BackgroundColor3 = DeltreTheme.NeonOutline
			SectionDecideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionDecideFrame.AnchorPoint = Vector2.new(0.5, 0)
			SectionDecideFrame.BorderSizePixel = 0
			SectionDecideFrame.Position = UDim2.new(0.5, 0, 0, 35)
			SectionDecideFrame.Size = UDim2.new(0, 0, 0, 2)
			SectionDecideFrame.Name = "SectionDecideFrame"
			SectionDecideFrame.Parent = Section

			UICorner1.Parent = SectionDecideFrame
			UICorner1.CornerRadius = UDim.new(0, 1)

			UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, DeltreTheme.Background),
				ColorSequenceKeypoint.new(0.5, GuiConfig.Color),
				ColorSequenceKeypoint.new(1, DeltreTheme.Background),
			})
			UIGradient.Parent = SectionDecideFrame

			--// Section Add
			local SectionAdd = Instance.new("Frame")
			local UICorner8 = Instance.new("UICorner")
			local UIListLayout2 = Instance.new("UIListLayout")

			SectionAdd.AnchorPoint = Vector2.new(0.5, 0)
			SectionAdd.BackgroundColor3 = DeltreTheme.Surface
			SectionAdd.BackgroundTransparency = 0.95
			SectionAdd.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionAdd.BorderSizePixel = 0
			SectionAdd.ClipsDescendants = true
			SectionAdd.LayoutOrder = 1
			SectionAdd.Position = UDim2.new(0.5, 0, 0, 40)
			SectionAdd.Size = UDim2.new(1, 0, 0, 100)
			SectionAdd.Name = "SectionAdd"
			SectionAdd.Parent = Section

			UICorner8.CornerRadius = DeltreTheme.SmallCornerRadius
			UICorner8.Parent = SectionAdd

			UIListLayout2.Padding = UDim.new(0, 4)
			UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout2.Parent = SectionAdd

			local OpenSection = false

			local function UpdateSizeScroll()
				local OffsetY = 0
				for _, child in ScrolLayers:GetChildren() do
					if child.Name ~= "UIListLayout" then
						OffsetY = OffsetY + 4 + child.Size.Y.Offset
					end
				end
				ScrolLayers.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
			end

			local function UpdateSizeSection()
				if OpenSection then
					local SectionSizeYWitdh = 40
					for _, v in SectionAdd:GetChildren() do
						if v.Name ~= "UIListLayout" and v.Name ~= "UICorner" then
							SectionSizeYWitdh = SectionSizeYWitdh + v.Size.Y.Offset + 4
						end
					end
					TweenService:Create(FeatureFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), { Rotation = 90 })
						:Play()
					TweenService:Create(
						Section,
						TweenInfo.new(0.4, Enum.EasingStyle.Quart),
						{ Size = UDim2.new(1, 1, 0, SectionSizeYWitdh) }
					):Play()
					TweenService:Create(
						SectionAdd,
						TweenInfo.new(0.4, Enum.EasingStyle.Quart),
						{ Size = UDim2.new(1, 0, 0, SectionSizeYWitdh - 40) }
					):Play()
					TweenService:Create(
						SectionDecideFrame,
						TweenInfo.new(0.4, Enum.EasingStyle.Quart),
						{ Size = UDim2.new(1, 0, 0, 2) }
					):Play()
					task.wait(0.4)
					UpdateSizeScroll()
				end
			end

			if AlwaysOpen == true then
				SectionButton:Destroy()
				FeatureFrame:Destroy()
				OpenSection = true
				UpdateSizeSection()
			elseif AlwaysOpen == false then
				OpenSection = true
				UpdateSizeSection()
			else
				OpenSection = false
			end

			if AlwaysOpen ~= true then
				SectionButton.Activated:Connect(function()
					CircleClick(SectionButton, Mouse.X, Mouse.Y)
					if OpenSection then
						TweenService:Create(FeatureFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), { Rotation = 0 })
							:Play()
						TweenService
							:Create(
								Section,
								TweenInfo.new(0.4, Enum.EasingStyle.Quart),
								{ Size = UDim2.new(1, 1, 0, 32) }
							)
							:Play()
						TweenService:Create(
							SectionDecideFrame,
							TweenInfo.new(0.4, Enum.EasingStyle.Quart),
							{ Size = UDim2.new(0, 0, 0, 2) }
						):Play()
						OpenSection = false
						task.wait(0.4)
						UpdateSizeScroll()
					else
						OpenSection = true
						UpdateSizeSection()
					end
				end)
			end

			if AlwaysOpen == true or AlwaysOpen == false then
				OpenSection = true
				local SectionSizeYWitdh = 40
				for _, v in SectionAdd:GetChildren() do
					if v.Name ~= "UIListLayout" and v.Name ~= "UICorner" then
						SectionSizeYWitdh = SectionSizeYWitdh + v.Size.Y.Offset + 4
					end
				end
				FeatureFrame.Rotation = 90
				Section.Size = UDim2.new(1, 1, 0, SectionSizeYWitdh)
				SectionAdd.Size = UDim2.new(1, 0, 0, SectionSizeYWitdh - 40)
				SectionDecideFrame.Size = UDim2.new(1, 0, 0, 2)
				UpdateSizeScroll()
			end

			SectionAdd.ChildAdded:Connect(UpdateSizeSection)
			SectionAdd.ChildRemoved:Connect(UpdateSizeSection)

			local layout = ScrolLayers:FindFirstChildOfClass("UIListLayout")
			if layout then
				layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					ScrolLayers.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
				end)
			end

			local Items = {}
			local CountItem = 0

			function Items:AddParagraph(ParagraphConfig)
				local ParagraphConfig = ParagraphConfig or {}
				ParagraphConfig.Title = ParagraphConfig.Title or "Title"
				ParagraphConfig.Content = ParagraphConfig.Content or "Content"
				local ParagraphFunc = {}

				local Paragraph = Instance.new("Frame")
				local UICorner14 = Instance.new("UICorner")
				local ParagraphTitle = Instance.new("TextLabel")
				local ParagraphContent = Instance.new("TextLabel")

				Paragraph.BackgroundColor3 = DeltreTheme.Surface
				Paragraph.BackgroundTransparency = 0.8
				Paragraph.BorderSizePixel = 0
				Paragraph.LayoutOrder = CountItem
				Paragraph.Size = UDim2.new(1, 0, 0, 46)
				Paragraph.Name = "Paragraph"
				Paragraph.Parent = SectionAdd

				UICorner14.CornerRadius = DeltreTheme.SmallCornerRadius
				UICorner14.Parent = Paragraph

				-- Neon border for paragraph
				local ParaStroke = CreateNeonStroke(Paragraph, 1)

				local iconOffset = 10
				if ParagraphConfig.Icon then
					local IconImg = Instance.new("ImageLabel")
					IconImg.Size = UDim2.new(0, 20, 0, 20)
					IconImg.Position = UDim2.new(0, 8, 0, 12)
					IconImg.BackgroundTransparency = 1
					IconImg.Name = "ParagraphIcon"
					IconImg.Parent = Paragraph
					IconImg.ImageColor3 = DeltreTheme.AccentTertiary

					if Icons and Icons[ParagraphConfig.Icon] then
						IconImg.Image = Icons[ParagraphConfig.Icon]
					else
						IconImg.Image = ParagraphConfig.Icon
					end

					iconOffset = 30
				end

				ParagraphTitle.Font = Enum.Font.GothamBold
				ParagraphTitle.Text = ParagraphConfig.Title
				ParagraphTitle.TextColor3 = DeltreTheme.TextPrimary
				ParagraphTitle.TextSize = 13
				ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
				ParagraphTitle.TextYAlignment = Enum.TextYAlignment.Top
				ParagraphTitle.BackgroundTransparency = 1
				ParagraphTitle.Position = UDim2.new(0, iconOffset, 0, 10)
				ParagraphTitle.Size = UDim2.new(1, -16, 0, 13)
				ParagraphTitle.Name = "ParagraphTitle"
				ParagraphTitle.Parent = Paragraph

				ParagraphContent.Font = Enum.Font.Gotham
				ParagraphContent.Text = ParagraphConfig.Content
				ParagraphContent.TextColor3 = DeltreTheme.TextSecondary
				ParagraphContent.TextSize = 12
				ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
				ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
				ParagraphContent.BackgroundTransparency = 1
				ParagraphContent.Position = UDim2.new(0, iconOffset, 0, 25)
				ParagraphContent.Name = "ParagraphContent"
				ParagraphContent.TextWrapped = false
				ParagraphContent.RichText = true
				ParagraphContent.Parent = Paragraph

				ParagraphContent.Size = UDim2.new(1, -16, 0, ParagraphContent.TextBounds.Y)

				local ParagraphButton
				if ParagraphConfig.ButtonText then
					ParagraphButton = Instance.new("TextButton")
					ParagraphButton.Position = UDim2.new(0, 10, 0, 42)
					ParagraphButton.Size = UDim2.new(1, -22, 0, 28)
					ParagraphButton.BackgroundColor3 = DeltreTheme.AccentPrimary
					ParagraphButton.BackgroundTransparency = 0.7
					ParagraphButton.Font = Enum.Font.GothamBold
					ParagraphButton.TextSize = 12
					ParagraphButton.TextColor3 = DeltreTheme.TextPrimary
					ParagraphButton.Text = ParagraphConfig.ButtonText
					ParagraphButton.Parent = Paragraph

					local btnCorner = Instance.new("UICorner")
					btnCorner.CornerRadius = DeltreTheme.SmallCornerRadius
					btnCorner.Parent = ParagraphButton

					-- 45 degree gradient for button
					local btnGradient = CreateNeonGradient(ParagraphButton, 45)

					local btnStroke = CreateNeonStroke(ParagraphButton, 1)

					if ParagraphConfig.ButtonCallback then
						ParagraphButton.MouseButton1Click:Connect(ParagraphConfig.ButtonCallback)
					end
				end

				local function UpdateSize()
					local totalHeight = ParagraphContent.TextBounds.Y + 33
					if ParagraphButton then
						totalHeight = totalHeight + ParagraphButton.Size.Y.Offset + 5
					end
					Paragraph.Size = UDim2.new(1, 0, 0, totalHeight)
				end

				UpdateSize()

				ParagraphContent:GetPropertyChangedSignal("TextBounds"):Connect(UpdateSize)

				function ParagraphFunc:SetContent(content)
					content = content or "Content"
					ParagraphContent.Text = content
					UpdateSize()
				end

				CountItem = CountItem + 1
				return ParagraphFunc
			end

			function Items:AddPanel(PanelConfig)
				PanelConfig = PanelConfig or {}
				PanelConfig.Title = PanelConfig.Title or "Title"
				PanelConfig.Content = PanelConfig.Content or ""
				PanelConfig.Placeholder = PanelConfig.Placeholder or nil
				PanelConfig.Default = PanelConfig.Default or ""
				PanelConfig.ButtonText = PanelConfig.Button or PanelConfig.ButtonText or "Confirm"
				PanelConfig.ButtonCallback = PanelConfig.Callback or PanelConfig.ButtonCallback or function() end
				PanelConfig.SubButtonText = PanelConfig.SubButton or PanelConfig.SubButtonText or nil
				PanelConfig.SubButtonCallback = PanelConfig.SubCallback
					or PanelConfig.SubButtonCallback
					or function() end

				local configKey = "Panel_" .. PanelConfig.Title
				if ConfigData[configKey] ~= nil then
					PanelConfig.Default = ConfigData[configKey]
				end

				local PanelFunc = { Value = PanelConfig.Default }

				local baseHeight = 50

				if PanelConfig.Placeholder then
					baseHeight = baseHeight + 40
				end

				if PanelConfig.SubButtonText then
					baseHeight = baseHeight + 40
				else
					baseHeight = baseHeight + 36
				end

				local Panel = Instance.new("Frame")
				Panel.BackgroundColor3 = DeltreTheme.Surface
				Panel.BackgroundTransparency = 0.8
				Panel.Size = UDim2.new(1, 0, 0, baseHeight)
				Panel.LayoutOrder = CountItem
				Panel.Parent = SectionAdd

				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = DeltreTheme.SmallCornerRadius
				UICorner.Parent = Panel

				local PanelStroke = CreateNeonStroke(Panel, 1)

				local Title = Instance.new("TextLabel")
				Title.Font = Enum.Font.GothamBold
				Title.Text = PanelConfig.Title
				Title.TextSize = 13
				Title.TextColor3 = DeltreTheme.TextPrimary
				Title.TextXAlignment = Enum.TextXAlignment.Left
				Title.BackgroundTransparency = 1
				Title.Position = UDim2.new(0, 10, 0, 10)
				Title.Size = UDim2.new(1, -20, 0, 13)
				Title.Parent = Panel

				local Content = Instance.new("TextLabel")
				Content.Font = Enum.Font.Gotham
				Content.Text = PanelConfig.Content
				Content.TextSize = 12
				Content.TextColor3 = DeltreTheme.TextSecondary
				Content.TextTransparency = 0
				Content.TextXAlignment = Enum.TextXAlignment.Left
				Content.BackgroundTransparency = 1
				Content.RichText = true
				Content.Position = UDim2.new(0, 10, 0, 28)
				Content.Size = UDim2.new(1, -20, 0, 14)
				Content.Parent = Panel

				local InputBox
				if PanelConfig.Placeholder then
					local InputFrame = Instance.new("Frame")
					InputFrame.AnchorPoint = Vector2.new(0.5, 0)
					InputFrame.BackgroundColor3 = DeltreTheme.Background
					InputFrame.BackgroundTransparency = 0.5
					InputFrame.Position = UDim2.new(0.5, 0, 0, 48)
					InputFrame.Size = UDim2.new(1, -20, 0, 30)
					InputFrame.Parent = Panel

					local inputCorner = Instance.new("UICorner")
					inputCorner.CornerRadius = DeltreTheme.SmallCornerRadius
					inputCorner.Parent = InputFrame

					local inputStroke = CreateNeonStroke(InputFrame, 1)

					InputBox = Instance.new("TextBox")
					InputBox.Font = Enum.Font.GothamBold
					InputBox.PlaceholderText = PanelConfig.Placeholder
					InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
					InputBox.Text = PanelConfig.Default
					InputBox.TextSize = 11
					InputBox.TextColor3 = DeltreTheme.TextPrimary
					InputBox.BackgroundTransparency = 1
					InputBox.TextXAlignment = Enum.TextXAlignment.Left
					InputBox.Size = UDim2.new(1, -10, 1, -6)
					InputBox.Position = UDim2.new(0, 5, 0, 3)
					InputBox.Parent = InputFrame
				end

				local yBtn = 0
				if PanelConfig.Placeholder then
					yBtn = 88
				else
					yBtn = 48
				end

				local ButtonMain = Instance.new("TextButton")
				ButtonMain.Font = Enum.Font.GothamBold
				ButtonMain.Text = PanelConfig.ButtonText
				ButtonMain.TextColor3 = DeltreTheme.TextPrimary
				ButtonMain.TextSize = 12
				ButtonMain.BackgroundColor3 = DeltreTheme.AccentPrimary
				ButtonMain.BackgroundTransparency = 0.7
				ButtonMain.Size = PanelConfig.SubButtonText and UDim2.new(0.5, -12, 0, 30) or UDim2.new(1, -20, 0, 30)
				ButtonMain.Position = UDim2.new(0, 10, 0, yBtn)
				ButtonMain.Parent = Panel

				local btnCorner = Instance.new("UICorner")
				btnCorner.CornerRadius = DeltreTheme.SmallCornerRadius
				btnCorner.Parent = ButtonMain

				local btnGradient = CreateNeonGradient(ButtonMain, 45)
				local btnStroke = CreateNeonStroke(ButtonMain, 1)

				ButtonMain.MouseButton1Click:Connect(function()
					PanelConfig.ButtonCallback(InputBox and InputBox.Text or "")
				end)

				if PanelConfig.SubButtonText then
					local SubButton = Instance.new("TextButton")
					SubButton.Font = Enum.Font.GothamBold
					SubButton.Text = PanelConfig.SubButtonText
					SubButton.TextColor3 = DeltreTheme.TextPrimary
					SubButton.TextSize = 12
					SubButton.BackgroundColor3 = DeltreTheme.AccentSecondary
					SubButton.BackgroundTransparency = 0.7
					SubButton.Size = UDim2.new(0.5, -12, 0, 30)
					SubButton.Position = UDim2.new(0.5, 2, 0, yBtn)
					SubButton.Parent = Panel

					local subCorner = Instance.new("UICorner")
					subCorner.CornerRadius = DeltreTheme.SmallCornerRadius
					subCorner.Parent = SubButton

					local subGradient = CreateNeonGradient(SubButton, 45)
					local subStroke = CreateNeonStroke(SubButton, 1)

					SubButton.MouseButton1Click:Connect(function()
						PanelConfig.SubButtonCallback(InputBox and InputBox.Text or "")
					end)
				end

				if InputBox then
					InputBox.FocusLost:Connect(function()
						PanelFunc.Value = InputBox.Text
						ConfigData[configKey] = InputBox.Text
						SaveConfig()
					end)
				end

				function PanelFunc:GetInput()
					return InputBox and InputBox.Text or ""
				end

				CountItem = CountItem + 1
				return PanelFunc
			end

			function Items:AddButton(ButtonConfig)
				ButtonConfig = ButtonConfig or {}
				ButtonConfig.Title = ButtonConfig.Title or "Confirm"
				ButtonConfig.Callback = ButtonConfig.Callback or function() end
				ButtonConfig.SubTitle = ButtonConfig.SubTitle or nil
				ButtonConfig.SubCallback = ButtonConfig.SubCallback or function() end

				local Button = Instance.new("Frame")
				Button.BackgroundColor3 = DeltreTheme.Surface
				Button.BackgroundTransparency = 0.8
				Button.Size = UDim2.new(1, 0, 0, 40)
				Button.LayoutOrder = CountItem
				Button.Parent = SectionAdd

				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = DeltreTheme.SmallCornerRadius
				UICorner.Parent = Button

				local ButtonStroke = CreateNeonStroke(Button, 1)

				local MainButton = Instance.new("TextButton")
				MainButton.Font = Enum.Font.GothamBold
				MainButton.Text = ButtonConfig.Title
				MainButton.TextSize = 12
				MainButton.TextColor3 = DeltreTheme.TextPrimary
				MainButton.BackgroundColor3 = DeltreTheme.AccentPrimary
				MainButton.BackgroundTransparency = 0.7
				MainButton.Size = ButtonConfig.SubTitle and UDim2.new(0.5, -8, 1, -10) or UDim2.new(1, -12, 1, -10)
				MainButton.Position = UDim2.new(0, 6, 0, 5)
				MainButton.Parent = Button

				local mainCorner = Instance.new("UICorner")
				mainCorner.CornerRadius = DeltreTheme.SmallCornerRadius
				mainCorner.Parent = MainButton

				local mainGradient = CreateNeonGradient(MainButton, 45)
				local mainStroke = CreateNeonStroke(MainButton, 1)

				MainButton.MouseButton1Click:Connect(ButtonConfig.Callback)

				if ButtonConfig.SubTitle then
					local SubButton = Instance.new("TextButton")
					SubButton.Font = Enum.Font.GothamBold
					SubButton.Text = ButtonConfig.SubTitle
					SubButton.TextSize = 12
					SubButton.TextColor3 = DeltreTheme.TextPrimary
					SubButton.BackgroundColor3 = DeltreTheme.AccentSecondary
					SubButton.BackgroundTransparency = 0.7
					SubButton.Size = UDim2.new(0.5, -8, 1, -10)
					SubButton.Position = UDim2.new(0.5, 2, 0, 5)
					SubButton.Parent = Button

					local subCorner = Instance.new("UICorner")
					subCorner.CornerRadius = DeltreTheme.SmallCornerRadius
					subCorner.Parent = SubButton

					local subGradient = CreateNeonGradient(SubButton, 45)
					local subStroke = CreateNeonStroke(SubButton, 1)

					SubButton.MouseButton1Click:Connect(ButtonConfig.SubCallback)
				end

				CountItem = CountItem + 1
			end

			function Items:AddToggle(ToggleConfig)
				local ToggleConfig = ToggleConfig or {}
				ToggleConfig.Title = ToggleConfig.Title or "Title"
				ToggleConfig.Title2 = ToggleConfig.Title2 or ""
				ToggleConfig.Content = ToggleConfig.Content or ""
				ToggleConfig.Default = ToggleConfig.Default or false
				ToggleConfig.Callback = ToggleConfig.Callback or function() end

				local configKey = "Toggle_" .. ToggleConfig.Title
				if ConfigData[configKey] ~= nil then
					ToggleConfig.Default = ConfigData[configKey]
				end

				local ToggleFunc = { Value = ToggleConfig.Default }

				local Toggle = Instance.new("Frame")
				local UICorner20 = Instance.new("UICorner")
				local ToggleTitle = Instance.new("TextLabel")
				local ToggleContent = Instance.new("TextLabel")
				local ToggleButton = Instance.new("TextButton")
				local FeatureFrame2 = Instance.new("Frame")
				local UICorner22 = Instance.new("UICorner")
				local UIStroke8 = Instance.new("UIStroke")
				local ToggleCircle = Instance.new("Frame")
				local UICorner23 = Instance.new("UICorner")

				Toggle.BackgroundColor3 = DeltreTheme.Surface
				Toggle.BackgroundTransparency = 0.8
				Toggle.BorderSizePixel = 0
				Toggle.LayoutOrder = CountItem
				Toggle.Name = "Toggle"
				Toggle.Parent = SectionAdd

				UICorner20.CornerRadius = DeltreTheme.SmallCornerRadius
				UICorner20.Parent = Toggle

				local ToggleStroke = CreateNeonStroke(Toggle, 1)

				ToggleTitle.Font = Enum.Font.GothamBold
				ToggleTitle.Text = ToggleConfig.Title
				ToggleTitle.TextSize = 13
				ToggleTitle.TextColor3 = DeltreTheme.TextPrimary
				ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
				ToggleTitle.TextYAlignment = Enum.TextYAlignment.Top
				ToggleTitle.BackgroundTransparency = 1
				ToggleTitle.Position = UDim2.new(0, 10, 0, 10)
				ToggleTitle.Size = UDim2.new(1, -100, 0, 13)
				ToggleTitle.Name = "ToggleTitle"
				ToggleTitle.Parent = Toggle

				local ToggleTitle2 = Instance.new("TextLabel")
				ToggleTitle2.Font = Enum.Font.GothamBold
				ToggleTitle2.Text = ToggleConfig.Title2
				ToggleTitle2.TextSize = 12
				ToggleTitle2.TextColor3 = DeltreTheme.TextSecondary
				ToggleTitle2.TextXAlignment = Enum.TextXAlignment.Left
				ToggleTitle2.TextYAlignment = Enum.TextYAlignment.Top
				ToggleTitle2.BackgroundTransparency = 1
				ToggleTitle2.Position = UDim2.new(0, 10, 0, 23)
				ToggleTitle2.Size = UDim2.new(1, -100, 0, 12)
				ToggleTitle2.Name = "ToggleTitle2"
				ToggleTitle2.Parent = Toggle

				ToggleContent.Font = Enum.Font.GothamBold
				ToggleContent.Text = ToggleConfig.Content
				ToggleContent.TextColor3 = DeltreTheme.TextSecondary
				ToggleContent.TextSize = 12
				ToggleContent.TextTransparency = 0.6
				ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
				ToggleContent.TextYAlignment = Enum.TextYAlignment.Bottom
				ToggleContent.BackgroundTransparency = 1
				ToggleContent.Size = UDim2.new(1, -100, 0, 12)
				ToggleContent.Name = "ToggleContent"
				ToggleContent.Parent = Toggle
				ToggleContent.RichText = true

				if ToggleConfig.Title2 ~= "" then
					Toggle.Size = UDim2.new(1, 0, 0, 57)
					ToggleContent.Position = UDim2.new(0, 10, 0, 36)
					ToggleTitle2.Visible = true
				else
					Toggle.Size = UDim2.new(1, 0, 0, 46)
					ToggleContent.Position = UDim2.new(0, 10, 0, 23)
					ToggleTitle2.Visible = false
				end

				ToggleContent.Size =
					UDim2.new(1, -100, 0, 12 + (12 * (ToggleContent.TextBounds.X // ToggleContent.AbsoluteSize.X)))
				ToggleContent.TextWrapped = true
				if ToggleConfig.Title2 ~= "" then
					Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 47)
				else
					Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 33)
				end

				ToggleContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					ToggleContent.TextWrapped = false
					ToggleContent.Size =
						UDim2.new(1, -100, 0, 12 + (12 * (ToggleContent.TextBounds.X // ToggleContent.AbsoluteSize.X)))
					if ToggleConfig.Title2 ~= "" then
						Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 47)
					else
						Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 33)
					end
					ToggleContent.TextWrapped = true
					UpdateSizeSection()
				end)

				ToggleButton.Font = Enum.Font.SourceSans
				ToggleButton.Text = ""
				ToggleButton.BackgroundTransparency = 1
				ToggleButton.Size = UDim2.new(1, 0, 1, 0)
				ToggleButton.Name = "ToggleButton"
				ToggleButton.Parent = Toggle

				FeatureFrame2.AnchorPoint = Vector2.new(1, 0.5)
				FeatureFrame2.BackgroundTransparency = 0.9
				FeatureFrame2.BackgroundColor3 = DeltreTheme.Background
				FeatureFrame2.BorderSizePixel = 0
				FeatureFrame2.Position = UDim2.new(1, -15, 0.5, 0)
				FeatureFrame2.Size = UDim2.new(0, 36, 0, 18)
				FeatureFrame2.Name = "FeatureFrame"
				FeatureFrame2.Parent = Toggle

				UICorner22.CornerRadius = UDim.new(0, 9)
				UICorner22.Parent = FeatureFrame2

				UIStroke8.Color = DeltreTheme.NeonOutline
				UIStroke8.Thickness = 2
				UIStroke8.Transparency = 0.5
				UIStroke8.Parent = FeatureFrame2

				ToggleCircle.BackgroundColor3 = DeltreTheme.TextPrimary
				ToggleCircle.BorderSizePixel = 0
				ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
				ToggleCircle.Name = "ToggleCircle"
				ToggleCircle.Parent = FeatureFrame2

				UICorner23.CornerRadius = UDim.new(0, 7)
				UICorner23.Parent = ToggleCircle

				-- Glow effect for circle
				local CircleGlow = Instance.new("UIStroke")
				CircleGlow.Color = DeltreTheme.AccentPrimary
				CircleGlow.Thickness = 2
				CircleGlow.Transparency = 0.5
				CircleGlow.Parent = ToggleCircle

				ToggleButton.Activated:Connect(function()
					ToggleFunc.Value = not ToggleFunc.Value
					ToggleFunc:Set(ToggleFunc.Value)
				end)

				function ToggleFunc:Set(Value)
					if typeof(ToggleConfig.Callback) == "function" then
						local ok, err = pcall(function()
							ToggleConfig.Callback(Value)
						end)
						if not ok then
							warn("Toggle Callback error:", err)
						end
					end
					ConfigData[configKey] = Value
					SaveConfig()
					if Value then
						TweenService:Create(ToggleTitle, TweenInfo.new(0.2), { TextColor3 = GuiConfig.Color }):Play()
						TweenService:Create(ToggleCircle, TweenInfo.new(0.2), { Position = UDim2.new(0, 20, 0, 2) })
							:Play()
						TweenService
							:Create(UIStroke8, TweenInfo.new(0.2), { Color = GuiConfig.Color, Transparency = 0.2 })
							:Play()
						TweenService:Create(
							FeatureFrame2,
							TweenInfo.new(0.2),
							{ BackgroundColor3 = GuiConfig.Color, BackgroundTransparency = 0.3 }
						):Play()
						TweenService
							:Create(CircleGlow, TweenInfo.new(0.2), { Color = GuiConfig.Color, Transparency = 0 })
							:Play()
					else
						TweenService:Create(ToggleTitle, TweenInfo.new(0.2), { TextColor3 = DeltreTheme.TextPrimary })
							:Play()
						TweenService:Create(ToggleCircle, TweenInfo.new(0.2), { Position = UDim2.new(0, 2, 0, 2) })
							:Play()
						TweenService
							:Create(
								UIStroke8,
								TweenInfo.new(0.2),
								{ Color = DeltreTheme.NeonOutline, Transparency = 0.5 }
							)
							:Play()
						TweenService:Create(
							FeatureFrame2,
							TweenInfo.new(0.2),
							{ BackgroundColor3 = DeltreTheme.Background, BackgroundTransparency = 0.9 }
						):Play()
						TweenService:Create(
							CircleGlow,
							TweenInfo.new(0.2),
							{ Color = DeltreTheme.AccentPrimary, Transparency = 0.5 }
						):Play()
					end
				end

				ToggleFunc:Set(ToggleFunc.Value)
				CountItem = CountItem + 1
				Elements[configKey] = ToggleFunc
				return ToggleFunc
			end

			function Items:AddSlider(SliderConfig)
				local SliderConfig = SliderConfig or {}
				SliderConfig.Title = SliderConfig.Title or "Slider"
				SliderConfig.Content = SliderConfig.Content or ""
				SliderConfig.Increment = SliderConfig.Increment or 1
				SliderConfig.Min = SliderConfig.Min or 0
				SliderConfig.Max = SliderConfig.Max or 100
				SliderConfig.Default = SliderConfig.Default or 50
				SliderConfig.Callback = SliderConfig.Callback or function() end

				local configKey = "Slider_" .. SliderConfig.Title
				if ConfigData[configKey] ~= nil then
					SliderConfig.Default = ConfigData[configKey]
				end

				local SliderFunc = { Value = SliderConfig.Default }

				local Slider = Instance.new("Frame")
				local UICorner15 = Instance.new("UICorner")
				local SliderTitle = Instance.new("TextLabel")
				local SliderContent = Instance.new("TextLabel")
				local SliderInput = Instance.new("Frame")
				local UICorner16 = Instance.new("UICorner")
				local TextBox = Instance.new("TextBox")
				local SliderFrame = Instance.new("Frame")
				local UICorner17 = Instance.new("UICorner")
				local SliderDraggable = Instance.new("Frame")
				local UICorner18 = Instance.new("UICorner")
				local UIStroke5 = Instance.new("UIStroke")
				local SliderCircle = Instance.new("Frame")
				local UICorner19 = Instance.new("UICorner")
				local UIStroke6 = Instance.new("UIStroke")
				local UIStroke7 = Instance.new("UIStroke")

				Slider.BackgroundColor3 = DeltreTheme.Surface
				Slider.BackgroundTransparency = 0.8
				Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Slider.BorderSizePixel = 0
				Slider.LayoutOrder = CountItem
				Slider.Size = UDim2.new(1, 0, 0, 46)
				Slider.Name = "Slider"
				Slider.Parent = SectionAdd

				UICorner15.CornerRadius = DeltreTheme.SmallCornerRadius
				UICorner15.Parent = Slider

				local SliderStroke = CreateNeonStroke(Slider, 1)

				SliderTitle.Font = Enum.Font.GothamBold
				SliderTitle.Text = SliderConfig.Title
				SliderTitle.TextColor3 = DeltreTheme.TextPrimary
				SliderTitle.TextSize = 13
				SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
				SliderTitle.TextYAlignment = Enum.TextYAlignment.Top
				SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderTitle.BackgroundTransparency = 0.999
				SliderTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderTitle.BorderSizePixel = 0
				SliderTitle.Position = UDim2.new(0, 10, 0, 10)
				SliderTitle.Size = UDim2.new(1, -180, 0, 13)
				SliderTitle.Name = "SliderTitle"
				SliderTitle.Parent = Slider

				SliderContent.Font = Enum.Font.GothamBold
				SliderContent.Text = SliderConfig.Content
				SliderContent.TextColor3 = DeltreTheme.TextSecondary
				SliderContent.TextSize = 12
				SliderContent.TextTransparency = 0.6
				SliderContent.TextXAlignment = Enum.TextXAlignment.Left
				SliderContent.TextYAlignment = Enum.TextYAlignment.Bottom
				SliderContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderContent.BackgroundTransparency = 0.999
				SliderContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderContent.BorderSizePixel = 0
				SliderContent.Position = UDim2.new(0, 10, 0, 25)
				SliderContent.Size = UDim2.new(1, -180, 0, 12)
				SliderContent.Name = "SliderContent"
				SliderContent.Parent = Slider
				SliderContent.RichText = true

				SliderContent.Size =
					UDim2.new(1, -180, 0, 12 + (12 * (SliderContent.TextBounds.X // SliderContent.AbsoluteSize.X)))
				SliderContent.TextWrapped = true
				Slider.Size = UDim2.new(1, 0, 0, SliderContent.AbsoluteSize.Y + 33)

				SliderContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					SliderContent.TextWrapped = false
					SliderContent.Size =
						UDim2.new(1, -180, 0, 12 + (12 * (SliderContent.TextBounds.X // SliderContent.AbsoluteSize.X)))
					Slider.Size = UDim2.new(1, 0, 0, SliderContent.AbsoluteSize.Y + 33)
					SliderContent.TextWrapped = true
					UpdateSizeSection()
				end)

				SliderInput.AnchorPoint = Vector2.new(0, 0.5)
				SliderInput.BackgroundColor3 = DeltreTheme.AccentPrimary
				SliderInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderInput.BackgroundTransparency = 0.7
				SliderInput.BorderSizePixel = 0
				SliderInput.Position = UDim2.new(1, -155, 0.5, 0)
				SliderInput.Size = UDim2.new(0, 32, 0, 20)
				SliderInput.Name = "SliderInput"
				SliderInput.Parent = Slider

				UICorner16.CornerRadius = DeltreTheme.SmallCornerRadius
				UICorner16.Parent = SliderInput

				local InputGradient = CreateNeonGradient(SliderInput, 45)
				local InputStroke = CreateNeonStroke(SliderInput, 1)

				TextBox.Font = Enum.Font.GothamBold
				TextBox.Text = "90"
				TextBox.TextColor3 = DeltreTheme.TextPrimary
				TextBox.TextSize = 13
				TextBox.TextWrapped = true
				TextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				TextBox.BackgroundTransparency = 0.999
				TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextBox.BorderSizePixel = 0
				TextBox.Position = UDim2.new(0, -1, 0, 0)
				TextBox.Size = UDim2.new(1, 0, 1, 0)
				TextBox.Parent = SliderInput

				SliderFrame.AnchorPoint = Vector2.new(1, 0.5)
				SliderFrame.BackgroundColor3 = DeltreTheme.Background
				SliderFrame.BackgroundTransparency = 0.5
				SliderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderFrame.BorderSizePixel = 0
				SliderFrame.Position = UDim2.new(1, -20, 0.5, 0)
				SliderFrame.Size = UDim2.new(0, 100, 0, 4)
				SliderFrame.Name = "SliderFrame"
				SliderFrame.Parent = Slider

				UICorner17.CornerRadius = UDim.new(0, 2)
				UICorner17.Parent = SliderFrame

				local FrameStroke = CreateNeonStroke(SliderFrame, 1)

				SliderDraggable.AnchorPoint = Vector2.new(0, 0.5)
				SliderDraggable.BackgroundColor3 = GuiConfig.Color
				SliderDraggable.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderDraggable.BorderSizePixel = 0
				SliderDraggable.Position = UDim2.new(0, 0, 0.5, 0)
				SliderDraggable.Size = UDim2.new(0.899999976, 0, 0, 2)
				SliderDraggable.Name = "SliderDraggable"
				SliderDraggable.Parent = SliderFrame

				UICorner18.CornerRadius = UDim.new(0, 1)
				UICorner18.Parent = SliderDraggable

				SliderCircle.AnchorPoint = Vector2.new(1, 0.5)
				SliderCircle.BackgroundColor3 = DeltreTheme.TextPrimary
				SliderCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderCircle.BorderSizePixel = 0
				SliderCircle.Position = UDim2.new(1, 4, 0.5, 0)
				SliderCircle.Size = UDim2.new(0, 10, 0, 10)
				SliderCircle.Name = "SliderCircle"
				SliderCircle.Parent = SliderDraggable

				UICorner19.CornerRadius = UDim.new(0, 5)
				UICorner19.Parent = SliderCircle

				UIStroke6.Color = GuiConfig.Color
				UIStroke6.Thickness = 2
				UIStroke6.Parent = SliderCircle

				-- Glow effect
				local SliderGlow = Instance.new("UIStroke")
				SliderGlow.Color = GuiConfig.Color
				SliderGlow.Thickness = 3
				SliderGlow.Transparency = 0.7
				SliderGlow.Parent = SliderCircle

				local Dragging = false

				local function Round(Number, Factor)
					if Factor == 0 then
						return Number
					end
					return math.floor((Number / Factor) + 0.5) * Factor
				end

				function SliderFunc:Set(Value)
					local rawValue =
						math.clamp(Round(Value, SliderConfig.Increment), SliderConfig.Min, SliderConfig.Max)

					local decimals = 0
					local incStr = tostring(SliderConfig.Increment)
					if string.find(incStr, "%.") then
						decimals = #string.split(incStr, ".")[2]
					end
					local formattedValue = tonumber(string.format("%." .. decimals .. "f", rawValue))

					if SliderFunc.Value == formattedValue and TextBox.Text == tostring(formattedValue) then
						return
					end

					SliderFunc.Value = formattedValue
					TextBox.Text = tostring(formattedValue)

					local scale = 0
					if SliderConfig.Max > SliderConfig.Min then
						scale = (formattedValue - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
					end

					TweenService:Create(
						SliderDraggable,
						TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
						{ Size = UDim2.fromScale(scale, 1) }
					):Play()

					SliderConfig.Callback(formattedValue)
					ConfigData[configKey] = formattedValue
					SaveConfig()
				end

				SliderFrame.InputBegan:Connect(function(Input)
					if
						Input.UserInputType == Enum.UserInputType.MouseButton1
						or Input.UserInputType == Enum.UserInputType.Touch
					then
						Dragging = true
						TweenService:Create(
							SliderCircle,
							TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
							{ Size = UDim2.new(0, 16, 0, 16) }
						):Play()
						local SizeScale = math.clamp(
							(Input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X,
							0,
							1
						)
						SliderFunc:Set(SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale))
					end
				end)

				SliderFrame.InputEnded:Connect(function(Input)
					if
						Input.UserInputType == Enum.UserInputType.MouseButton1
						or Input.UserInputType == Enum.UserInputType.Touch
					then
						Dragging = false
						TweenService:Create(
							SliderCircle,
							TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
							{ Size = UDim2.new(0, 10, 0, 10) }
						):Play()
					end
				end)

				UserInputService.InputChanged:Connect(function(Input)
					if
						Dragging
						and (
							Input.UserInputType == Enum.UserInputType.MouseMovement
							or Input.UserInputType == Enum.UserInputType.Touch
						)
					then
						local SizeScale = math.clamp(
							(Input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X,
							0,
							1
						)
						SliderFunc:Set(SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale))
					end
				end)

				TextBox.FocusLost:Connect(function()
					local ValidNumber = tonumber(TextBox.Text)
					if ValidNumber then
						SliderFunc:Set(ValidNumber)
					else
						SliderFunc:Set(SliderFunc.Value)
					end
				end)

				SliderFunc:Set(SliderConfig.Default)
				CountItem = CountItem + 1
				Elements[configKey] = SliderFunc
				return SliderFunc
			end
			function Items:AddInput(InputConfig)
				local InputConfig = InputConfig or {}
				InputConfig.Title = InputConfig.Title or "Title"
				InputConfig.Content = InputConfig.Content or ""
				InputConfig.Callback = InputConfig.Callback or function() end
				InputConfig.Default = InputConfig.Default or ""

				local configKey = "Input_" .. InputConfig.Title
				if ConfigData[configKey] ~= nil then
					InputConfig.Default = ConfigData[configKey]
				end

				local InputFunc = { Value = InputConfig.Default }

				local Input = Instance.new("Frame")
				local UICorner12 = Instance.new("UICorner")
				local InputTitle = Instance.new("TextLabel")
				local InputContent = Instance.new("TextLabel")
				local InputFrame = Instance.new("Frame")
				local UICorner13 = Instance.new("UICorner")
				local InputTextBox = Instance.new("TextBox")

				Input.BackgroundColor3 = DeltreTheme.Surface
				Input.BackgroundTransparency = 0.8
				Input.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Input.BorderSizePixel = 0
				Input.LayoutOrder = CountItem
				Input.Size = UDim2.new(1, 0, 0, 46)
				Input.Name = "Input"
				Input.Parent = SectionAdd

				UICorner12.CornerRadius = DeltreTheme.SmallCornerRadius
				UICorner12.Parent = Input

				local InputStroke = CreateNeonStroke(Input, 1)

				InputTitle.Font = Enum.Font.GothamBold
				InputTitle.Text = InputConfig.Title or "TextBox"
				InputTitle.TextColor3 = DeltreTheme.TextPrimary
				InputTitle.TextSize = 13
				InputTitle.TextXAlignment = Enum.TextXAlignment.Left
				InputTitle.TextYAlignment = Enum.TextYAlignment.Top
				InputTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputTitle.BackgroundTransparency = 0.999
				InputTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputTitle.BorderSizePixel = 0
				InputTitle.Position = UDim2.new(0, 10, 0, 10)
				InputTitle.Size = UDim2.new(1, -180, 0, 13)
				InputTitle.Name = "InputTitle"
				InputTitle.Parent = Input

				InputContent.Font = Enum.Font.GothamBold
				InputContent.Text = InputConfig.Content or "This is a TextBox"
				InputContent.TextColor3 = DeltreTheme.TextSecondary
				InputContent.TextSize = 12
				InputContent.TextTransparency = 0.6
				InputContent.TextWrapped = true
				InputContent.TextXAlignment = Enum.TextXAlignment.Left
				InputContent.TextYAlignment = Enum.TextYAlignment.Bottom
				InputContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputContent.BackgroundTransparency = 0.999
				InputContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputContent.BorderSizePixel = 0
				InputContent.Position = UDim2.new(0, 10, 0, 25)
				InputContent.Size = UDim2.new(1, -180, 0, 12)
				InputContent.Name = "InputContent"
				InputContent.Parent = Input
				InputContent.RichText = true

				InputContent.Size =
					UDim2.new(1, -180, 0, 12 + (12 * (InputContent.TextBounds.X // InputContent.AbsoluteSize.X)))
				InputContent.TextWrapped = true
				Input.Size = UDim2.new(1, 0, 0, InputContent.AbsoluteSize.Y + 33)

				InputContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					InputContent.TextWrapped = false
					InputContent.Size =
						UDim2.new(1, -180, 0, 12 + (12 * (InputContent.TextBounds.X // InputContent.AbsoluteSize.X)))
					Input.Size = UDim2.new(1, 0, 0, InputContent.AbsoluteSize.Y + 33)
					InputContent.TextWrapped = true
					UpdateSizeSection()
				end)

				InputFrame.AnchorPoint = Vector2.new(1, 0.5)
				InputFrame.BackgroundColor3 = DeltreTheme.Background
				InputFrame.BackgroundTransparency = 0.5
				InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputFrame.BorderSizePixel = 0
				InputFrame.ClipsDescendants = true
				InputFrame.Position = UDim2.new(1, -7, 0.5, 0)
				InputFrame.Size = UDim2.new(0, 148, 0, 30)
				InputFrame.Name = "InputFrame"
				InputFrame.Parent = Input

				UICorner13.CornerRadius = DeltreTheme.SmallCornerRadius
				UICorner13.Parent = InputFrame

				local InputFrameStroke = CreateNeonStroke(InputFrame, 1)

				InputTextBox.CursorPosition = -1
				InputTextBox.Font = Enum.Font.GothamBold
				InputTextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
				InputTextBox.PlaceholderText = "Input Here"
				InputTextBox.Text = InputConfig.Default
				InputTextBox.TextColor3 = DeltreTheme.TextPrimary
				InputTextBox.TextSize = 12
				InputTextBox.TextXAlignment = Enum.TextXAlignment.Left
				InputTextBox.AnchorPoint = Vector2.new(0, 0.5)
				InputTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputTextBox.BackgroundTransparency = 0.999
				InputTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputTextBox.BorderSizePixel = 0
				InputTextBox.Position = UDim2.new(0, 5, 0.5, 0)
				InputTextBox.Size = UDim2.new(1, -10, 1, -8)
				InputTextBox.Name = "InputTextBox"
				InputTextBox.Parent = InputFrame

				function InputFunc:Set(Value)
					InputTextBox.Text = Value
					InputFunc.Value = Value
					InputConfig.Callback(Value)
					ConfigData[configKey] = Value
					SaveConfig()
				end

				InputFunc:Set(InputFunc.Value)

				InputTextBox.FocusLost:Connect(function()
					InputFunc:Set(InputTextBox.Text)
				end)
				CountItem = CountItem + 1
				Elements[configKey] = InputFunc
				return InputFunc
			end

			function Items:AddDropdown(DropdownConfig)
				local DropdownConfig = DropdownConfig or {}
				DropdownConfig.Title = DropdownConfig.Title or "Title"
				DropdownConfig.Content = DropdownConfig.Content or ""
				DropdownConfig.Multi = DropdownConfig.Multi or false
				DropdownConfig.Options = DropdownConfig.Options or {}
				DropdownConfig.Default = DropdownConfig.Default or (DropdownConfig.Multi and {} or nil)
				DropdownConfig.Callback = DropdownConfig.Callback or function() end

				local configKey = "Dropdown_" .. DropdownConfig.Title
				if ConfigData[configKey] ~= nil then
					DropdownConfig.Default = ConfigData[configKey]
				end

				local DropdownFunc = { Value = DropdownConfig.Default, Options = DropdownConfig.Options }

				local Dropdown = Instance.new("Frame")
				local DropdownButton = Instance.new("TextButton")
				local UICorner10 = Instance.new("UICorner")
				local DropdownTitle = Instance.new("TextLabel")
				local DropdownContent = Instance.new("TextLabel")
				local SelectOptionsFrame = Instance.new("Frame")
				local UICorner11 = Instance.new("UICorner")
				local OptionSelecting = Instance.new("TextLabel")
				local OptionImg = Instance.new("ImageLabel")

				Dropdown.BackgroundColor3 = DeltreTheme.Surface
				Dropdown.BackgroundTransparency = 0.8
				Dropdown.BorderSizePixel = 0
				Dropdown.LayoutOrder = CountItem
				Dropdown.Size = UDim2.new(1, 0, 0, 46)
				Dropdown.Name = "Dropdown"
				Dropdown.Parent = SectionAdd

				DropdownButton.Text = ""
				DropdownButton.BackgroundTransparency = 1
				DropdownButton.Size = UDim2.new(1, 0, 1, 0)
				DropdownButton.Name = "ToggleButton"
				DropdownButton.Parent = Dropdown

				UICorner10.CornerRadius = DeltreTheme.SmallCornerRadius
				UICorner10.Parent = Dropdown

				local DropdownStroke = CreateNeonStroke(Dropdown, 1)

				DropdownTitle.Font = Enum.Font.GothamBold
				DropdownTitle.Text = DropdownConfig.Title
				DropdownTitle.TextColor3 = DeltreTheme.TextPrimary
				DropdownTitle.TextSize = 13
				DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
				DropdownTitle.BackgroundTransparency = 1
				DropdownTitle.Position = UDim2.new(0, 10, 0, 10)
				DropdownTitle.Size = UDim2.new(1, -180, 0, 13)
				DropdownTitle.Name = "DropdownTitle"
				DropdownTitle.Parent = Dropdown

				DropdownContent.Font = Enum.Font.GothamBold
				DropdownContent.Text = DropdownConfig.Content
				DropdownContent.TextColor3 = DeltreTheme.TextSecondary
				DropdownContent.TextSize = 12
				DropdownContent.TextTransparency = 0.6
				DropdownContent.TextWrapped = true
				DropdownContent.TextXAlignment = Enum.TextXAlignment.Left
				DropdownContent.BackgroundTransparency = 1
				DropdownContent.Position = UDim2.new(0, 10, 0, 25)
				DropdownContent.Size = UDim2.new(1, -180, 0, 12)
				DropdownContent.Name = "DropdownContent"
				DropdownContent.Parent = Dropdown
				DropdownContent.RichText = true

				SelectOptionsFrame.AnchorPoint = Vector2.new(1, 0.5)
				SelectOptionsFrame.BackgroundColor3 = DeltreTheme.Background
				SelectOptionsFrame.BackgroundTransparency = 0.5
				SelectOptionsFrame.Position = UDim2.new(1, -7, 0.5, 0)
				SelectOptionsFrame.Size = UDim2.new(0, 148, 0, 30)
				SelectOptionsFrame.Name = "SelectOptionsFrame"
				SelectOptionsFrame.LayoutOrder = CountDropdown
				SelectOptionsFrame.Parent = Dropdown

				UICorner11.CornerRadius = DeltreTheme.SmallCornerRadius
				UICorner11.Parent = SelectOptionsFrame

				local SelectStroke = CreateNeonStroke(SelectOptionsFrame, 1)

				DropdownButton.Activated:Connect(function()
					if not MoreBlur.Visible then
						MoreBlur.Visible = true
						DropPageLayout:JumpToIndex(SelectOptionsFrame.LayoutOrder)
						TweenService:Create(MoreBlur, TweenInfo.new(0.3), { BackgroundTransparency = 0.7 }):Play()
						TweenService
							:Create(DropdownSelect, TweenInfo.new(0.3), { Position = UDim2.new(1, -11, 0.5, 0) })
							:Play()
					end
				end)

				OptionSelecting.Font = Enum.Font.GothamBold
				OptionSelecting.Text = DropdownConfig.Multi and "Select Options" or "Select Option"
				OptionSelecting.TextColor3 = DeltreTheme.TextPrimary
				OptionSelecting.TextSize = 12
				OptionSelecting.TextTransparency = 0.6
				OptionSelecting.TextXAlignment = Enum.TextXAlignment.Left
				OptionSelecting.AnchorPoint = Vector2.new(0, 0.5)
				OptionSelecting.BackgroundTransparency = 1
				OptionSelecting.Position = UDim2.new(0, 5, 0.5, 0)
				OptionSelecting.Size = UDim2.new(1, -30, 1, -8)
				OptionSelecting.Name = "OptionSelecting"
				OptionSelecting.Parent = SelectOptionsFrame

				OptionImg.Image = "rbxassetid://16851841101"
				OptionImg.ImageColor3 = DeltreTheme.AccentPrimary
				OptionImg.AnchorPoint = Vector2.new(1, 0.5)
				OptionImg.BackgroundTransparency = 1
				OptionImg.Position = UDim2.new(1, 0, 0.5, 0)
				OptionImg.Size = UDim2.new(0, 25, 0, 25)
				OptionImg.Name = "OptionImg"
				OptionImg.Parent = SelectOptionsFrame

				local DropdownContainer = Instance.new("Frame")
				DropdownContainer.Size = UDim2.new(1, 0, 1, 0)
				DropdownContainer.BackgroundTransparency = 1
				DropdownContainer.Parent = DropdownFolder

				local SearchBox = Instance.new("TextBox")
				SearchBox.PlaceholderText = "Search"
				SearchBox.Font = Enum.Font.Gotham
				SearchBox.Text = ""
				SearchBox.TextSize = 12
				SearchBox.TextColor3 = DeltreTheme.TextPrimary
				SearchBox.BackgroundColor3 = DeltreTheme.Surface
				SearchBox.BackgroundTransparency = 0.5
				SearchBox.BorderSizePixel = 0
				SearchBox.Size = UDim2.new(1, 0, 0, 25)
				SearchBox.Position = UDim2.new(0, 0, 0, 0)
				SearchBox.ClearTextOnFocus = false
				SearchBox.Name = "SearchBox"
				SearchBox.Parent = DropdownContainer

				local SearchCorner = Instance.new("UICorner")
				SearchCorner.CornerRadius = DeltreTheme.SmallCornerRadius
				SearchCorner.Parent = SearchBox

				local SearchStroke = CreateNeonStroke(SearchBox, 1)

				local ScrollSelect = Instance.new("ScrollingFrame")
				ScrollSelect.Size = UDim2.new(1, 0, 1, -30)
				ScrollSelect.Position = UDim2.new(0, 0, 0, 30)
				ScrollSelect.ScrollBarImageColor3 = DeltreTheme.AccentPrimary
				ScrollSelect.ScrollBarThickness = 2
				ScrollSelect.BorderSizePixel = 0
				ScrollSelect.BackgroundTransparency = 1
				ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, 0)
				ScrollSelect.Name = "ScrollSelect"
				ScrollSelect.Parent = DropdownContainer

				local UIListLayout4 = Instance.new("UIListLayout")
				UIListLayout4.Padding = UDim.new(0, 3)
				UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout4.Parent = ScrollSelect

				UIListLayout4:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, UIListLayout4.AbsoluteContentSize.Y)
				end)

				SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
					local query = string.lower(SearchBox.Text)
					for _, option in pairs(ScrollSelect:GetChildren()) do
						if option.Name == "Option" and option:FindFirstChild("OptionText") then
							local text = string.lower(option.OptionText.Text)
							option.Visible = query == "" or string.find(text, query, 1, true)
						end
					end
					ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, UIListLayout4.AbsoluteContentSize.Y)
				end)

				local DropCount = 0

				function DropdownFunc:Clear()
					for _, DropFrame in ScrollSelect:GetChildren() do
						if DropFrame.Name == "Option" then
							DropFrame:Destroy()
						end
					end
					DropdownFunc.Value = DropdownConfig.Multi and {} or nil
					DropdownFunc.Options = {}
					OptionSelecting.Text = DropdownConfig.Multi and "Select Options" or "Select Option"
					DropCount = 0
				end

				function DropdownFunc:AddOption(option)
					local label, value
					if typeof(option) == "table" and option.Label and option.Value ~= nil then
						label = tostring(option.Label)
						value = option.Value
					else
						label = tostring(option)
						value = option
					end

					local Option = Instance.new("Frame")
					local OptionButton = Instance.new("TextButton")
					local OptionText = Instance.new("TextLabel")
					local ChooseFrame = Instance.new("Frame")
					local UIStroke15 = Instance.new("UIStroke")
					local UICorner38 = Instance.new("UICorner")
					local UICorner37 = Instance.new("UICorner")

					Option.BackgroundColor3 = DeltreTheme.Surface
					Option.BackgroundTransparency = 0.95
					Option.Size = UDim2.new(1, 0, 0, 30)
					Option.Name = "Option"
					Option.Parent = ScrollSelect

					UICorner37.CornerRadius = DeltreTheme.SmallCornerRadius
					UICorner37.Parent = Option

					OptionButton.BackgroundTransparency = 1
					OptionButton.Size = UDim2.new(1, 0, 1, 0)
					OptionButton.Text = ""
					OptionButton.Name = "OptionButton"
					OptionButton.Parent = Option

					OptionText.Font = Enum.Font.GothamBold
					OptionText.Text = label
					OptionText.TextSize = 13
					OptionText.TextColor3 = DeltreTheme.TextPrimary
					OptionText.Position = UDim2.new(0, 8, 0, 8)
					OptionText.Size = UDim2.new(1, -100, 0, 13)
					OptionText.BackgroundTransparency = 1
					OptionText.TextXAlignment = Enum.TextXAlignment.Left
					OptionText.Name = "OptionText"
					OptionText.Parent = Option

					Option:SetAttribute("RealValue", value)

					ChooseFrame.AnchorPoint = Vector2.new(0, 0.5)
					ChooseFrame.BackgroundColor3 = GuiConfig.Color
					ChooseFrame.Position = UDim2.new(0, 2, 0.5, 0)
					ChooseFrame.Size = UDim2.new(0, 0, 0, 0)
					ChooseFrame.Name = "ChooseFrame"
					ChooseFrame.Parent = Option

					UIStroke15.Color = GuiConfig.Color
					UIStroke15.Thickness = 2
					UIStroke15.Transparency = 0.999
					UIStroke15.Parent = ChooseFrame
					UICorner38.CornerRadius = UDim.new(0, 1)
					UICorner38.Parent = ChooseFrame

					OptionButton.Activated:Connect(function()
						if DropdownConfig.Multi then
							if not table.find(DropdownFunc.Value, value) then
								table.insert(DropdownFunc.Value, value)
							else
								for i, v in pairs(DropdownFunc.Value) do
									if v == value then
										table.remove(DropdownFunc.Value, i)
										break
									end
								end
							end
						else
							DropdownFunc.Value = value
						end
						DropdownFunc:Set(DropdownFunc.Value)
					end)
				end

				function DropdownFunc:Set(Value)
					if DropdownConfig.Multi then
						DropdownFunc.Value = type(Value) == "table" and Value or {}
					else
						DropdownFunc.Value = (type(Value) == "table" and Value[1]) or Value
					end

					ConfigData[configKey] = DropdownFunc.Value
					SaveConfig()

					local texts = {}
					for _, Drop in ScrollSelect:GetChildren() do
						if Drop.Name == "Option" and Drop:FindFirstChild("OptionText") then
							local v = Drop:GetAttribute("RealValue")
							local selected = DropdownConfig.Multi and table.find(DropdownFunc.Value, v)
								or DropdownFunc.Value == v

							if selected then
								TweenService
									:Create(Drop.ChooseFrame, TweenInfo.new(0.2), { Size = UDim2.new(0, 2, 0, 12) })
									:Play()
								TweenService:Create(Drop.ChooseFrame.UIStroke, TweenInfo.new(0.2), { Transparency = 0 })
									:Play()
								TweenService:Create(Drop, TweenInfo.new(0.2), { BackgroundTransparency = 0.8 }):Play()
								table.insert(texts, Drop.OptionText.Text)
							else
								TweenService
									:Create(Drop.ChooseFrame, TweenInfo.new(0.1), { Size = UDim2.new(0, 0, 0, 0) })
									:Play()
								TweenService
									:Create(Drop.ChooseFrame.UIStroke, TweenInfo.new(0.1), { Transparency = 0.999 })
									:Play()
								TweenService:Create(Drop, TweenInfo.new(0.1), { BackgroundTransparency = 0.95 }):Play()
							end
						end
					end

					OptionSelecting.Text = (#texts == 0)
							and (DropdownConfig.Multi and "Select Options" or "Select Option")
						or table.concat(texts, ", ")

					if DropdownConfig.Callback then
						if DropdownConfig.Multi then
							DropdownConfig.Callback(DropdownFunc.Value)
						else
							local str = (DropdownFunc.Value ~= nil) and tostring(DropdownFunc.Value) or ""
							DropdownConfig.Callback(str)
						end
					end
				end

				function DropdownFunc:SetValue(val)
					self:Set(val)
				end

				function DropdownFunc:GetValue()
					return self.Value
				end

				function DropdownFunc:SetValues(newList, selecting)
					newList = newList or {}
					selecting = selecting or (DropdownConfig.Multi and {} or nil)
					DropdownFunc:Clear()
					for _, v in ipairs(newList) do
						DropdownFunc:AddOption(v)
					end
					DropdownFunc.Options = newList
					DropdownFunc:Set(selecting)
				end

				DropdownFunc:SetValues(DropdownFunc.Options, DropdownFunc.Value)

				CountItem = CountItem + 1
				CountDropdown = CountDropdown + 1
				Elements[configKey] = DropdownFunc
				return DropdownFunc
			end

			function Items:AddDivider()
				local Divider = Instance.new("Frame")
				Divider.Name = "Divider"
				Divider.Parent = SectionAdd
				Divider.AnchorPoint = Vector2.new(0.5, 0)
				Divider.Position = UDim2.new(0.5, 0, 0, 0)
				Divider.Size = UDim2.new(1, 0, 0, 2)
				Divider.BackgroundColor3 = DeltreTheme.NeonOutline
				Divider.BackgroundTransparency = 0.5
				Divider.BorderSizePixel = 0
				Divider.LayoutOrder = CountItem

				local UIGradient = Instance.new("UIGradient")
				UIGradient.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, DeltreTheme.Background),
					ColorSequenceKeypoint.new(0.5, GuiConfig.Color),
					ColorSequenceKeypoint.new(1, DeltreTheme.Background),
				})
				UIGradient.Parent = Divider

				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = UDim.new(0, 1)
				UICorner.Parent = Divider

				CountItem = CountItem + 1
				return Divider
			end

			function Items:AddSubSection(title)
				title = title or "Sub Section"

				local SubSection = Instance.new("Frame")
				SubSection.Name = "SubSection"
				SubSection.Parent = SectionAdd
				SubSection.BackgroundTransparency = 1
				SubSection.Size = UDim2.new(1, 0, 0, 24)
				SubSection.LayoutOrder = CountItem

				local Background = Instance.new("Frame")
				Background.Parent = SubSection
				Background.Size = UDim2.new(1, 0, 1, 0)
				Background.BackgroundColor3 = DeltreTheme.Surface
				Background.BackgroundTransparency = 0.85
				Background.BorderSizePixel = 0
				Instance.new("UICorner", Background).CornerRadius = DeltreTheme.SmallCornerRadius

				local SubStroke = CreateNeonStroke(Background, 1)

				local Label = Instance.new("TextLabel")
				Label.Parent = SubSection
				Label.AnchorPoint = Vector2.new(0, 0.5)
				Label.Position = UDim2.new(0, 10, 0.5, 0)
				Label.Size = UDim2.new(1, -20, 1, 0)
				Label.BackgroundTransparency = 1
				Label.Font = Enum.Font.GothamBold
				Label.Text = "── [ " .. title .. " ] ──"
				Label.TextColor3 = DeltreTheme.AccentPrimary
				Label.TextSize = 12
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.RichText = true

				CountItem = CountItem + 1
				return SubSection
			end

			CountSection = CountSection + 1
			return Items
		end

		CountTab = CountTab + 1
		local safeName = TabConfig.Name:gsub("%s+", "_")
		_G[safeName] = Sections
		return Sections
	end

	return Tabs
end

function Deltrehub:MakeKeySystem(KeyConfig)
	KeyConfig = KeyConfig or {}
	KeyConfig.Title = KeyConfig.Title or "DeltreHub Key System"
	KeyConfig.Subtitle = KeyConfig.Subtitle or "Choose a checkpoint to get your key"
	KeyConfig.Color = KeyConfig.Color or DeltreTheme.AccentPrimary

	local KeyFunc = {}
	local CoreGui = game:GetService("CoreGui")
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")

	local Mouse = game.Players.LocalPlayer and game.Players.LocalPlayer:GetMouse()

	local LinkvertiseOrange = Color3.fromRGB(255, 107, 53)
	local LinkvertiseDark = Color3.fromRGB(45, 45, 55)
	local LootLabsPurple = Color3.fromRGB(139, 92, 246)
	local LootLabsYellow = Color3.fromRGB(246, 201, 69)
	local LootLabsDark = Color3.fromRGB(30, 25, 45)

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "DeltreKeySystem"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = CoreGui

	local ParticleFrame = Instance.new("Frame")
	ParticleFrame.Name = "ParticleFrame"
	ParticleFrame.Size = UDim2.new(1, 0, 1, 0)
	ParticleFrame.BackgroundTransparency = 1
	ParticleFrame.ZIndex = 0
	ParticleFrame.ClipsDescendants = true
	ParticleFrame.Parent = ScreenGui

	local particles = {}
	for i = 1, 20 do
		local particle = Instance.new("Frame")
		particle.Size = UDim2.new(0, math.random(3, 8), 0, math.random(3, 8))
		particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
		particle.BackgroundColor3 = math.random() > 0.5 and DeltreTheme.AccentPrimary or DeltreTheme.AccentTertiary
		particle.BackgroundTransparency = math.random(60, 90) / 100
		particle.BorderSizePixel = 0
		particle.ZIndex = 0

		local pCorner = Instance.new("UICorner")
		pCorner.CornerRadius = UDim.new(1, 0)
		pCorner.Parent = particle

		particle.Parent = ParticleFrame
		table.insert(particles, {
			frame = particle,
			speedX = (math.random() - 0.5) * 0.002,
			speedY = (math.random() - 0.5) * 0.002,
		})
	end

	task.spawn(function()
		while ParticleFrame and ParticleFrame.Parent do
			for _, p in ipairs(particles) do
				if p.frame and p.frame.Parent then
					local newPos = p.frame.Position
					newPos = UDim2.new(
						math.clamp(newPos.X.Scale + p.speedX, 0, 1),
						0,
						math.clamp(newPos.Y.Scale + p.speedY, 0, 1),
						0
					)
					p.frame.Position = newPos

					if newPos.X.Scale <= 0 or newPos.X.Scale >= 1 then
						p.speedX = -p.speedX
					end
					if newPos.Y.Scale <= 0 or newPos.Y.Scale >= 1 then
						p.speedY = -p.speedY
					end
				end
			end
			task.wait(0.03)
		end
	end)

	local MainHolder = Instance.new("Frame")
	MainHolder.Name = "MainHolder"
	MainHolder.BackgroundTransparency = 1
	MainHolder.BorderSizePixel = 0
	MainHolder.AnchorPoint = Vector2.new(0.5, 0.5)
	MainHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainHolder.Size = UDim2.new(0, 0, 0, 0)
	MainHolder.ZIndex = 10
	MainHolder.ClipsDescendants = false
	MainHolder.Parent = ScreenGui

	TweenService:Create(MainHolder, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 520, 0, 440),
	}):Play()

	local NeonBorder = Instance.new("Frame")
	NeonBorder.Name = "NeonBorder"
	NeonBorder.BackgroundColor3 = DeltreTheme.NeonOutline
	NeonBorder.BackgroundTransparency = 0.5
	NeonBorder.BorderSizePixel = 0
	NeonBorder.Position = UDim2.new(0.5, 0, 0.5, 0)
	NeonBorder.AnchorPoint = Vector2.new(0.5, 0.5)
	NeonBorder.Size = UDim2.new(1, 12, 1, 12)
	NeonBorder.ZIndex = 9
	NeonBorder.Parent = MainHolder

	local NeonCorner = Instance.new("UICorner")
	NeonCorner.CornerRadius = UDim.new(0, 16)
	NeonCorner.Parent = NeonBorder

	local BorderGradient = Instance.new("UIGradient")
	BorderGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.0, DeltreTheme.AccentPrimary),
		ColorSequenceKeypoint.new(0.25, DeltreTheme.AccentTertiary),
		ColorSequenceKeypoint.new(0.5, DeltreTheme.AccentSecondary),
		ColorSequenceKeypoint.new(0.75, DeltreTheme.AccentTertiary),
		ColorSequenceKeypoint.new(1.0, DeltreTheme.AccentPrimary),
	})
	BorderGradient.Rotation = 0
	BorderGradient.Parent = NeonBorder

	task.spawn(function()
		while NeonBorder and NeonBorder.Parent do
			local tween = TweenService:Create(BorderGradient, TweenInfo.new(3, Enum.EasingStyle.Linear), {
				Rotation = BorderGradient.Rotation + 180,
			})
			tween:Play()
			tween.Completed:Wait()
		end
	end)

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "Main"
	MainFrame.Size = UDim2.new(1, -12, 1, -12)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = DeltreTheme.Background
	MainFrame.BackgroundTransparency = 0.05
	MainFrame.BorderSizePixel = 0
	MainFrame.ZIndex = 10
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = NeonBorder

	local BgPattern = Instance.new("ImageLabel")
	BgPattern.Name = "BgPattern"
	BgPattern.Size = UDim2.new(1, 0, 1, 0)
	BgPattern.BackgroundTransparency = 1
	BgPattern.Image = "rbxassetid://6887083222"
	BgPattern.ImageColor3 = DeltreTheme.AccentPrimary
	BgPattern.ImageTransparency = 0.93
	BgPattern.ScaleType = Enum.ScaleType.Tile
	BgPattern.TileSize = UDim2.new(0, 40, 0, 40)
	BgPattern.ZIndex = 9
	BgPattern.Parent = MainFrame

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 12)
	MainCorner.Parent = MainFrame

	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.Size = UDim2.new(1, 0, 0, 60)
	TopBar.BackgroundColor3 = DeltreTheme.Surface
	TopBar.BackgroundTransparency = 0.15
	TopBar.BorderSizePixel = 0
	TopBar.ZIndex = 11
	TopBar.ClipsDescendants = true
	TopBar.Parent = MainFrame

	local TopGradient = Instance.new("UIGradient")
	TopGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.0, DeltreTheme.AccentPrimary),
		ColorSequenceKeypoint.new(0.5, DeltreTheme.AccentTertiary),
		ColorSequenceKeypoint.new(1.0, DeltreTheme.AccentSecondary),
	})
	TopGradient.Rotation = 90
	TopGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0.0, 0.75),
		NumberSequenceKeypoint.new(0.5, 0.9),
		NumberSequenceKeypoint.new(1.0, 0.75),
	})
	TopGradient.Parent = TopBar

	local TopCorner = Instance.new("UICorner")
	TopCorner.CornerRadius = UDim.new(0, 10)
	TopCorner.Parent = TopBar

	local TopGlow = Instance.new("Frame")
	TopGlow.Name = "TopGlow"
	TopGlow.Size = UDim2.new(1, 0, 0, 2)
	TopGlow.Position = UDim2.new(0, 0, 1, 0)
	TopGlow.BackgroundColor3 = DeltreTheme.AccentPrimary
	TopGlow.BackgroundTransparency = 0.6
	TopGlow.BorderSizePixel = 0
	TopGlow.ZIndex = 11
	TopGlow.Parent = TopBar

	local TitleIcon = Instance.new("ImageLabel")
	TitleIcon.Name = "TitleIcon"
	TitleIcon.Size = UDim2.new(0, 28, 0, 28)
	TitleIcon.Position = UDim2.new(0, 18, 0, 16)
	TitleIcon.BackgroundTransparency = 1
	TitleIcon.Image = "rbxassetid://7733765045"
	TitleIcon.ImageColor3 = DeltreTheme.AccentTertiary
	TitleIcon.ZIndex = 12
	TitleIcon.Parent = TopBar

	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Size = UDim2.new(1, -80, 1, 0)
	Title.Position = UDim2.new(0, 52, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = KeyConfig.Title
	Title.TextColor3 = DeltreTheme.TextPrimary
	Title.TextSize = 18
	Title.Font = Enum.Font.GothamBold
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.ZIndex = 12
	Title.Parent = TopBar

	local Subtitle = Instance.new("TextLabel")
	Subtitle.Name = "Subtitle"
	Subtitle.Size = UDim2.new(0.9, 0, 0, 24)
	Subtitle.Position = UDim2.new(0.05, 0, 0, 62)
	Subtitle.BackgroundTransparency = 1
	Subtitle.Text = KeyConfig.Subtitle
	Subtitle.TextColor3 = DeltreTheme.TextSecondary
	Subtitle.TextSize = 13
	Subtitle.Font = Enum.Font.Gotham
	Subtitle.TextXAlignment = Enum.TextXAlignment.Center
	Subtitle.ZIndex = 11
	Subtitle.Parent = MainFrame

	local KeyBoxFrame = Instance.new("Frame")
	KeyBoxFrame.Name = "KeyBoxFrame"
	KeyBoxFrame.Size = UDim2.new(0.9, 0, 0, 60)
	KeyBoxFrame.Position = UDim2.new(0.05, 0, 0.20, 0)
	KeyBoxFrame.BackgroundColor3 = DeltreTheme.Surface
	KeyBoxFrame.BackgroundTransparency = 0.25
	KeyBoxFrame.BorderSizePixel = 0
	KeyBoxFrame.ZIndex = 11
	KeyBoxFrame.ClipsDescendants = true
	KeyBoxFrame.Parent = MainFrame

	local KeyBoxCorner = Instance.new("UICorner")
	KeyBoxCorner.CornerRadius = UDim.new(0, 10)
	KeyBoxCorner.Parent = KeyBoxFrame

	local KeyBoxStroke = Instance.new("UIStroke")
	KeyBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	KeyBoxStroke.Color = DeltreTheme.NeonOutline
	KeyBoxStroke.Thickness = 2
	KeyBoxStroke.Transparency = 0.2
	KeyBoxStroke.Parent = KeyBoxFrame

	local KeyBoxStrokeGradient = Instance.new("UIGradient")
	KeyBoxStrokeGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.0, DeltreTheme.AccentPrimary),
		ColorSequenceKeypoint.new(0.5, DeltreTheme.AccentTertiary),
		ColorSequenceKeypoint.new(1.0, DeltreTheme.AccentSecondary),
	})
	KeyBoxStrokeGradient.Parent = KeyBoxStroke

	local KeyIcon = Instance.new("ImageLabel")
	KeyIcon.Name = "KeyIcon"
	KeyIcon.Size = UDim2.new(0, 24, 0, 24)
	KeyIcon.Position = UDim2.new(0, 15, 0.5, 0)
	KeyIcon.AnchorPoint = Vector2.new(0, 0.5)
	KeyIcon.BackgroundTransparency = 1
	KeyIcon.Image = "rbxassetid://7733764536"
	KeyIcon.ImageColor3 = DeltreTheme.AccentTertiary
	KeyIcon.ZIndex = 12
	KeyIcon.Parent = KeyBoxFrame

	local KeyBox = Instance.new("TextBox")
	KeyBox.Name = "KeyBox"
	KeyBox.Size = UDim2.new(1, -60, 1, -12)
	KeyBox.Position = UDim2.new(0, 48, 0, 6)
	KeyBox.BackgroundTransparency = 1
	KeyBox.TextColor3 = DeltreTheme.TextPrimary
	KeyBox.PlaceholderText = "Enter your key here..."
	KeyBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
	KeyBox.Text = ""
	KeyBox.TextSize = 15
	KeyBox.Font = Enum.Font.Gotham
	KeyBox.TextXAlignment = Enum.TextXAlignment.Center
	KeyBox.ClearTextOnFocus = false
	KeyBox.ZIndex = 12
	KeyBox.ClipsDescendants = true
	KeyBox.Parent = KeyBoxFrame

	KeyBox.Focused:Connect(function()
		TweenService:Create(KeyBoxFrame, TweenInfo.new(0.2), {
			BackgroundTransparency = 0.1,
		}):Play()
		TweenService:Create(KeyBoxStroke, TweenInfo.new(0.2), {
			Transparency = 0.0,
			Thickness = 2.5,
		}):Play()
	end)

	KeyBox.FocusLost:Connect(function()
		TweenService:Create(KeyBoxFrame, TweenInfo.new(0.2), {
			BackgroundTransparency = 0.25,
		}):Play()
		TweenService:Create(KeyBoxStroke, TweenInfo.new(0.2), {
			Transparency = 0.2,
			Thickness = 2,
		}):Play()
	end)

	local ButtonContainer = Instance.new("Frame")
	ButtonContainer.Name = "ButtonContainer"
	ButtonContainer.Size = UDim2.new(0.9, 0, 0, 70)
	ButtonContainer.Position = UDim2.new(0.05, 0, 0.38, 0)
	ButtonContainer.BackgroundTransparency = 1
	ButtonContainer.ZIndex = 11
	ButtonContainer.ClipsDescendants = true
	ButtonContainer.Parent = MainFrame

	local ButtonLayout = Instance.new("UIListLayout")
	ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
	ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	ButtonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	ButtonLayout.Padding = UDim.new(0, 20)
	ButtonLayout.Parent = ButtonContainer

	local function createGlint(button)
		local glint = Instance.new("Frame")
		glint.Name = "Glint"
		glint.Size = UDim2.new(0, 50, 1.8, 0)
		glint.AnchorPoint = Vector2.new(0.5, 0.5)
		glint.Position = UDim2.new(-0.3, 0, 0.5, 0)
		glint.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		glint.BackgroundTransparency = 0.82
		glint.BorderSizePixel = 0
		glint.Rotation = 20
		glint.ZIndex = button.ZIndex + 2
		glint.Parent = button

		local gc = Instance.new("UICorner")
		gc.CornerRadius = UDim.new(1, 0)
		gc.Parent = glint

		return glint
	end

	local function playGlint(glint)
		glint.Position = UDim2.new(-0.3, 0, 0.5, 0)
		local tween =
			TweenService:Create(glint, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = UDim2.new(1.3, 0, 0.5, 0),
			})
		tween:Play()
	end

	local LinkvertiseBtn = Instance.new("TextButton")
	LinkvertiseBtn.Name = "Linkvertise"
	LinkvertiseBtn.Size = UDim2.new(0.5, -10, 1, 0)
	LinkvertiseBtn.BackgroundColor3 = LinkvertiseOrange
	LinkvertiseBtn.BackgroundTransparency = 0.1
	LinkvertiseBtn.Text = ""
	LinkvertiseBtn.AutoButtonColor = false
	LinkvertiseBtn.ZIndex = 12
	LinkvertiseBtn.ClipsDescendants = true
	LinkvertiseBtn.Parent = ButtonContainer

	local LinkCorner = Instance.new("UICorner")
	LinkCorner.CornerRadius = UDim.new(0, 10)
	LinkCorner.Parent = LinkvertiseBtn

	local LinkGradient = Instance.new("UIGradient")
	LinkGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.0, LinkvertiseOrange),
		ColorSequenceKeypoint.new(1.0, LinkvertiseDark),
	})
	LinkGradient.Rotation = 45
	LinkGradient.Parent = LinkvertiseBtn

	local LinkAccent = Instance.new("Frame")
	LinkAccent.Name = "Accent"
	LinkAccent.Size = UDim2.new(1, 0, 0, 4)
	LinkAccent.Position = UDim2.new(0, 0, 1, -4)
	LinkAccent.BackgroundColor3 = Color3.fromRGB(255, 160, 100)
	LinkAccent.BorderSizePixel = 0
	LinkAccent.ZIndex = 13
	LinkAccent.Parent = LinkvertiseBtn

	local LinkIcon = Instance.new("ImageLabel")
	LinkIcon.Name = "Icon"
	LinkIcon.Size = UDim2.new(0, 20, 0, 20)
	LinkIcon.Position = UDim2.new(0, 12, 0.5, 0)
	LinkIcon.AnchorPoint = Vector2.new(0, 0.5)
	LinkIcon.BackgroundTransparency = 1
	LinkIcon.Image = "rbxassetid://7733771982"
	LinkIcon.ImageColor3 = Color3.fromRGB(255, 220, 180)
	LinkIcon.ZIndex = 13
	LinkIcon.Parent = LinkvertiseBtn

	local LinkLabel = Instance.new("TextLabel")
	LinkLabel.Name = "CenterLabel"
	LinkLabel.Size = UDim2.new(1, -44, 1, -4)
	LinkLabel.Position = UDim2.new(0, 34, 0, 0)
	LinkLabel.BackgroundTransparency = 1
	LinkLabel.Text = "Linkvertise"
	LinkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	LinkLabel.TextSize = 15
	LinkLabel.Font = Enum.Font.GothamBold
	LinkLabel.TextXAlignment = Enum.TextXAlignment.Center
	LinkLabel.TextYAlignment = Enum.TextYAlignment.Center
	LinkLabel.ZIndex = 14
	LinkLabel.Parent = LinkvertiseBtn

	local LinkStroke = Instance.new("UIStroke")
	LinkStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	LinkStroke.Color = Color3.fromRGB(255, 160, 100)
	LinkStroke.Thickness = 2
	LinkStroke.Transparency = 0.12
	LinkStroke.Parent = LinkvertiseBtn

	local LinkGlint = createGlint(LinkvertiseBtn)

	local LootLabsBtn = Instance.new("TextButton")
	LootLabsBtn.Name = "LootLabs"
	LootLabsBtn.Size = UDim2.new(0.5, -10, 1, 0)
	LootLabsBtn.BackgroundColor3 = LootLabsPurple
	LootLabsBtn.BackgroundTransparency = 0.1
	LootLabsBtn.Text = ""
	LootLabsBtn.AutoButtonColor = false
	LootLabsBtn.ZIndex = 12
	LootLabsBtn.ClipsDescendants = true
	LootLabsBtn.Parent = ButtonContainer

	local LootCorner = Instance.new("UICorner")
	LootCorner.CornerRadius = UDim.new(0, 10)
	LootCorner.Parent = LootLabsBtn

	local LootGradient = Instance.new("UIGradient")
	LootGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.0, LootLabsPurple),
		ColorSequenceKeypoint.new(1.0, LootLabsDark),
	})
	LootGradient.Rotation = 45
	LootGradient.Parent = LootLabsBtn

	local LootAccent = Instance.new("Frame")
	LootAccent.Name = "Accent"
	LootAccent.Size = UDim2.new(1, 0, 0, 4)
	LootAccent.Position = UDim2.new(0, 0, 1, -4)
	LootAccent.BackgroundColor3 = LootLabsYellow
	LootAccent.BorderSizePixel = 0
	LootAccent.ZIndex = 13
	LootAccent.Parent = LootLabsBtn

	local LootIcon = Instance.new("ImageLabel")
	LootIcon.Name = "Icon"
	LootIcon.Size = UDim2.new(0, 20, 0, 20)
	LootIcon.Position = UDim2.new(0, 12, 0.5, 0)
	LootIcon.AnchorPoint = Vector2.new(0, 0.5)
	LootIcon.BackgroundTransparency = 1
	LootIcon.Image = "rbxassetid://7733673987"
	LootIcon.ImageColor3 = LootLabsYellow
	LootIcon.ZIndex = 13
	LootIcon.Parent = LootLabsBtn

	local LootLabel = Instance.new("TextLabel")
	LootLabel.Name = "CenterLabel"
	LootLabel.Size = UDim2.new(1, -44, 1, -4)
	LootLabel.Position = UDim2.new(0, 34, 0, 0)
	LootLabel.BackgroundTransparency = 1
	LootLabel.Text = "LootLabs"
	LootLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	LootLabel.TextSize = 15
	LootLabel.Font = Enum.Font.GothamBold
	LootLabel.TextXAlignment = Enum.TextXAlignment.Center
	LootLabel.TextYAlignment = Enum.TextYAlignment.Center
	LootLabel.ZIndex = 14
	LootLabel.Parent = LootLabsBtn

	local LootStroke = Instance.new("UIStroke")
	LootStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	LootStroke.Color = LootLabsYellow
	LootStroke.Thickness = 2
	LootStroke.Transparency = 0.12
	LootStroke.Parent = LootLabsBtn

	local LootGlint = createGlint(LootLabsBtn)

	local SubmitBtn = Instance.new("TextButton")
	SubmitBtn.Name = "Submit"
	SubmitBtn.Size = UDim2.new(0.9, 0, 0, 55)
	SubmitBtn.Position = UDim2.new(0.05, 0, 0.58, 0)
	SubmitBtn.BackgroundColor3 = DeltreTheme.AccentPrimary
	SubmitBtn.BackgroundTransparency = 0.15
	SubmitBtn.TextColor3 = DeltreTheme.TextPrimary
	SubmitBtn.Text = "Submit Key"
	SubmitBtn.TextSize = 16
	SubmitBtn.Font = Enum.Font.GothamBold
	SubmitBtn.AutoButtonColor = false
	SubmitBtn.ZIndex = 12
	SubmitBtn.ClipsDescendants = true
	SubmitBtn.Parent = MainFrame

	local SubmitCorner = Instance.new("UICorner")
	SubmitCorner.CornerRadius = UDim.new(0, 10)
	SubmitCorner.Parent = SubmitBtn

	local SubmitGradient = Instance.new("UIGradient")
	SubmitGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.0, DeltreTheme.AccentPrimary),
		ColorSequenceKeypoint.new(0.5, DeltreTheme.AccentTertiary),
		ColorSequenceKeypoint.new(1.0, DeltreTheme.AccentSecondary),
	})
	SubmitGradient.Rotation = 90
	SubmitGradient.Parent = SubmitBtn

	local SubmitStroke = Instance.new("UIStroke")
	SubmitStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	SubmitStroke.Color = DeltreTheme.NeonOutline
	SubmitStroke.Thickness = 2.5
	SubmitStroke.Transparency = 0.08
	SubmitStroke.Parent = SubmitBtn

	local SubmitShine = Instance.new("Frame")
	SubmitShine.Name = "Shine"
	SubmitShine.Size = UDim2.new(0, 60, 1.8, 0)
	SubmitShine.AnchorPoint = Vector2.new(0.5, 0.5)
	SubmitShine.Position = UDim2.new(-0.25, 0, 0.5, 0)
	SubmitShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SubmitShine.BackgroundTransparency = 0.8
	SubmitShine.BorderSizePixel = 0
	SubmitShine.Rotation = 20
	SubmitShine.ZIndex = 13
	SubmitShine.Parent = SubmitBtn

	local SubmitShineCorner = Instance.new("UICorner")
	SubmitShineCorner.CornerRadius = UDim.new(1, 0)
	SubmitShineCorner.Parent = SubmitShine

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Name = "Close"
	CloseBtn.Size = UDim2.new(0, 36, 0, 36)
	CloseBtn.Position = UDim2.new(1, -42, 0, 12)
	CloseBtn.BackgroundColor3 = DeltreTheme.Surface
	CloseBtn.BackgroundTransparency = 0.4
	CloseBtn.Text = ""
	CloseBtn.AutoButtonColor = false
	CloseBtn.ZIndex = 12
	CloseBtn.Parent = MainFrame

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 8)
	CloseCorner.Parent = CloseBtn

	local CloseIcon = Instance.new("ImageLabel")
	CloseIcon.Name = "CloseIcon"
	CloseIcon.Size = UDim2.new(0, 18, 0, 18)
	CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	CloseIcon.BackgroundTransparency = 1
	CloseIcon.Image = "rbxassetid://9886659671"
	CloseIcon.ImageColor3 = Color3.fromRGB(255, 100, 100)
	CloseIcon.ZIndex = 13
	CloseIcon.Parent = CloseBtn

	local CloseStroke = Instance.new("UIStroke")
	CloseStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	CloseStroke.Color = Color3.fromRGB(255, 100, 100)
	CloseStroke.Thickness = 2
	CloseStroke.Transparency = 0.25
	CloseStroke.Parent = CloseBtn

	local StatusFrame = Instance.new("Frame")
	StatusFrame.Name = "StatusFrame"
	StatusFrame.Size = UDim2.new(0.9, 0, 0, 48)
	StatusFrame.Position = UDim2.new(0.05, 0, 0.77, 0)
	StatusFrame.BackgroundColor3 = DeltreTheme.Surface
	StatusFrame.BackgroundTransparency = 0.2
	StatusFrame.BorderSizePixel = 0
	StatusFrame.ZIndex = 11
	StatusFrame.ClipsDescendants = false
	StatusFrame.Parent = MainFrame

	local StatusCorner = Instance.new("UICorner")
	StatusCorner.CornerRadius = UDim.new(0, 10)
	StatusCorner.Parent = StatusFrame

	local StatusStroke = Instance.new("UIStroke")
	StatusStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	StatusStroke.Color = DeltreTheme.AccentSecondary
	StatusStroke.Thickness = 2
	StatusStroke.Transparency = 0.18
	StatusStroke.Parent = StatusFrame

	local StatusIcon = Instance.new("ImageLabel")
	StatusIcon.Name = "StatusIcon"
	StatusIcon.Size = UDim2.new(0, 18, 0, 18)
	StatusIcon.Position = UDim2.new(0.5, -9, 0, 6)
	StatusIcon.AnchorPoint = Vector2.new(0.5, 0)
	StatusIcon.BackgroundTransparency = 1
	StatusIcon.Image = "rbxassetid://7733658504"
	StatusIcon.ImageColor3 = DeltreTheme.AccentSecondary
	StatusIcon.ZIndex = 12
	StatusIcon.Parent = StatusFrame

	local Status = Instance.new("TextLabel")
	Status.Name = "Status"
	Status.Size = UDim2.new(1, -16, 0, 20)
	Status.Position = UDim2.new(0, 8, 0, 25)
	Status.BackgroundTransparency = 1
	Status.Text = ""
	Status.TextWrapped = true
	Status.TextScaled = false
	Status.TextColor3 = DeltreTheme.AccentSecondary
	Status.TextSize = 14
	Status.Font = Enum.Font.GothamBold
	Status.TextXAlignment = Enum.TextXAlignment.Center
	Status.TextYAlignment = Enum.TextYAlignment.Center
	Status.ZIndex = 12
	Status.Parent = StatusFrame

	local function addHoverEffect(btn, stroke, defaultTransparency, hoverTransparency, glint)
		defaultTransparency = defaultTransparency or 0.1
		hoverTransparency = hoverTransparency or 0.02

		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.2), {
				BackgroundTransparency = hoverTransparency,
			}):Play()
			if stroke then
				TweenService:Create(stroke, TweenInfo.new(0.2), {
					Transparency = 0.0,
				}):Play()
			end
			if glint then
				playGlint(glint)
			end
		end)

		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.2), {
				BackgroundTransparency = defaultTransparency,
			}):Play()
			if stroke then
				TweenService:Create(stroke, TweenInfo.new(0.2), {
					Transparency = 0.12,
				}):Play()
			end
		end)
	end

	addHoverEffect(LootLabsBtn, LootStroke, 0.1, 0.02, LootGlint)
	addHoverEffect(LinkvertiseBtn, LinkStroke, 0.1, 0.02, LinkGlint)
	addHoverEffect(SubmitBtn, SubmitStroke, 0.15, 0.02, nil)

	task.spawn(function()
		while SubmitBtn and SubmitBtn.Parent do
			TweenService:Create(SubmitShine, TweenInfo.new(1.5, Enum.EasingStyle.Quart), {
				Position = UDim2.new(1.25, 0, 0.5, 0),
			}):Play()
			task.wait(1.5)
			SubmitShine.Position = UDim2.new(-0.25, 0, 0.5, 0)
			task.wait(3)
		end
	end)

	CloseBtn.MouseEnter:Connect(function()
		TweenService:Create(CloseBtn, TweenInfo.new(0.2), {
			BackgroundTransparency = 0.15,
		}):Play()
		TweenService:Create(CloseIcon, TweenInfo.new(0.2), {
			ImageColor3 = Color3.fromRGB(255, 70, 70),
		}):Play()
		TweenService:Create(CloseStroke, TweenInfo.new(0.2), {
			Transparency = 0.0,
		}):Play()
	end)

	CloseBtn.MouseLeave:Connect(function()
		TweenService:Create(CloseBtn, TweenInfo.new(0.2), {
			BackgroundTransparency = 0.4,
		}):Play()
		TweenService:Create(CloseIcon, TweenInfo.new(0.2), {
			ImageColor3 = Color3.fromRGB(255, 100, 100),
		}):Play()
		TweenService:Create(CloseStroke, TweenInfo.new(0.2), {
			Transparency = 0.25,
		}):Play()
	end)

	MakeDraggable(TopBar, MainHolder)

	function KeyFunc:SetStatus(text, color)
		local useColor = color or DeltreTheme.AccentSecondary
		Status.Text = text or ""
		Status.TextColor3 = useColor
		StatusIcon.ImageColor3 = useColor
		StatusStroke.Color = useColor

		StatusFrame.Size = UDim2.new(0.885, 0, 0, 46)
		TweenService:Create(StatusFrame, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.9, 0, 0, 48),
		}):Play()
	end

	function KeyFunc:GetKey()
		return (KeyBox.Text or ""):gsub("%s+", "")
	end

	function KeyFunc:Close()
		TweenService:Create(MainHolder, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0),
			Rotation = -10,
		}):Play()
		TweenService:Create(NeonBorder, TweenInfo.new(0.3), {
			BackgroundTransparency = 1,
		}):Play()
		task.wait(0.4)
		if ScreenGui then
			ScreenGui:Destroy()
		end
	end

	function KeyFunc:Hide()
		TweenService:Create(MainHolder, TweenInfo.new(0.3), {
			Position = UDim2.new(0.5, 0, 1.5, 0),
		}):Play()
	end

	function KeyFunc:Show()
		MainHolder.Visible = true
		TweenService:Create(MainHolder, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, 0, 0.5, 0),
		}):Play()
	end

	LootLabsBtn.MouseButton1Click:Connect(function()
		if Mouse then
			CircleClick(LootLabsBtn, Mouse.X, Mouse.Y)
		end
		if KeyConfig.OnLootLabs then
			KeyConfig.OnLootLabs()
		end
	end)

	LinkvertiseBtn.MouseButton1Click:Connect(function()
		if Mouse then
			CircleClick(LinkvertiseBtn, Mouse.X, Mouse.Y)
		end
		if KeyConfig.OnLinkvertise then
			KeyConfig.OnLinkvertise()
		end
	end)

	SubmitBtn.MouseButton1Click:Connect(function()
		if Mouse then
			CircleClick(SubmitBtn, Mouse.X, Mouse.Y)
		end
		if KeyConfig.OnSubmit then
			KeyConfig.OnSubmit(KeyFunc:GetKey())
		end
	end)

	KeyBox.FocusLost:Connect(function(enterPressed)
		if enterPressed and KeyConfig.OnSubmit then
			KeyConfig.OnSubmit(KeyFunc:GetKey())
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		if KeyConfig.OnClose then
			KeyConfig.OnClose()
		end
		KeyFunc:Close()
	end)

	task.spawn(function()
		task.wait(0.1)
		local elements = { KeyBoxFrame, ButtonContainer, SubmitBtn, StatusFrame }
		for i, elem in ipairs(elements) do
			if elem and elem.Parent then
				local originalPos = elem.Position
				local originalBg = elem.BackgroundTransparency

				elem.Position =
					UDim2.new(originalPos.X.Scale, originalPos.X.Offset + 40, originalPos.Y.Scale, originalPos.Y.Offset)
				elem.BackgroundTransparency = 1

				TweenService:Create(
					elem,
					TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, false, i * 0.08),
					{
						Position = originalPos,
						BackgroundTransparency = originalBg,
					}
				):Play()
			end
		end
	end)

	return KeyFunc
end

return Deltrehub
