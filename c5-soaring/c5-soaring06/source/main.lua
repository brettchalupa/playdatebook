import "CoreLibs/graphics"
import "CoreLibs/ui"

local gfx <const> = playdate.graphics
local screenWidth <const> = playdate.display.getWidth()
local screenHeight <const> = playdate.display.getHeight()
local buttonForce <const> = 0.20

function initBird()
	return {
		x = screenWidth / 2,
		y = 100,
		yVel = 0,
		r = 12,
		maxVel = 12
	}
end

function initTree()
	return {
		x = screenWidth + 40,
		y = 0,
		w = 40,
		h = 80,
		s = 4,
	}
end

local state = {
	activeScene = "mainMenu",
	bird = initBird(),
	tree = initTree(),
}

function playdate.update()
	if state.activeScene == "mainMenu" then
		updateMainMenu(state)
	elseif state.activeScene == "gameplay" then
		updateGameplay(state)
	elseif state.activeScene == "gameOver" then
		updateGameOver(state)
	end
end

function updateMainMenu(state)
	if playdate.buttonJustPressed(playdate.kButtonA) then
		state.activeScene = "gameplay"
		resetGameplay(state)
	end

	gfx.clear()
	gfx.drawText("*Soaring*", 40, 40);
	gfx.drawText("Press A to start", 40, screenHeight - 80);
end

function updateGameplay(state)
	local bird = state.bird
	local tree = state.tree

	updateBird(bird)
	updateTree(tree)

	if birdHitbox(bird):intersects(treeHitbox(tree)) then
		state.activeScene = "gameOver"
	end

	gfx.clear()
	gfx.fillCircleAtPoint(bird.x, bird.y, bird.r)

	gfx.fillRect(tree.x, tree.y, tree.w, tree.h)

	if playdate.isCrankDocked() then
		playdate.ui.crankIndicator:draw()
	end
end

function updateGameOver(state)
	if playdate.buttonJustPressed(playdate.kButtonA) then
		state.activeScene = "gameplay"
		resetGameplay(state)
	end

	gfx.clear()
	gfx.drawText("*Game Over*", 40, 40);
	gfx.drawText("Press A to try again", 40, screenHeight - 80);
end

function resetGameplay(state)
	state.bird = initBird()
	state.tree = initTree()
end

function updateBird(bird)
	bird.y += bird.yVel

	local crankChange, _ = playdate.getCrankChange()
	bird.yVel -= crankChange / 10

	if playdate.buttonIsPressed(playdate.kButtonUp) or playdate.buttonIsPressed(playdate.kButtonA) then
		bird.yVel -= buttonForce
	end
	if playdate.buttonIsPressed(playdate.kButtonDown) or playdate.buttonIsPressed(playdate.kButtonB) then
		bird.yVel += buttonForce
	end

	bird.yVel = clamp(bird.yVel, -bird.maxVel, bird.maxVel)
	bird.y = clamp(bird.y, 0, screenHeight)
end

function updateTree(tree)
	tree.x -= tree.s

	if tree.x < -tree.w then
		tree.x = screenWidth + math.random(tree.w + 10, tree.w + 40)
		tree.y = math.random(-20, screenHeight - 20)
	end
end

function birdHitbox(bird)
	return playdate.geometry.rect.new(bird.x - 4, bird.y - 4, 8, 8)
end

function treeHitbox(tree)
	return playdate.geometry.rect.new(tree.x, tree.y, tree.w, tree.h)
end

function clamp(value, min, max)
	return math.max(math.min(value, max), min)
end
