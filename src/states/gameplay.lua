local Player = require("src.entities.player")
local Tilemap = require("src.tilemap")

local Gameplay = {}

function Gameplay:load()
    print("Gameplay state loaded")
    self.map = Tilemap:new("maps.farm")
    self.player = Player:new(100, 100)
end

function Gameplay:update(dt)
    self.player:update(dt)
end

function Gameplay:draw()
    self.map:draw()
    self.player:draw()

    love.graphics.print(
        "WASD / Arrow Keys",
        20,
        20
    )
end

return Gameplay
