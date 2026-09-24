local Input = require("src.input")

local Player = {}

function Player:new(x, y)
    -- Create a new table to represent this player.
    local player = {
        x = x,
        y = y,

        -- Size of our temporary square.
        size = 32,

        -- How many pixels the player moves per second.
        speed = 200
    }

    -- Make the new player use Player's functions.
    setmetatable(player, { __index = self })

    return player
end

function Player:update(dt)
    local horizontal = Input:getHorizontal()
    local vertical = Input:getVertical()

    local moveX = horizontal
    local moveY = vertical

    -- Calculate the length of the movement vector.
    local length = math.sqrt(
        moveX * moveX +
        moveY * moveY
    )

    -- When moving diagonally, both X and Y are 1/-1.
    -- Without normalization, diagonal movement would be
    -- faster than horizontal/vertical movement.
    if length > 0 then
        moveX = moveX / length
        moveY = moveY / length
    end

    -- Move using speed * delta time.
    --
    -- This makes movement frame-rate independent:
    -- 200 pixels per second rather than 200 pixels per frame.
    self.x = self.x + moveX * self.speed * dt
    self.y = self.y + moveY * self.speed * dt
end

function Player:draw()
    love.graphics.rectangle(
        "fill",
        self.x,
        self.y,
        self.size,
        self.size
    )
end

return Player
