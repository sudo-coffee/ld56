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
  local cam, pos = camera.position, instance:getPosition()
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
  local pos, cam = instance:getPosition(), camera.position
  instanceOffset.y = pos.y - cam.y
  if camera.direction == class.NORTH then
    instanceOffset.x = pos.x - cam.x
    instanceOffset.z = pos.z - cam.z
  elseif camera.direction == class.SOUTH then
    instanceOffset.x = cam.x - pos.x
    instanceOffset.z = cam.z - pos.z
  elseif camera.direction == class.EAST then
    instanceOffset.x = cam.z - pos.z
    instanceOffset.z = pos.x - cam.x
  elseif camera.direction == class.WEST then
    instanceOffset.x = pos.z - cam.z
    instanceOffset.z = cam.x - pos.x
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
  for _, surface in pairs(instance:getBlock():getSurfaces(rotated)) do
    renderSurface(camera, height, surface, instance)
  end
  local sprite = instance:getBlock():getSprite(rotated)
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

function class.block:isWall(side)
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
  instance._block = block
  instance._position = {}
  instance._position.x = position and position.x or 0
  instance._position.y = position and position.y or 0
  instance._position.z = position and position.z or 0
  instance._direction = direction or class.NORTH
  instance._layout = nil
  setmetatable(instance, {__index = class.instance})
  return instance
end

function class.instance:setPosition(position)
  self._layout:removeInstance(self)
  self._position.x = position.x
  self._position.y = position.y
  self._position.z = position.z
  self._layout:addInstance(self)
end

function class.instance:getPosition()
  return {x=self._position.x, y=self._position.y, z=self._position.z}
end

function class.instance:getBlock()
  return self._block
end

function class.instance:setDirection(direction)
  self._direction = direction
end

function class.instance:getDirection()
  return self._direction
end

function class.instance:setLayout(layout)
  self._layout = layout
  layout:addInstance(self)
end

function class.instance:toRotated(direction)
  local newDirection = direction
  if newDirection <= 4 then
    newDirection = (direction + self._direction - 2) % 4 + 1
  end
  return newDirection
end

function class.instance:fromRotated(direction)
  local newDirection = direction
  if newDirection <= 4 then
    newDirection = (direction - self._direction) % 4 + 1
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
  self._instance:setDirection(direction)
end

function class.character:getDirection()
  return self._direction
end

function class.character:rotate(turns)
  local direction = (self:getDirection() + turns - 1) % 4 + 1
  self:setDirection(direction)
end

function class.character:setPosition(position)
  self._position = {x=position.x, y=position.y, z=position.z}
  self._camera.position = self._position
  self._instance:setPosition(self._position)
end

function class.character:getPosition()
  return {x=self._position.x, y=self._position.y, z=self._position.z}
end

function class.character:destroy()
  -- self._world:removeInstance(self._instance)
end


-- ╭ ------ ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Layout | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------ ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

class.layout = {}

function class.layout.new()
  local layout = {}
  layout._instances = {}
  setmetatable(layout, {__index = class.layout})
  return layout
end

function class.layout:positionEmpty(position)
  local empty = false
  if not self._instances[position.x]
  or not self._instances[position.x][position.y]
  or not self._instances[position.x][position.y][position.z] then
    empty = true
  end
  return empty
end

function class.layout:removeInstance(instance)
  local pos = instance:getPosition()
  if self:positionEmpty(pos) then return end
  for i=1,#self._instances[pos.x][pos.y][pos.z] do
    if self._instances[pos.x][pos.y][pos.z][i] == instance then
      table.remove(self._instances[pos.x][pos.y][pos.z], i)
    end
  end
  if #self._instances[pos.x][pos.y][pos.z] == 0 then
    table.remove(self._instances[pos.x][pos.y], pos.z)
    if #self._instances[pos.x][pos.y] == 0 then
      table.remove(self._instances[pos.x], pos.y)
      if #self._instances[pos.x] == 0 then
        table.remove(self._instances, pos.x)
      end
    end
  end
end

function class.layout:addInstance(instance)
  local pos = instance:getPosition()
  local instances = self._instances
  instances[pos.x] = instances[pos.x] or {}
  instances[pos.x][pos.y] = instances[pos.x][pos.y] or {}
  instances[pos.x][pos.y][pos.z] = instances[pos.x][pos.y][pos.z] or {}
  table.insert(instances[pos.x][pos.y][pos.z], instance)
end

function class.layout:getInstances(position)
  if self:positionEmpty(position) then return {} end
  local instances = {}
  local pos = position
  for i=1,#self._instances[pos.x][pos.y][pos.z] do
    table.insert(instances, self._instances[pos.x][pos.y][pos.z][i])
  end
  return instances
end

function class.layout:getAllInstances()
  local instances = {}
  for x,_ in pairs(self._instances) do
    for y,_ in pairs(self._instances[x]) do
      for z,_ in pairs(self._instances[x][y]) do
        for i=1,#self._instances[x][y][z] do
          table.insert(instances, self._instances[x][y][z][i])
        end
      end
    end
  end
  return instances
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
  world._layout = class.layout.new()
  setmetatable(world, {__index = class.world})
  return world
end

function class.world:addInstance(instance)
  instance:setLayout(self._layout)
end

function class.world:addBlock(block, position, direction)
  local instance = class.instance.new(block, position, direction)
  local pos = position
  self:addInstance(instance)
end

function class.world:removeInstance(instance)
  -- WIP
end

function class.world:isWall(position, side)
  local instances = self._layout:getInstances(position)
  local isWall = false
  for i=1,#instances do
    local block = instances[i]:getBlock()
    if block:isWall(instances[i]:toRotated(side)) then
      isWall = true
    end
  end
  return isWall
end

function class.world:render(camera, canvas)
  local cam = camera.position
  local instances = self._layout:getAllInstances()
  table.sort(instances, function(a, b)
    local posA, posB = a:getPosition(), b:getPosition()
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
