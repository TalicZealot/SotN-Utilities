------------------------------------------------------
-- Castlevania: Symphony of the Night Hitbox Display--
------------------------------------------------------
-- Original by ConHuevos
-- Ported by TalicZealot
----------------
----settings----
----------------
local playerHurtboxColor = 0x3C0000FF -- Color format: OORRGGBB(Opacity, Red, Green, Blue)
local playerHitboxColor = 0x3CFFFF00
local playerSubweaponHitboxColor = 0x3CFFFFFF
local EnemyHitboxColor = 0x3CFF0000

local hp_display = false -- Set to true to show enemy HP (incomplete)

-------------------------
----fixing draw space----
-------------------------
local drawingOffsetX = 150
local drawingOffsetY = 0

------------------------
local function hitboxDisplay()
    local start = 0x733D8
    local x
    local y
    local xrad
    local yrad
    local base
    local facing
    local hp
    local line
    local fill

    for i = 0, 180, 1 do
        base = start + (i * 0xBC)

        xrad = mainmemory.readbyte(base + 0x46) * 2
        yrad = mainmemory.readbyte(base + 0x47) * 2

        if xrad ~= 0 and yrad ~= 0 then
            x = mainmemory.read_u16_le(base + 2) -- overflows
            y = mainmemory.read_u16_le(base + 6)
            if x <= 256 and x >= 0 and y <= 240 and y >= 0 then
                hp = mainmemory.read_u16_le(base + 0x3E)
                facing = mainmemory.readbyte(base + 0x14)
                xoff = mainmemory.read_u16_le(base + 0x10)
                yoff = mainmemory.read_u16_le(base + 0x12)
                x = x * 2
                y = y * 2

                if facing == 1 then xoff = xoff * -1 end

                if base == 0x733D8 then
                    -- Alucard/Richter hurtbox / colision box
                    line = 0xFF0000FF
                    fill = playerHurtboxColor
                elseif base >= 0x73F98 and base <= 0x744BC then
                    -- Alucard weapons/attacks hitbox
                    line = 0xFFFFFF00
                    fill = playerHitboxColor
                elseif base >= 0x74B58 and base <= 0x7565C then
                    -- Alucard/Richter Subweapons hitbox
                    line = 0xFFFFFFFF
                    fill = playerSubweaponHitboxColor
                else
                    -- enemies and world interactable objects
                    line = 0xFFFF0000
                    fill = EnemyHitboxColor

                end

                if hp < 65500 then
                    gui.drawBox(
                        x + xoff - xrad + drawingOffsetX,
                        y + yoff - yrad + drawingOffsetY,
                        x + xoff + xrad + drawingOffsetX,
                        y + yoff + yrad + drawingOffsetY,
                        line,
                        fill
                    )
                end

                if hp_display == true then
                    if hp > 0 and hp ~= 32767 and hp < 65500 then gui.text(x - 2 + drawingOffsetX, y - 2 + drawingOffsetY, "HP: " .. hp) end
                end
            end
        end

    end
end

while true do
    hitboxDisplay()
    emu.frameadvance()
end
