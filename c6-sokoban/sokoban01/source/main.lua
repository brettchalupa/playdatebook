import "CoreLibs/graphics"

local gfx <const> = playdate.graphics
local tileSize <const> = 40
local displayW <const>, displayH <const> = playdate.display.getSize()
gfx.setLineWidth(3)

local player = {
    x = 4,
    y = 3,
}

function playdate.update()
    if playdate.buttonJustPressed(playdate.kButtonUp) and player.y > 0 then
        player.y -= 1
    end

    if playdate.buttonJustPressed(playdate.kButtonDown) and player.y < displayH / tileSize - 1 then
        player.y += 1
    end

    if playdate.buttonJustPressed(playdate.kButtonLeft) and player.x > 0 then
        player.x -= 1
    end

    if playdate.buttonJustPressed(playdate.kButtonRight) and player.x < displayW / tileSize - 1 then
        player.x += 1
    end

    gfx.clear()
    drawPlayer(player)
end

function drawPlayer(p)
    gfx.drawCircleInRect(p.x * tileSize, p.y * tileSize, tileSize, tileSize)
end
