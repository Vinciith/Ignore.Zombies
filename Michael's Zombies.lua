local DiscordLib = loadstring(game:HttpGet "https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/discord")()
local win = DiscordLib:Window("Gopher's Zombie GUI ".."("..GameName..")")
local serv = win:Server("Main", "rbxassetid://12157991984")
local btns = serv:Channel("Buttons")

btns:Button(
    "Repair Barriers",
    function()
        DiscordLib:Notification("Notification", "Repairing Barriers (DON'T PRESS F)", "ok")
		for i,v in pairs(workspace["_Barriers"]:GetChildren()) do
			game.Players.LocalPlayer.Character.Remotes.UpdateInputHold:FireServer(true)
			game.Players.LocalPlayer.Character.Remotes.UpdateHoverObject:FireServer(v.Fixbarrier)
			wait()
		end
		game.Players.LocalPlayer.Character.Remotes.UpdateInputHold:FireServer(false)
    end
)

btns:Seperator()

btns:Button(
    "Get max level",
    function()
        DiscordLib:Notification("Notification", "Max level!", "Okay!")
    end
)

local tgls = serv:Channel("Toggles")

local color = Color3.fromRGB(255, 0, 0)
local toggledESP = false
tgls:Toggle(
    "ESP",
    false,
    function(bool)
		toggledESP = bool

        if toggledESP == false then
				for i,v in pairs(workspace.Ignore.Zombies:GetChildren()) do
					if v:FindFirstChild("Highlight") then
						v.Highlight:Destroy()
					end
				end
				for i,v in pairs(workspace["_WallBuys"]:GetChildren()) do
					if v:FindFirstChild("Highlight") then
						v.Highlight:Destroy()
					end
				end
				for i,v in pairs(workspace["_Parts"]:GetChildren()) do
					if v:FindFirstChild("Highlight") then
						v.Highlight:Destroy()
					end
				end
			end

			while toggledESP and game:GetService('RunService').Heartbeat:Wait() do
				for i,v in pairs(workspace.Ignore.Zombies:GetChildren()) do
					if not v:FindFirstChild("Highlight") then
						local Highlight = Instance.new("Highlight", v)
						Highlight.FillColor = color
					else
						v.Highlight.FillColor = color
					end
				end
				for i,v in pairs(workspace["_WallBuys"]:GetChildren()) do
					if not v:FindFirstChild("Highlight") then
						local Highlight = Instance.new("Highlight", v)
						Highlight.FillColor = color
					else
						v.Highlight.FillColor = color
					end
				end
				for i,v in pairs(workspace["_Parts"]:GetChildren()) do
					if not v:FindFirstChild("Highlight") then
						local Highlight = Instance.new("Highlight", v)
						Highlight.FillColor = color
					else
						v.Highlight.FillColor = color
					end
				end
			end
    end
)

local toggled = false
tgls:Toggle(
    "Instant-Reload",
    false,
    function(bool)
		toggled = bool
		while toggled and game:GetService('RunService').Heartbeat:Wait() do
			game:GetService("Players").LocalPlayer.Character.Remotes.Reload:FireServer()
		end
    end
)

local localPlayer = game:GetService("Players").LocalPlayer

local function booga()
   local closestPlayer = nil
 local shortestDistance = math.huge
   for i, v in pairs(workspace.Ignore.Zombies:GetChildren()) do
       if v:FindFirstChild("Humanoid") and v.Humanoid.Health ~= 0  and v:FindFirstChild("Head") then
           local magnitude = (v.Head.Position - localPlayer.Character.Head.Position).magnitude

           if magnitude < shortestDistance then
               closestPlayer = v
               shortestDistance = magnitude
           end
       end
   end

   return closestPlayer
end

local toggledKnife = false
tgls:Toggle(
    "Kill Aura",
    false,
    function(bool)
		toggledKnife = bool
		while toggledKnife and wait(.1) do
			local isZombie = false
			for i,v in pairs(workspace.Ignore.Zombies:GetChildren()) do
				if (localPlayer.Character.PrimaryPart.Position-v.PrimaryPart.Position).Magnitude <= 10 then
					isZombie = true
				end
			end

			if #workspace.Ignore.Zombies:GetChildren() > 0 and isZombie then
				local args = {
					[1] = booga().Humanoid
				}

				game:GetService("ReplicatedStorage").Framework.Remotes.KnifeHitbox:FireServer(unpack(args))
			end
		end
    end
)

local mouseDown = false
localPlayer:GetMouse().Button1Down:Connect(function()
	mouseDown = true
end)
localPlayer:GetMouse().Button1Up:Connect(function()
	mouseDown = false
end)

local toggledAuto = false
--[[tgls:Toggle(
    "All Automatic",
    false,
    function(bool)
		toggledAuto = bool
		while toggledAuto and game:GetService('RunService').Heartbeat:Wait() do
			game:GetService("ReplicatedStorage").Framework.Remotes.FireBullet:FireServer()
		end
    end
)]]

local toggled2 = false
tgls:Toggle(
    "Headshots Only",
    false,
    function(bool)
		toggled2 = not toggled2
		if toggled2 then
			local mt = getrawmetatable(game)
			local old = mt.__namecall
			setreadonly(mt,false)
			mt.__namecall = newcclosure(function(self, ...)
			local args = {...}
			if getnamecallmethod() == 'FireServer' and self.Name == 'ClientBulletHit' then
			args[1] = args[1].Parent.Head
			end
			return old(self, unpack(args))
			end)
		else
			local mt = getrawmetatable(game)
			local old = mt.__namecall
			setreadonly(mt,false)
			mt.__namecall = newcclosure(function(self, ...)
			local args = {...}
			if getnamecallmethod() == 'FireServer' and self.Name == 'ClientBulletHit' then
			args[1] = args[1]
			end
			return old(self, unpack(args))
			end)
		end
    end
)

local sldrs = serv:Channel("Sliders")

local fov = 0
local sldr =
    sldrs:Slider(
    "FOV",
    70,
    120,
    90,
    function(t)
        fov = t
    end
)

local walkspeed = 0
local sldr2 =
    sldrs:Slider(
    "Walk Speed",
    16,
    100,
    8,
    function(t)
        walkspeed = t
    end
)

spawn(function()
	while game:GetService('RunService').Heartbeat:Wait() do
		workspace.CurrentCamera.FieldOfView = fov
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = walkspeed
	end
end)

sldrs:Button(
    "Reset FOV",
    function()
        sldr:Change(90)
    end
)

local drops = serv:Channel("Dropdowns")

local drop =
    drops:Dropdown(
    "Pick me!",
    {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5"},
    function(bool)
        print(bool)
    end
)

drops:Button(
    "Clear",
    function()
        drop:Clear()
    end
)

drops:Button(
    "Add option",
    function()
        drop:Add("Option")
    end
)

local clrs = serv:Channel("Colorpickers")

clrs:Colorpicker(
    "ESP Color",
    Color3.fromRGB(255, 1, 1),
    function(t)
        color = t
    end
)


local textbs = serv:Channel("Textboxes")

textbs:Textbox(
    "Gun power",
    "Type here!",
    true,
    function(t)
        print(t)
    end
)

local lbls = serv:Channel("Labels")

lbls:Label("Teleports")

local bnds = serv:Channel("Teleports")

bnds:Bind(
    "Teleport To Box",
    Enum.KeyCode.B,
    function()
		game.Players.LocalPlayer.Character:PivotTo(workspace["_MapComponents"].MysteryBox.HumanoidRootPart.CFrame * CFrame.new(0,0,1))
    end
)

serv:Channel("by gopherboi#6263")
