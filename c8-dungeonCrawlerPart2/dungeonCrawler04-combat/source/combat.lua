local gfx <const> = playdate.graphics

local enemy = nil
local menuIndex = 0
local SCALE <const> = 2
local MENU_ITEMS <const> = {
  "Attack",
  "Defend",
  "Run",
}
local messageQueue = {}

function initCombat(e)
  menuIndex = 1
  enemy = table.shallowcopy(e)
  messageQueue = {}
  switchState("combat")
  print("initCombat: " .. enemy.name)

  playdate.display.setScale(SCALE)
  playdate.graphics.setColor(gfx.kColorWhite)
end

function drawTile(i, x, y)
  imgtable:getImage(i):drawScaled(x, y, 4)
end

local menuTextX = 10
local menuTextY = 50
local menuDotD = 6
local function drawMenu()
  for key, value in pairs(MENU_ITEMS) do
    gfx.drawText(value, menuTextX, (16 * key) + menuTextY)

    if menuIndex == key then
      gfx.fillCircleInRect(menuTextX - 8, (16 * key) + 2 + menuTextY, menuDotD, menuDotD)
    end
  end
end

local function takeAction(action)
  if action == "Attack" then
    local dmg = 2
    table.insert(messageQueue, "You attacked!")
    table.insert(messageQueue, "Dealt " .. dmg .. " damage!")
    table.insert(messageQueue, function(e)
      e.hp -= dmg

      if e.hp <= 0 then
        table.insert(messageQueue, "Defeated " .. e.name .. "!")
        table.insert(messageQueue, function()
          switchToField()
          return true
        end)
      end
    end)
  elseif action == "Defend" then
    table.insert(messageQueue, "You defended!")
  elseif action == "Run" then
    table.insert(messageQueue, "You fled!")
    table.insert(messageQueue, function()
      switchToField()
      return true
    end)
  else
    print("Unknown action taken: " .. action)
  end
end

local function updateMenu()
  if playdate.buttonJustPressed(playdate.kButtonDown) then
    playSFX("C5")
    menuIndex += 1
  end

  if playdate.buttonJustPressed(playdate.kButtonUp) then
    playSFX("B4")
    menuIndex -= 1
  end

  if menuIndex > #MENU_ITEMS then
    menuIndex = 1
  end
  if menuIndex < 1 then
    menuIndex = #MENU_ITEMS
  end

  if playdate.buttonJustPressed(playdate.kButtonA) then
    playSFX("D4")
    takeAction(MENU_ITEMS[menuIndex])
  end
end

function updateCombat()
  gfx.clear()

  local currentMessage = messageQueue[1]

  if currentMessage then
    if type(currentMessage) == "string" then
      if playdate.buttonJustPressed(playdate.kButtonA) then
        playSFX("D4")
        table.remove(messageQueue, 1)
      end
    elseif type(currentMessage) == "function" then
      local returnEarly = currentMessage(enemy)
      table.remove(messageQueue, 1)
      if returnEarly then
        return
      end
    else
      print("Unhandled message queue type: " .. currentMessage)
      table.remove(messageQueue, 1)
    end
  else
    updateMenu()
  end

  gfx.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
  gfx.drawText(enemy.name .. "!", 12, 12)
  drawMenu()

  if #messageQueue > 0 then
    local currentMessage = messageQueue[1]
    if type(currentMessage) == "string" then
      local window_r = playdate.geometry.rect.new(90, 70, 100, 40)
      local text_r = playdate.geometry.rect.new(95, 75, 95, 35)
      gfx.drawRoundRect(window_r, 4)
      gfx.drawTextInRect(currentMessage, text_r)
      gfx.fillCircleInRect(180, 100, menuDotD, menuDotD)
    end
  end
  gfx.setImageDrawMode(playdate.graphics.kDrawModeCopy)

  drawTile(enemy.imgtableIndex, 100, 12)
end
