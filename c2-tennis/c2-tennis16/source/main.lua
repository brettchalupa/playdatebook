import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

local paddle = {
	x = 36,
	y = 80,
	s = 10,
	w = 12,
	h = 48,
}

local ball = {
	x = 220,
	y = 80,
	r = 10,
	s = 6,
	max_s = 12,
	a = 195, -- degrees
}

ball.initX = ball.x
ball.initY = ball.y
ball.initS = ball.s
ball.initA = ball.a

local score = 0

local displayHeight = playdate.display.getHeight()
local displayWidth = playdate.display.getWidth()

function playdate.update()
	movePaddle()
	moveBall()

	if circleOverlapsRect(ball, paddle) then
		ball.a = math.random(160, 200) - ball.a

		score += 1

		if ball.s < ball.max_s then
			ball.s += 1
		end
	end

	draw()
end

function draw()
	gfx.clear()
	gfx.fillRect(paddle.x, paddle.y, paddle.w, paddle.h)
	gfx.fillCircleAtPoint(ball.x, ball.y, ball.r)
	gfx.drawText("Score: " .. score, displayWidth - 100, 20)
end

function movePaddle()
	if playdate.buttonIsPressed(playdate.kButtonUp) then
		paddle.y -= paddle.s
	end

	if playdate.buttonIsPressed(playdate.kButtonDown) then
		paddle.y += paddle.s
	end

	local _crankChange, acceleratedCrankChange = playdate.getCrankChange()
	paddle.y += acceleratedCrankChange

	if paddle.y <= 0 then
		paddle.y = 0
	end

	if paddle.y + paddle.h >= displayHeight then
		paddle.y = displayHeight - paddle.h
	end
end

function moveBall()
	local radians = math.rad(ball.a)
	ball.x += math.cos(radians) * ball.s
	ball.y += math.sin(radians) * ball.s

	if ball.x + ball.r >= displayWidth then
		ball.x = displayWidth - ball.r
		ball.a = 180 - ball.a
	end

	if ball.x <= ball.r then
		resetGame()
	end

	if ball.y + ball.r >= displayHeight then
		ball.y = displayHeight - ball.r
		ball.a *= -1
	end

	if ball.y <= ball.r then
		ball.y = ball.r
		ball.a *= -1
	end
end

function resetGame()
	score = 0
	ball.x = ball.initX
	ball.y = ball.initY
	ball.s = ball.initS
	ball.a = ball.initA
end

function circleOverlapsRect(circle, rect)
	-- Find the point to the circle center within the rectangle
	local closestX = math.max(rect.x, math.min(circle.x, rect.x + rect.w))
	local closestY = math.max(rect.y, math.min(circle.y, rect.y + rect.h))

	-- Distance between the circle center and the closest point
	local distance = math.sqrt((closestX - circle.x)^2 + (closestY - circle.y)^2)

	-- If the distance is less than or equal to the radius, there's overlap
	return distance <= circle.r
end
