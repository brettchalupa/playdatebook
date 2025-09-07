import "CoreLibs/graphics"
import "levels"
import "main_menu"

local state <const> = {
    main_menu = "main_menu",
    gameplay = "gameplay",
}
local currentState = state.main_menu
local sysMenu = playdate.getSystemMenu()

local gfx <const> = playdate.graphics
local tileSize <const> = 40
local displayW <const>, displayH <const> = playdate.display.getSize()
gfx.setLineWidth(3)

local maxTileX <const> = displayW / tileSize - 1
local maxTileY <const> = displayH / tileSize - 1

local levelComplete = false
local currentLevel = 1

local player = { steps = 0 }
local boxes = {}
local targets = {}
local walls = {}

function loadCurrentLevel()
    levelComplete = false
    loadLevel(currentLevel, player, boxes, targets, walls)
end

function switchToGameplay(levelIndex)
    sysMenu:addMenuItem("Main Menu", function()
        currentState = state.main_menu
        sysMenu:removeAllMenuItems()
    end)
    currentLevel = levelIndex
    loadCurrentLevel()
    currentState = state.gameplay
end

function playdate.update()
    if currentState == state.gameplay then
        updateGameplay()
    elseif currentState == state.main_menu then
        updateMainMenu()
    else
        print("ERROR: unknown currentState: " .. currentState)
    end
end

function updateGameplay()
    -- UPDATING
    if not levelComplete then
        updatePlayer(player)
    end

    if levelComplete then
        if playdate.buttonJustPressed(playdate.kButtonA) then
            currentLevel += 1
            if currentLevel > numLevels() then
                currentLevel = 1
            end

            loadCurrentLevel()
        end
    end

    if playdate.buttonJustPressed(playdate.kButtonB) then
        loadCurrentLevel()
    end

    -- DRAWING
    gfx.clear()

    for _, wall in pairs(walls) do
        drawWall(wall)
    end

    for _, target in pairs(targets) do
        drawTarget(target)
    end

    for _, box in pairs(boxes) do
        drawBox(box)
    end

    drawPlayer(player)
    drawUI()
end

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

    if itemAtPos(walls, newX, newY) then
        return false
    end

    local box = itemAtPos(boxes, newX, newY)
    if box then
        -- Player is trying to move into the box.
        -- Check if the box can be pushed
        local boxNewX = box.x + dx
        local boxNewY = box.y + dy

        -- Check if box would be out of bounds
        if boxNewX < 0 or boxNewX > maxTileX or boxNewY < 0 or boxNewY > maxTileY then
            return false -- Box is blocked by boundary
        elseif itemAtPos(boxes, boxNewX, boxNewY) ~= nil then
            return false -- Box is blocked by another box
        elseif itemAtPos(walls, boxNewX, boxNewY) ~= nil then
            return false -- Box is blocked by another box
        else
            -- Box can be pushed, so move the box and allow player to move
            moveBoxTo(box, boxNewX, boxNewY)
            -- Player moves are handled outside this function after a successful tryMove
            return true
        end
    end

    return true
end

function itemAtPos(coll, x, y)
    for _, item in pairs(coll) do
        if item.x == x and item.y == y then
            return item
        end
    end

    return nil
end

function moveBoxTo(b, x, y)
    b.x = x
    b.y = y

    local target = itemAtPos(targets, x, y)

    if target and b.x == target.x and b.y == target.y then
        b.onTarget = true
    else
        b.onTarget = false
    end

    if allBoxesOnTarget() then
        levelComplete = true
    end
end

function allBoxesOnTarget()
    local allOnTarget = true

    for _, box in pairs(boxes) do
        if not box.onTarget then
            allOnTarget = false
        end
    end

    return allOnTarget
end

function drawPlayer(p)
    gfx.drawCircleInRect(p.x * tileSize + 2, p.y * tileSize + 2, tileSize - 4, tileSize - 4)
end

function drawBox(b)
    gfx.drawRoundRect(b.x * tileSize + 2, b.y * tileSize + 2, tileSize - 4, tileSize - 4, 4)
end

function drawTarget(t)
    gfx.fillRoundRect(
        t.x * tileSize + 6,
        t.y * tileSize + 6,
        tileSize - 12,
        tileSize - 12,
        4)
end

function drawWall(w)
    gfx.fillRect(
        w.x * tileSize,
        w.y * tileSize,
        tileSize,
        tileSize)
end

function drawUI()
    gfx.drawText("Level " .. currentLevel, 8, 2)
    gfx.drawText("Steps: " .. player.steps, 8, 18)

    if levelComplete then
        gfx.drawText("Level Complete!", 84, 2)
        gfx.drawText("Press A for next level", 220, 2)
        gfx.drawText("Press B to restart", 220, 18)
    end
end
