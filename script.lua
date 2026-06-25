local teamCheck = false
local fov = 150
local smoothing = 1

local RunService = game:GetService("RunService")

local FOVring = Drawing.new("Circle")
FOVring.Visible = true
FOVring.Thickness = 1.5
FOVring.Radius = fov
FOVring.Transparency = 1
FOVring.Color = Color3.fromRGB(255, 128, 128)
FOVring.Position = workspace.CurrentCamera.ViewportSize/2

local function getClosest(cframe)
   local ray = Ray.new(cframe.Position, cframe.LookVector).Unit
   local target = nil
   local mag = math.huge
   for i,v in pairs(game.Players:GetPlayers()) do
       -- ĐÃ SỬA: Tập trung kiểm tra HumanoidRootPart (Torso) thay vì Head
       if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v ~= game.Players.LocalPlayer and (v.Team ~= game.Players.LocalPlayer.Team or (not teamCheck)) then
           -- Tính toán khoảng cách dựa trên vị trí của Torso
           local torsoPos = v.Character.HumanoidRootPart.Position
           local magBuf = (torsoPos - ray:ClosestPoint(torsoPos)).Magnitude
           if magBuf < mag then
               mag = magBuf
               target = v
           end
       end
   end
   return target
end

loop = RunService.RenderStepped:Connect(function()
   local UserInputService = game:GetService("UserInputService")
   local pressed = --[[UserInputService:IsKeyDown(Enum.KeyCode.E)]] UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) --Enum.UserInputType.MouseButton2
   local localPlay = game.Players.localPlayer.Character
   local cam = workspace.CurrentCamera
   local zz = workspace.CurrentCamera.ViewportSize/2
   if pressed then
       local Line = Drawing.new("Line")
       local curTar = getClosest(cam.CFrame)
       
       -- ĐÃ SỬA: Lấy tọa độ màn hình và ép góc nhìn Camera vào Torso (HumanoidRootPart)
       if curTar and curTar.Character and curTar.Character:FindFirstChild("HumanoidRootPart") then
           local torso = curTar.Character.HumanoidRootPart
           local ssTorsoPoint = cam:WorldToScreenPoint(torso.Position)
           ssTorsoPoint = Vector2.new(ssTorsoPoint.X, ssTorsoPoint.Y)
           
           if (ssTorsoPoint - zz).Magnitude < fov then
               workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(cam.CFrame.Position, torso.Position), smoothing)
           end
       end
   end
   if UserInputService:IsKeyDown(Enum.KeyCode.Delete) then
       loop:Disconnect()
       FOVring:Remove()
   end
end)
