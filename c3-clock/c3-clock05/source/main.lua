local gfx <const> = playdate.graphics
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
	gfx.drawText("Batt: " .. playdate.getBatteryPercentage() .. "%", 40, 180)
end
