local gfx <const> = playdate.graphics

local TILE_SIZE <const> = 8
local SCALE <const> = 4
playdate.display.setScale(SCALE)
local player = { imgtableIndex = 5 }
local map = nil

local levels = {
	level1 = import("level1"),
}

function playdate.update()
	gfx.clear()

	map:draw(-5 * TILE_SIZE, -5 * TILE_SIZE)
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
	imgtable:drawImage(i, x * TILE_SIZE - 1, y * TILE_SIZE - 1)
end

function drawPlayer(p)
	drawTile(p.imgtableIndex, p.x, p.y)
end

init()
