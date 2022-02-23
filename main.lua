LARGURA_TELA = 320
ALTURA_TELA = 480
MAX_MET = 25

player = {
    src = "imagens/nave.png",
    largura = 64,
    altura = 64,
    x = LARGURA_TELA / 2 -64/2,
    y = ALTURA_TELA - 64/2 - 40
}

meteoros = {}

function criaMeteoro()
    meteoro = {
        x = math.random(LARGURA_TELA),
        y = - 100,
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
    math.randomseed(os.time())
    love.window.setMode(LARGURA_TELA, ALTURA_TELA, {resizable = false}) -- Largura, Altura, Tabela de dimensao.
    love.window.setTitle("14-BIS <==> Meteoro")
    backgroud = love.graphics.newImage("imagens/background.png")
    player.imagem = love.graphics.newImage(player.src)
    meteorito_img = love.graphics.newImage("imagens/meteoro.png")
end

-- Increase the size of the rectangle every frame.
function love.update(dt)
    if love.keyboard.isDown('w','a','s','d') then
        movePlayer()
    end
    removeMeteoros()
    if #meteoros <= MAX_MET then
        criaMeteoro()
    end
    moveMeteoro()
end

-- Draw a coloured rectangle.
function love.draw()
    love.graphics.draw(backgroud, 0, 0)
    love.graphics.draw(player.imagem, player.x, player.y)
    for k,meteoro in pairs(meteoros) do
        love.graphics.draw(meteorito_img, meteoro.x, meteoro.y)
    end
end