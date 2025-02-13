import "CoreLibs/graphics"
import "CoreLibs/math"
import "CoreLibs/timer"
import "util"

screenWidth = playdate.display.getWidth()
screenHeight = playdate.display.getHeight()

local gfx <const> = playdate.graphics

local state = {
	player = {
		x = 20,
		y = 20,
		w = 20,
		h = 20,
		s = 2,
	},
	enemies = {}
}

playdate.display.setRefreshRate(50)

function spawnEnemy()
	if table.getsize(state.enemies) < 20 then
		randomX = math.random(-20, screenWidth + 20)
		-- TODO: make this better
		randomY = math.random(-20, screenHeight + 20)

		table.insert(state.enemies, {
				x = randomX, y = randomY, size = 12
			})
	end

	startSpawnTimer()
end

function startSpawnTimer()
	playdate.timer.performAfterDelay(math.random(500, 1500), spawnEnemy)
end

startSpawnTimer()

function playdate.update()
	playdate.timer.updateTimers()

	updateEnemies(state.enemies, state.player)
	updatePlayer(state.player)

	gfx.clear()

	drawEnemies(state.enemies)
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

	player.x = clamp(player.x, 0, screenWidth - player.w)
	player.y = clamp(player.y, 0, screenHeight - player.h)
end

function updateEnemies(enemies, player)
	for _, enemy in pairs(enemies) do
		enemy.x = playdate.math.lerp(enemy.x, player.x, 0.01)
		enemy.y = playdate.math.lerp(enemy.y, player.y, 0.01)
	end
end

function drawEnemies(enemies)
	for _, enemy in pairs(enemies) do
		gfx.fillCircleInRect(enemy.x, enemy.y, enemy.size, enemy.size)
	end
end

function drawPlayer(player)
	gfx.fillRect(player.x, player.y, player.w, player.h)
end
