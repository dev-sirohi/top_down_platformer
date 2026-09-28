local Input = require("src.input")
local Assets = require("src.assets")
local Animation = require("src.animation")

local Player = {}

local walkAnimationDirectoryPath = "assets/characters/bearded_guy/animation/walk"

function Player:new(x, y)
    local walkFrames = Assets:loadAnimationFrameSetFromSeparateFiles(walkAnimationDirectoryPath)

    -- Create a new table to represent this player.
    local player = {
        x = x,
        y = y,
        size = 64,
        speed = 200,
        sprite = walkFrames[1],
        walkAnimation = Animation:new(walkFrames, 0.1),
        wasMoving = false
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
    local isMoving = length > 0

    if isMoving then
        moveX = moveX / length
        moveY = moveY / length

        if not self.wasMoving then
            self.walkAnimation:start()
        else
            self.walkAnimation:update(dt)
        end
    else
        -- Stop the animation on the first frame when idle.
        self.walkAnimation:reset()
    end

    -- Move using speed * delta time.
    --
    -- This makes movement frame-rate independent:
    -- 200 pixels per second rather than 200 pixels per frame.
    self.x = self.x + moveX * self.speed * dt
    self.y = self.y + moveY * self.speed * dt

    self.sprite = self.walkAnimation:getCurrentFrame()

    self.wasMoving = isMoving
end

function Player:draw()
    local width = self.sprite:getWidth()
    local height = self.sprite:getHeight()

    local scaleX = self.size / width
    local scaleY = self.size / height

    love.graphics.draw(
        self.sprite,
        self.x,
        self.y,
        0,
        scaleX,
        scaleY
    )
end

function Player:getPosition()
    return self.x, self.y
end

function Player:setPosition(x, y)
    self.x = x
    self.y = y
end

function Player:getBounds()
    return {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height
    }
end

function Player:getInteractionPoint()
    local centerX = self.x + self.size / 2
    local centerY = self.y + self.size / 2

    return centerX, centerY
end

function Player:isMoving()
    local horizontal = Input:getHorizontal()
    local vertical = Input:getVertical()

    return horizontal ~= 0 or vertical ~= 0
end

return Player
