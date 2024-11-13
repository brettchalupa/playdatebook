local updates = 0
local x = 40
local y = 40
local names = { "Playdate", "Goku", "Bulma", "Piccolo" }
local name = names[1]

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

    if playdate.buttonJustPressed(playdate.kButtonA) then
        name = names[math.random(#names)]
    end

    playdate.graphics.clear()
    playdate.graphics.drawText("Hello, " .. name, x, y)
    playdate.graphics.drawText("Updates: " .. updates, 40, 60)
end