local gfx <const> = playdate.graphics
local gridSize <const> = 20
local screenWidth <const> = playdate.display.getWidth()
local gridWidth <const> = screenWidth / gridSize - 1

local snake = {
	gridX = 2,
	gridY = 4,
}

local updates = 0

function playdate.update()
	updates += 1

	updateSnake()
	
	gfx.clear()
	gfx.fillRect(snake.gridX * gridSize, snake.gridY * gridSize, gridSize, gridSize)
end

function updateSnake()
	if updates % 4 == 0 then
		snake.gridX += 1
	end

	if snake.gridX > gridWidth then
		snake.gridX = 0
	end
end
