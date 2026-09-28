local Assets = {}

function Assets:loadImage(path)
    if not love.filesystem.getInfo(path) then
        error("Missing image asset: " .. path)
    end

    return love.graphics.newImage(path)
end

function Assets:loadAnimationFrameSetFromSeparateFiles(folderPath)
    if not love.filesystem.getInfo(folderPath, "directory") then
        error("Missing animation folder: " .. folderPath)
    end

    local files = love.filesystem.getDirectoryItems(folderPath)

    table.sort(files, function(a, b)
        local numberA = tonumber(a:match("(%d+)%.png$")) or math.huge
        local numberB = tonumber(b:match("(%d+)%.png$")) or math.huge

        return numberA < numberB
    end)

    local frames = {}

    for _, fileName in ipairs(files) do
        -- Only load PNG files.
        if fileName:lower():match("%.png$") then
            local path = folderPath .. "/" .. fileName

            frames[#frames + 1] = self:loadImage(path)
        end
    end


    if #frames == 0 then
        error("No PNG frames found in: " .. folderPath)
    end

    return frames
end

function Assets:loadAnimationTileSet()
end

return Assets
