--
-- CameraTweaker AddOn created by OMGparticles, Copyright 2023 
-- 
-- Adjusts camera sensitivity in both the horizontal and vertical directions.
-- 
--
-- Feel free to modify, extend and redistribute this AddOn as you see fit.
--


-- Helper function for displaying local messages in the chat window
local function printChat(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg)
end

-- Reload all addons with /rl (mainly for development and debugging)
SLASH_RELOAD1 = '/rl'
function SlashCmdList.RELOAD(msg, editbox) ReloadUI() end

-- Load settings when addon starts
LoadConfig=CreateFrame("frame")
LoadConfig:RegisterEvent("ADDON_LOADED")
LoadConfig:SetScript("OnEvent", function()
    if arg1 == "CameraTweaker" then
        -- printChat("loading CameraTweaker")
        CameraTweakerDB = CameraTweakerDB or {}
        CameraTweakerDB.yawSpeed = CameraTweakerDB.yawSpeed or tonumber(GetCVar("cameraYawMoveSpeed"))
        CameraTweakerDB.pitchSpeed = CameraTweakerDB.pitchSpeed or tonumber(GetCVar("cameraPitchMoveSpeed"))
        CameraTweakerDB.zoomSpeed = CameraTweakerDB.zoomSpeed or tonumber(GetCVar("cameraDistanceMoveSpeed"))
    end
end)

-- Apply any changed speed values to the game camera.
function Apply()
    if not CameraTweakerDB then
        return
    end
    local oldYaw = tonumber(GetCVar("cameraYawMoveSpeed"))
    local newYaw = CameraTweakerDB.yawSpeed
    local oldPitch = tonumber(GetCVar("cameraPitchMoveSpeed"))
    local newPitch = CameraTweakerDB.pitchSpeed
    local oldZoom = tonumber(GetCVar("cameraDistanceMoveSpeed"))
    local newZoom = CameraTweakerDB.zoomSpeed

    if (oldYaw ~= newYaw) then
        SetCVar("cameraYawMoveSpeed", newYaw)
        printChat("Horizontal camera speed changed from " .. oldYaw .. " to " .. newYaw .. ". Default is 180")
    end
    if (oldPitch ~= newPitch) then
        SetCVar("cameraPitchMoveSpeed", newPitch)
        printChat("Vertical camera speed changed from " .. oldPitch .. " to " .. newPitch .. ". Default is 90")
    end
    if (oldZoom ~= newZoom) then
        SetCVar("cameraDistanceMoveSpeed", newZoom)
        if (newZoom <= 0.01 and tonumber(GetCVar("cameraDistanceMoveSpeed")) ~= newZoom) then
            printChat("Zoom speed limited to 0.01 by game client.")
            newZoom = 0.01
            CameraTweakerDB.zoomSpeed = newZoom
            SetCVar("cameraDistanceMoveSpeed", newZoom)
        end
        if (newZoom > 50 and tonumber(GetCVar("cameraDistanceMoveSpeed")) ~= newZoom) then
            printChat("Zoom speed limited to 50 by game client.")
            newZoom = 50
            CameraTweakerDB.zoomSpeed = newZoom
            SetCVar("cameraDistanceMoveSpeed", newZoom)
        end
        if (oldZoom ~= newZoom) then
            printChat("Camera zooming speed changed from " .. oldZoom .. " to " .. newZoom .. ". Default is 8.33")
        end
    end
end

SLASH_CAMTWEAK1, SLASH_CAMTWEAK2, SLASH_CAMTWEAK3, SLASH_CAMTWEAK4, SLASH_CAMTWEAK5 = "/cameratweaker", "/cam", "/ct", "/camtweaker", "/camtweak"
SlashCmdList["CAMTWEAK"] = function(input)
    
    -- Open the interface
    -- if (input == "" or input == nil) then
    --     ShowUIPanel(CameraTweakerOptionsPanel)
    --     return
    -- end

    local iStart, iEnd = strfind(input, "[^%s]+")
    local str1 = strsub(input, iStart or 0, iEnd or 0)
    iStart, iEnd = strfind(input, "[^%s]+", string.len(str1)+2)
    local str2 = strsub(input, iStart or 0, iEnd or 0)

    local yawStrings = {y=true, yaw=true, yawspeed=true, h=true, horizontal=true}
    local pitchStrings = {p=true, pitch=true, pitchspeed=true, v=true, vertical=true}
    local zoomStrings = {z=true, zoom=true, zoomspeed=true, d=true, distance=true, distancespeed=true}

    if (tonumber(str1)) then -- /cam <number>
        CameraTweakerDB.yawSpeed = tonumber(str1)
    elseif (yawStrings[str1] and tonumber(str2)) then -- /cam yaw <number>
        CameraTweakerDB.yawSpeed = tonumber(str2)
    elseif (pitchStrings[str1] and tonumber(str2)) then -- /cam pitch <number>
        CameraTweakerDB.pitchSpeed = tonumber(str2)
    elseif (zoomStrings[str1] and tonumber(str2)) then -- /cam zoom <number>
        CameraTweakerDB.zoomSpeed = tonumber(str2)



    -- anything else
    else
        printChat("|cff00FF67CameraTweaker: |cff7AFFFF/ct <value> or /ct h <value> - Horizontal speed")
        printChat("|cff00FF67Current: |cffFFFFFF" .. CameraTweakerDB.yawSpeed .." |cff00FF67Default: |cffFF8888180")
        printChat("|cff00FF67CameraTweaker: |cff7AFFFF/ct v <value> - Vertical speed")
        printChat("|cff00FF67Current: |cffFFFFFF" .. CameraTweakerDB.pitchSpeed .." |cff00FF67Default: |cffFF888890")
        printChat("|cff00FF67CameraTweaker: |cff7AFFFF/ct z <value> - Zoom in/out speed")
        printChat("|cff00FF67Current: |cffFFFFFF" .. CameraTweakerDB.zoomSpeed .." |cff00FF67Default: |cffFF88888.33")
    end
    Apply()
end

-- Apply settings when player enters the world
CameraTweaker = CreateFrame("Frame")
CameraTweaker:RegisterEvent("PLAYER_ENTERING_WORLD")
CameraTweaker:SetScript("OnEvent", function()
    Apply()
end)