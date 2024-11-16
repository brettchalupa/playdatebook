local paddle = {
	x = 20,
	y = 20,
}

function playdate.update()
	playdate.graphics.drawRect(paddle.x, paddle.y, 12, 48)
end
