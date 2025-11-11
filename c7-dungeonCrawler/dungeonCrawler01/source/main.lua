local gfx <const> = playdate.graphics

local TILE_SIZE <const> = 8
local SCALE <const> = 4
playdate.display.setScale(SCALE)
local player = { imgtableIndex = 5 }

function playdate.update()
	gfx.clear()

	drawTile(32, 2, 2)
	drawPlayer(player)
end

function init()
	gfx.setBackgroundColor(gfx.kColorBlack)

	imgtable, err = gfx.imagetable.new("tilemap")
	if err then
		print(err)
	end

	player.x = 5
	player.y = 6
end

function drawTile(i, x, y)
	imgtable:drawImage(i, x * TILE_SIZE - 1, y * TILE_SIZE - 1)
end

function drawPlayer(p)
	drawTile(p.imgtableIndex, p.x, p.y)
end

init()
