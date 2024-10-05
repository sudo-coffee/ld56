local view = require("utils.view")
local class = require("class")


-- ╭ --------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Callbacks | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ --------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function worldTest()
  local world = class.world.new()
  world:addBlock(10, 50, 30, "block1")
  world:addBlock(10, 50, 31, "block2")
  world:addBlock(10, 51, 30, "block3")
  world:addBlock(12, 50, 30, "block4")
  print(world:getBlock(10, 0, 0))
  print(world:getBlock(10, 51, 30))
end

function love.load()
  view.setDimensions(1000, 1000)
  worldTest()
end

function love.draw()
  view.origin()
end
