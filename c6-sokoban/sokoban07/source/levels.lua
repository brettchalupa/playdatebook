import "CoreLibs/object"

local levels <const> = {
    [[
    #####
    #@BT#
    #####
    ]],
    [[
    #######
    #     #
    #     #
    #@B#T #
    #  ####
    ]]
}

local legend <const> = {
    box = "B",
    target = "T",
    player= "@",
    wall = "#",
}

function numLevels()
    return #levels
end

-- parses a level string and loads the data into appropriate tables
function loadLevel(levelIndex, player, boxes, targets, walls)
    print("Loading level:", levelIndex)

    local level = levels[levelIndex]

    clearTable(boxes)
    clearTable(targets)
    clearTable(walls)
    player.steps = 0

    local lines = {}
    for line in level:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    for y, line in ipairs(lines) do
        line = trim(line)

        local x = 1
        for char in line:gmatch(".") do
            if char == legend.player then
                player.x = x
                player.y = y
            end

            if char == legend.wall then
                table.insert(walls, { x = x, y = y })
            end

            if char == legend.target then
                table.insert(targets, { x = x, y = y })
            end

            if char == legend.box then
                table.insert(boxes, { x = x, y = y })
            end

            x += 1
        end
    end
end

function trim(s)
  return string.gsub(s, "^%s*(.-)%s*$", "%1")
end

function clearTable(t)
  for k in pairs(t) do
    t[k] = nil
  end
end
