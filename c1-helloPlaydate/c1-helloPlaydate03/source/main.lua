local updates = 0
local x = 40
local y = 40

function playdate.update()
    updates += 1

    if playdate.buttonIsPressed(playdate.kButtonUp) then
        y -= 2
    end
    if playdate.buttonIsPressed(playdate.kButtonDown) then
        y += 2
    end
    if playdate.buttonIsPressed(playdate.kButtonLeft) then
        x -= 2
    end
    if playdate.buttonIsPressed(playdate.kButtonRight) then
        x += 2
    end

    playdate.graphics.clear()
    playdate.graphics.drawText("Hello, Playdate", x, y)
    playdate.graphics.drawText("Updates: " .. updates, 40, 60)
end
