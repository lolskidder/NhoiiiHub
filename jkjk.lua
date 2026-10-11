
-- UIStroke_5 (UIStroke)
G.UIStroke_5 = Instance.new("UIStroke")
G.UIStroke_5.Color = Color3.fromRGB(140, 80, 255)
G.UIStroke_5.Parent = G.ULTRA_TP

-- ===================== ANTI HIT LOGIC (from file 2) =====================
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local AntiHitEnabled = false
local IsTeleporting = false

local TeleportPoints = {
	Vector3.new(500.62, 241.28, -366.64),
	Vector3.new(504.45, 155.80, -366.35),
	Vector3.new(508.30, 70.28, -366.03),
	Vector3.new(513.86, 70.28, -366.25),
	Vector3.new(519.43, 70.28, -366.47),
	Vector3.new(524.32, 70.28, -366.59),
	Vector3.new(529.22, 70.28, -366.71),
	Vector3.new(538.01, 70.28, -365.55),
	Vector3.new(546.80, 70.28, -364.40)
}

-- mount (remove old copy first, avoid duplicates)
local targetParent = (gethui and gethui()) or PlayerGui
local old = targetParent:FindFirstChild("KHAY_HUB")
if old then old:Destroy() end
G.KHAY_HUB.Parent = targetParent

-- Button state (ULTRA_TP = Anti-Hit toggle)
local function refreshButton()
	if AntiHitEnabled then
		G.ULTRA_TP.Text = '<font color="rgb(160,150,190)">[+] ANTI HIT • </font><font color="rgb(0,210,255)">ON</font>'
		G.TextLabel_5.Text = "   ●  ANTI HIT ACTIVE"
	else
		G.ULTRA_TP.Text = '<font color="rgb(160,150,190)">[+] ANTI HIT • </font><font color="rgb(255,90,110)">OFF</font>'
		G.TextLabel_5.Text = "   ●  SYSTEM READY"
	end
end
refreshButton()

G.ULTRA_TP.MouseButton1Click:Connect(function()
	AntiHitEnabled = not AntiHitEnabled
	refreshButton()
end)

-- Floating logo opens/closes the panel
G.KHAY_FLOAT.MouseButton1Click:Connect(function()
	G.KHAY_PANEL.Visible = not G.KHAY_PANEL.Visible
end)

-- Loading overlay (reuses the KHAY intro frame; Frame_56 = progress bar)
local overlay = G.KHAY_CINEMATIC_INTRO
local bar = G.Frame_56

local function TeleportRoute(Character)
	if not AntiHitEnabled then return end
	if not Character or not Character.Parent then return end

	overlay.Visible = true
	overlay.BackgroundTransparency = 0
	bar.Size = UDim2.new(0, 0, 0, 2)
	G.TextLabel_2.Text = "anti hit almost loaded"

	local total = #TeleportPoints
	for Index, Position in ipairs(TeleportPoints) do
		if not AntiHitEnabled then
			overlay.Visible = false
			return
		end

		TweenService:Create(bar, TweenInfo.new(0.12), {Size = UDim2.new(0, 220 * (Index / total), 0, 2)}):Play()
		if Index == total then
			G.TextLabel_2.Text = "anti hit loaded!"
		end

		Character:PivotTo(CFrame.new(Position))
		if Index < total then
			RunService.Heartbeat:Wait()
		end
	end

	task.wait(0.25)
	local fade = TweenService:Create(overlay, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
	fade:Play()
	fade.Completed:Wait()
	overlay.Visible = false
	G.TextLabel_2.Text = "[ LunarX • ULTRA EDITION ]"
end

ProximityPromptService.PromptTriggered:Connect(function(Prompt, TriggeredPlayer)
	if TriggeredPlayer ~= LocalPlayer then return end
	if not AntiHitEnabled or IsTeleporting then return end
	local Character = LocalPlayer.Character
	if not Character then return end
	IsTeleporting = true
	TeleportRoute(Character)
	IsTeleporting = false
end)

return G.KHAY_HUB
