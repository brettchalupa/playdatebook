local paddle = {
	x = 36,
	y = 80,
	s = 10,
	w = 12,
	h = 48,
}

function playdate.update()
	if playdate.buttonIsPressed(playdate.kButtonUp) then
		paddle.y -= paddle.s

		if paddle.y <= 0 then
			paddle.y = 0
		end
	end

	if playdate.buttonIsPressed(playdate.kButtonDown) then
		paddle.y += paddle.s

		if paddle.y + paddle.h >= 240 then
			paddle.y = 240 - paddle.h
		end
	end

	playdate.graphics.clear()
	playdate.graphics.fillRect(paddle.x, paddle.y, paddle.w, paddle.h)
end
