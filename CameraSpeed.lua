local function printChat(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg)
end

SLASH_RELOAD1 = '/rl'
function SlashCmdList.RELOAD(msg, editbox) ReloadUI() end

-- Load settings when addon starts
LoadConfig=CreateFrame("frame")
LoadConfig:RegisterEvent("ADDON_LOADED")
LoadConfig:SetScript("OnEvent", function()
    if arg1 == "CameraSpeed" then
        -- printChat("loading CameraSpeed")
        CameraSpeedDB = CameraSpeedDB or {}
        CameraSpeedDB.yawSpeed = CameraSpeedDB.yawSpeed or GetCVar("cameraYawMoveSpeed")
        CameraSpeedDB.pitchSpeed = CameraSpeedDB.pitchSpeed or GetCVar("cameraPitchMoveSpeed")
    end
end)

function Apply()
    if not CameraSpeedDB then
        return
    end
    if (CameraSpeedDB.yawSpeed ~= GetCVar("cameraYawMoveSpeed")) then
        SetCVar("cameraYawMoveSpeed", CameraSpeedDB.yawSpeed)
        printChat("Camera horizontal speed set to " .. CameraSpeedDB.yawSpeed .. ". Default is 180")
    end
    if (CameraSpeedDB.pitchSpeed ~= GetCVar("cameraPitchMoveSpeed")) then
        SetCVar("cameraPitchMoveSpeed", CameraSpeedDB.pitchSpeed)
        printChat("Camera vertical speed set to " .. CameraSpeedDB.pitchSpeed .. ". Default is 90")
    end
end

SLASH_CAMSPEED1, SLASH_CAMSPEED2 = "/camspeed", "/cs"
SlashCmdList["CAMSPEED"] = function(input)
    local iStart, iEnd = strfind(input, "[^%s]+")
    local str1 = strsub(input, iStart or 0, iEnd or 0)
    iStart, iEnd = strfind(input, "[^%s]+", string.len(str1)+2)
    local str2 = strsub(input, iStart or 0, iEnd or 0)

    -- /cs <number>
    if (tonumber(str1)) then
        CameraSpeedDB.yawSpeed = tonumber(str1)

    -- /cs yaw <number>
    elseif (str1 == "yaw" and tonumber(str2)) then
        CameraSpeedDB.yawSpeed = tonumber(str2)

    -- /cs pitch <number>
    elseif (str1 == "pitch" and tonumber(str2)) then
        CameraSpeedDB.pitchSpeed = str2

    -- anything else
    else
        printChat("|cff00FF67CameraSpeed: |cff7AFFFF/cs <value> or /cs yaw <value> - Horizontal speed")
        printChat("|cff00FF67Current: |cffFFFFFF" .. CameraSpeedDB.yawSpeed .." |cff00FF67Default: |cffFF8888180")
        printChat("|cff00FF67CameraSpeed: |cff7AFFFF/cs pitch <value> - Vertical speed")
        printChat("|cff00FF67Current: |cffFFFFFF" .. CameraSpeedDB.pitchSpeed .." |cff00FF67Default: |cffFF888890")
    end
    Apply()
end

-- Apply settings when player enters the world
CameraSpeed = CreateFrame("Frame")
CameraSpeed:RegisterEvent("PLAYER_ENTERING_WORLD")
CameraSpeed:SetScript("OnEvent", function()
    Apply()
end)