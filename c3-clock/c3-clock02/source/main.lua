local gfx <const> = playdate.graphics

function playdate.update()
	gfx.clear()
	local time = playdate.getTime()
	local hour = time.hour
	if hour > 12 then
		if not playdate.shouldDisplay24HourTime() then
			hour -= 12
		end
	end
	gfx.drawText("*" .. hour .. ":" .. time.minute .. "*", 40, 40)
end
