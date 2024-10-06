local view = require("utils.view")
local class = require("class")
local blocks = require("blocks")
local profile = require("libraries.profile.profile")
local lvl = require("lvl")
local world = nil
local characters = {}
local fallTimer = 1
local started = false
local alive = 16
local music = nil


-- ╭ ------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Helpers | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ ------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function interact(character)
  if not character:isDestroyed() then
    local pos = character:getPosition()
    if world:isTag(pos, "lava") then
      character:destroy()
      alive = alive - 1
    elseif world:isTag(pos, "orb") then
      character:win()
      alive = alive - 1
    end
  end
end

local function rotate(direction, turns)
  return (direction + turns - 1) % 4 + 1
end

local function onFloor(character)
  local isOnFloor = false
  local pos = character:getPosition()
  local testPos = {x=pos.x, y=pos.y+1, z=pos.z}
  if world:isWall(testPos, class.UP)
  or world:isTag(testPos, "character") then
    isOnFloor = true
  end
  return isOnFloor
end

local function fall()
  for i=1,#characters do
    local pos = characters[i]:getPosition()
    if not onFloor(characters[i]) then
      pos.y = pos.y + 1
      characters[i]:setPosition(pos)
    end
  end
end

local function moveForward()
  for i=1,#characters do
    if onFloor(characters[i]) then
      local pos = characters[i]:getPosition()
      local dir = characters[i]:getDirection()
      local testPos, testDir
      if dir == class.NORTH then
        testPos = {x=pos.x, y=pos.y, z=pos.z+1}
      elseif dir == class.SOUTH then
        testPos = {x=pos.x, y=pos.y, z=pos.z-1}
      elseif dir == class.WEST then
        testPos = {x=pos.x-1, y=pos.y, z=pos.z}
      elseif dir == class.EAST then
        testPos = {x=pos.x+1, y=pos.y, z=pos.z}
      end
      if not world:isWall(testPos, rotate(dir, 2))
      and not world:isTag(testPos, "character") then
        pos = testPos
        characters[i]:setPosition(pos)
      end
    end
  end
end

local function moveBack()
  for i=1,#characters do
    if onFloor(characters[i]) then
      local pos = characters[i]:getPosition()
      local dir = characters[i]:getDirection()
      local testPos, testDir
      if dir == class.NORTH then
        testPos = {x=pos.x, y=pos.y, z=pos.z-1}
      elseif dir == class.SOUTH then
        testPos = {x=pos.x, y=pos.y, z=pos.z+1}
      elseif dir == class.WEST then
        testPos = {x=pos.x+1, y=pos.y, z=pos.z}
      elseif dir == class.EAST then
        testPos = {x=pos.x-1, y=pos.y, z=pos.z}
      end
      if not world:isWall(testPos, dir)
      and not world:isTag(testPos, "character") then
        pos = testPos
        characters[i]:setPosition(pos)
      end
    end
  end
end

local function strafeRight()
  for i=1,#characters do
    if onFloor(characters[i]) then
      local pos = characters[i]:getPosition()
      local dir = characters[i]:getDirection()
      local testPos, testDir
      if dir == class.NORTH then
        testPos = {x=pos.x+1, y=pos.y, z=pos.z}
      elseif dir == class.SOUTH then
        testPos = {x=pos.x-1, y=pos.y, z=pos.z}
      elseif dir == class.WEST then
        testPos = {x=pos.x, y=pos.y, z=pos.z+1}
      elseif dir == class.EAST then
        testPos = {x=pos.x, y=pos.y, z=pos.z-1}
      end
      if not world:isWall(testPos, rotate(dir, 3))
      and not world:isTag(testPos, "character")  then
        pos = testPos
        characters[i]:setPosition(pos)
      end
    end
  end
end

local function strafeLeft()
  for i=1,#characters do
    if onFloor(characters[i]) then
      local pos = characters[i]:getPosition()
      local dir = characters[i]:getDirection()
      local testPos, testDir
      if dir == class.NORTH then
        testPos = {x=pos.x-1, y=pos.y, z=pos.z}
      elseif dir == class.SOUTH then
        testPos = {x=pos.x+1, y=pos.y, z=pos.z}
      elseif dir == class.WEST then
        testPos = {x=pos.x, y=pos.y, z=pos.z-1}
      elseif dir == class.EAST then
        testPos = {x=pos.x, y=pos.y, z=pos.z+1}
      end
      if not world:isWall(testPos, rotate(dir, 1))
      and not world:isTag(testPos, "character")  then
        pos = testPos
        characters[i]:setPosition(pos)
      end
    end
  end
end

local function turnRight()
  for i=1,#characters do
    local direction = characters[i]:getDirection()
    characters[i]:setDirection(rotate(direction, 1))
  end
end

local function turnLeft()
  for i=1,#characters do
    local direction = characters[i]:getDirection()
    characters[i]:setDirection(rotate(direction, 3))
  end
end

-- local function worldTest()
--   camera = class.camera.new()
--   worldCanvas = love.graphics.newCanvas(800, 800)
--   world = class.world.new()
--   camera.position = {x=10, y=10, z=10}
--   camera.direction = class.NORTH
--   testBlockRed = blocks.testBlockColor(0.8, 0.2, 0.3, 0.6)
--   testBlockBlue = blocks.testBlockColor(0.2, 0.3, 0.8, 0.6)
--   testSprite = blocks.testSpriteColor(0.4, 0.6, 0.4, 0.8)
--   world:setBlock(11, 10, 10, testBlockRed)
--   world:setBlock(9, 10, 11, testBlockRed)
--   world:setBlock(9, 10, 10, testBlockBlue)
--   world:setBlock(11, 10, 11, testBlockBlue)
--   world:setBlock(10, 10, 11, testSprite)
-- end

local function drawTestFloor()
  local testBlockRed = blocks.testBlockColor(0.8, 0.2, 0.3, 0.6)
  for x=1,15 do
    for z=1,15 do
      world:addBlock(testBlockRed, {x=x, y=20, z=z})
    end
  end
end


-- ╭ --------- ╮ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- | Callbacks | -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ╰ --------- ╯ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function reset()
  lvl.clearWorld()
  world = lvl.getWorld()
  characters = lvl.getCharacters()
  view.setDimensions(800, 800)
  alive = 16
  started = false
end

function love.load()
  reset()
end

function love.draw()
  view.origin()
  for i=1,#characters do
    if alive > 0 or characters[i]:hasWon() then
      local mesh = characters[i]:getMesh()
      love.graphics.draw(mesh)
    end
  end
end

function love.keypressed(key)
  if not music then
    music = love.audio.newSource("assets/ld56_3.mp3", "static")
    music:setLooping(true)
    music:play()
  end
  if not started then
    started = true
    for i=1,#characters do
      characters[i]:render()
    end
    return
  end
  if alive == 0 then
    reset()
    return
  end
  -- profile.start()
  if key == "w" or key == "up" then
    moveForward()
  elseif key == "s" or key == "down" then
    moveBack()
  elseif key == "d" or key == "right" then
    strafeRight()
  elseif key == "a" or key == "left" then
    strafeLeft()
  elseif key == "e" or key == "x" or key == "pagedown" then
    turnRight()
  elseif key == "q" or key == "z" or key == "pageup" then
    turnLeft()
  end
  -- fall()
  for i=1,#characters do
    characters[i]:move()
    interact(characters[i])
  end
  for i=1,#characters do
    characters[i]:render()
  end
  print(alive)
  -- profile.stop()
  -- print(profile.report(10))
end

function love.update()
  if not started then return end
  fallTimer = fallTimer % 4 + 1
  if fallTimer == 1 then
    fall()
    for i=1,#characters do
      characters[i]:move()
      interact(characters[i])
    end
    for i=1,#characters do
      characters[i]:render()
    end
  end
end
