--options

local drainPercentage = 4;
local frameInterval = 60

-----------------------------

local gameAddresses = {
    GameStatus = 0x03C734,
    EntityHitboxWidth = 0x07341e,
    CanSave = 0x03C708,
    CanWarp = 0x03C710,
    Loading = 0x03CF7C,
    ScreenTransition = 0x03C9A4,
    MenuOpen = 0x0973EC,
    MaoOpen = 0x0974A4,
    CurrentHp = 0x097BA0,
    MaxHp = 0x097BA4,
    Invincibility = 0x072F1A,
    PotionInvincibility = 0x072F1C,
    KnockbackInvincibility = 0x13B5E8,
    FreezeInvincibility = 0x097420,
    AlucardStep = 0x073404,
    AlucardStep2 = 0x073406,
    TimeAttackPrologue = 0x03CA28,
}

local frame = 0
local remainder = 0

local function InGame()
    return memory.readbyte(gameAddresses.GameStatus) == 2
end
local function IsLoading()
    return memory.readbyte(gameAddresses.Loading) == 0x88
end
local function InScreenTransition()
    return memory.readbyte(gameAddresses.ScreenTransition) == 0x3
end
local function MenuOpen()
    return memory.readbyte(gameAddresses.MenuOpen) == 0x1
end
local function MapOpen()
    return memory.readbyte(gameAddresses.MaoOpen) > 0
end
local function HasHitbox()
    if memory.read_u16_le(gameAddresses.AlucardStep) == 7 then -- Power of Mist
        return true
    end
    return memory.readbyte(gameAddresses.EntityHitboxWidth) > 0
end
local function IsDying()
    return memory.read_u16_le(gameAddresses.AlucardStep) == 0x10
end
local function CanSave()
    local canSave = memory.readbyte(gameAddresses.CanSave)
    return ((canSave & 0x20) == 0x20)
end
local function CanWarp()
    local canWarp = memory.readbyte(gameAddresses.CanWarp)
    return ((canWarp & 0x0E) == 0x0E)
end
local function IsInvincible()
    return memory.read_u16_le(gameAddresses.Invincibility) > 0
    or memory.readbyte(gameAddresses.PotionInvincibility) > 4 
    or memory.readbyte(gameAddresses.KnockbackInvincibility) > 0
    or memory.readbyte(gameAddresses.FreezeInvincibility) > 0
end
local function PrologueCompleted()
    return memory.read_u32_le(gameAddresses.TimeAttackPrologue) > 0
end
local function DrainViable()
    return InGame() == true
    and IsDying() == false
    and IsLoading() == false
    and InScreenTransition() == false
    and MenuOpen() == false
    and MapOpen() == false
    and HasHitbox() == true
    and CanSave() == false
    -- and canWarp() == false
    --and IsInvincible() == false
end
local function getMaxHp()
    return memory.read_u32_le(gameAddresses.MaxHp)
end
local function getCurrentHp()
    return memory.read_u32_le(gameAddresses.CurrentHp)
end
local function setCurrentHp(value)
    memory.write_u32_le(gameAddresses.CurrentHp, value)
end
local function killCharacter()
    memory.write_u16_le(gameAddresses.AlucardStep2, 0)
    memory.write_u16_le(gameAddresses.AlucardStep, 0x10)
end

local function drain()
    if DrainViable() == false or frame < frameInterval then
        return
    end

    frame = 0
    local reduction = getMaxHp() * (drainPercentage / 100)
    local reductionWhole = math.floor(reduction)
    remainder = remainder + (reduction - reductionWhole)

    if remainder >= 1 then
        remainder = remainder - 1
        reductionWhole = reductionWhole + 1
    end

    if PrologueCompleted() == false then
        setCurrentHp(getCurrentHp() - 1)
        return
    end

    local currentHp = getCurrentHp()
    local newHp = currentHp - reductionWhole
    if newHp < 1 then
        setCurrentHp(0)
        killCharacter()
    else
        setCurrentHp(newHp)
    end
end

while true do
    frame = frame + 1
    drain()
    emu.frameadvance()
end
