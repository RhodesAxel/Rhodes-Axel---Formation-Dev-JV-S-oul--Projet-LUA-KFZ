math.randomseed(os.time())
-- Import Module 
require("helpers")
require("zombie")
require("objectif")
require("exit")
require("bonus")
require("survivant")

-- parametre Ecran
SCREEN_SIZE = {width = 1920, height = 1000}
cadre = {}
cadre.width = SCREEN_SIZE.width - 80
cadre.height = SCREEN_SIZE.height - 80
cadre.x = 40
cadre.y = 40

perso = require("perso")
currentScene = "Menu"
local tirSeringue = {}
local tirPerso = {}
local enemies = {}
local objectif = newObjectif(math.random(80,SCREEN_SIZE.width * .5),math.random(80,SCREEN_SIZE.height * .5))
local exit = ExitDoor(perso.start.x,perso.start.y)
local bonusActif = nil
local bonusDef = newBonusDef(SCREEN_SIZE.width * .5 - 150,SCREEN_SIZE.height * .5 + 300,50)
local bonusAtt = newBonusAtt(SCREEN_SIZE.width * .5 ,SCREEN_SIZE.height * .5 + 300,50)
local bonusVie = newBonusVie(SCREEN_SIZE.width * .5 + 150,SCREEN_SIZE.height * .5 + 300,150)
local keyImg = love.graphics.newImage("img/objectifVide.png")
local offSetKeyImg = {x = keyImg:getWidth() * .5, y = keyImg:getHeight() * .5}
local point = 0
local time = 0
local alertTime = false
local niveau = 0
local survivantSauver = 0


function love.load()
    love.window.setMode(1920, 1000)
end

function love.update(dt)
    if currentScene == "Game" then 
        gameScene(dt)
    end 
end
---------------------------------------------Gestion de la scène Game ---------------------------------------------------------------------
function gameScene(dt)
    local dir = GetInPuts()
    if perso.isFree == false then 
        perso.move(dir)
        perso.update(dt)
        perso.rotate(love.mouse.getPosition())
    else
    end
    for _, v in ipairs(tirPerso) do 
        v.update(dt)
    end
    for _, seringue in ipairs(tirSeringue) do 
        seringue.update(dt)
    end

    for _, z in ipairs(enemies) do 
        z.update(dt)
    end
    if survivant.isFree == false then 
        survivant.update(dt)
    end 
    ifCollision()

    for n = #enemies, 1, -1 do 
        if enemies[n].isFree then 
            table.remove(enemies, n)
            point = point + 10
        end 
    end 

    for n = #tirPerso, 1, -1 do 
        if tirPerso[n].isFree then 
            table.remove(tirPerso, n)
        end 
    end 
    for n = #tirSeringue, 1, -1 do 
        if tirSeringue[n].isFree then 
            table.remove(tirSeringue, n)
        end 
    end 

    if #tirPerso  > 0 then 
        tirActif = true
    elseif #tirPerso  <= 0 then 
        tirActif = false
    end
    time = time - dt
    if time <= 10 then 
        alertTime = true 
    end
    if time <= 0 then 
        currentScene = "Reload"
    end 

end 

function GetInPuts()
    local direction = 0
    if love.keyboard.isDown("z") then 
        direction = 1
    elseif love.keyboard.isDown("s") then 
        direction = -1
    end  
    return direction
end 

function ifCollision()
    for _,tir in ipairs(tirPerso) do 
        for _,z in ipairs(enemies) do
            if circleCollision(z.x,z.y,z.radius,tir.x,tir.y, tir.radius) then 
                tir.isFree = true
                z.takeDamage(tir.dammage)
            end
        end
    end
    for _,seringue in ipairs(tirSeringue) do 
        for _,z in ipairs(enemies) do
            if circleCollision(z.x,z.y,z.radius,seringue.x,seringue.y, seringue.radius) then 
                z.x = z.getPosX()
                z.y = z.getPosY()
                seringue.isFree = true
                z.takeDamage(seringue.dammage)
                survivant = newSurvivant(z.x ,z.y,180,perso)
                survivant.isFree = false

            end
        end
    end
    
    if circleCollision(objectif.x,objectif.y,objectif.radius,posX,posY, perso.radius) then 
        objectif.inventory = true
    end
    if circleCollision(exit.x,exit.y,exit.radius,posX,posY, perso.radius) and objectif.inventory == true  then 
        currentScene = "Win"
    end
    if circleCollision(exit.x,exit.y,exit.radius,posX,posY, perso.radius) and objectif.inventory == true and survivant.isFree == false then 
        point = point + 100
        survivantSauver = survivantSauver + 1
        survivant.isFree = true
        currentScene = "Win"
    end
    if circleCollision(exit.x,exit.y,exit.radius,posX,posY, perso.radius) and objectif.inventory == true and niveau == 3 then 
        currentScene = "WinFinal"
    end
    if circleCollision(exit.x,exit.y,exit.radius,posX,posY, perso.radius) and objectif.inventory == true and survivant.isFree == false and niveau == 3 then 
        point = point + 100
        survivantSauver = survivantSauver + 1
        survivant.isFree = true
        currentScene = "WinFinal"
    end
    
end 
---------------------------------------------Gestion de l'affichage ---------------------------------------------------------------------
function love.draw()
    if currentScene == "Menu" then 
        love.graphics.setBackgroundColor(0,0,0)
        love.graphics.print("Menu Principal",SCREEN_SIZE.width * .5 - 50, SCREEN_SIZE.height * .5)
        love.graphics.print("Appuyer sur ESPACE pour lancer le jeux",SCREEN_SIZE.width * .5 - 120 , SCREEN_SIZE.height - 100)

-- Affichage du Jeu 
    elseif currentScene == "Game" then 
        love.graphics.setBackgroundColor(0,0,0)
        perso.draw()
        love.graphics.rectangle("line",cadre.x,cadre.y,cadre.width, cadre.height)
        for _, balle in ipairs(tirPerso) do 
            balle.draw()
        end
        for _, seringue in ipairs(tirSeringue) do 
            seringue.draw()
        end
        for _, z in ipairs(enemies) do 
            z.draw()
            
        end
        if objectif.inventory == false then 
            objectif.draw()
            love.graphics.draw(keyImg,200,15,0,1,1,offSetKeyImg.x,offSetKeyImg.y)
        else 
            love.graphics.draw(objectifImg,200,15,0,1,1,offSetKeyImg.x,offSetKeyImg.y)
            exit.draw()
        end
        if alertTime == true then 
            love.graphics.setColor(0.6,0.2,0.2)
            love.graphics.print("Il reste - de "..tostring(math.floor(time)).." secondes",SCREEN_SIZE.width * .5,SCREEN_SIZE.height - 40,0,1.5)
            love.graphics.setColor(1,1,1)
        end 
        if survivant.isFree == false then 
            survivant.draw()
        end 
    
        love.graphics.print(point, SCREEN_SIZE.width - 150, 0)
        love.graphics.print("Zombie : "..#enemies,SCREEN_SIZE.width - 900)
        love.graphics.print(tostring(math.floor(time)), SCREEN_SIZE.width - 250, 1)
        love.graphics.print("Level : "..niveau,SCREEN_SIZE.width - 350, 1)
        love.graphics.print("Munition : "..perso.chargeur.."/"..perso.stockMun,SCREEN_SIZE.width - 500, 1)
        love.graphics.print("Seringue : "..perso.chargeurSeringue,SCREEN_SIZE.width - 600, 1)

--Affichage du menu Recommencer
    elseif currentScene == "Reload" then
        love.graphics.setBackgroundColor(0.3,0.1,0.1)
        love.graphics.print("Recommencer",SCREEN_SIZE.width * .5, SCREEN_SIZE.height * .5)
        love.graphics.print("Appuyer sur g pour recommencer ou sur a pour revenir au Menu", SCREEN_SIZE.width * .5, SCREEN_SIZE.height * .5 +150, 0,1)
--Affiche du menu Victoire 
    elseif currentScene == "Win" then 
        love.graphics.setBackgroundColor(0.1,0.4,0.1)
        love.graphics.print("Victoire ! ",SCREEN_SIZE.width * .5, SCREEN_SIZE.height * .5)
        love.graphics.print("Vous avez gagné "..point.." Point",SCREEN_SIZE.width * .5 , SCREEN_SIZE.height * .5 + 50)
        love.graphics.print("Appuyer sur ESPACE pour continuer",SCREEN_SIZE.width * .5 - 120 , SCREEN_SIZE.height - 100)
        bonusDef.draw()
        bonusAtt.draw()
        bonusVie.draw()
    elseif currentScene == "WinFinal"  then 
        love.graphics.setBackgroundColor(0.1,0.4,0.1)
        love.graphics.print("Victoire ! ",SCREEN_SIZE.width * .5, SCREEN_SIZE.height * .5)
        love.graphics.print("Vous avez gagné "..point.." Point",SCREEN_SIZE.width * .5 , SCREEN_SIZE.height * .5 + 50)
        love.graphics.print("Vous avez sauvé "..survivantSauver.." survivant",SCREEN_SIZE.width * .5 , SCREEN_SIZE.height * .5 + 150)
        love.graphics.print("Appuyer sur ESPACE pour continuer",SCREEN_SIZE.width * .5 - 120 , SCREEN_SIZE.height - 100)
-- Affichage Menu Pause 
    elseif currentScene == "pause" then 
        love.graphics.setBackgroundColor(0.5,0.5,0.5,0.2)
        perso.draw()
        love.graphics.rectangle("line",cadre.x,cadre.y,cadre.width, cadre.height)
        for _, v in ipairs(tirPerso) do 
            v.draw()
        end
        for _, i in ipairs(enemies) do 
            i.draw()
        end
        if objectif.inventory == false then 
            objectif.draw()
            love.graphics.draw(keyImg,200,15,0,1,1,offSetKeyImg.x,offSetKeyImg.y)
        else 
            love.graphics.draw(objectifImg,200,15,0,1,1,offSetKeyImg.x,offSetKeyImg.y)
            exit.draw()
        end
        love.graphics.print(point, SCREEN_SIZE.width - 150, 0)
        love.graphics.print(#enemies,700)
        love.graphics.print(tostring(math.floor(time)), SCREEN_SIZE.width - 250, 1)
        love.graphics.print("PAUSE", SCREEN_SIZE.width * .5, SCREEN_SIZE.height * .5, 0,5)
        love.graphics.print("Appuyer sur g pour continuer ou sur a pour revenir au Menu", SCREEN_SIZE.width * .5, SCREEN_SIZE.height * .5 +150, 0,1)
-- Page d'explication du jeu
    elseif currentScene == "Explication" then 
        love.graphics.print("Clique Gauche pour tirer  ",SCREEN_SIZE.width * .5, SCREEN_SIZE.height * .5)
        love.graphics.print("Clique droit pour tirer une seringue et transformer un zombie en survivant. 1 seringue par niveau  ",SCREEN_SIZE.width * .5, SCREEN_SIZE.height * .5 + 20)
        love.graphics.print("z pour avancer ",SCREEN_SIZE.width * .5, SCREEN_SIZE.height * .5 + 40)
        love.graphics.print("s pour reculer ",SCREEN_SIZE.width * .5, SCREEN_SIZE.height * .5 + 60)
        love.graphics.print("la souris pour se diriger ",SCREEN_SIZE.width * .5, SCREEN_SIZE.height * .5 + 80)
        love.graphics.print("Trouver la clefs pour fair apparaitre la porte et passé le niveau suivant ",SCREEN_SIZE.width * .5, SCREEN_SIZE.height * .5 + 100)
        love.graphics.print("Tuer un zombie rapporte 10 point, un survivant rapporte 100 point ",SCREEN_SIZE.width * .5, SCREEN_SIZE.height * .5 + 120)
        love.graphics.print("Appuyer sur ESPACE POUR LANCER LE JEU",SCREEN_SIZE.width * .5 , SCREEN_SIZE.height - 140)
    end 
        
    
end
---------------------------------------------Gestion des touches---------------------------------------------------------------------
function love.keypressed(key, scancode)
    
    ------------------------NAVIGATION DES MENUS BASIQUES-------------------------------------------------------------
    if key == "space" and currentScene == "Menu" and niveau == 0 then 
        currentScene = "Explication"
    elseif key == "space" and currentScene == "Explication" then 
        levelOne()
    elseif key == "g" and currentScene == "Game" then 
        currentScene = "pause"
    elseif key == "g" and currentScene == "pause" then 
        currentScene = "Game"
    elseif key == "a" and currentScene == "pause" then 
        currentScene = "Menu"
        niveau = 0
    elseif key == "g" and currentScene == "Reload" and niveau == 1 then 
        levelOne()
        life = 100
    elseif key == "g" and currentScene == "Reload" and niveau == 2 then 
        levelTwo()
        life = 100
    elseif key == "g" and currentScene == "Reload" and niveau == 3 then 
        levelThree()
        life = 100
    elseif key == "a" and currentScene == "Reload" then 
        currentScene = "Menu"
        niveau = 0
    end
    ------------------------Gestion du niveau 2  -------------------------------------------------------------
    if key == "space" and currentScene == "Win" and niveau == 1  then 
        levelTwo()
    end
    if key == "c" and currentScene == "Win" and niveau == 1 and point >= 150 then 
        perso.bonusActif = "vie"
        point = point - 150
        levelTwo()
    elseif key == "x" and currentScene == "Win" and niveau == 1 and point >= 50 then 
        perso.bonusActif = "att"
        point = point - 50
        levelTwo()
    elseif key == "w" and currentScene == "Win" and niveau == 1 and point >= 50 then 
        perso.bonusActif = "def"
        point = point - 50
        levelTwo()
    end
        ------------------------GESTION du NIveau 3 -------------------------------------------------------------
    if key == "g" and currentScene == "Win" and niveau == 2  then 
        levelThree()
    end
    if key == "c" and currentScene == "Win" and niveau == 2 and point >= 150 then 
        perso.bonusActif = "vie"
        point = point - 150
        levelThree()
    elseif key == "x" and currentScene == "Win" and niveau == 2 and point >= 50 then 
        perso.bonusActif = "att"
        point = point - 50
        levelThree()
    elseif key == "w" and currentScene == "Win" and niveau == 2 and point >= 50 then 
        perso.bonusActif = "def"
        point = point - 50
        levelThree()
    end

    if key == "space" and currentScene == "WinFinal"  then 
        niveau = 0 
        survivantSauver = 0
        currentScene = "Menu"
    end
end     

function love.mousepressed(x, y, button) 
    if currentScene == "Game" then 
        if button == 1 then 
            local tir = perso.fire()
            table.insert(tirPerso, tir)
        end 
        if button == 2 then 
            local seringue= perso.fireSeringue()
            table.insert(tirSeringue, seringue)
        end 
    end 
end
---------------------------------------------Paramétrage des Niveaux---------------------------------------------------------------------
function levelOne()
    currentScene = "Game"
    niveau = 1
    perso.init(100,10) 
    for z = #enemies, #enemies, -1 do 
        table.remove(enemies, z)
    end 
    for z = #enemies,9,1 do
        table.insert(enemies,newZombie(math.random(80,SCREEN_SIZE.width * .5),math.random(80,SCREEN_SIZE.height * .5),math.random(100,160), perso))
    end
    local tirPerso = {}
    local tirSeringue = {}
    objectif = newObjectif(math.random(90,SCREEN_SIZE.width * .5),math.random(90,SCREEN_SIZE.height * .5))
    survivant = newSurvivant(posX ,posY ,180,perso)
    exit = ExitDoor(perso.start.x,perso.start.y)
    point = 0
    time = 60
    life = 100 
    perso.bouclier = 0
    alertTime = false
end 

function levelTwo()
    currentScene = "Game"
    niveau = 2
    perso.init(150,15) 
    survivant = newSurvivant(posX ,posY ,180,perso)
    for z = #enemies, #enemies, -1 do 
        table.remove(enemies, z)
    end 
    for z = #enemies,14,1 do
        table.insert(enemies,newZombie(math.random(80,SCREEN_SIZE.width * .5),math.random(80,SCREEN_SIZE.height * .5),math.random(130,180), perso))
    end 
    tirPerso = {}
    objectif = newObjectif(math.random(90,SCREEN_SIZE.width * .5),math.random(90,SCREEN_SIZE.height * .5))
    exit = ExitDoor(perso.start.x,perso.start.y)
    time = 45
    
end 

function levelThree()
    currentScene = "Game"
    niveau = 3
    perso.init(150,15) 
    survivant = newSurvivant(posX ,posY ,180,perso)
    for z = #enemies, #enemies, -1 do 
        table.remove(enemies, z)
    end 
    for z = #enemies,19,1 do
        table.insert(enemies,newZombie(math.random(80,SCREEN_SIZE.width * .5),math.random(80,SCREEN_SIZE.height * .5),math.random(150,190), perso))
    end
    
    tirPerso = {}
    objectif = newObjectif(math.random(90,SCREEN_SIZE.width * .5),math.random(90,SCREEN_SIZE.height * .5))
    exit = ExitDoor(perso.start.x,perso.start.y)
    time = 30

end 
