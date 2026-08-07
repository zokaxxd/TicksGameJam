sprites = {
    back = love.graphics.newImage('sprite/fundoMenu.png'),
    geaC = love.graphics.newImage('sprite/gear.png'),
    idle = love.graphics.newImage('sprite/player/idle.png'),
    walk = love.graphics.newImage('sprite/player/walk.png'),
    jump = love.graphics.newImage('sprite/player/jump.png'),
    dash = love.graphics.newImage('sprite/player/dash.png'),
    enemyIdle = love.graphics.newImage('sprite/robo.png'),
    enemyAt = love.graphics.newImage('sprite/roboAt.png'),
    lixe = love.graphics.newImage('sprite/lixeira.png'),
    Dead = love.graphics.newImage('sprite/DeadMenu.png'),

}

local grid  = anim8.newGrid(32, 32, sprites.idle:getWidth(), sprites.idle:getHeight())
local gridW = anim8.newGrid(32, 32, sprites.walk:getWidth(), sprites.walk:getHeight())
local gridJ = anim8.newGrid(32, 48, sprites.jump:getWidth(), sprites.jump:getHeight())
local gridD = anim8.newGrid(48, 32, sprites.dash:getWidth(), sprites.dash:getHeight())


animations = {

    idle = anim8.newAnimation(grid('1-6', 1), 0.3),
    walk = anim8.newAnimation(gridW('1-3', 1), 0.3),
    jump = anim8.newAnimation(gridJ('1-8', 1), 0.3),
    dash = anim8.newAnimation(gridD('1-11', 1), 1),
}

animData = {
    idle = {anim = animations.idle, img = sprites.idle, ox = 16, oy = 16},
    walk = {anim = animations.walk, img = sprites.walk, ox = 16, oy = 16},
    jump = {anim = animations.jump, img = sprites.jump, ox = 16, oy = 24},
    dash = {anim = animations.dash, img = sprites.dash, ox = 24, oy = 16},
}


local ESCALA_PECA = 0.2
local ESCALA_LIXEIRA = 0.1

function pecasDraw()
    for _, p in ipairs(pecas) do
        local x, y = p:getPosition()
        love.graphics.draw(sprites.geaC, x, y, anguloPecas or 0, ESCALA_PECA, ESCALA_PECA, sprites.geaC:getWidth()/2, sprites.geaC:getHeight()/2)
    end
end

function nextDraw()
    for _, n in ipairs(nextTriggers) do
        local x, y = n:getPosition()
        love.graphics.draw(sprites.lixe, x, y, 0, ESCALA_LIXEIRA, ESCALA_LIXEIRA, sprites.lixe:getWidth()/2 - 199, sprites.lixe:getHeight()/2 + 190)
    end
end
