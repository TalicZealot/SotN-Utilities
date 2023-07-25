local AlucardHorizontalSpeed = 0x0733E0
local frame = 0
local average = 0
local totalSpeed = 0
local started = true
local startFrame = 0

local function GetSpeed()
    return (memory.read_s32_le(AlucardHorizontalSpeed) / 65536.0)
end

local function check()
    local currentSpeed = GetSpeed() 

    if not started and math.abs(currentSpeed) > 0 then
        started = true
        frame  = 1
        average = 0
        startFrame = 1
        totalSpeed = 0
    elseif started and currentSpeed == 0 then
        started = false
        return
    elseif not started then
        gui.drawText(10, 10, 'Avg spd: ', 'white', 'black')
        return
    end

    totalSpeed = totalSpeed + currentSpeed
    average = totalSpeed / (frame - startFrame + 1)

    gui.drawText(10, 10, 'Avg spd: ' .. string.format("%.2f", average), 'white', 'black')
end

while true do
    frame = frame + 1
    check()
    emu.frameadvance()
end
