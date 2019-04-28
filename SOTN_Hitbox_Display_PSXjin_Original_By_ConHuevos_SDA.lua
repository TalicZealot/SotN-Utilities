local hp_display = false
local transparent = true
 
local function objects()
        local start = 0x733D8
        local x
        local y
        local xrad
        local yrad
        local base
        local facing
        local hp
        local outl
        local fill
       
        for i = 0,180,1 do
                base = start + (i * 0xBC)
               
                xrad = memory.readbyte(base + 0x46)
                yrad = memory.readbyte(base + 0x47)
               
                if xrad ~= 0 and yrad ~= 0 then        
                        x = memory.readword(base + 2)
                        y = memory.readword(base + 6)
                        if x <= 256 and x >= 0 and y <=240 and y >= 0 then
                                hp = memory.readword(base + 0x3E)
                                facing = memory.readbyte(base +0x14)
                                xrad = memory.readbyte(base + 0x46)
                                yrad = memory.readbyte(base + 0x47)
                                xoff = memory.readwordsigned(base + 0x10)
                                yoff = memory.readwordsigned(base + 0x12)
                               
                                if facing == 1 then
                                        xoff = xoff * -1
                                end
                               
                                if base == 0x733D8 then -- Alucard/Richter
                                        outl = "#0000FFFF"
                                        if transparent == true then
                                                fill = "#0000FF00"
                                        else
                                                fill = "#0000FF35"
                                        end
                                elseif base >= 0x73F98 and base <= 0x744BC then -- Alucard weapons/attacks
                                        outl = "#FFFFFFFF"
                                        if transparent == true then
                                                fill = "#FFFFFF00"
                                        else
                                                fill = "#FFFFFF35"
                                        end
                                elseif base >= 0x74B58 and base <= 0x7565C then -- Alucard/Richter Subweapons
                                        outl = "#FFFF00FF"
                                        if transparent == true then
                                                fill = "#FFFF0000"
                                        else
                                                fill = "#FFFF0035"
                                        end
                                else
                                        outl = "#FF0000FF"
                                        if transparent == true then
                                                fill = "#FF000000"
                                        else
                                                fill = "#FF000035"
                                        end
                                       
                                end
                               
                                if hp < 65500 then
                                        gui.box(x+xoff-xrad,y+yoff-yrad,x+xoff+xrad,y+yoff+yrad,fill,oult)
                                end
                               
                                if hp_display == true then
                                        if hp > 0 and hp ~= 32767 and hp < 65500 then
                                                gui.text(x-5,y-5,"HP: " .. hp)
                                        end
                                end
                               
                                -- gui.text(x+xoff,y+yoff,string.format("%X",base))  --debug
                               
                                -- gui.text(20,5 + (i * 8),string.format("%X",base)) -- debug
                        end
                end
               
        end
end
 
gui.register(function()
        objects()
end)