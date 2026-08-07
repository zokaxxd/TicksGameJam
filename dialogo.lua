
falas = {
    'Então cara tive que mandar você para esse trabalho pois você é o nosso melhor CLT e o negocio ta feio',
    'Resumindo a engrenagem que segura nossa gravidade quebrou e ta tudo girando de 7 em 7 segundos, aproveita e se apoia nos canos para não sair voando',
    'Então você vai ter que ir juntando as engrenagens que foram espalhadas pela area e levar até o dispenser que por algum motivo colocaram ele no topo de tudo apoiado em um dos canos',
    'E tome cuidado pois parece que tem alguns espinhos pelo caminho, e alguns robos ficaram quebrados e estão soltando lasers por todos os lados',
    'E tambem arruma isso ai logo, meu cachorro saiu voando pro espaço cara'
}
dialogoAtual = 1

function drawTextbox()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', 50, 400, 700, 150)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(falas[dialogoAtual], 70, 430, 660, 'left')
    love.graphics.printf('(E para continuar)', 70, 520, 675, 'right')
end

function avancarDialogo(key)
    if key == 'e' then
        dialogoAtual = dialogoAtual + 1
        if dialogoAtual > #falas then
            gameState = 'game' 
            fadeAlpha = 1
        end
    end
end