import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

local paddle = {
	x = 20,
	y = 20,
	s = 10,
	w = 12,
	h = 48,
}

local ball = {
	x = 60,
	y = 80,
	r = 10,
	s = 4,
}

function playdate.update()
	local displayHeight = playdate.display.getHeight()
	local displayWidth = playdate.display.getWidth()

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

	if circleOverlapsRect(ball, paddle) then
		ball.s *= -1
	end

	if ball.x + ball.r >= displayWidth then
		ball.x = displayWidth - ball.r
		ball.s *= -1
	end

	if ball.x <= ball.r then
		ball.x = ball.r
		ball.s *= -1
	end

	gfx.clear()
	gfx.drawRect(paddle.x, paddle.y, paddle.w, paddle.h)
	gfx.drawCircleAtPoint(ball.x, ball.y, ball.r)
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
