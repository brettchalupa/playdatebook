local gfx <const> = playdate.graphics

local levels = {
	level1 = import("level1"),
	level2 = import("level2"),
}

function findLayer(level, layer)
	for _i, l in ipairs(level.layers) do
		if l.type == layer then
			return l
		end
	end
	return nil
end

function loadLevel(levelName, imgtable)
	local level = levels[levelName]
	print("Loading level: " .. levelName)
	local map = gfx.tilemap.new()
	map:setImageTable(imgtable)
	layer = findLayer(level, "tilelayer")
	if layer then
		map:setTiles(layer.data, layer.width)
	else
		print("No tilelayer found in level")
	end
	objectLayer = findLayer(level, "objectgroup")
	return map, objectLayer
end
