local PartChangeKey = "z" -- Type a letter in the quotes
                          -- to change the key that'll switch which part the aimbot targets



------------------------------------

local LocalP = game.Players.LocalPlayer
local mouse = LocalP:GetMouse()
local rightclickdown = false
local shootuzi = false
local targetpart = "Head"
PartChangeKey = string.lower(PartChangeKey)

local function GetNearestPlayerToMouse()
    local players = {}
    local PLAYER_HOLD  = {}
    local DISTANCES = {}
    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= LocalP then
            table.insert(players, v)
        end
    end
    for i, v in pairs(players) do
        if v.Character ~= nil then
            local AIM = v.Character:FindFirstChild("Head")
            if AIM ~= nil then
                local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
                local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
                local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
                local DIFF = math.floor((POS - AIM.Position).magnitude)
                PLAYER_HOLD[v.Name .. i] = {}
                PLAYER_HOLD[v.Name .. i].dist= DISTANCE
                PLAYER_HOLD[v.Name .. i].plr = v
                PLAYER_HOLD[v.Name .. i].diff = DIFF
                table.insert(DISTANCES, DIFF)
            end
        end
    end
    
    if unpack(DISTANCES) == nil then
        return nil
    end
    
    local L_DISTANCE = math.floor(math.min(unpack(DISTANCES)))
    if L_DISTANCE > 20 then
        return nil
    end
    
    for i, v in pairs(PLAYER_HOLD) do
        if v.diff == L_DISTANCE then
            return v.plr
        end
    end
    return nil
end

mouse.Button2Down:Connect(function()
    rightclickdown = true
    local donemouse = false
    if mouse.Target ~= nil then
        if mouse.Target:FindFirstAncestor("Door") then
            local door = mouse.Target:FindFirstAncestor("Door")
            if door:FindFirstChild("Lock") and LocalP:DistanceFromCharacter(mouse.Target.CFrame.p) < 10 then
                if door:FindFirstChild("Lock"):FindFirstChild("ClickDetector") then
                    if door:FindFirstChild("Lock"):FindFirstChild("ClickDetector"):FindFirstChild("RemoteEvent") then
                        door:FindFirstChild("Lock"):FindFirstChild("ClickDetector"):FindFirstChild("RemoteEvent"):FireServer()
                        donemouse = true
                    end
                end
            end
        end
    end     
    if LocalP.Character ~= nil and (game.Workspace.CurrentCamera.Focus.p - game.Workspace.CurrentCamera.CoordinateFrame.p).Magnitude <= 1 and donemouse == false and not LocalP.Character:FindFirstChild("Super Uzi") then
        if LocalP.Character:FindFirstChildWhichIsA("Tool") then
            local Tool = LocalP.Character:FindFirstChildWhichIsA("Tool")
            if Tool:FindFirstChild("Fire") then
                if Tool.Name ~= "Uzi" then
                    local opp = GetNearestPlayerToMouse()
                    if opp ~= nil then
                        if opp.Character ~= nil then
                            if opp.Character:FindFirstChild("HumanoidRootPart") then
                                Tool:FindFirstChild("Fire"):FireServer(opp.Character[targetpart].CFrame + opp.Character.HumanoidRootPart.Velocity/5)
                            else
                                Tool:FindFirstChild("Fire"):FireServer(opp.Character[targetpart].CFrame + opp.Character.Torso.Velocity/5)
                            end
                        end
                    end
                elseif Tool.Name == "Uzi" then
                    shootuzi = true
                    if not Tool:FindFirstChild("UziUnequip") then
                        local Monitor = Instance.new("BoolValue", Tool)
                        Monitor.Name = "UziUnequip"
                        Tool.Unequipped:Connect(function()
                            shootuzi = false
                        end)
                    end
                end
            end
        end
    end
end)

mouse.KeyDown:Connect(function(key)
    if key == PartChangeKey then
        if targetpart == "Head" then
            targetpart = "Torso"
        elseif targetpart == "Torso" then
            targetpart = "Head"
        end
        game.StarterGui:SetCore("SendNotification", {
            Title = "notification";
            Text = "Aimbot is now targeting "..string.upper(targetpart).."s!";
            Icon = "rbxassetid://2541869220";
            Duration = 3;
        })
    end
end)


mouse.Button2Up:Connect(function()
    rightclickdown = false
    shootuzi = false
end)


game:GetService('RunService').Stepped:connect(function()
    if shootuzi == true and LocalP.Character:FindFirstChildWhichIsA("Tool") ~= nil then
        local tool = LocalP.Character:FindFirstChildWhichIsA("Tool")
        local opp = GetNearestPlayerToMouse()
        if opp ~= nil and opp.Character ~= nil and tool.Name == "Uzi" and tool:FindFirstChild("Fire") then
            if opp.Character:FindFirstChild("HumanoidRootPart") then
                tool.Fire:FireServer(opp.Character:FindFirstChild(targetpart).CFrame + opp.Character.HumanoidRootPart.Velocity/5)
            else
                tool.Fire:FireServer(opp.Character:FindFirstChild(targetpart).CFrame + opp.Character.Torso.Velocity/5) -- for people using the teleport bypass
            end
            wait()
        end
    end
end)


print("")
print(string.upper(PartChangeKey).." Key - Change the aimbot's target between heads and torsos")
print("")
print("RIGHT CLICK")
print("- Right click on doors to toggle their locks")
print("- Right click with a gun out in first person to target fire at the player closest to your mouse")
print("")

--[[
                                                        ..                                          
                                     /yys.            `hMM/                                        
                    :ys:            `NMMMo            oMMM:                                        
                  `sMMMm             -oo:            `NMMy                                          
                 .hMMMMM+                            +MMN`        `.-::.              `            
                -mMMyoMMN.         /hho       .:syhhomMMs       -smNMMMNy  `shysssssyhdho          
               :mMMs``dMMd`        NMMm     .smMNdhdMMMM.     `sNMNs:/MMM. `ydmmmmddMMMN+          
              +NMMs   -MMMs       :MMM/    +NMNs-  .MMMy     .dMMd- -yMMy    `````/hMMy-            
            `yMMMmosyhdMMMM+      yMMm    yMMN:   `yMMM/     dMMN+odNMd/        :hMNy:              
           -dMMMMMMmmdhyhMMM+     NMMo   /MMM-   :dMMMM-    :MMMMNmho-``:/    :hNMh-                
          +NMMm//-..``  `hMMMo`  -MMM/   yMMm``:hNMyMMM+.-- :MMMy.` `-omMd` /dMMmo/+oooo/`          
         oMMMh.          `yMMMm/ :MMMs   +MMMmmMNh: hMMNNNy  yMMMmhdmNMm+`:dMMMMNNNNmNMMMo          
         :yh+`            `/dNNs `ydh:    :shys/.   `+yso-`   :shddhy+-` oNMNho:-..```.-/`  
 
Join my discord here!:
https://discord.gg/Ez2dGeQ
 
This script includes all of the features attached to right click from mega combat
- Right click on doors to toggle their lock
- Right click while in first person with a gun out to fire with prediction at the player closest to your mouse

Change the key that changes the aimbot's target between heads and torsos at the top of the script

--]]

local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local Render = RS.RenderStepped

while Render:Wait() do
    if UIS:IsKeyDown(Enum.KeyCode.RightShift) then
        mouse2click()
        wait(0.0022)
    end
end
