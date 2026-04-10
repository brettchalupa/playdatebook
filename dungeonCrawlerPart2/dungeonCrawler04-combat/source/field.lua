import("sound")
import("input")
import("CoreLibs/graphics")
local gfx <const> = playdate.graphics

local SCALE <const> = 4
local DISPLAY_HEIGHT = nil -- gets set in initField
local DISPLAY_WIDTH = nil  -- gets set in initField
local TILE_SIZE <const> = 8

local player = { imgtableIndex = 5 }
local stepsUntilEncounter = 0
local map = nil
local levels = {
  level1 = import("level1"),
  level2 = import("level2"),
}
local camera = { x = 0, y = 0 }
local gfx <const> = playdate.graphics

local tileProp <const> = {
  WALKABLE = "walkable",
}
local tileProps <const> = {
  [18] = tileProp.WALKABLE,   -- ground
}
local focusedNPC = nil
local levelName = nil
local objectType <const> = {
  NPC = "npc",
  STAIRS = "stairs",
}
local objects <const> = {
  level1 = {
    -- NPCs
    ["22,10"] = {
      type = objectType.NPC,
      name = "Dog",
      text = "Got a treat?",
    },
    ["23,4"] = {
      type = objectType.NPC,
      name = "Snake",
      text = "Dogs, all they think about is food.",
    },
    ["24,7"] = {
      type = objectType.NPC,
      name = "Column",
      text = "Sure is windy out here today.",
    },
    -- STAIRS
    ["10,6"] = {
      type = objectType.STAIRS,
      toLevel = "level2",
      toPos = "3,2",
    },
  },
  level2 = {
    -- NPCs
    ["14,13"] = {
      type = objectType.NPC,
      name = "Jarman",
      text = "I didn't think anyone would find me in here!",
    },
    ["25,9"] = {
      type = objectType.NPC,
      name = "???",
      text = "Best be careful round these parts...",
    },
    -- STAIRS
    ["4,2"] = {
      type = objectType.STAIRS,
      toLevel = "level1",
      toPos = "9,6",
    },
  },
}

local function resetEncounterSteps()
  stepsUntilEncounter = math.random(7, 15)
end

local function levelHasEncounters(l)
  if l == "level1" then
    return false
  else
    return true
  end
end

local function loadLevel(name, imgtable)
  levelName = name
  local level = levels[levelName]
  print("Loading level: " .. levelName)

  if levelHasEncounters(levelName) then
    resetEncounterSteps()
  end

  local map = gfx.tilemap.new()
  map:setImageTable(imgtable)
  local layer = level.layers[1]
  map:setTiles(layer.data, layer.width)
  return map
end

local function drawTile(i, x, y)
  imgtable:drawImage(i, (x * TILE_SIZE) - camera.x, (y * TILE_SIZE) - camera.y)
end

local function drawPlayer(p)
  drawTile(p.imgtableIndex, p.x, p.y)
end

local function traverseStairs(stairs, p)
  local x, y = stairs.toPos:match("(%d+),(%d+)")
  player.x = x
  player.y = y
  map = loadLevel(stairs.toLevel, imgtable)
end

local function updatePlayer(p, map)
  local d = getInputDelta()

  if d.x ~= 0 or d.y ~= 0 then
    local dest = { x = p.x + d.x, y = p.y + d.y }

    local tileAtDest = map:getTileAtPosition(dest.x + 1, dest.y + 1)

    if tileProps[tileAtDest] == tileProp.WALKABLE then
      p.x += d.x
      p.y += d.y

      if levelHasEncounters(levelName) then
        stepsUntilEncounter -= 1

        if stepsUntilEncounter <= 0 then
          resetEncounterSteps()
          initCombat(enemies.snake)
          playSFX("C4")
        end
      end
    else
      local focusedObj = objects[levelName][dest.x .. "," .. dest.y]

      if focusedObj then
        if focusedObj.type == objectType.NPC then
          focusedNPC = focusedObj
          playSFX("B3")
        elseif focusedObj.type == objectType.STAIRS then
          traverseStairs(focusedObj, p)
          playSFX("B1")
        end
      end
    end
  end
end

local function updateCamera(c, p)
  c.x = p.x * TILE_SIZE - (DISPLAY_WIDTH / 2)
  c.y = p.y * TILE_SIZE - (DISPLAY_HEIGHT / 2)
end

local function drawTextbox(speak)
  gfx.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
  gfx.drawText(speak.name, 4, 0)
  gfx.setImageDrawMode(playdate.graphics.kDrawModeCopy)

  playdate.graphics.setColor(gfx.kColorWhite)
  gfx.fillRoundRect(0, DISPLAY_HEIGHT - 46, DISPLAY_WIDTH, 46, 4)
  playdate.graphics.setColor(gfx.kColorBlack)
  gfx.drawTextInRect(speak.text, 4, DISPLAY_HEIGHT - 42, DISPLAY_WIDTH - 8, 40)
end

function switchToField()
  switchState("field")
  playdate.display.setScale(SCALE)
  DISPLAY_HEIGHT = playdate.display.getHeight()
  DISPLAY_WIDTH = playdate.display.getWidth()

  gfx.setBackgroundColor(gfx.kColorBlack)
end

function initField()
  switchToField()

  player.x = 5
  player.y = 6

  map = loadLevel("level1", imgtable)
end

function updateField()
  if focusedNPC then
    if playdate.buttonJustPressed(playdate.kButtonA) then
      playSFX("C5")
      focusedNPC = nil
    end
  else
    updatePlayer(player, map)
    updateCamera(camera, player)
  end

  gfx.clear()

  if focusedNPC then
    drawTextbox(focusedNPC)
  else
    map:draw(-camera.x, -camera.y)
    drawPlayer(player)
  end
end
