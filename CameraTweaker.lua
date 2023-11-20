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
        CameraTweakerDB.yawSpeed = CameraTweakerDB.yawSpeed or GetCVar("cameraYawMoveSpeed")
        CameraTweakerDB.pitchSpeed = CameraTweakerDB.pitchSpeed or GetCVar("cameraPitchMoveSpeed")
    end
end)

-- Apply any changed speed values to the game camera.
function Apply()
    if not CameraTweakerDB then
        return
    end
    if (CameraTweakerDB.yawSpeed ~= GetCVar("cameraYawMoveSpeed")) then
        SetCVar("cameraYawMoveSpeed", CameraTweakerDB.yawSpeed)
        printChat("Camera horizontal speed set to " .. CameraTweakerDB.yawSpeed .. ". Default is 180")
    end
    if (CameraTweakerDB.pitchSpeed ~= GetCVar("cameraPitchMoveSpeed")) then
        SetCVar("cameraPitchMoveSpeed", CameraTweakerDB.pitchSpeed)
        printChat("Camera vertical speed set to " .. CameraTweakerDB.pitchSpeed .. ". Default is 90")
    end
end

SLASH_CAMSPEED1, SLASH_CAMSPEED2 = "/camtweaker", "/cam"
SlashCmdList["CAMSPEED"] = function(input)
    
    -- Open the interface
    if (input == "" or input == nil) then
        ShowUIPanel(CameraTweakerOptionsPanel)
        return
    end

    local iStart, iEnd = strfind(input, "[^%s]+")
    local str1 = strsub(input, iStart or 0, iEnd or 0)
    iStart, iEnd = strfind(input, "[^%s]+", string.len(str1)+2)
    local str2 = strsub(input, iStart or 0, iEnd or 0)

    -- /cam <number>
    if (tonumber(str1)) then
        CameraTweakerDB.yawSpeed = tonumber(str1)
        CameraTweakerDB.pitchSpeed = tonumber(str1)

    -- /cam yaw <number>
    elseif (str1 == "yaw" and tonumber(str2)) then
        CameraTweakerDB.yawSpeed = tonumber(str2)

    -- /cam pitch <number>
    elseif (str1 == "pitch" and tonumber(str2)) then
        CameraTweakerDB.pitchSpeed = str2

    -- anything else
    else
        printChat("|cff00FF67CameraTweaker: |cff7AFFFF/cs <value> or /cs yaw <value> - Horizontal speed")
        printChat("|cff00FF67Current: |cffFFFFFF" .. CameraTweakerDB.yawSpeed .." |cff00FF67Default: |cffFF8888180")
        printChat("|cff00FF67CameraTweaker: |cff7AFFFF/cs pitch <value> - Vertical speed")
        printChat("|cff00FF67Current: |cffFFFFFF" .. CameraTweakerDB.pitchSpeed .." |cff00FF67Default: |cffFF888890")
    end
    Apply()
end

-- Apply settings when player enters the world
CameraTweaker = CreateFrame("Frame")
CameraTweaker:RegisterEvent("PLAYER_ENTERING_WORLD")
CameraTweaker:SetScript("OnEvent", function()
    Apply()
end)