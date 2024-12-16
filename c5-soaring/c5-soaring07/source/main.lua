import "CoreLibs/graphics"
import "CoreLibs/ui"
import "util"
import "bird"
import "tree"

screenWidth = playdate.display.getWidth()
screenHeight = playdate.display.getHeight()

local gfx <const> = playdate.graphics

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
