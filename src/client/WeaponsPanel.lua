--services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--constant directories
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

--client modules
local PlayerPanel = require(PlayerScripts.TacticalLiquidClient.PlayerPanel)
local FilesPanel = require(PlayerScripts.TacticalLiquidClient.FilesPanel)

--shared modules
local FastCast = require(ReplicatedStorage.Libraries.FastCastRedux)
local ParticleFramework = require(ReplicatedStorage.Libraries.ParticleFramework)
local Tracers = require(ReplicatedStorage.Libraries.Tracers)

--variable directories
local Character, CharacterChanged = PlayerPanel.GetCharacter()
CharacterChanged:Connect(function(NewCharacter)
    Character = NewCharacter
end)
local Camera = PlayerPanel.GetCamera()
local _Tracers = FilesPanel.CreateNewDirectory(Camera, "Tracers")

--functions
local function Pierce(cast, result, segmentVelocity)
    if result.Instance.Transparency == 1 or result.Instance.Parent == Camera or result.Instance.Parent == Character  or result.Instance.Parent:IsA("Accessory") or result.Instance.Parent.Name == "PlayerClip" then
        return true
    else
        return false
    end
end

local Behaviour = FastCast.newBehavior()

Behaviour.RaycastParams = nil
Behaviour.Acceleration = Vector3.new()
Behaviour.MaxDistance = 1000
Behaviour.CanPierceFunction = Pierce
Behaviour.HighFidelityBehavior = FastCast.HighFidelityBehavior.Default
Behaviour.HighFidelitySegmentSize = 0.5
Behaviour.CosmeticBulletTemplate = nil
Behaviour.CosmeticBulletProvider = nil
Behaviour.CosmeticBulletContainer = nil
Behaviour.AutoIgnoreContainer = true

local Caster = FastCast.new()

local Panel = {}

Panel.Fire = function()
    local AC = Caster:Fire(Camera.CFrame.Position, Camera.CFrame.LookVector, 1000, Behaviour)
    Tracers.new(
        {
            position = Camera.CFrame.Position,
            velocity = Camera.CFrame.LookVector * 1000,
            visible = true,
            cancollide = true,
            size = 0.2,
            brightness = 20 * math.random(),
            color = Color3.new(1, 1, 0.8),
            bloom = 0.005 * math.random(),
            --life = 1000 / Velocity --0.1
            life = 5
        }
    )
    task.wait(0.1)
end



-- Caster.LengthChanged:Connect(function(CasterThatFired, LastPoint, RayDirection, Displacement, SegmentVelocity, CosmeticBulletObject)
--     local CurrentPoint = LastPoint + (RayDirection * Displacement)
--     local CurrentPointMinusOne = CurrentPoint - (RayDirection.Unit * 25)

--     CosmeticBulletObject.Attachment0.WorldPosition = CurrentPoint
--     for _, v in pairs(CosmeticBulletObject:GetChildren()) do
--         if v:IsA("Beam") then
--             v.Width0 = ((Camera.CFrame.Position - CurrentPoint).Magnitude / 10) * 0.1
--         end
--     end
--     CosmeticBulletObject.Attachment1.WorldPosition = CurrentPointMinusOne
--     for _, v in pairs(CosmeticBulletObject:GetChildren()) do
--         if v:IsA("Beam") then
--             v.Width1 = ((Camera.CFrame.Position - CurrentPointMinusOne).Magnitude / 10) * 0.1
--         end
--     end
-- end)

-- Caster.RayPierced:Connect(function(CasterThatFired, RaycastResult, SegmentVelocity, CosmeticBulletObject)
    
-- end)

-- Caster.RayHit:Connect(function(CasterThatFired, RaycastResult, SegmentVelocity, CosmeticBulletObject)
--     CosmeticBulletObject:Destroy()
-- end)

-- Caster.CastTerminating:Connect(function(CasterThatFired)
    
-- end)

return Panel