import "CoreLibs/graphics"

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

function playdate.update()
	updateBird()

	gfx.clear()
	gfx.fillCircleAtPoint(bird.x, bird.y, bird.r)
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

function clamp(value, min, max)
	return math.max(math.min(value, max), min)
end

