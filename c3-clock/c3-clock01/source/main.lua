local gfx <const> = playdate.graphics

function playdate.update()
	gfx.clear()
	local time = playdate.getTime()
	gfx.drawText("*" .. time.hour .. ":" .. time.minute .. "*", 40, 40)
end
