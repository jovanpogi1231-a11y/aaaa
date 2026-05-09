local Players = game:GetService('Players')
local Player = Players.LocalPlayer
 
local Auto_Parry = {}
local Grab_Parry = nil
 
function Auto_Parry.Parry_Animation()
    local Character = Player.Character
    if not Character then return end
 
    local Humanoid = Character:FindFirstChildOfClass('Humanoid')
    if not Humanoid then return end
 
    local Animator = Humanoid:FindFirstChildOfClass('Animator')
    if not Animator then return end
 
    local Parry_Animation = game:GetService('ReplicatedStorage').Shared.SwordAPI.Collection.Default:FindFirstChild('GrabParry')
    local Current_Sword = Character:GetAttribute('CurrentlyEquippedSword')
        
    if not Current_Sword then return end
        
    if not Parry_Animation then return end
 
    local Sword_Data = game:GetService('ReplicatedStorage').Shared.ReplicatedInstances.Swords.GetSword:Invoke(Current_Sword)
    if not Sword_Data or not Sword_Data['AnimationType'] then return end
 
    
    for _, object in game:GetService('ReplicatedStorage').Shared.SwordAPI.Collection:GetChildren() do
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
 
return Auto_Parry
