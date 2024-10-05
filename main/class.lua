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

local function blockInView(camera, position, block)
  local inView = true
  if camera.direciton == class.NORTH and position.z < camera.position.z then
    inView = false
  elseif camera.direciton == class.SOUTH and position.z > camera.position.z then
    inView = false
  elseif camera.direciton == class.EAST and position.x < camera.position.x then
    inView = false
  elseif camera.direciton == class.WEST and position.x > camera.position.x then
    inView = false
  else
    -- need more logic here
  end
  return inView
end

-- in screen coordinates
local function getBlockOffset(camera, position)
  local blockOffset = {}
  blockOffset.y = position.y - camera.position.y
  if camera.direction == class.NORTH then
    blockOffset.x = position.x - camera.position.x
    blockOffset.z = position.z - camera.position.z
  elseif camera.direction == class.SOUTH then
    blockOffset.x = camera.position.x - position.x
    blockOffset.z = camera.position.z - position.z
  elseif camera.direction == class.EAST then
    blockOffset.x = position.z - camera.position.z
    blockOffset.z = position.x - camera.position.x
  elseif camera.direction == class.WEST then
    blockOffset.x = camera.position.z - position.z
    blockOffset.z = camera.position.x - position.x
  end
  return blockOffset
end

local function renderSurface(camera, width, height, surface, position)
  local offset = getBlockOffset(camera, position)
  local scaleA = height * camera.frame * camera.perspective ^ offset.z
  local scaleB = scaleA * camera.perspective
  local vertices = {}
  -- need some logic to reverse side wall textures
  if (camera.direction == class.NORTH and surface.side == class.NORTH)
  or (camera.direction == class.SOUTH and surface.side == class.SOUTH)
  or (camera.direction == class.EAST and surface.side == class.EAST)
  or (camera.direction == class.WEST and surface.side == class.WEST) then
    vertices[1] = {(offset.x - 0.5) * scaleB, (offset.y - 0.5) * scaleB, 0, 0}
    vertices[2] = {(offset.x + 0.5) * scaleB, (offset.y - 0.5) * scaleB, 1, 0}
    vertices[3] = {(offset.x + 0.5) * scaleB, (offset.y + 0.5) * scaleB, 1, 1}
    vertices[4] = {(offset.x - 0.5) * scaleB, (offset.y + 0.5) * scaleB, 0, 1}
  elseif (camera.direction == class.NORTH and surface.side == class.SOUTH)
  or (camera.direction == class.SOUTH and surface.side == class.NORTH)
  or (camera.direction == class.EAST and surface.side == class.WEST)
  or (camera.direction == class.WEST and surface.side == class.EAST) then
    vertices[1] = {(offset.x - 0.5) * scaleA, (offset.y - 0.5) * scaleA, 0, 0}
    vertices[2] = {(offset.x + 0.5) * scaleA, (offset.y - 0.5) * scaleA, 1, 0}
    vertices[3] = {(offset.x + 0.5) * scaleA, (offset.y + 0.5) * scaleA, 1, 1}
    vertices[4] = {(offset.x - 0.5) * scaleA, (offset.y + 0.5) * scaleA, 0, 1}
  elseif (camera.direction == class.NORTH and surface.side == class.EAST)
  or (camera.direction == class.SOUTH and surface.side == class.WEST)
  or (camera.direction == class.EAST and surface.side == class.SOUTH)
  or (camera.direction == class.WEST and surface.side == class.NORTH) then
    vertices[1] = {(offset.x + 0.5) * scaleB, (offset.y - 0.5) * scaleB, 0, 0}
    vertices[2] = {(offset.x + 0.5) * scaleA, (offset.y - 0.5) * scaleA, 1, 0}
    vertices[3] = {(offset.x + 0.5) * scaleA, (offset.y + 0.5) * scaleA, 1, 1}
    vertices[4] = {(offset.x + 0.5) * scaleB, (offset.y + 0.5) * scaleB, 0, 1}
  elseif (camera.direction == class.NORTH and surface.side == class.WEST)
  or (camera.direction == class.SOUTH and surface.side == class.EAST)
  or (camera.direction == class.EAST and surface.side == class.NORTH)
  or (camera.direction == class.WEST and surface.side == class.SOUTH) then
    vertices[1] = {(offset.x - 0.5) * scaleB, (offset.y - 0.5) * scaleB, 0, 0}
    vertices[2] = {(offset.x - 0.5) * scaleA, (offset.y - 0.5) * scaleA, 1, 0}
    vertices[3] = {(offset.x - 0.5) * scaleA, (offset.y + 0.5) * scaleA, 1, 1}
    vertices[4] = {(offset.x - 0.5) * scaleB, (offset.y + 0.5) * scaleB, 0, 1}
  elseif surface.side == class.DOWN then
    vertices[1] = {(offset.x - 0.5) * scaleB, (offset.y + 0.5) * scaleB, 0, 0}
    vertices[2] = {(offset.x - 0.5) * scaleA, (offset.y + 0.5) * scaleA, 1, 0}
    vertices[3] = {(offset.x + 0.5) * scaleA, (offset.y + 0.5) * scaleA, 1, 1}
    vertices[4] = {(offset.x + 0.5) * scaleB, (offset.y + 0.5) * scaleB, 0, 1}
  elseif surface.side == class.UP then
    vertices[1] = {(offset.x - 0.5) * scaleB, (offset.y - 0.5) * scaleB, 0, 0}
    vertices[2] = {(offset.x - 0.5) * scaleA, (offset.y - 0.5) * scaleA, 1, 0}
    vertices[3] = {(offset.x + 0.5) * scaleA, (offset.y - 0.5) * scaleA, 1, 1}
    vertices[4] = {(offset.x + 0.5) * scaleB, (offset.y - 0.5) * scaleB, 0, 1}
  end
  local mesh = love.graphics.newMesh(vertices)
  mesh:setTexture(surface.texture)
  love.graphics.draw(mesh)
end

local function renderBlock(camera, canvas, position, block)
  if not blockInView(camera, position, block) then return end
  local width, height = canvas:getPixelDimensions()
  love.graphics.setCanvas(canvas)
  love.graphics.origin()
  love.graphics.translate(
    canvas:getPixelHeight() / 2.0,
    canvas:getPixelWidth() / 2.0
  )
  for _, surface in pairs(block:getSurfaces(camera.direction)) do
    renderSurface(camera, width, height, surface, position)
  end
  love.graphics.setCanvas()
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

function class.surface.new(texture, direction, side)
  local instance = {}
  instance.texture = texture
  instance.direction = direction
  instance.side = side
  -- instance.offset = offset or 0.0
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
  instance.frame = .8
  instance.fog = 1.0
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
  self._surfaces[surface.direction] = self._surfaces[surface.direction] or {}
  self._surfaces[surface.direction][surface.side] = surface
end

function class.block:getSurfaces(direction)
  return self._surfaces[direction]
end

function class.block:getSurface(side, direction)
  return self._surfaces[direction] and self._surfaces[direction][side] or nil
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

-- ╭ -------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Instance | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ -------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- (add instance object here to represent block position and rotation)


-- ╭ ----- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | World | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ----- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- +y is DOWN
-- +x is EAST
-- +z is NORTH

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
