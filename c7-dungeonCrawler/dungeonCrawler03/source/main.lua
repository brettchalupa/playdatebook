local gfx <const> = playdate.graphics

local TILE_SIZE <const> = 8
local SCALE <const> = 4
playdate.display.setScale(SCALE)
local player = { imgtableIndex = 5 }
local map = nil
local levels = {
	level1 = import("level1"),
}
local camera = { x = 0, y = 0 }
local DISPLAY_HEIGHT <const> = playdate.display.getHeight()
local DISPLAY_WIDTH <const> = playdate.display.getWidth()

function playdate.update()
	updatePlayer(player)
	updateCamera(camera, player)

	gfx.clear()

	map:draw(-camera.x, -camera.y)
	drawPlayer(player)
end

function loadLevel(levelName, imgtable)
	local level = levels[levelName]
	print("Loading level: " .. levelName)
	local map = gfx.tilemap.new()
	map:setImageTable(imgtable)
	local layer = level.layers[1]
	map:setTiles(layer.data, layer.width)
	return map
end

function init()
	gfx.setBackgroundColor(gfx.kColorBlack)

	imgtable, err = gfx.imagetable.new("tilemap")
	if err then
		print(err)
	end

	player.x = 5
	player.y = 6

	map = loadLevel("level1", imgtable)
end

function drawTile(i, x, y)
	imgtable:drawImage(i, (x * TILE_SIZE) - camera.x, (y * TILE_SIZE) - camera.y)
end

function drawPlayer(p)
	drawTile(p.imgtableIndex, p.x, p.y)
end

function updatePlayer(p)
	d = getInputDelta()
	p.x += d.x
	p.y += d.y
end

function getInputDelta()
	d = { x = 0, y = 0 }

	if playdate.buttonJustPressed(playdate.kButtonLeft) then
		d.x -= 1
	end

	if playdate.buttonJustPressed(playdate.kButtonRight) then
		d.x += 1
	end

	if playdate.buttonJustPressed(playdate.kButtonUp) then
		d.y -= 1
	end

	if playdate.buttonJustPressed(playdate.kButtonDown) then
		d.y += 1
	end

	return d
end

function updateCamera(c, p)
	c.x = p.x * TILE_SIZE - (DISPLAY_WIDTH / 2)
	c.y = p.y * TILE_SIZE - (DISPLAY_HEIGHT / 2)
end

init()
