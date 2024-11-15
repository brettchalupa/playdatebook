local paddle = {
	x = 20,
	y = 20,
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
	playdate.graphics.drawRect(paddle.x, paddle.y, 12, 48)
end
