------------------------------------------------------
-- Castlevania: Symphony of the Night Strings Dump--
------------------------------------------------------

local done = 0

------------------------
local function strings()
    local address = 0x0E05D8
    local endAdd = 0x0E0D36
    local output = ""
    local newString = true
    local digit = false
    local stringTmp = ""
    local stringAddress = 0

    while address < endAdd do
        local currentValue = mainmemory.readbyte(address)
        if currentValue == 255 then
            newString = true
            output = output .. "\r" .. "{\"" .. stringTmp .. "\", 0x" .. string.format("%x", stringAddress) .. "},"
            stringTmp = ""
        end
        if currentValue > 0 and currentValue < 255  then
            if newString == true then
                newString = false
                stringAddress = address
            end
            if currentValue == 130 then
                digit = true
            else
                if digit then
                    stringTmp = stringTmp .. (currentValue - 79)
                else
                    stringTmp = stringTmp .. string.char(currentValue + 32)
                end
                digit = false
            end
        end
        address = address + 1
    end
    console.log(output)
    done = 1;
end

while true do
    if done < 1 then
        strings()
    end
    emu.frameadvance()
end