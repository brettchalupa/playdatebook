local gfx <const> = playdate.graphics

local SCALE = 2

function switchToGameOver()
  gfx.clear(gfx.kColorBlack)
  playdate.display.setScale(SCALE)

  switchState("gameOver")
end

function updateGameOver()
  if playdate.buttonJustPressed(playdate.kButtonA) then
    initField()
    return
  end

  gfx.clear()
  gfx.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
  gfx.drawText("Game Over", 10, 10)
  gfx.drawText("Press A to restart", 10, 40)
  gfx.setImageDrawMode(playdate.graphics.kDrawModeCopy)
end
