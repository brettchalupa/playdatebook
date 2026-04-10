function getInputDelta()
  d = { x = 0, y = 0 }

  if playdate.buttonJustPressed(playdate.kButtonLeft) then
    d.x -= 1
  end

  if playdate.buttonJustPressed(playdate.kButtonRight) then
    d.x += 1
  end

  if playdate.buttonJustPressed(playdate.kButtonUp) then
    d.y -= 1
  end

  if playdate.buttonJustPressed(playdate.kButtonDown) then
    d.y += 1
  end

  return d
end
