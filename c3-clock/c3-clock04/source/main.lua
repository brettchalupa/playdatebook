local gfx <const> = playdate.graphics
local updates = 0
playdate.display.setRefreshRate(10)

function playdate.update()
	gfx.clear()
	local time = playdate.getTime()
	local hour = time.hour
	if hour > 12 then
		if not playdate.shouldDisplay24HourTime() then
			hour -= 12
		end
	end
	local minute = time.minute
	if minute < 10 then
		minute = "0" .. minute
	end
	gfx.drawText("*" .. hour .. ":" .. minute .. "*", 40, 40)

	updates += 1
	print(updates)
end
