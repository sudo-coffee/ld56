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
  print(position.x, position.y, position.z, block)
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
  instance.position = {x=0, y=0, z=0}
  instance.direction = class.NORTH
  instance.perspective = 0.8
  instance.frame = 2.0
  instance.fog = 2.0
  setmetatable(instance, {__index = class.camera})
  return instance
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
  self._walls[wall.direction] = wall
end

function class.block:getWall(direction)
  return self._walls[wall.direction] or nil
end

function class.block:testWall(direction)
  return self._walls[direction] ~= nil
end

function class.block:addSurface(surface)
  self._surfaces[surface.side] = self._surfaces[surface.side] or {}
  self._surfaces[surface.side][surface.direction] = surface
end

function class.block:getSurface(side, direction)
  return self._surfaces[side] and self._surfaces[side][direction] or nil
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
  return self._blocks[x] and self._blocks[x][y] and self._blocks[x][y][z] or nil
end

function class.world:getBlockPositions()
  local blockPositions = {}
  for x, sliceY in pairs(self._blocks) do
    for y, sliceZ in pairs(sliceY) do
      for z, _ in pairs(sliceZ) do
        table.insert(blockPositions, {x=x, y=y, z=z})
      end
    end
  end
  return blockPositions
end

function class.world:clearBlock(x, y, z)
  if self._blocks[x] and self._blocks[x][y] and self._blocks[x][y][z] then
    self._blocks[x][y][z] = nil
  end
end

function class.world:render(camera, canvas)
  local blockPositions = self:getBlockPositions()
  local camX = camera.position.x
  local camY = camera.position.y
  local camZ = camera.position.z
  table.sort(blockPositions, function(a, b)
    local aXDiff = math.max(a.x, camX) - math.min(a.x, camX)
    local aYDiff = math.max(a.y, camY) - math.min(a.y, camY)
    local aZDiff = math.max(a.z, camZ) - math.min(a.z, camZ)
    local bXDiff = math.max(b.x, camX) - math.min(b.x, camX)
    local bYDiff = math.max(b.y, camY) - math.min(b.y, camY)
    local bZDiff = math.max(b.z, camZ) - math.min(b.z, camZ)
    return aXDiff + aYDiff + aZDiff > bXDiff + bYDiff + bZDiff
  end)
  for i=1,#blockPositions do
    local position = blockPositions[i]
    local block = self:getBlock(position.x, position.y, position.z)
    renderBlock(camera, canvas, position, block)
  end
end

return class
