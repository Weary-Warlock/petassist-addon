local last = 0

local function ShouldPetAttack()
    return UnitExists("pet")
        and UnitExists("target")
        and UnitCanAttack("player", "target")
        and not UnitIsDead("target")
end

local function TryPetAttack()
    if not ShouldPetAttack() then return end

    local now = GetTime()
    if now - last < 0.2 then return end
    last = now

    PetAttack()
end

-- Keybind attack
local oldAttackTarget = AttackTarget
function AttackTarget()
    oldAttackTarget()
    TryPetAttack()
end

-- ONLY MAIN ACTION BAR (1–12)
local oldUseAction = UseAction
function UseAction(slot, checkCursor, onSelf)
    oldUseAction(slot, checkCursor, onSelf)

    -- FILTER: only main bar
    if slot >= 1 and slot <= 12 then
        TryPetAttack()
    end
end

-- Combat start
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_REGEN_DISABLED")

f:SetScript("OnEvent", function()
    TryPetAttack()
end)

DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00PetAssist: main bar only mode loaded|r")