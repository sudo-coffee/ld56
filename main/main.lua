local view = require("utils.view")
local class = require("class")
local blocks = require("blocks")
local profile = require("libraries.profile.profile")
local world = nil
local characters = {}
local fallTimer = 1


-- ╭ ------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Helpers | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function onFloor(character)
  local isOnFloor = false
  local pos = character:getPosition()
  local testPos = {x=pos.x, y=pos.y+1, z=pos.z}
  if world:isWall(pos, class.DOWN)
  or world:isWall(testPos, class.UP) then
    isOnFloor = true
  end
  return isOnFloor
end

local function fall()
  for i=1,#characters do
    local pos = characters[i]:getPosition()
    if not onFloor(characters[i]) then pos.y = pos.y + 1 end
    characters[i]:setPosition(pos)
  end
end

local function moveForward()
  for i=1,#characters do
    if onFloor(characters[i]) then
      local pos = characters[i]:getPosition()
      local dir = characters[i]:getDirection()
      if dir == class.NORTH then
        local testPos = {x=pos.x, y=pos.y, z=pos.z+1}
        if not world:isTag(testPos, "character")
        and not world:isWall(pos, class.NORTH)
        and not world:isWall(testPos, class.SOUTH) then
          pos = testPos
        end
      elseif dir == class.SOUTH then
        local testPos = {x=pos.x, y=pos.y, z=pos.z-1}
        if not world:isTag(testPos, "character")
        and not world:isWall(pos, class.SOUTH)
        and not world:isWall(testPos, class.NORTH) then
          pos = testPos
        end
      elseif dir == class.WEST then
        local testPos = {x=pos.x-1, y=pos.y, z=pos.z}
        if not world:isTag(testPos, "character")
        and not world:isWall(pos, class.EAST)
        and not world:isWall(testPos, class.WEST) then
          pos = testPos
        end
      elseif dir == class.EAST then
        local testPos = {x=pos.x+1, y=pos.y, z=pos.z}
        if not world:isTag(testPos, "character")
        and not world:isWall(pos, class.WEST)
        and not world:isWall(testPos, class.EAST) then
          pos = testPos
        end
      end
      characters[i]:setPosition(pos)
    end
  end
end

local function moveBack()
  for i=1,#characters do
    if onFloor(characters[i]) then
      local pos = characters[i]:getPosition()
      local dir = characters[i]:getDirection()
      if dir == class.NORTH then
        local testPos = {x=pos.x, y=pos.y, z=pos.z-1}
        if not world:isTag(testPos, "character")
        and not world:isWall(pos, class.SOUTH)
        and not world:isWall(testPos, class.NORTH) then
          pos = testPos
        end
      elseif dir == class.SOUTH then
        local testPos = {x=pos.x, y=pos.y, z=pos.z+1}
        if not world:isTag(testPos, "character")
        and not world:isWall(pos, class.NORTH)
        and not world:isWall(testPos, class.SOUTH) then
          pos = testPos
        end
      elseif dir == class.WEST then
        local testPos = {x=pos.x+1, y=pos.y, z=pos.z}
        if not world:isTag(testPos, "character")
        and not world:isWall(pos, class.WEST)
        and not world:isWall(testPos, class.EAST) then
          pos = testPos
        end
      elseif dir == class.EAST then
        local testPos = {x=pos.x-1, y=pos.y, z=pos.z}
        if not world:isTag(testPos, "character")
        and not world:isWall(pos, class.EAST)
        and not world:isWall(testPos, class.WEST) then
          pos = testPos
        end
      end
      characters[i]:setPosition(pos)
    end
  end
end

local function strafeRight()
  for i=1,#characters do
    if onFloor(characters[i]) then
      local pos = characters[i]:getPosition()
      local dir = characters[i]:getDirection()
      if dir == class.NORTH then
        local testPos = {x=pos.x+1, y=pos.y, z=pos.z}
        if not world:isTag(testPos, "character")
        and not world:isWall(pos, class.EAST)
        and not world:isWall(testPos, class.WEST) then
          pos = testPos
        end
      elseif dir == class.SOUTH then
        local testPos = {x=pos.x-1, y=pos.y, z=pos.z}
        if not world:isTag(testPos, "character")
        and not world:isWall(pos, class.WEST)
        and not world:isWall(testPos, class.EAST) then
          pos = testPos
        end
      elseif dir == class.WEST then
        local testPos = {x=pos.x, y=pos.y, z=pos.z+1}
        if not world:isTag(testPos, "character")
        and not world:isWall(pos, class.NORTH)
        and not world:isWall(testPos, class.SOUTH) then
          pos = testPos
        end
      elseif dir == class.EAST then
        local testPos = {x=pos.x, y=pos.y, z=pos.z-1}
        if not world:isTag(testPos, "character")
        and not world:isWall(pos, class.SOUTH)
        and not world:isWall(testPos, class.NORTH) then
          pos = testPos
        end
      end
      characters[i]:setPosition(pos)
    end
  end
end

local function strafeLeft()
  for i=1,#characters do
    if onFloor(characters[i]) then
      local pos = characters[i]:getPosition()
      local dir = characters[i]:getDirection()
      if dir == class.NORTH then
        local testPos = {x=pos.x-1, y=pos.y, z=pos.z}
        if not world:isTag(testPos, "character")
        and not world:isWall(pos, class.WEST)
        and not world:isWall(testPos, class.EAST) then
          pos = testPos
        end
      elseif dir == class.SOUTH then
        local testPos = {x=pos.x+1, y=pos.y, z=pos.z}
        if not world:isTag(testPos, "character")
        and not world:isWall(pos, class.EAST)
        and not world:isWall(testPos, class.WEST) then
          pos = testPos
        end
      elseif dir == class.WEST then
        local testPos = {x=pos.x, y=pos.y, z=pos.z-1}
        if not world:isTag(testPos, "character")
        and not world:isWall(pos, class.SOUTH)
        and not world:isWall(testPos, class.NORTH) then
          pos = testPos
        end
      elseif dir == class.EAST then
        local testPos = {x=pos.x, y=pos.y, z=pos.z+1}
        if not world:isTag(testPos, "character")
        and not world:isWall(pos, class.NORTH)
        and not world:isWall(testPos, class.SOUTH) then
          pos = testPos
        end
      end
      characters[i]:setPosition(pos)
    end
  end
end

local function turnRight()
  for i=1,#characters do
    if onFloor(characters[i]) then
      local direction = characters[i]:getDirection()
      direction = direction % 4 + 1
      characters[i]:setDirection(direction)
    end
  end
end

local function turnLeft()
  for i=1,#characters do
    if onFloor(characters[i]) then
      local direction = characters[i]:getDirection()
      direction = (direction - 2) % 4 + 1
      characters[i]:setDirection(direction)
    end
  end
end

-- local function worldTest()
--   camera = class.camera.new()
--   worldCanvas = love.graphics.newCanvas(800, 800)
--   world = class.world.new()
--   camera.position = {x=10, y=10, z=10}
--   camera.direction = class.NORTH
--   testBlockRed = blocks.testBlockColor(0.8, 0.2, 0.3, 0.6)
--   testBlockBlue = blocks.testBlockColor(0.2, 0.3, 0.8, 0.6)
--   testSprite = blocks.testSpriteColor(0.4, 0.6, 0.4, 0.8)
--   world:setBlock(11, 10, 10, testBlockRed)
--   world:setBlock(9, 10, 11, testBlockRed)
--   world:setBlock(9, 10, 10, testBlockBlue)
--   world:setBlock(11, 10, 11, testBlockBlue)
--   world:setBlock(10, 10, 11, testSprite)
-- end

local function drawTestFloor()
  local testBlockRed = blocks.testBlockColor(0.8, 0.2, 0.3, 0.6)
  for x=1,15 do
    for z=1,15 do
      world:addBlock(testBlockRed, {x=x, y=20, z=z})
    end
  end
end


-- ╭ --------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Callbacks | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ --------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function love.load()
  world = class.world.new()
  local testBlockRed = blocks.testBlockColor(0.8, 0.2, 0.3, 0.6)
  world:addBlock(testBlockRed, {x=11, y=8, z=10})
  view.setDimensions(800, 800)
  drawTestFloor()
  for x=1,4 do
    for y=1,4 do
      local block = blocks.character()
      local character = class.character.new(world, block, x, y, 200, 200, 10)
      character:setPosition({x=x*2+4, y=10, z=y*2+4})
      world:addBlock(testBlockRed, {x=x*2+4, y=11, z=y*2+4})
      table.insert(characters, character)
    end
  end
end

function love.draw()
  profile.start()
  view.origin()
  for i=1,#characters do
    local mesh = characters[i]:getMesh()
    characters[i]:render(world)
    love.graphics.draw(mesh)
  end
  profile.stop()
  print(profile.report(10))
end

function love.keypressed(key)
  if key == "w" or key == "up" then
    moveForward()
  elseif key == "s" or key == "down" then
    moveBack()
  elseif key == "d" or key == "right" then
    strafeRight()
  elseif key == "a" or key == "left" then
    strafeLeft()
  elseif key == "e" or key == "x" or key == "pagedown" then
    turnRight()
  elseif key == "q" or key == "z" or key == "pageup" then
    turnLeft()
  end
end

function love.update()
  fallTimer = fallTimer % 20 + 1
  if fallTimer == 1 then
    fall()
  end
end
