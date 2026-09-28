-- Code written by Codex

local Tilemap = {}


function Tilemap:new(mapPath)
    local success, mapData = pcall(require, mapPath)

    if not success then
        error("Failed to load Tiled map '" .. mapPath .. "': " .. mapData)
    end


    -- Basic map validation.
    if not mapData.width or not mapData.height then
        error("Invalid Tiled map: missing width or height.")
    end

    if not mapData.tilewidth or not mapData.tileheight then
        error("Invalid Tiled map: missing tile dimensions.")
    end

    if not mapData.layers then
        error("Invalid Tiled map: missing layers.")
    end

    if not mapData.tilesets or #mapData.tilesets == 0 then
        error("Invalid Tiled map: missing tilesets.")
    end


    local tilemap = {
        data = mapData,

        width = mapData.width,
        height = mapData.height,

        tileWidth = mapData.tilewidth,
        tileHeight = mapData.tileheight,

        -- We'll load every tileset instead of assuming
        -- that the map has only one.
        tilesets = {},

        -- Keep the Tiled layer order.
        layers = mapData.layers
    }


    --------------------------------------------------
    -- LOAD TILESETS
    --------------------------------------------------

    for tilesetIndex, tilesetData in ipairs(mapData.tilesets) do
        if not tilesetData.image then
            error(
                "Tileset '" ..
                (tilesetData.name or tostring(tilesetIndex)) ..
                "' has no image."
            )
        end


        -- Tiled exported the image path relative to farm.lua.
        --
        -- Example:
        -- "../assets/tiles/Grass.png"
        --
        -- LÖVE paths are relative to the game root, so
        -- remove the "../" part.
        local imagePath = tilesetData.image

        while imagePath:sub(1, 3) == "../" do
            imagePath = imagePath:sub(4)
        end


        local image = love.graphics.newImage(imagePath)

        -- Pixel-art tiles should use nearest-neighbour filtering.
        -- This prevents blurry edges when tiles are drawn.
        image:setFilter("nearest", "nearest")


        local columns = tilesetData.columns

        if not columns then
            columns = math.floor(
                image:getWidth() / tilesetData.tilewidth
            )
        end


        local tileset = {
            data = tilesetData,

            firstgid = tilesetData.firstgid,

            image = image,

            columns = columns,

            tileWidth = tilesetData.tilewidth,
            tileHeight = tilesetData.tileheight,

            spacing = tilesetData.spacing or 0,
            margin = tilesetData.margin or 0,

            -- Quads will be created once here rather than
            -- every frame during drawing.
            quads = {}
        }


        --------------------------------------------------
        -- CREATE QUADS FOR THIS TILESET
        --------------------------------------------------

        local tileCount = tilesetData.tilecount

        if not tileCount then
            tileCount =
                columns *
                math.floor(image:getHeight() / tilesetData.tileheight)
        end


        for tileID = 0, tileCount - 1 do
            local tileColumn = tileID % columns

            local tileRow = math.floor(
                tileID / columns
            )


            local x =
                tileset.margin +
                tileColumn *
                (tileset.tileWidth + tileset.spacing)

            local y =
                tileset.margin +
                tileRow *
                (tileset.tileHeight + tileset.spacing)


            tileset.quads[tileID] = love.graphics.newQuad(
                x,
                y,

                tileset.tileWidth,
                tileset.tileHeight,

                image:getWidth(),
                image:getHeight()
            )
        end


        tilemap.tilesets[tilesetIndex] = tileset
    end


    setmetatable(tilemap, {
        __index = self
    })

    --------------------------------------------------
    -- BUILD RENDER BATCHES
    --------------------------------------------------

    for _, layer in ipairs(tilemap.layers) do
        if layer.type == "tilelayer" then
            tilemap:buildLayerBatch(layer)
        end
    end


    return tilemap
end

--------------------------------------------------
-- FIND WHICH TILESET OWNS A GLOBAL TILE ID
--------------------------------------------------

function Tilemap:getTilesetForGid(gid)
    local selectedTileset = nil
    local selectedIndex = nil


    -- Tiled's firstgid tells us where each tileset's
    -- global tile IDs begin.
    for index, tileset in ipairs(self.tilesets) do
        if gid >= tileset.firstgid then
            selectedTileset = tileset
            selectedIndex = index
        end
    end


    return selectedTileset, selectedIndex
end

--------------------------------------------------
-- BUILD A SPRITEBATCH FOR A TILE LAYER
--------------------------------------------------

function Tilemap:buildLayerBatch(layer)
    -- One layer can use more than one tileset.
    --
    -- Each SpriteBatch can only use one texture,
    -- so we create one batch per tileset.
    layer.batches = {}
    layer.batchOrder = {}


    local maxSprites =
        layer.width *
        layer.height


    for tilesetIndex, tileset in ipairs(self.tilesets) do
        local batch = love.graphics.newSpriteBatch(
            tileset.image,
            maxSprites,
            "static"
        )

        layer.batches[tilesetIndex] = batch

        layer.batchOrder[#layer.batchOrder + 1] = tilesetIndex
    end


    --------------------------------------------------
    -- PUT EVERY TILE INTO THE APPROPRIATE BATCH
    --------------------------------------------------

    for mapY = 0, layer.height - 1 do
        for mapX = 0, layer.width - 1 do
            local index =
                mapY * layer.width +
                mapX +
                1


            local gid = layer.data[index]


            -- GID 0 means this cell contains no tile.
            if gid and gid ~= 0 then
                local tileset, tilesetIndex =
                    self:getTilesetForGid(gid)


                if not tileset then
                    error(
                        "No tileset found for GID " ..
                        gid ..
                        " in layer '" ..
                        layer.name ..
                        "'."
                    )
                end


                local tileID =
                    gid -
                    tileset.firstgid


                local quad =
                    tileset.quads[tileID]


                if not quad then
                    error(
                        "Invalid tile ID " ..
                        tileID ..
                        " in tileset '" ..
                        (tileset.data.name or "unknown") ..
                        "'."
                    )
                end


                -- Convert tile coordinates into world pixels.
                local worldX =
                    mapX * self.tileWidth +
                    (layer.offsetx or 0)

                local worldY =
                    mapY * self.tileHeight +
                    (layer.offsety or 0)


                layer.batches[tilesetIndex]:add(
                    quad,
                    worldX,
                    worldY
                )
            end
        end
    end
end

--------------------------------------------------
-- DRAW THE COMPLETE TILEMAP
--------------------------------------------------

function Tilemap:draw()
    -- Tiled stores layers in their intended draw order.
    --
    -- We therefore draw them in the same order:
    --
    -- Ground
    -- Decorations
    -- etc.
    for _, layer in ipairs(self.layers) do
        if
            layer.type == "tilelayer"
            and layer.visible ~= false
        then
            love.graphics.setColor(
                1,
                1,
                1,
                layer.opacity or 1
            )


            -- Draw every tileset batch belonging
            -- to this layer.
            for _, tilesetIndex in ipairs(layer.batchOrder) do
                love.graphics.draw(
                    layer.batches[tilesetIndex]
                )
            end
        end
    end


    -- Reset the draw color so later things such as
    -- the player and UI aren't accidentally transparent.
    love.graphics.setColor(1, 1, 1, 1)
end

return Tilemap
