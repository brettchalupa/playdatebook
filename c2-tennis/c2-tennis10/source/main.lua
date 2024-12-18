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
	x = 60,
	y = 80,
	r = 10,
	s = 6,
}

local displayHeight = playdate.display.getHeight()
local displayWidth = playdate.display.getWidth()

function playdate.update()
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

	ball.x += ball.s

	if ball.x + ball.r >= displayWidth then
		ball.x = displayWidth - ball.r
		ball.s *= -1
	end

	if ball.x <= ball.r then
		ball.x = ball.r
		ball.s *= -1
	end

	gfx.clear()
	gfx.fillRect(paddle.x, paddle.y, paddle.w, paddle.h)
	gfx.fillCircleAtPoint(ball.x, ball.y, ball.r)
end
