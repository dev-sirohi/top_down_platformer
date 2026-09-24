-- Import the gameplay state
local Gameplay = require("src.states.gameplay")

-- GameTbl is responsible for managing the overall game
-- main.lua will talk to GameTbl instead of directly managing individual states
local Game = {}

-- Called once when game starts
function Game:load()
    self.currentState = Gameplay
    self.currentState:load()
end

-- Called every frame.
function Game:update(dt)
    -- Forward the update call to whichever state
    -- is currently active.
    if self.currentState then
        self.currentState:update(dt)
    end
end

-- Called every frame to render the game.
function Game:draw()
    -- Forward the draw call to the active state.
    if self.currentState then
        self.currentState:draw()
    end
end

return Game
