-- Input is responsible for reading keyboard input
-- Other parts of the game will ask Input instead of directly checking keyboard each time
local Input = {}

-- Returns the horizontal movement direction
-- -1 = left
-- 0 = no horizontal movement
-- 1 = right
function Input:getHorizontal()
    local direction = 0
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        direction = direction - 1
    end

    -- D and Right Arrow move right.
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        direction = direction + 1
    end

    return direction
end

-- Returns the vertical movement direction.
--
-- -1 = up
--  0 = no vertical movement
--  1 = down
function Input:getVertical()
    local direction = 0

    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        direction = direction - 1
    end

    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        direction = direction + 1
    end

    return direction
end

return Input
