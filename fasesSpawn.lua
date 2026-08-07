function spawnWalls(x, y, w, h)
    local wall = world:newRectangleCollider(x, y, w, h, {collision_class = 'wall'})
    wall:setType('static')
    table.insert(walls, wall)
end

function spawnPecas(x, y)
    local peca = world:newRectangleCollider(x, y, 8, 8, {collision_class = 'peca'})
    peca:setType('static')
    table.insert(pecas, peca)
end

function spawnNext(x, y, w, h)
    local n = world:newRectangleCollider(x, y, w, h, {collision_class = 'next'})
    n:setType('static')
    table.insert(nextTriggers, n)
end

function spawnDanger(x, y, w, h)
    local d = world:newRectangleCollider(x, y, w, h, {collision_class = 'danger'})
    d:setType('static')
    table.insert(dangers, d)
end

function loadMap()
    gameMap = sti('maps/fase' .. faseAtual .. '.lua')

    for i, obj in pairs(gameMap.layers['spawn'].objects) do
        playerX = obj.x
        playerY = obj.y
    end
    player:setPosition(playerX, playerY)
    
    for i, obj in pairs(gameMap.layers['wall'].objects) do
        spawnWalls(obj.x, obj.y, obj.width, obj.height)
    end

    for i, obj in pairs(gameMap.layers['pecas'].objects) do
        spawnPecas(obj.x, obj.y)
    end

    for i, obj in pairs(gameMap.layers['next'].objects) do
        spawnNext(obj.x, obj.y, obj.width, obj.height)
    end

    for i, obj in pairs(gameMap.layers['enemy'].objects) do
        local dirStr = obj.properties and obj.properties.direcao or 'baixo'
        print('inimigo direcao:', dirStr) 
        spawnInimigo(obj.x, obj.y, dirStr)
    end

    for i, obj in pairs(gameMap.layers['danger'].objects) do
        spawnDanger(obj.x, obj.y, obj.width, obj.height)
    end
end

function limparFase()
    for _, w in ipairs(walls) do w:destroy() end
    walls = {}

    for _, p in ipairs(pecas) do p:destroy() end
    pecas = {}

    for _, n in ipairs(nextTriggers) do n:destroy() end
    nextTriggers = {}

    for _, i in ipairs(inimigos) do i.collider:destroy() end
    inimigos = {}

    for _, d in ipairs(dangers) do d:destroy() end 
    dangers = {}
end

function proximaFase()
    limparFase()
    pecasColetadas = 0
    faseAtual = faseAtual + 1
    pertoDoNext = false
    loadMap()
end