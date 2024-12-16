import "CoreLibs/graphics"
import "CoreLibs/ui"

local gfx <const> = playdate.graphics
local screenWidth <const> = playdate.display.getWidth()
local screenHeight <const> = playdate.display.getHeight()
local maxVel <const> = 12
local buttonForce <const> = 0.20

local bird = {
	x = screenWidth / 2,
	y = 100,
	yVel = 0,
	r = 12,
}
bird.initX = bird.x
bird.initY = bird.y

local tree = {
	x = screenWidth + 40,
	y = 0,
	w = 40,
	h = 80,
	s = 4,
}
tree.initX = tree.x
tree.initY = tree.y
tree.initS = tree.s

local activeScene = "mainMenu"

function playdate.update()
	if activeScene == "mainMenu" then
		updateMainMenu()
	elseif activeScene == "gameplay" then
		updateGameplay()
	elseif activeScene == "gameOver" then
		updateGameOver()
	end
end

function updateMainMenu()
	if playdate.buttonJustPressed(playdate.kButtonA) then
		activeScene = "gameplay"
		resetGameplay()
	end

	gfx.clear()
	gfx.drawText("*Soaring*", 40, 40);
	gfx.drawText("Press A to start", 40, screenHeight - 80);
end

function updateGameplay()
	updateBird()
	updateTree()

	if birdHitbox():intersects(treeHitbox()) then
		activeScene = "gameOver"
	end

	gfx.clear()
	gfx.fillCircleAtPoint(bird.x, bird.y, bird.r)

	gfx.fillRect(tree.x, tree.y, tree.w, tree.h)

	if playdate.isCrankDocked() then
		playdate.ui.crankIndicator:draw()
	end
end

function updateGameOver()
	if playdate.buttonJustPressed(playdate.kButtonA) then
		activeScene = "gameplay"
		resetGameplay()
	end

	gfx.clear()
	gfx.drawText("*Game Over*", 40, 40);
	gfx.drawText("Press A to try again", 40, screenHeight - 80);
end

function resetGameplay()
	bird.x = bird.initX
	bird.y = bird.initY
	bird.yVel = 0

	tree.x = tree.initX
	tree.y = tree.initY
	tree.s = tree.initS
end

function updateBird()
	bird.y += bird.yVel

	local crankChange, _ = playdate.getCrankChange()
	bird.yVel -= crankChange / 10

	if playdate.buttonIsPressed(playdate.kButtonUp) or playdate.buttonIsPressed(playdate.kButtonA) then
		bird.yVel -= buttonForce
	end
	if playdate.buttonIsPressed(playdate.kButtonDown) or playdate.buttonIsPressed(playdate.kButtonB) then
		bird.yVel += buttonForce
	end

	bird.yVel = clamp(bird.yVel, -maxVel, maxVel)
	bird.y = clamp(bird.y, 0, screenHeight)
end

function updateTree()
	tree.x -= tree.s

	if tree.x < -tree.w then
		tree.x = screenWidth + math.random(tree.w + 10, tree.w + 40)
		tree.y = math.random(-20, screenHeight - 20)
	end
end

function birdHitbox()
	return playdate.geometry.rect.new(bird.x - 4, bird.y - 4, 8, 8)
end

function treeHitbox()
	return playdate.geometry.rect.new(tree.x, tree.y, tree.w, tree.h)
end

function clamp(value, min, max)
	return math.max(math.min(value, max), min)
end
