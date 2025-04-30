local bonusAttImg = love.graphics.newImage("img/attaque.png")
local bonusDefImg = love.graphics.newImage("img/bouclier.png")
local bonusVieImg = love.graphics.newImage("img/vie.png")

function newBonusDef(x,y,prix) 
    bonusDef = {}
    bonusDef.x = x
    bonusDef.y = y
    bonusDef.prix = prix
    bonusDef.actif = false
    bonusDef.offSet = {x = bonusDefImg:getWidth() * .5, y = bonusDefImg:getHeight() * .5}

    bonusDef.draw = function()
        love.graphics.draw(bonusDefImg, bonusDef.x, bonusDef.y,0,1,1, bonusDef.offSet.x, bonusDef.offSet.y)
        love.graphics.print("+ 20 de bouclier",bonusDef.x -40,bonusDef.y - 35)
        love.graphics.print(bonusDef.prix,bonusDef.x - 8,bonusDef.y + 20)
        love.graphics.print("Appuyer sur w",bonusDef.x - 8,bonusDef.y + 30)
    end 
    return bonusDef
end 

function newBonusAtt(x,y,prix) 
    bonusAtt = {}
    bonusAtt.x = x
    bonusAtt.y = y
    bonusAtt.prix = prix
    bonusAtt.actif = false
    bonusAtt.offSet = {x = bonusAttImg:getWidth() * .5, y = bonusAttImg:getHeight() * .5}

    bonusAtt.draw = function()
        love.graphics.draw(bonusAttImg, bonusAtt.x, bonusAtt.y,0,1,1, bonusAtt.offSet.x, bonusAtt.offSet.y)
        love.graphics.print("+ 10 de dégats",bonusAtt.x -40,bonusAtt.y - 35)
        love.graphics.print(bonusAtt.prix,bonusAtt.x - 8,bonusAtt.y + 20)
        love.graphics.print("Appuyer sur x",bonusAtt.x - 8,bonusAtt.y + 30)
    end 
    return bonusAtt
end 

function newBonusVie(x,y,prix) 
    bonusVie = {}
    bonusVie.x = x
    bonusVie.y = y
    bonusVie.prix = prix
    bonusVie.actif = false
    bonusVie.offSet = {x = bonusVieImg:getWidth() * .5, y = bonusVieImg:getHeight() * .5}

    bonusVie.draw = function()
        love.graphics.draw(bonusVieImg, bonusVie.x, bonusVie.y,0,1,1, bonusVie.offSet.x, bonusVie.offSet.y)
        love.graphics.print("+ 20 point de vie",bonusVie.x -40,bonusVie.y - 35)
        love.graphics.print(bonusVie.prix,bonusVie.x - 8,bonusVie.y + 20)
        love.graphics.print("Appuyer sur c",bonusVie.x - 8,bonusVie.y + 30)
    end 
    return bonusVie
end 

