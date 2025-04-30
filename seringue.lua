function tirSeringue(x,y,dx,dy,speed,range, dammage)
    local  seringue = {}
    seringue.startX = x
    seringue.startY = y
    seringue.x = x
    seringue.y = y 
    seringue.dx = dx
    seringue.dy = dy
    seringue.dammage = dammage
    seringue.speed = speed
    seringue.range = range
    seringue.isFree = false 
    seringue.radius = 2

    seringue.update = function(dt)
        seringue.x = seringue.x + dx * speed * dt
        seringue.y = seringue.y + dy * speed * dt

        local dist = distance(seringue.startX, seringue.startY,seringue.x, seringue.y )
        if dist >= seringue.range then 
            seringue.isFree = true
        elseif seringue.x > SCREEN_SIZE.width - 40 or seringue.x < 0 + 40 or seringue.y > SCREEN_SIZE.height - 40 or seringue.y < 0 + 40 then 
            seringue.isFree = true
        end


    end

    seringue.draw = function()
        love.graphics.setColor(0,1,0)
        love.graphics.circle("fill", seringue.x,seringue.y, seringue.radius)
        love.graphics.setColor(1,1,1)
    end 

    return seringue

end