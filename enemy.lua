inimigos = {}

local TEMPO_CICLO = 4
local TEMPO_AVISO = 1
local DURACAO_LASER = 0.15
local ALCANCE_LASER = 200
local ESCALA_INIMIGO = 0.09

function inimigosUpdate(dt)
    for _, inimigo in ipairs(inimigos) do

        if inimigo.estado == 'disparando' then
            inimigo.tempoDisparo = inimigo.tempoDisparo - dt
            checarLaserAtingiuPlayer(inimigo)

            if inimigo.tempoDisparo <= 0 then
                inimigo.estado = 'esperando'
                inimigo.timer = 0
            end

        else
            inimigo.timer = inimigo.timer + dt

            if inimigo.timer >= TEMPO_CICLO then
                inimigo.estado = 'disparando'
                inimigo.tempoDisparo = DURACAO_LASER
            elseif inimigo.timer >= TEMPO_CICLO - TEMPO_AVISO then
                inimigo.estado = 'aviso'
            else
                inimigo.estado = 'esperando'
            end
        end

    end
end

function checarLaserAtingiuPlayer(inimigo)
    local x, y = inimigo.collider:getPosition()
    local w = (inimigo.dir.x ~= 0) and ALCANCE_LASER or 4
    local h = (inimigo.dir.y ~= 0) and ALCANCE_LASER or 4
    local cx = x + inimigo.dir.x * ALCANCE_LASER / 2
    local cy = y + inimigo.dir.y * ALCANCE_LASER / 2

    local hits = world:queryRectangleArea(cx - w/2, cy - h/2, w, h, {'player'})
    if #hits > 0 then
        playerTomaDano()
    end
end

local direcoes = {
    cima = {x=0, y=-1},
    baixo = {x=0, y=1},
    esquerda = {x=-1, y=0},
    direita = {x=1, y=0},
}

function spawnInimigo(x, y, direcaoStr)
    local inimigo = {}
    inimigo.collider = world:newRectangleCollider(x, y, 12, 12, {collision_class = 'enemy'})
    inimigo.collider:setType('static') 
    inimigo.timer = 0
    inimigo.estado = 'esperando' 
    inimigo.dir = direcoes[direcaoStr] or direcoes['baixo']
    table.insert(inimigos, inimigo)
end

function inimigosDraw()
    for _, inimigo in ipairs(inimigos) do
        local x, y = inimigo.collider:getPosition()

        local sprite = (inimigo.estado == 'disparando') and sprites.enemyAt or sprites.enemyIdle

        if inimigo.estado == 'aviso' then
            love.graphics.setColor(1, 0.5, 0.5, 1) -- tom avermelhado avisando o disparo chegando
        else
            love.graphics.setColor(1, 1, 1, 1)
        end

        love.graphics.draw(sprite, x, y, 0, ESCALA_INIMIGO, ESCALA_INIMIGO, sprite:getWidth()/2 - 290, sprite:getHeight()/2)
        love.graphics.setColor(1, 1, 1, 1) 

        if inimigo.estado == 'disparando' then
            local w = (inimigo.dir.x ~= 0) and ALCANCE_LASER or 4
            local h = (inimigo.dir.y ~= 0) and ALCANCE_LASER or 4
            local cx = x + inimigo.dir.x * ALCANCE_LASER / 2
            local cy = y + inimigo.dir.y * ALCANCE_LASER / 2

            love.graphics.setColor(1, 0.2, 0.2, 0.9)
            love.graphics.rectangle('fill', cx - w/2, cy - h/2, w, h)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end