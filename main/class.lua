local class = {}


-- ╭ ----- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Enums | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ----- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Side / Rotation / Direction.
class.NORTH = 1
class.EAST = 2
class.SOUTH = 3
class.WEST = 4
class.UP = 5
class.DOWN = 6


-- ╭ ------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Helpers | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function renderBlock(camera, canvas, position, block)
  local distance
  print(position[1], position[2], position[3], block)
end


-- ╭ ---- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Wall | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ---- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.wall = {}

function class.wall.new(direction)
  local instance = {}
  instance.direction = direction
  return instance
end


-- ╭ ------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Surface | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.surface = {}

function class.surface.new(texture, side, direction, offset)
  local instance = {}
  instance.texture = texture
  instance.side = side
  instance.direction = direction
  instance.offset = offset or 0.0
  return instance
end


-- ╭ ------ ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Camera | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------ ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.camera = {}

function class.camera.new()
  local instance = {}
  instance._position = {0, 0, 0}
  instance._direction = class.NORTH
  instance._perspective = 0.8
  instance._frame = 2.0
  setmetatable(instance, {__index = class.camera})
  return instance
end

function class.camera:setPosition(x, y, z)
  self._position = {x, y, z}
end

function class.camera:getPosition()
  return unpack(self._position)
end

-- Must be NORTH, EAST, SOUTH, or WEST.
function class.camera:setDirection(direction)
  self._direction = direction
end

function class.camera:getDirection()
  return self._direction
end

-- Float between "0.0" and "1.0".
function class.camera:setPerspective(perspective)
  self._perspective = perspective
end

function class.camera:getPerspective()
  return self._perspective
end

-- Value representing the size of the closest mesh layer, with 1.0 exactly
-- matching the Window's frame.
function class.camera:setFrame(frame)
  self._frame = frame
end

function class.camera:getFrame()
  return self._frame
end


-- ╭ ----- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Block | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ----- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.block = {}

function class.block.new()
  local instance = {}
  instance._walls = {}
  instance._surfaces = {}
  instance._rotation = class.NORTH
  setmetatable(instance, {__index = class.block})
  return instance
end

function class.block:addWall(wall)
  table.insert(self._walls, wall)
end

function class.block:getWalls()
  return self._walls
end

function class.block:addSurface(surface)
  table.insert(self._surfaces, surface)
end

function class.block:getSurfaces()
  return self._surfaces
end

-- Must be NORTH, EAST, SOUTH, or WEST.
function class.block:setRotation(direction)
  self._rotation = direction
end

function class.block:getRotation()
  return self._rotation
end

-- -- In number of 90 degree turns clockwise.
-- function class.block:rotate(turns)
--   self._rotation = (self._rotation + turns - 1) % 4 + 1
-- end


-- ╭ ----- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | World | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ----- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- +y is UP
-- +x is EAST
-- +z is SOUTH

class.world = {}

function class.world.new()
  local instance = {}
  instance._blocks = {}
  setmetatable(instance, {__index = class.world})
  return instance
end

function class.world:setBlock(x, y, z, block)
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

function class.world:render(camera, canvas)
  local positionsToRender = {}
  local direction = camera:getDirection()
  local camX, camY, camZ = camera:getPosition()

  for x, sliceY in pairs(self._blocks) do
    for y, sliceZ in pairs(sliceY) do
      for z, _ in pairs(sliceZ) do
        table.insert(positionsToRender, {x, y, z})
      end
    end
  end

  table.sort(positionsToRender, function(a, b)
    local aXDiff = math.max(a[1], camX) - math.min(a[1], camX)
    local aYDiff = math.max(a[2], camY) - math.min(a[2], camY)
    local aZDiff = math.max(a[3], camZ) - math.min(a[3], camZ)
    local bXDiff = math.max(b[1], camX) - math.min(b[1], camX)
    local bYDiff = math.max(b[2], camY) - math.min(b[2], camY)
    local bZDiff = math.max(b[3], camZ) - math.min(b[3], camZ)
    return aXDiff + aYDiff + aZDiff > bXDiff + bYDiff + bZDiff
  end)

  for i=1,#positionsToRender do
    local position = positionsToRender[i]
    local block = self:getBlock(unpack(position))
    renderBlock(camera, canvas, position, block)
  end

end

return class
