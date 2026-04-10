import("player")
import("enemies")
import("sound")
import("field")
import("combat")

local TILE_SIZE <const> = 8

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
imgtable = nil

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

  imgtable, err = gfx.imagetable.new("tilemap")
  if err then
    print(err)
  end

  initField()

  -- temporarily start combat for quick dev cycle
  initCombat(enemies.snake)
end

init()
