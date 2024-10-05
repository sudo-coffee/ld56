local view = require("utils.view")
local class = require("class")


-- ╭ --------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Callbacks | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ --------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function worldTest()
  local camera = class.camera.new()
  local world = class.world.new()
  camera:setPosition(10, 10, 0)
  world:setBlock(10, 10, 0, "block1")
  world:setBlock(10, 10, 1, "block1")
  world:setBlock(6, 0, 0, "block1")
  world:setBlock(7, 4, 0, "block2")
  world:setBlock(7, 2, 0, "block2")
  world:setBlock(7, 5, 0, "block2")
  world:setBlock(8, 3, 0, "block1")
  world:setBlock(9, 0, 0, "block2")
  world:setBlock(10, 0, 0, "block2")
  world:setBlock(11, 0, 0, "block3")
  world:setBlock(12, 0, 0, "block4")
  world:render(camera)
  -- print(world:getBlock(10, 0, 0))
  -- print(world:getBlock(10, 51, 30))
end

function love.load()
  view.setDimensions(1000, 1000)
  worldTest()
end

function love.draw()
  view.origin()
end
