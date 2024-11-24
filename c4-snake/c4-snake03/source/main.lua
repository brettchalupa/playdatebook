import "CoreLibs/graphics"

local gfx <const> = playdate.graphics
local gridSize <const> = 20
local screenWidth <const> = playdate.display.getWidth()
local screenHeight <const> = playdate.display.getHeight()
local gridWidth <const> = screenWidth / gridSize - 1
local gridHeight <const> = screenHeight / gridSize - 1

local snake = {
	gridX = 2,
	gridY = 2,
	direction = "right",
	movementDelay = 4,
}

local apple = {
	gridX = 5,
	gridY = 5,
}

local updates = 0

function playdate.update()
	updates += 1

	updateSnake()

	if snake.gridX == apple.gridX and snake.gridY == apple.gridY then
		spawnApple()
	end
	
	gfx.clear()
	gfx.fillRect(snake.gridX * gridSize, snake.gridY * gridSize, gridSize, gridSize)
	gfx.fillCircleAtPoint(
		apple.gridX * gridSize + gridSize / 2,
		apple.gridY * gridSize + gridSize / 2,
		gridSize / 2 - 2
	)
end

function spawnApple()
	apple.gridX = math.random(0, gridWidth)
	apple.gridY = math.random(0, gridHeight)
end

function updateSnake()
	if playdate.buttonIsPressed(playdate.kButtonLeft) then
		snake.direction = "left"
	end
	if playdate.buttonIsPressed(playdate.kButtonRight) then
		snake.direction = "right"
	end
	if playdate.buttonIsPressed(playdate.kButtonUp) then
		snake.direction = "up"
	end
	if playdate.buttonIsPressed(playdate.kButtonDown) then
		snake.direction = "down"
	end

	if updates % snake.movementDelay == 0 then
		moveSnake()
	end
end

function moveSnake()
	if snake.direction == "right" then
		snake.gridX += 1
	end
	if snake.direction == "left" then
		snake.gridX -= 1
	end
	if snake.direction == "up" then
		snake.gridY -= 1
	end
	if snake.direction == "down" then
		snake.gridY += 1
	end

	if snake.gridX > gridWidth then
		snake.gridX = 0
	end
	if snake.gridX < 0 then
		snake.gridX = gridWidth
	end
	if snake.gridY > gridHeight then
		snake.gridY = 0
	end
	if snake.gridY < 0 then
		snake.gridY = gridHeight
	end
end
