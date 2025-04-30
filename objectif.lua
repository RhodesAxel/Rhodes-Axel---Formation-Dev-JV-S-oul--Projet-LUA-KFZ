
objectifImg = love.graphics.newImage("img/objectif.png")
local offSet = {x = objectifImg:getWidth() * .5, y = objectifImg:getHeight() * .5}

function newObjectif(x,y)
    objectif = {}
    objectif.x = x
    objectif.y = y 
    objectif.inventory = false
    objectif.radius = 25

    objectif.draw = function()
        if objectif.inventory == false then 
            love.graphics.draw(objectifImg, objectif.x,objectif.y,0,1,1, offSet.x, offSet.y)
        else 
        end 
    end 
    return objectif
end 