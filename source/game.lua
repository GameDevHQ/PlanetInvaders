local game = {}

-- imports
screen = require("screen")
sound = require("sound")
resources = require("resources")

-- game functions
local MAX_LIFE = 5
local lifes
local game_over_text
local score
local scoreText
local scoreCoeff
local speedBump
local text_show_delay = 2000

function game.start_game()
    local text = display.newText("Tap here to start. Protect the planet!", 0, 0, Helvetica, 24)

    text.x = screen.centerX
    text.y = display.contentHeight - 30
    text.alpha = 0
    text:setFillColor(255, 250, 185)

    local function play(event)
        text = nil
        -- remove any text, title, etc from the screen
        display.remove(event.target)
        display.remove(screen.gameTitle)
        display.remove(game_over_text)
        game_over_text = nil

        -- reset score to zero
        display.remove(scoreText)
        scoreText = nil
        score = 0
        scoreText = display.newText("Score: 0", 0, 0, Helvetica, 22)
        scoreText.x = screen.centerX
        scoreText.y = 20

        scoreCoeff = 1
        speedBump = 0

        lifes = {}

        screen.planet.alpha = 1

        for life_index = 1, MAX_LIFE do
            life = display.newImage(resources.images['life'])
            life.x = (display.contentWidth / 2 + 25 * MAX_LIFE / 2 ) - (25 * life_index) + 5
            life.y = display.contentHeight - 25
            life.xScale = 0.25
            life.yScale = 0.25
            life.alpha = 0.75
            table.insert(lifes, life_index, life)
        end

        game.spawn_enemy()
    end
    text:addEventListener('tap', play)

    local function show_text(event)
        text.alpha = 1
    end
    timer.performWithDelay(text_show_delay, show_text)
end

function game.spawn_enemy()
    local battleships = {
        resources.images['beetleship'],
        resources.images['octopus'],
        resources.images['rocketship'],
    }

    local function get_random_battleship()
        -- take from battleships table only one random image
        return battleships[math.random(#battleships)]
    end

    local enemy = display.newImage(get_random_battleship())
    -- generate random (x, y) position
    if math.random(2) == 1 then
        enemy.x = math.random(-100, -10)
    else
        enemy.x = math.random(display.contentWidth + 10, display.contentWidth + 100)
        enemy.xScale = -1
    end
    enemy.y = math.random(display.contentHeight)
    -- set event handlers
    local enemy_lifetime = math.random(2500 - speedBump, 3500 - speedBump)
    enemy.transition = transition.to(enemy, {x=screen.centerX, y=screen.centerY, time=enemy_lifetime, onComplete=game.hit_planet})
    enemy:addEventListener('tap', game.ship_smash)

    speedBump = speedBump + 50
    scoreCoeff = scoreCoeff + 0.05
end

function game.redraw_lifes()
    current_lifes = #lifes
    for life_index = 1, current_lifes do
        lifes[life_index].x = (display.contentWidth / 2 + 25 * current_lifes / 2) - (25 * life_index) + 5
    end
end

function game.lost_one_life()
    life = table.remove(lifes, 1)
    life:removeSelf()
    life = nil

    current_lifes = #lifes
    -- game over, when player lost all lifes
    if current_lifes == 0 then
        game_over_text = display.newText("Game Over", 0, 0, Helvetica, 48)
        game_over_text.x = screen.centerX
        game_over_text.y = screen.centerY
        game_over_text:setFillColor(236, 225, 106)

        screen.planet.alpha = 0
        text_show_delay = 0
        timer.performWithDelay(100, game.start_game)
        sound.play_sound(sound.lose)
    else
        game.redraw_lifes()
        -- make simple animation, when player lost one life point
        local function animate_lost_one_life(obj)
            screen.planet.xScale = 1
            screen.planet.yScale = 1
            screen.planet.alpha = (1.0 / MAX_LIFE) * current_lifes
        end
        transition.to(screen.planet, {time=200, xScale=1.2, yScale=1.2, alpha=1, onComplete=animate_lost_one_life})
    end
end

function game.hit_planet(obj)
    obj:removeSelf()
    obj = nil
    game.lost_one_life()
    sound.play_sound(sound.blast)

    if #lifes > 0 then
        game.spawn_enemy()
    end
end

function game.ship_smash(event)
    display.remove(event.target)
    transition.cancel(event.target.transition)
    sound.play_sound(sound.kill)
    score = score + 25 * scoreCoeff
    scoreText.text = "Score: "..score
    game.spawn_enemy()
end

return game
