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
	parts = {}
}

local apple = {
	gridX = 5,
	gridY = 5,
}

local updates = 0
local isGameOver = false
local newHighScore = false
local highScore = nil -- we'll set this on game over

local menu = playdate.getSystemMenu()
menu:addMenuItem("reset score", function()
	playdate.datastore.write({ highScore = 0 })
end)

function playdate.update()
	updates += 1

	if not isGameOver then
		updateSnake()
	else
		if playdate.buttonJustPressed(playdate.kButtonA) then
			resetGame()
		end
	end

	if snake.gridX == apple.gridX and snake.gridY == apple.gridY then
		table.insert(snake.parts, { gridX = snake.gridX, gridY = snake.gridY })
		spawnApple()
	end
	
	gfx.clear()
	gfx.fillRect(snake.gridX * gridSize, snake.gridY * gridSize, gridSize, gridSize)
	for _, part in pairs(snake.parts) do
		gfx.fillRect(part.gridX * gridSize, part.gridY * gridSize, gridSize, gridSize)
	end
	gfx.fillCircleAtPoint(
		apple.gridX * gridSize + gridSize / 2,
		apple.gridY * gridSize + gridSize / 2,
		gridSize / 2 - 2
	)

	if isGameOver then
		gfx.drawText("*Game Over*", 40, 40);
		gfx.drawText("Press the A button to play again", 40, 70);
		gfx.drawText("Your Score: " .. numParts() .. " | High-Score: " .. highScore, 40, 100);
		if newHighScore then
			gfx.drawText("New high-score!", 40, 130);
		end
	end
end

function resetGame()
	newHighScore = false
	highScore = nil
	isGameOver = false
	snake.parts = {}
	spawnApple()
end

function spawnApple()
	local appleOverlapsSnake = true
	while appleOverlapsSnake do
		apple.gridX = math.random(0, gridWidth)
		apple.gridY = math.random(0, gridHeight)

		local anyOverlaps = false

		if apple.gridX == snake.gridX and apple.gridY == snake.gridY then
			anyOverlaps = true
		end

		for _, part in pairs(snake.parts) do
			if apple.gridX == part.gridX and apple.gridY == part.gridY then
				anyOverlaps = true
			end
		end

		appleOverlapsSnake = anyOverlaps
	end
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
		checkForSnakeBite()
	end
end

function moveSnake()
	local prevPos = { gridX = snake.gridX, gridY = snake.gridY }

	for _, part in pairs(snake.parts) do
		local segmentPos = { gridX = part.gridX, gridY = part.gridY }
		part.gridX = prevPos.gridX
		part.gridY = prevPos.gridY
		prevPos = segmentPos
	end

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

function checkForSnakeBite()
	for _, part in pairs(snake.parts) do
		if part.gridX == snake.gridX and part.gridY == snake.gridY then
				endGame();
				return
		end
	end
end

function endGame()
	isGameOver = true
	local save = playdate.datastore.read()
	local numParts = numParts()
	if save ~= nil and save.highScore ~= nil then
		if numParts > save.highScore then
			saveNewHighScore(numParts)
		else
			highScore = save.highScore
		end
	else -- first save
		saveNewHighScore(numParts)
	end
end

function numParts()
	local partsCount, _ = table.getsize(snake.parts)
	return partsCount
end

function saveNewHighScore(score)
	newHighScore = true
	highScore = score
	playdate.datastore.write({ highScore = score})
end
