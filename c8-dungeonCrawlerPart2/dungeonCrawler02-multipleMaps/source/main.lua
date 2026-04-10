import("sound")
import("field")

local gfx <const> = playdate.graphics

function playdate.update()
  updateField()
end

function init()
  local fontNontendo = gfx.font.new("fonts/Nontendo-Bold")
  gfx.setFont(fontNontendo)

  initField()
end

init()
