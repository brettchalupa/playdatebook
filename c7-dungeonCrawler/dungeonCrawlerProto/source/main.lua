import("map")
import("player")

local gfx <const> = playdate.graphics

local TILE_SIZE <const> = 8
local SCALE <const> = 4
playdate.display.setScale(SCALE)
local DISPLAY_HEIGHT <const> = playdate.display.getHeight()
local DISPLAY_WIDTH <const> = playdate.display.getWidth()
local imgtable = nil
local map = nil
local objectLayer = nil
local player = { imgtableIndex = 5 }
local camera = { x = 0, y = 0 }
local currentLevel = "level1"

local tileProp <const> = {
	WALKABLE = "walkable",
}
local tileProps <const> = {
	[18] = tileProp.WALKABLE, -- ground
	[53] = tileProp.WALKABLE, -- stairs_down
}

function playdate.update()
	gfx.clear()
	dx, dy = updatePlayer(player)

	if dx ~= 0 or dy ~= 0 then
		local tileAtDest = map:getTileAtPosition(player.x + dx, player.y + dy)
		if tileAtDest then
			print("tileAtDest: " .. tileAtDest)
		end

		local obj = objectAtPos(objectLayer, player.x + dx, player.y + dy)
		if obj and obj.name then
			local dest = obj.properties.dest
			if dest then
				previousLevel = currentLevel
				currentLevel = dest
				map, objectLayer = loadLevel(currentLevel, imgtable)

				-- set the player's position next to the stair they just came from
				if objectLayer and objectLayer.objects then
					for _i, o in ipairs(objectLayer.objects) do
						if o.properties.dest == previousLevel then
							player.x = o.x / TILE_SIZE
							player.y = o.y / TILE_SIZE + 1
						end
					end
				end

				return
			end
		end

		if tileProps[tileAtDest] == tileProp.WALKABLE then
			player.x += dx
			player.y += dy
		end
	end

	updateCamera(camera, player)

	map:draw(-camera.x, -camera.y)
	drawPlayer(player)
end

function init()
	gfx.setBackgroundColor(gfx.kColorBlack)

	imgtable, err = gfx.imagetable.new("tilemap")
	if err then
		print(err)
	end

	map, objectLayer = loadLevel(currentLevel, imgtable)

	player.x = 6
	player.y = 6
end

function drawTile(i, x, y)
	imgtable:drawImage(i, x * TILE_SIZE - camera.x, y * TILE_SIZE - camera.y)
end

function updateCamera(c, p)
	c.x = (p.x - 1) * TILE_SIZE - (DISPLAY_WIDTH / 2)
	c.y = (p.y - 1) * TILE_SIZE - (DISPLAY_HEIGHT / 2)
end

function objectAtPos(objectLayer, x, y)
	if objectLayer and objectLayer.objects then
		for _i, object in ipairs(objectLayer.objects) do
			if object.x / TILE_SIZE == x - 1 and object.y / TILE_SIZE == y - 1 then
				return object
			end
		end
	else
		return nil
	end
end

init()
