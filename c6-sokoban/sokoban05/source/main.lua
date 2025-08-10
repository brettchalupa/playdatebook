import "CoreLibs/graphics"

local gfx <const> = playdate.graphics
local tileSize <const> = 40
local displayW <const>, displayH <const> = playdate.display.getSize()
gfx.setLineWidth(3)

local maxTileX <const> = displayW / tileSize - 1
local maxTileY <const> = displayH / tileSize - 1

local initPlayer <const> = {
    x = 4,
    y = 3,
    steps = 0,
}
local player = {}

local initBox <const> = {
    x = 5,
    y = 3,
    onTarget = false,
}
local box = {}

local target = {
    x = 7,
    y = 5,
}

function playdate.update()
    if not box.onTarget then
        updatePlayer(player)
    end

    if playdate.buttonJustPressed(playdate.kButtonA) then
        resetLevel()
    end

    gfx.clear()
    drawTarget(target)
    drawPlayer(player)
    drawBox(box)
    drawUI()
end

function resetLevel()
    player = table.deepcopy(initPlayer)
    box = table.deepcopy(initBox)
end

resetLevel() -- this is important, it copies the init* values on level start!

function updatePlayer(p)
    local dx, dy = 0, 0

    if playdate.buttonJustPressed(playdate.kButtonUp) then
        dy = -1
    elseif playdate.buttonJustPressed(playdate.kButtonDown) then
        dy = 1
    elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
        dx = -1
    elseif playdate.buttonJustPressed(playdate.kButtonRight) then
        dx = 1
    end

    if dx ~= 0 or dy ~= 0 then
        if tryMove(dx, dy) then
            p.x = p.x + dx
            p.y = p.y + dy
            p.steps += 1
        end
    end
end

function tryMove(dx, dy)
    local newX = player.x + dx
    local newY = player.y + dy

    -- Check display boundaries
    if newX < 0 or newX > maxTileX or newY < 0 or newY > maxTileY then
        return false -- Cannot move, out of bounds
    end

    -- Check for box collision
    if newX == box.x and newY == box.y then
        -- Player is trying to move into the box.
        -- Check if the box can be pushed
        local boxNewX = box.x + dx
        local boxNewY = box.y + dy

        -- Check if box would be out of bounds
        if boxNewX < 0 or boxNewX > maxTileX or boxNewY < 0 or boxNewY > maxTileY then
            return false -- Box is blocked by boundary
        else
            -- Box can be pushed, so move the box and allow player to move
            moveBoxTo(box, boxNewX, boxNewY)
            -- Player moves are handled outside this function after a successful tryMove
            return true
        end
    end

    return true
end

function moveBoxTo(b, x, y)
    b.x = x
    b.y = y

    if b.x == target.x and b.y == target.y then
        b.onTarget = true
    else
        b.onTarget = false
    end
end

function drawPlayer(p)
    gfx.drawCircleInRect(p.x * tileSize, p.y * tileSize, tileSize, tileSize)
end

function drawBox(b)
    gfx.drawRoundRect(b.x * tileSize, b.y * tileSize, tileSize, tileSize, 4)
end

function drawTarget(t)
    gfx.fillRoundRect(
        t.x * tileSize + 4,
        t.y * tileSize + 4,
        tileSize - 8,
        tileSize - 8,
        4)
end

function drawUI()
    gfx.drawText("Steps: " .. player.steps, 8, 8)

    if box.onTarget then
        gfx.drawText("Level Complete!", 40, 40)
        gfx.drawText("Press A to restart", 40, 60)
    end
end
