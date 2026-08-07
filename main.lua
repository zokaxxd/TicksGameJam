anim8 = require 'libraries/anim8/anim8'
wf = require 'libraries/windfield/windfield'
sti = require 'libraries/Simple-Tiled-Implementation/sti'
camFile = require 'libraries/message'
require 'player' -- player 
require 'enemy' -- inimigo do jogo
require 'SpritesAnima' -- sprites do game
require 'mecanica' -- mecanica principal da gravidade11
require 'menu' -- auto explicativo, os Draws dos menus e tudo mais esta aki
require 'dialogo' -- dialogo inicial que explica mais ou menos como funciona
require 'fasesSpawn' --loadMap e os spawns das coisas do Tiled

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest') -- melhora os graficos
    fonte = love.graphics.newFont('fonts/tal.ttf', 20)
    fonteBotao = love.graphics.newFont('fonts/tal.ttf', 48)
    love.graphics.setFont(fonte) -- coloca a fonte meio 2d do game
    cam = camFile()
    world = wf.newWorld(0, 800, false) -- cria o mundo
    world:setQueryDebugDrawing(true)
    
    -- adiciona as classes de colisao do game 
    world:addCollisionClass('player')
    world:addCollisionClass('enemy')
    world:addCollisionClass('peca', {ignore = {'player'}})
    world:addCollisionClass('next', {ignore = {'player'}})
    world:addCollisionClass('wall')
    world:addCollisionClass('danger')

    -- status q o game ta e o fade pra trocar
    gameState = 'menu'
    fadeAlpha = 0

    -- algumas coisa do game, como a fase atual, pecas, paredes, spawn do player e o loadMap e tals 
    pertoDoNext = false
    faseAtual = 1
    pecas = {}
    pecasNecessarias = 18
    pecasColetadas = 0
    nextTriggers = {}
    walls = {}
    dangers = {}
    --pecasPosition = {}
    playerSpawn()
    loadMap()

end

local speed = 300 

function love.update(dt)
    if gameState == 'menu' then
        local mx, my = love.mouse.getPosition()
        local b = botaoJogar
        b.hover = mx >= b.x and mx <= b.x + b.w and my >= b.y and my <= b.y + b.h
    end
    if gameState == 'dead' then
        local mx, my = love.mouse.getPosition()
        local b = menu
        b.hover = mx >= b.x and mx <= b.x + b.w and my >= b.y and my <= b.y + b.h
    end

    if gameState == 'dialogo' then
        
    end

    if gameState == 'game' then
        mec.update(dt)
        world:update(dt)
        inimigosUpdate(dt)
        playerUpdate(dt)
        gameMap:update(dt)
        

        local px, py = player:getPosition()
        cam:lookAt(px, py)
        local zoom = 5
        cam:zoomTo(zoom)
    end
    if fadeAlpha > 0 then
        fadeAlpha = fadeAlpha - dt 
    end
end

function love.draw()
    if gameState == 'menu' then
        back()
        drawMenu()
    end

    if gameState == 'dead' then
        dead()
        deadMenu()
    end

    if gameState == 'dialogo' then
        cam:attach()
            playerDraw()
            gameMap:drawLayer(gameMap.layers['layer2'])
        cam:detach()
        drawTextbox()
    end


    if gameState == 'game' then
        cam:attach()
            gameMap:drawLayer(gameMap.layers['layer2'])
            gameMap:drawLayer(gameMap.layers['layer1'])
            inimigosDraw()
            pecasDraw()
            nextDraw()
            playerDraw()
            --world:draw()
        cam:detach()

        love.graphics.print(pecasColetadas .. '/' .. pecasNecessarias .. ' pecas', 10, 10)
        love.graphics.print(player.heart .. ' vidas', 10, 30)

        if pertoDoNext then
            if pecasColetadas >= pecasNecessarias then
                love.graphics.print('Aperte E para consertar', 10, 30)
            else
                love.graphics.print('Faltam pecas...', 10, 30)
            end
        end
    end
    if fadeAlpha > 0 then
        love.graphics.setColor(0, 0, 0, fadeAlpha)
        love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    end
end


function love.keypressed(key)
    if gameState == 'dialogo' then
        avancarDialogo(key)
    elseif gameState == 'game' then
        playerKeypressed(key) 
    end
end

