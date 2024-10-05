local class = {}


-- ╭ ----- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Enums | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ----- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Side / Rotation / Direction. Should store these as vectors.
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
  local pos, cam = position, camera.position
  if pos.x == cam.x and pos.y == cam.y and pos.z == cam.z then
    inView = false
  elseif camera.direction == class.NORTH and pos.z < cam.z then
    inView = false
  elseif camera.direction == class.SOUTH and pos.z > cam.z then
    inView = false
  elseif camera.direction == class.EAST and pos.x < cam.x then
    inView = false
  elseif camera.direction == class.WEST and pos.x > cam.x then
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
    blockOffset.x = camera.position.z - position.z
    blockOffset.z = position.x - camera.position.x
  elseif camera.direction == class.WEST then
    blockOffset.x = position.z - camera.position.z
    blockOffset.z = camera.position.x - position.x
  end
  return blockOffset
end

local function renderSurface(camera, height, surface, position, block)
  local offset = getBlockOffset(camera, position)
  local scaleA = height * camera.perspective ^ offset.z / camera.frame
  local scaleB = scaleA * camera.perspective
  local vertices = {}
  local rotated = block:toRotated(surface.side)
  -- need some logic to reverse side wall textures
  if (camera.direction == class.NORTH and rotated == class.NORTH)
  or (camera.direction == class.SOUTH and rotated == class.SOUTH)
  or (camera.direction == class.EAST and rotated == class.EAST)
  or (camera.direction == class.WEST and rotated == class.WEST) then
    vertices[1] = {(offset.x - 0.5) * scaleB, (offset.y - 0.5) * scaleB, 0, 0}
    vertices[2] = {(offset.x + 0.5) * scaleB, (offset.y - 0.5) * scaleB, 1, 0}
    vertices[3] = {(offset.x + 0.5) * scaleB, (offset.y + 0.5) * scaleB, 1, 1}
    vertices[4] = {(offset.x - 0.5) * scaleB, (offset.y + 0.5) * scaleB, 0, 1}
  elseif (camera.direction == class.NORTH and rotated == class.SOUTH)
  or (camera.direction == class.SOUTH and rotated == class.NORTH)
  or (camera.direction == class.EAST and rotated == class.WEST)
  or (camera.direction == class.WEST and rotated == class.EAST) then
    vertices[1] = {(offset.x - 0.5) * scaleA, (offset.y - 0.5) * scaleA, 0, 0}
    vertices[2] = {(offset.x + 0.5) * scaleA, (offset.y - 0.5) * scaleA, 1, 0}
    vertices[3] = {(offset.x + 0.5) * scaleA, (offset.y + 0.5) * scaleA, 1, 1}
    vertices[4] = {(offset.x - 0.5) * scaleA, (offset.y + 0.5) * scaleA, 0, 1}
  elseif (camera.direction == class.NORTH and rotated == class.EAST)
  or (camera.direction == class.SOUTH and rotated == class.WEST)
  or (camera.direction == class.EAST and rotated == class.SOUTH)
  or (camera.direction == class.WEST and rotated == class.NORTH) then
    vertices[1] = {(offset.x + 0.5) * scaleB, (offset.y - 0.5) * scaleB, 0, 0}
    vertices[2] = {(offset.x + 0.5) * scaleA, (offset.y - 0.5) * scaleA, 1, 0}
    vertices[3] = {(offset.x + 0.5) * scaleA, (offset.y + 0.5) * scaleA, 1, 1}
    vertices[4] = {(offset.x + 0.5) * scaleB, (offset.y + 0.5) * scaleB, 0, 1}
  elseif (camera.direction == class.NORTH and rotated == class.WEST)
  or (camera.direction == class.SOUTH and rotated == class.EAST)
  or (camera.direction == class.EAST and rotated == class.NORTH)
  or (camera.direction == class.WEST and rotated == class.SOUTH) then
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

local function renderSprite(camera, height, sprite, position)
  local offset = getBlockOffset(camera, position)
  offset.z = offset.z + sprite.offset
  local scale = height * camera.perspective ^ offset.z / camera.frame
  local vertices = {}
  vertices[1] = {(offset.x - 0.5) * scale, (offset.y - 0.5) * scale, 0, 0}
  vertices[2] = {(offset.x + 0.5) * scale, (offset.y - 0.5) * scale, 1, 0}
  vertices[3] = {(offset.x + 0.5) * scale, (offset.y + 0.5) * scale, 1, 1}
  vertices[4] = {(offset.x - 0.5) * scale, (offset.y + 0.5) * scale, 0, 1}
  local mesh = love.graphics.newMesh(vertices)
  mesh:setTexture(sprite.texture)
  love.graphics.draw(mesh)
end

local function renderBlock(camera, canvas, position, block)
  if not blockInView(camera, position, block) then return end
  local height = canvas:getPixelHeight()
  love.graphics.push("all")
  love.graphics.setCanvas(canvas)
  love.graphics.origin()
  love.graphics.translate(
    canvas:getPixelHeight() / 2.0,
    canvas:getPixelWidth() / 2.0
  )
  for _, surface
  in pairs(block:getSurfaces(block:fromRotated(camera.direction))) do
    renderSurface(camera, height, surface, position, block)
  end
  local sprite = block:getSprite(block:fromRotated(camera.direction))
  if sprite then renderSprite(camera, height, sprite, position) end
  love.graphics.pop()
end


-- ╭ ---- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Wall | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ---- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.wall = {}

function class.wall.new(side)
  local instance = {}
  instance.side = side
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
  return instance
end


-- ╭ ------ ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Sprite | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------ ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.sprite = {}

function class.sprite.new(texture, direction, offset)
  local instance = {}
  instance.texture = texture
  instance.direction = direction
  instance.offset = offset or 0.5
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
  instance.perspective = 0.6
  instance.frame = 0.8
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
  instance._sprites = {}
  instance._rotation = class.NORTH
  setmetatable(instance, {__index = class.block})
  return instance
end

function class.block:addWall(wall)
  self._walls[wall.side] = wall
end

function class.block:getWall(side)
  return self._walls[wall.side] or nil
end

function class.block:testWall(side)
  return self._walls[side] ~= nil
end

function class.block:addSurface(surface)
  self._surfaces[surface.direction] = self._surfaces[surface.direction] or {}
  self._surfaces[surface.direction][surface.side] = surface
end

function class.block:getSurfaces(direction)
  return self._surfaces[direction] or {}
end

function class.block:addSprite(sprite)
  self._sprites[sprite.direction] = sprite
end

function class.block:getSprite(direction)
  return self._sprites[direction] or nil
end

-- Must be NORTH, EAST, SOUTH, or WEST.
function class.block:setRotation(direction)
  self._rotation = direction
end

function class.block:getRotation()
  return self._rotation
end

function class.block:toRotated(direction)
  local newDirection = direction
  if newDirection <= 4 then
    newDirection = (direction + self._rotation - 2) % 4 + 1
  end
  return newDirection
end

function class.block:fromRotated(direction)
  local newDirection = direction
  if newDirection <= 4 then
    newDirection = (direction - self._rotation) % 4 + 1
  end
  return newDirection
end

-- ╭ -------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Instance | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ -------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- (add instance object here to represent block position and rotation)


-- ╭ --------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Character | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ --------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.character = {}

function class.character.new(block, slotX, slotY, resX, resY, pad)
  local instance = {}
  instance._block = block -- needs to be a unique object
  instance._camera = class.camera.new()
  instance._canvas = love.graphics.newCanvas(resX - pad * 2, resY - pad * 2)
  instance._position = nil
  instance._direction = instance._camera.direction
  instance._slot = {slotX, slotY} -- integer
  local vertices = {
    {resX * (slotX - 1) + pad, resY * (slotY - 1) + pad, 0, 0},
    {resX * (slotX - 1) + pad, resY * slotY - pad, 0, 1},
    {resX * slotX - pad, resY * slotY - pad, 1, 1},
    {resX * slotX - pad, resY * (slotY - 1) + pad, 1, 0},
  }
  instance._mesh = love.graphics.newMesh(vertices)
  instance._mesh:setTexture(instance._canvas)
  setmetatable(instance, {__index = class.character})
  return instance
end

function class.character:render(world)
  love.graphics.push("all")
  love.graphics.setCanvas(self._canvas)
  love.graphics.clear(0.3, 0.3, 0.4, 1.0)
  love.graphics.pop()
  world:render(self._camera, self._canvas)
end

function class.character:getMesh()
  return self._mesh
end

function class.character:setDirection(direction)
  self._direction = direction
  self._camera.direction = direction
  self._block.direction = direction
end

function class.character:getDirection()
  return self._direction
end

function class.character:rotate(turns)
  self._direction = (self._direction + turns - 1) % 4 + 1
  self._camera.direction = self._direction
  self._block.direction = self._direction
end

function class.character:setPosition(world, position)
  if self._position then
    world:clearBlock(self._position.x, self._position.y, self._position.z)
  end
  world:setBlock(position.x, position.y, position.z, self._block)
  self._position = position
  self._camera.position = position
end

function class.character:getPosition()
  return {x=self._position.x, y=self._position.y, z=self._position.z}
end

function class.character:destroy(world)
  if self._position then
    world:clearBlock(self._position.x, self._position.y, self._position.z)
  end
end


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
