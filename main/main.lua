local view = require("utils.view")
local class = require("class")
local blocks = require("blocks")
local world = nil
local characters = {}


-- ╭ ------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Helpers | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function moveForward()
  for i=1,#characters do
    local position = characters[i]:getPosition()
    local direction = characters[i]:getDirection()
    if direction == class.NORTH then
      position.z = position.z + 1
    elseif direction == class.SOUTH then
      position.z = position.z - 1
    elseif direction == class.WEST then
      position.x = position.x - 1
    elseif direction == class.EAST then
      position.x = position.x + 1
    end
    characters[i]:setPosition(world, position)
  end
end

local function moveBack()
  for i=1,#characters do
    local position = characters[i]:getPosition()
    local direction = characters[i]:getDirection()
    if direction == class.NORTH then
      position.z = position.z - 1
    elseif direction == class.SOUTH then
      position.z = position.z + 1
    elseif direction == class.WEST then
      position.x = position.x + 1
    elseif direction == class.EAST then
      position.x = position.x - 1
    end
    characters[i]:setPosition(world, position)
  end
end

local function strafeRight()
  for i=1,#characters do
    local position = characters[i]:getPosition()
    local direction = characters[i]:getDirection()
    if direction == class.NORTH then
      position.x = position.x + 1
    elseif direction == class.SOUTH then
      position.x = position.x - 1
    elseif direction == class.WEST then
      position.z = position.z + 1
    elseif direction == class.EAST then
      position.z = position.z - 1
    end
    characters[i]:setPosition(world, position)
  end
end

local function strafeLeft()
  for i=1,#characters do
    local position = characters[i]:getPosition()
    local direction = characters[i]:getDirection()
    if direction == class.NORTH then
      position.x = position.x - 1
    elseif direction == class.SOUTH then
      position.x = position.x + 1
    elseif direction == class.WEST then
      position.z = position.z - 1
    elseif direction == class.EAST then
      position.z = position.z + 1
    end
    characters[i]:setPosition(world, position)
  end
end

local function turnRight()
  for i=1,#characters do
    local direction = characters[i]:getDirection()
    direction = direction % 4 + 1
    characters[i]:setDirection(direction)
  end
end

local function turnLeft()
  for i=1,#characters do
    local direction = characters[i]:getDirection()
    direction = (direction - 2) % 4 + 1
    characters[i]:setDirection(direction)
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


-- ╭ --------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Callbacks | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ --------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function love.load()
  world = class.world.new()
  testBlockRed = blocks.testBlockColor(0.8, 0.2, 0.3, 0.6)
  world:setBlock(11, 10, 10, testBlockRed)
  view.setDimensions(800, 800)
  for x=1,4 do
    for y=1,4 do
      local block = blocks.character()
      local character = class.character.new(block, x, y, 200, 200, 10)
      character:setPosition(world, {x=x*2, y=10, z=y*2})
      table.insert(characters, character)
    end
  end
end

function love.draw()
  view.origin()
  for i=1,#characters do
    local mesh = characters[i]:getMesh()
    characters[i]:render(world)
    love.graphics.draw(mesh)
  end
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
