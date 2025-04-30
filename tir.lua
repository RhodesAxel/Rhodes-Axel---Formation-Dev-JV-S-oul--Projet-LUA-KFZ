

function tirPerso(x,y,dx,dy,speed,range, dammage)
    local  ballePerso = {}
    ballePerso.startX = x
    ballePerso.startY = y
    ballePerso.x = x
    ballePerso.y = y 
    ballePerso.dx = dx
    ballePerso.dy = dy
    ballePerso.dammage = dammage
    ballePerso.speed = speed
    ballePerso.range = range
    ballePerso.isFree = false 
    ballePerso.radius = 2

    


    ballePerso.update = function(dt)
        ballePerso.x = ballePerso.x + dx * speed * dt
        ballePerso.y = ballePerso.y + dy * speed * dt

        local dist = distance(ballePerso.startX, ballePerso.startY,ballePerso.x, ballePerso.y )
        if dist >= ballePerso.range then 
            ballePerso.isFree = true
        elseif ballePerso.x > SCREEN_SIZE.width - 40 or ballePerso.x < 0 + 40 or ballePerso.y > SCREEN_SIZE.height - 40 or ballePerso.y < 0 + 40 then 
            ballePerso.isFree = true
        end


    end

    ballePerso.draw = function()
        love.graphics.circle("fill", ballePerso.x,ballePerso.y, ballePerso.radius)
    end 

    return ballePerso

end