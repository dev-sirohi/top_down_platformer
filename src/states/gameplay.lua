local Input = require("src.input")
local Player = require("src.entities.player")

local Gameplay = {}

function Gameplay:load()
    print("Gameplay state loaded")
    self.player = Player:new(100, 100)
end

function Gameplay:update(dt)
    self.player:update(dt)
end

function Gameplay:draw()
    self.player:draw()

    love.graphics.print(
        "WASD / Arrow Keys",
        20,
        20
    )
end

return Gameplay
