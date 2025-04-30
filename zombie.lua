    local zombieImg = love.graphics.newImage("img/zombie.png")
    local offSet ={x = zombieImg:getWidth() * .5, y = zombieImg:getHeight() * .5}
    
function newZombie(x, y, speed, target)

    local zombie = {}
        zombie.x = x
        zombie.y = y
        zombie.angle = 0 
        zombie.speed = speed
        zombie.patrolSpeed = zombie.speed * 0.5
        zombie.target = target 
        zombie.visionRange = math.random(200,300)
        zombie.health = 100
        zombie.patrolTimer = math.random(1,3)
        zombie.etat = "patrol"
        zombie.radius = 30
        zombie.isFree = false
        zombie.timerAttack = 0.4

    zombie.update = function(dt)
        
        local targetPositionX = zombie.target.getPositionX()
        local targetPositionY = zombie.target.getPositionY()

        local dist = distance(zombie.x,zombie.y, targetPositionX,targetPositionY)
        local distSurvivant = distance(zombie.x,zombie.y, targetPositionX,targetPositionY)
        
        if zombie.etat == "chase" then 
            zombie.chase(dt)
            if dist < zombie.radius + zombie.target.radius then 
                zombie.etat = "attack"
            elseif dist > zombie.visionRange then 
                zombie.etat = "patrol"
            end
        elseif zombie.etat == "attack" then 
            zombie.attack(dt)
            if dist > zombie.radius + zombie.target.radius then 
                zombie.etat = "chase"
            end
        elseif zombie.etat == "patrol" then 
            zombie.patrol(dt)
            if dist < zombie.visionRange then 
                zombie.etat = "chase"
            end
        end 
    end 
    zombie.patrol = function(dt)
        zombie.patrolTimer = zombie.patrolTimer - dt
        if zombie.x > SCREEN_SIZE.width - 80  or zombie.x < 80 or zombie.y > SCREEN_SIZE.height - 80 or zombie.y < 80 then 
            zombie.angle =  zombie.angle + math.pi
            zombie.patrolTimer = math.random(1,3) 
        elseif zombie.patrolTimer <= 0 then 
            zombie.angle =  math.random(0, math.pi * 2) 
            zombie.patrolTimer = math.random(1,3)
        end
        zombie.move(dt, zombie.patrolSpeed)
    end 

    zombie.chase = function(dt)
        if not zombie.target then return end 
        local targetPositionX = target.getPositionX()
        local targetPositionY = target.getPositionY()
        local dx = targetPositionX - zombie.x
        local dy = targetPositionY - zombie.y
        zombie.angle = math.atan2(dy,dx)
        zombie.move(dt, zombie.speed)
    end  

    zombie.attack = function(dt) 
        
        zombie.timerAttack = zombie.timerAttack - dt
        if  zombie.timerAttack <= 0 then 
            zombie.target.takeDamage(5)
            zombie.timerAttack = 0.4
        end
    end 

    zombie.move = function(dt, speed)
        zombie.x = zombie.x + math.cos(zombie.angle) * speed * dt
        zombie.y = zombie.y + math.sin(zombie.angle) * speed * dt
    end 

    zombie.takeDamage = function(dammage)
        zombie.health =  zombie.health - dammage
        if  zombie.health <= 0 then 
            zombie.health = 0
            zombie.isFree = true
        end
    end 
    zombie.getPosX = function()
        return zombie.x
    end
    zombie.getPosY = function()
        return zombie.y
    end
    zombie.draw = function()
        if zombie.isFree == false then 
        love.graphics.draw(zombieImg, zombie.x, zombie.y, zombie.angle, 1,1, offSet.x, offSet.y)
        love.graphics.print(zombie.health,zombie.x, zombie.y- 30)
        else 

        end

    end 
    return zombie
end 