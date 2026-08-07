mec = {}

local timer = 0
local inter = 7
local atu = 1

local direcoes = {
    {x = 0, y = 1},   -- baixo 
    {x = -1, y = 0},  -- esquerda
    {x = 0, y = -1},  -- cima
    {x = 1, y = 0},   -- direita
}

function mec.update(dt)
    timer = timer + dt

    if timer >= inter then
        timer = timer - inter
        atu = atu + 1
        if atu > #direcoes then
            atu = 1
        end
        print("funcionou", direcoes[atu].x, direcoes[atu].y)
    end
    
end

function mec.getDirection()
    return direcoes[atu]
end
function mec.tempRestante()
    return timer - inter
end

function mec.reset()
    direcaoAtual = direcoes[1]
    timer = 0
    atu = 1
    inter = 7
end