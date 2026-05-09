local Parry_Animation_API = {}
 
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Player = Players.LocalPlayer
 
local Grab_Parry = nil
 
function Parry_Animation_API.Play_Animation()
    local Character = Player.Character
    if not Character then return end
 
    local Humanoid = Character:FindFirstChildOfClass('Humanoid')
    if not Humanoid then return end
 
    local Animator = Humanoid:FindFirstChildOfClass('Animator')
    if not Animator then return end
 
    local Parry_Animation = ReplicatedStorage.Shared.SwordAPI.Collection.Default:FindFirstChild('GrabParry')
    local Current_Sword = Character:GetAttribute('CurrentlyEquippedSword')
 
    if not Current_Sword then return end
    if not Parry_Animation then return end
 
    local Sword_Data = ReplicatedStorage.Shared.ReplicatedInstances.Swords.GetSword:Invoke(Current_Sword)
    if not Sword_Data or not Sword_Data['AnimationType'] then return end
 
    for _, object in ReplicatedStorage.Shared.SwordAPI.Collection:GetChildren() do
        if object.Name == Sword_Data['AnimationType'] then
            if object:FindFirstChild('GrabParry') or object:FindFirstChild('Grab') then
                local sword_animation_type = 'GrabParry'
                if object:FindFirstChild('Grab') then
                    sword_animation_type = 'Grab'
                end
                Parry_Animation = object[sword_animation_type]
                break
            end
        end
    end
 
    local Success, Track = pcall(function()
        return Animator:LoadAnimation(Parry_Animation)
    end)
 
    if Success and Track then
        Grab_Parry = Track
        if Track.IsPlaying then
            Track:Stop(0)
        end
        Track:Play()
    end
end
 
function Parry_Animation_API.Stop_Animation()
    if Grab_Parry and Grab_Parry.IsPlaying then
        Grab_Parry:Stop(0)
    end
end
 
function Parry_Animation_API.Get_Track()
    return Grab_Parry
end
 
return Parry_Animation_API
