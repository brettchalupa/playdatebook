local paddle = {
	x = 36,
	y = 80,
	s = 10
}

function playdate.update()
	if playdate.buttonIsPressed(playdate.kButtonUp) then
		paddle.y -= paddle.s
	end

	if playdate.buttonIsPressed(playdate.kButtonDown) then
		paddle.y += paddle.s
	end

	playdate.graphics.clear()
	playdate.graphics.fillRect(paddle.x, paddle.y, 12, 48)
end
