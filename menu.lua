
botaoJogar = {x = 596, y = 422, w = 460, h = 118, texto = 'Jogar'}
menu = {x = 415, y = 674, w = 460, h = 118, texto = 'Menu'}


function drawMenu()
    love.graphics.setFont(fonteBotao)
    if botaoJogar.hover then
        love.graphics.setColor(0.6, 0.35, 0.1, 1)
    else
        love.graphics.setColor(245/255, 117/255, 0/255, 1)
    end
    love.graphics.rectangle('fill', botaoJogar.x, botaoJogar.y, botaoJogar.w, botaoJogar.h)

    love.graphics.setColor(1, 1, 1, 1) -- reset, senão o texto sai colorido também
    love.graphics.printf(botaoJogar.texto, botaoJogar.x, botaoJogar.y + 38, botaoJogar.w, 'center')
    love.graphics.setFont(fonte)
end

function back()
    local w, h = love.graphics.getDimensions()
    local x, y = w / sprites.back:getWidth(), h / sprites.back:getHeight()
    love.graphics.draw(sprites.back, nil, nil, nil, x, y)
end

function dead()
    local w, h = love.graphics.getDimensions()
    local x, y = w / sprites.Dead:getWidth(), h / sprites.Dead:getHeight()
    love.graphics.draw(sprites.Dead, nil, nil, nil, x, y)
end

function deadMenu()
    love.graphics.setFont(fonteBotao)
    if menu.hover then
        love.graphics.setColor(0.6, 0.35, 0.1, 1)
    else
        love.graphics.setColor(245/255, 117/255, 0/255, 1)
    end
    love.graphics.rectangle('fill', menu.x, menu.y, menu.w, menu.h)

    love.graphics.setColor(1, 1, 1, 1) -- reset, senão o texto sai colorido também
    love.graphics.printf(menu.texto, menu.x, menu.y + 38, menu.w, 'center')
    love.graphics.setFont(fonte)
end

function love.mousepressed(x, y, button)
    if gameState == 'menu' and button == 1 then
        local b = botaoJogar
        if x >= b.x and x <= b.x + b.w and y >= b.y and y <= b.y + b.h then
            gameState = 'dialogo'
            dialogoAtual = 1
            fadeAlpha = 1
        end
    end
    if gameState == 'dead' and button == 1 then
        local b = menu
        if x >= b.x and x <= b.x + b.w and y >= b.y and y <= b.y + b.h then
            gameState = 'menu'
            fadeAlpha = 1
        end
    end
end

