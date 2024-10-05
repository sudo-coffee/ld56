local view = require("utils.view")
local class = require("class")
local blocks = require("blocks")
local world = nil
local worldCamera = nil
local worldCanvas = nil


-- ╭ ------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Helpers | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function worldTest()
  worldCamera = class.camera.new()
  worldCanvas = love.graphics.newCanvas(800, 800)
  world = class.world.new()
  worldCamera.position = {x=10, y=10, z=10}
  worldCamera.direction = class.NORTH
  world:setBlock(15, 12, 20, blocks.testBlockRed())
  world:setBlock(14, 12, 20, blocks.testBlockBlue())
  world:setBlock(13, 12, 20, blocks.testBlockRed())
  world:setBlock(12, 12, 20, blocks.testBlockBlue())
  world:setBlock(8, 8, 24, blocks.testBlockRed())
  world:setBlock(7, 7, 23, blocks.testBlockBlue())
  world:setBlock(6, 6, 22, blocks.testBlockRed())
  world:setBlock(5, 5, 21, blocks.testBlockBlue())

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
  world:render(worldCamera, worldCanvas)
  view.origin()
  love.graphics.draw(worldCanvas)
end
