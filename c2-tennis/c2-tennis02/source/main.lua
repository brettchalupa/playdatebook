local paddle = {
	x = 36,
	y = 80,
}

function playdate.update()
	playdate.graphics.fillRect(paddle.x, paddle.y, 12, 48)
end
