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

function birdHitbox(bird)
	return playdate.geometry.rect.new(bird.x - 4, bird.y - 4, 8, 8)
end
