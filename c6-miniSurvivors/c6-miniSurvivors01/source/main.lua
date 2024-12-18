import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

local state = {
	player = {
		x = 20,
		y = 20,
		w = 20,
		h = 20,
		s = 2,
	}
}

playdate.display.setRefreshRate(50)

function playdate.update()
	updatePlayer(state.player)

	gfx.clear()

	drawPlayer(state.player)
end

function updatePlayer(player)
	if playdate.buttonIsPressed(playdate.kButtonUp) then
			player.y -= player.s
	end
	if playdate.buttonIsPressed(playdate.kButtonDown) then
			player.y += player.s
	end
	if playdate.buttonIsPressed(playdate.kButtonLeft) then
			player.x -= player.s
	end
	if playdate.buttonIsPressed(playdate.kButtonRight) then
			player.x += player.s
	end
end

function drawPlayer(player)
	gfx.fillRect(player.x, player.y, player.w, player.h)
end
