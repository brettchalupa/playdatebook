import("CoreLibs/graphics")

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
local tileProp <const> = {
	WALKABLE = "walkable",
}
local tileProps <const> = {
	[18] = tileProp.WALKABLE, -- ground
}
local fontNontendo = gfx.font.new("fonts/Nontendo-Bold")
gfx.setFont(fontNontendo)
local synth = playdate.sound.synth.new(playdate.sound.kWaveSine)
local focusedNPC = nil
local levelName = nil
local npcs <const> = {
	level1 = {
		["22,10"] = {
			name = "Dog",
			text = "Got a treat?",
		},
		["23,4"] = {
			name = "Snake",
			text = "Dogs, all they think about is food.",
		},
		["24,7"] = {
			name = "Column",
			text = "Sure is windy out here today.",
		},
	},
}

function playdate.update()
	if focusedNPC then
		if playdate.buttonJustPressed(playdate.kButtonA) then
			playSFX("C5")
			focusedNPC = nil
		end
	else
		updatePlayer(player, map)
		updateCamera(camera, player)
	end

	gfx.clear()

	if focusedNPC then
		drawTextbox(focusedNPC)
	else
		map:draw(-camera.x, -camera.y)
		drawPlayer(player)
	end
end

function loadLevel(name, imgtable)
	levelName = name
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

function updatePlayer(p, map)
	local d = getInputDelta()

	if d.x ~= 0 or d.y ~= 0 then
		local dest = { x = p.x + d.x, y = p.y + d.y }

		local tileAtDest = map:getTileAtPosition(dest.x + 1, dest.y + 1)

		if tileProps[tileAtDest] == tileProp.WALKABLE then
			p.x += d.x
			p.y += d.y
		else
			focusedNPC = npcs[levelName][dest.x .. "," .. dest.y]

			if focusedNPC then
				playSFX("B3")
			end
		end
	end
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

function playSFX(note)
	synth:playMIDINote(note, 1, 0.15)
end

function drawTextbox(speak)
	gfx.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
	gfx.drawText(speak.name, 4, 0)
	gfx.setImageDrawMode(playdate.graphics.kDrawModeCopy)

	playdate.graphics.setColor(gfx.kColorWhite)
	gfx.fillRoundRect(0, DISPLAY_HEIGHT - 46, DISPLAY_WIDTH, 46, 4)
	playdate.graphics.setColor(gfx.kColorBlack)
	gfx.drawTextInRect(speak.text, 4, DISPLAY_HEIGHT - 42, DISPLAY_WIDTH - 8, 40)
end

init()
