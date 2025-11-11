-- Movement timing configuration
local HOLD_INITIAL_DELAY = 15 -- frames before hold movement starts
local HOLD_REPEAT_DELAY = 4 -- frames between movements when holding

-- Button hold tracking
local holdTimers = {}

-- Button configuration: button -> {axis, value}
local buttons = {
	[playdate.kButtonUp] = { axis = "y", value = -1 },
	[playdate.kButtonDown] = { axis = "y", value = 1 },
	[playdate.kButtonLeft] = { axis = "x", value = -1 },
	[playdate.kButtonRight] = { axis = "x", value = 1 },
}

local function handleButton(button, movement)
	holdTimers[button] = holdTimers[button] or 0

	if playdate.buttonIsPressed(button) then
		holdTimers[button] += 1

		-- Immediate movement on first press
		if holdTimers[button] == 1 then
			return movement.value
		-- Repeated movement after hold delay
		elseif
			holdTimers[button] > HOLD_INITIAL_DELAY
			and (holdTimers[button] - HOLD_INITIAL_DELAY - 1) % HOLD_REPEAT_DELAY == 0
		then
			return movement.value
		end
	else
		holdTimers[button] = 0
	end

	return 0
end

function drawPlayer(p)
	drawTile(p.imgtableIndex, p.x - 1, p.y - 1)
end

function updatePlayer(p)
	local dx, dy = 0, 0

	for button, movement in pairs(buttons) do
		local delta = handleButton(button, movement)
		if movement.axis == "x" then
			dx += delta
		else
			dy += delta
		end
	end

	return dx, dy
end
