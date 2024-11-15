local paddle = {
	x = 20,
	y = 20,
	s = 10,
	w = 12,
	h = 48,
}

function playdate.update()
	local displayHeight = playdate.display.getHeight()

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
	playdate.graphics.drawRect(paddle.x, paddle.y, paddle.w, paddle.h)
end
