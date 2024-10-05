local view = require("utils.view")
local class = require("class")
local blocks = require("blocks")
local world = nil
local camera = nil
local worldCanvas = nil


-- ╭ ------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Helpers | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function moveForward()
  if camera.direction == class.NORTH then
    camera.position.z = camera.position.z + 1
  elseif camera.direction == class.SOUTH then
    camera.position.z = camera.position.z - 1
  elseif camera.direction == class.WEST then
    camera.position.x = camera.position.x - 1
  elseif camera.direction == class.EAST then
    camera.position.x = camera.position.x + 1
  end
  print(camera.position.x, camera.position.y, camera.position.z)
end

local function moveBack()
  if camera.direction == class.NORTH then
    camera.position.z = camera.position.z - 1
  elseif camera.direction == class.SOUTH then
    camera.position.z = camera.position.z + 1
  elseif camera.direction == class.WEST then
    camera.position.x = camera.position.x + 1
  elseif camera.direction == class.EAST then
    camera.position.x = camera.position.x - 1
  end
  print(camera.position.x, camera.position.y, camera.position.z)
end

local function strafeRight()
  if camera.direction == class.NORTH then
    camera.position.x = camera.position.x + 1
  elseif camera.direction == class.SOUTH then
    camera.position.x = camera.position.x - 1
  elseif camera.direction == class.WEST then
    camera.position.z = camera.position.z + 1
  elseif camera.direction == class.EAST then
    camera.position.z = camera.position.z - 1
  end
  print(camera.position.x, camera.position.y, camera.position.z)
end

local function strafeLeft()
  if camera.direction == class.NORTH then
    camera.position.x = camera.position.x - 1
  elseif camera.direction == class.SOUTH then
    camera.position.x = camera.position.x + 1
  elseif camera.direction == class.WEST then
    camera.position.z = camera.position.z - 1
  elseif camera.direction == class.EAST then
    camera.position.z = camera.position.z + 1
  end
  print(camera.position.x, camera.position.y, camera.position.z)
end

local function turnRight()
  camera.direction = camera.direction % 4 + 1
end

local function turnLeft()
  camera.direction = (camera.direction - 2) % 4 + 1
end

local function worldTest()
  camera = class.camera.new()
  worldCanvas = love.graphics.newCanvas(800, 800)
  world = class.world.new()
  camera.position = {x=10, y=10, z=10}
  camera.direction = class.NORTH
  testBlockRed = blocks.testBlockColor(0.8, 0.2, 0.3, 0.6)
  testBlockBlue = blocks.testBlockColor(0.2, 0.3, 0.8, 0.6)
  testSprite = blocks.testSpriteColor(0.4, 0.6, 0.4, 0.8)
  world:setBlock(11, 10, 10, testBlockRed)
  world:setBlock(9, 10, 11, testBlockRed)
  world:setBlock(9, 10, 10, testBlockBlue)
  world:setBlock(11, 10, 11, testBlockBlue)
  world:setBlock(10, 10, 11, testSprite)
  -- world:setBlock(13, 10, 20, blocks.testBlockRed())
  -- world:setBlock(12, 10, 20, blocks.testBlockBlue())
  -- world:setBlock(8, 8, 24, blocks.testBlockRed())
  -- world:setBlock(7, 7, 23, blocks.testBlockBlue())
  -- world:setBlock(6, 6, 22, blocks.testBlockRed())
  -- world:setBlock(5, 5, 21, blocks.testBlockBlue())

  -- world:setBlock(10, 10, 0, testBlockRed())
  -- world:setBlock(10, 10, 1, testBlockRed())
  -- world:setBlock(6, 0, 0, testBlockRed())
  -- world:setBlock(7, 4, 0, testBlockRed())
  -- world:setBlock(7, 2, 0, testBlockRed())
  -- world:setBlock(7, 5, 0, testBlockBlue())
  -- world:setBlock(8, 3, 0, testBlockBlue())
  -- world:setBlock(9, 0, 0, testBlockBlue())
  -- world:setBlock(10, 0, 0, testBlockBlue())
  -- world:setBlock(11, 0, 0, testBlockBlue())
  -- world:setBlock(12, 0, 0, testBlockBlue())
end


-- ╭ --------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Callbacks | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ --------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function love.load()
  view.setDimensions(800, 800)
  worldTest()
end

function love.draw()
  love.graphics.setCanvas(worldCanvas)
  love.graphics.clear()
  love.graphics.setCanvas()
  world:render(camera, worldCanvas)
  view.origin()
  love.graphics.draw(worldCanvas)
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
