local Animation = {}

function Animation:new(frames, frameDuration)
    local animation = {
        frames = frames,
        frameDuration = frameDuration,
        currentFrame = 1,
        timer = 0
    }

    setmetatable(animation, {
        __index = Animation
    })

    return animation
end

function Animation:update(dt)
    self.timer = self.timer + dt

    if self.timer >= self.frameDuration then
        self.timer = self.timer - self.frameDuration

        self.currentFrame = self.currentFrame + 1

        -- Loop back to the first frame.
        if self.currentFrame > #self.frames then
            self.currentFrame = 1
        end
    end
end

function Animation:start()
    self.currentFrame = 1
    self.timer = self.frameDuration
end

function Animation:reset()
    self.currentFrame = 1
    self.timer = 0
end

function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end

return Animation
