    require("helpers")
    
    local survivantImg = love.graphics.newImage("img/survivant.png")
    local offSet ={x = survivantImg:getWidth() * .5, y = survivantImg:getHeight() * .5}
function newSurvivant(x, y, speed, target)

    survivant = {}
        survivant.radius = 30
        survivant.x = x 
        survivant.y = y 
        survivant.angle = 0 
        survivant.speed = speed
        survivant.target = target 
        survivant.health = 100
        survivant.radius = 30
        survivant.isFree = true

    survivant.update = function(dt)
        
        local targetPositionX = survivant.target.getPositionX()
        local targetPositionY = survivant.target.getPositionY()
        local targetRadius = survivant.target.getRadius()

        local dist = distance(survivant.x,survivant.y, targetPositionX,targetPositionY)

        
        if survivant.isFree == false then 
            if circleCollision(survivant.x,survivant.y,survivant.radius,targetPositionX,targetPositionY, targetRadius) then 
                survivant.speed = 0
            else
                survivant.speed = speed
                survivant.chase(dt)
            end
            
        end 
    end 

    survivant.chase = function(dt)
        if not survivant.target then return end 
        local targetPositionX = target.getPositionX()
        local targetPositionY = target.getPositionY()
        local dx = targetPositionX - survivant.x
        local dy = targetPositionY - survivant.y
        survivant.angle = math.atan2(dy,dx)
        survivant.move(dt, survivant.speed)
    end  
    survivant.takeDamage = function(dammage)
        survivant.health =  survivant.health - dammage
        if  survivant.health <= 0 then 
            survivant.health = 0
            survivant.isFree = true
            
        end
    end 
    survivant.move = function(dt, speed)
        local move = true
        if move == true then 
        survivant.x = survivant.x + math.cos(survivant.angle) * speed * dt
        survivant.y = survivant.y + math.sin(survivant.angle) * speed * dt
    else
    end 
    end 
    survivant.draw = function()
        if survivant.isFree == false then 
        love.graphics.draw(survivantImg, survivant.x, survivant.y, survivant.angle, 1,1, offSet.x, offSet.y)
        love.graphics.print(survivant.health,survivant.x, survivant.y- 30)
        else 

        end

    end 
    return survivant
end 