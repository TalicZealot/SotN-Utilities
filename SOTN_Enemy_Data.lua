------------------------------------------------------
-- Castlevania: Symphony of the Night Enemy Data Dump--
------------------------------------------------------

local done = 0

------------------------
local function enemyData()
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

    done = 1
    local entityType

    for i = 0, 180, 1 do
        base = start + (i * 0xBC)

        xrad = mainmemory.readbyte(base + 0x46) * 2
        yrad = mainmemory.readbyte(base + 0x47) * 2

        if xrad ~= 0 and yrad ~= 0 then
            if base == 0x733D8 then
                entityType = 'Alucard'
                -- Alucard/Richter hurtbox / colision box
            elseif base >= 0x73F98 and base <= 0x744BC then
                -- Alucard weapons/attacks hitbox
                entityType = 'Weapon'
            elseif base >= 0x74B58 and base <= 0x7565C then
                -- Alucard/Richter Subweapons hitbox
            else
                -- enemies and world interactable objects
                entityType = 'Enemy'
            end
            x = mainmemory.read_u16_le(base + 2) -- overflows
            y = mainmemory.read_u16_le(base + 6)
            speedHorFract = mainmemory.readbyte(base + 0x9)
            speedHorWhole = mainmemory.readbyte(base + 0xA)
            speedVertFract = mainmemory.readbyte(base + 0xD)
            speedVertWhole = mainmemory.readbyte(base + 0xE)
            xoff = mainmemory.read_u16_le(base + 0x10)
            yoff = mainmemory.read_u16_le(base + 0x12)
            facing = mainmemory.readbyte(base + 0x14)
            palette = mainmemory.readbyte(base + 0x16)
            colorMode = mainmemory.readbyte(base + 0x18) --transparency
            sprite = mainmemory.read_u16_le(base + 0x28)
            lockOn = mainmemory.read_u16_le(base + 0x2C)
            itemIndex = mainmemory.readbyte(base + 0x30)
            crit = mainmemory.readbyte(base + 0x33)
            homing = mainmemory.read_u16_le(base + 0x37)
            --38
            --39
            name = mainmemory.read_u16_le(base + 0x3A)
            --3C
            --3D
            hp = mainmemory.read_u16_le(base + 0x3E)
            dmg = mainmemory.read_u16_le(base + 0x40)
            type = mainmemory.read_u16_le(base + 0x43)
            invincibility = mainmemory.read_u16_le(base + 0x49)
            spriteSheet = mainmemory.read_u16_le(base + 0x54)
            spriteAnimationFrame = mainmemory.read_u16_le(base + 0x56)
            spriteIndex = mainmemory.read_u16_le(base + 0x5A)
            itemState1 = mainmemory.read_u16_le(base + 0x64)
            customVal = mainmemory.read_u16_le(base + 0x81) --medusa head sine wave amplitude


            console.log('------------' .. "\r" .. ' address: ' .. string.format("%x", base) .. 
            "\r" .. entityType .. 
            "\r" .. 'hp: ' .. hp .. ' address: ' .. string.format("%x", (base + 0x3E)) .. 
            "\r" .. 'xpos: ' .. x .. ' address: ' .. string.format("%x", (base + 0x2)) .. 
            "\r" .. 'ypos: ' .. y .. ' address: ' .. string.format("%x", (base + 0x6)) .. 
            "\r" .. 'speedHorFract: ' .. speedHorFract .. ' address: ' .. string.format("%x", (base + 0x9)) .. 
            "\r" .. 'speedHorWhole: ' .. speedHorWhole .. ' address: ' .. string.format("%x", (base + 0xA)) .. 
            "\r" .. 'speedVertFract: ' .. speedVertFract .. ' address: ' .. string.format("%x", (base + 0xD)) .. 
            "\r" .. 'speedVertWhole: ' .. speedVertWhole .. ' address: ' .. string.format("%x", (base + 0xE)) .. 
            "\r" .. 'dmg: ' .. dmg .. ' address: ' .. string.format("%x", (base + 0x40)) .. 
            "\r" .. 'type: ' .. type .. ' address: ' .. string.format("%x", (base + 0x43)) ..
            "\r" .. 'xrad: ' .. xrad .. ' address: ' .. string.format("%x", (base + 0x46)) .. 
            "\r" .. 'yrad: ' .. yrad .. ' address: ' .. string.format("%x", (base + 0x47)) .. 
            "\r" .. 'invincibility: ' .. invincibility .. ' address: ' .. string.format("%x", (base + 0x49)) .. 
            "\r" .. 'spriteIndex: ' .. spriteIndex .. ' address: ' .. string.format("%x", (base + 0x5A)) .. 
            "\r" .. 'spriteSheet: ' .. spriteSheet .. ' address: ' .. string.format("%x", (base + 0x54)) .. 
            "\r" .. 'sprite: ' .. sprite .. ' address: ' .. string.format("%x", (base + 0x28)) .. 
            "\r" .. 'palette: ' .. palette .. ' address: ' .. string.format("%x", (base + 0x16)))
        end
    end

    console.log('end')
end

while true do
    if done < 1 then
        enemyData()
    end
    emu.frameadvance()
end
