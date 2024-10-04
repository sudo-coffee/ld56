local view = {}

-- Scale and center the coordinate system to adjust for different window sizes.
function view.setDimensions(x, y)
  local width, height = love.graphics.getDimensions()
  local scale = math.min(width / x, height / y)
  local offsetX = (width - x * scale) / 2.0
  local offsetY = (height - y * scale) / 2.0
  love.graphics.translate(offsetX, offsetY)
  love.graphics.scale(scale)
end

return view
