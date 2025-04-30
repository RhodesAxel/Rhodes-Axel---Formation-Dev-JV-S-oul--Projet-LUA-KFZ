 require("tir")
require("bonus")
require("seringue")
require("survivant")

walkImg = love.graphics.newImage("img/perso_marche.png")
tirImg = love.graphics.newImage("img/perso_tir.png")

posX = 0
posY = 0
persoAngle = 0
speed = 180
direction = 0
offSet = {x = walkImg:getWidth() / 2, y = walkImg:getHeight() / 2}
tirActif = false
life = 100


firePoint = {x = 0, y = 0} 
cannonHeight = 0

local perso = {}
    perso.start = {x = SCREEN_SIZE.height - 80, y = SCREEN_SIZE.height - 80 }
    perso.radius = 30
    perso.isFree = false
    perso.bonusActif = nil 
    perso.dammage = 20
    perso.bouclier = 0
    perso.chargeur = perso.chargeur
    perso.chargeurSeringue = 1
    perso.stockMun = 100
    perso.rechargeTimer = 1

    
    perso.update = function(dt)
        if direction ~= 0 then 
            local dx = math.cos(persoAngle) * speed * direction * dt 
            local dy = math.sin(persoAngle) * speed * direction * dt 
            posX = posX + dx
            posY = posY + dy
        end
        if posX > SCREEN_SIZE.width - 70 then 
            posX = SCREEN_SIZE.width - 70
        elseif posX < 70 then 
            posX = 70
        elseif posY > SCREEN_SIZE.height - 70 then 
            posY = SCREEN_SIZE.height - 70
        elseif posY < 70 then 
            posY = 70
        end 

        perso.checkReload(dt)
    end

    perso.move = function(dir)
        direction = dir
    end

    perso.rotate = function(mouseX, mouseY)
        local dx = mouseX - posX
        local dy = mouseY - posY
        persoAngle = math.atan2(dy, dx)
        
        firePoint.x =  math.cos(persoAngle)  * cannonHeight + posX
        firePoint.y =  math.sin(persoAngle) * cannonHeight + posY
    end

    perso.fire = function()
        
        if perso.chargeur > 0 then 
            perso.chargeur = perso.chargeur - 1
            local dx = math.cos(persoAngle)
            local dy = math.sin(persoAngle)
            local tir = tirPerso( firePoint.x, firePoint.y, dx, dy, 300, 200, perso.dammage)
            return tir
        end
        
    end

    perso.fireSeringue = function()
        
        if perso.chargeurSeringue > 0 then 
            perso.chargeurSeringue = perso.chargeurSeringue - 1 
            local dx = math.cos(persoAngle)
            local dy = math.sin(persoAngle)
            local tirSeringue = tirSeringue( firePoint.x, firePoint.y, dx, dy, 300, 200, 100)
            return tirSeringue
        end
        
    end

    perso.checkReload = function(dt)
    
        if perso.chargeur <= 0 then 
            perso.rechargeTimer =  perso.rechargeTimer - dt
        end
        if  perso.rechargeTimer <= 0 and perso.chargeur <= 0 then 
            perso.rechargeTimer =  1
            perso.chargeur = perso.chargeur + 10
            perso.stockMun = perso.stockMun - perso.chargeur
        end
    end

    perso.getPositionX = function()
        return posX
    end 

    perso.getPositionY = function()
        return posY
    end 

    perso.getRadius = function()
        return perso.radius
    end

    perso.takeDamage = function(dammage)
        if survivant.isFree == false and survivant.health > 0 then 
            survivant.takeDamage(5)
        elseif perso.bouclier > 0 then 
            perso.bouclier = perso.bouclier - dammage
        elseif perso.bouclier <= 0 then
            life = life - dammage
            end
        if life <= 0 then 
            life = 0
            currentScene = "Reload"
            end
    end 

    perso.takeBonusAtt = function()
        bonusAtt.actif = true
        if bonusAtt.actif == true then 
            perso.dammage = perso.dammage + 10
            bonusAtt.actif = false
        end
    end 

    perso.takeBonusDef = function()
        bonusDef.actif = true
        if bonusDef.actif == true then 
            perso.bouclier = perso.bouclier + 20
            bonusDef.actif = false
        end
    end 

    perso.takeBonusVie = function()
        bonusVie.actif = true
        if bonusVie.actif == true then 
            life = life + 20
            bonusVie.actif = false
        end
    end 

    perso.init = function(stockMun, chargeur)
        posX = SCREEN_SIZE.width * .5 
        posY = SCREEN_SIZE.height - 80
        persoAngle = 0
        speed = speed
        direction = 0
        offSet = {x = walkImg:getWidth() / 2, y = walkImg:getHeight() / 2}
        tirActif = false
        perso.radius = 20
        firePoint = {x = 0, y = 0} 
        cannonHeight = 30
        perso.isFree = false
        perso.chargeur = chargeur
        perso.stockMun = stockMun
        perso.chargeurSeringue = 1
        if perso.bonusActif == "vie" then 
            perso.takeBonusVie()
        elseif perso.bonusActif == "att" then 
            perso.takeBonusAtt()
        elseif perso.bonusActif == "def" then 
            perso.takeBonusDef()
        end
    end 

    perso.draw = function()
        
        love.graphics.print("Vie : "..tostring(math.floor(life)), SCREEN_SIZE.width - 700, 1)
        if perso.isFree == false then 
            if tirActif == false then 
            love.graphics.draw(walkImg, posX,posY,persoAngle, 1, 1, offSet.x, offSet.y)
            else  
            love.graphics.draw(tirImg, posX,posY,persoAngle, 1, 1, offSet.x, offSet.y)
            end 
        elseif perso.isFree == true then 
        end
        if perso.bouclier > 0 then 
            love.graphics.setColor(0.1,0.1,0.8)
            love.graphics.print(perso.bouclier,posX, posY + 20)
            love.graphics.circle("line",posX,posY, perso.radius)
            love.graphics.setColor(1,1,1,1)
        end     
    end

    return perso 