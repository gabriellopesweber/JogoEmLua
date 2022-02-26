LARGURA_TELA = 320
ALTURA_TELA = 480
MAX_MET = 25
FIM_JOGO = false
VENCEDOR = false
METEOROS_ATINGIDOS = 0
OBJETIVO_METEORO = 100

player = {
    src = "imagens/nave.png",
    largura = 55,
    altura = 63,
    x = LARGURA_TELA / 2 -55/2,
    y = ALTURA_TELA - 63/2 - 40,
    disparo = {}
}

meteoros = {}

function efetuarDisparo()
    disparo_som:play()

    local disparo = {
        x = player.x + 25, -- horizontal 
        y = player.y,
        largura = 16,
        altura = 16
    }
    table.insert(player.disparo, disparo)
end

function moveDisparo()
    for i = #player.disparo, 1, -1 do
        if player.disparo[i].y > 0 then
            player.disparo[i].y = player.disparo[i].y - 1
        else
            table.remove(player.disparo, i)
        end
    end
end

function destroiPlayer()
    destruicao:play()
    player.src = "imagens/explosao_nave.png"
    player.imagem = love.graphics.newImage(player.src)
    player.largura = 67
    player.altura = 77
end


function isColisao(X1, Y1, L1, A1, X2, Y2, L2, A2)
    return X2 < X1 + L1 and
           X1 < X2 + L2 and
           Y1 < Y2 + A2 and
           Y2 < Y1 + A1
end

function trocaMusicaDeFundo()
    musica_ambiente:stop()
    gameover:play()
end

function validaColisaoComAviao()
    for k, meteoro in pairs(meteoros) do
        if isColisao(meteoro.x, meteoro.y, meteoro.largura, meteoro.altura, 
                    player.x, player.y, player.largura, player.altura) then
            trocaMusicaDeFundo()
            destroiPlayer()
            FIM_JOGO = true
        end
    end
end

function validaColisaoComDisparo()
    for i = #player.disparo, 1, -1 do
        for j = #meteoros, 1, -1 do
            if isColisao(player.disparo[i].x, player.disparo[i].y, player.disparo[i].largura, player.disparo[i].altura, 
                        meteoros[j].x, meteoros[j].y, meteoros[j].largura, meteoros[j].altura) then
                METEOROS_ATINGIDOS = METEOROS_ATINGIDOS + 1
                table.remove(player.disparo, i)
                table.remove(meteoros, j)
                break
            end
        end
    end
end

function validaColisoes()
    validaColisaoComAviao()
    validaColisaoComDisparo()
end

function validaObjetivoConcluido()
    if METEOROS_ATINGIDOS >= OBJETIVO_METEORO then
        VENCEDOR = true
        musica_ambiente:stop()
        win_som:play()
        disparo_som:stop()
    end
end

function criaMeteoro()
    meteoro = {
        x = math.random(LARGURA_TELA),
        y = - 100,
        largura = 50,
        altura = 44,
        peso = math.random(3), 
        deslocamento_horizontal = math.random(-1, 1)
    }
    table.insert(meteoros, meteoro)
end

function removeMeteoros()
    for i = #meteoros, 1, -1 do
        if meteoros[i].y > ALTURA_TELA then
            table.remove(meteoros, i)
        end
    end
end

function moveMeteoro()
    for x,meteoro in pairs(meteoros) do
        meteoro.y = meteoro.y + meteoro.peso
        meteoro.x = meteoro.x + meteoro.deslocamento_horizontal
    end
end

function movePlayer()
    -- Teclas para uso do jogo - W S D A
    if love.keyboard.isDown('w') then
        player.y = player.y - 2
    end
    if love.keyboard.isDown('s') then
        player.y = player.y + 2
    end
    if love.keyboard.isDown('d') then
        player.x = player.x + 2
    end
    if love.keyboard.isDown('a') then
        player.x = player.x - 2
    end
end

function love.load()
    love.window.setMode(LARGURA_TELA, ALTURA_TELA, {resizable = false}) -- Largura, Altura, Tabela de dimensao.
    love.window.setTitle("14-BIS <==> Meteoro")

    math.randomseed(os.time())
    
    backgroud = love.graphics.newImage("imagens/background.png")
    player.imagem = love.graphics.newImage(player.src)
    meteorito_img = love.graphics.newImage("imagens/meteoro.png")
    met_icon = love.graphics.newImage("imagens/met_icon.png")
    tiro_img = love.graphics.newImage("imagens/tiro.png")
    game_over_img = love.graphics.newImage("imagens/gameover.png")
    win_img = love.graphics.newImage("imagens/vencedor.png")

    musica_ambiente = love.audio.newSource("audios/ambiente.wav", 'static')
    destruicao = love.audio.newSource("audios/destruicao.wav", 'static')
    gameover = love.audio.newSource("audios/game_over.wav", 'static')
    disparo_som = love.audio.newSource("audios/disparo.wav", 'static')
    win_som = love.audio.newSource("audios/winner.wav", 'static')

    musica_ambiente:setLooping(true)
    musica_ambiente:play()

end

-- Increase the size of the rectangle every frame.
function love.update(dt)
    if not FIM_JOGO and not VENCEDOR then
        if love.keyboard.isDown('w','a','s','d') then
            movePlayer()
        end
        removeMeteoros()
        if #meteoros <= MAX_MET then
            criaMeteoro()
        end
        moveMeteoro()
        moveDisparo()
        validaColisoes()
        validaObjetivoConcluido()
    end
end

function love.keypressed(tecla)
    if tecla == "escape" then
        love.event.quit()
    elseif tecla == "space" then
        if FIM_JOGO == false and VENCEDOR == false then
            efetuarDisparo()
        end
    end
end

-- Draw a coloured rectangle.
function love.draw()
    love.graphics.draw(backgroud, 0, 0)
    love.graphics.draw(player.imagem, player.x, player.y)
    for k,meteoro in pairs(meteoros) do
        love.graphics.draw(meteorito_img, meteoro.x, meteoro.y)
    end
    for k,disparo in pairs(player.disparo) do
        love.graphics.draw(tiro_img, disparo.x, disparo.y)
    end
    if FIM_JOGO then
        love.graphics.draw(game_over_img, LARGURA_TELA/2 - game_over_img:getWidth()/2, ALTURA_TELA/2 - game_over_img:getHeight()/2)
    end
    if VENCEDOR then
        love.graphics.draw(win_img, LARGURA_TELA/2 - win_img:getWidth()/2, ALTURA_TELA/2 - win_img:getHeight()/2)
    end
    love.graphics.draw(met_icon, 0, 0)
    love.graphics.print("Meteoros Restantes " .. OBJETIVO_METEORO - METEOROS_ATINGIDOS, 25, 1)
end