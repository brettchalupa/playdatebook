local gfx <const> = playdate.graphics

local ticks = 1
local menuIndex = 1

function updateMainMenu()
    if playdate.buttonJustPressed(playdate.kButtonUp) then
        menuIndex -= 1

        if menuIndex <= 0 then
            menuIndex = numLevels()
        end
    end

    if playdate.buttonJustPressed(playdate.kButtonDown) then
        menuIndex += 1

        if menuIndex > numLevels() then
            menuIndex = 1
        end
    end

    if playdate.buttonJustPressed(playdate.kButtonA) then
        switchToGameplay(menuIndex)
        return
    end

    gfx.clear()
    gfx.drawText("*SOKOBAN*", 20, 6)

    gfx.drawText("_Select a level:_", 20, 32)

    for i = 1, numLevels() do
        local y = i * 32 + 42
        gfx.drawText("Level " .. i, 40, y)

        if menuIndex == i then
            local x = math.cos(ticks / 10) * 3 + 22
            gfx.fillCircleAtPoint(x, y + 8, 4)
        end
    end

    ticks += 1
end
