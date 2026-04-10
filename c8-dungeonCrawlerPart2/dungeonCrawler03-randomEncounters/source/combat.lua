local gfx <const> = playdate.graphics

function updateCombat()
  if playdate.buttonJustPressed(playdate.kButtonA) then
    switchState("field")
  end

  gfx.clear()

  gfx.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
  gfx.drawText("Combat!\n\nPress A to exit", 4, 4)
  gfx.setImageDrawMode(playdate.graphics.kDrawModeCopy)
end
