import("sound")
import("field")
import("combat")

local gfx <const> = playdate.graphics

local states = {
  field = {
    update = updateField,
  },
  combat = {
    update = updateCombat,
  },
}
currentState = states.field

function switchState(s)
  currentState = states[s]

  if currentState == nil then
    print("invalid state set! " .. s)
  end
end

function playdate.update()
  currentState.update()
end

function init()
  math.randomseed(playdate.getSecondsSinceEpoch())

  local fontNontendo = gfx.font.new("fonts/Nontendo-Bold")
  gfx.setFont(fontNontendo)

  initField()
end

init()
