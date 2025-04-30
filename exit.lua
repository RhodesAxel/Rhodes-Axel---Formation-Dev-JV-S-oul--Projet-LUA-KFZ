local exitImg = love.graphics.newImage{"img/exit.png"}
local offSetExit = { x = exitImg:getWidth() * .5, y = exitImg:getHeight() * .5}

function ExitDoor(x,y)
local exit = {}
    exit.x = x
    exit.y = y
    exit.radius = exitImg:getWidth() 

    exit.draw = function()
        love.graphics.draw(exitImg, exit.x, exit.y,0,1,1,offSetExit.x, offSetExit.y)
    end
    return exit
end 