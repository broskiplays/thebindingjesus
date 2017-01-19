local Demigod = RegisterMod(",demigod",1)
local demigodfamiliar = Isaac.GetEntityTypeByName("LilDemigod")
local demigodvariant = Isaac.GetEntityVariantByName("LilDemigod")
local r = RNG()
local item = Isaac.GetItemIdByName("Lil Demigod")
run = false
local demiExists = false

function modDemiInit(_mod,demigod)
  run = true
  player = Isaac.GetPlayer(0)
  demigod.GridCollisionClass = GridCollisionClass.COLLISION_WALL
 end
 
local function modUpdateCheck(_mod)
  player = Isaac.GetPlayer(0)
  if player:HasCollectible(item) and not(demiExists) then
    Isaac.Spawn(demigodfamiliar, demigodvariant, 0, Vector (0,0),Vector (0,0), player)
    demiExists = true
  end
 end
 
 function modUpdateGod(_mod, demigod)
   sprite = demigod:GetSprite()
   player = Isaac.GetPlayer(0)
   enemytarget = player:GetHeadDirection()
   entities = Isaac.GetRoomEntities()
   lastdirection = player:GetHeadDirection()
   tear = Isaac.GetEntityTypeByName("Chaos Card Tear")
   tearshot = false
   
   if demiExists == true then
     demigod:FollowPosition(Vector(player.Position.X,player.Position.Y))
   end
   
  
   
  for i = 1, #entities do
    if entities[i]:IsEnemy()== true then 
      if player:HasCollectible(Isaac.GetItemIdByName("Lil Demigod")) then 
        if player.FrameCount % 40 == 0 then
          if tearshot == false then
          if lastdirection == -1 and enemytarget == -1 then
         sprite:Play("IdleDown",false)
         tearshot=false
       elseif lastdirection == 0 and enemytarget == 0 then
         sprite:Play("FloatShootLeft",false)
         Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.LOST_CONTACT, 0, Vector (demigod.Position.X,demigod.Position.Y), Vector (-10,0), player)
         tearshot=false
       elseif enemytarget == 1 then
         sprite:Play("FloatShootUp",true)
         Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.LOST_CONTACT, 0, Vector (demigod.Position.X,demigod.Position.Y), Vector (0,-10), player)
         tearshot=false
       elseif lastdirection == 2 and enemytarget == 2 then
         sprite:Play("FloatShootRight",false)
         Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.LOST_CONTACT, 0, Vector (demigod.Position.X,demigod.Position.Y), Vector (10,0), player)
         tearshot=false
       elseif lastdirection == 3 and enemytarget == 3 then
         sprite:Play("FloatShootDown",false)
         Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.LOST_CONTACT, 0, Vector (demigod.Position.X,demigod.Position.Y), Vector (0,10), player)
         tearshot=false
   end
 end
end
end
end
end
end

function Demigod:Render()
  local player = Isaac.GetPlayer(0)
  local enemytarget = player:GetHeadDirection()
  lastdirection = player:GetFireDirection()
  Isaac.RenderText((tostring(enemytarget)),30,60,255,0,0,1,255) 
  Isaac.RenderText((tostring(lastdirection)),30,80,255,0,0,1,255) 
  end
Demigod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, modUpdateCheck)
Demigod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, modDemiInit, 121)
Demigod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, modUpdateGod, 121)
Demigod:AddCallback(ModCallbacks.MC_POST_RENDER, Demigod.Render)