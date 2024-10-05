local class = {}


-- ╭ ----- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Enums | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ----- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Side / Direction. Should store these as vectors.
class.NORTH = 1
class.EAST = 2
class.SOUTH = 3
class.WEST = 4
class.UP = 5
class.DOWN = 6


-- ╭ ------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Helpers | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function instanceInView(camera, instance)
  local inView = true
  local cam, pos = camera.position, instance.position
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
local function getInstanceOffset(camera, instance)
  local instanceOffset = {}
  instanceOffset.y = instance.position.y - camera.position.y
  if camera.direction == class.NORTH then
    instanceOffset.x = instance.position.x - camera.position.x
    instanceOffset.z = instance.position.z - camera.position.z
  elseif camera.direction == class.SOUTH then
    instanceOffset.x = camera.position.x - instance.position.x
    instanceOffset.z = camera.position.z - instance.position.z
  elseif camera.direction == class.EAST then
    instanceOffset.x = camera.position.z - instance.position.z
    instanceOffset.z = instance.position.x - camera.position.x
  elseif camera.direction == class.WEST then
    instanceOffset.x = instance.position.z - camera.position.z
    instanceOffset.z = camera.position.x - instance.position.x
  end
  return instanceOffset
end

local function renderSurface(camera, height, surface, instance)
  local offset = getInstanceOffset(camera, instance)
  local scaleA = height * camera.perspective ^ offset.z / camera.frame
  local scaleB = scaleA * camera.perspective
  local vertices = {}
  local rotated = instance:toRotated(surface.side)
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

local function renderSprite(camera, height, sprite, instance)
  local offset = getInstanceOffset(camera, instance)
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

local function renderInstance(camera, canvas, instance)
  if not instanceInView(camera, instance) then return end
  local height = canvas:getPixelHeight()
  love.graphics.push("all")
  love.graphics.setCanvas(canvas)
  love.graphics.origin()
  love.graphics.translate(
    canvas:getPixelHeight() / 2.0,
    canvas:getPixelWidth() / 2.0
  )
  local rotated = instance:fromRotated(camera.direction)
  for _, surface in pairs(instance.block:getSurfaces(rotated)) do
    renderSurface(camera, height, surface, instance)
  end
  local sprite = instance.block:getSprite(rotated)
  if sprite then renderSprite(camera, height, sprite, instance) end
  love.graphics.pop()
end


-- ╭ ---- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Wall | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ---- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.wall = {}

function class.wall.new(side)
  local wall = {}
  wall.side = side
  return wall
end


-- ╭ ------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Surface | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.surface = {}

function class.surface.new(texture, direction, side)
  local surface = {}
  surface.texture = texture
  surface.direction = direction
  surface.side = side
  return surface
end


-- ╭ ------ ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Sprite | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------ ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.sprite = {}

function class.sprite.new(texture, direction, offset)
  local sprite = {}
  sprite.texture = texture
  sprite.direction = direction
  sprite.offset = offset or 0.5
  return sprite
end


-- ╭ ------ ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Camera | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------ ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.camera = {}

function class.camera.new()
  local camera = {}
  camera.position = {x=0, y=0, z=0}
  camera.direction = class.NORTH
  camera.perspective = 0.6
  camera.frame = 0.8
  camera.fog = 1.0
  setmetatable(camera, {__index = class.camera})
  return camera
end


-- ╭ ----- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Block | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ----- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.block = {}

function class.block.new()
  local block = {}
  block._walls = {}
  block._surfaces = {}
  block._sprites = {}
  setmetatable(block, {__index = class.block})
  return block
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


-- ╭ -------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Instance | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ -------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.instance = {}

function class.instance.new(block, position, direction)
  local instance = {}
  instance.block = block
  instance.position = position or {x=0, y=0, z=0}
  instance.direction = direction or class.NORTH
  setmetatable(instance, {__index = class.instance})
  return instance
end

function class.instance:toRotated(direction)
  local newDirection = direction
  if newDirection <= 4 then
    newDirection = (direction + self.direction - 2) % 4 + 1
  end
  return newDirection
end

function class.instance:fromRotated(direction)
  local newDirection = direction
  if newDirection <= 4 then
    newDirection = (direction - self.direction) % 4 + 1
  end
  return newDirection
end


-- ╭ --------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Character | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ --------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.character = {}

function class.character.new(world, block, slotX, slotY, resX, resY, pad)
  local character = {}
  character._world = world
  character._instance = class.instance.new(block)
  character._camera = class.camera.new()
  character._canvas = love.graphics.newCanvas(resX - pad * 2, resY - pad * 2)
  character._position = {x=nil, y=nil, z=nil}
  character._direction = character._camera.direction
  character._slot = {slotX, slotY} -- integer
  local vertices = {
    {resX * (slotX - 1) + pad, resY * (slotY - 1) + pad, 0, 0},
    {resX * (slotX - 1) + pad, resY * slotY - pad, 0, 1},
    {resX * slotX - pad, resY * slotY - pad, 1, 1},
    {resX * slotX - pad, resY * (slotY - 1) + pad, 1, 0},
  }
  character._mesh = love.graphics.newMesh(vertices)
  character._mesh:setTexture(character._canvas)
  character._world:addInstance(character._instance)
  setmetatable(character, {__index = class.character})
  return character
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
  self._instance.direction = direction
end

function class.character:getDirection()
  return self._direction
end

function class.character:rotate(turns)
  self._direction = (self._direction + turns - 1) % 4 + 1
  self._camera.direction = self._direction
  self._instance.direction = self._direction
end

function class.character:setPosition(position)
  self._position = position
  self._camera.position = position
  self._instance.position = position
end

function class.character:getPosition()
  return {x=self._position.x, y=self._position.y, z=self._position.z}
end

function class.character:destroy()
  self._world:removeInstance(self._instance)
end


-- ╭ ----- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | World | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ----- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- +y is DOWN
-- +x is EAST
-- +z is NORTH

class.world = {}

function class.world.new()
  local world = {}
  world._instances = {}
  setmetatable(world, {__index = class.world})
  return world
end

function class.world:addBlock(block, position, direction)
  local instance = class.instance.new(block, position, direction)
  table.insert(self._instances, instance)
end

function class.world:addInstance(instance)
  table.insert(self._instances, instance)
end

function class.world:removeInstance(instance)
  -- WIP
end

function class.world:render(camera, canvas)
  local cam = camera.position
  local instances = {}
  for k, v in pairs(self._instances) do
    instances[k] = v
  end
  table.sort(instances, function(a, b)
    local posA, posB = a.position, b.position
    local aXDiff = math.max(posA.x, cam.x) - math.min(posA.x, cam.x)
    local aYDiff = math.max(posA.y, cam.y) - math.min(posA.y, cam.y)
    local aZDiff = math.max(posA.z, cam.z) - math.min(posA.z, cam.z)
    local bXDiff = math.max(posB.x, cam.x) - math.min(posB.x, cam.x)
    local bYDiff = math.max(posB.y, cam.y) - math.min(posB.y, cam.y)
    local bZDiff = math.max(posB.z, cam.z) - math.min(posB.z, cam.z)
    return aXDiff + aYDiff + aZDiff > bXDiff + bYDiff + bZDiff
  end)
  for i=1,#instances do
    renderInstance(camera, canvas, instances[i])
  end
end

return class
