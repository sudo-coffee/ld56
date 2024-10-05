local class = {}
class.world = {}
class.block = {}


-- ╭ ----- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Enums | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ----- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Direction enum.
class.NORTH = 1
class.SOUTH = 2
class.EAST = 3
class.WEST = 4
class.UP = 5
class.DOWN = 6


-- ╭ ------ ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Camera | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------ ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function class.camera.new()
  local instance = {}
  instance._position = {}
  instance._direction = nil
  setmetatable(instance, {__index = class.camera})
  return instance
end

function class.camera:setPosition(x, y, z)
  self._position[1] = x
  self._position[2] = y
  self._position[3] = z
end

function class.camera:getPosition()
  local x, y, z = self._position[1], self._position[2], self._position[3]
  return x, y, z
end

function class.camera:setDirection(direction)
  instance._direction = direction
end

function class.camera:getDirection(direction)
  local direction = instance._direction
  return direction
end


-- ╭ ----- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Block | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ----- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function class.block.new()
  local instance = {}
  setmetatable(instance, {__index = class.block})
  return instance
end


-- ╭ ----- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | World | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ----- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function class.world.new()
  local instance = {}
  instance._blocks = {}
  instance._bounds = {}
  setmetatable(instance, {__index = class.world})
  return instance
end

function class.world:setBounds(x, y, z)
  self._bounds = {x, y, z}
end

function class.world:addBlock(x, y, z, block)
  self._blocks[x] = self._blocks[x] or {}
  self._blocks[x][y] = self._blocks[x][y] or {}
  self._blocks[x][y][z] = block
end

function class.world:getBlock(x, y, z)
  local block = nil
  if self._blocks[x] and self._blocks[x][y] and self._blocks[x][y][z] then
    block = self._blocks[x][y][z]
  end
  return block
end

function class.world:clearBlock(x, y, z)
  if self._blocks[x] and self._blocks[x][y] and self._blocks[x][y][z] then
    self._blocks[x][y][z] = nil
  end
end

function world:render(camera)
  local blocksToRender = {}
end

return class
