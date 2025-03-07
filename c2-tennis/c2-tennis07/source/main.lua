import "CoreLibs/graphics"

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
}

local displayHeight = playdate.display.getHeight()

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

	playdate.graphics.clear()
	playdate.graphics.fillRect(paddle.x, paddle.y, paddle.w, paddle.h)
	playdate.graphics.fillCircleAtPoint(ball.x, ball.y, ball.r)
end
