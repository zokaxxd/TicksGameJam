playerX = 400
playerY = 400
direc = 1
love.graphics.setDefaultFilter('nearest', 'nearest')

function playerSpawn()

    player = world:newRectangleCollider(playerX, playerY, 8, 8, {collision_class = "player"})
    player:setType('dynamic')
    player:setFriction(0)
    player:setFixedRotation(true)
    --player.animation = animations.idle
    --player.sprite = sprites.idle
    player.speed = 250
    player.grounded = true
    player.angle = 0
    player.pulos = 2
    player.dashing = false
    player.podeDash = true
    player.facing = 1
    player.animAtual = animData.idle
    player.tempoNoChao = 0
    player.flash = false
    player.flashTimer = 0
    player.heart = 3
    player.invencible = 0
end

function playerUpdate(dt)
    if player.body then
        player.invencible = player.invencible - dt

        local dir = mec.getDirection()
        player.angle = math.atan2(dir.y, dir.x) - math.pi / 2
        local forca = 800
        world:setGravity(dir.x * forca, dir.y * forca)

        local checkX = player:getX() + dir.x * 4
        local checkY = player:getY() + dir.y * 4
        local w = (dir.x ~= 0) and 2 or 8
        local h = (dir.y ~= 0) and 2 or 8

        local collider = world:queryRectangleArea(checkX - w/2, checkY - h/2, w, h, {'wall'})
        if #collider > 0 then
            player.grounded = true
            player.pulos = 2
        else
            player.grounded = false
        end

        local vx, vy = player:getLinearVelocity()

        if player:enter('peca') then
            local data = player:getEnterCollisionData('peca')
            local other = data.collider

            for p = #pecas, 1, -1 do
                if pecas[p] == other then
                    other:destroy()
                    table.remove(pecas, p)
                    pecasColetadas = pecasColetadas + 1
                    break
                end
            end
        end
        
        if player:enter('enemy') then
            playerTomaDano()
        end

        if player.heart <= 0 then
            playerMorreu()
            pecasColetadas = 0
            gameState = 'dead'
        end

        if player:enter('danger') then
            playerMorreu()
            pecasColetadas = 0
            gameState = 'dead'
        end

        if player.grounded then
            player.tempoNoChao = 0
        else
            player.tempoNoChao = player.tempoNoChao + dt
        end

        local visualNoAr = player.tempoNoChao > 0.05 

        local novaAnim
        if player.dashing then
            novaAnim = animData.dash
        elseif visualNoAr then
            novaAnim = animData.jump
        elseif vx ~= 0 or vy ~= 0 then
            novaAnim = animData.walk
        else
            novaAnim = animData.idle
        end

        if novaAnim ~= player.animAtual then
            novaAnim.anim:gotoFrame(1)
            player.animAtual = novaAnim
        end

        player.animAtual.anim:update(dt)

        if not player.podeDash then
            player.dashCooldown = player.dashCooldown - dt
            if player.dashCooldown <= 0 then
                player.podeDash = true
            end
        end

        if player.dashing then
            player.dashTempo = player.dashTempo - dt
            if player.dashTempo <= 0 then
                player.dashing = false
            end
        end

        if player:enter('next') then
            pertoDoNext = true
        end
        if player:exit('next') then
            pertoDoNext = false
        end

        if not player.dashing then
            if dir.x ~= 0 then
                if love.keyboard.isDown('w') then
                    vy = -player.speed
                    player.facing = -1
                elseif love.keyboard.isDown('s') then
                    vy = player.speed
                    player.facing = 1
                else
                    vy = 0
                end
            else
                if love.keyboard.isDown('a') then
                    vx = -player.speed
                    player.facing = -1
                elseif love.keyboard.isDown('d') then
                    vx = player.speed
                    player.facing = 1
                else
                    vx = 0
                end
            end
            player:setLinearVelocity(vx, vy)
        end

        if player.flash then
            player.flashTimer = player.flashTimer - dt
            if player.flashTimer <= 0 then
                player.flash = false
            end
        end
    end
end

local ESCALA_PLAYER = 0.5 

local function calcularFlipX()
    local dir = mec.getDirection()

    
    local worldDirX, worldDirY
    if dir.x ~= 0 then
        worldDirX, worldDirY = 0, player.facing
    else
        worldDirX, worldDirY = player.facing, 0
    end

    
    local localX, localY = math.cos(player.angle), math.sin(player.angle)

    
    local produto = worldDirX * localX + worldDirY * localY

    return (produto < 0) and -1 or 1
end

function playerDraw()
    love.graphics.push()
    love.graphics.translate(player:getX(), player:getY())
    love.graphics.rotate(player.angle)

    local shouldDraw = true
    if player.flash then
        shouldDraw = math.floor(player.flashTimer * 8) % 2 == 0
    end


    local sx = calcularFlipX() * ESCALA_PLAYER
    local sy = ESCALA_PLAYER

    local colliderHalf = 4 
    local spriteHalfAltura = player.animAtual.oy * ESCALA_PLAYER
    local AJUSTE_FINO = 3 
    local offsetY = colliderHalf - spriteHalfAltura + AJUSTE_FINO

    player.animAtual.anim:draw(player.animAtual.img, 0, offsetY, 0, sx, sy, player.animAtual.ox, player.animAtual.oy)

    if shouldDraw then 
        player.animAtual.anim:draw(player.animAtual.img, 0, offsetY, 0, sx, sy, player.animAtual.ox, player.animAtual.oy)
    end
    love.graphics.setColor(1, 1, 1)

    love.graphics.pop()
    
end


function playerKeypressed(key)
    if key == 'space' and player.pulos > 0 then
        Pulo(38)
        player.pulos = player.pulos - 1
    end
    
    if key == 'e' and pertoDoNext and pecasColetadas >= pecasNecessarias then
        proximaFase()
    end

    if key == 'lshift' and player.podeDash and not player.dashing then
        iniciarDash()
    end
end

function playerMorreu()
    limparFase()
    loadMap()

    player:setPosition(playerX, playerY)
    player:setLinearVelocity(0, 0)
    player.heart = 3
    player.invencible = 0
    player.flash = false
    player.flashTimer = 0
    player.dashing = false
    player.podeDash = true
    mec.reset()
end

function Pulo(forcaPulo)
    local dir = mec.getDirection()
    local vx, vy = player:getLinearVelocity()

    if dir.x ~= 0 then vx = 0 else vy = 0 end
    player:setLinearVelocity(vx, vy)

    player:applyLinearImpulse(-dir.x * forcaPulo, -dir.y * forcaPulo)
end

local DASH_VELOCIDADE = 500
local DASH_DURACAO = 0.15
local DASH_COOLDOWN = 2

function iniciarDash()
    local dir = mec.getDirection()
    player.dashing = true
    player.dashTempo = DASH_DURACAO
    player.podeDash = false
    player.dashCooldown = DASH_COOLDOWN

    if dir.x ~= 0 then
        player:setLinearVelocity(0, player.facing * DASH_VELOCIDADE)
    else
        player:setLinearVelocity(player.facing * DASH_VELOCIDADE, 0)
    end
end

function playerTomaDano()
    if player.invencible <= 0 then
        player.heart = player.heart - 1
        player.invencible = 2
        player.flash = true
        player.flashTimer = 2
    end
end